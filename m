Return-Path: <io-uring+bounces-11265-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 475A7CD7813
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:37:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5E667301987B
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:36:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 119021F63D9;
	Tue, 23 Dec 2025 00:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kr0O7K/f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889582B9A4
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450210; cv=none; b=tDk6L9H3cfXcu5r7grBKb5A2nT37nYYZTjTE8xgMARM7m8Q6sC+7WruWjRuXIZVWy0O3jYLAa102qsYPjF4qLcvFk424zA4UeMDGwx4JIknzto43UeLauIn+WVOHjpvLYLGuQJYapzSVkcs04aplxb0PdkK0U1Uc8xl+rIueRcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450210; c=relaxed/simple;
	bh=dCE9Ifsy53U4i9ZoCVgrqAcptT5uW4tuuXml9xDq4zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGuARw0x8AWYAGO8+YdhfZBWSvQOoR3mWvpi0rbO17jMW5r6XV6xXpwUvzQxoO1+O2qTG0WhurvvZ1WRSz2q42MMIbXZ3hbP0irKRiun7aOlMUI89nxcL/Q4R90MaGDmAdsepaVDFOK0WzVCg1j9s+Zj6kjIH1ChCzdeJlfwCwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kr0O7K/f; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7baf61be569so4836443b3a.3
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450208; x=1767055008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9L/4yXbNzZtfTE9c852n7Fp8KTBsMqoDKIABPL39CrI=;
        b=Kr0O7K/f+yR7Xts04IRWah+DPAWBsv++iHiSujESvuVvsib9pewvhMvDlMc/WxF9Dy
         MI4E+0nOl01k1FdY7Bd3c51zWopmtExlTNjY4FmCQaabJg/cGmLD6ie5mrFWWNAUWAm4
         Xn4TZmT7Xg90bqpd5eVg0DDNiglDWZz7IEfqHge7W+RGzq04cB/m/CRMoOeMA67QxVdZ
         ocOia5pTbTYd9l6SXGtQ+nLrGrzPXJ46DUUGsFZOWOtGE5MDoP58dXFjx1bllPAoT+dT
         p+vHRRAf6dXCGw5EP2ZLvEI87CS7a+7JotLkEuGWFpM/A8jcfIzNO5PP/SvwPXZCeBYM
         JF1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450208; x=1767055008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9L/4yXbNzZtfTE9c852n7Fp8KTBsMqoDKIABPL39CrI=;
        b=QXicKcD+ZPzSdgC+6jY6Kf0fL5lDUDGKsxnj6M7ykQ8qkm+xbWidDuUp0CJTE3HrSk
         ULpmyv2yce0xfZcR13KEnwQTBEAyGnrc5P/3H++Vhpqs0HKT2iz1maleYrtEbVh8N5WB
         fWp6rZjvtRyppgk5fs+rwuI5/c4+y+MpSAlUEy00quDv7TSc7uULytdGR0c6Hr9EPfVO
         A3b7JS/+f/u6H8fS34+V149MNfRoXg2tzOk/dzx25FOsbCybt71g5gYjWAtJfk8OAtqL
         pnHTjTzde5QKn/ug0jB2xO5v05EO32IuFAT+aoVbkPoapS179luaFTIvrN7syiT9pnW3
         GEPg==
X-Forwarded-Encrypted: i=1; AJvYcCW1m/i5w4y96mr/TyVJC7fX/GGgLOtu8CamNcld8tC9c6rnq6WGSJmBOqJTMakzyu1JQPVcLsyabA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyxJ8D9YSOdoejlNo81iAt/Ot8SQjexnC2QKXEP4JIEgwR5nt44
	ezj5H/aSm9NZJH8fSfEFrz9n85QWdHz9qE0usyCZ7oGIA0KTjZWpIkhf
X-Gm-Gg: AY/fxX7EBu8yn42rR219o7XNh11u475Q9A8G0Xw7ZoPw6YIKMRC1zid9LMMozkk6sCN
	1DgfZ/G+eiSR0gyvqOXXdONeDKiW5BC5n2ZGgEzVxZ2uZ7tB+JboQmHjW0NHNzg6J58wUjfFvon
	AhAUA6k1aIWgaGaCLw79eVmOX1nl2sQ++qPUsruJfzkNbe++C4LMfX6BqpUgbfSBPSk4CZxjcIP
	LEUiVRmxE1wWzAIj6iOoLAjNC9KIX0ojUYcoAyMbFV3OH4Jf8IP5q2z2RQuKA6kYVoovqxo8lha
	0wr0jg1bZ+uXCrtccAicSKI6O8I9DUoocnZr7HESYkcvNUNDxCkqcPQvmJU1KQoUwcA4of5Fr3N
	gCDBh3Xl8Aae4wc/KaQ9otpcSBvPrqAeoIrymWf/wbV3mzqV5cW5IeJVC2Cl1vEtqdCTkOn89W2
	PAd26A3gpCnrQdZ8lDfw==
X-Google-Smtp-Source: AGHT+IHVdbjckMfiuEk88UJEb1waxjTNLZMmz6/YhqW8vhxBy6d9JfnViDgdIFqCP3BFIXY3RksA0g==
X-Received: by 2002:a05:6a00:3489:b0:7ef:3f4e:9182 with SMTP id d2e1a72fcca58-7ff67965e2amr11079021b3a.47.1766450207863;
        Mon, 22 Dec 2025 16:36:47 -0800 (PST)
Received: from localhost ([2a03:2880:ff:51::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7a93ab3csm11529868b3a.7.2025.12.22.16.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:47 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 14/25] fuse: refactor io-uring header copying to ring
Date: Mon, 22 Dec 2025 16:35:11 -0800
Message-ID: <20251223003522.3055912-15-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251223003522.3055912-1-joannelkoong@gmail.com>
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
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
 fs/fuse/dev_uring.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 1efee4391af5..7962a9876031 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -575,6 +575,18 @@ static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
 	return err;
 }
 
+static __always_inline int copy_header_to_ring(void __user *ring,
+					       const void *header,
+					       size_t header_size)
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
@@ -637,13 +649,11 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
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
@@ -659,9 +669,8 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
 	}
 
 	ent_in_out.payload_sz = cs.ring.copied_sz;
-	err = copy_to_user(&ent->headers->ring_ent_in_out, &ent_in_out,
-			   sizeof(ent_in_out));
-	return err ? -EFAULT : 0;
+	return copy_header_to_ring(&ent->headers->ring_ent_in_out, &ent_in_out,
+				   sizeof(ent_in_out));
 }
 
 static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
@@ -690,14 +699,8 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
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


