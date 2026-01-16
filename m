Return-Path: <io-uring+bounces-11783-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EC8DD38A2C
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:32:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 74EEE30A39AA
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:31:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD38F318ED7;
	Fri, 16 Jan 2026 23:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FGhxS76w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A7B1FE44A
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606292; cv=none; b=nJPFdPhUPgMEd3LYdEC0EfApZnHbW7nyDgYJr6vrFcAsNGKcsEz/VuWnzXT548lAZlbcejki2g2t+fwqwuVmaw4nAa6/ZNPawGf0edv9mJFAQxgUckUjyOrdkIsJe/VOKd9rJXxbiylZaPfIBFslNHq+3B+ylvfa14/ocTRVitM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606292; c=relaxed/simple;
	bh=7StnbW/TqmHUc1vg9s38n043pYlTzeZZxclo5H0fKUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0Ac+CQGh5fOZDAyYdiHU5laji+2oM79Z7kZ9xwgZG9Fzc4DeNFZrDDd2rAusHJDI+2pK6cbzH9WMoz9h+7g98JHXGQKyfgyHCZV9GjGD2GYdLEeQcmP197TC3NnrmLe8v4VrGJZBIQLU2ZrOoR/3juGahSr5TKpk5WGfrYtXwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FGhxS76w; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a0c20ee83dso22991445ad.2
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606291; x=1769211091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w+ttqcfQ3T5zSOFv2YhovKb1gWr/JPYacZE2ZQZbU7Y=;
        b=FGhxS76wty1orKznut30+WppXmYBESFeGJjQFo1aY3CsQ1mXZj6gHEVCZxLImilcK7
         rIXeMT6O33MdRsY5qYAPUG1snqBRlKNB2T+TqHA5pLimU4QaQsNRT1JDsR4BZCJavDn4
         UTpK+DwOhiaNmRZPgKuSp5RjuEUtfNFBo5TcpH3slsjKgKH5Qjz8C9dqcKFT6BIMkZq2
         vXXJZ/ICo62JepIkh/mf8TezGoa1z61gG+Rr8CvAn5g5LOtZmi9bidIc/HOyIebPM9XU
         UroEs4DHnFlTHs97cQZNtuqCVmSnDCU/ib8ZHLrLpRRwAkJ0ohCpWTTycF6ggfA8Ll9y
         NR1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606291; x=1769211091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w+ttqcfQ3T5zSOFv2YhovKb1gWr/JPYacZE2ZQZbU7Y=;
        b=Buh5CY6dite/vfzdbJzY1kJ47ImvMof2NkJWGjKovkjR7H/zu31fLVUBRA1GlH9zxl
         LhDWUkwfbiL8NF9M8vES0+a8EAanF7Hw/9O4oqgpp1PHJRX8kxGDuYsegU9bLGrbW8y1
         HJYvBh08Bu2NakrK2CKyJpajFWt9wmsSedvTRiuzOBO6hg5tz4L+qsjaMYpMHj459Uev
         i+VbXpHAiEcF5z1x5ipsmp6ZYfXxiGJYreH8e+5oNg0DOV+8zjDacPjo7iAJdpcmaBfB
         Gb6Iz2IVdYXBNsjpK592ojOohKicNqRt23Fkk46Tl4OI8eXZZdSvz9SCcjSrfeo2A6H7
         KD6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVaRXYbBdPzzhudHwIAQCXwurjjkY0CeyWJ5916zjWUM4pvefh067gnAfaWmi0P0Drz/oNP97VyRg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyver7snCUXuLIwLwukY7J4HI65E5F68//SsSjn9elVykCPsKWC
	E7ND2Qvg6Oem/u4YuUGw5dCk6Zgy0QkbxdWkXZeMXrJcDC7kIUg9WuAM
X-Gm-Gg: AY/fxX5plbbDvY/QH01scIufD6hhLkgTbeemBa+8ThwtQvDDfScC2pN4AmF2IOZo7/7
	uYBfXi+Jb4oFHJSnAptyCNYqbUcm0xHq0BtwADSxUye5WdS5I0NOF67rCWWrQJw7Q2LujzDmrEi
	Yk6W4+V2qLjSwsnKR/zRRbFwq1NZ/aQqZvDzrpZZkaKRcp9wDRO6lBPn4Ow+SohrWUmNq374lS/
	+W3Cn/B2E9YFElE2aRDdT0LREbPAp2aLuCokUP7gLtBgl5qz9rKf3wdQctKG5IIPA0NsXfLQkBr
	KDEWcBUaokk/Kw8QIyDeFS0fTISn3yTvIcEOKrbXluf/x7EbeAvGQ2CPEqAhXVa799Nw6ID9TT8
	JRvx7LjDQ+/rT1NE0YDSvLPrcycyGp1+xhT/x/8qVZwH1bUVRQXUTYcmsNoCvDxeTOp82rF5Iru
	/EC8NSvQ==
X-Received: by 2002:a17:902:db0a:b0:2a3:bf5f:9269 with SMTP id d9443c01a7336-2a7174f0127mr53253535ad.3.1768606290943;
        Fri, 16 Jan 2026 15:31:30 -0800 (PST)
Received: from localhost ([2a03:2880:ff:44::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193dbfcasm30757085ad.53.2026.01.16.15.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:30 -0800 (PST)
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
Subject: [PATCH v4 15/25] fuse: refactor io-uring header copying from ring
Date: Fri, 16 Jan 2026 15:30:34 -0800
Message-ID: <20260116233044.1532965-16-joannelkoong@gmail.com>
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


