Return-Path: <io-uring+bounces-5886-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8FE5A128A6
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 17:25:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18CB53A1879
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 16:25:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8011E4D599;
	Wed, 15 Jan 2025 16:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aZKyzEAg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E19716D9B8
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 16:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736958344; cv=none; b=des5Rfi3H0ZIxMYiXyQvj3LwXczTmzXFcPuKMZCZOr/tGUT9G2qi5U/6IfK8EtrjloshXfvk5F6yhE8T34EzR6tGw8WDfCiP1kYQdxvxF+DbQKQixF+BeH1M+0Ak7ipyy+7rWbiuqVmylb3ZhEoiVT/8OZFVpHupMzAVz5luJs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736958344; c=relaxed/simple;
	bh=KlKHCdyQlh/4QXIGu2NlS+UrQHVfhnL4IWFrWpke3B0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=fYZSm1VMU060HzPSXJ5Alu/LOl2evaltP+sMjCfxlxZFiZqnJV/hkNpMwx7H1rgEqJMI1rqWwxfTfHD+JYFKZp/Pm04cIdU08NF4Ah4U6zNGkWPbfv7msCQXPWfyVwvKxsGWIgUNlkimudxyp0b7R0esLlBiEykdaTRm8kFT5mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aZKyzEAg; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-435b0df5dbdso138795e9.0
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 08:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736958341; x=1737563141; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E7tBPaJBLO6adrX13iEshYe2MPRu3VvQuNYHZI9pNzg=;
        b=aZKyzEAg36oGEqV7r9s/Os8scwZFePGHgawm/2RblB4udI3JiM2f1b3M2I1x7cKWsg
         lPgOHS6rZBM7C5QlrQCugNkpd2iQegYfFEOjJ8OGHURp+BQyYWekCa05NcEP+UKVGvVe
         MFDPSkxw6UBOSJjmN3qNFJOnQfUYOIVY4/xrF6srPNIgmX5EnneuhUzszVpCYVw5bUpn
         6R9xGb4SNuoZNszcVZ/dPpgNMCdop7mpamPoW28BQlYdbhJfXJf4Blk02P+K71655sKs
         mm+N98DTPvwsWkom4QHoL98u6f4hOWtmV6yW5blNYwTdNYQaL5W79Rv3/7VodscVWs/x
         RgPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736958341; x=1737563141;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E7tBPaJBLO6adrX13iEshYe2MPRu3VvQuNYHZI9pNzg=;
        b=N3jTAq2VWEGhTljWHOdDhLRzqa0F+dGswseGXdSd42lkGxet8ohOzLBB4EfkgHkTWG
         bVC2bN33MhgK4ffbZEUpGU8rTWQIIlFgUlfpK7Grj9Bynqkpl9Lp+7n/CoPNUj7VX6cc
         QBE6K0ADkFs2BS/yvaylQ7DSJL2vI3btjXTILCivrxn7Y4bxd1UIg5YsjR2/p6vEvKrR
         nyV+QuUTcwKZh7otAzcwPnAn0QDG/oSzMqHGNpf7XPnxS2j61M1ykPaQCWdGwWLAjP7S
         KYWSOCZQy5u6wOX+pGAn4IktzxiLRCt0KihLrmoTX0SlBpcKbcZDL6EZ/LkoQeGdGlGA
         zCxA==
X-Gm-Message-State: AOJu0YzhqmqP0W35yPVVWBBY1x1S3T2jaX40azsLzn/RdwupsUFY8TUb
	/ygwpxIi2pMc2AyAiJmqVwAVy4DLdLge8pON18qHCA/BID9t881WUU/xVwTH1RNA+Yblwg5Lup1
	wiEK1+bE=
X-Gm-Gg: ASbGncs+9t8r2oytxksvpsgZbT32b7PGCvwcaBrwJA5QTHQjodW8a751XiOEq/BLisy
	kVofyngDGyg6Yz3E4O9roSQX7b5Nd8yvXGYo+uM1YTw2qFmRna7qTgYR81jgHbYk8oVqPXldHHI
	diAHAC4VNrvWF9R9KkhPr/Of7n00zRhEB89dwo+kAeBXkxSJIPA7X5J0FzMMqee9S7goaoZTttx
	LKkN9bbqIeBsRsu04YsiXQvPJaMUJ/bvSOMMOEdckVd
X-Google-Smtp-Source: AGHT+IEpp96oQxVvwOubAD2J8fH41icvftlYvC9RBIjv8nJv54ohEK8w3qNgsto01NFobS7axVAfWA==
X-Received: by 2002:a05:600c:2d94:b0:435:921b:3535 with SMTP id 5b1f17b1804b1-437c73f8285mr1141865e9.3.1736958340177;
        Wed, 15 Jan 2025 08:25:40 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:7175:4098:36d3:bfd7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e37e36asm17646545f8f.5.2025.01.15.08.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 08:25:39 -0800 (PST)
From: Jann Horn <jannh@google.com>
Date: Wed, 15 Jan 2025 17:25:35 +0100
Subject: [PATCH] io_uring/rsrc: Simplify buffer cloning by locking both
 rings
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250115-uring-clone-refactor-v1-1-b2d951577201@google.com>
X-B4-Tracking: v=1; b=H4sIAH7hh2cC/x2MQQqAMAzAviI9W+gEPfgV8aBr1YJs0qkIsr87P
 IaQvJDEVBL01QsmtyaNoYCrK/DbFFZB5cLQUNOScy1epmFFv8cgaLJM/oyG1DF7YZaZCEp6FKP
 Pvx3GnD+LzVtVZgAAAA==
