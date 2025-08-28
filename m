Return-Path: <io-uring+bounces-9387-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4715AB3986C
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 11:38:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E41E1C2747E
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 09:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386B11FE47B;
	Thu, 28 Aug 2025 09:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NAcG7w+T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5DE25CC64
	for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 09:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756373898; cv=none; b=CxwKZvcNuqW+ecreHDd26rMDigmxZvM/sIs+t44V3WDCzcdVvwrkNsM2vxFOdj8aBOZuqwTxCtmxTZptr6fCTT5QZeWswew3cgMdO68Lx+mIlCB44fRCFWe/yZ1lP9BN+lnH/yKm7zjI/OR2wcFBeytTIX/+HHKIV9A6/mOHpaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756373898; c=relaxed/simple;
	bh=9CihXvK8I2dPvot5dktr69KT/dur071wrPk7u5h41dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aahfq+VMur+Yw3u9hv3wBXBgVr26NSXx/XE/OfQ7GPMT4tSMdHbUX+wyixV93OQmWUgeeXjRZjK5qGluzRjyn8nJZZkUgJw4DaAElkPudzasP754thbecySshYpAk7E8dtAnR5iVhySyPhGy6AxtHRruzK0EZ35p2sXQpxpOAFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NAcG7w+T; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3c73d3ebff0so827149f8f.1
        for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 02:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756373894; x=1756978694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zz5iR5Itghwnj9zwKDl9tq9v6O15lxNL/l95WBYSHzU=;
        b=NAcG7w+TikWcJLvBNbIb3PdB6Da7jUCKr4zgYA6fOv12nriI8yyZFFkYP7R5oMQ1Tw
         i12ewp4wDdumx3/WcO9QQiswDVXYwbpe/SjGrr5n/vySKnU3vJEKzdaowJvT0RckCGJo
         uNdpS/5wAuQd1+DEdMSegVSw38MdcMv4fuqDezcN8/6MciDvJfdgIsrUUlBUmNFkXq9g
         oCczaimv/HviEGBik2Ub7JD/HBEvIy2K9q3q0Y0ek48Sl9EfPBy/JKd78PHmj4nWKhRe
         DLJlxvGY/aoJO52EecnsJVygjQwZOj9DJGwkO3wZiFF74CpaKl46vQQpsKQPT/p3uycv
         4FAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756373894; x=1756978694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zz5iR5Itghwnj9zwKDl9tq9v6O15lxNL/l95WBYSHzU=;
        b=ME9NXwH+9v9Pftau0ZKyMuBZJLkgnDzL51polhdLk2aKyt3oTAzVWcoZNmWI8YUQLY
         f8aioSJ7Y67DHxDoEZbzfVP5fNAgi7WcT6AD4/GHqRYKxRa1mJuE6tT53kmAcvBagh8m
         cwHfZ7+tG2Ju08BA9brGUCh2ZLwebTulnxiVnito0rdirbk9CdyAGtFtBhuGXF5n/5FF
         u2uibEo/gCbfk8apaG75ZOn+yCA4yuqo7CoTjiaM5/c24CFpgeIM6JYvfyWNVBv5IwGh
         h5rW7qZ/mWC9qyNEMNRnI0l5YA3DMqmdQJWQPxVyivh88I2/PtoNWwiuETSVpWcQ12FL
         Jg6w==
X-Gm-Message-State: AOJu0Yy4mr4l3Z+0KyTFGYWC67Mz+ZzevCLgjDIFJXsBZSHnVpnlIF5K
	1LoI4s7kf/p/NSDwMAOfPoYWv+PFweYl1BOjlshhMe33W9bdlSP0xnx5DTt65A==
X-Gm-Gg: ASbGncvXfApTWRKDdOwZOE77sSa0J8v0T+It9zqE90/nl3EaL7VlRrvpkwDQFkmzGDU
	zpHYjgFCf0WwFtyukx2dZMrwe9gKDiWWcU4JMr2pk90mxvE/6D6fga+hYthjWq6zywHEy+MBUn6
	XtZ6IL1+2Ku4eEWybKC67edv9/YE5ITMa0mZOn2WUjLNcEDfULpG+DsUOHv6kxEnzQXQ9S0+yic
	KRQ5H4AXej8C8FOem+kvPByMEr5AFffTyNHNkHMRiqvDgjUp/3mDM52kuhFWrPOZrS1n6yGiOHn
	xco6GQ1kkMQie7Cwn1xjWu1taFvhfk2cicTT8hbTfm4wyxvIIoIcLAu/HMRDwy/NmE2a0euTY9o
	P2J24RSGc9EElkpTd
X-Google-Smtp-Source: AGHT+IF50A5xS8HMr4J9qdzkQADKpFOfxoeNnqFab3bKz/8E11EK5SvTEhc0RyV5rQsKxeCG9DTCdg==
X-Received: by 2002:a5d:63cd:0:b0:3cb:bd66:da42 with SMTP id ffacd0b85a97d-3cbbd66ed3cmr5398445f8f.13.1756373894053;
        Thu, 28 Aug 2025 02:38:14 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:68ae])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b797e5499sm24331455e9.21.2025.08.28.02.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 02:38:13 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 1/3] io_uring: add helper for *REGISTER_SEND_MSG_RING
Date: Thu, 28 Aug 2025 10:39:26 +0100
Message-ID: <8c4cbc22dfcf1b480fab2663cfda7dcc013df3ab.1756373946.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756373946.git.asml.silence@gmail.com>
References: <cover.1756373946.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move handling of IORING_REGISTER_SEND_MSG_RING into a separate function
in preparation to growing io_uring_register_blind().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/register.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index a59589249fce..046dcb7ba4d1 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -877,6 +877,23 @@ struct file *io_uring_register_get_file(unsigned int fd, bool registered)
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static int io_uring_register_send_msg_ring(void __user *arg, unsigned int nr_args)
+{
+	struct io_uring_sqe sqe;
+
+	if (!arg || nr_args != 1)
+		return -EINVAL;
+	if (copy_from_user(&sqe, arg, sizeof(sqe)))
+		return -EFAULT;
+	/* no flags supported */
+	if (sqe.flags)
+		return -EINVAL;
+	if (sqe.opcode != IORING_OP_MSG_RING)
+		return -EINVAL;
+
+	return io_uring_sync_msg_ring(&sqe);
+}
+
 /*
  * "blind" registration opcodes are ones where there's no ring given, and
  * hence the source fd must be -1.
@@ -885,21 +902,9 @@ static int io_uring_register_blind(unsigned int opcode, void __user *arg,
 				   unsigned int nr_args)
 {
 	switch (opcode) {
-	case IORING_REGISTER_SEND_MSG_RING: {
-		struct io_uring_sqe sqe;
-
-		if (!arg || nr_args != 1)
-			return -EINVAL;
-		if (copy_from_user(&sqe, arg, sizeof(sqe)))
-			return -EFAULT;
-		/* no flags supported */
-		if (sqe.flags)
-			return -EINVAL;
-		if (sqe.opcode == IORING_OP_MSG_RING)
-			return io_uring_sync_msg_ring(&sqe);
-		}
+	case IORING_REGISTER_SEND_MSG_RING:
+		return io_uring_register_send_msg_ring(arg, nr_args);
 	}
-
 	return -EINVAL;
 }
 
-- 
2.49.0


