Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02E01E6A7A
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2020 21:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406459AbgE1TWX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 May 2020 15:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406430AbgE1TWV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 May 2020 15:22:21 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980BAC08C5C6
        for <io-uring@vger.kernel.org>; Thu, 28 May 2020 12:22:21 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id n15so19404pjt.4
        for <io-uring@vger.kernel.org>; Thu, 28 May 2020 12:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ezZJ58p99hMOymjxL1l/MTbksS3V3CIxTlXr14wAUW8=;
        b=MKiPVTG6GTvgUu3tA/+CIWcS/bCGY4wigYhY7r/BYLXezfT4mK/Sl+wadAXKl8VVDQ
         mtj9jKZFgvoLdR/c1VOKPqWbTkmL1pKKeGnRAzAi+mvHp/MDSwygOOAJG0osX6eEcI4K
         y27IvHwzQsHZkegyWX6qZhvTcEdIm8uojH6++O9ASKm+wrU0tR2OyvwAY6g1ZEDWTBTo
         sgQpbHMUzu7+7muMd2GJmt1GGdQx9DEzxKpVQCr89eehZBLMpgqViBb6P982eIr7xVln
         WZfMsPDUVowVs+vGXlfXPFEmvVc/tJEz18YNURqBmXsi3DU8WknNLGMBolwxvNh193OM
         y5Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ezZJ58p99hMOymjxL1l/MTbksS3V3CIxTlXr14wAUW8=;
        b=AqFmG3FFSL8Au4kOIAN92vYBV59AgDsJ1UByFVE9V2CYesZg0ud6xgCDilOIU0FfQZ
         HLaR4jM9KaltgNeNh9EVDwSpIfk/rNdQSK8ZWNEfKp/P4JHDti/wPyWMSX+G9l6dYXSk
         n9+URlzDYwOy5MUuirIHRPQwGI3kCLfXz19/RzG+ygd4/NsH7NAmdf9eKd/Y1nr5vmG5
         7TIhxxeRqnvEIa4wuZfvYvTQmIHt8Fe8KqxtudcTRQuxfAEsSM3b09IH0lXB6BIBAag0
         IzaQyUajn0sbFLFYaLhNYwpurJaI8cpZE5NK7Ate4oYzDVkUyJHyUDMi9YTBrGQDOqF4
         ATzg==
X-Gm-Message-State: AOAM531MJh17t6dCRAi2lpd2lWlCf7Ykd7YsqSJn+/FLG99I+E5tE8YG
        vCg/q2lVT2Bdzt9KX+AM7gjrMEuSsWg/9w==
X-Google-Smtp-Source: ABdhPJyleCwB+3OOiwpuaumwuhX3cypQXJRHFEHG55deUIRp8HlkCgE0q7jLJoP1qOxUeZ2YOsDQjQ==
X-Received: by 2002:a17:90b:41d5:: with SMTP id jm21mr5055518pjb.96.1590693740717;
        Thu, 28 May 2020 12:22:20 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id lj12sm6194890pjb.21.2020.05.28.12.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 12:22:20 -0700 (PDT)
Subject: Re: [RFC 2/2] io_uring: mark REQ_NOWAIT for a non-mq queue as
 unspported
From:   Jens Axboe <axboe@kernel.dk>
To:     Jeff Moyer <jmoyer@redhat.com>,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <1589925170-48687-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1589925170-48687-3-git-send-email-bijan.mottahedeh@oracle.com>
 <x495zcf29ie.fsf@segfault.boston.devel.redhat.com>
 <0ab35b4b-be67-8977-08ea-2998a4ac1a7e@kernel.dk>
Message-ID: <798e24c7-b973-00c7-037f-4095e43515b7@kernel.dk>
Date:   Thu, 28 May 2020 13:22:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <0ab35b4b-be67-8977-08ea-2998a4ac1a7e@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/28/20 1:01 PM, Jens Axboe wrote:
> On 5/28/20 12:35 PM, Jeff Moyer wrote:
>> Bijan Mottahedeh <bijan.mottahedeh@oracle.com> writes:
>>
>>> Mark a REQ_NOWAIT request for a non-mq queue as unspported instead of
>>> retryable since otherwise the io_uring layer will keep resubmitting
>>> the request.
>>
>> Getting back to this...
>>
>> Jens, right now (using your io_uring-5.7 or linus' tree) fio's
>> t/io_uring will never get io completions when run against a file on a
>> file system that is backed by lvm.  The system will have one workqueue
>> per sqe submitted, all spinning, eating up CPU time.
>>
>> # ./t/io_uring /mnt/test/poo 
>> Added file /mnt/test/poo
>> sq_ring ptr = 0x0x7fbed40ae000
>> sqes ptr    = 0x0x7fbed40ac000
>> cq_ring ptr = 0x0x7fbed40aa000
>> polled=1, fixedbufs=1, buffered=0 QD=128, sq_ring=128, cq_ring=256
>> submitter=3851
>> IOPS=128, IOS/call=6/0, inflight=128 (128)
>> IOPS=0, IOS/call=0/0, inflight=128 (128)
>> IOPS=0, IOS/call=0/0, inflight=128 (128)
>> IOPS=0, IOS/call=0/0, inflight=128 (128)
>> IOPS=0, IOS/call=0/0, inflight=128 (128)
>> IOPS=0, IOS/call=0/0, inflight=128 (128)
>> ...
>>
>> # ps auxw | grep io_wqe
>> root      3849 80.1  0.0      0     0 ?        R    14:32   0:40 [io_wqe_worker-0]
>> root      3850  0.0  0.0      0     0 ?        S    14:32   0:00 [io_wqe_worker-0]
>> root      3853 72.8  0.0      0     0 ?        R    14:32   0:36 [io_wqe_worker-0]
>> root      3854 81.4  0.0      0     0 ?        R    14:32   0:40 [io_wqe_worker-1]
>> root      3855 74.8  0.0      0     0 ?        R    14:32   0:37 [io_wqe_worker-0]
>> root      3856 74.8  0.0      0     0 ?        R    14:32   0:37 [io_wqe_worker-1]
>> ...
>>
>> # ps auxw | grep io_wqe | grep -v grep | wc -l
>> 129
>>
>> With this patch applied, the test program will exit without doing I/O
>> (which I don't think is the right behavior either, right?):
>>
>> # t/io_uring /mnt/test/poo
>> Added file /mnt/test/poo
>> sq_ring ptr = 0x0x7fdb98f00000
>> sqes ptr    = 0x0x7fdb98efe000
>> cq_ring ptr = 0x0x7fdb98efc000
>> polled=1, fixedbufs=1, buffered=0 QD=128, sq_ring=128, cq_ring=256
>> submitter=33233
>> io: unexpected ret=-95
>> Your filesystem/driver/kernel doesn't support polled IO
>> IOPS=128, IOS/call=32/0, inflight=128 (127)
>>
>> /mnt/test is an xfs file system on top of a linear LVM volume on an nvme
>> device (with 8 poll queues configured).
> 
> poll won't work over dm, so that looks correct. What happens if you edit
> it and disable poll? Would be curious to see both buffered = 0 and
> buffered = 1 runs with that.
> 
> I'll try this here too.

I checked, and with the offending commit reverted, it behaves exactly
like it should - io_uring doesn't hit endless retries, and we still
return -EAGAIN to userspace for preadv2(..., RFW_NOWAIT) if not supported.
I've queued up the revert.

Jeff, the poll test above is supposed to fail as we can't poll on dm.
So that part is expected.

-- 
Jens Axboe

