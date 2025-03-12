Return-Path: <io-uring+bounces-7061-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 69193A5DD72
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 14:10:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CF263B6800
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 13:09:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 939D724635E;
	Wed, 12 Mar 2025 13:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="xXgbPt2l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107A02451C8
	for <io-uring@vger.kernel.org>; Wed, 12 Mar 2025 13:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741784983; cv=none; b=Id0izgiTVPiUA9mch9O+6PgPN96pQbsrDpk0pjNr9FhfA5TC82CuI+3fBqjMK2kMm0hgrGeiJ17kkjFdzY/ZcDvlvZSPs41pFBqtJOc2hU2zdz+SV2aUBi0If8Sm+evU4hrjNh2zfxSNlTY5MpBt1taIHN9smc/w++YhFn9Rvs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741784983; c=relaxed/simple;
	bh=ueLLfb2g6ooAKzkCZNWnsaYYsRz9CK6dnjSm/F8mDd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGb0CVK1rWg5B6X05FaeFDCZGwzZO8QSLlV4rii5uX+E7tBQ6NtE34lOdSqXhIMuZrOagqGi8zW+ohUirgqFC1AMYqLVaW6mAem39Y160LmakJcTtyCnH/ce+RPbaVtHqQxQTRKhygWosHOQhMs3k1cqo97i173RPYTj0g+QSps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=xXgbPt2l; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22185cddbffso14742655ad.1
        for <io-uring@vger.kernel.org>; Wed, 12 Mar 2025 06:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1741784981; x=1742389781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0xE5xU4H97yAwT+GSMKnaXD9mzHnmpKqghu02U5UNnw=;
        b=xXgbPt2lnIl76IcX7VCKYy5orOCANDofbFa9AXKD/CCXbU2BjqocYnQVK+gAcUi7QK
         yW26EpOOJDdkrn305NcS86z5X2/LiLF2w8KLI5m/V8I1hi6281RlsgxfYX3ktgLSwp7M
         hr5/1nGfz5h4EZhQk3AuPMudso3ISkP/HybBPnY2DKNcalglVVL7jgyVfonfv+k/qdVZ
         DsasTcAritcWqq0jkiOGTKlSZ6fxad/Y6Yf3zhOw7oalKvwlL0hcafWKZZxuE8BXUA92
         bMwhzZJleBZlsjNN5jF7lWDU1xOEZMezmtVmdVvin1qrndE2IbLU35Kk3Z5oPjEt7AhJ
         kqCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741784981; x=1742389781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0xE5xU4H97yAwT+GSMKnaXD9mzHnmpKqghu02U5UNnw=;
        b=vxVRTPv3Jyt/ab3jLaAmy9BKrk261Q4mh/K3NSjGwuAOX7IdeWVa5DZfPgHB10zvkF
         9vrzlm9E9wpfbW12LSWV4ow2oPIED2GbTIqJgahQBGCgN21YX6FWthkT5CkPTXMA1W7C
         Y3PZMGBhKGB29Dkpk1EwXLcQiqpwOQV+coZdtdjYsjW5idceioWKnU4nRp988fcKGbTZ
         Z9Hh6uB1MBNSMrdZDc+J9zKYS0vLmVlrSkc9wKJYf9coThWDrlhRHAEeH/dp+RIEl0lW
         dOjsM8oUrwFVelzN6FuO17WgHv/KQLX5NsHB+3uz7kdArt5tRlBGRyhdiGd9X3m+1o4a
         R8qw==
X-Forwarded-Encrypted: i=1; AJvYcCWMxqT5Bu5fA8URZxOac3n4X3b49ew1bTQE7kosjvHvU6tZNFMRHI71rEGjMStVtdv6bs1DBQ+MNQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzzmXlP0KGvEd8GkOorNHJPqsNxDBFg1TLkwGyTnn/oV1K6S7EI
	Grq8B683mo3jrjrrmSkpww8KwdM2Ft1PRoNClxt5ZvZcqVNamUG45Hn8lh7BbOY=
