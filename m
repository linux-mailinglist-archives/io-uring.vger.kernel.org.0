Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FC62173F6
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 18:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgGGQaT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 12:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgGGQaT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 12:30:19 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2772CC061755
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 09:30:19 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k23so43760627iom.10
        for <io-uring@vger.kernel.org>; Tue, 07 Jul 2020 09:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/Aq0Ja+CqKvF9lrmPxJRGMfwxHS2vwzIPhLC/x5x1b0=;
        b=GwlP2Q8U9Em+Z0ze9l9Pi/ruyR5vUMeM/vN8wh4T1NLqFUvbU3xuqu8JMBuvIBcg1C
         jTY2xDANxAyFOfXDWvh7S87cFWkJYa3C6/YmeBVRl3QeDq7eMVXRpYMiOpkR6RIUE5wN
         /plwB8F6ckleltIzXzp7RERylmRQNZnue7p4Qo0aagWb1AObG9jVQld+b7pNF1UQrf2s
         TxLmi1/mnZ9Sj5XsPvHTvuCKv1yZUAtpGkzKD0OME1jyRJb7nIQWX9glxAAix/GzPqRt
         63cDkFMKP8A7MeoZzqkXHHGgKSmOw4mR5ruK5XC4knEfq6Wqw2rY2dltNOywLMEVbMkB
         +EoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/Aq0Ja+CqKvF9lrmPxJRGMfwxHS2vwzIPhLC/x5x1b0=;
        b=OAq0r4ZDj40sdOtjhIJ+sgPAbaL5SWosQp0wj8PI9PZsXgPVkxxQ+gO+34+oPesLCe
         mM7Utq+zNlo90ITX1jlr75LumNdFiVCDLx3g2sfpcQDZq7C6TLXO/BIuuhU7QHFbO+jz
         lmZ5MApnra4nb2w3GmMA2yOC8AeTVwgZ+OtGj6mysrtSF2Ip4CgJhFgp//27fAwEwNTS
         1va7g3Xlm7eeIBuTQbdgYpDs9JMRLwkppVRANV2GVSlbsrfrnftKywnZTk3JplGbUp1H
         Ga/Gnbp/v0n4s/LvwtCIh/DtbxwXwlotugvEJI77W0EJ6y3S0RzAXd8fP6On60WBVDcf
         F6mw==
X-Gm-Message-State: AOAM533AVAYomffSamMed+RN5PVbiDoBGdBcf0JyPKDaZWjdmpSVWbWd
        SvUFig97AOIxMwph0sA0CFubjt275gXeFQ==
X-Google-Smtp-Source: ABdhPJzeWGQKqf96mBM77q+6MoiT4uXXCB4x8J+1/9IYPMdO6L5O/QG2RDn2o28yVitPWh8yfU2IDQ==
X-Received: by 2002:a02:b089:: with SMTP id v9mr33106772jah.50.1594139418510;
        Tue, 07 Jul 2020 09:30:18 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x16sm12116623iob.35.2020.07.07.09.30.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 09:30:18 -0700 (PDT)
Subject: Re: [PATCH] io_uring: export cq overflow status to userspace
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200707132420.2007-1-xiaoguang.wang@linux.alibaba.com>
 <0ebded37-3660-e3c0-aa51-d3d7e56d634c@kernel.dk>
 <bb9e165a-3193-5da2-d342-e5d9ed200070@kernel.dk>
 <7262c580-6b98-3dce-3cd7-1bb0ce4c39ed@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <58c488a8-4981-fad8-aabc-df12aecaf2f3@kernel.dk>
Date:   Tue, 7 Jul 2020 10:30:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <7262c580-6b98-3dce-3cd7-1bb0ce4c39ed@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/7/20 10:25 AM, Pavel Begunkov wrote:
> ...
>>>>
>>>> To fix this issue, export cq overflow status to userspace, then
>>>> helper functions() in liburing, such as io_uring_peek_cqe, can be
>>>> aware of this cq overflow and do flush accordingly.
>>>
>>> Is there any way we can accomplish the same without exporting
>>> another set of flags? Would it be enough for the SQPOLl thread to set
>>> IORING_SQ_NEED_WAKEUP if we're in overflow condition? That should
>>> result in the app entering the kernel when it's flushed the user CQ
>>> side, and then the sqthread could attempt to flush the pending
>>> events as well.
>>>
>>> Something like this, totally untested...
>>
>> OK, took a closer look at this, it's a generic thing, not just
>> SQPOLL related. My bad!
>>
>> Anyway, my suggestion would be to add IORING_SQ_CQ_OVERFLOW to the
>> existing flags, and then make a liburing change almost identical to
>> what you had.
> 
> How about CQ being full as an indicator that flush is required?
> With a properly set CQ size there shouldn't be much false positives.

I guess my worry there would be that it makes the state more tricky.
When you do the first peek/get, the ring is full but you can't flush
at that point. You'd really want to flush when the ring is now empty,
AND it used to be full, and you get -EAGAIN.

-- 
Jens Axboe

