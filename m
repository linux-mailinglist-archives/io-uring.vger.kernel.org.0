Return-Path: <io-uring+bounces-6643-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42BE0A41062
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2025 18:21:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83FF318936AD
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2025 17:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E554C1BC3C;
	Sun, 23 Feb 2025 17:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TIr2Vz+U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2587D126BEE
	for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 17:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740331310; cv=none; b=LBcprlSn+75sU0x++/Ho0KtF4UOuXSKCUab9MnW0U5hHeVSEf5Jjjtkqhzs3WYGN5rYpM/FZeT/tkSr9iAOYumpIuBkoDvJpMu6TWQtAH/FQn7KSdy3FtWIH7IRLCKGAARn3NdhBDBBzoYjvXqQ948vC+T8U40/4BtACPnXRdEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740331310; c=relaxed/simple;
	bh=Hn2SSGLa1Zf2M8XXQtR718u9JMVg3QCKYLTf39YwZ34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhddXxKf4ZLGju8qBas/ETed4V1bz0L608jixAOiB6d89vJIWUhXny7BIlzZc+gwNk9DXUwtZoOL7jLn9uO7WNxRsBRgJKvAjhlOk62nuplAUOIBK/wPPtyR0upu8f+7gn00iPezX2sMPwx0NkONpYKS/AGvUr+CoSvfa8BnbLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TIr2Vz+U; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43937cf2131so24478315e9.2
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 09:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740331307; x=1740936107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ExhDyyv3Sh2t0xfSNNu2pV2UTZ/1xa15A50v3I1MnlA=;
        b=TIr2Vz+U+M1LXqHEZjgdPWwYURVpqfZD18kkeVYCCIHHgC5O/tcROQs/r8RAWm9vO8
         9S64GaNpXzSnjDOWZG7w5OiGDwlHfu4G/85050snjIXlioXT3BvmuddK98G59eSoVPTQ
         txIV9t3VFSaxZPDLgQ7xDkRWr8mam+tQPqZNuvDzQBuYHKsY7ClFpUaMTJ2d4Iq8uV5t
         6sB3pedXn8emKKHmTxD4nCdkvEY4T3igSOPZinghy91sn7nz9Avc97xV+ZUPzut9/nQE
         HB6RfDivcx2mGUUKVAwedSUEaI4tZ9wMw0ASDspRMyVQ2h0mxhR2RkxSdwFgXH7Dzss1
         NDgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740331307; x=1740936107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ExhDyyv3Sh2t0xfSNNu2pV2UTZ/1xa15A50v3I1MnlA=;
        b=PbKzG6B6DdVhaCkpR0ZjhUgk78jSuWLzPYz25tU60CtkkSKglnHaRM0TBHFBBqD+qV
         J8vLfIxuGrxm92yf2RRs3g3nb8o2S//PAzcptFRXfF1+jakJehfVAz4FQPwTQjTK1oc2
         DdJcjYM8qsm+tsSlFpHbv+BzOZOEDTXru0iyDw8Y1ZPbgLTyyK/TGjCCQXuHp5HbsGrx
         GiZAbtUKKldFfN2wDCgz8aCvuDYbU0+jzgLlZAtA3hj7OHz+QdcetOnnBQgzG1roRGK5
         6pJt+t4uy2y1L9bhmcTntYvHEjsx4/u9nLHC3K+CXP32RH2fqtwW90bTIeDiGW4X6xk3
         bndw==
X-Gm-Message-State: AOJu0Yxwdt5nG3NnMIrDbpVJsATLzFVO7EtV+++ObslRAqvxs/xIny27
	2VB60jAKDC4zzY1mIZj0+ZwReRvmhK0CBQOd8qfTi/l5jviol75dvLTRsQ==
