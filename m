Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D3A3E46E9
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 15:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbhHINtz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 09:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233420AbhHINtz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 09:49:55 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2B3C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 06:49:35 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id a8so28037438pjk.4
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 06:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GmCQpp15kiB+glAo4fsvGZ0zt8bma0KDr+KXpV8hF6Y=;
        b=bJ+YEcT6FQ5Iq/7jgHNT6clz0J2CmACYu3eICWEsDbW1tGVu9xXHE6eEdYD5rKzL+/
         TrnSrMiKLwNmjHA7L79/cv2Krphwze0/AdlxMSzuf1x2mIcd3DUHoInIxiFrWdZrcJu5
         h5xma5LbdC5qta4YR12k18zQ0gDvVnul0/2Zoxc4nZBgabSWpz8N4SDtPFQWTaAVL+8/
         91F3kTfO4FTFxjoGC/h5ZWJkV/X6Vqi0azYZc1So4AW2whI/SSTHyc2CpHX+S5lYucIv
         XACiBGA45p0joenimJKAcGfxzich7BH4k3jIEKg4vddsaBri1Oh2Vkfx/a5E3W/25jQA
         XFgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GmCQpp15kiB+glAo4fsvGZ0zt8bma0KDr+KXpV8hF6Y=;
        b=pHWU2DDEedRpElGXadYJOGUwBrZ9v/bOEjZgPjHR1NyOXRO+/Y2ZymtHDVQ3+MR5NI
         s7WLXAc+WNRB5eZEpZ2r4q8vtiGQC3PO3hxDGw0fYlhfIltZ20+tjKjgju0zNKwkw4oo
         8avnSs65qOTO5MIPicOFKebCIr6qtr4ntMlpyEb31v+arfecINTiu+0MY24GNjX7mx2T
         6ooUycoZZttSQNeNi6EOxMeN9C3gTcOlRjwBUKc0qQP+lEzjFvPPExzfoQ8gu3sTNYyQ
         OcrzwG1KEFHagS8ECJT/U0bscF97fswbiryjQ+jm7O9op+4aJcKvsQe7aAwzEZn1qGoF
         mpmA==
X-Gm-Message-State: AOAM530fzfTL3xH6Mnl62qIm9d9aqaABK72IjkPGuWlcpMd15oUOjTRt
        ec/e7k45he1wZpS+nYDr+R8uAcr+xPa56h+0
X-Google-Smtp-Source: ABdhPJyCfGfkrBlJdvKe5Uv2IvEiRcbkvniGaQrOIXDEc1lIGMI83GODJYtufybcG+uejKsLbS3Jtw==
X-Received: by 2002:a63:4005:: with SMTP id n5mr385078pga.140.1628516974457;
        Mon, 09 Aug 2021 06:49:34 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id n23sm21945177pgv.76.2021.08.09.06.49.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 06:49:33 -0700 (PDT)
