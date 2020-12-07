Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554A52D15F7
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 17:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgLGQ3D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 11:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgLGQ3C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 11:29:02 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4F7C061793
        for <io-uring@vger.kernel.org>; Mon,  7 Dec 2020 08:28:22 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id t37so9323886pga.7
        for <io-uring@vger.kernel.org>; Mon, 07 Dec 2020 08:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XYveud/4T1tJ7zU32kT3fUDtRpMesbaDb+LwXgqnUOc=;
        b=OELjWbeSukm1ETuFtnAatgT8uMM2kFRKQEv1nUn8tTpuBhlQT9WHapGvpAx0bV5w2s
         Jr90lGJrJ6qrTUvOZe8Kn0w7AzOqcrqLbk/IkKdLFWejLI93Vom+70AfJiDy8RJJq9gN
         oktNeC3V2ubphh0mdt11mxo8g+M4cJvvKkoeRRf5QojnyUAslmburxoegElmJOve15ar
         Z3zxWHzD5WhKoNN9zWhOq0lkzBbUh5sWvucTSz5d89mkFJryRIinBpWFxxp4my0PVUhb
         K5DM5gTugzqTCgPv+dSvQX+mUdVWHMAhTLeIK8NGWmKDEjaXyKrGbZ2DeCMDV8Nh2+oV
         wkxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XYveud/4T1tJ7zU32kT3fUDtRpMesbaDb+LwXgqnUOc=;
        b=Kf+OniZdfNh/V21x1ei9woha5zVGoFP46u4GAyH926q9n42Fhrsi0zgQDGr8RX1DNh
         +cz4dK4GV8/ciBzIxYJbxWMA+DbA45c/6940CZ4uhGYyPOJMyb9NAPIORRH/1Nwk35oX
         pIzwPRQEp0GMqeZkrHI0eGNUI47zR0NYZTcayyYgdob5ZaRXQDwxzr36KaO2YcYu7tvD
         6q4jpbgrRfU5ke5FP1BnfvkVd5xNr4y3MvmqYjeyWmRqbWR0ODvtJ5xh8xCCoOy0yIkM
         /nJ2JNbEvTttDizXguZnaZfnMRiAESBkPFaWjHbecgAcLsBPuqVxJjMzTh4fPJuHieP6
         v8Xw==
X-Gm-Message-State: AOAM533TiTcGQtZSuar3Tp/drkjJhIQJzMuGh+mHOBQMHeTKw612+rn8
        lkfDmniRF+I+keBDz1CL8xzSnHI92WJ2CQ==
X-Google-Smtp-Source: ABdhPJy81Lg/fD8/qmNxkLmw6Tgr/17cQr05TwDzMM6AbkhBZ2ZqvtN/Gow7Br2fwwluqpO7Izdfqw==
X-Received: by 2002:a63:8f4f:: with SMTP id r15mr19114370pgn.381.1607358502000;
        Mon, 07 Dec 2020 08:28:22 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21d6::120d? ([2620:10d:c090:400::5:8d80])
        by smtp.gmail.com with ESMTPSA id d4sm10786846pjz.28.2020.12.07.08.28.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 08:28:21 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.10 1/5] io_uring: always let io_iopoll_complete()
 complete polled io.
To:     Pavel Begunkov <asml.silence@gmail.com>
References: <cover.1607293068.git.asml.silence@gmail.com>
 <cf556b9b870c640690a1705c073fe955c01dab47.1607293068.git.asml.silence@gmail.com>
Cc:     xiaoguang.wang@linux.alibaba.com,
        io-uring <io-uring@vger.kernel.org>