X-Gm-Gg: ASbGncvi0nw1Nv1eMeRr2Qb1dINBt/r3AR1yvYds/hZyDytIpeKi5Oi0uLG2ZDPaVDf
	WJkR+UI7PO+m5HhChc/ePxdG6iX6u3/k73Cf7hAWRAy7i/h63Uc0QVzdrbyos10ujb6R3lqWizT
	uARlFjwyA6V4TgyMBIY2hbl6uCQ/n/e0FMwoV6LCuuRmQ5U4OQRY4CFXu8U7xp7Pc6EMpVJGhls
	LrmHXvEEaKRYOH7ERbbEVqnjUQ38pjKA/OfMchob2wijyVCMd0cRCIOfLod7xYMfbXzvQcg/Ecz
	btxNZRZJBe3fgpcfHYdXD4dVFCGQd6O60Ted7aI=
X-Google-Smtp-Source: AGHT+IF0dYXUykBYnTNJKrKdHbVMOkshwr0o5FJnd+0tvlnL8vZXjR5piMHweD3lijVDM2CHCG4AHQ==
X-Received: by 2002:a05:600c:3b09:b0:439:8b19:fa87 with SMTP id 5b1f17b1804b1-439ae1d982amr90765025e9.4.1740331307111;
        Sun, 23 Feb 2025 09:21:47 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439b02d684dsm82117765e9.16.2025.02.23.09.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2025 09:21:46 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/3] io_uring: make io_poll_issue() sturdier
Date: Sun, 23 Feb 2025 17:22:31 +0000
Message-ID: <3096d7b1026d9a52426a598bdfc8d9d324555545.1740331076.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740331076.git.asml.silence@gmail.com>
References: <cover.1740331076.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_poll_issue() forwards the call to io_issue_sqe() and thus inherits
some of the handling. That's not particularly failure resistant, as for
example returning an innocently looking IOU_OK from a multishot issue
will lead to severe bugs.

Reimplement io_poll_issue() without io_issue_sqe()'s request completion
logic. Remove extra checks as we know that req->file is already set,
linked timeout are armed, and iopoll is not supported. Also cover it
with warnings for now.

The patch should be useful by itself, but it's also preparing the
codebase for other future clean ups.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 58528bf61638..a7f5794c1930 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1721,15 +1721,13 @@ static bool io_assign_file(struct io_kiocb *req, const struct io_issue_def *def,
 	return !!req->file;
 }
 
-static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
+static inline int __io_issue_sqe(struct io_kiocb *req,
+				 unsigned int issue_flags,
+				 const struct io_issue_def *def)
 {
-	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	const struct cred *creds = NULL;
 	int ret;
 
-	if (unlikely(!io_assign_file(req, def, issue_flags)))
-		return -EBADF;
-
 	if (unlikely((req->flags & REQ_F_CREDS) && req->creds != current_cred()))
 		creds = override_creds(req->creds);
 
@@ -1744,6 +1742,19 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	if (creds)
 		revert_creds(creds);
 
+	return ret;
+}
+
+static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
+{
+	const struct io_issue_def *def = &io_issue_defs[req->opcode];
+	int ret;
+
+	if (unlikely(!io_assign_file(req, def, issue_flags)))
+		return -EBADF;
+
+	ret = __io_issue_sqe(req, issue_flags, def);
+
 	if (ret == IOU_OK) {
 		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
 			io_req_complete_defer(req);
@@ -1766,9 +1777,24 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_poll_issue(struct io_kiocb *req, io_tw_token_t tw)
 {
+	const unsigned int issue_flags = IO_URING_F_NONBLOCK |
+					 IO_URING_F_MULTISHOT |
+					 IO_URING_F_COMPLETE_DEFER;
+	int ret;
+
 	io_tw_lock(req->ctx, tw);
-	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_MULTISHOT|
-				 IO_URING_F_COMPLETE_DEFER);
+
+	WARN_ON_ONCE(!req->file);
+	if (WARN_ON_ONCE(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EFAULT;
+
+	ret = __io_issue_sqe(req, issue_flags, &io_issue_defs[req->opcode]);
+
+	WARN_ON_ONCE(ret == IOU_OK);
+
+	if (ret == IOU_ISSUE_SKIP_COMPLETE)
+		ret = 0;
+	return ret;
 }
 
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
-- 
2.48.1


