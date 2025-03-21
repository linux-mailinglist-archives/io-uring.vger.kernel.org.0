Return-Path: <io-uring+bounces-7166-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A326A6C212
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 19:04:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33842465B42
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 18:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC9D22E405;
	Fri, 21 Mar 2025 18:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WSE+IC0C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C336E78F5B
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 18:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742580229; cv=none; b=QpeNTSP7oRQ+SxYVyQJ6zLinnfKWJEiCBlMYYJEfs8iH3d55PKVW34Libom5bJkq5XcjWy71GdKUg5NCW6T9QUTzhfCClGAFxrH92Ye32HMdHQcuPDyaa8iRm4o1Qy/Gck8d+7IuJRBZUE01WeqIUskEj66fA+kbtllKb3kCxos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742580229; c=relaxed/simple;
	bh=Qiq9QCrGk5TkB9pGm0wq49GL9GKj3R/yxn7kdMkwhdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ae0d2UGilZncuI4HEZ2+3qtLtzUUwfCthyTAbK887GTy4dMaQasYxsJf/3h4PskAC0uj9tYr88x0ZWY9zW8E9lCqOJ37YoCjrC6uFX9BMpQvZ9IXaAikixAI7cqbTAC0oo+KoHBuAyH48jCcIBerCc02FU8aV+5Ct6iUd/8Nv5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WSE+IC0C; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac34257295dso477474066b.2
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 11:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742580225; x=1743185025; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hIAG2Vk8MTGRYi2E9GE6atqWdSHnwdRL99A7etsMoU8=;
        b=WSE+IC0Cve2DjgbHbVz5t5JGpgwrbksWd66mj/ZBfyBiOb0BMp6jXCfK33qYSyqpEJ
         81yg7Dih+aw4P0nUx3fMTO2pG0H9moRQDF4pwddKbl3pgixp5ORpY183OwvdkksPWFHZ
         krzgnXDlbWrkabMPJD59EflmV5ywqwHSlJtlxPCKCIe5SKLLM3Klw/TGqdoOi5Gz5hjb
         9bi4v3FwZAX4BThmwTqDhCqqmgqDi6UjKgMGfaLxUeZa8nZuExkxnNFQFDsLX0TLvPiw
         nxOPr0mZLGvLDd5v7vDxybew7OZONsq1VAV2NMdf3opEzMkQ6TkGOsjFDVpTcSF/WYqE
         kSZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742580225; x=1743185025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hIAG2Vk8MTGRYi2E9GE6atqWdSHnwdRL99A7etsMoU8=;
        b=Qej4izsodt1T6PktUBU3eKymcBRVI7vtjlbNpBYP/yUKC1UoRXhbK2CyhEzjWwNydC
         AsDBdWPWqaAUKxO47TzSKuIoXc33tQ9vm+a4hX7/9ckWWwW5ycrwhnhq/iBQQo4PPno2
         ke7QDayfw+7P6jb4p9snfgPwk6wYJTdALIaMc+EucVol6v+pomOufZxFcfgvBTWaK/CI
         nLTEnFqH97TKRmJ9DJfXJFCmaHnCNUzIBwz8ipe4jkB/isTsBQw6SGvGmNnUgqdd53Zz
         u88x7lFf8q5WCEr+W18b31pgQwuBnDVMC4jWM0nc5fIf6LRbyBBviAjSPNmIzBzLSmTc
         nKIg==
X-Gm-Message-State: AOJu0YxSk+/bSqmNsBsIpTFvZ58KndLbLpcfkNIDJ1n7eDerCG/FRLG0
	UvkW6rrbakagh2Hem23NymWipyrKgznoSkr4+EOitrJf73ikhSD7cmqCvg==
X-Gm-Gg: ASbGnctcMjaa+iHpgVB8rXPG1uO9O6aWERcPhAF3+0XVQDktPSkCABwBF9+TJ5TnBTt
	AkjXvK0dZA4vtHFa2cXgK4+A9FlIRGpVBAJAhwCxN9Fw5W8llNVZA1hcw11dJXkRJ8QmoMhwA2M
	oSnprEvXdLtNAMUdVoz2ZoGFr+fIkBQdTFCqWRWYWRm9p/7omEp6Dijr1VOJ/lKammQth9Iup3e
	aBUlfdHbEgJK9SEGKKSW7psl3tWzGjrCBZZhm5Oj8/nK3aJyaYEgpRfxTOSvTcyzWoz8bew77gA
	HvLVNgWz3ogGcWBgGQiK6/JfCkAAIZgb+sVdOMYrOe6YZHoKfQ7CrZfvBBDmnQPUb6Ns
X-Google-Smtp-Source: AGHT+IGAd76VyOxZpXJIiG/687vva2mxveWIlU2r5kJ9yKxKCnDt5nEv66XBodvllg2UyDdfoyt4+g==
X-Received: by 2002:a17:906:c105:b0:ac1:fab4:a83 with SMTP id a640c23a62f3a-ac3f22aec3fmr420811566b.25.1742580225273;
        Fri, 21 Mar 2025 11:03:45 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.236.254])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3ef8d3d2dsm191646266b.60.2025.03.21.11.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 11:03:44 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 2/2] io_uring/cmd: introduce io_uring_cmd_import_fixed_vec
Date: Fri, 21 Mar 2025 18:04:34 +0000
Message-ID: <97487a80dec3fb8cf8aeedf1f9026ef6d503fe4b.1742579999.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1742579999.git.asml.silence@gmail.com>
References: <cover.1742579999.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_cmd_import_fixed_vec() is a cmd helper around vectored
registered buffer import functions, which caches the memory under
the hood. The lifetime of the vectore and hence the iterator is bound to
the request. Furthermore, the user is not allowed to call it multiple
times for a single request.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring/cmd.h | 13 +++++++++++++
 io_uring/uring_cmd.c         | 19 +++++++++++++++++++
 io_uring/uring_cmd.h         |  6 ++++++
 3 files changed, 38 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 598cacda4aa3..e6723fa95160 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -43,6 +43,11 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter,
 			      struct io_uring_cmd *ioucmd,
 			      unsigned int issue_flags);
+int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
+				  const struct iovec __user *uvec,
+				  size_t uvec_segs,
+				  int ddir, struct iov_iter *iter,
+				  unsigned issue_flags);
 
 /*
  * Completes the request, i.e. posts an io_uring CQE and deallocates @ioucmd
@@ -76,6 +81,14 @@ io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
+						const struct iovec __user *uvec,
+						size_t uvec_segs,
+						int ddir, struct iov_iter *iter,
+						unsigned issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
 		u64 ret2, unsigned issue_flags)
 {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 6a21cdaaf495..f2cfc371f3d0 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -277,6 +277,25 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
+int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
+				  const struct iovec __user *uvec,
+				  size_t uvec_segs,
+				  int ddir, struct iov_iter *iter,
+				  unsigned issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	struct io_async_cmd *ac = req->async_data;
+	int ret;
+
+	ret = io_prep_reg_iovec(req, &ac->vec, uvec, uvec_segs);
+	if (ret)
+		return ret;
+
+	return io_import_reg_vec(ddir, iter, req, &ac->vec, uvec_segs,
+				 issue_flags);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed_vec);
+
 void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index b45ec7cffcd1..14e525255854 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -16,3 +16,9 @@ bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 				   struct io_uring_task *tctx, bool cancel_all);
 
 void io_cmd_cache_free(const void *entry);
+
+int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
+				  const struct iovec __user *uvec,
+				  size_t uvec_segs,
+				  int ddir, struct iov_iter *iter,
+				  unsigned issue_flags);
-- 
2.48.1


