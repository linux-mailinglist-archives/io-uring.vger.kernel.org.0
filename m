Return-Path: <io-uring+bounces-539-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 621FA84BAD8
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:25:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2DD1FB2970B
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B1D134CEC;
	Tue,  6 Feb 2024 16:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="p5RLuW0J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA92134CCF
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707236662; cv=none; b=tI6fmglHYvavz7WqcnmGNYDwIlFEVVL5mjRgtwmZiSNZnU9aYUipJIhkKc59huT7FMVWSrE4i5cRoSg4pLI+Xqd+KBlCiDeFbUhlehIs8t0703X2wx0WdWP2qwDid+7SQyHSxLqlne8/UPblRaJv9f8Map++2XFiDIg4rA9maa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707236662; c=relaxed/simple;
	bh=iW+NquMWGt9Gqk/vv4bbPeGDI6UBStnYtNVupziAj8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGBKqO+kwzbcwi+RaYNk10WvV8gCkgK4co8f3ccfwnFYYxz0HQ11tC6z3bC76cdygns+DDEy5Sd9jH7ws0YLkj8d7UenGd79ii76pz+hWPHo0U/aG8TK0M9h32UfUWLDdX3yqTKPqy2DuinsGU7W0qtj1xRZh0nLNw6ysfNsbO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=p5RLuW0J; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-363cedf6a49so759735ab.1
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707236660; x=1707841460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UdoaioIXngn6g/+xmxUBVqHGk8dPSTC8+pDTCg3h3uM=;
        b=p5RLuW0JLhX4PIzCVvTRDTu2Nh1B9bVjG6BeuWLxUldztZKHtXRA1Xzci+a63eQVBI
         jWnnZRj5fF0zl+oVaS/Q+jfRrJ3f8i5o+hra51KhBqCu1l+PRUqDXki3N/7I4sWky9Oi
         P+O4iOYa+SF4ep/l7XsChioVG0A9ZG1IRfSZbY3GprvyHDHrxZKZogEdpJWbp2f/iHgz
         Y5zyqdE1oFQw0I2Jftam1tYq2k1OP9hHLyDxDqSnS5wHu5gu/IddOqiqvP4r7XsgK6Zr
         btARqD5QvVVwYphEP8mSae0ql8lb2uhmxUrzr0I7VpTDFInJgQ7e9HfDC8vRBoK4MZ/h
         wKJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707236660; x=1707841460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UdoaioIXngn6g/+xmxUBVqHGk8dPSTC8+pDTCg3h3uM=;
        b=HFOXQD7ZURwexGAm/gYaykbjK5c0REpEHKNMnQ85NyvZ08EVpFsh3PbkyOhldVtLhp
         sCFz88pGnlG5mXYU+pJEd0P8k0QdGDKDOzIBcq2ZHzSuYLkxh9rSTN1drLeMltmabuP5
         V/0NgmmwPRjKIS7k13zmZp8sXZCfeXXKuw28AceSXrs8hFJYCRWHXC3pcpTfnbWpdACJ
         l8aBhniMt4+7K3p87KJTHxBPYeXk/FvMwT5uQwLlH4RWTsVpEClwCA9fC0KvapDCJfdC
         azt6nQ3m41kqMOGWQosqB4DA1c4QYwwVMt0amLACXNHtH0+Q4pZbR/CkCAgpjGNH0lon
         ZUSw==
X-Gm-Message-State: AOJu0YyvlpwEpZNHnZ2tlpE7mEjN72Mteb0kzNuiMEDtt+o+9B6BcKMZ
	kzqrjREMFT8ZXDOgKHq9iuWb+xDdLMf0hsYyxPHgKIwGpwXdOdZIFJdTv4aAYAQxHPJJ9FhbCmC
	gKAg=
X-Google-Smtp-Source: AGHT+IGd2WwoIOPeR6d9HVP4RAsZdPoDivIitV5LvOSXMUv5J7nMyyv+IyilynHHejfy0a4ZdfW79Q==
X-Received: by 2002:a6b:f308:0:b0:7c3:f836:aed with SMTP id m8-20020a6bf308000000b007c3f8360aedmr438490ioh.0.1707236659809;
        Tue, 06 Feb 2024 08:24:19 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v17-20020a6b5b11000000b007bfe5fb5e0dsm520031ioh.51.2024.02.06.08.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:24:16 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] io_uring/rw: remove dead file == NULL check
Date: Tue,  6 Feb 2024 09:22:52 -0700
Message-ID: <20240206162402.643507-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206162402.643507-1-axboe@kernel.dk>
References: <20240206162402.643507-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Any read/write opcode has needs_file == true, which means that we
would've failed the request long before reaching the issue stage if we
didn't successfully assign a file. This check has been dead forever,
and is really a leftover from generic code.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 0fb7a045163a..8ba93fffc23a 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -721,7 +721,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 	struct file *file = req->file;
 	int ret;
 
-	if (unlikely(!file || !(file->f_mode & mode)))
+	if (unlikely(!(file->f_mode & mode)))
 		return -EBADF;
 
 	if (!(req->flags & REQ_F_FIXED_FILE))
-- 
2.43.0