Message-ID: <10e20bd3-b08f-98b8-f857-8b9a75a511dd@kernel.dk>
Date:   Mon, 7 Dec 2020 09:28:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cf556b9b870c640690a1705c073fe955c01dab47.1607293068.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Dec 6, 2020 at 3:26 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>
> Abaci Fuzz reported a double-free or invalid-free BUG in io_commit_cqring():
> [   95.504842] BUG: KASAN: double-free or invalid-free in io_commit_cqring+0x3ec/0x8e0
> [   95.505921]
> [   95.506225] CPU: 0 PID: 4037 Comm: io_wqe_worker-0 Tainted: G    B
> W         5.10.0-rc5+ #1
> [   95.507434] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [   95.508248] Call Trace:
> [   95.508683]  dump_stack+0x107/0x163
> [   95.509323]  ? io_commit_cqring+0x3ec/0x8e0
> [   95.509982]  print_address_description.constprop.0+0x3e/0x60
> [   95.510814]  ? vprintk_func+0x98/0x140
> [   95.511399]  ? io_commit_cqring+0x3ec/0x8e0
> [   95.512036]  ? io_commit_cqring+0x3ec/0x8e0
> [   95.512733]  kasan_report_invalid_free+0x51/0x80
> [   95.513431]  ? io_commit_cqring+0x3ec/0x8e0
> [   95.514047]  __kasan_slab_free+0x141/0x160
> [   95.514699]  kfree+0xd1/0x390
> [   95.515182]  io_commit_cqring+0x3ec/0x8e0
> [   95.515799]  __io_req_complete.part.0+0x64/0x90
> [   95.516483]  io_wq_submit_work+0x1fa/0x260
> [   95.517117]  io_worker_handle_work+0xeac/0x1c00
> [   95.517828]  io_wqe_worker+0xc94/0x11a0
> [   95.518438]  ? io_worker_handle_work+0x1c00/0x1c00
> [   95.519151]  ? __kthread_parkme+0x11d/0x1d0
> [   95.519806]  ? io_worker_handle_work+0x1c00/0x1c00
> [   95.520512]  ? io_worker_handle_work+0x1c00/0x1c00
> [   95.521211]  kthread+0x396/0x470
> [   95.521727]  ? _raw_spin_unlock_irq+0x24/0x30
> [   95.522380]  ? kthread_mod_delayed_work+0x180/0x180
> [   95.523108]  ret_from_fork+0x22/0x30
> [   95.523684]
> [   95.523985] Allocated by task 4035:
> [   95.524543]  kasan_save_stack+0x1b/0x40
> [   95.525136]  __kasan_kmalloc.constprop.0+0xc2/0xd0
> [   95.525882]  kmem_cache_alloc_trace+0x17b/0x310
> [   95.533930]  io_queue_sqe+0x225/0xcb0
> [   95.534505]  io_submit_sqes+0x1768/0x25f0
> [   95.535164]  __x64_sys_io_uring_enter+0x89e/0xd10
> [   95.535900]  do_syscall_64+0x33/0x40
> [   95.536465]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   95.537199]
> [   95.537505] Freed by task 4035:
> [   95.538003]  kasan_save_stack+0x1b/0x40
> [   95.538599]  kasan_set_track+0x1c/0x30
> [   95.539177]  kasan_set_free_info+0x1b/0x30
> [   95.539798]  __kasan_slab_free+0x112/0x160
> [   95.540427]  kfree+0xd1/0x390
> [   95.540910]  io_commit_cqring+0x3ec/0x8e0
> [   95.541516]  io_iopoll_complete+0x914/0x1390
> [   95.542150]  io_do_iopoll+0x580/0x700
> [   95.542724]  io_iopoll_try_reap_events.part.0+0x108/0x200
> [   95.543512]  io_ring_ctx_wait_and_kill+0x118/0x340
> [   95.544206]  io_uring_release+0x43/0x50
> [   95.544791]  __fput+0x28d/0x940
> [   95.545291]  task_work_run+0xea/0x1b0
> [   95.545873]  do_exit+0xb6a/0x2c60
> [   95.546400]  do_group_exit+0x12a/0x320
> [   95.546967]  __x64_sys_exit_group+0x3f/0x50
> [   95.547605]  do_syscall_64+0x33/0x40
> [   95.548155]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> The reason is that once we got a non EAGAIN error in io_wq_submit_work(),
> we'll complete req by calling io_req_complete(), which will hold completion_lock
> to call io_commit_cqring(), but for polled io, io_iopoll_complete() won't
> hold completion_lock to call io_commit_cqring(), then there maybe concurrent
> access to ctx->defer_list, double free may happen.
>
> To fix this bug, we always let io_iopoll_complete() complete polled io.

This patch is causing hangs with iopoll testing, if you end up getting
-EAGAIN on request submission. I've dropped it.

Reproducible with test/iopoll /dev/somedevice

where somedevice has a low queue depth and hits request starvation
during the test.

-- 
Jens Axboe

