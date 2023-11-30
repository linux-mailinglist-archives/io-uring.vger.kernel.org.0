Return-Path: <io-uring+bounces-176-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DA1F7FFBC2
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 20:46:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC20CB21167
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 19:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A49AD52F81;
	Thu, 30 Nov 2023 19:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fNGC8Ocj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34FFD67
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 11:46:47 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-7b05e65e784so6244839f.1
        for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 11:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701373606; x=1701978406; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jcoagagE8ChRc7FE6rp+15OsfYRm5luXE8rawYKeohg=;
        b=fNGC8OcjD73GlceajgsEdO/tl6dRWns8+jDzZB4sWui840VOgxcoXijHrsNk93bOjy
         xmzNshdvVNwYKYR3jLS2qyhljV7YBHyxlLRejC29QEc6vmX+XvtyQ+ub/IwftgkEJQMw
         9c5vxEnTTd3gee5t8jM/pDyGjJ5xAqqcdIH7nYZOIhWjbrWOPOqDmX9ncBw7eLlDn1xJ
         cw/+Nyzxp4zBjfFmDUCp/lMlhUelZe3Uevsia6pGeNOCw1ZpyAvMV+cQTzYiNxzUcabB
         TPg3s/YhZLxWy7ND9vStUuR/PyyQm1BANJyRWxKQRok8K3XCYe9VDNaLib1sj8qQhJsG
         22AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701373606; x=1701978406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jcoagagE8ChRc7FE6rp+15OsfYRm5luXE8rawYKeohg=;
        b=qqEAyfXxEhhsqsuvAJxYimu8XZDfCHHAQ+/CiXO0TfkTMnsXJCmRndjA+74EXNnhSq
         kfTvZLCQDb2rmgCxq25Y1aZfGDbf/bg01JWR4YQ/LdquKmKvmpiERyWA9x+FsPU3enAf
         VqnBdh9qynj0qMZXJr7pr7L5FgTzvja2vtHl66H4uL0izeV4KsR3hcjM7HYgWPTkIid2
         PsSsCdhYTXalf63tJ8jSku6GkBASZDu3LMrXBuEfwczKfEo71R2ew1ywjJHxfGR9UgN+
         TFLd0WYtJA58FNT7WJCYVhnOT7jYES2marEDSNWDzgZpC3mw1k5wj/f/5fkN3BWOeOun
         nxNQ==
X-Gm-Message-State: AOJu0YzG5UKDz/yS9ln4o3eGfDAdDMyRlIHrJ+IsMlw8YC57DSMtfUS/
	KSgEIX6MoFGlwEv+fT2Y9XcwFAtoLlXS14b2LN2lSg==
X-Google-Smtp-Source: AGHT+IHYo1wZxnO/I9f6KwWUcCPY7rAlVcUGoLFml+lSwBlFcbgW8tz5td2B5c0UNqcVhkjj8BlnDw==
X-Received: by 2002:a5e:9512:0:b0:7b0:75a7:6606 with SMTP id r18-20020a5e9512000000b007b075a76606mr22604669ioj.0.1701373606356;
        Thu, 30 Nov 2023 11:46:46 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a18-20020a029f92000000b004667167d8cdsm461179jam.116.2023.11.30.11.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 11:46:45 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/8] io_uring/kbuf: recycle freed mapped buffer ring entries
Date: Thu, 30 Nov 2023 12:45:51 -0700
Message-ID: <20231130194633.649319-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231130194633.649319-1-axboe@kernel.dk>
References: <20231130194633.649319-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Right now we stash any potentially mmap'ed provided ring buffer range
for freeing at release time, regardless of when they get unregistered.
Since we're keeping track of these ranges anyway, keep track of their
registration state as well, and use that to recycle ranges when
appropriate rather than always allocate new ones.

The lookup is a basic scan of entries, checking for the best matching
free entry.

