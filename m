Return-Path: <io-uring+bounces-11268-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 48384CD7869
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:38:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 14DB930552F5
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8EB81F5851;
	Tue, 23 Dec 2025 00:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y/V6jZkf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1CF1DF736
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450214; cv=none; b=liOZWBo8yfUojbBUkKbtfiz/VggVuxKGTYweed4K+DMOmt3Hi09BDppO8WbiP9XefmF5Tsy3S1z7sT247m3e009WTAV0IXKj/lEx9I0XDjCJl+/2co2MC/zAdD/RFUPe3bhP8sIHYTzUVdcf6n2yudFmwBlNSHyFeBFVybytHZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450214; c=relaxed/simple;
	bh=ZkMe4/6Dx+pmQX8ki8G7Upa84OZlBwKQ3m0/1EW95NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJi8ZLHaxyl5H0aKHvuo0am+AtGfNRM2svVrKhfpMkWK7YAQ/GfXZS9NaVi76sKCnZKS8PyKjiWXTuooWnYdCF+4/BZvPD1TgX3Tle31QKhM1Mo7dZdiVzO2hdoruqcCeRPDwABgzMpztqjK1MWzaYbVyTrgrZhip/dojZq4JcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y/V6jZkf; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so4813016b3a.1
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450212; x=1767055012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tw36/s5nwa0exNv0eee1S2uesxu6r6RLUjOdbIOB9QI=;
        b=Y/V6jZkf/mGpyD/5luAkPqtfoXj9EFPOxCLwALGcToC8J9KMpVKR25l59/fS7ap2B6
         rd/Cn54HcOWAO5dgxycScPtWVTyNrdPprg8VfBm/lj7N4Z3jLiteqCitB2Qvz8sdvjwQ
         nW2GkFqGpYhBoCwbLR7QDqZmZtTghppt2bFJLUJ/o0Qw+34cO+1YvOAv1YqT9XvIfwSx
         3gsDp+OnbjY9OJdeEoQ7L6XnuVxOg9BniYo0gfZ0sEzoL1Z2YbgsObLqY6Gu03MetP8C
         Qo8BIl2d2yqwVV96/GnKD5lrTdVkPlFQNc20oK9q9tjo/E9nJpOaE6Vo6E2fSa9aJOjY
         0Nrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450212; x=1767055012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tw36/s5nwa0exNv0eee1S2uesxu6r6RLUjOdbIOB9QI=;
        b=RU2V1LgYmzctkVIHpeR1vYcJ4eHGxtkvjMmS2pgLLKegn4dcIn9cVw1GUsbVehanka
         fT3+znPOsu0hjZ5eC5rsrsBN0RBVVXWDCfpYk+OdOjKwOyGPaQJJ4Wvh4nMy07h7A1e+
         brT7E/jW8BOF14DAt1copTK1VewQk19EBIXoUDpbIl55swHj94Wm1nvyUm/GYzwOEgww
         2LHYqzT71mY+lotM77MMDtOT2MNAK94oqFuE9lGJf5jY9RZ1RiXW2j/p3RNzJ0KOycVp
         ThMQf6AnnoCPrWODbpj3FtyaCE4S/i3znfHfyIwBo4W75kNpwb5YxQsjLmqyYwrTSrHc
         7hrw==
X-Forwarded-Encrypted: i=1; AJvYcCXTF/hAWr5pQO4INHSABhJwI5SFPV69BxMroaV3JWwuh94g0deoOt12ls2uUvrXy9392DuM12YpPA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywj1+VXtvQ2WBXn+zt2xaBEkF07uvtqPj1MXPMIaxHHLvFJ5i8l
	s9EVblaiPKRdC32XeMT85s0QRyg3SA/+jDAiSIXVTOXAkvRZKTJgSvQM
X-Gm-Gg: AY/fxX6t2xoipNMX14l/ugBq4Qz2f+rIgLwl74XahUWi0QF1qndYviIfTz5TbdL0ku4
	Zc2XCVxYnltB/JSM8XR4K9V87eq68vN4W3HzaFBxJ+gBtqWdSm8RS8uYCPiXtmQ0kYWQdXUSf6S
	ooPD6bjcELKs2nP0QmtzGcEjvRBE+Qo1FMiGNm0ZvSGWMG51QQece6V07TAcmpxrEWruH1FkrRQ
	Iie0x+4JG6wR4Z6SdgY2axr55gDQCyi5iVdj9zcm+qFXPYUECZ0wG9R4783GMLv+4rsktinGKSr
	a8UZxn92NxDRNsS1Q7m7Cgf/GmbLLQmwnm482P7ZAMsBN+LZtpEqjExIXby2xvilkz0+2f/p5ye
	TPHhi8izvKUCbS0WaWtSzkaXa6aR6IJPTubvHNDp/cU99sM4TyhEFdgQ1yywyoIHSrbgYWKoSl3
	qI3/cu3k+gZN0WCT5P5A==
X-Google-Smtp-Source: AGHT+IEjsCg3FBzrgx6EoHwmIBW+1HUiux/g5F1CumlaLvn4e/W0KwtScQO/rMnbqN/e03jH/m9TuA==
X-Received: by 2002:a05:6a20:3ca2:b0:34f:ec81:bc3d with SMTP id adf61e73a8af0-376aa1f7e23mr12096378637.44.1766450212369;
        Mon, 22 Dec 2025 16:36:52 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4a::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7961fbb9sm9998773a12.2.2025.12.22.16.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:52 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 17/25] fuse: refactor setting up copy state for payload copying
Date: Mon, 22 Dec 2025 16:35:14 -0800
Message-ID: <20251223003522.3055912-18-joannelkoong@gmail.com>
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


