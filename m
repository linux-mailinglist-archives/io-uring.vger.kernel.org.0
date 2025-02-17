Return-Path: <io-uring+bounces-6483-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04568A384DD
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 14:41:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0ABE83A22B8
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 13:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F76121C9F4;
	Mon, 17 Feb 2025 13:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HKJvZe/u"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1D321A44D
	for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 13:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739799405; cv=none; b=QU3sunka+d2FFJKGgqtsO9fblbWgOn+n6B7yLsB0Kyp/3vYfiffr9qjVqI3NedDJbi4j99z5vy5n+60MPpjHteE0BxdGpiigzK7Y1BEna0bJKX8HJ124fBfGC23ghNSfk/O2N4aMIwMsh7C6ajG1UAezEGq6zCcIcOVWBOM1Wk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739799405; c=relaxed/simple;
	bh=EFq5a7VyEzrvNInyp/fJnetBS6i/0YqZ39PAZ7Cpk7o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MjioHdkg5Gp4LxXre5gkzb0+pQOGUTGL56vVpHqWmcv4PszLwL6n3eLN1pQ6DjjtlyWt1z8oPupL0V3vTkI8GxRX9uLc4glFQws/KNiCOYnu976QQnolSnyIBCbcYc6rbSvawyDHqOrKaxAUAtG4GTvIVzlcKF2prYcixyLGo2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HKJvZe/u; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-38f488f3161so355016f8f.3
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 05:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739799401; x=1740404201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y8d5tuYkUFsNmUgkEteJQKcCaKeBkm8i/9IPDCD/UwM=;
        b=HKJvZe/uICTzhspfPXjlirYoyvEq8sYYXjX7B+xJm0DsohrsBgIHZ7cE+NRxO2lfGy
         3AvcENXNnn8KKQbOzjuvkSCspcuQdEVQTyHPTMxLKDL7mwFky29sPYz9Xoy71vkp05vT
         Mu13J1F7WpZ424T40TtRCIBW1cM4II2TdxH5zLaBkMD34cEynD9vpqQybfpujpEPVdZn
         b9BOsiI8wm3QTib0imIWka2CFxEL8RKqKaEljDx4lXv+LOpp7vqmdLmHcuuDcpolExoU
         SDFVktcmKjWV8Po7R/FvaVwFsRNkujPZ9Rv/WQg1KxQMYWulQ02QRVbnDpuHR4UerKvi
         EgNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739799401; x=1740404201;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y8d5tuYkUFsNmUgkEteJQKcCaKeBkm8i/9IPDCD/UwM=;
        b=ItQSQsSoKbWpZH56/Jr47iM7A8bstK7+guKLwjt2opNtNTWw993yYph8XIEomh0sz1
         PygScaQ7VwPmmV5/h7P2WWWZPVnDvQE0+apXsAz+R2dUVyrl1frTkrdpbheeYywwmJQV
         d8mJTvqTqpZCJaMTPBkmxt/cW45zxLgMMCpUbdXzfRrhAa52Mn3y8N+qXvYGrEAmj1rp
         N9V7+9e8H6JGpSjue2G098xobUc/XDa4iGyZPMlU1nEcVdFTOqaQsb964yJKPsfBHvE5
         UuP+NkskR8onfRmwU6TnBvYrsWWDFJJR7xV5ooW5jiEQSchc9StQE3UTO6gmZyJlKbiq
         Lwvw==
X-Gm-Message-State: AOJu0YyjWpmUQFxHog81k7b3LOvMUqtGT6nyH4cz3I4Zk5P+el7B7HGa
	oE8ISCSg0nO4C4PxUqFWnaBoiLf6NxUAstIVswKYzruIPNmoAthy6/tOeA==
X-Gm-Gg: ASbGncsYfeyaJXi2M290fUuNiLTyr9ASNn1TWoLDWBd5uv5AtspbHmi1KVDPhJ2hIy3
	nmCNABJPhasDjDeh2k532JFRyzIdLTtdkWgD68VET9tKqoWo6exaypUOVpODLBuTItqSawOj88V
	fgS1nhPBL3qmsSNstHG16bbtBetnfnbMlf0YL24QYkvXEdeVHWz+2/UWUU0WIVo0wsdLln3S3m9
	0F3GoEt4ehJMpeTalObbX1JFUPK/xiiB025zqOtyrQSmrCFfp+aTvSlJvXTEUr37jsyOvAlRTDs
	lyiDFBnGf8FqzbEAsnvRkz1BsSSf
X-Google-Smtp-Source: AGHT+IFNGlJBsWImbK5ehbebTpJGzsdpN21vLhpwxPua/8ZHuJDwXfGGhfrcrTyUXtcfeKEinRDqqw==
X-Received: by 2002:a05:6000:1887:b0:38f:3c01:fb2c with SMTP id ffacd0b85a97d-38f3c01fe81mr6611682f8f.48.1739799401051;
        Mon, 17 Feb 2025 05:36:41 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259f7987sm12061590f8f.87.2025.02.17.05.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 05:36:40 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/rw: forbid multishot async reads
Date: Mon, 17 Feb 2025 13:37:22 +0000
Message-ID: <49f065f7b88b7a67190ce65919e7c93c04b3a74b.1739799395.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At the moment we can't sanely handle queuing an async request from a
multishot context, so disable them. It shouldn't matter as pollable
files / socekts don't normally do async.

Cc: stable@vger.kernel.org
Fixes: fc68fcda04910 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 96b42c331267..4bda46c5eb20 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -878,7 +878,15 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		return ret;
 
-	ret = io_iter_do_read(rw, &io->iter);
+	if (unlikely(req->opcode == IORING_OP_READ_MULTISHOT)) {
+		void *cb_copy = rw->kiocb.ki_complete;
+
+		rw->kiocb.ki_complete = NULL;
+		ret = io_iter_do_read(rw, &io->iter);
+		rw->kiocb.ki_complete = cb_copy;
+	} else {
+		ret = io_iter_do_read(rw, &io->iter);
+	}
 
 	/*
 	 * Some file systems like to return -EOPNOTSUPP for an IOCB_NOWAIT
@@ -902,7 +910,8 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	} else if (ret == -EIOCBQUEUED) {
 		return IOU_ISSUE_SKIP_COMPLETE;
 	} else if (ret == req->cqe.res || ret <= 0 || !force_nonblock ||
-		   (req->flags & REQ_F_NOWAIT) || !need_complete_io(req)) {
+		   (req->flags & REQ_F_NOWAIT) || !need_complete_io(req) ||
+		   (issue_flags & IO_URING_F_MULTISHOT)) {
 		/* read all, failed, already did sync or don't want to retry */
 		goto done;
 	}
-- 
2.48.1


