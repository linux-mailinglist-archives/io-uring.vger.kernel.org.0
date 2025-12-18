Return-Path: <io-uring+bounces-11197-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 059BECCAF8C
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:43:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2CCC1304A4E6
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7178A33436A;
	Thu, 18 Dec 2025 08:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C0vtjmbX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BFA334688
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046903; cv=none; b=Kv57M9L6Ceyhz+hev0QgsEul/P5ey+/kCZ07R9jKh9GtyCH1I9gOrDBPZ0gpdBRiKIOrRp2ajRlC+uPRjax3ACc/pbLTqUYboiZL99UCzQBNkTwf49uA4TB8HDXy4vBFfSR5n6TICV5bHTxKc52+51jVTe7bAfkpZUrd8b7GWFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046903; c=relaxed/simple;
	bh=ZkMe4/6Dx+pmQX8ki8G7Upa84OZlBwKQ3m0/1EW95NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaPpO+2vkwkz74vdXM+FVDJx4yZnEgnZcaYQpN6kcpdnDXDyOTD6FFIiW0rIR+4NBiz9jXMMeZculIXTnt3HoPP8JdWH+3N5tJ78HT4aGs8nJJNwnKB637lhAAqW3Xa7+SmWOe5LUwTeCfITVnrDL81e8RBL87ZezKQV2Cf0E/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C0vtjmbX; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a09d981507so2733135ad.1
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046901; x=1766651701; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tw36/s5nwa0exNv0eee1S2uesxu6r6RLUjOdbIOB9QI=;
        b=C0vtjmbXrOv6BxDJ1Dl/Ij4lsQHmFGEQBy5jxhv57aA0BXJhxWtCdTFIlVWMVCYTI2
         RdMmVmlJMdD04xYfjXkjySt0kowuULDpKlSqNrsL+AQuvoghWNJe2iOM4zd/FXv4N5cO
         zsU0ATZI3a4GvIWI7eV0889y+dnOO9Vc8O3VFZ7J0dIYcP3xdihiIrraIzU0GJbKl7+U
         XarXRA+MzgV4MXDK55z+d2K0EZZT6I6fwZVc0u8Up7KarvK9LsKMkb4s2CgZ9D00Mtxf
         +cIF7ohrjoG4WpOBP0QkpCTKEmKCSO6ZfBcrhowSTlIClRhWpAi3ZQZwK2iU4/6hcDBA
         LJJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046901; x=1766651701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tw36/s5nwa0exNv0eee1S2uesxu6r6RLUjOdbIOB9QI=;
        b=DVBPmke820ZeYXzYibaZq7ntCACfzAK2Du2rYx7dwzhPm/4B8x7AC0K4hNkiLSZaBr
         2A5zTFM9v+0Wk282Kuigj4hax1XxRLdjNHO/AUbMzeNi+Zvf84ehJA7KY1akCaXl8hDT
         WylKjm5RXPBTRzDnnYtpWOeYAcX8aKdVJssWOplfSU4u0xT2VSGZakN12ReXmYBAYZhc
         TlxT9nPiAlKoEBnoL6EbuXuhnnpUNtqS4l+2VEGccf2KPeVrBHqEoTgdWxiHFJkyU1Nc
         5vUcQ6X6s0SuUDL1V3yNZhxCDFWKj8Wm7989GBGhN8kQ8eYgBJQa5bbayTu6SwMQJUxE
         RINw==
X-Forwarded-Encrypted: i=1; AJvYcCXbzjxeaduXunX2ydtEgV2juy5o3NDSVH/pJzNjm42rAzIF+ROKwmr0DWso/QozVdPlLFzu/vMRqQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0Q9DFHrHOjxpaB9NNMeAHf1zIESOkhIlnIPwPEBYPgB58I+Xm
	Lyh4AEFPsZsvEA0xrEqPe2gITwFXLUvg7WpVKtQV19GFiHje9OMQ0567
