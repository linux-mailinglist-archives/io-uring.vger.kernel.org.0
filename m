Return-Path: <io-uring+bounces-3925-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B64379AB7F3
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 22:47:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 35101B23943
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 20:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C641CC8A8;
	Tue, 22 Oct 2024 20:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eZUPPRhH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F011CCB26
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 20:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729630039; cv=none; b=if479KgoL3mLOqpCllJdOpPQgYdHDGkHX6dmuhMYTP86ZSSeS4zBRtR7Zp43e4bOSWoeTcCfvXl2fmD+f1zTy225yUxtZ68M7oVSl5t5HXCBe7sbTDRGXxiqtuysdepO5nK/k5WKc0QjX7vxgb+YEeD8r8Az0E6WCB+2mbakkF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729630039; c=relaxed/simple;
	bh=GZFcnp8e6oKtOWGxhWNVOdeyzjAZyESeFuthurBmm6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEDDl9rBUe1zY4CGBQdtXzEmuDP7qiszb8MObV585JQ360mRJm1W+iYcQ43PPzaTpj8S9tX1GEx8ZjMVfThiLz0hy9qDsgGKEitGOM4n8kXcS9Dzq8meHXaoBlz3EEYJ2c3SWEtVQzW0FUN05fOwzwNOCWY7MBcYnRucCuTj7/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eZUPPRhH; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-83a9be2c0e6so256020639f.2
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 13:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729630035; x=1730234835; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rnB3Z5RN4D4nRt88SitGDzm8oQVB+v3nAzJn2IwfJqg=;
        b=eZUPPRhHy+RF59yjSrF5WMdWFyJAJgvpXTDkY9pvDobW8gCfqHEtU1Fdus+AT2kpmK
         uifpBTf7u5MPAOLCL6EUnf6Fdk/lm3gVq8xwRDAmczR7q3aM+WsjZHMUzrGu5KgKo8IN
         oOlX4YuVNX6gCx6LHlV455fwQvoLez9fvRO5mWP8/FTjtoxdvmN/OLJxzh6eh5HcrVhH
         4OZLeK+rd117pxICSnKOpOp9/C43QDKNPJn+roMULbotuo9aXYWjxlv8kovW2K+t+tkD
         ItRo4tRNsS3awk/oF0zPrr2g9+fhtvni+mpr98lQzI40KmHruMiV0dSLH7y9ugPrrpId
         ZMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729630035; x=1730234835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rnB3Z5RN4D4nRt88SitGDzm8oQVB+v3nAzJn2IwfJqg=;
        b=U/09lSK5srzUmI4gODF+DGBKhHhFdQXL5xYGqFrb4eL2TQWd4K47OLUKXlpsuMjB/x
         LReEAn9A4Pz3rpJdulxy6jZIApFJ413BChk0Opop4jK+CYx7jjotomsG+ZqFwAfbHNAT
         eFo1tOUW4uJvnmiUb5D0ws5aGKY6IkbMz/TQXW+U88CFZHVlH+daroE1DRYd1mmzc2Ja
         8NYNcg0+D0d5yhcXrosYuys/73qEHeWR8sQK+7ARBDLuu+DhFDkzyuGBBMxTcZBY1tYL
         XWcnh+tBHQj3MF0dVdou0By8bAExjsUeve8rOUNOCdOB1tdRH5H2IVnH0tKCKzNJq6uf
         Bj4g==
X-Gm-Message-State: AOJu0Yzwi4rJSDql3Aww453/0IvYxCErsFL4aMZdEi13GAGBmkQbtO1s
	8dXy/FdTL9jEXpsFPZa7+TX09M4IfsxIV3X7ayrvzVkhfrqlu1SIvvJmfXOZo2mZ23v27INRxfF
	a
X-Google-Smtp-Source: AGHT+IENdFegKYnMxsMfZcAq79NasfRpIugE6qYkSA+aCx8GxhHw2Su9GdI8VLUXa3ljDygi8L/j0Q==
X-Received: by 2002:a05:6602:27c6:b0:83a:b0e7:cd5f with SMTP id ca18e2360f4ac-83af61633a1mr57829939f.6.1729630035445;
        Tue, 22 Oct 2024 13:47:15 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a5571d1sm1697385173.52.2024.10.22.13.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 13:47:14 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: change io_get_ext_arg() to uaccess begin + end
Date: Tue, 22 Oct 2024 14:39:03 -0600
Message-ID: <20241022204708.1025470-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241022204708.1025470-1-axboe@kernel.dk>
References: <20241022204708.1025470-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In scenarios where a high frequency of wait events are seen, the copy
of the struct io_uring_getevents_arg is quite noticeable in the
profiles in terms of time spent. It can be seen as up to 3.5-4.5%.
Rewrite the copy-in logic, saving about 0.5% of the time.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8952453ea807..612e7d66f845 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3239,6 +3239,7 @@ static int io_validate_ext_arg(unsigned flags, const void __user *argp, size_t a
 static int io_get_ext_arg(unsigned flags, const void __user *argp,
 			  struct ext_arg *ext_arg)
 {
+	const struct io_uring_getevents_arg __user *uarg = argp;
 	struct io_uring_getevents_arg arg;
 
 	/*
@@ -3256,8 +3257,13 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
 	 */
 	if (ext_arg->argsz != sizeof(arg))
 		return -EINVAL;
-	if (copy_from_user(&arg, argp, sizeof(arg)))
+	if (!user_access_begin(uarg, sizeof(*uarg)))
 		return -EFAULT;
+	unsafe_get_user(arg.sigmask, &uarg->sigmask, uaccess_end);
+	unsafe_get_user(arg.min_wait_usec, &uarg->min_wait_usec, uaccess_end);
+	unsafe_get_user(arg.ts, &uarg->ts, uaccess_end);
+	unsafe_get_user(arg.sigmask_sz, &uarg->sigmask_sz, uaccess_end);
+	user_access_end();
 	ext_arg->min_time = arg.min_wait_usec * NSEC_PER_USEC;
 	ext_arg->sig = u64_to_user_ptr(arg.sigmask);
 	ext_arg->argsz = arg.sigmask_sz;
@@ -3267,6 +3273,9 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
 		ext_arg->ts_set = true;
 	}
 	return 0;
+uaccess_end:
+	user_access_end();
+	return -EFAULT;
 }
 
 SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
-- 
2.45.2


