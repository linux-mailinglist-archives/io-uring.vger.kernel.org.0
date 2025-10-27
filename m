Return-Path: <io-uring+bounces-10245-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 508B2C11B48
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 23:30:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0460C1A63BC7
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 22:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EFBE32D7E0;
	Mon, 27 Oct 2025 22:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KaKnMge8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8716332C92A
	for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 22:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761604187; cv=none; b=If1ivW3inB5zy3/tuUbu77+jvfSfAmJSbjqPv0Etx4j00gx1lzBlg5yZdd8Q9nJd4xT2Rp+vifULVhrvZvXUqRFRL+jct5nIVvL9hMvtWPm0oH5TIOk/GflXEIOoHUfOqIzVx7YlY1zPmrYoomnxFSNpVmrWazHPClUBWOfZjvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761604187; c=relaxed/simple;
	bh=8A79P8ikgNtU8nqy/yGKm+ZPhSySvxK6IUtYcHc8hXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPKoby5wL+lkptC6thQxR9YlIz5u9wNLbvnWawG+BMp23iyvhMRYiVJWR99vKIrvjS94eUyr8V0ZrMkEJJ2BmxohxDjjeDVdNXAhYyGqHY33O9kVA4vU6RUK1JOw48eZ72nd1NkXAWqXYQZ8jji6sP2kjzVNvTSyg6AdN/S1cPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KaKnMge8; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-29488933a91so48992735ad.2
        for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 15:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761604185; x=1762208985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5UI4tABegcBahDJCaCrtdTqXp6q/hujggFDtHYhxwGg=;
        b=KaKnMge8mLCEtokwRcPgTA0e79UAFfe0aTSsk/O5mpbEq51+86eQaw6u6l3YEcqAVN
         eGsiAWat7xdB7ORFnctILLW6rOgj5yoEtD0ePVfkHnL2DRe6Rxh2wfiUUe5EEk75Uq6i
         dPqyT31rDFY6KXlFNxr9YCOddEGBqSvDGPI8YEQ3vP6oIrLGHGQ62Gss11D0Sqj7eIR4
         mYpNehaiNi7p5kYxttYUg/JTx8KHKxXwOhkry/OcQlLxKJKWwTowHz+xW7ZY0NoLKS6t
         qcrw/kiP4zLiu19DSNMx9uE54TGs/rBL0HHs6E53YZDR9hnGXi6IHzdV3MPXTZjYqcX+
         w7qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761604185; x=1762208985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5UI4tABegcBahDJCaCrtdTqXp6q/hujggFDtHYhxwGg=;
        b=NUlHuS7iIgF4mfAwZacpxRLes5geJbG2vd6AcEJRLx/T8JAYozxUOUjV7uLnFlpzp/
         8u3KyL6acjPzxeE/X+u+Vr1mlOJyXZhGCGSOzzTnjArbjUSme0YQcD3g4HV+WQSM3vKV
         ecpGHqyrO+V4QMi6uLpwBCzjGzG8Uh1DEuU7bOphZTVbX+WBkI1lb05tRngnoKO4bx6H
         6rct6QqQthWmx06OBWQGEcOqEAWKuv+KBDbKceefH0XiC8sj8F/AdUq6D9Hk8iprzyzM
         YJdgTrULwUTPf4iASLdErtK3fKfYpfHon+UnYDVMfLwo6fl3+9k7bw7eOcKFbG7Sf/yM
         EDoA==
X-Forwarded-Encrypted: i=1; AJvYcCXBlQlKOTiAQCrTTk1u6cY6aadYP0ugHoN2fjNahTzPvy5S7c5t6B/1KjzcvLULaTSZUXaS6YlVJQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9kVF7cE9IK5aevRPXT5j0mX5ifU4wvolQsMuSyqzOiERNuZpH
	xLoeuSz394FHL0MZ8RYQTmWXlH9wTcj1JrfoTVm81WeVVztTPvvH49KF
