Return-Path: <io-uring+bounces-1066-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9F1687E14E
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 01:44:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8D601C21334
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 00:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C75D1E862;
	Mon, 18 Mar 2024 00:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Owyo1AXb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816191DFC7;
	Mon, 18 Mar 2024 00:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710722625; cv=none; b=ehkhc1b2V4G7WK7m07OJl47/cqkEwroPxiCVDwVCgv+W0gSNp4/aiIBdd5utBZqhK1XAHv5cVU5lSpmLejgRtOmHIQ3Vs/QGlG5VwdU9dxfl6h0HkyUbnFet7txG0Sn8BhFY6EmplTdGlOgyORwnd56MpXFeyIW5FPZw29PJOzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710722625; c=relaxed/simple;
	bh=hRFIhnTfLnaAyAR/FJHl3b6p2rBAKes40e/Ty6a3718=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLextfg463TfjxfBe6Ior+5dBusA5R0JvNBWbLtzXXkbZYwF/olSXo4ILcA54TR6Iw0VpwUIhrObc8m/4NP4iOnXgVtq/JUzncCeCzVgjBCsfSWyuPieldU6scV7EhfcTGtrnZmObH5/Fnj+nxC9VO8YTdnmr1a+XKtgWXQ3MIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Owyo1AXb; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5684ea117a3so5431370a12.0;
        Sun, 17 Mar 2024 17:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710722621; x=1711327421; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9xW49xRGwOEZ3X1kEj3TcgEavVPmzEUMLGOfhWA4lGU=;
        b=Owyo1AXbFMS8d65Dplt4WBQtL9zqxCUoIw2FCrF3/jffqxvH7tAQkG/MYyAKREd7Qw
         fz977Aepxnh0tnwz8dq3gHr5iFwcj0PGwRoBogsIF2IBmS+VE74YtgOfaB2f9i4r7YDJ
         yXH5pQtHxrSDU2xrt9GkUvBTpq/gbSP54coMXFuqKZPsuzPQXBCfnJSV9NF0AHFKENa5
         3X/Sls0PALRAwoXtS8GT8GT5fPZTaSGehYfhw7XGEo1s+zcOTmTXCHCjfkcAaEZAN0uG
         KgBgUXWal5tw/+OJqh7fGdfNeTjYxUY322HaJH5K66Myus3VFamosHNWMKYhWrR0kr/1
         mFRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710722621; x=1711327421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9xW49xRGwOEZ3X1kEj3TcgEavVPmzEUMLGOfhWA4lGU=;
        b=jioV/DEROohbAF5dgjbwmF8VzN8ej/9cE11UNMLjUpulOOw1MpeYincxCU/r2sLdlF
         88TDrpAKe54e/D5m5pCfa9ZLouurGiFMpAnbjIC4zjYhk0/vl1NOzzrfkg7KVmsz7WCv
         lRs+bvT3EH6tceWHmXjrPw42AUgumo2GvxX2Sca6Tw1dX8sLG8InOQAaCJDsYf0aHGM2
         pjpPuObrE6zb8RDfNLqK+KflVVaLWY7Er+rh+JZoOST6Y7aIik04jMsofaybYaDc3X4o
         lDA6+RQfFlj85+aEz/eZt+l/+1mA1gOXOlL/LXv3/W1cDAvrLlcxyFa2x6erKLf1jH+H
         JWVg==
X-Gm-Message-State: AOJu0YyMZXFa4T+YCqVEw5r4vZ4rHDHEgoAoAuZ6Fo0hv0PFmaMtkJu6
	P8rxbPffsJxXi2YEnuZXn4k6puA8GYG4GNarttXpzjxDi6YWg1vojxb9yQuX
X-Google-Smtp-Source: AGHT+IEWDJFtwqWqwAJ+4gPipnYVYFDYgB4VPf7Q8gdWx8xHrgFnSfnvg8C6m3q1mbqFCrx+o2OCrg==
X-Received: by 2002:a05:6402:3222:b0:568:b38c:e2c1 with SMTP id g34-20020a056402322200b00568b38ce2c1mr5608670eda.35.1710722620964;
        Sun, 17 Mar 2024 17:43:40 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id p13-20020a05640243cd00b00568d55c1bbasm888465edc.73.2024.03.17.17.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Mar 2024 17:43:40 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 04/14] io_uring/cmd: introduce io_uring_cmd_complete
Date: Mon, 18 Mar 2024 00:41:49 +0000
Message-ID: <c4c0fb66d12a380536b41ebcddabd0de455bc04a.1710720150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710720150.git.asml.silence@gmail.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_cmd_complete() does exactly what io_uring_cmd_done() does, that
is completing the request, but doesn't ask for issue_flags argument. We
have a couple of users hardcoding some random issue_flags values in
drivers, which they absolutely should not do. This function will be used
to get rid of them. Also, add comments warning users that they're only
allowed to pass issue_flags that were given from io_uring.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/bb7e81aa31f9c878780d46e379d106124a7aa102.1710514702.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring/cmd.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index e453a997c060..9cbe986eab7d 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -26,12 +26,25 @@ static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
 #if defined(CONFIG_IO_URING)
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd);
+
+/*
+ * Completes the request, i.e. posts an io_uring CQE and deallocates @ioucmd
+ * and a corresponding io_uring request.
+ *
+ * Note: the caller must never invent the  @issue_flags mask, it's only allowed
+ * to pass what has been provided by the core io_uring code.
+ */
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
 			unsigned issue_flags);
+
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
 			    unsigned flags);
 
+/*
+ * The caller must never invent the @issue_flags mask, it's only allowed
+ * to pass what has been provided by the core io_uring code.
+ */
 void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		unsigned int issue_flags);
 
@@ -56,6 +69,17 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 }
 #endif
 
+/*
+ * Completes the request, i.e. posts an io_uring CQE and deallocates @ioucmd
+ * and a corresponding io_uring request. Similar to io_uring_cmd_done() but
+ * without issue_flags argument.
+ */
+static inline void io_uring_cmd_complete(struct io_uring_cmd *ioucmd,
+					 ssize_t ret, ssize_t res2)
+{
+	io_uring_cmd_done(ioucmd, ret, res2, IO_URING_F_UNLOCKED);
+}
+
 /* users must follow the IOU_F_TWQ_LAZY_WAKE semantics */
 static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
 			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
-- 
2.44.0


