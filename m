Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCC71E69F4
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2020 21:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406082AbgE1TCF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 May 2020 15:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406035AbgE1TCE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 May 2020 15:02:04 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2117AC08C5C6
        for <io-uring@vger.kernel.org>; Thu, 28 May 2020 12:02:03 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z26so14030707pfk.12
        for <io-uring@vger.kernel.org>; Thu, 28 May 2020 12:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VMmy+DQ+j6QvP+EVnwXeLtTGMnLSyFr4C0LJcKAfN1w=;
        b=RuoEjBQYN5O75FNeFBfg+hO9E+XO8SEcysneOBoGKwunv24tFRGM0twqmvFsD880KX
         cnF2O3QhW10kEF8YF/9fv2191Ws0b/wcdKm9lD6nDSShJnDsWqt/EH98I+HXBGxw4g06
         c1bww1EyC4Pko79NU132NRyyNBhxHiYHlBCR1aJfYmIb3qeTfby3fqCBwIdMaAAoOqW8
         4qqGTduRlHB5yPpcCfr04lcci6doidJ64bkq8hOD4kkUggElGETPkisfKm5nXc+sawGR
         sLRMSbyeHrQUkmhambRw0hc0KGJUdwAbpYUkrGuAc5tUKlggpN0k24ZFgX/VadTayr1E
         zsBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VMmy+DQ+j6QvP+EVnwXeLtTGMnLSyFr4C0LJcKAfN1w=;
        b=A5r8zLH7ZOJazC0/JaEOH/wNOLiTgunSqVaxvCguzxyoopluGMNzFj79I7T5lFtjGt
         iIs83iQYTjPtbX9YFd4u5P1xfxCt8t6ugBhr6izasbP+HtLyJ8psKvlLpMQZUhhLkaNZ
         bWrBkDbucwlDuensxUic4vNucknyC6+1uUlktYEhfJ+UfFrzrUblvF1k8930UsH1+kfN
         xbiKfrS7BIwgkEJWk5a4M7mYwPkel/af0G+JgVe9xgJRi0A+4BlT1/5NercqTD/v9Plg
         y3Ch+77/7ZHNivAz3Q4fVfUTQedWvjjRZW1w2rOvhLbw9auyPJFgmX2/qVuaPADHsHEN
         TCcQ==
X-Gm-Message-State: AOAM533pm09kNGoSxYP0BIw30IDm34GdS8mtbZ0d8OZw3p/mU111lWlf
        GWcSrlp6PNyYWbfBOoU0DY3Mhi9vVURnBw==
X-Google-Smtp-Source: ABdhPJwOgR+Rernx7+ieIgKwqql0WIQj4YxTpQB+L3mvN4VZk4Cn69AItdU6kxpHy6X3Y43O2Noxdw==
X-Received: by 2002:a63:e549:: with SMTP id z9mr4542913pgj.213.1590692521440;
        Thu, 28 May 2020 12:02:01 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j6sm6335789pjb.0.2020.05.28.12.02.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 12:02:00 -0700 (PDT)
Subject: Re: [RFC 2/2] io_uring: mark REQ_NOWAIT for a non-mq queue as
 unspported
To:     Jeff Moyer <jmoyer@redhat.com>,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <1589925170-48687-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1589925170-48687-3-git-send-email-bijan.mottahedeh@oracle.com>
 <x495zcf29ie.fsf@segfault.boston.devel.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0ab35b4b-be67-8977-08ea-2998a4ac1a7e@kernel.dk>
Date:   Thu, 28 May 2020 13:01:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <x495zcf29ie.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/28/20 12:35 PM, Jeff Moyer wrote:
> Bijan Mottahedeh <bijan.mottahedeh@oracle.com> writes:
> 
>> Mark a REQ_NOWAIT request for a non-mq queue as unspported instead of
>> retryable since otherwise the io_uring layer will keep resubmitting
>> the request.
> 
> Getting back to this...
> 
> Jens, right now (using your io_uring-5.7 or linus' tree) fio's
> t/io_uring will never get io completions when run against a file on a
> file system that is backed by lvm.  The system will have one workqueue
> per sqe submitted, all spinning, eating up CPU time.
> 
> # ./t/io_uring /mnt/test/poo 
> Added file /mnt/test/poo
> sq_ring ptr = 0x0x7fbed40ae000
> sqes ptr    = 0x0x7fbed40ac000
> cq_ring ptr = 0x0x7fbed40aa000
> polled=1, fixedbufs=1, buffered=0 QD=128, sq_ring=128, cq_ring=256
> submitter=3851
> IOPS=128, IOS/call=6/0, inflight=128 (128)
> IOPS=0, IOS/call=0/0, inflight=128 (128)
> IOPS=0, IOS/call=0/0, inflight=128 (128)
> IOPS=0, IOS/call=0/0, inflight=128 (128)
> IOPS=0, IOS/call=0/0, inflight=128 (128)
> IOPS=0, IOS/call=0/0, inflight=128 (128)
> ...
> 
> # ps auxw | grep io_wqe
> root      3849 80.1  0.0      0     0 ?        R    14:32   0:40 [io_wqe_worker-0]
> root      3850  0.0  0.0      0     0 ?        S    14:32   0:00 [io_wqe_worker-0]
> root      3853 72.8  0.0      0     0 ?        R    14:32   0:36 [io_wqe_worker-0]
> root      3854 81.4  0.0      0     0 ?        R    14:32   0:40 [io_wqe_worker-1]
> root      3855 74.8  0.0      0     0 ?        R    14:32   0:37 [io_wqe_worker-0]
> root      3856 74.8  0.0      0     0 ?        R    14:32   0:37 [io_wqe_worker-1]
> ...
> 
> # ps auxw | grep io_wqe | grep -v grep | wc -l
> 129
> 
> With this patch applied, the test program will exit without doing I/O
> (which I don't think is the right behavior either, right?):
> 
> # t/io_uring /mnt/test/poo
> Added file /mnt/test/poo
> sq_ring ptr = 0x0x7fdb98f00000
> sqes ptr    = 0x0x7fdb98efe000
> cq_ring ptr = 0x0x7fdb98efc000
> polled=1, fixedbufs=1, buffered=0 QD=128, sq_ring=128, cq_ring=256
> submitter=33233
> io: unexpected ret=-95
> Your filesystem/driver/kernel doesn't support polled IO
> IOPS=128, IOS/call=32/0, inflight=128 (127)
> 
> /mnt/test is an xfs file system on top of a linear LVM volume on an nvme
> device (with 8 poll queues configured).

poll won't work over dm, so that looks correct. What happens if you edit
it and disable poll? Would be curious to see both buffered = 0 and
buffered = 1 runs with that.

I'll try this here too.

-- 
Jens Axboe

