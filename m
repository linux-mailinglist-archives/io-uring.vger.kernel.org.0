Return-Path: <io-uring+bounces-9719-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D3838B523D3
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 23:48:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6DBDE7BD8FF
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 21:46:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1228C2D1926;
	Wed, 10 Sep 2025 21:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NbLJM1TI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856F13093C9;
	Wed, 10 Sep 2025 21:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757540862; cv=none; b=oRbwX52emTWsKxMBC1eu1sVZGhdahrSbZdSDbkQXHgircq6zT9ll7lexaKm5S4wwSimu3GUxArLabKWgyyfpnjqnwXmd8WLZhij9GeVTb9I7QR1P6WGG5g40EUJ54s2DXbClmvnBJFgH6DYr9ywRcnfnQuRNj693WnSCP8J1tzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757540862; c=relaxed/simple;
	bh=GhbGsRZIFWwACCchhCI1wpT+Z6yk4SfcgM3GpwKm+3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oysEZ3vBNvlhKq0bcpldemU1axjL3nORW+nhF6Rbof5lvHMH31kgmfS8Z7a1dBalzFc358TepXqfeAzup+zbKDvjlTSMAyoWc5HGwFde3aGzaFSnHYPhAU2tfAmnBtmLqt5XpeEWazOp8Akw7+lnn26PCobbKAOqbExqfYNG4vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NbLJM1TI; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-77264a94031so47127b3a.2;
        Wed, 10 Sep 2025 14:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757540860; x=1758145660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=epfohba7lLb94CzZQeNzguTuJKCwE90c2JR8b9B+3/Q=;
        b=NbLJM1TIATpGdDUobY2yCDFhgE/mQ2Nr7oPcFPkVBNQt6JW/dotPuI22t+kpBg5imt
         7WABXwKM3UcfsZ8nS5JF0helbdkwA7x9Qj5hx7HJ5UTNMs+YK1v5MDwErYILECy/syBw
         tiefo5zfclPwKwdDMIaTBYdvQFjTn5ZyUnBcR/mv9f3KG98uyIhmWCBB3eDf4VuV2NIW
         FqkSj0882xpYovy/OedS0/twNFNoY0A69OYpKLJxtMzG0Q4a19wQf9+QReKyTIOuIrDH
         eGrUU2lnG7lnqx8Pgl7Ddb4eLR4EF+u0Xi35e0nBVu0Ch+lxAeP0aSazh/IvZJJSBRzP
         QsEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757540860; x=1758145660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=epfohba7lLb94CzZQeNzguTuJKCwE90c2JR8b9B+3/Q=;
        b=QeYfKcM7iaooEE8CaMFUhVqw0sLaDA/YR96snfa630x49ma8xoe9lgppg8jlt/dT8I
         Uy/YqyRCRKuE5nqAorAgTZa5VT0rJVtXw4CPTtZli82z0GsllhsYUZRql31M9Vxl+SBp
         C1SCewPSByowB3wLRAQ371n9GCmrHCtwPw3UGrSGERKmppfAJHf5VFdMnycoEQlOtl5/
         D8rhg9mOipWF4Cwam7GHNlLpL4uHzOVksiCrI6v9goXR4DUh4FUP2G8SqIPJtvjjeX8c
         xNDZYMVwLrUN4Qgc8SZrfNbLkB0xtaKQ2EUzT+l93MPKFbDYAl7qDJtFK4JA75o1eYJB
         Srhw==
X-Forwarded-Encrypted: i=1; AJvYcCUZhPiDKcDUvZDFG9uR7JAt0HT3mG/Okmqdynbj0QIVjLVduoAaqGuhzjkllhMrUAHttVSrk8ldLfaf@vger.kernel.org, AJvYcCUyMsQVEf6te8669lx5ALbBDhAdu6DKJFF7ZTaaRFX102UgjSqM9fOH9pGMvWj0QSj/OUhhO9q8yjjn+iGd@vger.kernel.org
X-Gm-Message-State: AOJu0YxWvvi2sslrqnv3BTlWkfwjmbd0m475dNBlpkQeJUun5W7FxJy4
	G7yQBOYqcBlxOfYfuqINSQcwWueBDtJfhghD3j8YkqE+EQmGQk+KfSvO+dpkYb/W
