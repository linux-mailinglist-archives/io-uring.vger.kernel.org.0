Return-Path: <io-uring+bounces-11785-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9055DD38A30
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:33:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 444E53063475
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F0C71C84B8;
	Fri, 16 Jan 2026 23:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KDt1Zvrh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21B5322B74
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606296; cv=none; b=mBE7VC4A4ud6DgPCARzOdJuNeLEIJmWcu0VkAwrZNoD6v+GFA7T8Fej1nBSNETwOd/k5SnEVYy4lNrqL0ntCQXc4mJcA2cSNLdADzxL0ui8GPEOBEhupfRFRK565I0iqw5LV2f8/xT2QBHegdVOLxBaalieU8jdPAP5apMwh4nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606296; c=relaxed/simple;
	bh=ZkMe4/6Dx+pmQX8ki8G7Upa84OZlBwKQ3m0/1EW95NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0foVLM1hArYkQ8KczsTjbccOZQzbbawinuQxdOac6/aBGv1ItDwnBgMgbjokwwnuRsqgPzAJ5DpApTJMT77ta5GDIOJt1Y5zMseCc3SrTL4/kraEiVIrxfnN7b7C1o8yoO7ckdMTynlVIz327qAgqPBzTPsJ4o/7NoiAiO+ZEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KDt1Zvrh; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-34c708702dfso1333220a91.1
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606294; x=1769211094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tw36/s5nwa0exNv0eee1S2uesxu6r6RLUjOdbIOB9QI=;
        b=KDt1ZvrhPIDhE58PlzQ1lzp+H8RnPxYW8XywAOCU27DfdZzBNQccR+nSf7J/7lgu9z
         Qx7LCsGRzGuvezPjpNN4opoot6YF/GLpjy7S4G+fIa0EVFlgxjx0B+4jOAPV3/SHbJEs
         2cg3imY8No0c0ZiC5WzOMzy5C8v80QNw/cpns8ACtbY4gHUBJPdiJd08MRvT+tHEcUUJ
         pX4tHv5YGCDMgZAgnU0P0s6oid7PRaY5TMyuB88vvAArKrA5QkOb3iEUzLYJCyinZVo3
         HArmUoyNR6nSDEAc4XDIgDOmbIOvV+5hDoC61Vw+C8Uh77tnmNiRlstVmb/iaiM+1OM6
         9DkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606294; x=1769211094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tw36/s5nwa0exNv0eee1S2uesxu6r6RLUjOdbIOB9QI=;
        b=T0Fa56SJ5XLKMvF5yzKOMVMvCt2LY39jYwtjwF5UzaD2ycKf9WY/zW8+Cotb9nIbeb
         MJKBntmLilgC1fmlhxMLHcaYIhPsdh0iQFFnXCiHQuk2RBn/woND21rPnqRpZAmHVuHa
         tswcFPiDdPo9JoeM1MCzYog+J9TrjY8q7h3jtGGXWSDdIsGfXudBM217Nlyb5JkNcvGe
         RH0NAFspOSp83syfBgp2DEpJR2dFYn7WH1Sc5i8xcWOS9jF9SCPFaSMrXj5e+SAKK1A6
         2z9bKfD5m3Z48ZaFcNGPiGwDL3Ue3sEyQDrZzHVWERFjoSQPcX2hgh5rKu4ulhelTa0B
         dQWw==
X-Forwarded-Encrypted: i=1; AJvYcCUZ3OqhHIkf+NyUfUYGz5jvvXXTRUkK+bXeMtPF2/HyrRjQRZKyNUBYmhNtH/kH/CpIngg/sV8I5w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc4OXqeEJJ1p3O873MUwU6DG10Sg/1ScDaAyH3cqxqKh6SGFr+
	kk8Pgs4E9dFjKc2cXETpMsDqby5J933rOBh+hOGuY7pGlGDVu4bqYnkC
X-Gm-Gg: AY/fxX5gaR1zeRvqnuhHTcKEQJla3CC3SNJy6oy63u0eEsc7+u4/gvDmRCm/F22Q/zF
	2gBJYyhkCE/Dug7TEZZVXFsy9mN/SfhHCNKbJMmNG2uDgi/gXG2dcONvLMT7iLROsxk22EnVMdn
	3JFDtL0biaKFG5ykhknJW/wz5L+F+RFOXnt9MJqVD7qnuS6/R15SLxOW67V7KZ7hNaGutUdyDCM
	UiVBAlHMXQ80D7LZtDGDmzmV2sN998bBozu8hLhZDd5sOCfvGkmTgMwK02eccBfBLfFpKXFuyxx
	kj0Q4NzmKnEMe7KCwFzEvVg+5m9mGW/AxkpefGUp3Gr0Mt2S8mOIWpfn9XdOJA5+mLDzPAXpxQD
	eY82CHrqR47GP64uoZFzLs0pw/11lACOuKkYldFNFI6oj4mdgXhe2WKS5QrCfCEgRApinU2EVvd
	urqOATog==
X-Received: by 2002:a17:90b:3f4d:b0:34f:6312:f22c with SMTP id 98e67ed59e1d1-35272d9bf76mr3829862a91.0.1768606294261;
        Fri, 16 Jan 2026 15:31:34 -0800 (PST)
Received: from localhost ([2a03:2880:ff:51::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3527313c2a9sm2955690a91.17.2026.01.16.15.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:33 -0800 (PST)
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
Subject: [PATCH v4 17/25] fuse: refactor setting up copy state for payload copying
Date: Fri, 16 Jan 2026 15:30:36 -0800
Message-ID: <20260116233044.1532965-18-joannelkoong@gmail.com>
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


