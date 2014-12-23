﻿using System.ComponentModel;

namespace XpandTestExecutor.Module {
    public interface IModelOptionsTestExecutor
    {
        [Category("TestExecutor")]
        [DefaultValue(5)]
        int ExecutionRetries { get; set; }     
    }
}
