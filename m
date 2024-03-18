Return-Path: <io-uring+bounces-1118-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 35F6987F2CE
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 23:02:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1AD91F22256
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 22:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2FA65A4C4;
	Mon, 18 Mar 2024 22:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HP7Qrd0Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0648159B74;
	Mon, 18 Mar 2024 22:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799338; cv=none; b=uyKFUp8qxzWzfGuMaam+q3TerPyNcj0EI8eZzDigqL4qpKHOoQyCqAoJeNSJXM97CrvY+z87tlhz5n+uhlkD45wNt+T1ebhJ3PC4Q5ChkrsRAKFvi+wX3RDXX/ZvBV88Pu3jyvw58qNlE9S8qNk/1pqZpKfdu42a8eryJgu6CWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799338; c=relaxed/simple;
	bh=JCp/LX1aRNcLI0yu32VofH3AASA/z92mcX8UJU7sh+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1j/6g+UlUmK6izyKrM3+L8omZ1FxDB1+ztX92rA11BhFajGIUjOoZKZ9+k4nS2O7K/m4scF91EVni3/2AEwb6SWj/CL87aSag0AhoHl8LWhuws94FXrLihUnIYOrhm0B4idHmtMeNtFlraWc5LDMI8wFDX5SE49wxh5w97ejXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HP7Qrd0Y; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-33ed7ef0ae8so1560014f8f.0;
        Mon, 18 Mar 2024 15:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710799334; x=1711404134; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=okOU/yJL1S1r/fv/BiyDDnckwReFnZwpj+K4WdugD8s=;
        b=HP7Qrd0YQMy8HtQhKMiUQfZanZsIFpflA6YQG3DkDsZwPLGeSHIe+sdV4z6N/q0+8u
         OkF13gv5u1qkFulyYY3S2DTAbXJjzSRx3/Rlrn9eBfLx8aH/pfy1CLnyWzj0Y64c9rCW
         0zP7tv1NoxATsfzpSX+An2PiwPXCatLBBMVssTkbEctTn8Jpc+jD3u2189447FYtt3vP
         KoBADp4Sv4DJG1WahOtAyQ3lDJnXpvcVSLKuIna7VMzFtxvsPnxEtpuQdMWzA/E99PwT
         tN2sZN+N4elZgE/XRAIOXRvU8RaAzW8AQ+OjWYITwopHTrXLcZSyFgge9qUiGzdV3/qO
         HEIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710799334; x=1711404134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=okOU/yJL1S1r/fv/BiyDDnckwReFnZwpj+K4WdugD8s=;
        b=IRo2ExtimE4/jPeLarGKBWGf4WQne193WJDbA80L8HSEGa8h446H703UjqUv4dZmJs
         qBZG7xxSIpRMxFqB5q1QxjJOIUzoQDcX1jDS2I7l83SC24oS1BXli0FwKJ7zZmokDgwp
         XgXAlt6HNlLDId+k7BB6OuXEFZoyeG/96+HuxM+9m85ssaYmck/lSSHc0Q5oATJPiucU
         SE6ucXn/ladplzTIiHsJJ5IaTYU0jf3x0NYDcIswK4DWDJZD1a1ZWfKiSrc9pbomNplR
         cOlxkjcNAcqrvXtkhfpMNZQ6ONUSTZEFnC90WxvQ9VFCv0vG2bfG/SXVUZdjlJ7hFpvY
         HS2Q==
X-Gm-Message-State: AOJu0Yx94zfNcV65mrNd+JKInMcm6Eu/3awS2MpAkb6FryiMnxBGQSpu
	Bg+t+iU67PRxM6ulW6fT1JvwAt1GAHf+W7mfA+3aGOAklFoYSS2uno7mxoYV
X-Google-Smtp-Source: AGHT+IEGBPiDPkvBVjkzhWjsnSXQB1PjPEfVyl0X+QJ0aEZFNWG9zv/gpGduHelfP66esEg+5Ja7tg==
X-Received: by 2002:adf:ab14:0:b0:33e:d396:bc41 with SMTP id q20-20020adfab14000000b0033ed396bc41mr363729wrc.71.1710799334606;
        Mon, 18 Mar 2024 15:02:14 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id bj25-20020a0560001e1900b0033e68338fbasm2771038wrb.81.2024.03.18.15.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:02:14 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v3 04/13] io_uring/cmd: introduce io_uring_cmd_complete
Date: Mon, 18 Mar 2024 22:00:26 +0000
Message-ID: <82ff8a45f2c3eb5f3a04a33f0692e5e4a1320455.1710799188.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710799188.git.asml.silence@gmail.com>
References: <cover.1710799188.git.asml.silence@gmail.com>
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
---
 include/linux/io_uring/cmd.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index e453a997c060..bf94ed4135d8 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -26,12 +26,25 @@ static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
 #if defined(CONFIG_IO_URING)
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd);
+
+/*
+ * Completes the request, i.e. posts an io_uring CQE and deallocates @ioucmd
+ * and the corresponding io_uring request.
+ *
+ * Note: the caller should never hard code @issue_flags and is only allowed
+ * to pass the mask provided by the core io_uring code.
+ */
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
 			unsigned issue_flags);
+
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
 			    unsigned flags);
 
+/*
+ * Note: the caller should never hard code @issue_flags and only use the
+ * mask provided by the core io_uring code.
+ */
 void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		unsigned int issue_flags);
 
@@ -56,6 +69,21 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 }
 #endif
 
+/*
+ * Completes the request, i.e. posts an io_uring CQE and deallocates @ioucmd
+ * and the corresponding io_uring request. Similar to io_uring_cmd_done() but
+ * doesn't need issue_flags.
+ *
+ * Note, must not be used with cancellable requests.
+ */
+static inline void io_uring_cmd_complete(struct io_uring_cmd *ioucmd,
+					 ssize_t ret, ssize_t res2)
+{
+	if (WARN_ON_ONCE(ioucmd->flags & IORING_URING_CMD_CANCELABLE))
+		return;
+	io_uring_cmd_done(ioucmd, ret, res2, IO_URING_F_UNLOCKED);
+}
+
 /* users must follow the IOU_F_TWQ_LAZY_WAKE semantics */
 static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
 			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
-- 
2.44.0


