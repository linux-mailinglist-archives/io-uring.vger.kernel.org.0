Return-Path: <io-uring+bounces-11946-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kDFWATwFeWk3ugEAu9opvQ
	(envelope-from <io-uring+bounces-11946-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 19:34:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 64CC999253
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 19:34:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3F9C73074A6A
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 18:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7253328246;
	Tue, 27 Jan 2026 18:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PFypzoVM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D19327BF4
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 18:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769538800; cv=none; b=XlkZZCPSbmJXpjjH+evI1Ocq4BMkfz8a9CbQwcjWjaLTz/X06kgddRycXNCu7KbWJZwGx9qMsSXq+85UcRJ2ZUyOaRU6BsUOFHmZLeaFxmB7pzeW0oObi4J13r3UXfXTKTSZFavQAxaMphj8H1AfiafoJ7151SwS3dBrzc8APu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769538800; c=relaxed/simple;
	bh=2xgw0e4rGDrGC5UYd/H0Fu/bjp4HcjhxLYk3aWVibCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCJSXofGlb/xcQbQ2/F7D4x4EyXkf5bKZqXu3tpi662/pI9RprG/kRFQlHdeLmmQ+VVcsnbxUCCFgTiEvXC++1nweGzpf9258RMofl40cK6yWq60s9Iny7RCw3gJC3O6fPL6ow15/fJULUnt0dFNw/g1aWNpf/TRLQob47FqJh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PFypzoVM; arc=none smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1249acd6ad2so1604233c88.0
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 10:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769538798; x=1770143598; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yHX7748gxORjaCJqCbdbPxtHhuUnXJdKJ2s3V+FA30o=;
        b=PFypzoVM5en/innuD510oE2GnPOk+3AayVSvA/qaiCpuGVvhR1ojiuVxEgZx+lk1kd
         lwET+IBL2s03uf6sd2SfnxrKzZb4CXqSdc1WbPv+avpn9B71UdgQWPj/H54mtvLYEG6Z
         JJ3XJnWB0tzUBzeDL8GQeHS9p41Cbj35DezlYjqnj7YOlwaWN2UWl9DaKF+UBJdoB7Fj
         5dt4ld8ybLR5uf24QmvsNg6Mc09j8nEXIXRLLpwafGGa8YZQNCRIAuAkv2z10f6FEtCP
         y+gzaR92fDbsFtfDo/ADjPbj5BxxFdGHuNWxgzAs/kilw6bAP3f4nqfj8y0cej+bA4CL
         05/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769538798; x=1770143598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yHX7748gxORjaCJqCbdbPxtHhuUnXJdKJ2s3V+FA30o=;
        b=wm2/yji10S3v4MzrIsto6K9kUTYxpuc2Fvz1p9zNN9iZGgzkAsUka38XVa98WH4QKc
         o6KZIGvkrywHHiebi2Tpp4dqzpZpyJhOltWyHr4W+RQdLTqGAFGY64ZuSzsicaRU5N10
         bJBD6Ae3S6k63ZRhV+xrJz58izKF0QP79/K79KvayR84j9j4RYoens6xqlNdKof0ZSJU
         mqllzR/PGUHQHl2MmJlcLBwqG8RRuQ7CApLl8JRQK3yST8nUCZ+X1XAnCaLrPm88GpFH
         Tl2sEnNrEpQWdPwKlzqrWQh1VfjWnc+vvZMybCFlYW12arwM2h5/wVL0I6eZsRhQ+dmp
         4JrQ==
X-Gm-Message-State: AOJu0YyvPOqQJ9TY+5PuFs3r0HcIGffNf6atns9vC9G3xhxQKBBDVOk/
	3ad6MLBmQ6yvKyx4dOXsQrKEk8/w0d05XZNTdfvRQOfhnyJnV9WHZQYM5qenzMgkJXQY0WraD/9
	eyW2J
X-Gm-Gg: AZuq6aK4s0N89P5PBUPq5jIbBaX9Wa6o/PWgj3Yy7DNOIPg3M0t2Gkiw4jlqBySAYVB
	IIwUZlIP3foancliofE3uXse5UxxZPXcCujWGb99nOnNRB13dTCEcpZD8ltOJtQUjiOX108usPf
	Z0Ce8POuc+XM8fRHvf+d8GOVRDK34zKLxLza+oA+508+71z0VXL2rAG74AECRW9SeglQePlC0Cv
	x335QhrJU6uSO/xDGqWMa+RRiSCV8mlfLe6olT1FJ9ZEK1bzcbxV5BWCXt35er37pZNjoiFHbiT
	2TmM6mUYV3uRKDkA1XiwOOn6OpV7VKgWPc7p3g5XXxWt4FhpzLyKxU6uPrxT7U5LDJNOzsiNk5Y
	w/Hhahbeg7cnTh/Ic2eIo55U0nFiKABPhGkPWYqk2aGMGJGF8jvSM01UAWhrl3/LBPydoXOhWnH
	+MrlpDz2pJUNPMjq4jR0l5ZFhdVEIPguOAD9PqKg+9U6PABTaJk73FO1zajSlKgw==
X-Received: by 2002:a05:7022:4399:b0:119:e56b:989b with SMTP id a92af1059eb24-124a005d351mr1119117c88.2.1769538797713;
        Tue, 27 Jan 2026 10:33:17 -0800 (PST)
Received: from m2max.corp.tfbnw.net ([2620:10d:c090:600::cedf])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-124a7bd05b1sm670139c88.3.2026.01.27.10.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 10:33:16 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	cyphar@cyphar.com,
	jannh@google.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/7] io_uring/net: allow filtering on IORING_OP_SOCKET data
