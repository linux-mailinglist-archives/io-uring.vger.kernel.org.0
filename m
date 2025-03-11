Return-Path: <io-uring+bounces-7047-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 26907A5BF6B
	for <lists+io-uring@lfdr.de>; Tue, 11 Mar 2025 12:42:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BADFD1899B0E
	for <lists+io-uring@lfdr.de>; Tue, 11 Mar 2025 11:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D200C2561B5;
	Tue, 11 Mar 2025 11:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="eAIQqUCe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AE2255E20
	for <io-uring@vger.kernel.org>; Tue, 11 Mar 2025 11:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741693323; cv=none; b=PgUIcfoZJL5Rn5OBf7uY8b9FnWWF3dTv91fKhlxoWBlf0tALh01jlB9Vo7gaRh5eR3GJiH4VpDPp97UNZ8VLVrTT0Xzn4VVMB+n2KzTN63P389c8WTyjITUPIc4xHotBhLf3Y2FZHtqXcodHFXhtI3G/qye3MsHRqxz9TYoq+9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741693323; c=relaxed/simple;
	bh=RtWG1kcYXYJUxfQVm04qkDa/lg7kxL9FGZhNdQfBrt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUg49nkuC6FQsRA5UrMY0Ud1r+0Tc6W/vAhVN/IkL66UJ1imCiodq3Yq4tVTdtNvDa/WKk3NQeOXXb+6GZZXgoMuO3jlFuKmFQEC7ASetOiLSjmIkbrivz2himbp2s3XWxmyKCCFE37ZZDCwoJInc6596xY85aglmdLSiOCrZ34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=eAIQqUCe; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2ff6a98c638so10029664a91.0
        for <io-uring@vger.kernel.org>; Tue, 11 Mar 2025 04:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1741693322; x=1742298122; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X0Fp17O3JAMZDE/PWYetr8PB3aop95hwwptwptAErt0=;
        b=eAIQqUCerY3ew7X4PeZlrbVdKsmZIPpDKjTbz1tMgChXrHjA5i7zDVZ+xLkD1DD9nE
         1pmMP4MGRlvHHNYcQZGnUjMpwsprLLjOBtjQRpkILgBRP2krSXKvNz0+9214gfkbljfQ
         ep8j326sGnIiA2CDVpSI+cL7EiQbK/vkvtdzY7oljOX9tZ0SJZayd7arwszz0ozHqSyN
         hNiUE3lcIDfXYemXqK7JlJCCWU9IuvddeVQgp9YwagJPRsk8RwP2TqMWF2AEyk+crs0u
         CRZiXal+i9PoeGPPHSleNjx/FqM01qqQhPOHB4YoxHNiHSEFXwyLFa91glRKd4Dd2VHk
         RdJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741693322; x=1742298122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X0Fp17O3JAMZDE/PWYetr8PB3aop95hwwptwptAErt0=;
        b=cZyXnpESGMA+xTBraRc/o0+UK8agioBivNKa6YNaxCzveMeHEetXZ/x88RIzzP48F7
         qFF/tRuPMEzilf2rpnbu4IJf5rQm7iaTJqo6O4lx1rwtbCkITdDxuxnPNKyOTFxXECGV
         fC/Dswp+2mvd9/PJ+fofX/dCAnRaI4T3YTYoEK4fJey6s9lmNz8sQjjqwu66vsgn+EqO
         krtcDUUJgLF4ZvsN5VFfq/awCAHUXOowKyGvvQ6vZrBehVFoLCpqaK8DB2bTluMA9yeC
         J7HWUGfzsZ//jNeI+fvXOpNEgN728QPEO9ktl9FgcAqIm01wQF1gznp7hJHAhsmB3Qm0
         vbiA==
X-Forwarded-Encrypted: i=1; AJvYcCXyu1EP+BynD7Nk/EO/VeTF/bmw4SLluFiKQ5QOKaOUhTfSwjlYRgMY5tWawY0xmpZpNeAZ94GKJA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYQ1oNaecd/l7kSNAUemh2HOeYM+kM85gNaCsI3yQrznddDDNK
	cWPugxl5+huhX1pPCU3dquAW+UKqb9zijQ9xDfX5MFSbpZL5+Zmy7hxs9tSGjInEpERNskjrH8S
	s
