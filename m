Return-Path: <io-uring+bounces-7063-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E8E1A5DEE0
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 15:24:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0445A189CC99
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 14:24:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0224324FC0D;
	Wed, 12 Mar 2025 14:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="VpC7xg30"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8758524E018
	for <io-uring@vger.kernel.org>; Wed, 12 Mar 2025 14:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741789447; cv=none; b=FvNk5UZ4tMJwIfkXGrVU6DTi7tq8nKduveh3hDbXOpyobjtOGU5Itv1LbaMWGzesBlyzU9BPBiO3hLXw8GsXMO2jHJH7Smi/ofQz0qETySouDfxHQlvVnFf51FTFbJKEDpJN70baSljS74TVZ+ttrfQ2KVCpL5fbgsUrBlt9wYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741789447; c=relaxed/simple;
	bh=ueLLfb2g6ooAKzkCZNWnsaYYsRz9CK6dnjSm/F8mDd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RH9qPBMz1I4LSpMIVxW8WZ0Inrr3mAG9XntkR4NJZrVLThqI0SMAfqXbEIF6FjMG9TLUMLkPs669zBNW5HeXTlNJ8ugL6zJaqJRXa0UJUEyYbp8ddBjYBAf0Nze1H6JmnwSqYc1ppDE3VtZjM5kUzKvuMLFJaXpXD7Q0aVtwgXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=VpC7xg30; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22548a28d0cso47988295ad.3
        for <io-uring@vger.kernel.org>; Wed, 12 Mar 2025 07:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1741789445; x=1742394245; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0xE5xU4H97yAwT+GSMKnaXD9mzHnmpKqghu02U5UNnw=;
        b=VpC7xg30l1h4FAr8iEL6sODXobJWIdIyvkZ1BftrdM+DwlLEdrzR39EZulh7SFpX+b
         3zHRWQU798dj6mW5iKFwvkED+t6wPj16rdSVFPWvwcVgYuVKko4+hmhax2kilYLgQmfw
         rtboAnV4b0ivyBMYS7zHQ3QTXjJAgCzXCbG2eNtSbO4xf0vak15Rq1WjkPUjqrqsE1TC
         5T007ewHZr7tW3+aN3qpGTmic8aKdWf+KUnIKvyFe5GEi3UMvRfo5AmFyfwEpSrWusMH
         Wbw0T5cAe3XdiyrcGh6pEdscd+g9Y2OAsr6DgLWBm9MsyyvutjcyH9bCepgGwFd/yXnI
         j0Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741789445; x=1742394245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0xE5xU4H97yAwT+GSMKnaXD9mzHnmpKqghu02U5UNnw=;
        b=K/KaLzOB38Ng1mJVX6tBDwKU2KRxZMLhW7r3ZISVronJXsFJYTFkLj2qhVvMJbZIrn
         W8jx5XOKfO2BUsAdoJPjR49IVrqRU6rEh2qomdk/4DLAOVGM0SeTEe4w+hQL7G9oMkSd
         nb0ghztyHBUt1vxrvFQG7WKDu11sP6Yr0CNxPuJX9RxiL0sWPyX2Bkn1kTIpGt5iiNtO
         IAuII8RzUW/Ls5yMZUlUThYibD7Q7oL1TRcVZRnAfE5p45NS5sFfMe5Q0N03WpdRgyAx
         8PAYtY+3MXpp1jOAg3+/CAIFOR/4cMtZmydMWzrVs+1L0coieK5r2nM1BPrxoNiHJeW0
         QKyw==
X-Forwarded-Encrypted: i=1; AJvYcCU437Ed8AEcPgwa+29lW6Df+cbsfa3zfqCFcsEZbf6SNaoUNKttJzoD+kA9fflO0VviB1FgU1a86g==@vger.kernel.org
X-Gm-Message-State: AOJu0YymSpIECPuBM6zgbo6G4pJB8ZgZzvWFkug6bjp9g4b6ZXU5BE34
	jt7vhCd++IJ84pF3VzgGiRbs97uKc6bl7Rqug0fDXnYssyQUWZr8HJc4F+0zofQ=
X-Gm-Gg: ASbGncuTiS2ER65iKLKL1eZU7zFxdCOE4rebe2CAUpfyzSqspVnNy6IgrdBzxANiZJ7
	NlMs48vYIrzaX9y344uySzhf8jJykePt5jeDILvSvAivdzb3eyfztgovzTOON9CXtmZ5YWxUJp2
	MpaG4VrpIYq2am26q1KQCazaVuW08MCFN/PWJPiX0qgeRzioNJxAApguFoj7feyi2mvePFjhxGT
	dXXaTyh7CmanJMx4wI06TvEedIViJSbfPW8l7U7r2BiGTwvDCX0vPWVoyo6NjElTNaf2VxF3mkK
	7G+Qnsg/V9VzI8MAdZYySI6cG30KC6QR3J1FfEZkBASsiF43VaXU/jh6I8h9k9bbJeFP+y4Zld8
	OlOTv
X-Google-Smtp-Source: AGHT+IEFkanN727wtkiJd8Cv9m0pOpd+cskICbFK6tPN+bU3UWDrxWUgeUfFa42vbUkQzGost6P7tw==
X-Received: by 2002:a05:6a00:174c:b0:736:9f20:a16c with SMTP id d2e1a72fcca58-736aa9e96e1mr28852100b3a.5.1741789444707;
        Wed, 12 Mar 2025 07:24:04 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736cc972eabsm7413860b3a.144.2025.03.12.07.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 07:24:04 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [RFC PATCH v2 1/2] io_uring: cmd: introduce io_uring_cmd_import_fixed_vec
Date: Wed, 12 Mar 2025 14:23:25 +0000
Message-ID: <20250312142326.11660-2-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250312142326.11660-1-sidong.yang@furiosa.ai>
References: <20250312142326.11660-1-sidong.yang@furiosa.ai>
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


