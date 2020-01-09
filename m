Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD9AF135D80
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2020 17:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732900AbgAIQEw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jan 2020 11:04:52 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:39946 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732810AbgAIQEv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jan 2020 11:04:51 -0500
Received: by mail-wr1-f50.google.com with SMTP id c14so7956504wrn.7
        for <io-uring@vger.kernel.org>; Thu, 09 Jan 2020 08:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xxSmYcGTLwfdzABE06ZqYMAM2cjZHI5cZ3DQAF/kjg0=;
        b=REyaJsc5vEhk/hy97q5TXG80f5KQtcXOWzKV8V+NvvBjGaQ1JsS3B+NtqB+RWkK3SE
         gyjYO+g3u6GogNKTeWq9Uf6ga9+2Ks+Yi+kruEpe3M2ABOF7PwDnmURCOLfibkMdOoj3
         esOJofO8hs0khm9FQqJeIfMERN36TVtsKXweXRVRYIZHBPQKqdkyDzFUMsFYxPAPBHGQ
         nToPDQIVF2goACR4wdKPqGjYnZVaTWU3oFfbmVAAPSlqibxHcvSNI90cBgn+mJ75G76n
         CXvO1j+WAwWe9/DbNX9SIzetICu5mYVjj9bBJyQtRiCRBclxi9bamJXBpymBZbQ2a2PM
         Xweg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xxSmYcGTLwfdzABE06ZqYMAM2cjZHI5cZ3DQAF/kjg0=;
        b=DR6JV3aazpnFpCnBgIJqodA6AbJHphuvGba8sUghbnLrdMqZkV9jqkzlCm6AFVefCC
         llOs5wXjF8bTPzGz+Zf3B/mzLH4zlhdRnRhivSj0CBNA7xC9KpxUDnTwcx2bMGN6vdJz
         3lCBppzoSWeKnHshmp4qAC5KN3rsHUXFdZvntl6MN6vTMs0Xxl2oVc2q98RoFXGcbpGC
         YpXAlaCaxrO2BDn4n9wr1LxZ2Y9FBoXvFKeIkGUUbRrCgIrZnDmJDRWNbHu3V0elwG4J
         C+Zaa70xX7eX+ib0TK5ruRKbBVaVelgx13GetGzpRO1/iNxifFpMFz6ErjFuA+mlsffA
         zaFA==
X-Gm-Message-State: APjAAAUWLBP+rsAJPu2MA+Wndf9p1S+5Jwq4A8Tm3SNJrdKOGGwTPbHs
        3s/mPAJ7CMMLHrJQCKgzue1Zl3SMq6o=
X-Google-Smtp-Source: APXvYqxETlu53HEqkYWmlco0egKf32BRlQkzNxmUXihl0E1MZdGTJFQdfxTT1zkei0fc4YF68CEz3Q==
X-Received: by 2002:a5d:538e:: with SMTP id d14mr11952663wrv.358.1578585890298;
        Thu, 09 Jan 2020 08:04:50 -0800 (PST)
Received: from localhost ([185.85.220.193])
        by smtp.gmail.com with ESMTPSA id r5sm8437016wrt.43.2020.01.09.08.04.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jan 2020 08:04:45 -0800 (PST)
Date:   Thu, 9 Jan 2020 17:04:49 +0100
From:   Dmitry Dolgov <9erthalion6@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Subject: Re: [RFC] Check if file_data is initialized
Message-ID: <20200109160449.jmhetf3p6f2lkp3d@localhost>
References: <20200109131750.30468-1-9erthalion6@gmail.com>
 <e6cd2afe-565f-8cde-652c-26c52b888962@gmail.com>
 <07aeb2b5-b459-746b-30a2-b63550b288df@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07aeb2b5-b459-746b-30a2-b63550b288df@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> On Thu, Jan 09, 2020 at 07:51:28AM -0700, Jens Axboe wrote:
> On 1/9/20 7:26 AM, Pavel Begunkov wrote:
> > On 1/9/2020 4:17 PM, Dmitrii Dolgov wrote:
> >> With combination of --fixedbufs and an old version of fio I've managed
> >> to get a strange situation, when doing io_iopoll_complete NULL pointer
> >> dereference on file_data was caused in io_free_req_many. Interesting
> >> enough, the very same configuration doesn't fail on a newest version of
> >> fio (the old one is fc220349e4514, the new one is 2198a6b5a9f4), but I
> >> guess it still makes sense to have this check if it's possible to craft
> >> such request to io_uring.
> >
> > I didn't looked up why it could become NULL in the first place, but the
> > problem is probably deeper.
> >
> > 1. I don't see why it puts @rb->to_free @file_data->refs, even though
> > there could be non-fixed reqs. It needs to count REQ_F_FIXED_FILE reqs
> > and put only as much.
>
> Agree on the fixed file refs, there's a bug there where it assumes they
> are all still fixed. See below - Dmitrii, use this patch for testing
> instead of the other one!

Yes, the patch from this email also fixes the issue.
