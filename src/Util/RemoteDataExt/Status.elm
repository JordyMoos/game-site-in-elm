module Util.RemoteDataExt.Status exposing (Status(..), asStatus, isFailed, isSuccess)

import RemoteData exposing (RemoteData)

type Status
    = Failed
    | Success
    | Other


asStatus : RemoteData e a -> Status
asStatus remoteData =
    if RemoteData.isFailure remoteData then
        Failed
    else if RemoteData.isSuccess remoteData then
        Success
    else
        Other


isFailed : Status -> Bool
isFailed =
    (==) Failed

isSuccess : Status -> Bool
isSuccess =
    (==) Success
