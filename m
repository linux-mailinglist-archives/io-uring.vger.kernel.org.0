Return-Path: <io-uring+bounces-6168-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31EA3A2134D
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 21:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34E8E1884A20
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 20:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90A6D1E0090;
	Tue, 28 Jan 2025 20:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c3Sdma8E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C550D1E3DF8
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 20:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738097770; cv=none; b=FJTTq0fYSFs2GDuERDY/O3nQbwTN5U6SNnHKClV7tR8X1ZLaldAmx1F3mikfl9Ejv4xViAO2EBvLUdFy6wPilnCFNmVFFds5PGtyzLbXIdPov0hOgjpYAt+33HLBxGUMFPlhTtRyWIWcgYebh3uZAW4k39fg4Ju+eTTCbNdb050=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738097770; c=relaxed/simple;
	bh=0AwgUZFfoduAhGqQ+GRGD7wQFd69kXbD/I8JB7tN0sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAix+i7Sc1DcnFzEHsX2TpfNWIwibPuJpPUyA7o2VViob5NrElorccLGzIRq8y+N3Lcb8Z8RyeJdJxSU+ThS0eTmOxGRMc/jdPOBg6PgnCW2SBhTAbV+G6KlJiTtLFf+CBtPKfkAMfviCL5FrnFmEun9kAOS9VelhKszaZDp/YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c3Sdma8E; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5d3ecae02beso8361902a12.0
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 12:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738097767; x=1738702567; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61S3ynbxLsRmBQWo1PSXkO+mooFqEeYxcq4XV8RbRr0=;
        b=c3Sdma8EcoCHuCnQtyHgTDlXR6UZezmqia8LyoO6NAibf5Yk2gnYHjuf9weU5ymmJ7
         61oZofAOYYOLo5pCT5DkD2tClXObuJTi3W8l25r9QhbfFAGSz5UmF1PCIaZbh2o2AaQK
         VtwVLsZjc2pFQ77cAf4cuJnkP3HMku4QLrbWQCJuaSwAUhLIxSoOqC4VKwgnxXyByDFT
         PM5q8+cBW1cSmHLv3gSXk2lK1yEualtGMqpBOqW+ecs+iBhjgtzmKMv6Ar107ehMD+2s
         aAys6uOPBf6rRJvaxjY0fTaVqE5hcU8OvW49uuMIGKQHHmjAqR5rE3AxZLb1qgN9ytzf
         BkiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738097767; x=1738702567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=61S3ynbxLsRmBQWo1PSXkO+mooFqEeYxcq4XV8RbRr0=;
        b=SXhzSWOZxeoZu55joKRzzdbFl+vMJwIFqengzBxPTWeKhYUzUkfSSeIcKnY6rZEeII
         x5bERLidXv1cPyKlk3BvVg0Pvetq+AAmwPRIdp4cFgj10gZYgH1SzBCL2YNd2Z5eTAzs
         /bLCs2iz+ZiixVW2+fbTNju24xAHRFzyS4yqGXRhiy2OFSvAd9LRyxAKmXyqNmRAsoeS
         Os2Q9RNP0pEQ7f/OfKxlY/ulnK0JyFWJtOuItFkZDRhv6YFfVpMMzJ/A94HDM8YAHrU8
         NQGlf6E8Ui2S2/aeNq25rWTZz6neAsdYws9tyiI8iJu+EFik/KexiSMP2r4ZCQsrGXbt
         T/JA==
X-Gm-Message-State: AOJu0YyjuaxC2iYvYFAmDVY8jiUhvcIw8NuT1SZGQZ9/7utVm4BAEY71
	s7Z8+16/5aR//GASN/7pJ7Box5/v0afpqBNEy4whhiex5dVRrhTlvil4aA==
X-Gm-Gg: ASbGncuKkHSTKnz7IqPdOvSHZUG2AXfCodEhzgo1XR4rE/N9qKqlH9Ij+bewl6gh2jY
	AnERAbVFPLxS+Z+MB4n98tttAHQJHS+MPYr2E+n8a7m9OWcj84HOOaxMRs9Ts8mecMU2/eTQMxX
	zbL17LpaxXXsjQQvUtY3OJM2eXo7Cvu/d/Yp3QhKTwt6Z+wBT+q8zPweBlRyhQysLZ3bAu7WYMb
	fOy05SuIls7fO5a8vnGjY5+O8Ak9Df8h3irJQbA3e9iTAgLMAY+rkrBs+6438Wqg2gD2CUnGMz+
	cgCBhgaT0ecAbNKVRTy4yptoYVB4
X-Google-Smtp-Source: AGHT+IH+ZbK+e9QLJS/73So+tjE8aHRlJtdm8hA8PZzC2+o/RIHBLXhzajdsR4LVFkRXAQ6zOiqMSQ==
X-Received: by 2002:a05:6402:2711:b0:5d3:bc1d:e56d with SMTP id 4fb4d7f45d1cf-5dc5f01e7famr322858a12.31.1738097766663;
        Tue, 28 Jan 2025 12:56:06 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.145.92])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc18619351sm7736949a12.5.2025.01.28.12.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 12:56:05 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 7/8] io_uring: remove !KASAN guards from cache free
Date: Tue, 28 Jan 2025 20:56:15 +0000
Message-ID: <d6078a51c7137a243f9d00849bc3daa660873209.1738087204.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1738087204.git.asml.silence@gmail.com>
References: <cover.1738087204.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test setups (with KASAN) will avoid !KASAN sections, and so it's not
testing paths that would be exercised otherwise. That's bad as to be
sure that your code works you now have to specifically test both KASAN
and !KASAN configs.

Remove !CONFIG_KASAN guards from io_netmsg_cache_free() and
io_rw_cache_free(). The free functions should always be getting valid
entries, and even though for KASAN iovecs should already be cleared,
that's better than skipping the chunks completely.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 2 --
 io_uring/rw.c  | 2 --
 2 files changed, 4 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 4d21f7bd2149e..d89c39f853e39 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1813,10 +1813,8 @@ void io_netmsg_cache_free(const void *entry)
 {
 	struct io_async_msghdr *kmsg = (struct io_async_msghdr *) entry;
 
-#if !defined(CONFIG_KASAN)
 	if (kmsg->free_iov)
 		io_netmsg_iovec_free(kmsg);
-#endif
 	kfree(kmsg);
 }
 #endif
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 991ecfbea88e3..c496f195aae2b 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1309,9 +1309,7 @@ void io_rw_cache_free(const void *entry)
 {
 	struct io_async_rw *rw = (struct io_async_rw *) entry;
 
-#if !defined(CONFIG_KASAN)
 	if (rw->free_iovec)
 		io_rw_iovec_free(rw);
-#endif
 	kfree(rw);
 }
-- 
2.47.1


