{-# LANGUAGE OverloadedStrings #-}
module Web.Stripe.Balance
    ( -- * API
      getBalance
    , getBalanceTransaction
    , getBalanceTransactionHistory
      -- * Types
    , Balance       (..)
    , TransactionId (..)
    , StripeList    (..)
    , Limit
    , BalanceTransaction
    ) where

import           Web.Stripe.Client.Internal (Method (GET), Stripe,
                                             StripeRequest (..), callAPI,
                                             getParams, toText, (</>))
import           Web.Stripe.Types           (Balance(..), BalanceTransaction,
                                             EndingBefore, Limit, StartingAfter,
                                             StripeList(..), TransactionId (..))

------------------------------------------------------------------------------
-- | Retrieve the current 'Balance' for your Stripe account
getBalance :: Stripe Balance
getBalance = callAPI request
  where request = StripeRequest GET url params
        url     = "balance"
        params  = []

------------------------------------------------------------------------------
-- | Retrieve a 'BalanceTransaction' by 'TransactionId'
getBalanceTransaction
    :: TransactionId
    -> Stripe BalanceTransaction
getBalanceTransaction
    (TransactionId transactionid) = callAPI request
  where request = StripeRequest GET url params
        url     = "balance" </> "history" </> transactionid
        params  = []

------------------------------------------------------------------------------
-- | Retrieve the history of 'BalanceTransaction's
getBalanceTransactionHistory
    :: Limit                       -- ^ Defaults to 10 if `Nothing` specified
    -> StartingAfter TransactionId -- ^ Paginate starting after the following `TransactionId`
    -> EndingBefore TransactionId  -- ^ Paginate ending before the following `TransactionId`
    -> Stripe (StripeList BalanceTransaction)
getBalanceTransactionHistory
    limit
    startingAfter
    endingBefore = callAPI request
  where request = StripeRequest GET url params
        url     = "balance" </> "history"
        params  = getParams [
             ("limit", toText `fmap` limit )
           , ("starting_after", (\(TransactionId x) -> x) `fmap` startingAfter)
           , ("ending_before", (\(TransactionId x) -> x) `fmap` endingBefore)
           ]
