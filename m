Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D4D391B12
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 17:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235077AbhEZPEt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 11:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbhEZPEt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 11:04:49 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD9EC061756
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 08:03:16 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id b81so1334025iof.2
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 08:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yd9BkCgkqeJ67/8O8QywKaJ9wtr2QyuJ36blaYWY/JM=;
        b=yHuqERU3TkbAe/bG033XfWs4GeDHGVLnIuQNaUt9VtitjN9iCorY3E2KG/d/w+NBT5
         ShOtCRoO9B8P7yPD/CcBV6yFjjXLlJPcPcJfsQWUq4O7+eCuYLcl4aECmUSAMe57dcH7
         tpOEXiSqyzB+x5qHcvM7zyChRabeTxA1/dySGnypT9TYtw/RAwMJKbv/tQFgy+Rgcu2U
         yTu7cFn26ipm3gKRhAF+T4i3pqYTQI2n3TH6pwAl3JP4MPGTEB1PqOJTeMJd1IyaIPV2
         dlXfER1MllTP+gTjSn86R3Vizo7smQXVWR7tIurIiuRbDQy7a62OHdgQyJqKpkqKfvXH
         Wpaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yd9BkCgkqeJ67/8O8QywKaJ9wtr2QyuJ36blaYWY/JM=;
        b=rlJUwjCb+fs8zVkArdvhWAE/+Tu2t0jIP2/nJzBxZjTnsdcxfHGfZsKMRQRXHs3OSO
         TSO8RVPlk8WgnU8KbRbet9po7MmUSimEvuym5V3fPSKqqkfc6m5IwCppPh//TdQA48HD
         56+tKPAQnYmD+rKO/BU9xtqc13e6WHumB8UDgDcZ3izgjE8CdkxoBU1iYDNKQ1N6Zt8S
         N2CGVefTFVpV61jCkfD7ezkvVXz9TauXvU9BqEqRPjMDyo5xL9koGK5dHWObdb7bq6sG
         uMJyQohM3MdJGaAmh9SWsJvB+7PhvmqfBSFs8VxfavI8qMrdBbTt05NMjTAxYqVe7sLk
         gRrw==
X-Gm-Message-State: AOAM53067uVE3UIwG3MgiiJy5jSbq7q+u/5de8aYxspr/gl7RZI0lukU
        NttBoN4kFu+iEjwvegr7qyCpoQ==
X-Google-Smtp-Source: ABdhPJxgiL9seMiRRDh/Q/XCkBfXu4i6STpw9ewvI1V/RFnO/RQs4fZChtSqAOIzk/F3q4MM5sWnQw==
X-Received: by 2002:a5e:8a42:: with SMTP id o2mr24394616iom.144.1622041395719;
        Wed, 26 May 2021 08:03:15 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m8sm14720010ilh.38.2021.05.26.08.03.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 08:03:15 -0700 (PDT)
Subject: Re: [PATCH v2] io-wq: Fix UAF when wakeup wqe in hash waitqueue
To:     qiang.zhang@windriver.com, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210526050826.30500-1-qiang.zhang@windriver.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4b0a8cfa-938c-19fd-ee82-bd4426d55823@kernel.dk>
Date:   Wed, 26 May 2021 09:03:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210526050826.30500-1-qiang.zhang@windriver.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/25/21 11:08 PM, qiang.zhang@windriver.com wrote:
> From: Zqiang <qiang.zhang@windriver.com>
> 
> BUG: KASAN: use-after-free in __wake_up_common+0x637/0x650
> Read of size 8 at addr ffff8880304250d8 by task iou-wrk-28796/28802
> 
> Call Trace:
>  __dump_stack [inline]
>  dump_stack+0x141/0x1d7
>  print_address_description.constprop.0.cold+0x5b/0x2c6
>  __kasan_report [inline]
>  kasan_report.cold+0x7c/0xd8
>  __wake_up_common+0x637/0x650
>  __wake_up_common_lock+0xd0/0x130
>  io_worker_handle_work+0x9dd/0x1790
>  io_wqe_worker+0xb2a/0xd40
>  ret_from_fork+0x1f/0x30
> 
> Allocated by task 28798:
>  kzalloc_node [inline]
>  io_wq_create+0x3c4/0xdd0
>  io_init_wq_offload [inline]
>  io_uring_alloc_task_context+0x1bf/0x6b0
>  __io_uring_add_task_file+0x29a/0x3c0
>  io_uring_add_task_file [inline]
>  io_uring_install_fd [inline]
>  io_uring_create [inline]
>  io_uring_setup+0x209a/0x2bd0
>  do_syscall_64+0x3a/0xb0
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Freed by task 28798:
>  kfree+0x106/0x2c0
>  io_wq_destroy+0x182/0x380
>  io_wq_put [inline]
>  io_wq_put_and_exit+0x7a/0xa0
>  io_uring_clean_tctx [inline]
>  __io_uring_cancel+0x428/0x530
>  io_uring_files_cancel
>  do_exit+0x299/0x2a60
>  do_group_exit+0x125/0x310
>  get_signal+0x47f/0x2150
>  arch_do_signal_or_restart+0x2a8/0x1eb0
>  handle_signal_work[inline]
>  exit_to_user_mode_loop [inline]
>  exit_to_user_mode_prepare+0x171/0x280
>  __syscall_exit_to_user_mode_work [inline]
>  syscall_exit_to_user_mode+0x19/0x60
>  do_syscall_64+0x47/0xb0
>  entry_SYSCALL_64_after_hwframe
> 
> There are the following scenarios, hash waitqueue is shared by
> io-wq1 and io-wq2. (note: wqe is worker)
> 
> io-wq1:worker2     | locks bit1
> io-wq2:worker1     | waits bit1
> io-wq1:worker3     | waits bit1
> 
> io-wq1:worker2     | completes all wqe bit1 work items
> io-wq1:worker2     | drop bit1, exit
> 
> io-wq2:worker1     | locks bit1
> io-wq1:worker3     | can not locks bit1, waits bit1 and exit
> io-wq1             | exit and free io-wq1
> io-wq2:worker1     | drops bit1
> io-wq1:worker3     | be waked up, even though wqe is freed
> 
> After all iou-wrk belonging to io-wq1 have exited, remove wqe
> form hash waitqueue, it is guaranteed that there will be no more
> wqe belonging to io-wq1 in the hash waitqueue.

Thanks, applied.

-- 
Jens Axboe

