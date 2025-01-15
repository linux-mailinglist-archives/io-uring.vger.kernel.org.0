Return-Path: <io-uring+bounces-5875-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D638A125DE
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 15:20:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75B79188052B
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 14:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84ED024A7D0;
	Wed, 15 Jan 2025 14:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="gq5g8nHq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F5C24A7D1
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 14:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736950846; cv=none; b=AtZVkQ81UmT/cBrfNMVfdc7XjClC3sUBgs+9PEQl07/IfsjVTjf0YRA7dqmqpC2t9oypX3VmizULw6y09IEfLRFmvlfu0eVHyu1vH0/C8KOMq2QlC1ooSUlJxnPa8pPFQBleVg18IRVPQ2CRwjO4SDG6EoQqe0fIfky2q8iuM5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736950846; c=relaxed/simple;
	bh=wZJVHr50tVRxJgD4/Q9lPNz+wSttlrEe1Q5ocQ1GPrU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YQmnpu97B0bQmoKlYwThkcIXN+om1XrVpGzpv93u2dQXepe5QPTAP2Dqdb1HLmstQpsKPO930K+oCsNDauiQAJKAjeS0VEqn4ahP8ADSUE3f4D1DTB5eFzC9+1aAWEsgefBbo3kFWCJ1dky53uHXJLW35/U87VXfaWt6cWhbU0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=gq5g8nHq; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2166022c5caso107850045ad.2
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 06:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1736950843; x=1737555643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=okGeS6v1lzJs8M0nmHzMylENZ9EbVE9huMjoGku+U6Y=;
        b=gq5g8nHqmipeEoJF8QdEPGaKNbPO8VeOD8NLfD8UrWEHe7Q26Gy1SrAr+RjLzrFehb
         l8K3L+DhuB0gafN8+0pQVvAEqV/xIrJ+fR4agsnVXmZHNfMW0lyfNSOATJDd2bqoaOtD
         ARijuIjjRX6IDA3nLFvKflueqxPtA/PrSnYKeulgnDKpaBc7U5uHvGxwYjdw47vmTXKh
         IU8qK3PvuV+jDM6VNhUSG0DuJpnch9rSZWfe2amgaL0poehIif3yHIzi5nNmi3Hs5NIm
         ORtIT5mqMyuqSHoCAfM+u5k4WoL+ZRKB9ay7ebKSpPYm4NXn91D7rCGD0MqgFh/SRW6p
         6Uvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736950843; x=1737555643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=okGeS6v1lzJs8M0nmHzMylENZ9EbVE9huMjoGku+U6Y=;
        b=G6HqFjJcbV5xWDIDJtF6nimOid0sow5w4wxZJto2QsFzQqutcpArS8eOZlujgapHNL
         OUwQCWUZ/igQFums3Jcaz+x0Dsx5fgq8trhRX18SVgkRGKTYM8rlohPQHIEIW7yjwIHC
         zcFBYQwQaS27VVnmFd12g0Z6njYavx4a3QoHq4HthIyRIJ+WNVvsAz72CLp7zXaR6yZS
         X97jojfZEgnF2SFqn7U/5MJ+qC9nDownU8WnygxjLYA1OAvBE6bVvUD2PZ8B1K4/97g8
         Tafag+Qh/hAX6GVf2Y9NNlIV0DhxeYHFNeWVIhxO4kpAzIXACcHzi2GUV5pR3+365nzz
         XKgA==
X-Gm-Message-State: AOJu0YxfT1x/iyOT7B/SSvU77jIF1jBlP/PR7h7i1JihqCwQf9Bu0OyT
	o2U0488ut/yPjlSuLOEsI7zoRI7FZHpcYh1GG6APdM9X4LZYkWogXLFXKpcbxcmKykmg7pIp6f0
	BM8w=
