Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2D16B9CD6
	for <lists+io-uring@lfdr.de>; Tue, 14 Mar 2023 18:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjCNRRa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 13:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjCNRR2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 13:17:28 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F489B1B38
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 10:17:08 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id h5so4957525ile.13
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 10:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678814227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aGSYOM59UIr0TC/H6luGZyzBbwkeaeSpqlzrTARpmW0=;
        b=wGupW5nCeouf8RxFS7vjGxWrqwjy+7BUHNbQejh/zmGKQReyy3smWjItdNMogN3zhQ
         Qx+3SV4+ipihO+E0dlVCt6VJw3sHCpJtd16mic7FoWY8v772YRf4uUew0Yw8tlCGGvPd
         o7LdAXubDwODWIqq5mtkZz6iCDIyaVT4IjFv/TnNroovygBjn74MaZjHF0ZBe9uUOwt3
         4a1ux7mvyRhIFQLKAkWZcEqbqzpEjjeHkVNZUDo9Zy/CxYWzZLiV68ooilZA0OrOQ+H+
         2YMRe6wFK3MrhuxqQDsuENqhhc1IBKO5wcc/cYQ7pN6D0g5lR6n/dzvaaAZvP51tA8Vu
         P3FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678814227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aGSYOM59UIr0TC/H6luGZyzBbwkeaeSpqlzrTARpmW0=;
        b=7ERVlmnfFWiUVPRp8qPYf1adaC3oHkE9pW5gZJ+ZVZGeFE7ocreMq4j0GhkA5FHxaP
         PkChbMOogVLF0OKKmud4joZKBqhNVA7YwJ0XgZ7pQsJl2QKDwFDL5zT1GmdzYZE7IbaH
         sTeDYUhtpDNcSj4Lv0gqV+YkTAKb5N81L24un1hQTQZ6TlxdNH0Yuf4CAC0dT9C4JtAi
         TbxAUhcpCI5AmgWwlQShflOwOgdeNUFjw5Fpc/clRRBsbHfRnB8g6ik+taH+0d1tOMxI
         R05HINZvz2imGhHUBJqvq8/jbWBi3vt9nMkAw+Gp/OZE8EBhNgF1mgO8YhhEBYvR2Xqm
         MJ4g==
X-Gm-Message-State: AO0yUKXpDDP+gWVmNdPYG8+FODyStFe05duF0RrBdtws83rGjTDzhd2v
        5d6xDwEmkRRpoU6tGvGQB2tl3k/BDlDbGcKUp9JB3A==
X-Google-Smtp-Source: AK7set+1HnapotWvjI4yUJo0CiCylbQDp+FFwriokQv22BNQ+5f3HYbicAwoKB58roBSgpzAyr/uhA==
X-Received: by 2002:a05:6e02:1d16:b0:316:ef1e:5e1f with SMTP id i22-20020a056e021d1600b00316ef1e5e1fmr10774947ila.1.1678814227150;
        Tue, 14 Mar 2023 10:17:07 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o12-20020a056e02068c00b003179b81610csm948950ils.17.2023.03.14.10.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 10:17:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     deller@gmx.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring/kbuf: add buffer_list->is_mapped member
Date:   Tue, 14 Mar 2023 11:16:40 -0600
Message-Id: <20230314171641.10542-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314171641.10542-1-axboe@kernel.dk>
References: <20230314171641.10542-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rather than rely on checking buffer_list->buf_pages or ->buf_nr_pages,
add a separate member that tracks if this is a ring mapped provided
buffer list or not.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 14 ++++++++------
 io_uring/kbuf.h |  3 +++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 3adc08f90e41..db5f189267b7 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -179,7 +179,7 @@ void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 
 	bl = io_buffer_get_list(ctx, req->buf_index);
 	if (likely(bl)) {
-		if (bl->buf_nr_pages)
+		if (bl->is_mapped)
 			ret = io_ring_buffer_select(req, len, bl, issue_flags);
 		else
 			ret = io_provided_buffer_select(req, len, bl);
@@ -214,7 +214,7 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 	if (!nbufs)
 		return 0;
 
-	if (bl->buf_nr_pages) {
+	if (bl->is_mapped && bl->buf_nr_pages) {
 		int j;
 
 		i = bl->buf_ring->tail - bl->head;
@@ -225,6 +225,7 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 		bl->buf_nr_pages = 0;
 		/* make sure it's seen as empty */
 		INIT_LIST_HEAD(&bl->buf_list);
+		bl->is_mapped = 0;
 		return i;
 	}
 
@@ -303,7 +304,7 @@ int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 	if (bl) {
 		ret = -EINVAL;
 		/* can't use provide/remove buffers command on mapped buffers */
-		if (!bl->buf_nr_pages)
+		if (!bl->is_mapped)
 			ret = __io_remove_buffers(ctx, bl, p->nbufs);
 	}
 	io_ring_submit_unlock(ctx, issue_flags);
@@ -448,7 +449,7 @@ int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 		}
 	}
 	/* can't add buffers via this command for a mapped buffer ring */
-	if (bl->buf_nr_pages) {
+	if (bl->is_mapped) {
 		ret = -EINVAL;
 		goto err;
 	}
@@ -480,6 +481,7 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 	bl->buf_pages = pages;
 	bl->buf_nr_pages = nr_pages;
 	bl->buf_ring = br;
+	bl->is_mapped = 1;
 	return 0;
 }
 
@@ -514,7 +516,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	bl = io_buffer_get_list(ctx, reg.bgid);
 	if (bl) {
 		/* if mapped buffer ring OR classic exists, don't allow */
-		if (bl->buf_nr_pages || !list_empty(&bl->buf_list))
+		if (bl->is_mapped || !list_empty(&bl->buf_list))
 			return -EEXIST;
 	} else {
 		free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL);
@@ -548,7 +550,7 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	bl = io_buffer_get_list(ctx, reg.bgid);
 	if (!bl)
 		return -ENOENT;
-	if (!bl->buf_nr_pages)
+	if (!bl->is_mapped)
 		return -EINVAL;
 
 	__io_remove_buffers(ctx, bl, -1U);
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index c23e15d7d3ca..61b9c7dade9d 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -23,6 +23,9 @@ struct io_buffer_list {
 	__u16 nr_entries;
 	__u16 head;
 	__u16 mask;
+
+	/* ring mapped provided buffers */
+	__u8 is_mapped;
 };
 
 struct io_buffer {
-- 
2.39.2

