Return-Path: <io-uring+bounces-10911-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 11933C9D6CD
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:38:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DE7EE4E455F
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D534221773F;
	Wed,  3 Dec 2025 00:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c+Mqq3We"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB4D248868
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722218; cv=none; b=fsZHNAMmmkEN2RYauhtOZwM0ERfd02Uqag7c+/nM6qdj23lAA+PP8upEasExmKNaYs9jkcsG0XujqDlekjuTOhhL5q7B/roxn/MgIMZA0krIRvbyiVUZMikM6kbC4S6etZx4f6bSImEHsuE8qdk9P8VMV6Z1BZ3aYOpB7wgZAbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722218; c=relaxed/simple;
	bh=dCE9Ifsy53U4i9ZoCVgrqAcptT5uW4tuuXml9xDq4zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7heX/lQLTH6ymHAvmAYPjONUQp5moCE/lm2ouuVvm+rsh0LW8oLuM5miclo5I4+o4zfuFj0TUBoGtBLj7SALZNJgXS/zdiGOrrT5B2+GCfjK06EUds9e1MrFuuoXc5n9PibgFKgSntSsqN0+oD4jnvtlWTKQ7GANo+lrOBRT0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c+Mqq3We; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7ad1cd0db3bso4896311b3a.1
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722217; x=1765327017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9L/4yXbNzZtfTE9c852n7Fp8KTBsMqoDKIABPL39CrI=;
        b=c+Mqq3WeIE++9hi3VomeQ+dzQjHosu20ELf9+c9oF/WEG/fNg5/5RwyaH8VlduqvBw
         9Jsm15dWp0p7SHBmm06jQPi9co7f4/wedMGKfZciA457BkKd30mqduP1ORWW3hTUL2ft
         57KWY4qyzQeHBNTxjBsbGWNn4WGqi2UJBRHtHHyqIhKfv+UxPFf+msvZvW2W7g6g/btw
         HVRSk5ZKNdbsOarQASt3em1mwzf7zJKdnPr3epUFrOWwu3J1oCpqUEAiTm2ADyHQ6Pq7
         tpkHuAx3hJ3RPXzpLqdqHThJWfk8G1SMx05A19ybRDD7aJW/UlwEDKI+ak48Xr9RF+w1
         Z0vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722217; x=1765327017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9L/4yXbNzZtfTE9c852n7Fp8KTBsMqoDKIABPL39CrI=;
        b=erwtQg1LhXkFfHBMUyGHadoJDFNHI8rljbe3ySFpLjDel4ixM9O78fUArvfalKjO9C
         0GX+xUdJZ5GpK5BPwOpachxMJgjc7JzkL2pdnqrr9/pJLxRDlqPWhqbNabXlmZ/RpxXL
         gYQVZ9DYtt6wUlcFp6qP5rhqM4NvK5TU6Tp3Qr5GZo7t/KCrbakQ9+tv/Gyn2yTZOwUi
         3o8ZsG3aARegGM74ZyTNDAqerullny+fQ1Icp0c+nFNistOiYevyVoeL2f8/KjamAN4K
         cL2laar4oltnTl76qeU8GB/V8fhPGC/zzMcGvkAT5hycbhO3rj2l6eiU+VpqB21/O1R1
         e/VA==
X-Forwarded-Encrypted: i=1; AJvYcCVQeuUgbw8rlz0Zt9mU4wUoutBD1Apq1CWVDLRkfquP+DjQhTkWRsEr/U4YvM64NGo6WocWaK4ZYg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzyGSNOBYAQJAbBVccj1Zf8RzeGiJiZQAGiMZ2obrQm6yk30Nuo
	M5ltHKmggx0zeH3LGK0J0ltbpNTj63+jy/Q9W484wmG9uoLrFRzjBvAr
X-Gm-Gg: ASbGnctJFQInvh+aTxmKVDW1AoG8d35FoVEceJHVec666jNNVU+RPpjiadMOnyUn7Tz
	v0Wp0/rUECDVyoIwfNPOWCZVsvp6J0TjmR7xxad1h7/CwVUHpwkyAm87++UE1/JTmcvsDMZgF9O
	at50H53DrSJNfz9YKmliAn/SNXLoFkbBcrdTtJx+mAGQk0SWZ8YA98EZeWX5q37/q97NLASUXot
	lZjc5HqIvKbXwKS9CR/6ikeJghU46hTX/Zf7IfF7QZXKFiypnDqhxeXPMVwGRskseaZV5jHOkez
	Q28ZJjqoC/4Yw2hiSPp91ZoTODWQShr/AfHgtTlhzEWYnQV7N3mIV9tQJ34YB4EA/b+6cYBiHOU
	CTdFaPqIR8Z5+5isEvfYtSqzonicOzvkeR3EBh1u5V9P2Tv47SsxW5e9+OOvb91PVKUUNOttqkD
	ywqCj65D1x08xVOKs1lg==
X-Google-Smtp-Source: AGHT+IE9SeA1pRmveuEj5uphT28Uzm7hrg0+2OLBdcOapHOEKlm30K9S10BHshdmD74cxMMubzV74w==
X-Received: by 2002:a05:6a00:4650:b0:7a2:7c48:e394 with SMTP id d2e1a72fcca58-7e004b29385mr524068b3a.0.1764722216720;
        Tue, 02 Dec 2025 16:36:56 -0800 (PST)
Received: from localhost ([2a03:2880:ff:17::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d150b68367sm18373178b3a.12.2025.12.02.16.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:36:56 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 16/30] fuse: refactor io-uring header copying to ring
Date: Tue,  2 Dec 2025 16:35:11 -0800
Message-ID: <20251203003526.2889477-17-joannelkoong@gmail.com>
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