X-Gm-Gg: AY/fxX67eoVL+ItwhPK4aaM54cf1MkrskXtCcSjF07WdTyrdAFj+mkIVCrB8acTnfpV
	TRLi//7MNT2J29ppzEBVYyfCbM55sQaX3tdcjndHwhiJNvs5C/nuTQ3GqejVJuABJfuue4YrbvK
	VvZOOPAkXZ/BJZQaP2FOfIoesFEErsxPL5jS9PVAVQkju2jz3PC/YmhDCgKy0X7bErXBbhg+lUw
	9TQSC6bo43s995/hEuiQHh9x06sQvS7d8qJdhIdO6kUcmDtW7XJR44/ApP8HZsiieDPji3SzYwn
	eEBS6ciJPvLu+bsgCRht90sJ2Xr1vGmKQMrqq3m18L9KmvEQ25xpt6yZnGm+YaZd0fIlsu1IFUh
	EM9mr08LKOSU0tQJko11EAeib3ayGGeVEj6f5h/44AZ2qcFcsb/kQe0kD/Hp2Tw06c6+LA3nnft
	WXJe5f5Pw6crqszu5W2dWTEi2OhnFy
X-Google-Smtp-Source: AGHT+IESClevVgT7T+5JTfHjikryMOsnZxYsMHxq/XYThXFypK18IU7fDkeIlMVFw/rNWBsn4HTYkg==
X-Received: by 2002:a17:902:d542:b0:2a0:b467:a7d0 with SMTP id d9443c01a7336-2a2cab16184mr22128575ad.16.1766046901264;
        Thu, 18 Dec 2025 00:35:01 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4c::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2d161272asm17478995ad.55.2025.12.18.00.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:35:01 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 17/25] fuse: refactor setting up copy state for payload copying
Date: Thu, 18 Dec 2025 00:33:11 -0800
Message-ID: <20251218083319.3485503-18-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218083319.3485503-1-joannelkoong@gmail.com>
References: <20251218083319.3485503-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new helper function setup_fuse_copy_state() to contain the logic
for setting up the copy state for payload copying.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index d16f6b3489c1..b57871f92d08 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -636,6 +636,27 @@ static __always_inline int copy_header_from_ring(struct fuse_ring_ent *ent,
 	return 0;
 }
 
+static int setup_fuse_copy_state(struct fuse_copy_state *cs,
+				 struct fuse_ring *ring, struct fuse_req *req,
+				 struct fuse_ring_ent *ent, int dir,
+				 struct iov_iter *iter)
+{
+	int err;
+
+	err = import_ubuf(dir, ent->payload, ring->max_payload_sz, iter);
+	if (err) {
+		pr_info_ratelimited("fuse: Import of user buffer failed\n");
+		return err;
+	}
+
+	fuse_copy_init(cs, dir == ITER_DEST, iter);
+
+	cs->is_uring = true;
+	cs->req = req;
+
+	return 0;
+}
+
 static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
 				     struct fuse_req *req,
 				     struct fuse_ring_ent *ent)
@@ -651,15 +672,10 @@ static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
 	if (err)
 		return err;
 
-	err = import_ubuf(ITER_SOURCE, ent->payload, ring->max_payload_sz,
-			  &iter);
+	err = setup_fuse_copy_state(&cs, ring, req, ent, ITER_SOURCE, &iter);
 	if (err)
 		return err;
 
-	fuse_copy_init(&cs, false, &iter);
-	cs.is_uring = true;
-	cs.req = req;
-
 	err = fuse_copy_out_args(&cs, args, ring_in_out.payload_sz);
 	fuse_copy_finish(&cs);
 	return err;
@@ -682,15 +698,9 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
 		.commit_id = req->in.h.unique,
 	};
 
-	err = import_ubuf(ITER_DEST, ent->payload, ring->max_payload_sz, &iter);
-	if (err) {
-		pr_info_ratelimited("fuse: Import of user buffer failed\n");
+	err = setup_fuse_copy_state(&cs, ring, req, ent, ITER_DEST, &iter);
+	if (err)
 		return err;
-	}
-
-	fuse_copy_init(&cs, true, &iter);
-	cs.is_uring = true;
-	cs.req = req;
 
 	if (num_args > 0) {
 		/*
-- 
2.47.3


