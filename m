Return-Path: <io-uring+bounces-7317-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F427A76BC0
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 18:17:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED9441676BF
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 16:17:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8EB126AF6;
	Mon, 31 Mar 2025 16:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KR0QV3hj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B5F2144A3
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 16:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743437810; cv=none; b=Isekpbr6pvIFInntf/GD5Vffgh3vHYSmTzYMm3QcT7zr8l3GhOr2u9n1EK8gU4AtgVjCn8irurmuuygngf/aF4Vqr43166+dgAM4MRk4XDrJeXccTLKfxw3nQPO34dggK4wWL6/1Cwu+s4LTTXatnNHYFLh1EBVq9bX9op0GhWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743437810; c=relaxed/simple;
	bh=BDB26qxnVa5Dysy+YcDhMNRM+1YrQK/8TCzmz1KqEug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1SgwxplnrhdCClX0gs/Y9rrKMIxcMcB7w+Yh8q4nyMBwNl0krWC7RGq2xKOLp5pcc2Rao5R9kUmpDCWZGREWV9NZ7muji+3hWlhv8Y1dKEovPEthEf9D00ufPBnyNR6DkR0+MQVpuTE5LGuHX1tyOKWc4pi89OoGViGocH64I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KR0QV3hj; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5ed43460d6bso7697260a12.0
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 09:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743437807; x=1744042607; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=brTmowcR2O2yysIMIdutbGCklK4JFqu2hVoGfYEEdFA=;
        b=KR0QV3hjYk18nhQqPhOydB08xGqCSQYuIIVZeQ+NWBoJVmYyCvpmClKWpRM/ptmZ5k
         VGqvZi+6bokiZkTUSpdMWOo0UkfyNgDVJkpWsvEs6Aef80zS1oBcwCWwdbcX+rVixPkD
         zTNiMPb9MaAUuK6ot+OyYi2Outo2B1awIVCtb96hwI/fV77Yfgn5uvx/fUmZcY5fiwL3
         sF1McRU7IKJ+vu3LvJDhDMaeR9mBQoERYm0X+L0OE9XisYtkl2jjgJYpSZJYK9L5Pkyy
         NWXSg06zXsc/T+G+GKLjcbhKeZWwFlaeQYIpvOiZyqNm1kPqYvxYCDIGD8Js2ecK6wpn
         OQ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743437807; x=1744042607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=brTmowcR2O2yysIMIdutbGCklK4JFqu2hVoGfYEEdFA=;
        b=tTEpPisPuGDhSLKHeqNX3MFY1bwMWTunwnlEFDN6dhNCqy7+sFWHlDBNlHVNCCpjKu
         HdFPolKFyiNMKErqikL2LqCRsoZrP2XKEfH9aV5PPAbXcGF4RTTK+8vjpmilsUtLRs83
         Z29Ev5zbHzlFmOOBa6AuWrudho6QHqxcUbEyZXSDHHPWMgEiyHoXxaoyQEqzbeibneFd
         gHLIaL4ekJJBj5NEQSl/rVDNT4FIuW15g8kbd5fDMQ8vodmZyyU625p1tR8dz598bAn9
         j1g8T0H7wAY68upFLnf6ik8+zCyx64EOt+un70SvXxt4119UY2tIK7nyDOFg1VmfY5sq
         Q1OA==
X-Gm-Message-State: AOJu0YxXgoozf3iHcGjUM8okZ62ixM3OyjADLTsw2nye/9fKFzpPM4eV
	qbIysNUS3ZGzo4j2yYLB6PxLpt6fJdc3jFjnxNrWTFyZjlMNoo0tBFOj+w==
X-Gm-Gg: ASbGnctaqEonMNapUQCOwN0KHRIOC7luCvWtt60x3d+ioOQ+wddMyQLkr6o4UaTQI4u
	mJ+YAQ5Kt8vVx//3RkWjGaxKFIuUVF3+rAULJdlyaFSFxcsqv3pi2hTQnKhKpAGwvIQUxH8Xtx0
	P7ERknaxHcuWUbJ53qsMZSc8i/Ze0L8JHcre9lfrhE0s5ooP6qB5jiwX7BOOZaCEIOhaaNSfasE
	AZayQwgGKO631sq6Qzr0R7YnNYLzdsYvWz2PyJOZJ91znzhBxGiolfhj5Yu15ucZdnPuR1CT0al
	XsPd0h3MbjFIfTEF5EMakbhBhfho3I9CXJbDjuE=
X-Google-Smtp-Source: AGHT+IGUy7ixJ5zsgkLcY9Q2ZUwcNDzQPsBK8uzHZH2uG/Pdz2g0RNywMeNjCoezJJ4CQ4t1V+NBMg==
X-Received: by 2002:a05:6402:51c6:b0:5ed:89f0:27fd with SMTP id 4fb4d7f45d1cf-5edfd13e6d5mr8221484a12.19.1743437806574;
        Mon, 31 Mar 2025 09:16:46 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:f457])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5edc16d2dd0sm5861458a12.21.2025.03.31.09.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 09:16:44 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/5] io_uring/net: don't use io_do_buffer_select at prep
Date: Mon, 31 Mar 2025 17:17:59 +0100
Message-ID: <4488a029ac698554bebf732263fe19d7734affa6.1743437358.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743437358.git.asml.silence@gmail.com>
References: <cover.1743437358.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prep code is interested whether it's a selected buffer request, not
whether a buffer has already been selected like what
io_do_buffer_select() returns. Check for REQ_F_BUFFER_SELECT directly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 3b50151577be..f0809102cdf4 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -361,13 +361,9 @@ static int io_send_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	}
 	if (sr->flags & IORING_RECVSEND_FIXED_BUF)
 		return 0;
-	if (!io_do_buffer_select(req)) {
-		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
-				  &kmsg->msg.msg_iter);
-		if (unlikely(ret < 0))
-			return ret;
-	}
-	return 0;
+	if (req->flags & REQ_F_BUFFER_SELECT)
+		return 0;
+	return import_ubuf(ITER_SOURCE, sr->buf, sr->len, &kmsg->msg.msg_iter);
 }
 
 static int io_sendmsg_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -724,7 +720,6 @@ static int io_recvmsg_prep_setup(struct io_kiocb *req)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg;
-	int ret;
 
 	kmsg = io_msg_alloc_async(req);
 	if (unlikely(!kmsg))
@@ -740,13 +735,10 @@ static int io_recvmsg_prep_setup(struct io_kiocb *req)
 		kmsg->msg.msg_iocb = NULL;
 		kmsg->msg.msg_ubuf = NULL;
 
-		if (!io_do_buffer_select(req)) {
-			ret = import_ubuf(ITER_DEST, sr->buf, sr->len,
-					  &kmsg->msg.msg_iter);
-			if (unlikely(ret))
-				return ret;
-		}
-		return 0;
+		if (req->flags & REQ_F_BUFFER_SELECT)
+			return 0;
+		return import_ubuf(ITER_DEST, sr->buf, sr->len,
+				   &kmsg->msg.msg_iter);
 	}
 
 	return io_recvmsg_copy_hdr(req, kmsg);
-- 
2.48.1


