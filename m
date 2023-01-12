Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3E166797B
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 16:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbjALPiL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 10:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235011AbjALPhY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 10:37:24 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124B93FC90
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 07:27:52 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id p9so9158958iod.13
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 07:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QQNsmcbJGjSqHvhcGtkc7WNkhYvr6MAYzLtZxzByW0g=;
        b=Sok8W5STaiwlRrQMF/i3mUtf5g9Lh0azP7ztq7Svc+1fMrWrBZy/yAHxMSYqrQPJ0/
         BjgOjSWbaiVT2nGQd+k+1P53lSdhMnjXyzb+4VSjjbXyPRdsBGGxC/Qk/8M9CTQQvpDr
         /mSEX5oU2Up8GDZqHTNz1TSQ7SN6eUnR7TCfZc4QJMBoONXfgVFp1bY0P3+HkPPBlfCs
         N+fW1V2cUI20alnDje0RHTWs5hssptsw5kj8/mF3uGr1cqG/Gh0a7kUy3qG6SMtrg5Rg
         O6be7Eba1SHj6tCFp9ygCLj14eQY/xJ0TR22U1jYod3vVbM1fYY6LbYIVZBPvZzMi79w
         Zv/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QQNsmcbJGjSqHvhcGtkc7WNkhYvr6MAYzLtZxzByW0g=;
        b=cyXUFifXTxcRqgTXcWmPP4J+sGYu7BufSYfPx9vV3M8TqmJZm2JMxWRNrScDJV1ERs
         uWLfIS10Li8AGkFYJjFS9e8mImne99S6BoEbT7WVHWYbqgOPG4+R8xvlPUtxIfyNK6Q3
         JilkiYgqLKiU5+NC2J9lqs7ujiWI0EwPQNw//V443sf0eOl4y5eH1ZYx83RRadRXRP1w
         M45HkPVHEOIWg96s241VHoCjnCAidwPl1VIzd5GkuzX9uCkxaIh7WpLodtNWcfWbMq60
         0mk30HIE9avtIeIytSrkTmCFQRqPFhgAZ7JPa1b4o3D75AuFsAKV/0xM57cKEwoqKteX
         BZ0Q==
X-Gm-Message-State: AFqh2kpOHSh4KS7qABiwssLUlifahY5H0DDt0eRmbFRWo2ZheN9JFQkb
        MF6A8cV7UhVw7LOjtRs2zg2EYnfbKsqifAja
X-Google-Smtp-Source: AMrXdXvwplDhlmXDTyY/pvKGL+amu134TbFkzuPgPRiDNNd4Tiw+JyGbV8PVXHifjtTbFfQebKeEeg==
X-Received: by 2002:a6b:7d46:0:b0:6ed:1ad7:56bc with SMTP id d6-20020a6b7d46000000b006ed1ad756bcmr11343678ioq.0.1673537271293;
        Thu, 12 Jan 2023 07:27:51 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k5-20020a0566022a4500b006df19c8671fsm6010956iov.27.2023.01.12.07.27.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 07:27:50 -0800 (PST)
Message-ID: <5601285f-6628-f121-243e-44de7b15c779@kernel.dk>
Date:   Thu, 12 Jan 2023 08:27:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [syzbot] WARNING in io_cqring_event_overflow
Content-Language: en-US
To:     syzbot <syzbot+6805087452d72929404e@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000694ccd05f20ef7be@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000694ccd05f20ef7be@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/12/23 3:56?AM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> WARNING in io_cqring_event_overflow
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 2836 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> Modules linked in:
> CPU: 1 PID: 2836 Comm: kworker/u4:4 Not tainted 6.2.0-rc3-syzkaller-00011-g0af4af977a59 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound io_ring_exit_work
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
> sp : ffff8000164abad0
> x29: ffff8000164abad0
>  x28: ffff0000c655e578
>  x27: ffff80000d49b000
> 
> x26: 0000000000000000
>  x25: 0000000000000000
>  x24: 0000000000000000
> 
> x23: 0000000000000000
>  x22: 0000000000000000
>  x21: 0000000000000000
> 
> x20: 0000000000000000
>  x19: ffff0000d1727000
>  x18: 00000000000000c0
> 
> x17: ffff80000df48158
>  x16: ffff80000dd86118
>  x15: ffff0000c60dce00
> 
> x14: 0000000000000110
>  x13: 00000000ffffffff
>  x12: ffff0000c60dce00
> 
> x11: ff808000095945e8
>  x10: 0000000000000000
>  x9 : ffff8000095945e8
> 
> x8 : ffff0000c60dce00
>  x7 : ffff80000c1090e0
>  x6 : 0000000000000000
> 
> x5 : 0000000000000000
>  x4 : 0000000000000000
>  x3 : 0000000000000000
> 
> x2 : 0000000000000000
>  x1 : 0000000000000000
>  x0 : 0000000000000000
> 
> Call trace:
>  io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
>  io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
>  io_fill_cqe_req io_uring/io_uring.h:168 [inline]
>  io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
>  io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
>  io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
>  io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
>  process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
>  worker_thread+0x340/0x610 kernel/workqueue.c:2436
>  kthread+0x12c/0x158 kernel/kthread.c:376
>  ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 576210
> hardirqs last  enabled at (576209): [<ffff80000c1238f8>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (576209): [<ffff80000c1238f8>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
> hardirqs last disabled at (576210): [<ffff80000c110630>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (576168): [<ffff80000bfd4634>] spin_unlock_bh include/linux/spinlock.h:395 [inline]
> softirqs last  enabled at (576168): [<ffff80000bfd4634>] batadv_nc_purge_paths+0x1d0/0x214 net/batman-adv/network-coding.c:471
> softirqs last disabled at (576166): [<ffff80000bfd44c4>] spin_lock_bh include/linux/spinlock.h:355 [inline]
> softirqs last disabled at (576166): [<ffff80000bfd44c4>] batadv_nc_purge_paths+0x60/0x214 net/batman-adv/network-coding.c:442
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------

Pavel, don't we want to make this follow the usual lockdep rules?


diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1dd0fc0412c8..5aab3fa3b7c5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -753,7 +753,7 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	size_t ocq_size = sizeof(struct io_overflow_cqe);
 	bool is_cqe32 = (ctx->flags & IORING_SETUP_CQE32);
 
-	lockdep_assert_held(&ctx->completion_lock);
+	io_lockdep_assert_cq_locked(ctx);
 
 	if (is_cqe32)
 		ocq_size += sizeof(struct io_uring_cqe);

-- 
Jens Axboe

