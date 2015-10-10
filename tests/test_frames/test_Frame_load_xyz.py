from __future__ import print_function
import unittest
import numpy as np
import pytraj as pt
from pytraj import Frame
from pytraj.utils import assert_almost_equal, Timer
from pytraj.utils import has_


class Test(unittest.TestCase):
    def test_xyz(self):
        traj = pt.iterload("./data/md1_prod.Tc5b.x", "./data/Tc5b.top")
        frame = Frame()
        frame.append_xyz(traj[0].xyz)
        assert_almost_equal(frame.coords, traj[0].coords)
        assert_almost_equal(frame.xyz.flatten(), traj[0].xyz.flatten())
        assert_almost_equal(np.array(frame.buffer1d), traj[0].xyz.flatten())

if __name__ == "__main__":
    unittest.main()
