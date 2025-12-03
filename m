Return-Path: <io-uring+bounces-10914-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C0665C9D6DF
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:38:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2B31B4E4C61
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E5D1FE451;
	Wed,  3 Dec 2025 00:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bmw+/6B1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E91226541
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722224; cv=none; b=fkkwRPJyrbqWjVPA1qi4IrcApnQJMBQxMJoPiv51hlODPRYF1FOa887pOzMLtmnv2lIyj+ihkbQ9MGxji4MXDygJbEpZqDzW2PNuw6EwitbGbBBUkXY6GN4JifWXXjdZ4e3LRMnQOMhMnh22dPGhpAumltjDton4J3DbCT6xKhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722224; c=relaxed/simple;
	bh=ZkMe4/6Dx+pmQX8ki8G7Upa84OZlBwKQ3m0/1EW95NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bF3UW4IEEoOnc5K32PcSpNxLoKzE/MnVmVg0YbmJV2r5BYX9gHQdVRd//goRUgjtY6Y4SZ+LP2ZxJe0xD7bFqoCux+YkuPvAq5Xmcsmj65jlOuYyNzj/JfJlEfuR74FRXAcmB+0/lwvP5muFamuIynCBEJTMRYl4/ao4MBqK1Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bmw+/6B1; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-34585428e33so6361883a91.3
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722222; x=1765327022; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tw36/s5nwa0exNv0eee1S2uesxu6r6RLUjOdbIOB9QI=;
        b=bmw+/6B1d33rMRKj5To5fsK+H80aXlzw+Lj4YEEmhhKzJO82odB3pcU0ktbDaAJdak
         UtwkSti8J3vPBAloAeBX+7UuRZJZgwnOTeZIBDMH+8zWpdotD3fvDtjV7c0Rwn+CtL7N
         UI0HCfQkvi98d291xDeGvidNKF0ljUw6GSdjFcKhLOWeYjbxU1UHlu5Ev+zio7rfdOy6
         MCVjs++3/j06/AOBi+q0qdcPp9qWancee7vDD3iP+MN0Pw3JIWR5rd1tKwrJvAVIPMPm
         L+TsZ0Yrr0sgi6ul5lQ+hKI3J+trm8LmnGVcknKcr3ioA7IucyE6K+9RGMuW6U0Qho7v
         hMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722222; x=1765327022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tw36/s5nwa0exNv0eee1S2uesxu6r6RLUjOdbIOB9QI=;
        b=Piz4AECJLt/6YFyF/RPRPGJnsSwqTWIxhTnApRbqCRkzANJV+9wCtlU2rYvrJ5jvdG
         Qpr4wdslDS+BrycfOfEIE5eibycEYauWe3TzgGa/OivsJkteMWR0yVXqjY008XuncbYB
         OcMeddnWV3qOUnMDp6O3y0PrW5DicsMhleAqBBkOl0fMXDDIbuKp9JdPCcw8uIRz2ho2
         SCbZA5dFI6VaUnJQJjDvAsjXRLKF5IstA04xxeogiSroqfOKe6OMMSH98MpbYlFKiLHD
         abVgwXHqbYXo6xAjL7DW35PaH2WxfUc8af51E8zdx8Drij96N09D+teRKhvOetFkZU14
         CWzQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5DkFMLRlZ7e8+rKbLKqPn8GBfFiLQv0SQfFbl7hSElpWChXQH03DEW/YtjbI9vui20Gjfurn4vQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzNM0x9kHYGjCGZ3Zjeo6xuOX62hiSBL7lJ1A5WdpzJu9ABmrXR
	2PgIdhIijc+QP05nQ1PIRkJrLrMviWHRQ3Fpsmar7vIcwRiOfaXykpQm
X-Gm-Gg: ASbGnctEboWnlLiYeF4uTDiUyzS9uowEyAoY2xLAIg2d2mS8jeS4a30Anod+J/D5u4Q
	5pDAz8DVPfgrU2uZpCdhdnYwMQ6q/TX20t+wHC338IXz0qKB0DDwiz0aZDWaT2s0RscE2EDGYuk
	cCQs7X4xqeut8ZD2ZZfdShh5UjKZMZGydxhmjnMEA+AwKfR8tiy0MHQbNYyhDcxpy+w9HKr5eAG
	ch7pSuhBAMkQY7PbAT0RtUp4tKnhfiCjVsbCes1qPuOsYZLw19hYNCzXenWNYRup5PrXDyUJ5Xb
	K7Fy0WEcL3gcTl/ij2muGt8Jg7czsjazQ883L+Kw7o4+jFdAwjD/whjTrG1HGzYXfEwDO4fsl1x
	hNEcsat7uRIHouhUOtYH5fFQqewbiRj2xNDgA95zmiYw4I+UxUN20srFBZoVSlKdXG09GPDieOP
	nVFiP4+4FjnUEtKIlfsddS13ei
X-Google-Smtp-Source: AGHT+IEfQBwfERL3tHhQM9LIF/pf665YqQMJW9YkdHylacss2LHAlfTrA7E+oLb/HwDCseUtee8Dsg==
X-Received: by 2002:a17:90b:3e45:b0:343:6611:f21 with SMTP id 98e67ed59e1d1-349125ac880mr527379a91.1.1764722222047;
        Tue, 02 Dec 2025 16:37:02 -0800 (PST)
Received: from localhost ([2a03:2880:ff::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34912d27040sm144072a91.5.2025.12.02.16.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:37:01 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 19/30] fuse: refactor setting up copy state for payload copying
Date: Tue,  2 Dec 2025 16:35:14 -0800
Message-ID: <20251203003526.2889477-20-joannelkoong@gmail.com>
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