Fixes: c392cbecd8ec ("io_uring/kbuf: defer release of mapped buffer rings")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 77 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 66 insertions(+), 11 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 85e680fc74ce..325ca7f8b0a0 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -36,6 +36,8 @@ struct io_provide_buf {
 struct io_buf_free {
 	struct hlist_node		list;
 	void				*mem;
+	size_t				size;
+	int				inuse;
 };
 
 static inline struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
@@ -216,6 +218,24 @@ static __cold int io_init_bl_list(struct io_ring_ctx *ctx)
 	return 0;
 }
 
+/*
+ * Mark the given mapped range as free for reuse
+ */
+static void io_kbuf_mark_free(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
+{
+	struct io_buf_free *ibf;
+
+	hlist_for_each_entry(ibf, &ctx->io_buf_list, list) {
+		if (bl->buf_ring == ibf->mem) {
+			ibf->inuse = 0;
+			return;
+		}
+	}
+
+	/* can't happen... */
+	WARN_ON_ONCE(1);
+}
+
 static int __io_remove_buffers(struct io_ring_ctx *ctx,
 			       struct io_buffer_list *bl, unsigned nbufs)
 {
@@ -232,6 +252,7 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 			 * io_kbuf_list_free() will free the page(s) at
 			 * ->release() time.
 			 */
+			io_kbuf_mark_free(ctx, bl);
 			bl->buf_ring = NULL;
 			bl->is_mmap = 0;
 		} else if (bl->buf_nr_pages) {
@@ -539,6 +560,34 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 	return -EINVAL;
 }
 
+/*
+ * See if we have a suitable region that we can reuse, rather than allocate
+ * both a new io_buf_free and mem region again. We leave it on the list as
+ * even a reused entry will need freeing at ring release.
+ */
+static struct io_buf_free *io_lookup_buf_free_entry(struct io_ring_ctx *ctx,
+						    size_t ring_size)
+{
+	struct io_buf_free *ibf, *best = NULL;
+	size_t best_dist;
+
+	hlist_for_each_entry(ibf, &ctx->io_buf_list, list) {
+		size_t dist;
+
+		if (ibf->inuse || ibf->size < ring_size)
+			continue;
+		dist = ibf->size - ring_size;
+		if (!best || dist < best_dist) {
+			best = ibf;
+			if (!dist)
+				break;
+			best_dist = dist;
+		}
+	}
+
+	return best;
+}
+
 static int io_alloc_pbuf_ring(struct io_ring_ctx *ctx,
 			      struct io_uring_buf_reg *reg,
 			      struct io_buffer_list *bl)
@@ -548,20 +597,26 @@ static int io_alloc_pbuf_ring(struct io_ring_ctx *ctx,
 	void *ptr;
 
 	ring_size = reg->ring_entries * sizeof(struct io_uring_buf_ring);
-	ptr = io_mem_alloc(ring_size);
-	if (!ptr)
-		return -ENOMEM;
 
-	/* Allocate and store deferred free entry */
-	ibf = kmalloc(sizeof(*ibf), GFP_KERNEL_ACCOUNT);
+	/* Reuse existing entry, if we can */
+	ibf = io_lookup_buf_free_entry(ctx, ring_size);
 	if (!ibf) {
-		io_mem_free(ptr);
-		return -ENOMEM;
-	}
-	ibf->mem = ptr;
-	hlist_add_head(&ibf->list, &ctx->io_buf_list);
+		ptr = io_mem_alloc(ring_size);
+		if (!ptr)
+			return -ENOMEM;
 
-	bl->buf_ring = ptr;
+		/* Allocate and store deferred free entry */
+		ibf = kmalloc(sizeof(*ibf), GFP_KERNEL_ACCOUNT);
+		if (!ibf) {
+			io_mem_free(ptr);
+			return -ENOMEM;
+		}
+		ibf->mem = ptr;
+		ibf->size = ring_size;
+		hlist_add_head(&ibf->list, &ctx->io_buf_list);
+	}
+	ibf->inuse = 1;
+	bl->buf_ring = ibf->mem;
 	bl->is_mapped = 1;
 	bl->is_mmap = 1;
 	return 0;
-- 
2.42.0