X-Gm-Gg: ASbGnct5h7MvUoRgLeKszTvvfrbZR7qvI9kv7R+zo2eVKHQLoV7jjdUUauhmCKSqJQx
	INDiEP9ItSGBIi/TMOe8/wmIg/c/V0Wnu3u4/3qLeqfrtPLQUnKCK8cpVtbd85wofxO0rqWhUbn
	qamfn6mnQSXlZSANeNuxqzZwmUOEo4cZVoFwdeDRQoqwxHeh4Sa/HEC0oGND/7K1k431Fb+qUEp
	ooLt4pxkTCBM/g+KntTToiX7qLAsaqhV+gPvBkSJGAwW331sLJOCNoTefxf85mbU9c35V2T5FIA
	UhyUj4HgDejhBwbGi0UA3u5Qrpv1iJTRXrNzTSuRM3D0tsj7X3ZOrKvlJYsT8aY6Mx5Q02qDE5C
	p+7+uWJyu0WrJJj83gw/6Spf+6j6UpkTSdvhBt/uhcr3/Wi0=
X-Google-Smtp-Source: AGHT+IFRi5duAP8YunR1E24mqJnjAADhiIqfFbCEhB10CJ0A8Aw7ABcpn8NbHY3NAnUy1VeXYuEwQg==
X-Received: by 2002:a05:6a00:990:b0:772:57ee:fd6c with SMTP id d2e1a72fcca58-7742dc9eb1emr21128115b3a.2.1757540859688;
        Wed, 10 Sep 2025 14:47:39 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-775fbbc3251sm2422516b3a.103.2025.09.10.14.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 14:47:39 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH 08/10] io_uring: add __io_open_prep() helper
Date: Wed, 10 Sep 2025 15:49:25 -0600
Message-ID: <20250910214927.480316-9-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910214927.480316-1-tahbertschinger@gmail.com>
References: <20250910214927.480316-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds a helper, __io_open_prep(), which does the part of preparing
for an open that is shared between openat*() and open_by_handle_at().

It excludes reading in the user path or file handle--this will be done
by functions specific to the kind of open().

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 io_uring/openclose.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 884a66e56643..4da2afdb9773 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -58,11 +58,10 @@ static bool io_openat_force_async(struct io_open *open)
 	return open->how.flags & (O_TRUNC | O_CREAT | __O_TMPFILE);
 }
 
-static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+/* Prep for open that is common to both openat*() and open_by_handle_at() */
+static int __io_open_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
-	const char __user *fname;
-	int ret;
 
 	if (unlikely(sqe->buf_index))
 		return -EINVAL;
@@ -74,6 +73,29 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		open->how.flags |= O_LARGEFILE;
 
 	open->dfd = READ_ONCE(sqe->fd);
+
+	open->file_slot = READ_ONCE(sqe->file_index);
+	if (open->file_slot && (open->how.flags & O_CLOEXEC))
+		return -EINVAL;
+
+	open->nofile = rlimit(RLIMIT_NOFILE);
+
+	if (io_openat_force_async(open))
+		req->flags |= REQ_F_FORCE_ASYNC;
+
+	return 0;
+}
+
+static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
+	const char __user *fname;
+	int ret;
+
+	ret = __io_open_prep(req, sqe);
+	if (ret)
+		return ret;
+
 	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	open->filename = getname(fname);
 	if (IS_ERR(open->filename)) {
@@ -82,14 +104,7 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return ret;
 	}
 
-	open->file_slot = READ_ONCE(sqe->file_index);
-	if (open->file_slot && (open->how.flags & O_CLOEXEC))
-		return -EINVAL;
-
-	open->nofile = rlimit(RLIMIT_NOFILE);
 	req->flags |= REQ_F_NEED_CLEANUP;
-	if (io_openat_force_async(open))
-		req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
 
-- 
2.51.0


