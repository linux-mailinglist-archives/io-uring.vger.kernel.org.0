Return-Path: <io-uring+bounces-6940-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85AB8A4E4E7
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 17:06:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61679421C99
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 15:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A009C298CC4;
	Tue,  4 Mar 2025 15:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e2/Ix5ii"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93FC298CC0
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 15:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741102783; cv=none; b=BSx2au0cD+/vZ7PsDkHhZEOA/fjjLvgbuHoczf3MVCX2MSuMBSTyTTVcWBibsRJet5LvCeQLTOU0KmUsiHYr/H5zeXzJQ2+YSRk4FPLahUqyZqCChTwr3jPWIbTb+/kBPvB9ipN4HRRxWjpEr6SS5ygqmE0ufjIgN3bmHpIbnnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741102783; c=relaxed/simple;
	bh=dFLQOj2ZLIbINKKwcv5tlrqtAVZRjLUjvTJ5sPCh7Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKrnpYZeA4DjSV8hjrGdLX6805MeA7Yzrf0BZpObIjNu0eQCEVE+njO2f/x1z/8MytI+c6gpApBX3xvoN55OMfuwhlYho50rs6b6DcTYwW2+flrgjqhVWnnts6LAp4QON2I5vcgEd5/LWxOdAigesgoNv9Oe+/FRC3ipf0mWmhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e2/Ix5ii; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-abfe7b5fbe8so317715766b.0
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 07:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741102780; x=1741707580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xq9H3dhjnKdFz5nEV9/T6Wusp8ITCyq4E/MzF/cO3lc=;
        b=e2/Ix5ii5OQnGxMJ3vq1Cl9PTF89ydKooRd/cnf8QPbwZtAXg3bSZ4PdJAilRrcOMr
         1XKONrX2ZU/w6rI04KK0EuCyfhZ7O5B0E45mC10J0egye3EkUFQm05OubNMLFoWzRud5
         OW3xpm8q6l62lqlBMy1lcXfV6FATZWSwfjWi2g5bSC5yPZV2rJrCQwQjRGD/o7tujSAP
         n/Q11WTnDmADvEEkpuxA9qOmaajrVELPSW6Hap89AFdYnwbPTumwviP6X21rAIE3Mxsb
         VYK5MAAA0IYn3bvoVobtK4cxdkCF4QZrWYodPLYSdzApt87JWqq2dZ23NINYJd9riPuh
         yKgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741102780; x=1741707580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xq9H3dhjnKdFz5nEV9/T6Wusp8ITCyq4E/MzF/cO3lc=;
        b=XX0lx7hXVv6G10/M0h5aNOUcmPisRpn5zYzxA/BBWhO9E+ahPnNLG3LIVxmHkFnoD+
         a77f0O0t3BH/YwLNuBLw0q4ApJGmIBoGwb3bWGayxD08mMAuftPH7zUZrMq9jbrHlL2H
         RklxKNgUUwhNV3Oxbkuj5UbSaknXVbGBJn28JAa5IkMQzsr6s9YKRY9ZFwunkDhqfBIk
         csu9HtpjIA1pmPpCJdtxyYwOiv4kd05FS12pcU3S4BLsSW/N15WxGzvp160+KJWRQeR7
         dQhqZoYHjvo03X9YpKphyOSe20WNG3+MhB7Jyo8V5VfEpOvWROAHayjy478xGDM+rgwm
         PkkQ==
X-Gm-Message-State: AOJu0YwofqqkiAa/Zy99yqLuFX0pouffLjqNFT5w1WxQOIcp/123gD0b
	Kr+7Qrwt8+ZO7Crlrm+jj5cIMmL1csAMNSQkzPi1RPD8nnncO3AGBYRzOw==
X-Gm-Gg: ASbGncsDXhuWzNAOhRiQE4s3dii7QFnikeE05JrUqyzUkRY3fbO2GbNA5CKpTGr0rBg
	1duqubVqc5D3Fzy0ShN+wc9gDf3SzMzrdx2+p9qfpepYtZnRaAciT0tdN3L4y+wKCr2z8yjoec3
	Sb57x1MJ0izQq4PVCQu0TOmCaSj4n1BBn40QIpyY/FYVDz8QMulK00D7DUqLcMl84lPWn+cVHpV
	1nUEH/l1MmzCpl7xfDiBxbuizei+QRymqKQ9NEiOr3+WPNfj5i4Xj6ecLoO5vZMYBhF/obF9glS
	z7fpt2FY2WKKv/dKzQAEIWbfpUtP
X-Google-Smtp-Source: AGHT+IFZriAoSOp8xxvRw4vAE9UxOIJvovmxB3/Tv8kdwinW9oWTcfgPKQ1Sz6jIeCu2HzEn1cBHvQ==
X-Received: by 2002:a05:6402:34c6:b0:5de:4a8b:4c9c with SMTP id 4fb4d7f45d1cf-5e4d6b62f6emr45746979a12.32.1741102779457;
        Tue, 04 Mar 2025 07:39:39 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:3bd7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1ecafa17fsm168420966b.162.2025.03.04.07.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 07:39:38 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Andres Freund <andres@anarazel.de>
Subject: [PATCH v2 6/9] io_uring/net: pull vec alloc out of msghdr import
Date: Tue,  4 Mar 2025 15:40:27 +0000
Message-ID: <3e9edc3be022d9dc2ada8577c73b3532f836aaad.1741102644.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741102644.git.asml.silence@gmail.com>
References: <cover.1741102644.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I'll need more control over iovec management, move
io_net_import_vec() out of io_msg_copy_hdr().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 33076bd22c16..cbb889b85cfc 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -253,12 +253,8 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 				return -EFAULT;
 			sr->len = tmp_iov.iov_len;
 		}
-
-		return 0;
 	}
-
-	return io_net_import_vec(req, iomsg, (struct iovec __user *)uiov,
-				 msg->msg_iovlen, ddir);
+	return 0;
 }
 
 static int io_copy_msghdr_from_user(struct user_msghdr *msg,
@@ -328,10 +324,8 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 				return -EFAULT;
 			sr->len = tmp_iov.iov_len;
 		}
-		return 0;
 	}
-
-	return io_net_import_vec(req, iomsg, msg->msg_iov, msg->msg_iovlen, ddir);
+	return 0;
 }
 
 static int io_sendmsg_copy_hdr(struct io_kiocb *req,
@@ -342,6 +336,12 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 	int ret;
 
 	ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_SOURCE, NULL);
+	if (unlikely(ret))
+		return ret;
+
+	if (!(req->flags & REQ_F_BUFFER_SELECT))
+		ret = io_net_import_vec(req, iomsg, msg.msg_iov, msg.msg_iovlen,
+					ITER_SOURCE);
 	/* save msg_control as sys_sendmsg() overwrites it */
 	sr->msg_control = iomsg->msg.msg_control_user;
 	return ret;
@@ -719,6 +719,13 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 	ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_DEST, &iomsg->uaddr);
 	if (unlikely(ret))
 		return ret;
+
+	if (!(req->flags & REQ_F_BUFFER_SELECT)) {
+		ret = io_net_import_vec(req, iomsg, msg.msg_iov, msg.msg_iovlen,
+					ITER_DEST);
+		if (unlikely(ret))
+			return ret;
+	}
 	return io_recvmsg_mshot_prep(req, iomsg, msg.msg_namelen,
 					msg.msg_controllen);
 }
-- 
2.48.1


