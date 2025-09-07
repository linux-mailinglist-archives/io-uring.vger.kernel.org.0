Return-Path: <io-uring+bounces-9632-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 91C69B48128
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 01:02:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2ECC44E14B3
	for <lists+io-uring@lfdr.de>; Sun,  7 Sep 2025 23:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1661FBCA1;
	Sun,  7 Sep 2025 23:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MwRcTtrF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC66315D25
	for <io-uring@vger.kernel.org>; Sun,  7 Sep 2025 23:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757286128; cv=none; b=AXVl4kGAgYuhW+ZWUD6zL9fUdpj+hqOtNm2Fm4uOR/025n9CjF4tPmXtraPA9+CGWQ/cjfYi9MTN7FGETif9Kt+gBzrd3OVmf67leq4L8vNRzpCE7+3guiYL1j8OkUJdvoEok6BDlptNaBrlR9d5l39X+bsTi0idBESFidLK7mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757286128; c=relaxed/simple;
	bh=oBWRbEAowXvUcS3ZO4gLa0ESgJEpuW0yyru9knky6IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HoI91GCqiZczsePPZSdYDB1VqUc6re4blG/1y8FAOcrcLarB5Hn/EIyEN22oO3DtA3YigJi7Aex1p+ww6EbEtv9eWqvPpW597ZAIRa2ilO+4LgHQ5Xuk87ulGKbbrhOFIo0RYs6H8P86O56qTpleGjjGSSkCZB1jfmGOE3KLsTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MwRcTtrF; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6228de28242so2942922a12.0
        for <io-uring@vger.kernel.org>; Sun, 07 Sep 2025 16:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757286124; x=1757890924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SdlwnZgizto//lG+7lIBagL734XHJQ/s1YE0UmQNVZg=;
        b=MwRcTtrF6OlSUakkswBpCckJ6rrJsavHufBhE/A957rgCj2Kmwcb7vXm+f2oeuLbP3
         444wd+PAwTgl/IyhqYp5S1A8H1dZcTleGEAI0i/T0QL9XmCBRTYk7J7aO1IwKsebGzHv
         Me96NSFAk3zdzz2rOuUetJXb3WwbhrI7ZzHvhqDqFpkwC5CkrNmntWMUibt2zxWXzfss
         8RJw9xl1Db9R4twiVslM2ZNaIewv+X69iGD9XYYuKLstlw9zHJDojM9ROTy0jiHVUGvN
         43bk9WNCaLYtFSi4oiPE7n9qWTBBvm0ol+i0mUV+kQgO6jBeDH2frw60QGKZowhVEr+k
         WFng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757286124; x=1757890924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SdlwnZgizto//lG+7lIBagL734XHJQ/s1YE0UmQNVZg=;
        b=s1l79x/BOzBE+kqFhU2HEjyIMAKbOscjGMB+e0C6MRBB+5aEmRuRkPZPNCpZEXaZb9
         NRscyrbDPWKcobv8f3Y/Gl0Mkib20q2iGi0nOt0EUohIBrbLcjDi4r/K2OJ/QH5zxyHi
         X36YJvX9Xmd17k4fnSdlArI8c45aVKXnjWHoosHGwzu7FXzqhiMgXwV0Hqh86/ni7eBU
         udvJmQrKpPa9ioj7CcysSqiNDr2d4P8SSugtt0nWKbvruH2N7p488RH91mra/mEnLPE6
         gGO97rYhRGANzQ1uJu6xeApQsgLtp9fqke5ufXwGiYc9Sxb3WP+G3wzUHX9fhZUtuyGg
         encw==
X-Gm-Message-State: AOJu0YwHTyVPqEyR5d1ZQjJSf8iAebiQ1PEmSyBeJd6DhpoWM2bJdvWU
	GPIN1eDU2ZUrZ+l6QVPbAXWvRimcEbQZfZ/CTlrTLXVSeZn1j3XzAloGKZ+JLg==
X-Gm-Gg: ASbGncvaak9rHc74eb8KOIb8Hwf8qzeSzqzMBdjtiwGTu/YU68cMTfugVj3fphYz+JQ
	O2C0y4PTVvHJJ4IC2tQKbAGqqlsJfZyjeVVyFawUwuEGxW2IkgrEkaKoBahs9SDwk3uuygv2AAI
	xDX0Nr9w2M9csAxEaJKyO7H/m91AolUSr5X1BZlp4gKCQ+oO39PjikrSyMMJn/tme0ZlfVRideW
	p9U8Fk3CaHMK7v1oPrRqzR51TSW5uQNYFXywrpXzASLIg6ARKxA3fgV9Um62GLmZITfTiy0/AcA
	tsbiqoW6chyy4FPdb4JmRJXsSHEwrnUkfvZAP0X5WXU3QcILXl6oS99xDjaHnXUdle7U4GspAJB
	LkZT7fY3jVKgKPFH2L2u5wohmfpAJMvYZBb9N
X-Google-Smtp-Source: AGHT+IFfAST3ewlsx82llFbaSdTvytJMxsWvcTpV7jrqeiFP/dsBbZRfwDk5ALwNxpD098moofvEdA==
X-Received: by 2002:a05:6402:238c:b0:61c:e287:7ad3 with SMTP id 4fb4d7f45d1cf-620f3e58fd0mr7021397a12.6.1757286123996;
        Sun, 07 Sep 2025 16:02:03 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.147.138])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-625ef80347asm3363570a12.1.2025.09.07.16.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 16:02:02 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 1/3] io_uring: add helper for *REGISTER_SEND_MSG_RING
Date: Mon,  8 Sep 2025 00:02:58 +0100
Message-ID: <6a0ae8fcbaebdc3add648f27660efc5f58454761.1757286089.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1757286089.git.asml.silence@gmail.com>
References: <cover.1757286089.git.asml.silence@gmail.com>
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
index aa5f56ad8358..50ce87928be0 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -874,6 +874,23 @@ struct file *io_uring_register_get_file(unsigned int fd, bool registered)
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
@@ -882,21 +899,9 @@ static int io_uring_register_blind(unsigned int opcode, void __user *arg,
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


