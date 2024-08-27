Return-Path: <io-uring+bounces-2957-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECD439611F6
	for <lists+io-uring@lfdr.de>; Tue, 27 Aug 2024 17:25:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 464E8B24D53
	for <lists+io-uring@lfdr.de>; Tue, 27 Aug 2024 15:25:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 229071C68BD;
	Tue, 27 Aug 2024 15:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xAT74wQ6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661B81C6F69
	for <io-uring@vger.kernel.org>; Tue, 27 Aug 2024 15:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772308; cv=none; b=lJl16CSgMh5rrTEB0i8HGIeLJVgKy3BXi+4GeOkgjaUtPIYcq7Oex2qoVD8EqNUDrBKSKAzPjrksjaTO84cSfuusSNjnjBz+92Ffc3FB5t13wrJy1CY1oy/77m74E1Ztg/cu3ISUtWEuW5sBl+tppcYMDghcF+gNaGS127m2d3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772308; c=relaxed/simple;
	bh=g1Ub/EmToMcijMnn8L53pc67yZ5x5/1dcAHCP9T2tWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rr8ZXYAIXB82W09PQv70iPijBp8hghZ5s5kKBOpYCtAE352SUfR+Pqetvw9R8kJm5nKEUzIC2Zjvw4bkyrrmEcuaioM7vVHqdTvYOkWh1xSmGZNTwGHn9dDdYzZ9/4z+Odbi/y/WZeLdfVtK6Q6Ghh1sUQRcaeg2FoiHEhoaGsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xAT74wQ6; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-81f86fd93acso210190939f.1
        for <io-uring@vger.kernel.org>; Tue, 27 Aug 2024 08:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724772305; x=1725377105; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=faXHaqUUVKCe2qlotFGZ9Ec0jeJ6g9XXDCxBiP40XIc=;
        b=xAT74wQ6U3W6CVhMHZrVrz12cu+qI66+ny7C0zF+3k3qZxQiTVCBQzsf78Ecv4OFK5
         kR53F+G9CXS5x8lq8MCFrSZkVKWGSKFeV4aTewjIEUzCJy9i07fxoWOo+ArumY1/bdHY
         o3ZXYqn0rds9TqQgRRfMcfOeR5EfGwxZmHYUieeCSmZLcNSK1LtcEXFHO5J381tH2fO1
         vJ+Xp/oBk0M5bjt/9BQ/CItp5l+7PRve5QQHUNPWadLYY9ZkUi4IR45EBJ+yJWK62qUP
         yPHOjyl5iubsnLW+XW4ZMHkujLum7+hZrZxAFz6S7wlSwqkgc62AKc6LdvFH37/05PVs
         OgCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724772305; x=1725377105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=faXHaqUUVKCe2qlotFGZ9Ec0jeJ6g9XXDCxBiP40XIc=;
        b=AIUgWVaKLTk+mly1O9Hh3wiwxgkaEFR1eirCQsfXgjzn7XpIkCYSUTpb9IyKnaMode
         hjXHwKsJl9GPvcE/yHGySVRSiRF6Liq9jAAb8umqzJFWtNNSNkYOsuf4f4ps9H8A0PAC
         lNyMzI6135eK1gfu48woBHbcrXUDfENMSLRiC1tJn64jBUDKttsdQrfZn7iR93pHvfvf
         gY1FGfBLdzQvnwBq3yVn7Rph6d2SOm3fYVEAt34I6etagkTD1gXLbi2r6goSMlG1J20a
         YWW2AoysL0IAV9UV+GW2eofi9UZeT33+bgfAl/76vWrDLaaqvqoy6PsFmboUN8HLeadQ
         MT2w==
X-Gm-Message-State: AOJu0YwAHlTbtAt8jWESdyYsfnhNt9bBQ4RKyWh6SB86TbTf4xT0YHWV
	V0/AJe/KzeOq1TNPqALZulMBJx8uCgLw21z6jzz4yhnDE9mIzKIOjTo5ZtPb6coBwUGpDDp9i9N
	X
X-Google-Smtp-Source: AGHT+IGLVNbPnKjPqR2gZRXJ1ohIV2PWdehBfNjtdJ88SphwKmH1wnM9NCdWCw4C7evafUICILe99g==
X-Received: by 2002:a05:6e02:1489:b0:39d:24af:aff8 with SMTP id e9e14a558f8ab-39e63fd96fcmr22482115ab.7.1724772304625;
        Tue, 27 Aug 2024 08:25:04 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ce7106a4a9sm2678580173.106.2024.08.27.08.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 08:25:03 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring/kbuf: move io_ring_head_to_buf() to kbuf.h
Date: Tue, 27 Aug 2024 09:23:06 -0600
Message-ID: <20240827152500.295643-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240827152500.295643-1-axboe@kernel.dk>
References: <20240827152500.295643-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for using this helper in kbuf.h as well, move it there and
turn it into a macro.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 6 ------
 io_uring/kbuf.h | 3 +++
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index c69f69807885..297c1d2c3c27 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -132,12 +132,6 @@ static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
 	return 0;
 }
 
-static struct io_uring_buf *io_ring_head_to_buf(struct io_uring_buf_ring *br,
-						__u16 head, __u16 mask)
-{
-	return &br->bufs[head & mask];
-}
-
 static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 					  struct io_buffer_list *bl,
 					  unsigned int issue_flags)
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 43c7b18244b3..4c34ff3144b9 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -121,6 +121,9 @@ static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	return false;
 }
 
+/* Mapped buffer ring, return io_uring_buf from head */
+#define io_ring_head_to_buf(br, head, mask)	&(br)->bufs[(head) & (mask)]
+
 static inline void io_kbuf_commit(struct io_kiocb *req,
 				  struct io_buffer_list *bl, int nr)
 {
-- 
2.45.2


