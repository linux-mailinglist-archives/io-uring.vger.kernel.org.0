Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503D747AB3B
	for <lists+io-uring@lfdr.de>; Mon, 20 Dec 2021 15:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbhLTO0A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 09:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhLTOZ7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Dec 2021 09:25:59 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95959C061574
        for <io-uring@vger.kernel.org>; Mon, 20 Dec 2021 06:25:59 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id w1so7704000ilh.9
        for <io-uring@vger.kernel.org>; Mon, 20 Dec 2021 06:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zXEDrZf1G6+2/wjOxoLQuOZSuLrIboMbUaCQw9Ek2J8=;
        b=LxJ2WpRKiiofOLBkO9SG5eemMg4K/Wh1GDDB/2+fTcRhVAsFjG0/O6k7kVlGfXnMnR
         Ok8nwvpZj0QS5sTBDIPinnIQli2CfpecjxSp/tmD3sKofMrtFfbmblfPf+lLW55oOjEh
         zFeSG+rrT7Gl9CPG7GrTBlAUl0sulPOtV8bgLbCWng9W34Xblj3P/EbJJxJ2ehUsJQo0
         135lSQJCrRFru4XyiZeVBX+XLDqfEMH6uel7Z1cBQeJJnkqEYbsbZ0zK+l47U3LuQ4Re
         sP+F1r0GLL/XoyHzTPE7sOCf6AIRHfZSHevEoZhw78uOZAZByvzR6txf2t3wPE95u/KI
         DcEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zXEDrZf1G6+2/wjOxoLQuOZSuLrIboMbUaCQw9Ek2J8=;
        b=69e+AiqnldW9PiBqO6NlOjLacpFQuEGHgM0hjSmkcy4B1amXIhiIr09F6Dc92vlpBU
         LKzwtRZi2GajvzPB8a5kXpegqPOSlUJVBptBY4/1h2jYUi1QgXSdEXqR0XAdBIhxcW7z
         2S0UarIAQhSkUu5VT8Ypsi8UKe0tzC50qBYTnEIlJEkVdE6mnhwGL6KUtaOZGKODuPX4
         qxj6TNn85XLmAJfRNErAyjvblYGUiUZtR8rV/4B8PJjxc2S6h1XHLcX1VKLObtxlCCtD
         FIyJH3wljiSvrI7krJL20sPjBZofRraRik205IrT8gUypU09aQ9vMxUP6Zl5Yl3O1aU+
         CLYQ==
X-Gm-Message-State: AOAM530TKWDz+bv1ATxkAo56sMrtuiEi+aNTkj3SSmeBOaTkYVcsdlPb
        OeFnIoJhyRSd9Woz9Tq5y6d13g==
X-Google-Smtp-Source: ABdhPJwpRUfuggKoLzxc00z86IdpzICWhTVPJ0oWuzKDoutiPSUInsfGh4QBXxZ9TVKsGHmGo9+2zQ==
X-Received: by 2002:a05:6e02:214e:: with SMTP id d14mr7316394ilv.8.1640010358817;
        Mon, 20 Dec 2021 06:25:58 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id g7sm9098278iln.67.2021.12.20.06.25.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 06:25:58 -0800 (PST)
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
From:   Jens Axboe <axboe@kernel.dk>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Hannes Reinecke <hare@suse.de>, Oren Duer <oren@nvidia.com>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-5-axboe@kernel.dk> <YbsB/W/1Uwok4i0u@infradead.org>
 <2adafc43-3860-d9f0-9cb5-ca3bf9a27109@nvidia.com>
 <06ab52e6-47b7-6010-524c-45bb73fbfabc@kernel.dk>
 <9b4202b4-192a-6611-922e-0b837e2b97c3@nvidia.com>
 <5f249c03-5cb2-9978-cd2c-669c0594d1c0@kernel.dk>
 <d1613b7f-342d-08ad-d655-a6afb89e1847@nvidia.com>
 <a159220b-6e0c-6ee9-f8e2-c6dc9f6dfaed@kernel.dk>
 <3474493a-a04d-528c-7565-f75db5205074@nvidia.com>
 <87e3a197-e8f7-d8d6-85b6-ce05bf1f35cd@kernel.dk>
 <5ee0e257-651a-ec44-7ca3-479438a737fb@nvidia.com>
 <e3974442-3b3f-0419-519c-7360057c4603@kernel.dk>
 <01f9ce91-d998-c823-f2f2-de457625021e@nvidia.com>
 <573bbe72-d232-6063-dd34-2e12d8374594@kernel.dk>
 <4fbf2936-8e4c-9c04-e5a9-10eae387b562@nvidia.com>
 <6ca82929-7e70-be15-dcbb-1e68a02dd933@kernel.dk>