X-Gm-Gg: ASbGncu/pVJHjDFS8vJJ+OJkFelBcDCAc8TJpIs0FKNG8Q2rwia5psSSUI4merOOTlp
	WhEIgWwJYcgXd6HVFuw1As5vsRAVRu4YunWFM4b3RKJADQeO7e2uKh4jKE72G6nvbP8dBx5inXb
	z6rylmxs4baSeXSCfVfu/OPr6pJattXzwqJbPRd1ltX/NVjFj4xGGIcf51jL4+gKDx+uPcqZ2Qj
	8Ja+r9u4oln+OXLhzauYtcyTUbXGmqYR74mGnce5msAK0+h7grcYa7+yZo0lxmvdI4uelxoiT0H
	wKwRHc3FyahXesvJRq8/nq9+xCVr/Hl9lRbk/2yMmxmitTeQbg6v1aqCpehR37loUgN8LXEKL17
	ZnEsp
X-Google-Smtp-Source: AGHT+IH7VkB+NmesEyRPaK+5JngGbkotuud4dSkt+bqgpb7eOgAc+UGan0lPxKxbcp4ppjOow3D4eA==
X-Received: by 2002:a05:6a21:38c:b0:1ee:c598:7a87 with SMTP id adf61e73a8af0-1f58d73a925mr9693203637.14.1741784981396;
        Wed, 12 Mar 2025 06:09:41 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af5053a85c2sm9432299a12.10.2025.03.12.06.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 06:09:41 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Sidong Yang <sidong.yang@furiosa.ai>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 1/2] io_uring: cmd: introduce io_uring_cmd_import_fixed_vec
Date: Wed, 12 Mar 2025 13:09:21 +0000
Message-ID: <20250312130924.11402-2-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250312130924.11402-1-sidong.yang@furiosa.ai>
References: <20250312130924.11402-1-sidong.yang@furiosa.ai>
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
 io_uring/uring_cmd.c         | 31 +++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 598cacda4aa3..b0e09c685941 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -44,6 +44,12 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct io_uring_cmd *ioucmd,
 			      unsigned int issue_flags);
 
+int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
+				  const struct iovec __user *uiovec,
+				  unsigned long nr_segs, int rw,
+				  unsigned int issue_flags,
+				  struct iov_iter *iter, struct bio_vec **bvec);
+
 /*
  * Completes the request, i.e. posts an io_uring CQE and deallocates @ioucmd
  * and the corresponding io_uring request.
@@ -76,6 +82,14 @@ io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 {
 	return -EOPNOTSUPP;
 }
+int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
+				  const struct iovec __user *uiovec,
+				  unsigned long nr_segs, int rw,
+				  unsigned int issue_flags,
+				  struct iov_iter *iter, struct bio_vec **bvec);
+{
+	return -EOPNOTSUPP;
+}
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
 		u64 ret2, unsigned issue_flags)
 {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index de39b602aa82..6bf076f45e6a 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include "linux/io_uring_types.h"
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/file.h>
@@ -255,6 +256,36 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
+int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
+				  const struct iovec __user *uiovec,
+				  unsigned long nr_segs, int rw,
+				  unsigned int issue_flags,
+				  struct iov_iter *iter, struct bio_vec **bvec)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	struct iovec *iov;
+	int ret;
+	bool is_compat = io_is_compat(req->ctx);
+	struct iou_vec iou_vec;
+
+	if (!bvec)
+		return -EINVAL;
+
+	iov = iovec_from_user(uiovec, nr_segs, 0, NULL, is_compat);
+	if (IS_ERR(iov))
+		return PTR_ERR(iov);
+
+	iou_vec.iovec = iov;
+	iou_vec.nr = nr_segs;
+
+	ret = io_import_reg_vec(rw, iter, req, &iou_vec, iou_vec.nr, 0,
+				issue_flags);
+
+	*bvec = iou_vec.bvec;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed_vec);
+
 void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
-- 
2.43.0


