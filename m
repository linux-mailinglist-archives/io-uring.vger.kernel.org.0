Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1182B4BD9
	for <lists+io-uring@lfdr.de>; Mon, 16 Nov 2020 17:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730096AbgKPQ5w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Nov 2020 11:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729629AbgKPQ5w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Nov 2020 11:57:52 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3605CC0613CF
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 08:57:52 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id j23so2236932iog.6
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 08:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=I1pEpLhzihvFbRfmQZ7qzF7i6AhURtgc4xDSva3XQvY=;
        b=eb0ybHFavt9IB2zxWvDipo0MZUywlAoeohElBHb7XzXMITeWcTqPIwPLU755T3O2y7
         CV5gFfEy4MDFEebcqBPaqS18z+7p30Jqo/OdtLXmgkxKi1gMNYN54q4ycOhxmrUt6WXe
         lnfgJ6sfOM57or+c6de57YMPdBMbPQrknO8qxtf28Ci27vrf4cf2/A1lS3yVBaC9aV+V
         HhQvqan/fngb32dAT8sG8SPLM1LvD2zwmASgzvCKQbTIoHiRwN6PBk3W8me1wvdvwZQP
         zOW8P0WdXviPRaMNnnHxU7YuBfVx+aQU9zKhyufVds5DYtCVxnbf3wiZJrpYlUjEAuUw
         RQ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I1pEpLhzihvFbRfmQZ7qzF7i6AhURtgc4xDSva3XQvY=;
        b=RBbjXlQlYLTy4moeNBOvCj1Z5ml6GQ8uzfjN8VodEnYHpDzxO/XN8qSr0ies94cGyD
         zJrEDXAL8ETIKbxmo5kGrAU8o46TjnMKMfqBpuqeKsmzYvF+1lwspWcJi3p9Zw+7vd6F
         htiS4chII/sTIcWnwfm1XEH+v3j+Oxa8hfaTuIXo/R9l29GdHLX/9p/t6FxGnvq1tgsl
         Zs/OLqLJ5UJS/AZ7xM5wVE+9tlRdu3JPv59/ylAR2Hq4tkMgu+IFFnsDIXd0SzJt0Cq2
         8AzKl1n64bl/zpsXklZe6vzIhXVcnp23smh7sovvw0Inz07zXl6Y/t3PR8o5WdPNHpVu
         Xgnw==
X-Gm-Message-State: AOAM531mrlnWLY9M+8v13QQwEvdB71opmuOaqQMn9iBUJ10CcvBPPYFB
        Haoeow8dTfE4UaGCTk6MYgNuHcrf3nNsjQ==
X-Google-Smtp-Source: ABdhPJw8E7fvjYp5X1Kucp+uyDdxzEurEwlrzF6xeOFwb8StSQmL+BO1VF36M7QfnCuWt/FfnHjf1w==
X-Received: by 2002:a5d:9042:: with SMTP id v2mr7684438ioq.98.1605545871233;
        Mon, 16 Nov 2020 08:57:51 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x7sm9636056ilh.79.2020.11.16.08.57.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 08:57:50 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: replace inflight_wait with tctx->wait
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <ce4f91e603b524b6425d68cf49c83c7d4fbd7d79.1605444955.git.asml.silence@gmail.com>
 <463ac36b-974d-f88c-d178-6e4d24fa4c93@kernel.dk>
 <6f58c74f-19d8-497b-e73e-8655a29601a8@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <980e4479-5923-f776-e2d6-54e46014a0c7@kernel.dk>
Date:   Mon, 16 Nov 2020 09:57:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6f58c74f-19d8-497b-e73e-8655a29601a8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/16/20 9:48 AM, Pavel Begunkov wrote:
> On 16/11/2020 16:33, Jens Axboe wrote:
>> On 11/15/20 5:56 AM, Pavel Begunkov wrote:
>>> As tasks now cancel only theirs requests, and inflight_wait is awaited
>>> only in io_uring_cancel_files(), which should be called with ->in_idle
>>> set, instead of keeping a separate inflight_wait use tctx->wait.
>>>
>>> That will add some spurious wakeups but actually is safer from point of
>>> not hanging the task.
>>>
>>> e.g.
>>> task1                   | IRQ
>>>                         | *start* io_complete_rw_common(link)
>>>                         |        link: req1 -> req2 -> req3(with files)
>>> *cancel_files()         |
>>> io_wq_cancel(), etc.    |
>>>                         | put_req(link), adds to io-wq req2
>>> schedule()              |
>>>
>>> So, task1 will never try to cancel req2 or req3. If req2 is
>>> long-standing (e.g. read(empty_pipe)), this may hang.
>>
>> This looks like it's against 5.11, but also looks like we should add
>> it for 5.10?
> 
> Yeah, 5.10 completely slipped my mind, I'll resend

I applied it to 5.10, and fixed up the 5.11 side of things. So all good,
just wanted to confirm.

-- 
Jens Axboe

