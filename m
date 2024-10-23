Return-Path: <io-uring+bounces-3932-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DAAC9ABB9E
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 04:37:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C84341F24634
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 02:37:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B6BB8825;
	Wed, 23 Oct 2024 02:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SId/y5rG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6183E47B
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 02:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729651067; cv=none; b=hLOuXiZP7glsbkuF0FyzYNy7RTQGW1E6pIsH1OKIlgJc8CBCoGlZSiZbsHotTCAoVJsKafpDjrAEBWe5nU1i3X3u1Tc4821k7O8ipBIAoxEhI8TpBCC3kqtv0xYvaqNnPu409IavimHHrq7pEE/p1jtIUNZ5esVONt1Pc5XT2aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729651067; c=relaxed/simple;
	bh=EfHPem0do0GYFx0J09ST4Cctmb18cdKIyDDQs68dbFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewDOwFVxsJoH55p/Kok1hg+biRjEc8i6QUlskDeu0vYiR8hpkfLBy+GhSrWpLLoQiGxxq3scHHucR7pJ0CiN3mKEWayKo7BIKoK+VEzB4+K2i4rN7K00aQYdQSMtRBi70aGvpY2QwfXVhClsLCJXx0IHd2jZ2SY7pTVI3MgfL9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SId/y5rG; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4314f38d274so85721095e9.1
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 19:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729651064; x=1730255864; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cMUVtpGdejGLLGPI3KH9jr++Ui3+MXActRRl7F9MiG0=;
        b=SId/y5rG0HYRoF6WID9+cYzUPgxKRBkaKOaFzNwqV+zWsR2UdeHwRvbHNegX+64ypa
         OHw3ih6CpfQ1T9alljbW3yLPLDTumb6KWOjr8yu2T6K0u7afQonXhDRlMhH3XRI/71/l
         pFiEvsIxY7+ye/D6r2DhJg3BSAbCdbgbDucw9dyAyBs+gmCmGBGI0CdD+Gcrvlar8aCt
         U8nwtvaLrzcEWf6DPtay4PYCLm7Se90u8P7fW77i7XbmZmAOaHDkMy8mna/njv/BtuwW
         aqdXQ8R72cUz+IffI6F8UICFLYGt80v/TQ8FpO3R0Yaz9ZTIOTNSaEDkK3wRSwHVsOr6
         DKXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729651064; x=1730255864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cMUVtpGdejGLLGPI3KH9jr++Ui3+MXActRRl7F9MiG0=;
        b=TfM2j6dn5zuJ6NUgYhk8IWTMTfahVQ9jBz10Qx6D2q/a6ZSFw4eIGRoDg0ARLm+XCL
         ANyQ4FFHpgYzxDnhlVPpCkK4Daqpzn3jdHktlGvSE/swaBpMhFmlpKTF1nqcLw6xZmFl
         lwYNMPSTKUWUlE1/qsgr2JrMOB2YW2mT8+nL1ohUa/VdDnitjKG7PvvHVzmDD1ghiJOw
         qa5xKhBAVDrSjA+dTKSLPq23Fh2lHpljF30mIZHV2JEusy0iNzu7A6aJXbl4rvEPS0ww
         ALef8miJRm1xLRcu0ne3T2G9j8eu0bXntTnDOn2dzqstBtz4Vn36l8KCXdVbFNPeMl7k
         E3Jw==
X-Gm-Message-State: AOJu0Yxz231G5iTRI66JQ1TwWaueMJOgnuY4Ll5deMDxBN/g5vCY4FJN
	dAT/fsbTV84SKzPsYZsM/kJtL17RTYvnJAMCIgk+WgIvgDhHvKmQM/PnZw==
X-Google-Smtp-Source: AGHT+IGJmXL397yq8TyJXKBKMg+ObMyezQt41230F9t/wCVT1PJgGlEL04FSpQWUyQe/9se0IEn5NQ==
X-Received: by 2002:adf:e952:0:b0:37d:3705:84e7 with SMTP id ffacd0b85a97d-37efcf05c67mr750166f8f.17.1729651063420;
        Tue, 22 Oct 2024 19:37:43 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91371046sm410418766b.139.2024.10.22.19.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 19:37:42 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 1/4] io_uring/net: introduce io_kmsg_set_iovec
Date: Wed, 23 Oct 2024 03:38:18 +0100
Message-ID: <c987adc69862de06c50f10d55502064478fd9f2d.1729650350.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1729650350.git.asml.silence@gmail.com>
References: <cover.1729650350.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A prep patch, add a helper function taking an allocated iovec and
assigning it to the kmsg cache. It'll be expanded upon in the following
patch.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 0a0b148a153c..bd24290fa646 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -125,12 +125,18 @@ static bool io_net_retry(struct socket *sock, int flags)
 	return sock->type == SOCK_STREAM || sock->type == SOCK_SEQPACKET;
 }
 
+static inline void io_kmsg_set_iovec(struct io_async_msghdr *kmsg,
+				     struct iovec *iov, int nr)
+{
+	kmsg->free_iov_nr = nr;
+	kmsg->free_iov = iov;
+}
+
 static void io_netmsg_iovec_free(struct io_async_msghdr *kmsg)
 {
 	if (kmsg->free_iov) {
 		kfree(kmsg->free_iov);
-		kmsg->free_iov_nr = 0;
-		kmsg->free_iov = NULL;
+		io_kmsg_set_iovec(kmsg, NULL, 0);
 	}
 }
 
@@ -174,8 +180,7 @@ static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req)
 
 	if (!io_alloc_async_data(req)) {
 		hdr = req->async_data;
-		hdr->free_iov_nr = 0;
-		hdr->free_iov = NULL;
+		io_kmsg_set_iovec(hdr, NULL, 0);
 		return hdr;
 	}
 	return NULL;
@@ -187,10 +192,9 @@ static int io_net_vec_assign(struct io_kiocb *req, struct io_async_msghdr *kmsg,
 {
 	if (iov) {
 		req->flags |= REQ_F_NEED_CLEANUP;
-		kmsg->free_iov_nr = kmsg->msg.msg_iter.nr_segs;
 		if (kmsg->free_iov)
 			kfree(kmsg->free_iov);
-		kmsg->free_iov = iov;
+		io_kmsg_set_iovec(kmsg, iov, kmsg->msg.msg_iter.nr_segs);
 	}
 	return 0;
 }
@@ -623,8 +627,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 			return ret;
 
 		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_iov) {
-			kmsg->free_iov_nr = ret;
-			kmsg->free_iov = arg.iovs;
+			io_kmsg_set_iovec(kmsg, arg.iovs, ret);
 			req->flags |= REQ_F_NEED_CLEANUP;
 		}
 		sr->len = arg.out_len;
@@ -1107,8 +1110,7 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		iov_iter_init(&kmsg->msg.msg_iter, ITER_DEST, arg.iovs, ret,
 				arg.out_len);
 		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_iov) {
-			kmsg->free_iov_nr = ret;
-			kmsg->free_iov = arg.iovs;
+			io_kmsg_set_iovec(kmsg, arg.iovs, ret);
 			req->flags |= REQ_F_NEED_CLEANUP;
 		}
 	} else {
-- 
2.46.0