X-Gm-Gg: ASbGncuK7JJxsQveBYT1TYHJ9YbAjEx2wCG4WANnTbOyPW5zKq0S4V+RGS7NXtRVE/W
	OJFbaX6RYhdGo3ul664AsxaZE0todnw+7J+wM0hc1hzIFcGDozKA5OMh0W2y/ZL/bkNzi1wnYJQ
	U7NURs7vFINFCGZGABF8lKantR2bzFYDaBpZVQ3nDRu8MoZ+7d/AqIRKSlbPSWC2yInHzwDT1oD
	WHCSECfp74KcT2AMpQA50ozjTUVKn+aqkzOUDjNVj/O+aa1xQexuJsZs8YJ/uwWD/7nGucJJLeD
	XCyk82jIPmPhiGWg5Kw66gmiJ+YiC1bvRQJERdzkkzHwaHjAwNxFbIc76Bk8FIJLSkht6+cXhdr
	cpxTYW2VwafiyxsAU09HgYFvVfAfZMn9WFVxTXTytcHKTqp8KGmgg27pFqinXi19FgqCH5r6Ndg
	TxpP1HFr9ru4Q1PEnZEFgk8OAJC5s=
X-Google-Smtp-Source: AGHT+IFwrbOr1tSnykKtXJZCnqIDrl9UdlMQ53hxYME5Wm5nkykYz2Elb3VDPJa8XKwN00l5oOirrQ==
X-Received: by 2002:a17:902:f550:b0:290:a8fe:24e5 with SMTP id d9443c01a7336-294cb65f7dfmr14967285ad.55.1761604184868;
        Mon, 27 Oct 2025 15:29:44 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:41::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d30030sm92523355ad.65.2025.10.27.15.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 15:29:44 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: linux-fsdevel@vger.kernel.org,
	bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	xiaobing.li@samsung.com,
	csander@purestorage.com,
	kernel-team@meta.com
Subject: [PATCH v2 3/8] fuse: refactor io-uring header copying to ring
Date: Mon, 27 Oct 2025 15:28:02 -0700
Message-ID: <20251027222808.2332692-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251027222808.2332692-1-joannelkoong@gmail.com>
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move header copying to ring logic into a new copy_header_to_ring()
function. This consolidates error handling.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev_uring.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 415924b346c0..e94af90d4d46 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -574,6 +574,17 @@ static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
 	return err;
 }
 
+static int copy_header_to_ring(void __user *ring, const void *header,
+			       size_t header_size)
+{
+	if (copy_to_user(ring, header, header_size)) {
+		pr_info_ratelimited("Copying header to ring failed.\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
 static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
 				     struct fuse_req *req,
 				     struct fuse_ring_ent *ent)
@@ -634,13 +645,11 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
 		 * Some op code have that as zero size.
 		 */
 		if (args->in_args[0].size > 0) {
-			err = copy_to_user(&ent->headers->op_in, in_args->value,
-					   in_args->size);
-			if (err) {
-				pr_info_ratelimited(
-					"Copying the header failed.\n");
-				return -EFAULT;
-			}
+			err = copy_header_to_ring(&ent->headers->op_in,
+						  in_args->value,
+						  in_args->size);
+			if (err)
+				return err;
 		}
 		in_args++;
 		num_args--;
@@ -655,9 +664,8 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
 	}
 
 	ent_in_out.payload_sz = cs.ring.copied_sz;
-	err = copy_to_user(&ent->headers->ring_ent_in_out, &ent_in_out,
-			   sizeof(ent_in_out));
-	return err ? -EFAULT : 0;
+	return copy_header_to_ring(&ent->headers->ring_ent_in_out, &ent_in_out,
+				   sizeof(ent_in_out));
 }
 
 static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
@@ -686,14 +694,8 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
 	}
 
 	/* copy fuse_in_header */
-	err = copy_to_user(&ent->headers->in_out, &req->in.h,
-			   sizeof(req->in.h));
-	if (err) {
-		err = -EFAULT;
-		return err;
-	}
-
-	return 0;
+	return copy_header_to_ring(&ent->headers->in_out, &req->in.h,
+				   sizeof(req->in.h));
 }
 
 static int fuse_uring_prepare_send(struct fuse_ring_ent *ent,
-- 
2.47.3


