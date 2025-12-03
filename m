Return-Path: <io-uring+bounces-10912-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 97420C9D6D3
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:38:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5E3364E4BCE
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6928E2472A6;
	Wed,  3 Dec 2025 00:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WG5kav/y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0712250C06
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722220; cv=none; b=dZDJzO4hMhpeXgPKoQ4ozMAdCj2nxyypaZeWi6kii99+TwuF/k/qHmN4TIzuFr0m9joJ7F+vKTd0kJ1W/8LuOaMIF5kEr6AG1TINJZORSShJ/6yFPIolLLVUE1jbjywRC8AgYbFqfeVEzvyWX+T5Uh/RX3M01rHtQsCyFAaKqDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722220; c=relaxed/simple;
	bh=7StnbW/TqmHUc1vg9s38n043pYlTzeZZxclo5H0fKUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=coFYcwrRTVOwhLac93LsG+dMR7adAJOh1yPQzgZYYi+eFae/b+qjyXxTenQ0RMr85hL90sZuEdxlUYpisChlgm84nARgdr7ck7/Kt+Fcnz2RGYZupVxDkou9gnqDszMyo9gjEHNGtWL08tFKxIa2948YOX5z5OjrOQR+BV5fccY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WG5kav/y; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-29558061c68so74414485ad.0
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722218; x=1765327018; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w+ttqcfQ3T5zSOFv2YhovKb1gWr/JPYacZE2ZQZbU7Y=;
        b=WG5kav/ywz0DiDVAsvWBTFcoSZZ40FNMd1iyFGkYx6uL9amvehY7/6ZRx2QwUdaIR0
         kKBb2hD9D/OMSR/y7f2NSZmqO2s3rIYoUWg4u8bKhtil1q5U1UNFBGkwYrr49uClmkks
         AhSbDRmnxY087sNQ8yzytzUylUtxJWPRjtp69BnPVat0OIdWOiC7a7PlPb/mQkhGYEcC
         NPYIyr9+L2ig2ZZcakLeC7a6ZacvwuS8lLLqxK+gQcZIIemhEdxNKn8tzpcKiyGdNvm+
         JdL4BmenQo1a/Eq4TfQ/gQasmmCWRc/YIxAfVT6EpzPRO6h7+qQNjJTUT3phZlGLHeY9
         uqIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722218; x=1765327018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w+ttqcfQ3T5zSOFv2YhovKb1gWr/JPYacZE2ZQZbU7Y=;
        b=lJs5dRSpoh1OWGToFu7zh/v+4PL6Fb0U0s75EOevfcmeMMV04+pevd6tYgdXkYMTp6
         Ru24i52NUKltqtiorMv8NPkX93Hsgn9aWTK0DaNhvpEq5K28a1gxkSpQ7EUkbSvrDa6e
         86/Jad46PRs0Jie+LVa9XWDOY3LF3JnTAodR88g/bQ3qjFaqvD4Oxhn+BW0bZUgkQN9f
         kE+eAuaQ8uNUQXWdysybPDmiNmqah3kHUoXOTpF/TdQ1ziys3JN0pgpgraVWKQZCBiZY
         XEBveCgreFW4tjfr5ulPGCKdMyFe0LnbPLIFYJSW1kTXi6GEdPI96A35Rm3cnzMtgksV
         PU2w==
X-Forwarded-Encrypted: i=1; AJvYcCUinAAH1Bsl3Trf9CRKbKPrpHkwXEH6GkyzpgSc4U7iyB7qfGEBIiazENIJDI3gajSdSN+iAwq/PA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6h4W/K+Biqjoi+ToGiRzXCNWBM5wKR9elgyBHA7kMn+H0hi0Y
	y8C2/kg3u5Y54aS0him/cIH1BcOOGDScu/3TGBDS1PjQ21KXA1TNdfXV
X-Gm-Gg: ASbGnctjZIg4TxG0GivXKPGOgkrFvdpXTIBJcJHXuqYMACJeo0PA5dWWESpiJaX04tq
	BUyKZdNUdTa4UvCGyLUXxMQ4/eJwI+Y+GFrYFl9BVgP3aakyacnECTzNz5pEkouS/i0pM6Ik4xJ
	lrMc74QM4C/CoFpvV2R3GrP5w53EVT9q7oECz2RJp2jTvOAum9UEtZDyrnkMGfEglQkxeoQYWbB
	opQljSE//nIKAD6IZ1EvSlnj3Wfx/EzAPAMIrvOEP1l68ANVnYeMxFnv+94JsYgM9h0YyBnm0Ma
	q6WwS76jTS3uNUk2XS4PJnGMF5jVailxBzKH+UsqHuMEMcKA95yO5vaGT3CNytIWKDia9SuDSlD
	cbmS2so+fELZVjLAD2DG/bM8tISTLKTyzGmKocom2DgI6iKqqW6r0hwwTMO6xOXYYbd99nNZPWM
	La1idB4B6rQ7ksPPulwg==
X-Google-Smtp-Source: AGHT+IGJU3HgWRI9UHKPjckJ3JBE+66C1T7M/Dkm7JlcooakJDntbx5JY2gxwKnBnmyKaum49h0T4g==
X-Received: by 2002:a17:902:f60e:b0:297:d4a5:6500 with SMTP id d9443c01a7336-29d68391c85mr5750825ad.26.1764722218273;
        Tue, 02 Dec 2025 16:36:58 -0800 (PST)
Received: from localhost ([2a03:2880:ff:15::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb471c6sm163749065ad.79.2025.12.02.16.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:36:58 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 17/30] fuse: refactor io-uring header copying from ring
Date: Tue,  2 Dec 2025 16:35:12 -0800
Message-ID: <20251203003526.2889477-18-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move header copying from ring logic into a new copy_header_from_ring()
function. This consolidates error handling.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev_uring.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 7962a9876031..e8ee51bfa5fc 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -587,6 +587,18 @@ static __always_inline int copy_header_to_ring(void __user *ring,
 	return 0;
 }
 
+static __always_inline int copy_header_from_ring(void *header,
+						 const void __user *ring,
+						 size_t header_size)
+{
+	if (copy_from_user(header, ring, header_size)) {
+		pr_info_ratelimited("Copying header from ring failed.\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
 static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
 				     struct fuse_req *req,
 				     struct fuse_ring_ent *ent)
@@ -597,10 +609,10 @@ static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
 	int err;
 	struct fuse_uring_ent_in_out ring_in_out;
 
-	err = copy_from_user(&ring_in_out, &ent->headers->ring_ent_in_out,
-			     sizeof(ring_in_out));
+	err = copy_header_from_ring(&ring_in_out, &ent->headers->ring_ent_in_out,
+				    sizeof(ring_in_out));
 	if (err)
-		return -EFAULT;
+		return err;
 
 	err = import_ubuf(ITER_SOURCE, ent->payload, ring->max_payload_sz,
 			  &iter);
@@ -794,10 +806,10 @@ static void fuse_uring_commit(struct fuse_ring_ent *ent, struct fuse_req *req,
 	struct fuse_conn *fc = ring->fc;
 	ssize_t err = 0;
 
-	err = copy_from_user(&req->out.h, &ent->headers->in_out,
-			     sizeof(req->out.h));
+	err = copy_header_from_ring(&req->out.h, &ent->headers->in_out,
+				    sizeof(req->out.h));
 	if (err) {
-		req->out.h.error = -EFAULT;
+		req->out.h.error = err;
 		goto out;
 	}
 
-- 
2.47.3


