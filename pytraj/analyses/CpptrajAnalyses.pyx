# distutils: language = c++
from cython.operator cimport dereference as deref
from pytraj.cpptraj_dict cimport RetTypeAna, OKANALYSIS, ERRANALYSIS
from pytraj.externals.six import PY3
from pytraj.decorators import makesureABC
from pytraj.externals.six import string_types

cdef extern from "Analysis.h":
    ctypedef enum RetType "Analysis::RetType":
        OKANALYSIS "Analysis::OK"
        ERRANALYSIS "Analysis::ERR"

cdef class Analysis:
    """
    Original cpptraj doc:
    ====================
        The abstract base class that all other actions inherit. 
        By convention actions have 3 main phases: init, Setup, and DoAnalysis.
        Init is used to initialize the action, make sure that all arguments
        for the action are correct, and add any DataSets/DataFiles which will
        be used by the action. Setup will set up the action for a specific
        Topology file. DoAnalysis will perform the action on a given frame.
        A fourth function, Print, is for any additional calculations or output 
        the action may require once all frames are processed.

    pytraj doc:
    =============
    Add new action: add to pytraj/actions/ folder 
                    then update action in pytraj/actions/allactions
                    (TODO : allactions.py might be changed)
    """
    def __cinit__(self):
        # don't directly create instance of this ABC class.
        pass
        #self.baseptr = new _Analysis()

    def __dealloc__(self):
        # should I del pointer here or in subclass? 
        #del self.baseptr
        pass

    def __call__(self, *args, **kwd):
        return self._master(*args, **kwd)

    @makesureABC("Analysis")
    def read_input(self, command='', 
                   top=TopologyList(),
                   DatasetList dslist=DatasetList(), 
                   DataFileList dflist=DataFileList()):
        """
        Parameters
        ----------
        command : str
            Type of actions, mask, ... (Get help: Analysis_Clustering().help())
        top : Topology or TopologyList instance, default=TopologyList()
        dslist : DatasetList instance, default=DatasetList()
        dflist : DataFileList instance, default=DataFileList()
        debug : int, default=0
            debug option from cpptraj. (Do we need this?)
        """
        cdef ArgList arglist
        cdef TopologyList toplist
        cdef debug = 0
        cdef RetType STATUS

        if isinstance(top, Topology) or isinstance(top, string_types):
            toplist = TopologyList()
            toplist.add_parm(top)
        elif isinstance(top, TopologyList):
            toplist = <TopologyList> top
        else:
            raise ValueError('Topology must not be empty')

        if isinstance(command, string_types):
            arglist = ArgList(command)
        elif isinstance(command, ArgList):
            arglist = <ArgList> command
        else:
            raise ValueError()

        STATUS = self.baseptr.Setup(arglist.thisptr[0], 
                       dslist.thisptr, 
                       toplist.thisptr,
                       dflist.thisptr,
                       debug)
        if STATUS == ERRANALYSIS:
            raise ValueError()
        else:
            return STATUS

    @makesureABC("Analysis")
    def do_analysis(self):
        """
        Parameters: None
        """
        self.baseptr.Analyze()

    def _master(self, *args, **kwd):
        self.read_input(*args, **kwd)
        return self.do_analysis()


cdef class Analysis_AmdBias (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_AmdBias()
        self.thisptr = <_Analysis_AmdBias*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_AutoCorr (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_AutoCorr()
        self.thisptr = <_Analysis_AutoCorr*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_Average (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_Average()
        self.thisptr = <_Analysis_Average*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_Clustering (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_Clustering()
        self.thisptr = <_Analysis_Clustering*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_Corr (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_Corr()
        self.thisptr = <_Analysis_Corr*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_CrankShaft (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_CrankShaft()
        self.thisptr = <_Analysis_CrankShaft*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_CrdFluct (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_CrdFluct()
        self.thisptr = <_Analysis_CrdFluct*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_CrossCorr (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_CrossCorr()
        self.thisptr = <_Analysis_CrossCorr*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_Divergence (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_Divergence()
        self.thisptr = <_Analysis_Divergence*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_FFT (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_FFT()
        self.thisptr = <_Analysis_FFT*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_Hist (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_Hist()
        self.thisptr = <_Analysis_Hist*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_IRED (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_IRED()
        self.thisptr = <_Analysis_IRED*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_Integrate (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_Integrate()
        self.thisptr = <_Analysis_Integrate*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_KDE (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_KDE()
        self.thisptr = <_Analysis_KDE*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_Lifetime (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_Lifetime()
        self.thisptr = <_Analysis_Lifetime*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()

cdef class Analysis_Matrix (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_Matrix()
        self.thisptr = <_Analysis_Matrix*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_MeltCurve (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_MeltCurve()
        self.thisptr = <_Analysis_MeltCurve*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_Modes (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_Modes()
        self.thisptr = <_Analysis_Modes*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_MultiHist (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_MultiHist()
        self.thisptr = <_Analysis_MultiHist*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_Overlap (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_Overlap()
        self.thisptr = <_Analysis_Overlap*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_Regression (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_Regression()
        self.thisptr = <_Analysis_Regression*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_RemLog (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_RemLog()
        self.thisptr = <_Analysis_RemLog*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_Rms2d (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_Rms2d()
        self.thisptr = <_Analysis_Rms2d*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        with nogil:
            func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_RmsAvgCorr (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_RmsAvgCorr()
        self.thisptr = <_Analysis_RmsAvgCorr*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_RunningAvg (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_RunningAvg()
        self.thisptr = <_Analysis_RunningAvg*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_Spline (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_Spline()
        self.thisptr = <_Analysis_Spline*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_Statistics (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_Statistics()
        self.thisptr = <_Analysis_Statistics*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_Timecorr (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_Timecorr()
        self.thisptr = <_Analysis_Timecorr*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()


cdef class Analysis_VectorMath (Analysis):
    def __cinit__(self):
        self.baseptr = <_Analysis*> new _Analysis_VectorMath()
        self.thisptr = <_Analysis_VectorMath*> self.baseptr

    def __dealloc__(self):
        if self.baseptr is not NULL:
            del self.baseptr

    def alloc(self):
        """return a function-pointer object to be used with AnalysisList class
        """
        cdef FunctPtr func = FunctPtr()
        func.ptr = &(self.thisptr.Alloc)
        return func
        
    def help(self):
        self.thisptr.Help()