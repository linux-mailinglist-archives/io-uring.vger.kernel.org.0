Return-Path: <io-uring+bounces-6102-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44838A1A9D0
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 19:48:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87F7A1639F2
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 18:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A85AE16F858;
	Thu, 23 Jan 2025 18:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EHb0eymC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFBC15ECDF
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 18:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737658084; cv=none; b=u2lJF+B02z4vv66q9LzkB89S4hPXTlEk6BGjYBMKSlfHqRqWO76GZxjQdG/MmPrgjNpe2QyegvhrDmzTaG6fTQdQ1mBwmYWgmkWMceB9Nd5ZnimAWA/mIYxHBSrdKZ6A3aAgtR+LqYVKPyaMs7J8pv7Yq6mr2eBp3Gw4JaU5MO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737658084; c=relaxed/simple;
	bh=zf7UVRwWjGwfQQ59luxZG4Az/4/jvzJ9epQYq2eDWQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pv4cMmWjnD7CqAHknKPPS993cObLjdJXywJrJeR5EVg2gPM5ksbkq0yu0JrD5MUIPfNKO+s3TxoD/IekNVe0BPi/gW78wFXSz9blKfhDjLxfJJE5sUDegZsj6pU3D0mxSc79EYeLWwyMrNlk/iZ0wrX4INVOEeLssSCsgMebV5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EHb0eymC; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3cfb0ed6ef8so7149395ab.0
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 10:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737658080; x=1738262880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L/tfWCfmDuERkqFhjJUzPDvmxz7mAz60TOX3P5+350o=;
        b=EHb0eymCjNE58cfCsJDCS7OxFAc/g6dlP3OCu+4aku36m/kIvan3O2QSI94iZuQJlh
         nADXjzoPcbJEaQBA5kt/iGob2jXBcIObO0OXa2V2XvCyMPyccN3CAJW3iNDG+jmbN5B9
         RXchJ6BBq5Xtn6WbtJfALshuMz5gLo1SmRml1UwtHOuux32GahOSAi3+oNhAXzzstXlL
         qe7K1D1IINICHVT3M300XCuqDodGrjfCBIO8JTCsS65vOFoPm0rizHqwCBfs9wxn5Sx7
         mwR8coGVQNuTXHTAA+6wIw5IXJQLk5BN9eEo0V1vDhJu12VgzHZ4YNeca3VkYiqr0KYO
         nXlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737658080; x=1738262880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L/tfWCfmDuERkqFhjJUzPDvmxz7mAz60TOX3P5+350o=;
        b=bH4T0zlu1foLPyJjtkmQ67ARE0Te4hEnYFNhUeEPCGrAlZkesgg1UT0o5mZTWzK6fh
         fG75MtVDjviBQnrfu6Rh1MjBS91DaMoo0F0xtKS+l5gFNtldj2rkucSemPp+PvUtQ+If
         wuF2927LlVXV95kzmn8q0tHajxKLaYtZOgfNunu6nKYi/rCvFAs5pXhPwZuJaL/2mt9W
         4s1zj+Qc+f2+28lUuKsuXJiLzAx/8/1y8ivPJCK1lGxqXb/AxpLPhO8h6JtIX7ZMN4UM
         9ZB88k+QIs0p9R+n8V2xNE+Vy5K/j4Ag9pbGLCzM1KETogTdxaiSCkrPSY3wPVgOplCs
         anvA==
X-Gm-Message-State: AOJu0YxecgOCW2WfPwEPD+h1M/iZYTBk8xkgzibLLIIerLa0WGpqKoXk
	LXydNhE00X4a6awzdFYjtc6J45WwvapP3npqmLEdhrZGaQmwTZKr2uyki+SnNme7HRxuKgUp0tj
	e
X-Gm-Gg: ASbGncuRpkTUeZaN667XIFL6waLAz4gj0T9hjnpppzT8gIoSiAjU4V2TEN9QC8AJclN
	0rpuY59xL2FXW7NcKWRjPjrMkLzGY+dZBa+wD0d7Wnf9aSga+wUXlI8Ij1EJ3Qd/e7C3P6BOMCm
	oTNRNdCm5mrrz1fOhaFKor682kBi8K0/737Gu9WMzup/+aDLZd9KxODmCAhMCASE+g12jYwlRFb
	1KZ/E4O17WqozlyxTy5un6GWsUWDoId+wZunnOtOW9XlEcKCEqMrHOg5uU0BJZotu/AHfzHadfq
	BNafY45y
X-Google-Smtp-Source: AGHT+IFeQsdPT6QrMlPsXEpDFtenhbhiMyd9fM0PI9EGp6AK7ujFOoMcA2ugRnD38ZWJ3hZdfQb9HQ==
X-Received: by 2002:a05:6e02:1c82:b0:3ce:7a41:d885 with SMTP id e9e14a558f8ab-3cfc795b6bamr3384215ab.1.1737658080660;
        Thu, 23 Jan 2025 10:48:00 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec1db6c4b0sm53432173.89.2025.01.23.10.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 10:47:59 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: krisman@suse.de,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/alloc_cache: get rid of _nocache() helper
Date: Thu, 23 Jan 2025 11:45:27 -0700
Message-ID: <20250123184754.555270-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250123184754.555270-1-axboe@kernel.dk>
References: <20250123184754.555270-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just allow passing in NULL for the cache, if the type in question
doesn't have a cache associated with it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.h | 18 +++++++-----------
 io_uring/timeout.c  |  2 +-
 io_uring/waitid.c   |  2 +-
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 67adbb3c1bf5..ab619e63ef39 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -228,18 +228,14 @@ static inline void io_req_set_res(struct io_kiocb *req, s32 res, u32 cflags)
 static inline void *io_uring_alloc_async_data(struct io_alloc_cache *cache,
 					      struct io_kiocb *req)
 {
-	req->async_data = io_cache_alloc(cache, GFP_KERNEL);
-	if (req->async_data)
-		req->flags |= REQ_F_ASYNC_DATA;
-	return req->async_data;
-}
+	if (cache) {
+		req->async_data = io_cache_alloc(cache, GFP_KERNEL);
+	} else {
+		const struct io_issue_def *def = &io_issue_defs[req->opcode];
 
-static inline void *io_uring_alloc_async_data_nocache(struct io_kiocb *req)
-{
-	const struct io_issue_def *def = &io_issue_defs[req->opcode];
-
-	WARN_ON_ONCE(!def->async_size);
-	req->async_data = kmalloc(def->async_size, GFP_KERNEL);
+		WARN_ON_ONCE(!def->async_size);
+		req->async_data = kmalloc(def->async_size, GFP_KERNEL);
+	}
 	if (req->async_data)
 		req->flags |= REQ_F_ASYNC_DATA;
 	return req->async_data;
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 2bd7e0a317bb..48fc8cf70784 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -544,7 +544,7 @@ static int __io_timeout_prep(struct io_kiocb *req,
 
 	if (WARN_ON_ONCE(req_has_async_data(req)))
 		return -EFAULT;
-	data = io_uring_alloc_async_data_nocache(req);
+	data = io_uring_alloc_async_data(NULL, req);
 	if (!data)
 		return -ENOMEM;
 	data->req = req;
diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 6778c0ee76c4..853e97a7b0ec 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -303,7 +303,7 @@ int io_waitid(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_waitid_async *iwa;
 	int ret;
 
-	iwa = io_uring_alloc_async_data_nocache(req);
+	iwa = io_uring_alloc_async_data(NULL, req);
 	if (!iwa)
 		return -ENOMEM;
 
-- 
2.47.2


