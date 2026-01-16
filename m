Return-Path: <io-uring+bounces-11782-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E93AED38A2A
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:32:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7D7DE30A0306
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A922D8364;
	Fri, 16 Jan 2026 23:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lI7zXNQq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0ACF1FE44A
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606291; cv=none; b=hyzAyl5pkv5rf9Ex3dad3zo+7bDYQqS9Syv2zSNesBPDoj5RfhF5wmPH6Zh5O88sQq8cxs7UiyPPwi1d/FVgqYXKbBWcT/fdlswKI9GOldfhMLkUpendkm/fnGEtXbH4qFIKvAERlWBQ8UWC4Ek664RRmF3ea+SpCDUUa52I2dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606291; c=relaxed/simple;
	bh=F+kZeMexWtQKde2dJlSnSScoagreLhL3Ac0mm4y6W5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gl9h3efuZNAXKW40QXQKoXe/wHRJPaO1ATyacmrpLrwyVdNEQOBX9JjtLepllgyyb2lpd4o6jFMCRzvz1e081/Ds/dXR2oas388fLBOe1BsNLVW/6AY+Hdv3Fu3nCqmE8ietW6GgFLZpCBsT6fYRovaxsr5C3luTlKjC4BlDlpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lI7zXNQq; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-81dab89f286so1215663b3a.2
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606289; x=1769211089; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tWu0xJoZ2lXzLlzZvtC7iw+OrNL48tfG2EiEU6ep6XM=;
        b=lI7zXNQq2RG4P57vgTj2RIUV0ihfl2tZ6Yst3w8wXJ5tX+nPwe3dNuKye1KT8LWO1P
         W3TVGen1k7U4crAJ+sQXRa3MeseQdJHLEkYkRah0LelFJnzVQ8wzsC4tm3BRoSJWWHPw
         G/apRASfN0P7iJT56pFj7db4yfg/noGG4jAzEjuN5IxtUm4mWmggR65zVMZNP2XZwYoU
         /rLzubDLxFwyMurICg6a5D1/1VAxO+pN0b1/Y3mMieYAwIf5r4THkEefuZtTUeScP1eX
         pj5OPueiK2B82PHYlWuOMt3qyG5verBCviU3QtOe5qFXJ0xrG3fu+U7dvHUPYXptfAY6
         vIjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606289; x=1769211089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tWu0xJoZ2lXzLlzZvtC7iw+OrNL48tfG2EiEU6ep6XM=;
        b=omkAQ5jQ6jIxWf9JqSqwLvlvXS09f9sAXOSANxyk5YeDteCFphBjF8DPmgHeReQzz3
         daXxEn94mP57pjGpaVCrsD9lHBLOZXJlKAGmr/2vogX3xnvR5QgBfUUJg2nYP3j+9kCp
         VT0WlL3oDH13GHbxMiGEehqPBiTqp9M746NXJOWaF66wKC+t+tQ2Vb2vjPjM/D8K0MO5
         d3j/wnbzZNdtm1V2FInaNj6EBRSUnypMfWqMEKS0D758tmdNqky+EfVyeUobxxLUSQYy
         Gzms1mNnrZOzN8cg5a5NufGmTmiDl54++yVQl4EIpEW8rDJpa0P4P9+SCXIJT5mziWka
         WbIg==
X-Forwarded-Encrypted: i=1; AJvYcCXlBdfjv1VQo3is8lilKAEwwr1mbcVH6fZLZyTlWI2lDZOzup5SoB0Hu3dTCGJ2xXVp6A+/AGPV0A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyA8BDGVjnJBkjtdDamZTgXjQ8qiBwfVKL+x0Z4cgeVy1GeG9tx
	pgzCgarQFktm5c2k2e8xyOTnIsM2wNA3j4jwaoa4uJCQhval2o4pXU6e
X-Gm-Gg: AY/fxX5kCWvvdTEUVHFPiL2/lbvab7q8LjYdVZeAPjtk0AYOQsORaXNwYNpzyDweRuZ
	U8lW+xu/78amQrqnP1oeVA7rThbK/fZS03Wx9YF7RbFX6U0G8heldCssX6/118FyYR3y1tqpPxa
	8V0mkHBYiJkQYIukIu+2PIUaIl7DbTC3zT5z3w/PfXYe7yfJ81kclX7iODoFxsWV/7/FG50wklR
	vX9a9fl+FaGtBj8QyNAXzXwvAQ20XIfPKOUoABOkfKdU4GT8irC/bzL6pTo5uKJt8p88HJJ0wCF
	XO7uovsdM23N5yg6NpoDpyQ3Xw19JeeqCsmn/BPsK29XTBdn2jjYOg/2fA2MRYID+hL0gvY7vPZ
	yf2Fofxv7epNR4EnqxVflZKUEJNvoyOc2ksb6FwAl35NcJjewahSmymmL1nziaugxcnk/MEJhST
	qU3edr6Q==
X-Received: by 2002:a05:6a21:6b17:b0:38d:f0f3:b958 with SMTP id adf61e73a8af0-38dfe60ca5dmr4535168637.23.1768606289296;
        Fri, 16 Jan 2026 15:31:29 -0800 (PST)
Received: from localhost ([2a03:2880:ff:55::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c5edf249c24sm2956893a12.11.2026.01.16.15.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:29 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	miklos@szeredi.hu
Cc: bschubert@ddn.com,
	csander@purestorage.com,
	krisman@suse.de,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	xiaobing.li@samsung.com,
	safinaskar@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 14/25] fuse: refactor io-uring header copying to ring
Date: Fri, 16 Jan 2026 15:30:33 -0800
Message-ID: <20260116233044.1532965-15-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116233044.1532965-1-joannelkoong@gmail.com>
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
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
Reviewed-by: Bernd Schubert <bschubert@ddn.com>
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


