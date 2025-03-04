Return-Path: <io-uring+bounces-6939-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9785EA4E4E3
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 17:05:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 930CB17D5A9
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 15:58:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BEFE298CC1;
	Tue,  4 Mar 2025 15:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ukz/llAq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EC0298CB1
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 15:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741102781; cv=none; b=jDhzLOXbzore0P7KwCNm43VvyqagJyXGRiZK77VL/DJM6eQtyhL7LsoyYOldF2mXinfdkM1IV7DHozE3tFa7HAL/MYnFeWL+Fk2oN9HaVOrbIgZPynw9iXRFH4kB43jAFhoNNHGMaHnnj0j29T4gnHjn0plT2J6EMyTEbspTK20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741102781; c=relaxed/simple;
	bh=q/FZLY6NX7KPIL9q2sRYyOUjPSfSZOW4huImrRHQGAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9CSTeebjzENmXZL5Un4fk4ZtuBWnyqXERJYF5+AeCwfrvHKshKdxf2ZUaN0o/fs8pTsNODLAPTlAnHywibWGckMdtgKqqDAsKV0g8xbm6yperkRo5fuNaMa8bo2DaocwV4Ds0oP047RJOp6OrFoeUs3p3g4ujzQkmqGW7idj3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ukz/llAq; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-abf538f7be0so530306766b.3
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 07:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741102778; x=1741707578; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VMFfmh910ijk2bF3gt2GcETiZRuBH9+UmQ8at+7H2ws=;
        b=Ukz/llAqzz6nnEYUXolgAhE2DfJkyrC3eWtiRPhJ2gNv4teohr07Ckqf36d+cy5rd8
         aeIlWTdxV5AD06/OWFdACSPw2ZwR/XA2CSZgBP6Fr/td10j60q1IzLsTO+Zu/ph727dp
         igkr1C5CmPciWqrOjy6yIE+E6iJSDk9Fz4E3rdXKR1NNO1s6hZ8Qn3cwB7WZ/k7pdvwv
         7IBpcu0rkPzoe4Wk79SIU4DKgvMkW3GzkCKMDOhq0om2TUaWhQn2ALCL4RawVYKifn+z
         zLelnPB4cxoP0TeuwX7mlHviPCx1GEc3RNnZTaj/+LgjtLEVaHhvlBRnntWmQSMtUcA3
         nKAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741102778; x=1741707578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VMFfmh910ijk2bF3gt2GcETiZRuBH9+UmQ8at+7H2ws=;
        b=Sqs4C4Q7LX+TPgyEccfJbfJd2s9Y+fGqTcuqOalDy0qK55CVMgHrHixKqq8nK8xUTs
         FUKi1QLzOIrdgSiEKy96+oO6DYEjirwd3XLTOYQbySFFUrMCePjbvb8RtWvG8h+Q78Ay
         CSw754Qh7j3LiTHzkuRmk+9XRtzY2N7AUim0D0yH0I+/OoK3msDHbz7I/oKNBcOkKFC9
         WGZpkB7tWN87Mmk7E9Qjn/mmqc8xtCIfD4h+1LH8IBevYTKiRYfeEnhdjPai8HS6Z4oJ
         3Jy0mzM086F3y5IFIgiJQRBVTfOc7CagoeB1SknHqkleXHMC9HXkVP8NW8FFaSGl+Q7V
         UgCQ==
X-Gm-Message-State: AOJu0YyJypv+bbN0Q2K4EGzTRGVHimYkGL76j6bwZI9tHcYcICLYDx8f
	ITF6xPI/SYWFnum0dUAKdlXajLnaXHtoi5JABRNsAhfbKLk8SyJQGBINlA==
X-Gm-Gg: ASbGncu2KbHG2eYkoHWpBeDjW30yOoRfdFYjnKfSKxOEEAeGHDFM3f3SR+FbMu/XAxm
	9qnRz+QR5BYeNwN4rY518fqmVt+y8sNwupHNXYi7gupGnwYb+9fTEmOINKCd+vxem5Mt62ojlrN
	oP7veWd1Y2aSZGvkEsNokLkfqaNSFB2JthrWZcZ7mN3ipULGBj5wrGQD8tOxOEnYFWRhdMa8SXH
	2c2XcXFpt9rPVdX6t9VkpWM9HOjF0kWQsVLGlJr3kJnzGB4nfuBUoRkIX8aQjUpLyzRp71McreS
	jvZHq9tniBg7MNQJKNAVpVw0yx3f
