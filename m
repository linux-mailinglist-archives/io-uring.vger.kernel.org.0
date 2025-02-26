Return-Path: <io-uring+bounces-6783-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CF37A45D61
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 12:40:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C37BC1690EE
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 11:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E343215769;
	Wed, 26 Feb 2025 11:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C0HsjIJ0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCFD216380
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 11:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740570044; cv=none; b=JMIWJ6GTBp6W6uBZ1fto3h+IJj4UxtC9I5YT934WPKSepzv4xHH6OD/rPCGo693nqDCYgeoC4Zc9zas4FqxI5m0/E59WxRGMG4k5eL9M34G1hsyzjyvxvpnRt5kF1gBHzPAWpR6wiVgGMix8DcsYpN7VnEYlpteVCabCPnLO0b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740570044; c=relaxed/simple;
	bh=ZjqhMIKWojNH1Fw5h0ut7wxl/cVzvmR5RoeB+laF98k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKrgLP2PreNpc0mD4MtTiIk5p9dhLyzSAGwXEhK1k8nWN0EsSwxcUJAGfm6maK/+GHQwa20PukXE+Q0P1S8869gRVnDt+Plt9LSTFSf4Q3PVHAsYNC9RgC/lfTrIjGwP1gMzidYLI7EV+GxEqRvw1Ocjf0vPMO7GRWd3PBNjjFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C0HsjIJ0; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5e05717755bso10164644a12.0
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 03:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740570040; x=1741174840; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d2FjhbDI3XS7khyxUO37XmaPy8jPaHgTcWcgyeR3Bjo=;
        b=C0HsjIJ0MDRnWtjc8WcLv5v+YdlVtHEWGUt+zSAHdnhlFIlBGqh4O+VS5LSv/PWlgI
         K3vvfx6iZaDIvd7ZQCT/wP3bJL1hbYkgnGqn3YT3rjR1xWotnTCx1F0f2LiCwZRATDnO
         SpJbcd9lUs9A8dJUyJA4V92Izy0oOrc14o+/8nsyvDC+G14V6TSlzSsTzTaYBbOYYWbu
         Asr3xDootklHzRtDvYXYzwMyj2IAyvpSxX6munElF6YXZWafmvLKrzoN9dxrTCb0jHUe
         cfU88YOA0U7+nxi1CJnHPi96ronblAaJqwCKFLbFckAdM+NPOeS9nYorLPuUZHMf+k0T
         ZtBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740570040; x=1741174840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d2FjhbDI3XS7khyxUO37XmaPy8jPaHgTcWcgyeR3Bjo=;
        b=j3JVCDl7GH4nCJFV/OJpL7CZcVaPkVhpNr47wwO/4GZDgMjoTUkkaxbD7Ah9dphsw/
         sWpT7LNZmlRnYG7SLj0cl0+xghsFdesp3KnV2XU2FI88fj1aKOBsaGqzhyxSJqIxYEHt
         wBjJFCDptBRfMB4OTKTJje0uZOG9pyuaZOLsy065lur0tzVu/yN9idSDTp9R+mBQ9O2R
         G03kYf3nGdGxDmR6ky0NbJn7LnowZsQbHtxZQGobOrqIdThs/WnypDDp2iCuY7A9QfQe
         ZOAS2HBvDFCFb3TaBrRgg1co2VB0Z53BpU2RM++20TpcOAA9UlyZ1/PoiXGPoOcUtWZ4
         Gy6A==
X-Gm-Message-State: AOJu0YxNEOGNlX7c43+DQx5XFOZjg8Qjygg8Rc6lUHXm7Gowe6qm+PJs
	fYXQZOiQ+/laVlUSwBDn2pMsEWjgR5u+yaAglhE1K1QyIC768FF3W5s8dg==
X-Gm-Gg: ASbGncvlnvmrcfniLB+7Qh5OOOA26jCEe3ATi2W4QD2w8ldByOsdQiHwoBkhkk2O8E+
	YEXuV3TBLur5sLMP/WoZJqh8J5khcrHOc+3XSzu+d+DkE9zQZbwbc376o/Za3mRZ5RcYOcop2Gr
	+DYkq1Ro7Ic0G5vwtJwPKOhmA1R/IvfKq5d6TTZfprlZjRqfeqW6MMWwZV5TPJCApnAb+YV24+9
	QkUr9LVDyYHPrQNYm+HWB5PSe297m1UE9p2ol626vw8e4CqAnIeGZJSty6EjsXdLZGbmxkib4UF
	Kba6tAE4QA==
