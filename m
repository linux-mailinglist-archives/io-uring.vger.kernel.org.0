Return-Path: <io-uring+bounces-11266-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E0590CD7851
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:38:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0E8F3300D14C
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93E3320DD75;
	Tue, 23 Dec 2025 00:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k3a9VoQE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289851FAC34
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450211; cv=none; b=Kb0sDiFik9NrUsnURIB21v2vV1Djyh6WSoJKJpThW8xm9FBeGOSw5AVOMJQJUN9U9esz2YtAf27sGln2l2hxwIhlUgC1OTGSE7W1z85hhQrwou5qod7NZl6nK/c5whOri+v6bzfcjY6PTHZhKJKr5E6QDbb2MjWkK5XESz/ERJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450211; c=relaxed/simple;
	bh=7StnbW/TqmHUc1vg9s38n043pYlTzeZZxclo5H0fKUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfYaapBdjUSrXogwcL6AZZUO4d/WPtWrxYRuoI4VCrq8O8Sjg6aTGKM5ryYizIh1Xe10NbJDyocvYg6ub08y2YFVurAYal72Ilm5JSgLrG7e5/Z4Yrwit7AhVBmlJdqe7z08RoznLdCGiJ3PGrbt2j2o0RqkglzIaa4gC19BHgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k3a9VoQE; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a0d5c365ceso57348145ad.3
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450209; x=1767055009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w+ttqcfQ3T5zSOFv2YhovKb1gWr/JPYacZE2ZQZbU7Y=;
        b=k3a9VoQEfMtFU5eFpe8Ramn6QNsP59pf8Ut98dfXo/vtPxW0Cmvg98i1WLMr3KvbZf
         kUSLgxzeE/PxXSyLj3vi3erdlEaHnyUiCAI6gC9Y6FGglMA0nrsW8jOjc2TAMbzt6F3+
         8TMO1TIwv/K+x+FVoN0uXbJf6Gsmk564H1FVFfD5DjI0KBKmhr42yiSNmMrsGRJwkyL3
         i2QGwN7Ayf5EnGHlcfwEsDxlm/cBixqARdq/bbB8Hpwq+oYQzSVO8fZBx40lbWwpZ/7I
         tCjE1CQAUpSWf6nOWjJqFn8+pJE5FEoi28OGfOHl3jo1DVDJgOHylG68yZqj+4NGYHKs
         9HKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450209; x=1767055009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w+ttqcfQ3T5zSOFv2YhovKb1gWr/JPYacZE2ZQZbU7Y=;
        b=FV94PEGrfIEqdgOtMT0mM/ZlWX1mZUeRMBZx3caud5kfX1njhEFeXHRLu9jCnFyoMA
         eiWRym25ypQY2C5R7+oydGb8fc3Z20nno8FvzjzKcxGW7k4D2k5rQTXk9yU0NKSVnrRG
         8lOqlwi7XWnH3h1QBTWC/0xUItPkibKrzbwK5/nv0aUJtB6sNefhuWnJUjyRdIJFwkuK
         pUZHEccKKA6yydSKekl9UUQSpxeZ7CXvB1+UXbv21CxODh1x8RMGVl13zU4Mx2BUl6Sm
         jPoOqytDZg+kTllcXzVWM8h6pC6WBHbPa2ERWP1MgdOq8i4q3P9RyQaYL8swq/kah8h3
         UppQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwN5Q0QI1Q1O0uw/3LoTGPLXiYsWsibD57e3Z9TNQx3phpm18blz6g9z2GOyuguEWJj2aIlyw/Nw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5cjTh3aeQW8X0FVeZvxP5+d6fhaI9LOeLIbwMMFTOEpP+CcmN
	5X1N5eKps+K2rgcaQHhoq6HOYETLmMlimTGuRfeqm4jNlB9qheWonir7
X-Gm-Gg: AY/fxX4b5nK1YQraq8s2W/BexCvOOFJ/95TZC39yvtxZFHKPivI+Erx1X2d0OrHu6Bg
	5efdpTdkYl1C7HxpiqoVx9Z7r4KZmGW/UXpiz/arBhncalUqvlSkQ8GZKdao8U4XPivMFqyNd0X
	iltd3ZmvGwnUSGaNylV+u6eUstQAMTyAogS3V5nnOiDctagQoalsC90Vu3MI0xJkYN99kgfryCn
	m/A+5YsYWDEjuiCDpN5TL6nUMqIHx6LWCA089oqQaDq0j+Fa1laGJGI8VYtxGO7jnfDPF0vsUx9
	0YTG/VOQhx8MZmt7N4GbSbL//vO5pivj4o4N7EDrz3cYaza/XlyfhRMBbR77VHn8/H1P5ShBcrQ
	s5P/6BVxnqTmO7xe8nVNB3fNfQMxUDt7RIgrDPBX5BbxSzhsCYnRR+08/D51yy/l/UMGl/WYDNK
	mbaMDOuNGDiOZnGaGi
X-Google-Smtp-Source: AGHT+IEG2ZslDRIBVszUST8fjCQfpuscl1VfHChhLWfIfgGL+anHgSStZkgHL/p5tjHNzxd0QrnJ2A==
X-Received: by 2002:a17:902:cecd:b0:2a0:909a:1535 with SMTP id d9443c01a7336-2a2f21fc33fmr129619795ad.11.1766450209461;
        Mon, 22 Dec 2025 16:36:49 -0800 (PST)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d5d566sm107593665ad.71.2025.12.22.16.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:49 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 15/25] fuse: refactor io-uring header copying from ring
Date: Mon, 22 Dec 2025 16:35:12 -0800
Message-ID: <20251223003522.3055912-16-joannelkoong@gmail.com>
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