Date: Tue, 27 Jan 2026 11:29:57 -0700
Message-ID: <20260127183311.86505-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127183311.86505-1-axboe@kernel.dk>
References: <20260127183311.86505-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11946-lists,io-uring=lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 64CC999253
X-Rspamd-Action: no action

Example population method for the BPF based opcode filtering. This
exposes the socket family, type, and protocol to a registered BPF
filter. This in turn enables the filter to make decisions based on
what was passed in to the IORING_OP_SOCKET request type.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring/bpf_filter.h |  7 +++++++
 io_uring/bpf_filter.c                    | 11 +++++++++++
 io_uring/net.c                           |  9 +++++++++
 io_uring/net.h                           |  6 ++++++
 4 files changed, 33 insertions(+)

diff --git a/include/uapi/linux/io_uring/bpf_filter.h b/include/uapi/linux/io_uring/bpf_filter.h
index 2d4d0e5743e4..4dbc89bbbf10 100644
--- a/include/uapi/linux/io_uring/bpf_filter.h
+++ b/include/uapi/linux/io_uring/bpf_filter.h
@@ -16,6 +16,13 @@ struct io_uring_bpf_ctx {
 	__u8	sqe_flags;
 	__u8	pdu_size;	/* size of aux data for filter */
 	__u8	pad[5];
+	union {
+		struct {
+			__u32	family;
+			__u32	type;
+			__u32	protocol;
+		} socket;
+	};
 };
 
 enum {
diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
index 5207226d72ea..889fa915fa54 100644
--- a/io_uring/bpf_filter.c
+++ b/io_uring/bpf_filter.c
@@ -30,6 +30,17 @@ static void io_uring_populate_bpf_ctx(struct io_uring_bpf_ctx *bctx,
 	/* clear residual, anything from pdu_size and below */
 	memset((void *) bctx + offsetof(struct io_uring_bpf_ctx, pdu_size), 0,
 		sizeof(*bctx) - offsetof(struct io_uring_bpf_ctx, pdu_size));
+
+	/*
+	 * Opcodes can provide a handler fo populating more data into bctx,
+	 * for filters to use.
+	 */
+	switch (req->opcode) {
+	case IORING_OP_SOCKET:
+		bctx->pdu_size = sizeof(bctx->socket);
+		io_socket_bpf_populate(bctx, req);
+		break;
+	}
 }
 
 /*
diff --git a/io_uring/net.c b/io_uring/net.c
index 519ea055b761..4fcba36bd0bb 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1699,6 +1699,15 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_COMPLETE;
 }
 
+void io_socket_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req)
+{
+	struct io_socket *sock = io_kiocb_to_cmd(req, struct io_socket);
+
+	bctx->socket.family = sock->domain;
+	bctx->socket.type = sock->type;
+	bctx->socket.protocol = sock->protocol;
+}
+
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_socket *sock = io_kiocb_to_cmd(req, struct io_socket);
diff --git a/io_uring/net.h b/io_uring/net.h
index 43e5ce5416b7..a862960a3bb9 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -3,6 +3,7 @@
 #include <linux/net.h>
 #include <linux/uio.h>
 #include <linux/io_uring_types.h>
+#include <uapi/linux/io_uring/bpf_filter.h>
 
 struct io_async_msghdr {
 #if defined(CONFIG_NET)
@@ -44,6 +45,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_socket(struct io_kiocb *req, unsigned int issue_flags);
+void io_socket_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req);
 
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_connect(struct io_kiocb *req, unsigned int issue_flags);
@@ -64,4 +66,8 @@ void io_netmsg_cache_free(const void *entry);
 static inline void io_netmsg_cache_free(const void *entry)
 {
 }
+static inline void io_socket_bpf_populate(struct io_uring_bpf_ctx *bctx,
+					  struct io_kiocb *req)
+{
+}
 #endif
-- 
2.51.0


