Return-Path: <io-uring+bounces-708-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A1786289B
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 01:40:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 887C3281DB9
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 00:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FD84EC2;
	Sun, 25 Feb 2024 00:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="flxHyOLO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F2B1373
	for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 00:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708821600; cv=none; b=Mdc2M5akSvqaYDbvgT3UehH8PWsGYdkkplPMpjTlyrTZThp/lyAagu5sLVW1LG38Qp0eocqiBNwHyM422qfVgf6Rv2XaGTR+4JEBlUYCxpyxKx0NEXdRIW8apHLg5b6+gINsbRbifTk3EeP2kTEKAFoBDsx6hISWeVJSJ2Mkn8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708821600; c=relaxed/simple;
	bh=P5ixUEnPDqgCgetkEGXKZH60xYxsyTjwl9mK1THuS/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMUOYunDUC8hRBdagvYdDWVh1+ee4DOxrekNPtBaWMx+sSFFfyv2plQgwU7s471nna8YvYi9J3AHfwBnMfrC3ERX05b/J5F+3NnhNADnQj8/kfXNksoeFaeP80QdENn/jNjQOUfpPdLQSuEAW/+9KoWPE95gNFGCAtUgexrbV9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=flxHyOLO; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-58962bf3f89so754894a12.0
        for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 16:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708821597; x=1709426397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8nERVJumMFm9j/dfRWnpXO7RdH3oxXK+/zTrBj/X2q4=;
        b=flxHyOLO+QR/6CDFrRrpbMNIuftUZfwHAchosWpnKHonwiTh38jG+uMjndsYq25a5z
         cNWbe9Jt8FcmadKhKtdp8DWaOB0yLyo6tqd0udRIBPycVh/cT0K/bz6Tgn5++Sue33Je
         xMwZydag1c9iK9f8OwbMXnpzC1prm6Nh4flQOY3ZiYY62QT7mInGwirlcrh7m+9+ekxB
         Y1xkEdnX8fKsJJeCr0VosFZ0IrjQcnPESNYpo30DGP+iSM0i78KjlgQeCCMuVGxegCdL
         R5qHgPfuIuN4TS0KmGJjXMkMiboj8UPgOJELZXEj+vWxtoRdp2H5CSW1GqT2x8Px5rJN
         ICgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708821597; x=1709426397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8nERVJumMFm9j/dfRWnpXO7RdH3oxXK+/zTrBj/X2q4=;
        b=TfC9nno53gU8kiaE1wnYJZkRw56Au5X/C8l0qh/EwwC6944tZo/Fmj/ZqPXhjI6Dy+
         4KjU6zW4ISgm7YabKIgQW83eKcWK59S8zBEk/KQ7+68HcbziO1mDLRzMV14SldKfEdVU
         HfvV4t0sm7S2UBHP0uUsDwH2pa4wFefrywwAKdiQ4pmWrzzp/V+4KlOvh+MZu87lW49O
         OBE6ydeFYJhJjzLO0oaC4vkCgMDwRTC+qww+OSLYJYRzHgte3pERdjqxZeRLdMUsuL4x
         CIA/bn3/BukpUytM+21mlaFV+OOMGdCa9XK4BHgw9U5ZElEakwYppz3gUojTk1epvbg6
         eIIw==
X-Gm-Message-State: AOJu0YxhSDp7U6yOrICH2zjjBTJOsajqzEWLvEUbWq2DQRvyrRWVYX97
	1YgDBeH8bONtPeIiXZCuy1/UGfQv3y9xPLqVfqiCXgJeebuEj8lLQ/e+8Nz1WUMt+C0acIGYBCW
	o
X-Google-Smtp-Source: AGHT+IFaAfw+8zMkjQQlObRVu9V53qgpLdtsXDIupcJCxd0ZgAiWAp8h7llNJv4SmhU+wPCNjAXwsw==
X-Received: by 2002:a05:6a20:4283:b0:1a0:e557:7ec3 with SMTP id o3-20020a056a20428300b001a0e5577ec3mr5203630pzj.1.1708821597391;
        Sat, 24 Feb 2024 16:39:57 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id u3-20020a62d443000000b006e24991dd5bsm1716170pfl.98.2024.02.24.16.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Feb 2024 16:39:55 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/8] io_uring/net: support multishot for sendmsg
Date: Sat, 24 Feb 2024 17:35:53 -0700
Message-ID: <20240225003941.129030-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240225003941.129030-1-axboe@kernel.dk>
References: <20240225003941.129030-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Same as the IORING_OP_SEND multishot mode. Needs further work, but it's
functional and can be tested.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 8237ac5c957f..240b8eff1a78 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -494,7 +494,6 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
-	unsigned int cflags;
 	unsigned flags;
 	int min_ret = 0;
 	int ret;
@@ -517,6 +516,10 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return io_setup_async_msg(req, kmsg, issue_flags);
 
+	if (!io_check_multishot(req, issue_flags))
+		return io_setup_async_msg(req, kmsg, issue_flags);
+
+retry_multishot:
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
 		size_t len = sr->len;
@@ -537,8 +540,14 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
 
 	if (ret < min_ret) {
-		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
-			return io_setup_async_msg(req, kmsg, issue_flags);
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK)) {
+			ret = io_setup_async_msg(req, kmsg, issue_flags);
+			if (ret == -EAGAIN && (issue_flags & IO_URING_F_MULTISHOT)) {
+				io_kbuf_recycle(req, issue_flags);
+				return IOU_ISSUE_SKIP_COMPLETE;
+			}
+			return ret;
+		}
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			kmsg->msg.msg_controllen = 0;
 			kmsg->msg.msg_control = NULL;
@@ -550,18 +559,22 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 			ret = -EINTR;
 		req_set_fail(req);
 	}
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
+	else
+		io_kbuf_recycle(req, issue_flags);
+
+	if (!io_send_finish(req, &ret, &kmsg->msg, issue_flags))
+		goto retry_multishot;
+
 	/* fast path, check for non-NULL to avoid function call */
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_netmsg_recycle(req, issue_flags);
-	if (ret >= 0)
-		ret += sr->done_io;
-	else if (sr->done_io)
-		ret = sr->done_io;
-	cflags = io_put_kbuf(req, issue_flags);
-	io_req_set_res(req, ret, cflags);
-	return IOU_OK;
+	return ret;
 }
 
 int io_send(struct io_kiocb *req, unsigned int issue_flags)
-- 
2.43.0


