Return-Path: <io-uring+bounces-3944-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90B319ACF89
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 17:57:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A25FF1C23761
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 15:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B85071C876D;
	Wed, 23 Oct 2024 15:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vTRJxjFc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB7179C4
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 15:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729699007; cv=none; b=BEAT3nbzyOMP503KUlUdrLRocp6PzdoVh6GVJZLYytlj//lXXGQlMod27nh8/A7RNEZ1e88f1OOd7ZgsWyWIA6xhiRS/0qrUhlp3rw79yvWMMBhnFQkPy2OsAqmqgXCY3stIVWQAk1P8GFqYu2IDTwQ4ufK1jCgU0MTO9rB6R1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729699007; c=relaxed/simple;
	bh=azReeC6JDM9vl2bxhBAJCZSFC7xE/Zte+PZEVTChuyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K223ZX23ByalPa1nZt0GIM602iyTFQ25kewGb8UM4C7O2l/rzA0peSJviNgTb35dI8XSeVOOvTEVr6ENm7q8jr1EvinepiJ689gdJzR8d6oTMs53ugqCsj1pqz15r0HkSt/lOYvO1IPQAFNw+Ci+BoK0aM7LLFk+Z6smNC4DyJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vTRJxjFc; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-83aba237c03so237279639f.3
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 08:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729699004; x=1730303804; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HYtrenvy20ANrIpWXUBY1U73jDZWvmvz372HYOtJ4d8=;
        b=vTRJxjFctGVmtgyW8ZQoyA76GiEG/YEvbqzfBaOoawrAD3WeZcI1e019R4bkdsTw2j
         xt97pAchLia7/WcI4C7B0v2HHBjwrGBWECbrp+oi9L/ySTcgpfLpWLVvsjyy6N5sEEsw
         rYtsN+1228ugJYDMoAFw/ZRDpLpOceuR/o07u9PduBMcg1ZrJnY38pVjj1+WGw16I6FL
         SWgM3iL6nKZJpQaU+z2dQAXX2uQK1a/eYG5EyCN/gbgpos2WboEDLK5Om9oMBDDIhVj6
         EyADRRY1QGiL4fOGvHLEQXYpI59tnOOBp1QowgC44K5lTtSc5VP23caAKOpkxIMakr2N
         llgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729699004; x=1730303804;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HYtrenvy20ANrIpWXUBY1U73jDZWvmvz372HYOtJ4d8=;
        b=nVyAAv4oJCKzz0Ef9NsAtpUd6MQR3k1vA280A+Zsoln2Py7fZXgRRXzdZm4ocbRYH2
         eS88iqmchOXL0r6HJj/V0LvzV00tfruDt5ouFekPXnYEijULTa/2Np1TCaQcPGL4mv6s
         tmic3YmGfRzhgk0umJ7GgDuXTgYeb5wt5kKSSR+Dao+eLMg+z+u9kjwexLuZDqIC5hPB
         Zm4s6i+dLPQQoLBskXoio+q0aC0c3RYwOnK5/JNqGK+wKQisOOqVG34356+wBwGLZP6d
         QGG2YxskkB98nFqq2gn+lfcLG3TUioR5tQswQzdRJA8//gD9M5/s8cr77UfIpeQs3fKw
         xPMw==
X-Gm-Message-State: AOJu0Yw7qzMkfQAbNi8lGvgjyFL1gGpeasrtPdMrqTDCTcGvHmo2t0ii
	7LtJoSeVnRuYLnRzsvIAzD9nPx7Cdk388Q+80rs5xFcKDZDCeWnqX8es5J3AMVIRc1RzGAHbvQJ
	a
X-Google-Smtp-Source: AGHT+IHQcEcSEF9VOZ6cZo69i3GjwSflhGG+Be1HLboJwZyBhji+Z4AeUZu5mroCxg/SYUO2iWmLyg==
X-Received: by 2002:a05:6602:1482:b0:83a:b364:ff10 with SMTP id ca18e2360f4ac-83af619a291mr316848339f.9.1729699004255;
        Wed, 23 Oct 2024 08:56:44 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a6091bfsm2131572173.97.2024.10.23.08.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 08:56:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 2/3] io_uring: change io_get_ext_arg() to use uaccess begin + end
Date: Wed, 23 Oct 2024 09:54:33 -0600
Message-ID: <20241023155639.1124650-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241023155639.1124650-1-axboe@kernel.dk>
References: <20241023155639.1124650-1-axboe@kernel.dk>
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

Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8952453ea807..bfea5d1fbc67 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3239,6 +3239,7 @@ static int io_validate_ext_arg(unsigned flags, const void __user *argp, size_t a
 static int io_get_ext_arg(unsigned flags, const void __user *argp,
 			  struct ext_arg *ext_arg)
 {
+	const struct io_uring_getevents_arg __user *uarg = argp;
 	struct io_uring_getevents_arg arg;
 
 	/*
@@ -3256,8 +3257,19 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
 	 */
 	if (ext_arg->argsz != sizeof(arg))
 		return -EINVAL;
-	if (copy_from_user(&arg, argp, sizeof(arg)))
+	if (!user_access_begin(uarg, sizeof(*uarg)))
 		return -EFAULT;
+#ifdef CONFIG_64BIT
+	unsafe_get_user(arg.sigmask, &uarg->sigmask, uaccess_end);
+	unsafe_get_user(arg.ts, &uarg->ts, uaccess_end);
+#else
+	unsafe_copy_from_user(&arg.sigmask, &uarg->sigmask, sizeof(arg.sigmask),
+				uaccess_end);
+	unsafe_copy_from_user(&arg.ts, &uarg->ts, sizeof(arg.ts), uaccess_end);
+#endif
+	unsafe_get_user(arg.min_wait_usec, &uarg->min_wait_usec, uaccess_end);
+	unsafe_get_user(arg.sigmask_sz, &uarg->sigmask_sz, uaccess_end);
+	user_access_end();
 	ext_arg->min_time = arg.min_wait_usec * NSEC_PER_USEC;
 	ext_arg->sig = u64_to_user_ptr(arg.sigmask);
 	ext_arg->argsz = arg.sigmask_sz;
@@ -3267,6 +3279,9 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
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


