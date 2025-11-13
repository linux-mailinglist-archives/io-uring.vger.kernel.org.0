Return-Path: <io-uring+bounces-10574-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A889DC57000
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:52:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A5A804EBB41
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:47:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C930C33C523;
	Thu, 13 Nov 2025 10:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="De4LOw+7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ACE33BBC8
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763030792; cv=none; b=mEGQdLgfyEy0lsfsjo4/3KwHstKpbNoswvzIBJRFbtupaeDW85n3GhfieQWCnc2repO9goWt3XVqVoHjDfa6uD4rN6vRCC3IU47WXtrcthX1UfGXtO3zar3ecq527mZ86XihNwWV714G6XnhpW7i7Ou+3o5G/KaLbay1QxmFH84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763030792; c=relaxed/simple;
	bh=ap1uZ8OKZ1VGPT7gvzx4NvIGBscoe+hIMRR724Quxu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxBfCcItIqtQXOrPgK0a+btyVaylfk+BEvqiRi/b02A3RRnFnJW+xfS+uGcLnPH/kCho3qDscqQFJ28DDM6HCIqxYZqnlHtSJDjnflDMaEhTf+R8k2tNryDGK+xjc+jFJBJHIDY6vJUDmhPl/AaUvJUqIYTOlQnhwlxk1xPw9Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=De4LOw+7; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-477563e28a3so4379765e9.1
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 02:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763030789; x=1763635589; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qVdeD9AeawCexBewceARpbccOt7zF9XT4KxHtfqp8jU=;
        b=De4LOw+7kMvyBEWpa3AoERMhWMlWx17LnVLscjOYOXKoQRuNcwVXF4TualkOoZg+fB
         sK48It0NbMY0VkUu4n2DXbFKTo6rcQq9yzVWqstO5o+QLI5Tp+ayXTaCtni9/OcLlkzi
         WRwNAC4qqos93cSnbCV2UzB9A24PwVDuVBl3uCxVqEYu5b/XdRa6x3l69RQRUtr1106F
         jGFaHQbrfZboJlyeKfmJAUUOk+ubndfadDMr7vAeBWd1gPqBSwQotkKD6ZqEvmmD2X84
         /A3lcs1dHVpAyglklZz01lXHQE7dc9ekcZslkE0MwYa3X+QHKXo/qisltWCHMHn9O/IH
         Oj0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763030789; x=1763635589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qVdeD9AeawCexBewceARpbccOt7zF9XT4KxHtfqp8jU=;
        b=jYg7UWI6xUKf0ut1Slte1MVn5C9mdlk4+fMs2KmKho8L1ii0jabkaW5qICG2byDYi7
         L7m8cjipPZ1J12ClzEsQHMfT4Wb/fl/xOrqN9qI/3QVFcdDXSjGc3033wlSIe6IxkWA0
         cSQ0gbJTfB+dNDrfNdSYdLsILFPHBLhV3QShzlLJrs6OnrfNn3SK9RvS2yfFOXoPYdBW
         RaALJ9tZiIfrNkKZHeeNQOXDuPMCL6ISwKCee4/YVc8hcoaRgphdxV3U5G3tDfELj17b
         bZ4dVwqcy1BhC9A9GekqErtGhtC5L0pFZ6cKxbxKD1FmYWHomhSP7EXv/TJY7fRRBaBD
         R0KA==
X-Gm-Message-State: AOJu0YzKGfbIdluzXxpskPMgC9X3B9MK7hS+8Ph64kLsVQngqyzsS5rg
	8t7ZtssCbm2eQlT1v1tve7pykYw01LQeGnU+ourwwYo/8rAjZVxXdnelDlEs3Q==
X-Gm-Gg: ASbGnct8GhgN219VbitIDITdEo8LeEBL5HfJgiXUdZR0oY/Ipgfx4xPrh4EiFvBJH53
	gLVOyzQOjiPsER0J1OnSoMRCSj5E1mX8WQrnCgpyf89m5geVJjg8XDq3pS2ZE0wU3ZrnTDBFA1Z
	WqJpfT3A4kVW0fJ8As1FWLchtHf+bdMPWZn5lBzYmNCrOsfY3hKe1ZEqNZHHUBUxCACjcNBWbL0
	TS/OfDX1hEQEQgKcCoUKBrwudwUOFEbjDEd2RI4U0MDokQ82LQw7GtDZuWOF/+E4ifODjvpVVui
	7pO3+eyqhgESUNMMAvb8IKsOUBE9r7viGNwYoE63x7Q4Cuc7VoiE77ndo1NtntRNpzb//qq6chU
	PZNypsdZbwtDdI6Dt7V9Vy6iSpL9FSSTZ1oBTeMkwkQpQUn6awdZeaGLDfuQ=
X-Google-Smtp-Source: AGHT+IHkVUkfZOQI7AOFvd4EpLj5bOMNn+T4uPm/5c7yPxv0vG8gT2we0niRWxmbHW8oaxC28UxYjg==
X-Received: by 2002:a05:600c:1819:b0:475:de06:dbaf with SMTP id 5b1f17b1804b1-4778bd1474amr15789455e9.17.1763030788975;
        Thu, 13 Nov 2025 02:46:28 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e7b12asm3135210f8f.10.2025.11.13.02.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 02:46:27 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH 03/10] io_uring/zcrx: elide passing msg flags
Date: Thu, 13 Nov 2025 10:46:11 +0000
Message-ID: <5b3fb48fe1cff736579294b08c511b40e91fe4d4.1763029704.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1763029704.git.asml.silence@gmail.com>
References: <cover.1763029704.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zcrx sqe->msg_flags has never been defined and checked to be zero. It
doesn't need to be a MSG_* bitmask. Keep them undefined, don't mix
with MSG_DONTWAIT, and don't pass into io_zcrx_recv() as it's ignored
anyway.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index adf8a4471511..c7614d822788 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -110,7 +110,6 @@ enum sr_retry_flags {
 
 struct io_recvzc {
 	struct file			*file;
-	unsigned			msg_flags;
 	u16				flags;
 	u32				len;
 	struct io_zcrx_ifq		*ifq;
@@ -1262,8 +1261,7 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	zc->len = READ_ONCE(sqe->len);
 	zc->flags = READ_ONCE(sqe->ioprio);
-	zc->msg_flags = READ_ONCE(sqe->msg_flags);
-	if (zc->msg_flags)
+	if (READ_ONCE(sqe->msg_flags))
 		return -EINVAL;
 	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST | IORING_RECV_MULTISHOT))
 		return -EINVAL;
@@ -1292,8 +1290,7 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 		return -ENOTSOCK;
 
 	len = zc->len;
-	ret = io_zcrx_recv(req, zc->ifq, sock, zc->msg_flags | MSG_DONTWAIT,
-			   issue_flags, &zc->len);
+	ret = io_zcrx_recv(req, zc->ifq, sock, 0, issue_flags, &zc->len);
 	if (len && zc->len == 0) {
 		io_req_set_res(req, 0, 0);
 
-- 
2.49.0