X-Gm-Gg: ASbGncu4X7sro6RUSAQBuIBOognewWrGfelg8WjQEhTgqfF4hWezPjUTQxMMb1uEnTM
	KS0NsmBdad3nhxvXGbWdG914HhmJ8JGPpcLxP3oJ9t8AI+T4DNrvWp3nJFXjOQaoxRugPihmLoE
	luyycaoPl11Kv1vxeqrUcT889wWm+95B55TF1fF+F9fHdDTSwVyMG80VJa44pfl3GomqDERK909
	2mXPiPt7rNowk+iSJEsu3p/GGXPSrpNMCmwBiX04nvpbtmZ1xyZ88HEj8f3EIPegwOqF/TF34uL
	yZsX7UKdtOSh83+c3gkLImj0fay3cK6oQG2Xk9og4lkZF2Y6DgpbkDsejlC3G7aNLnUpB3DnaT6
	XPAQS
X-Google-Smtp-Source: AGHT+IFwzzGRe2jkxfHS08jzq7ZtsPhqL17dqZLhLnPKsxh8KSmAtnOqy8MNjjK7N8xAtgGZm+Y1lQ==
X-Received: by 2002:a17:90b:3fce:b0:2f2:a664:df20 with SMTP id 98e67ed59e1d1-2ff7ce47c16mr27695933a91.7.1741693321657;
        Tue, 11 Mar 2025 04:42:01 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([221.148.76.1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff4e7ff8cfsm11647817a91.37.2025.03.11.04.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 04:42:01 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Cc: Sidong Yang <sidong.yang@furiosa.ai>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 1/2] io_uring: cmd: introduce io_uring_cmd_import_fixed_vec
Date: Tue, 11 Mar 2025 11:40:41 +0000
Message-ID: <20250311114053.216359-2-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250311114053.216359-1-sidong.yang@furiosa.ai>
References: <20250311114053.216359-1-sidong.yang@furiosa.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_cmd_import_fixed_vec() could be used for using multiple
fixed buffer in uring_cmd callback.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 include/linux/io_uring/cmd.h | 14 ++++++++++++++
 io_uring/uring_cmd.c         | 29 +++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 598cacda4aa3..75cf25c1e730 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -44,6 +44,13 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct io_uring_cmd *ioucmd,
 			      unsigned int issue_flags);
 
+int io_uring_cmd_import_fixed_vec(const struct iovec __user *uiovec,
+				  unsigned long nr_segs, int rw,
+				  struct iov_iter *iter,
+				  struct io_uring_cmd *ioucmd,
+				  struct iou_vec *iou_vec, bool compat,
+				  unsigned int issue_flags);
+
 /*
  * Completes the request, i.e. posts an io_uring CQE and deallocates @ioucmd
  * and the corresponding io_uring request.
@@ -76,6 +83,13 @@ io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 {
 	return -EOPNOTSUPP;
 }
+int io_uring_cmd_import_fixed_vec(int rw, struct iov_iter *iter,
+				  struct io_uring_cmd *ioucmd,
+				  struct iou_vec *vec, unsigned nr_iovs,
+				  unsigned iovec_off, unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
 		u64 ret2, unsigned issue_flags)
 {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index de39b602aa82..58e2932f29e7 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -255,6 +255,35 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
+int io_uring_cmd_import_fixed_vec(const struct iovec __user *uiovec,
+				  unsigned long nr_segs, int rw,
+				  struct iov_iter *iter,
+				  struct io_uring_cmd *ioucmd,
+				  struct iou_vec *iou_vec, bool compat,
+				  unsigned int issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	struct iovec *iov;
+	int ret;
+
+	iov = iovec_from_user(uiovec, nr_segs, 0, NULL, compat);
+	if (IS_ERR(iov))
+		return PTR_ERR(iov);
+
+	ret = io_vec_realloc(iou_vec, nr_segs);
+	if (ret) {
+		kfree(iov);
+		return ret;
+	}
+	memcpy(iou_vec->iovec, iov, sizeof(*iov) * nr_segs);
+	kfree(iov);
+
+	ret = io_import_reg_vec(rw, iter, req, iou_vec, iou_vec->nr, 0,
+				issue_flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed_vec);
+
 void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
-- 
2.43.0