X-Gm-Gg: ASbGncuQPqKbTEfsZBiHbUSU5gKpZ6r1fg6wK4K2b5kLx4b8xW7F7dFzDFF6A2Bvsu0
	vmX7REIAz3Zbc86IgmOj1Fqjm9VDeeeJoZ3KBF5RMz84xPYIeZIYjRWSh39HOLpuacUc0jU4dH1
	glpBWFVU6zvtAStnfGgm3FMXs0WBgaTBYz2p5a9cLZotWkCu0b7XhusmkJDHt1oKYShW/6wjRoQ
	rDoe3B3nuRZ1Bs5ZcVvKG49qnFHuohOI7ZC0xYriWBgQNNP2LbqBhCr0r3s1c1dDJdnuB2sK+UL
	qy6zOulWt/zKnl87xhk0jPg=
X-Google-Smtp-Source: AGHT+IHJBb2A6zzSfaOB45ZLJdFB5XjzXN1eQFNJGd3MnMGWGxlpLPeREnQe89zrmw/fNs1ESMUTBg==
X-Received: by 2002:a17:903:1110:b0:215:7b7b:5cc9 with SMTP id d9443c01a7336-21a83f54bf6mr474510175ad.22.1736950843512;
        Wed, 15 Jan 2025 06:20:43 -0800 (PST)
Received: from sidong-vm.sidong.yang.office.furiosa.vpn ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f2545f5sm83362275ad.217.2025.01.15.06.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 06:20:43 -0800 (PST)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: io-uring <io-uring@vger.kernel.org>
Cc: Sidong Yang <sidong.yang@furiosa.ai>
Subject: [PATCH] io_uring/rsrc: remove unused parameter ctx for io_rsrc_node_alloc()
Date: Wed, 15 Jan 2025 14:20:31 +0000
Message-ID: <20250115142033.658599-1-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_ctx parameter for io_rsrc_node_alloc() is unused for now.
This patch removes the parameter and fixes the callers accordingly.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 io_uring/filetable.c |  2 +-
 io_uring/rsrc.c      | 10 +++++-----
 io_uring/rsrc.h      |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index a21660e3145a..dd8eeec97acf 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -68,7 +68,7 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 	if (slot_index >= ctx->file_table.data.nr)
 		return -EINVAL;
 
-	node = io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
+	node = io_rsrc_node_alloc(IORING_RSRC_FILE);
 	if (!node)
 		return -ENOMEM;
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 077f84684c18..f30efb1c1ef1 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -118,7 +118,7 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 	}
 }
 
-struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int type)
+struct io_rsrc_node *io_rsrc_node_alloc(int type)
 {
 	struct io_rsrc_node *node;
 
@@ -203,7 +203,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				err = -EBADF;
 				break;
 			}
-			node = io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
+			node = io_rsrc_node_alloc(IORING_RSRC_FILE);
 			if (!node) {
 				err = -ENOMEM;
 				fput(file);
@@ -525,7 +525,7 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			goto fail;
 		}
 		ret = -ENOMEM;
-		node = io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
+		node = io_rsrc_node_alloc(IORING_RSRC_FILE);
 		if (!node) {
 			fput(file);
 			goto fail;
@@ -734,7 +734,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	if (!iov->iov_base)
 		return NULL;
 
-	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
+	node = io_rsrc_node_alloc(IORING_RSRC_BUFFER);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
 	node->buf = NULL;
@@ -994,7 +994,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		if (!src_node) {
 			dst_node = NULL;
 		} else {
-			dst_node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
+			dst_node = io_rsrc_node_alloc(IORING_RSRC_BUFFER);
 			if (!dst_node) {
 				ret = -ENOMEM;
 				goto out_put_free;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 7a4668deaa1a..68b6127673e0 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -42,7 +42,7 @@ struct io_imu_folio_data {
 	unsigned int	folio_shift;
 };
 
-struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int type);
+struct io_rsrc_node *io_rsrc_node_alloc(int type);
 void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node);
 void io_rsrc_data_free(struct io_ring_ctx *ctx, struct io_rsrc_data *data);
 int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
-- 
2.43.0


