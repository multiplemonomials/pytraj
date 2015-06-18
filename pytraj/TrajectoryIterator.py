"""This is a thin wrapper of Trajin_Single
We need to sub-class Trajin_Single to use Trajectory
(we called Trajin_Single from Trajectory, so we can not call Trajectory back from 
Trajin_Single)
"""
from __future__ import absolute_import
from pytraj.trajs.TrajectoryCpptraj import TrajectoryCpptraj
from pytraj._action_in_traj import ActionTrajectory
from pytraj.action_dict import ActionDict
from pytraj.Frame import Frame
from pytraj.AtomMask import AtomMask
from pytraj.externals.six import string_types
from pytraj.exceptions import PytrajMemviewError
from pytraj._shared_methods import _tolist


def _make_frame_slices(n_files, original_frame_slice):
    if isinstance(original_frame_slice, tuple):
        return [original_frame_slice for i in range(n_files)]
    elif isinstance(original_frame_slice, list):
        fs_len = len(original_frame_slice)
        if fs_len < n_files:
            old_list = original_frame_slice[:] + [original_frame_slice[-1]
                                                 for _ in range(fs_len, n_files)]

class TrajectoryIterator(TrajectoryCpptraj, ActionTrajectory):
    def __init__(self, *args, **kwd):
        super(TrajectoryIterator, self).__init__(*args, **kwd)

    def load(self, filename=None, top=None, frame_slice=(0, -1, 1)):
        """load trajectory/trajectories from filename/filenames with 
        a single frame_slice or a list of frame_slice
        """
        if isinstance(filename, string_types):
            super(TrajectoryIterator, self).load(filename, top, frame_slice)

        elif isinstance(filename, (list, tuple)):
            filename_list = filename
            full_frame_slice = _make_frame_slices(len(filename_list), frame_slice)
            for fname, fslice in enumerate(filename_list, full_frame_slice):
                super(TrajectoryIterator, self).load(fname, frame_slice=fslice)
        elif filename is None:
            # empty constructor
            pass
        else:
            raise ValueError("filename must a a string or a list of strings")

    @property
    def topology(self):
        """traditional name for Topology file"""
        return self.top

    @topology.setter
    def topology(self, newtop):
        self.top = newtop

    def iterator_slice(self, start=0, stop=None, stride=None):
        """iterator slice"""
        from itertools import islice
        if stop is None:
            stop = self.n_frames
        return islice(self, start, stop, stride)

    def make_independent_iterators(self, n_iters):
        from itertools import tee
        return tee(self, n_iters)

    def frame_iter(self, start=0, stop=-1, stride=1, mask=None, autoimage=False, rmsfit=None):
        """frame iterator

        Parameters
        ----------
        start : int, default=0
        stop : int, default=-1 (last frame)
        stride : int, deault=1 (no skipping)
        mask : str | array of integers | AtomMask object, default=None
            get sub-frame with coords of given mask
        autoimage : bool, default=False
            perform `autoimage`
        rmsfit : None | tuple/list of (Frame, mask)
            perform `rmsfit` reference if not `None`
            Notes : reference must have the same n_atoms
        """
        if autoimage:
            act = ActionDict()['autoimage']
        if rmsfit is not None:
            ref, mask_for_rmsfit = rmsfit
            need_align = True
            from pytraj.actions.CpptrajActions import Action_Rmsd
        else:
            need_align = False
            ref, mask_for_rmsfit = None, None

        for frame in super(TrajectoryIterator, self).frame_iter(start, stop, stride):
            if autoimage:
                act(current_frame=frame, top=self.top)
            if need_align:
                act = Action_Rmsd()
                # trick cpptraj to fit to 1st frame (=ref)
                act(mask_for_rmsfit, [ref, frame], top=self.top)
            if mask is not None:
                if isinstance(mask, string_types):
                    atm = self.top(mask)
                else:
                    try:
                        atm = AtomMask()
                        atm.add_selected_indices(mask)
                    except TypeError:
                        raise PytrajMemviewError()
                frame2 = Frame(atm.n_atoms)
                frame2.set_coords(frame, atm)
                yield frame2
            else:
                yield frame

    def chunk_iter(self, chunk=2, start=0, stop=-1, 
                   autoimage=False, 
                   rmsfit=None,
                   copy_top=False):
        """
        Parameters
        ----------
        chunk : int, default=2
            size of each chunk. Notes: final chunk's size might be changed
        start : int, default=0 (first frame)
        stop : int, default=-1 (last frame)
        autoimage : bool, default=False
        rmsfit : None | tuple/list of (reference frame, mask)

        Examples
        --------
            for chunk in trajiter.chunk_iter(100, autoimage=True, rmsfit=(ref0, '@CA'))
        """

        if rmsfit is not None:
            ref, mask_for_rmsfit = rmsfit
            need_align = True
        else:
            need_align = False
            ref, mask_for_rmsfit = None, None

        for chunk in super(TrajectoryIterator, self).chunk_iter(chunk, start, stop, copy_top):
            # always perform autoimage before doing fitting
            # chunk is `Trajectory` object, having very fast `autoimage` and `rmsfit` methods
            if autoimage:
                chunk.autoimage()
            if need_align:
                chunk.rmsfit(ref, mask_for_rmsfit)
            yield chunk

    @property
    def filename(self):
        '''return 1st filename in filelist. For testing only
        '''
        return self.filelist[0]

    @property
    def shape(self):
        return (self.n_frames, self.n_atoms, 3)

    def is_empty(self):
        return self.n_frames == 0

    @property
    def max_frames(self):
        return self.n_frames

    def tolist(self):
        return _tolist(self)

    def to_mutable_trajectory(self):
        return self[:]
