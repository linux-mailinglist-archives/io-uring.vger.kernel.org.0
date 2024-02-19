Return-Path: <io-uring+bounces-647-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 88F5385ADB3
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 22:29:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29B581F2282C
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 21:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F5556B6E;
	Mon, 19 Feb 2024 21:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GWNQ0WRP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006BC55E47
	for <io-uring@vger.kernel.org>; Mon, 19 Feb 2024 21:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708378082; cv=none; b=Yc/Jzj5KqLqBebw+2aCGqYPF2CT8hYxXJ0U5JhSeN9jh+DK/h2rvjW4Rm99KCxObSLC3ybeiyUwIZP0Vd/HLL3xDyrhfKsyFhv5V31I1CWHQnveiqKbAjiedQPrQgLrlVpfwscekkWPCgmtNmhrOEVtUedA6lwpkxN3hSLGxn+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708378082; c=relaxed/simple;
	bh=taZLZYe9/lGhZlFpg6RgyuB6JMR1eg7+Ku/sLaHYol0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4kyStMTirhHCceleD5dSnXrHWpCv/ddH1n1zVZJrukfdydiT9brLTxKXJH9ria/SJawPqZZVkQU3OrE1Zw5plGPppKIg1k5ifDZC0ysFkNDfpcEO29Vras1iHLO3yY8+908o+rBn2RSRolriUjBGiQgHGUFPbvNhxliwPVMoFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GWNQ0WRP; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e4784216cbso56047b3a.0
        for <io-uring@vger.kernel.org>; Mon, 19 Feb 2024 13:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708378080; x=1708982880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iQJvsw/J6sK+/X03ucFK8E4fqOrLrmHIUymPpkqPOW8=;
        b=GWNQ0WRPnAiynwPE2axBzD/lBxW+ojw9hoK+U5lcPkueMME3ULKAvl8sq0gOBHHaIt
         4gTQXweg8PQVtyWsLPDndTV8fakTayWSdgdvvZgUuraEH7BkxgpbGI5VP7tgP6lW6BE7
         TKxXeKguegG6534Ktrmv/PlGRfFG+f9rY5wJyzE5l9UWHi/MN7UvI0kCGw4SxdLSkBA6
         dINOYIOL18K7wAdA4O2rW2Rs9TEN2SMdNJ5RQJkgh5J57eKwbEcMKcwSp/+EwdDXFINn
         wljmJTdd60DiuFiatTNtCzuRlcCDBWT26vURLEfWiLJaN5jMJj65MCVYp47VuPqIHJP9
         acLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708378080; x=1708982880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iQJvsw/J6sK+/X03ucFK8E4fqOrLrmHIUymPpkqPOW8=;
        b=V/h7TSOSbstefAycggJvXRt8z+JQfPyik/v3Q5gMHTK7OzQers0IT0XM+o0uMOACVW
         jeJJc+3MA6vFWRqLpHEgOckvGAaB6Nc2+BxOUPFPGRMVzdSxUQTfU1vdqKvAgwcVfMQ2
         9pP7xDh1URLQSZD0LyqcNSQ+L6lGv80qItDttoHWOcv2pI2JXwvGyXok7w6bpOMBExsC
         IXEI51crIpw8jiZma7psD8bPJnC1MTtF+BSAXHPAUpEPXsd7trS2PBFBm7nbVuGlE62j
         CwVS0dcHAfgL+sxk244wqMOUF62C9b3bHjQKh6ULaSSr95HP9dyclqF/vhoc4czfCZcn
         VNmQ==
X-Gm-Message-State: AOJu0Yzg29/PqFhAT7/nKoYoXqL3a83VLxxFUj1G0erzZVZQfV4kPPzb
	/O3Qx9DtJEprQppS5nflBv1cQW/CQEScEV4X0jSUaE0uydgS2vDUl9qFSmytdNygvr5xrIHOv4x
	O
X-Google-Smtp-Source: AGHT+IFrzr9AMXwoB1VIzIWPn53A7QvxUfQvzQbiHqp+n8D0WBtDF51S3eqKkSWnvFtL8nanP5j6HQ==
X-Received: by 2002:a05:6a00:1c88:b0:6e4:5e66:6815 with SMTP id y8-20020a056a001c8800b006e45e666815mr5148474pfw.3.1708378078847;
        Mon, 19 Feb 2024 13:27:58 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id q13-20020a056a00088d00b006e05c801748sm5279770pfj.199.2024.02.19.13.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 13:27:57 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/net: add provided buffer support for IORING_OP_SENDMSG
Date: Mon, 19 Feb 2024 14:25:27 -0700
Message-ID: <20240219212748.3826830-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219212748.3826830-1-axboe@kernel.dk>
References: <20240219212748.3826830-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adds provided buffer support for sendmsg as well, see the previous commit
that added it to IORING_OP_SEND for a longer explanation of why this
makes sense.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c   | 15 ++++++++++++++-
 io_uring/opdef.c |  1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 10b6d8caf4da..30afb394efd7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -436,6 +436,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
+	unsigned int cflags;
 	unsigned flags;
 	int min_ret = 0;
 	int ret;
@@ -458,6 +459,17 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return io_setup_async_msg(req, kmsg, issue_flags);
 
+	if (io_do_buffer_select(req)) {
+		void __user *buf;
+		size_t len = sr->len;
+
+		buf = io_buffer_select(req, &len, issue_flags);
+		if (!buf)
+			return -ENOBUFS;
+
+		iov_iter_ubuf(&kmsg->msg.msg_iter, ITER_SOURCE, buf, len);
+	}
+
 	flags = sr->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
@@ -576,7 +588,8 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		ret += sr->done_io;
 	else if (sr->done_io)
 		ret = sr->done_io;
-	io_req_set_res(req, ret, 0);
+	cflags = io_put_kbuf(req, issue_flags);
+	io_req_set_res(req, ret, cflags);
 	return IOU_OK;
 }
 
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 88fbe5cfd379..1f6b09e61ef8 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -139,6 +139,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollout		= 1,
 		.ioprio			= 1,
 		.manual_alloc		= 1,
+		.buffer_select		= 1,
 #if defined(CONFIG_NET)
 		.prep			= io_sendmsg_prep,
 		.issue			= io_sendmsg,
-- 
2.43.0