Subject: Re: iouring locking issue in io_req_complete_post() /
 io_rsrc_node_ref_zero()
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <C187C836-E78B-4A31-B24C-D16919ACA093@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3f2529b9-7815-3562-9978-ee29bf7692e5@kernel.dk>
Date:   Mon, 9 Aug 2021 07:49:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <C187C836-E78B-4A31-B24C-D16919ACA093@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/8/21 10:36 PM, Nadav Amit wrote:
> Jens, others,
> 
> Sorry for bothering again, but I encountered a lockdep assertion failure:
> 
> [  106.009878] ------------[ cut here ]------------
> [  106.012487] WARNING: CPU: 2 PID: 1777 at kernel/softirq.c:364 __local_bh_enable_ip+0xaa/0xe0
> [  106.014524] Modules linked in:
> [  106.015174] CPU: 2 PID: 1777 Comm: umem Not tainted 5.13.1+ #161
> [  106.016653] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/22/2020
> [  106.018959] RIP: 0010:__local_bh_enable_ip+0xaa/0xe0
> [  106.020344] Code: a9 00 ff ff 00 74 38 65 ff 0d a2 21 8c 7a e8 ed 1a 20 00 fb 66 0f 1f 44 00 00 5b 41 5c 5d c3 65 8b 05 e6 2d 8c 7a 85 c0 75 9a <0f> 0b eb 96 e8 2d 1f 20 00 eb a5 4c 89 e7 e8 73 4f 0c 00 eb ae 65
> [  106.026258] RSP: 0018:ffff88812e58fcc8 EFLAGS: 00010046
> [  106.028143] RAX: 0000000000000000 RBX: 0000000000000201 RCX: dffffc0000000000
> [  106.029626] RDX: 0000000000000007 RSI: 0000000000000201 RDI: ffffffff8898c5ac
> [  106.031340] RBP: ffff88812e58fcd8 R08: ffffffff8575dbbf R09: ffffed1028ef14f9
> [  106.032938] R10: ffff88814778a7c3 R11: ffffed1028ef14f8 R12: ffffffff85c9e9ae
> [  106.034363] R13: ffff88814778a000 R14: ffff88814778a7b0 R15: ffff8881086db890
> [  106.036115] FS:  00007fbcfee17700(0000) GS:ffff8881e0300000(0000) knlGS:0000000000000000
> [  106.037855] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  106.039010] CR2: 000000c0402a5008 CR3: 000000011c1ac003 CR4: 00000000003706e0
> [  106.040453] Call Trace:
> [  106.041245]  _raw_spin_unlock_bh+0x31/0x40
> [  106.042543]  io_rsrc_node_ref_zero+0x13e/0x190
> [  106.043471]  io_dismantle_req+0x215/0x220
> [  106.044297]  io_req_complete_post+0x1b8/0x720
> [  106.045456]  __io_complete_rw.isra.0+0x16b/0x1f0
> [  106.046593]  io_complete_rw+0x10/0x20
> 
> [ .... The rest of the call-stack is my stuff ] 
> 
> 
> Apparently, io_req_complete_post() disables IRQs and this code-path seems
> valid (IOW: I did not somehow cause this failure). I am not familiar with
> this code, so some feedback would be appreciated.

Can you try with this patch?


diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca064486cb41..6a8257233061 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7138,16 +7138,6 @@ static void **io_alloc_page_table(size_t size)
 	return table;
 }
 
-static inline void io_rsrc_ref_lock(struct io_ring_ctx *ctx)
-{
-	spin_lock_bh(&ctx->rsrc_ref_lock);
-}
-
-static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
-{
-	spin_unlock_bh(&ctx->rsrc_ref_lock);
-}
-
 static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
 {
 	percpu_ref_exit(&ref_node->refs);
@@ -7164,9 +7154,9 @@ static void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 		struct io_rsrc_node *rsrc_node = ctx->rsrc_node;
 
 		rsrc_node->rsrc_data = data_to_kill;
-		io_rsrc_ref_lock(ctx);
+		spin_lock_irq(&ctx->rsrc_ref_lock);
 		list_add_tail(&rsrc_node->node, &ctx->rsrc_ref_list);
-		io_rsrc_ref_unlock(ctx);
+		spin_unlock_irq(&ctx->rsrc_ref_lock);
 
 		atomic_inc(&data_to_kill->refs);
 		percpu_ref_kill(&rsrc_node->refs);
@@ -7674,9 +7664,10 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 {
 	struct io_rsrc_node *node = container_of(ref, struct io_rsrc_node, refs);
 	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
+	unsigned long flags;
 	bool first_add = false;
 
-	io_rsrc_ref_lock(ctx);
+	spin_lock_irqsave(&ctx->rsrc_ref_lock, flags);
 	node->done = true;
 
 	while (!list_empty(&ctx->rsrc_ref_list)) {
@@ -7688,7 +7679,7 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 		list_del(&node->node);
 		first_add |= llist_add(&node->llist, &ctx->rsrc_put_llist);
 	}
-	io_rsrc_ref_unlock(ctx);
+	spin_unlock_irqrestore(&ctx->rsrc_ref_lock, flags);
 
 	if (first_add)
 		mod_delayed_work(system_wq, &ctx->rsrc_put_work, HZ);

-- 
Jens Axboe