X-Change-ID: 20250115-uring-clone-refactor-06ddceddeb00
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736958336; l=4803;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=KlKHCdyQlh/4QXIGu2NlS+UrQHVfhnL4IWFrWpke3B0=;
 b=K6+PGIj+TpMWq6N7maipCGU3rFs5gjoghBrsXmPAHjeceSRWVJkIl1EbhNVTZ1wG4ngxqjCVy
 EzQvNvF/+UZCRDmFUFq3UW7/jcDdMsaP6d1xytYFS0158DCHZ6ZVQy3
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=

The locking in the buffer cloning code is somewhat complex because it goes
back and forth between locking the source ring and the destination ring.

Make it easier to reason about by locking both rings at the same time.
To avoid ABBA deadlocks, lock the rings in ascending kernel address order,
just like in lock_two_nondirectories().

Signed-off-by: Jann Horn <jannh@google.com>
---
Just an idea for how I think io_clone_buffers() could be changed so it
becomes slightly easier to reason about.
I left the out_unlock jump label with its current name for now, though
I guess that should probably be adjusted.
---
 io_uring/rsrc.c | 58 ++++++++++++++++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 69937d0c94f9518a2fd2cde1e5b2e7139078e1d3..8e26f78230eaaaf7910c1b84a50b40b6ab5fbf16 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -924,6 +924,16 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 	return 0;
 }
 
+/* Lock two rings at once. The rings must be different! */
+static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
+{
+	if (ctx1 > ctx2)
+		swap(ctx1, ctx2);
+	mutex_lock(&ctx1->uring_lock);
+	mutex_lock_nested(&ctx2->uring_lock, SINGLE_DEPTH_NESTING);
+}
+
+/* Both rings are locked by the caller. */
 static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx,
 			    struct io_uring_clone_buffers *arg)
 {
@@ -938,7 +948,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	if (ctx->buf_table.nr && !(arg->flags & IORING_REGISTER_DST_REPLACE))
 		return -EBUSY;
 
-	nbufs = READ_ONCE(src_ctx->buf_table.nr);
+	nbufs = src_ctx->buf_table.nr;
 	if (!arg->nr)
 		arg->nr = nbufs;
 	else if (arg->nr > nbufs)
@@ -962,13 +972,6 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		}
 	}
 
-	/*
-	 * Drop our own lock here. We'll setup the data we need and reference
-	 * the source buffers, then re-grab, check, and assign at the end.
-	 */
-	mutex_unlock(&ctx->uring_lock);
-
-	mutex_lock(&src_ctx->uring_lock);
 	ret = -ENXIO;
 	nbufs = src_ctx->buf_table.nr;
 	if (!nbufs)
@@ -1007,10 +1010,6 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		i++;
 	}
 
-	/* Have a ref on the bufs now, drop src lock and re-grab our own lock */
-	mutex_unlock(&src_ctx->uring_lock);
-	mutex_lock(&ctx->uring_lock);
-
 	/*
 	 * If asked for replace, put the old table. data->nodes[] holds both
 	 * old and new nodes at this point.
@@ -1019,24 +1018,17 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		io_rsrc_data_free(ctx, &ctx->buf_table);
 
 	/*
-	 * ctx->buf_table should be empty now - either the contents are being
-	 * replaced and we just freed the table, or someone raced setting up
-	 * a buffer table while the clone was happening. If not empty, fall
-	 * through to failure handling.
+	 * ctx->buf_table must be empty now - either the contents are being
+	 * replaced and we just freed the table, or the contents are being
+	 * copied to a ring that does not have buffers yet (checked at function
+	 * entry).
 	 */
-	if (!ctx->buf_table.nr) {
-		ctx->buf_table = data;
-		return 0;
-	}
+	WARN_ON(ctx->buf_table.nr);
+	ctx->buf_table = data;
+	return 0;
 
-	mutex_unlock(&ctx->uring_lock);
-	mutex_lock(&src_ctx->uring_lock);
-	/* someone raced setting up buffers, dump ours */
-	ret = -EBUSY;
 out_unlock:
 	io_rsrc_data_free(ctx, &data);
-	mutex_unlock(&src_ctx->uring_lock);
-	mutex_lock(&ctx->uring_lock);
 	return ret;
 }
 
@@ -1050,6 +1042,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 {
 	struct io_uring_clone_buffers buf;
+	struct io_ring_ctx *src_ctx;
 	bool registered_src;
 	struct file *file;
 	int ret;
@@ -1067,7 +1060,18 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	file = io_uring_register_get_file(buf.src_fd, registered_src);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
-	ret = io_clone_buffers(ctx, file->private_data, &buf);
+	src_ctx = file->private_data;
+	if (src_ctx == ctx) {
+		ret = -ELOOP;
+		goto out_put;
+	}
+
+	mutex_unlock(&ctx->uring_lock);
+	lock_two_rings(ctx, src_ctx);
+	ret = io_clone_buffers(ctx, src_ctx, &buf);
+	mutex_unlock(&src_ctx->uring_lock);
+
+out_put:
 	if (!registered_src)
 		fput(file);
 	return ret;

---
base-commit: c1c03ee7957ec178756cae09c39d77194e8cddb7
change-id: 20250115-uring-clone-refactor-06ddceddeb00

-- 
Jann Horn <jannh@google.com>


