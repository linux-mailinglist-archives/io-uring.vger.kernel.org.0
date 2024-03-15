Return-Path: <io-uring+bounces-956-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D78E87D04E
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:31:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 347001F23518
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 15:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E987C3D396;
	Fri, 15 Mar 2024 15:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hu1df6+u"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDCF1946C;
	Fri, 15 Mar 2024 15:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710516677; cv=none; b=vDTvMbOB/olAacp2rIFeD+uCuvfvlVelSkkv386iN8f8HPjSnwr6j0OoeSKkC2lzMJZxjKflaZRyG3Cik7NF+ie9MML3pJvW+7lqZWtkAkarktm2MXxSHde8TBo6PNyL0sypcKK9FbxccvNHtkdPWFTzXdTlEVpMronooeKq61U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710516677; c=relaxed/simple;
	bh=zAf6c7/XJ1nhbxWUTxcMM5i8EgkOlmQJlR+NVc+j6Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIATBQhxKn/Y2bsOa4WSfwINKVbwn7gubRzaBc3svl6lyyHv8zim7iTZ/GwfDKaDSdEhcBiGziOrJ0Bsj4iwLsVx6LAKtiMglpVBGY8Ex4PAk0YOKvzFiipVxKRTk7/PaSdlfyeb9FegneD0G9WKhZljNAbCUdVngGwV0MkpU2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hu1df6+u; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-33e966f56c7so2310990f8f.0;
        Fri, 15 Mar 2024 08:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710516674; x=1711121474; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+UMgC0mUDzTo76vypApcjS0mpEbmkLe5hnsQfuh8pPk=;
        b=Hu1df6+uh1dVgZeaotiD7pgDiSvTOv/LspDdtMMsdCCBC2uPNF4S5vJRzKnwCjgS4o
         PXAPyIv4BL2Ka3wt0Vx66S883FGfW6Wzslf4V/7MgJ6aY5ItjBC4N33OmlgjCFC0GIcK
         8ppTCJTaFTK4iSd0ziAfOP8VNGxKvm5b1cIFSM8dmn3zv4lQWzNlCaKSMWv684SqwigG
         i3mqVLGeBb7nQDN1jZD4IjlBXVEgJM4eUGxIukWEyA9yHHuQxhyGGPkQv5Qq7/5cLcGD
         lGQ6dPX4gdse9FOfjFKwU2V+k+ovHQ5R0CTQ3kzKML50NotWrhw+JYczasy2kCSdZLOd
         DUZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710516674; x=1711121474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+UMgC0mUDzTo76vypApcjS0mpEbmkLe5hnsQfuh8pPk=;
        b=BfAtBa4NOgv7s9BY+lD+9hSYTrno+5vhKxMCsRDokmhqiB/hfYu2NABtsaDFETjVeO
         VRecq9jIUuB0rpucPzqUowvOCokCSTTB2jw5xO1ogjyuEOP/68l6ZCcK5sCBDe5+UbKs
         nDx57k+8vc0aazzF/x3KljTusNvcUWd8yjWbGXG6zZQFhcIlGzqY7UBkzFnxVQuJQ7vj
         dAIGQA3kwvxctScS1OMyPEYvw9OM5bE0OAYV8ToMsNsH2KUpBb1zBIG6qDPTB87cySTG
         ZnMMPMje+92q8Zmif+ZsUBibhcuo6EDKhX5wNG/JFhUBcDU/xl6NFi8M93FSUybmmKfj
         F2MQ==
X-Gm-Message-State: AOJu0Yxbm2MwjDiEqrC0sgUiu2L2gySFieOMXy4FwUhvPbJLdM4vDwSg
	wpVdLfSqfsY9jmfOVy5HkY5Lnx6FzbFig6YfL18UM/ZWIn54U1s2Fly7m5Cw
X-Google-Smtp-Source: AGHT+IGQ07XO0QxIj+Ccxxec6obPCN59IwaNJeiNvnUv2xQot8JuiSz3IToMGeDq4rxk75UnyrXZFQ==
X-Received: by 2002:a05:6000:1103:b0:33d:73de:cd95 with SMTP id z3-20020a056000110300b0033d73decd95mr2988774wrw.17.1710516674298;
        Fri, 15 Mar 2024 08:31:14 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id u3-20020a5d6ac3000000b0033dd2c3131fsm3415671wrw.65.2024.03.15.08.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 08:31:13 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 04/11] io_uring/cmd: introduce io_uring_cmd_complete
Date: Fri, 15 Mar 2024 15:29:54 +0000
Message-ID: <bb7e81aa31f9c878780d46e379d106124a7aa102.1710514702.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1710514702.git.asml.silence@gmail.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
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
2.43.0