X-Google-Smtp-Source: AGHT+IFe1iy3YKe9l4rfiHeXdmiRwkwkQM1EwKgD0AuAXULvyCOXnxOMnUxDgEqv1vihvAMjxzhpaw==
X-Received: by 2002:a05:6402:1e96:b0:5de:dff7:7d8f with SMTP id 4fb4d7f45d1cf-5e4469dd8b9mr9219072a12.18.1740570040104;
        Wed, 26 Feb 2025 03:40:40 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:7b07])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e45b80b935sm2692418a12.41.2025.02.26.03.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 03:40:39 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 5/7] io_uring/net: derive iovec storage later
Date: Wed, 26 Feb 2025 11:41:19 +0000
Message-ID: <8bfa7d74c33e37860a724f4e0e96660c25cd4c02.1740569495.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740569495.git.asml.silence@gmail.com>
References: <cover.1740569495.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't read free_iov until right before we need it to import the iovec.
The only place that uses it before that is provided buffer selection,
but it only serves as temporary storage and iovec content is not reused
afterwards, so use a local variable for that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 14eeebfd8a5a..8a9ec4783a2b 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -203,14 +203,6 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 	struct iovec *iov;
 	int ret, nr_segs;
 
-	if (iomsg->free_iov) {
-		nr_segs = iomsg->free_iov_nr;
-		iov = iomsg->free_iov;
-	} else {
-		iov = &iomsg->fast_iov;
-		nr_segs = 1;
-	}
-
 	if (copy_from_user(msg, sr->umsg_compat, sizeof(*msg)))
 		return -EFAULT;
 
@@ -221,8 +213,7 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 	uiov = compat_ptr(msg->msg_iov);
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		if (msg->msg_iovlen == 0) {
-			sr->len = iov->iov_len = 0;
-			iov->iov_base = NULL;
+			sr->len = 0;
 		} else if (msg->msg_iovlen > 1) {
 			return -EINVAL;
 		} else {
@@ -238,6 +229,14 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 		return 0;
 	}
 
+	if (iomsg->free_iov) {
+		nr_segs = iomsg->free_iov_nr;
+		iov = iomsg->free_iov;
+	} else {
+		iov = &iomsg->fast_iov;
+		nr_segs = 1;
+	}
+
 	ret = __import_iovec(ddir, (struct iovec __user *)uiov, msg->msg_iovlen,
 				nr_segs, &iov, &iomsg->msg.msg_iter, true);
 	if (unlikely(ret < 0))
@@ -275,14 +274,6 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 	struct iovec *iov;
 	int ret, nr_segs;
 
-	if (iomsg->free_iov) {
-		nr_segs = iomsg->free_iov_nr;
-		iov = iomsg->free_iov;
-	} else {
-		iov = &iomsg->fast_iov;
-		nr_segs = 1;
-	}
-
 	ret = io_copy_msghdr_from_user(msg, umsg);
 	if (unlikely(ret))
 		return ret;
@@ -295,20 +286,28 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		if (msg->msg_iovlen == 0) {
-			sr->len = iov->iov_len = 0;
-			iov->iov_base = NULL;
+			sr->len = 0;
 		} else if (msg->msg_iovlen > 1) {
 			return -EINVAL;
 		} else {
 			struct iovec __user *uiov = msg->msg_iov;
+			struct iovec tmp_iov;
 
-			if (copy_from_user(iov, uiov, sizeof(*iov)))
+			if (copy_from_user(&tmp_iov, uiov, sizeof(tmp_iov)))
 				return -EFAULT;
-			sr->len = iov->iov_len;
+			sr->len = tmp_iov.iov_len;
 		}
 		return 0;
 	}
 
+	if (iomsg->free_iov) {
+		nr_segs = iomsg->free_iov_nr;
+		iov = iomsg->free_iov;
+	} else {
+		iov = &iomsg->fast_iov;
+		nr_segs = 1;
+	}
+
 	ret = __import_iovec(ddir, msg->msg_iov, msg->msg_iovlen, nr_segs,
 				&iov, &iomsg->msg.msg_iter, false);
 	if (unlikely(ret < 0))
-- 
2.48.1


