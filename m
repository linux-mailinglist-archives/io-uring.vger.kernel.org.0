Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8451D6CA1
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 21:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgEQT5j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 15:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgEQT5j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 15:57:39 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC8FC061A0C
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 12:57:39 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q24so3885928pjd.1
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 12:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=sE5fcrQ82fU8GbGwnvTiLGQcYinCVX1bU6wo2mq/S2c=;
        b=LqmKE9eHIk1CO0Yvsrl6ehSiegmam8ynVe6g5Y/kHxm2Rzm56J8lQIH/tgAH2NIcoF
         XXJAwbv62rTZk158XXt4yqPrdAgBkBI1j2fSnU3ap38ACF3kXsOJ/nhpRX6ZC/Q032WL
         zQMpVOn3r46YxqjtGtTv2yKGbbCHLdhtugiKAcp1BihbzEtlZygkFe15PUZubbpE957A
         O06wy33xVcNmwuu9QkR05MfxubvZEjjsF48p/1v5qYDabkCDnOrB7+TvoRPNdpsJePiS
         Jn5AcOfipNG1Ql8E9TX/ADRIiBGshn6hnHgIbVknn4NaAfEJ8GxuGtMNf3AGCB3Pog3S
         dowA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=sE5fcrQ82fU8GbGwnvTiLGQcYinCVX1bU6wo2mq/S2c=;
        b=jf5gFBVOsV/hgHkdL0TMCSuxcgNFhxB3RJsEvFrrxeCeJfwfv9NgLjjBRQaK2aYUQj
         AivWXedRy7IIZoXy0bSwZZHSHUgwLMll5ZnvOfExNBO80FcMp9oknHqzFRbhp3yS/NYy
         01CiKEGWdNsIe0HsKOHu+8zSt5tZm7TVY3bF2rS3obg9r7aXPZ58+9YkuxFT/tBHgRr1
         Gsye5KK1GQnFQAlwMXk53LUG9yGkA106GeWMkZTXbpFrQE+xHDKRYWuMP7eeG2VwJ/oi
         V3YiyQMg6hr9qmJYbpLKEtTjjGfZPlkA2vZd/X8NeFZ1XDzTgAmUbn/6LiIcd+KpGX5k
         emyg==
X-Gm-Message-State: AOAM533yFKsyBk7ngMudMe37TpJjljFf9GnUwFtXcuCAB7HPKu5s1bfj
        XryOdN4WofsHxgTI5WWVVpXF4yOLodg=
X-Google-Smtp-Source: ABdhPJw/bsuraHY5OdzIwhPfLi3r72TPutmjLkASBPtJn4dlEJYqGo9fYcHRe8uXKPS1cjFhcEsyDw==
X-Received: by 2002:a17:90a:26a7:: with SMTP id m36mr15287176pje.28.1589745458346;
        Sun, 17 May 2020 12:57:38 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:91d6:39a4:5ac7:f84a? ([2605:e000:100e:8c61:91d6:39a4:5ac7:f84a])
        by smtp.gmail.com with ESMTPSA id o190sm6872598pfb.178.2020.05.17.12.57.37
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 May 2020 12:57:37 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: file registration list and lock optimization
Message-ID: <6c8139b5-67bd-8cb9-622e-8901b7b75623@kernel.dk>
Date:   Sun, 17 May 2020 13:57:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There's no point in using list_del_init() on entries that are going
away, and the associated lock is always used in process context so
let's not use the IRQ disabling+saving variant of the spinlock.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bb2d062c1ff1..93883a46ffb4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6265,16 +6265,15 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	struct fixed_file_data *data = ctx->file_data;
 	struct fixed_file_ref_node *ref_node = NULL;
 	unsigned nr_tables, i;
-	unsigned long flags;
 
 	if (!data)
 		return -ENXIO;
 
-	spin_lock_irqsave(&data->lock, flags);
+	spin_lock(&data->lock);
 	if (!list_empty(&data->ref_list))
 		ref_node = list_first_entry(&data->ref_list,
 				struct fixed_file_ref_node, node);
-	spin_unlock_irqrestore(&data->lock, flags);
+	spin_unlock(&data->lock);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
 
@@ -6517,17 +6516,16 @@ static void __io_file_put_work(struct fixed_file_ref_node *ref_node)
 	struct fixed_file_data *file_data = ref_node->file_data;
 	struct io_ring_ctx *ctx = file_data->ctx;
 	struct io_file_put *pfile, *tmp;
-	unsigned long flags;
 
 	list_for_each_entry_safe(pfile, tmp, &ref_node->file_list, list) {
-		list_del_init(&pfile->list);
+		list_del(&pfile->list);
 		io_ring_file_put(ctx, pfile->file);
 		kfree(pfile);
 	}
 
-	spin_lock_irqsave(&file_data->lock, flags);
-	list_del_init(&ref_node->node);
-	spin_unlock_irqrestore(&file_data->lock, flags);
+	spin_lock(&file_data->lock);
+	list_del(&ref_node->node);
+	spin_unlock(&file_data->lock);
 
 	percpu_ref_exit(&ref_node->refs);
 	kfree(ref_node);
@@ -6606,7 +6604,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	int fd, ret = 0;
 	unsigned i;
 	struct fixed_file_ref_node *ref_node;
-	unsigned long flags;
 
 	if (ctx->file_data)
 		return -EBUSY;
@@ -6714,9 +6711,9 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	}
 
 	ctx->file_data->cur_refs = &ref_node->refs;
-	spin_lock_irqsave(&ctx->file_data->lock, flags);
+	spin_lock(&ctx->file_data->lock);
 	list_add(&ref_node->node, &ctx->file_data->ref_list);
-	spin_unlock_irqrestore(&ctx->file_data->lock, flags);
+	spin_unlock(&ctx->file_data->lock);
 	percpu_ref_get(&ctx->file_data->refs);
 	return ret;
 }
@@ -6792,7 +6789,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	__s32 __user *fds;
 	int fd, i, err;
 	__u32 done;
-	unsigned long flags;
 	bool needs_switch = false;
 
 	if (check_add_overflow(up->offset, nr_args, &done))
@@ -6857,10 +6853,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 	if (needs_switch) {
 		percpu_ref_kill(data->cur_refs);
-		spin_lock_irqsave(&data->lock, flags);
+		spin_lock(&data->lock);
 		list_add(&ref_node->node, &data->ref_list);
 		data->cur_refs = &ref_node->refs;
-		spin_unlock_irqrestore(&data->lock, flags);
+		spin_unlock(&data->lock);
 		percpu_ref_get(&ctx->file_data->refs);
 	} else
 		destroy_fixed_file_ref_node(ref_node);
-- 
2.26.2

-- 
Jens Axboe