Message-ID: <dec03e62-9ddb-ebf6-a011-b3a9c9b3ac10@kernel.dk>
Date:   Mon, 20 Dec 2021 07:25:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6ca82929-7e70-be15-dcbb-1e68a02dd933@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/20/21 7:19 AM, Jens Axboe wrote:
>>> develop NVMe/RDMA queue_rqs code and test the perf with it.
>>> You should just be able to use iodepth_batch with fio. For my peak
>>> testing, I use t/io_uring from the fio repo. By default, it'll run QD of
>>> and do batches of 32 for complete and submit. You can just run:
>>>
>>> t/io_uring <dev or file>
>>>
>>> maybe adding -p0 for IRQ driven rather than polled IO.
>>
>> I used your block/for-next branch and implemented queue_rqs in NVMe/RDMA 
>> but it was never called using the t/io_uring test nor fio with 
>> iodepth_batch=32 flag with io_uring engine.
>>
>> Any idea what might be the issue ?
>>
>> I installed fio from sources..
> 
> The two main restrictions right now are a scheduler and shared tags, are
> you using any of those?

Here's a sample run, which is 2 threads, each driving 2 devices and
using 31 (-s31) batch submit count, with 16 batch completions (-c16).
Block size is 512b. Ignore most other options, they don't really matter,
the defaults are 128 QD, 32 submit batch, 32 complete batch.

$ sudo taskset -c 10,11 t/io_uring -d256 -b512 -s31 -c16 -p1 -F1 -B1 -n2 /dev/nvme0n1 /dev/nvme3n1 /dev/nvme2n1 /dev/nvme4n1
Added file /dev/nvme0n1 (submitter 0)
Added file /dev/nvme3n1 (submitter 1)
Added file /dev/nvme2n1 (submitter 0)
Added file /dev/nvme4n1 (submitter 1)
polled=1, fixedbufs=1/1, register_files=1, buffered=0, QD=256
Engine=io_uring, sq_ring=256, cq_ring=256
submitter=0, tid=91490
submitter=1, tid=91491
IOPS=13038K, BW=6366MiB/s, IOS/call=30/30, inflight=(128 5 120 128)
IOPS=13042K, BW=6368MiB/s, IOS/call=30/30, inflight=(128 96 128 15)
IOPS=13049K, BW=6371MiB/s, IOS/call=30/30, inflight=(128 122 120 128)
IOPS=13045K, BW=6369MiB/s, IOS/call=30/30, inflight=(110 128 99 128)

That's driving 13M IOPS, using a single CPU core (10/11 are thread
siblings). Top of profile for that:

+    6.41%  io_uring  [kernel.vmlinux]  [k] __blk_mq_alloc_requests
+    5.46%  io_uring  [kernel.vmlinux]  [k] blkdev_direct_IO.part.0
+    5.36%  io_uring  [kernel.vmlinux]  [k] blk_mq_end_request_batch
+    5.24%  io_uring  io_uring          [.] submitter_uring_fn
+    5.18%  io_uring  [kernel.vmlinux]  [k] io_submit_sqes
+    5.12%  io_uring  [kernel.vmlinux]  [k] bio_alloc_kiocb
+    4.75%  io_uring  [nvme]            [k] nvme_poll
+    4.67%  io_uring  [kernel.vmlinux]  [k] __io_import_iovec
+    4.58%  io_uring  [nvme]            [k] nvme_queue_rqs
+    4.49%  io_uring  [kernel.vmlinux]  [k] blk_mq_submit_bio
+    4.32%  io_uring  [nvme]            [k] nvme_map_data
+    3.02%  io_uring  [kernel.vmlinux]  [k] io_issue_sqe
+    2.89%  io_uring  [nvme_core]       [k] nvme_setup_cmd
+    2.60%  io_uring  [kernel.vmlinux]  [k] io_prep_rw
+    2.59%  io_uring  [kernel.vmlinux]  [k] submit_bio_noacct.part.0


-- 
Jens Axboe