X-Google-Smtp-Source: AGHT+IEtrgiSzJbLJs07GbvYBSwaLhqcbcC8rTo/06QM7KJC5+aYR1gtYi1diGno/MnOfnHrgjNFPA==
X-Received: by 2002:a17:906:d54f:b0:ac1:ffde:7706 with SMTP id a640c23a62f3a-ac1ffde7a3emr156100066b.25.1741102778207;
        Tue, 04 Mar 2025 07:39:38 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:3bd7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1ecafa17fsm168420966b.162.2025.03.04.07.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 07:39:37 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Andres Freund <andres@anarazel.de>
Subject: [PATCH v2 5/9] io_uring/net: combine msghdr copy
Date: Tue,  4 Mar 2025 15:40:26 +0000
Message-ID: <71be0fd66b80847a948855d825f6db0bb24e049f.1741102644.git.asml.silence@gmail.com>
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

Call the compat version from inside of io_msg_copy_hdr() and don't
duplicate it in callers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 46 +++++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 27 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 905d1ee01201..33076bd22c16 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -287,6 +287,24 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 	struct user_msghdr __user *umsg = sr->umsg;
 	int ret;
 
+	iomsg->msg.msg_name = &iomsg->addr;
+	iomsg->msg.msg_iter.nr_segs = 0;
+
+	if (io_is_compat(req->ctx)) {
+		struct compat_msghdr cmsg;
+
+		ret = io_compat_msg_copy_hdr(req, iomsg, &cmsg, ddir, save_addr);
+		if (ret)
+			return ret;
+
+		memset(&msg, 0, sizeof(msg));
+		msg->msg_namelen = cmsg.msg_namelen;
+		msg->msg_controllen = cmsg.msg_controllen;
+		msg->msg_iov = compat_ptr(cmsg.msg_iov);
+		msg->msg_iovlen = cmsg.msg_iovlen;
+		return 0;
+	}
+
 	ret = io_copy_msghdr_from_user(msg, umsg);
 	if (unlikely(ret))
 		return ret;
@@ -323,18 +341,6 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 	struct user_msghdr msg;
 	int ret;
 
-	iomsg->msg.msg_name = &iomsg->addr;
-	iomsg->msg.msg_iter.nr_segs = 0;
-
-	if (io_is_compat(req->ctx)) {
-		struct compat_msghdr cmsg;
-
-		ret = io_compat_msg_copy_hdr(req, iomsg, &cmsg, ITER_SOURCE,
-					     NULL);
-		sr->msg_control = iomsg->msg.msg_control_user;
-		return ret;
-	}
-
 	ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_SOURCE, NULL);
 	/* save msg_control as sys_sendmsg() overwrites it */
 	sr->msg_control = iomsg->msg.msg_control_user;
@@ -710,21 +716,7 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 	struct user_msghdr msg;
 	int ret;
 
-	iomsg->msg.msg_name = &iomsg->addr;
-	iomsg->msg.msg_iter.nr_segs = 0;
-
-	if (io_is_compat(req->ctx)) {
-		struct compat_msghdr cmsg;
-
-		ret = io_compat_msg_copy_hdr(req, iomsg, &cmsg, ITER_DEST,
-					     &iomsg->uaddr);
-		memset(&msg, 0, sizeof(msg));
-		msg.msg_namelen = cmsg.msg_namelen;
-		msg.msg_controllen = cmsg.msg_controllen;
-	} else {
-		ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_DEST, &iomsg->uaddr);
-	}
-
+	ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_DEST, &iomsg->uaddr);
 	if (unlikely(ret))
 		return ret;
 	return io_recvmsg_mshot_prep(req, iomsg, msg.msg_namelen,
-- 
2.48.1


