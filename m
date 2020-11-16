Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A35A2B52D5
	for <lists+io-uring@lfdr.de>; Mon, 16 Nov 2020 21:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731770AbgKPUmT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Nov 2020 15:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727764AbgKPUmT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Nov 2020 15:42:19 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D00EC0613CF
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 12:42:18 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id s2so8978737plr.9
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 12:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aJSNc+5TGusbh/DQjBs739mKWDGoTkCryoU5FuRghNo=;
        b=2CS6kPYbN/XKViwYQHMljUEmD700S0FwJIaYonoeuUm3mdq2APkUESgRV14JyatQrm
         BY6oCB+80xuZwYnSrVG83ZNT8pEf+JMjeaRaNacp/Odo3tWOfav0MN/hPegAt3bQSYlY
         eoB9ySaS9yHRkrCqhc5ll366gZMl4rxqnytxmf0RFjroISu/IhufZO1SKLr8+haJ+Nfr
         Ln4E+ue3RG447QnIEk+H5N/acluP/ULB+ygbsHKUmzeXvvUZDutvG07DomcqFOc9eaM1
         3U3/+kv1p1enPvLy+iAD9WmOM1242ypzNaYEVwLCFk+sd/+MyhwlTNxp90MPDGCkEkzS
         Uc5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aJSNc+5TGusbh/DQjBs739mKWDGoTkCryoU5FuRghNo=;
        b=QAx9TMZmyn852fjkK47D9t6+jNRewpq/Fr0gaMGJ/Q7lUZynQHcdOH/gdWpqQDErii
         ZM8fobAAJkQKyAhAEUSjHr8juiSCxniHdfvCXym4HVI0HwVRkx+5/tEOyHYicCZXHyPb
         xB6EuZ6yFY73XN4jwa737HjSj/sCaNABz/qiOvdebAq+ILwAGskWrvoyLESsN/rCBwaJ
         4OumXJ2XYxb7b8hSDvWy2Y4MYgkkyScQF92lsPK5VH6Nc4t7trbiKQIymGS2hpBEXOqY
         /ZmMngZQsPIE8yvwkpuLnUMge9xbxJzFnf+7OPOutceICCaJNBT1R1Y9odOl0iomnXCP
         KaOA==
X-Gm-Message-State: AOAM531h3UPMQOe+Hde/cJBX5Za7binjX/pmO6mEyHc6K5P+URdtEj5q
        KLDPGP/QuClk3S4gOZLVFV1vBzDoB3OsbQ==
X-Google-Smtp-Source: ABdhPJx/Ixx5KJEisWl5gxn78o8kKSztHBbOW+gbnl9RC07ay7xoolQF4qNkNOL+ZKWTJCcCBHqc2Q==
X-Received: by 2002:a17:902:6a84:b029:d8:c8a9:e04d with SMTP id n4-20020a1709026a84b02900d8c8a9e04dmr14787358plk.74.1605559337152;
        Mon, 16 Nov 2020 12:42:17 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w63sm324737pjj.12.2020.11.16.12.42.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 12:42:16 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: replace inflight_wait with tctx->wait
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <ce4f91e603b524b6425d68cf49c83c7d4fbd7d79.1605444955.git.asml.silence@gmail.com>
 <463ac36b-974d-f88c-d178-6e4d24fa4c93@kernel.dk>
 <6f58c74f-19d8-497b-e73e-8655a29601a8@gmail.com>
 <980e4479-5923-f776-e2d6-54e46014a0c7@kernel.dk>
 <7751bed7-2dc0-d72d-297f-de0c2e8fa5d9@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ec769c0e-e2cd-ab52-6132-877694985f65@kernel.dk>
Date:   Mon, 16 Nov 2020 13:42:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7751bed7-2dc0-d72d-297f-de0c2e8fa5d9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/16/20 10:16 AM, Pavel Begunkov wrote:
> On 16/11/2020 16:57, Jens Axboe wrote:
>> On 11/16/20 9:48 AM, Pavel Begunkov wrote:
>>> On 16/11/2020 16:33, Jens Axboe wrote:
>>>> On 11/15/20 5:56 AM, Pavel Begunkov wrote:
>>>>> As tasks now cancel only theirs requests, and inflight_wait is awaited
>>>>> only in io_uring_cancel_files(), which should be called with ->in_idle
>>>>> set, instead of keeping a separate inflight_wait use tctx->wait.
>>>>>
>>>>> That will add some spurious wakeups but actually is safer from point of
>>>>> not hanging the task.
>>>>>
>>>>> e.g.
>>>>> task1                   | IRQ
>>>>>                         | *start* io_complete_rw_common(link)
>>>>>                         |        link: req1 -> req2 -> req3(with files)
>>>>> *cancel_files()         |
>>>>> io_wq_cancel(), etc.    |
>>>>>                         | put_req(link), adds to io-wq req2
>>>>> schedule()              |
>>>>>
>>>>> So, task1 will never try to cancel req2 or req3. If req2 is
>>>>> long-standing (e.g. read(empty_pipe)), this may hang.
>>>>
>>>> This looks like it's against 5.11, but also looks like we should add
>>>> it for 5.10?
>>>
>>> Yeah, 5.10 completely slipped my mind, I'll resend
>>
>> I applied it to 5.10, and fixed up the 5.11 side of things. So all good,
>> just wanted to confirm.
> 
> Hmm, this won't work with 5.10, at least without
> 
> b7e7fb9960b03c ("io_uring: cancel only requests of current task")
> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.11/io_uring&id=b7e7fb9960b03ca07866b5c016ac3ce5373ef207
> 
> That's because tctx->wait is kicked only by requests of current task,
> but 5.10 cancels everything with specified ->files, including owned
> by other tasks.

Ah good point, let's leave it 5.11 for now.

-- 
Jens Axboe

