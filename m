Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435DB394BD1
	for <lists+io-uring@lfdr.de>; Sat, 29 May 2021 13:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhE2LE7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 May 2021 07:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhE2LE7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 May 2021 07:04:59 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA6DC061574;
        Sat, 29 May 2021 04:03:22 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id q5so5753076wrs.4;
        Sat, 29 May 2021 04:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8hrWgEWGLESgRyLhrq1kkN9qRLSKJH0aHYooCga+EvM=;
        b=FABmk0NO0U/9T42PPCAEXPKSV65ksYxTkJG3Y618vdYr/JSDavQKQ8Bd9olM2VsxYW
         WLduO+QnE+m1VjMkOkAzBzY2H+AUz547aja+sFzgHLRg/rFvT1gmuYWlVyi4QxIYAndh
         oR9TTXNTvEFJZrnvoEVNWofPiBA16ZUqErJUHQ7qmKLvtWw5q2UWgtrvgdDcqiyzby0q
         4JBpvA5WiBSSuMUoCJeJ10F8IM/2lMpIc++SojcbvJc3Nqg63r1sBTJAGRyso+Tb7CKf
         qI/qR414wSOeIPBNLikC5oqZf55in1QWHOljtiRMwR3FLSeUgKHC1u+mErsAsJa2y1Pn
         NETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8hrWgEWGLESgRyLhrq1kkN9qRLSKJH0aHYooCga+EvM=;
        b=GVMvsHbmEJdM+Ssc2+d4zzLtR9thTe9BeKWvHMPAtOHHRx2aD9X0wmziQXC0+Ywg50
         2cCbjYmcxLr+tem9/6GqlU3qrUXcn/CzARo5dffiawV6LGN3eIHshSBUVHNs9YVCwrLz
         BhjrGRhFtMzeBd19U5NaWB9IsqpSi1Bd7v2t0PWNhLqXfI5Aq5QH5tY8lTTQm/g3vui+
         sxUfN8afsHHRiEmRSVlSGTZdx5kOxioFUG/3kV2MTln76YqjUJWZmnSvsCHtaaQWGNgY
         PgIMnZle0OmpFhOa1qyeJlzAw3sgfp8m2ZXDFi1X0QvNsAQNMcTWOHc14uK4FAuW1Bdq
         ET3w==
X-Gm-Message-State: AOAM5309f/isdtzRB10/JQjZvC98BGVDJnfLeIgJNvFXk1jksTFhftFu
        AmX6OLjv0YRAiCf7Q+uBLY3yMDFSRaM=
X-Google-Smtp-Source: ABdhPJwkwTgaw8M4PrxMoiO+bK0lAyQcv+nob2zc3EkNAmWsf4kVe5ls5LIOMNx99uGV64XvHfPY0Q==
X-Received: by 2002:adf:fc11:: with SMTP id i17mr8514948wrr.374.1622286201214;
        Sat, 29 May 2021 04:03:21 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.19])
        by smtp.gmail.com with ESMTPSA id x7sm272599wre.8.2021.05.29.04.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 May 2021 04:03:20 -0700 (PDT)
Subject: Re: Memory uninitialized after "io_uring: keep table of pointers to
 ubufs"
To:     Andres Freund <andres@anarazel.de>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210529003350.m3bqhb3rnug7yby7@alap3.anarazel.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <d2c5b250-5a0f-5de5-061f-38257216389d@gmail.com>
Date:   Sat, 29 May 2021 12:03:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210529003350.m3bqhb3rnug7yby7@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/29/21 1:33 AM, Andres Freund wrote:
> Hi,
> 
> I started to see buffer registration randomly failing with ENOMEM on
> 5.13. Registering buffer or two often succeeds, but more than that
> rarely. Running the same program as root succeeds - but the user has a high
> rlimit.
> 
> The issue is that io_sqe_buffer_register() doesn't initialize
> imu. io_buffer_account_pin() does imu->acct_pages++, before calling
> io_account_mem(ctx, imu->acct_pages);
> 
> Which means that a random amount of memory is being accounted for. On the first
> few allocations this sometimes fails to fail because the memory is zero, but
> after a bit of reuse...

Makes sense, thanks for digging in. I've just sent a patch, would
be great if you can test it or send your own.


> It only doesn't fail as root because the rlimit doesn't apply.
> 
> This is caused by
> 
> commit 41edf1a5ec967bf4bddedb83c48e02dfea8315b4
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   2021-04-25 14:32:23 +0100
> 
>     io_uring: keep table of pointers to ubufs
> 
> Greetings,
> 
> Andres Freund
> 

-- 
Pavel Begunkov
