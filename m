Return-Path: <io-uring+bounces-13640-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id F+CyBKzTJmrYlAIAu9opvQ
	(envelope-from <io-uring+bounces-13640-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 16:37:32 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F4676574A8
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 16:37:31 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SXpdVVKK;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13640-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13640-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4450F31261B8
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2026 14:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D87B93D3012;
	Mon,  8 Jun 2026 14:25:26 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615293D3D1D
	for <io-uring@vger.kernel.org>; Mon,  8 Jun 2026 14:25:25 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780928726; cv=none; b=AuXuB+1CvA4IXzZyzFIdKPtqSV8l/YOsdDie8Go+yJfKgyYBBwKVDsr1X84lJnOt0qnXK00GGGjF0iMzKG/yZSUdm9UjbMMEDANqYlTWgkyX/Ay+8rId3qs/fuSJ0Aaq9V4IS9pJtXzo3MnDMQPs/4BkgVqshy94DzKxe5EuMG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780928726; c=relaxed/simple;
	bh=9lPwQATNqZ6D4yPGkbuAGF0YzI6rmk8NPcxNmCqUi9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGDN+LPCPmfJv8M0hlJ0UQ2tqIbXGIVM3IgqrBc/eZBqeO1/4nzLDoOEb4QLbOiYmDpZZnlUFoxIPtS9b1ETX3G2c4OOEMSm3806FgUlEiy7+jfmZ4dxMSmh2AoF2MsFwS/Fpr5qKOmC7Z/U/gw9Smjrv8LcVZOjTqg1lQvbteQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SXpdVVKK; arc=none smtp.client-ip=74.125.224.54
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-6605c3453f2so4349909d50.1
        for <io-uring@vger.kernel.org>; Mon, 08 Jun 2026 07:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780928724; x=1781533524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Is8hfKUQHQVLHZ3Yk0+vkLWxClkHP91zk86rXxghJA=;
        b=SXpdVVKKv+NZmCX8hFEtxJBXOXCIGl9ZWmPB7rMvAIbvQvJiI5e2ePCo8AkNAsqZXA
         MjPGrpwhY0jF94BF8vTCSsCeEzn7f8h9Wpsc2aRUyJSylZGHRNiHrL7HIcWazvQPY92U
         z5pPJ8IycYjtHPTU0voB0iihAKR32PGJJHdEhAg2DZKUPJvDru4MvzJ+1oOlPbVsmsj0
         C/qIZo2JaZh771BfQjOnEj6tLQBOu00L4fSA7bWMfACG+JAEpJQC7bBzpcZtvEpmDyXN
         wqaVA/R3uvVurOR3vyDQhmcndYzAl3M/ThW4hSNUMMB7gzRh1h35baewTmGHrPtFLgNP
         hyIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780928724; x=1781533524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6Is8hfKUQHQVLHZ3Yk0+vkLWxClkHP91zk86rXxghJA=;
        b=spWl0dgfSeAJtoJRWNcqHJXHvVmlaPkPWHB1XZW7y9p7dB0wEkzmwHhsZE8ycl+MJG
         gnCL6d8hFMsBSjR1CavgmeK5ljqYi3v1hPIlQeL3lbQfvD1AScXPa9JDlZfEiNIFkma9
         RC8v5sxlPNsMV5/VH5qmDVhzPYHlKlSpHupwqPHLklrbahf3qw01F5kpZSTaWiwLpRiW
         Ebudn3e5llg6be0Cwq9GCWhPyW3T18bwbmE2EV3CYTU0ltY6AgHu1CUxetYfWLdh1i5d
         +uamY+zto8O0QvikIYRZYZ1vY4Yw3ZsuJ/zr2y+GGHrf6vDCIJU+k6CAUFxImn2TWiZu
         OURQ==
X-Forwarded-Encrypted: i=1; AFNElJ/7GZyET3ROBtIKD93hSPIcULBiRdqKODY862ohDT8dzo9ohds05aFUfrsAXone5n1mPyKjM/jCzQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyO7cxxRWpDbghTlUc80UOybP/2laa+mKtzfauSuMhmG4EYqxO4
	SpsSXFEhfr7K/YKXHQZ0ncZCc+bMJxWN+NfyGABVvWJr3uiYbqYimQMS
X-Gm-Gg: Acq92OFQVDF7cS04Tqu0QrMrS8CX5oywm+mhAGt/yUC7rwq1qaPQUZzsqGCwn7k00qh
	5S/WcgMkEziFo3wrsI7HD0MKmao3b4ykBoLGjl380a83bySSQuhAtqd4zdGNoDBv4z0Iay1litv
	UM/SoVvw7qcVsDaVTOlRP/nDTA1FJ4saMFD89C6LbY1lMJTx0CpxOFVnXkEvL+PHXaj96l8JLG6
	1ifwfxtxybnB2AnByTGgqk2c2KFep0qD+lteXdSiFOa8xVNdmDFf8IXzW/S4ilv7cGt03OOKpin
	88PGYVe0Ti/I+SXtd/Xc+AGYmo/qWWFfIxOM+UghIrSLnGcgUZLNT2aIJsQiGd+3CZHyI5yYaAk
	RZTlLTz8lqDkCX3FVC7lpamBDKSoIDUaxzNIQ1M/paJiSwCvZzPKZ+PjFZ3g81HKxJ75q6HNCQ7
	rHWZlwZrVTJoQRfEe8seDyCN5S6ZFiFU3IfkUXdVaAJ6JZy0vRitbpDyNz/uVSG/VnTj12FiV6i
	/bHceFwdLDQJvCUAyZFj5weiOTjJZYEFcMF2xO94xeZeKdmLnqs5A==
X-Received: by 2002:a05:690e:1206:b0:660:689b:1542 with SMTP id 956f58d0204a3-66106f3b26fmr13697278d50.42.1780928724122;
        Mon, 08 Jun 2026 07:25:24 -0700 (PDT)
Received: from fedora.tail348456.ts.net ([172.245.82.59])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-661473db74asm239368d50.7.2026.06.08.07.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 07:25:23 -0700 (PDT)
From: Ming Lei <tom.leiming@gmail.com>
X-Google-Original-From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v2 1/2] io_uring/net: support registered buffer for plain send and recv
Date: Mon,  8 Jun 2026 09:25:10 -0500
Message-ID: <20260608142511.659240-2-ming.lei@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260608142511.659240-1-ming.lei@redhat.com>
References: <20260608142511.659240-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13640-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[tomleiming@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:tom.leiming@gmail.com,m:tomleiming@gmail.com,s:lists@lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tomleiming@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8F4676574A8

From: Ming Lei <tom.leiming@gmail.com>

So far IORING_RECVSEND_FIXED_BUF is only honoured on the SEND_ZC path,
even though the import wiring is already present for plain send and
completely absent for recv. Targets such as ublk's NBD backend want to
push/pull I/O data directly to/from an io_uring registered buffer over a
plain send/recv on a TCP socket.

Wire IORING_RECVSEND_FIXED_BUF into the plain IORING_OP_SEND and
IORING_OP_RECV paths:

 - Accept the flag in SENDMSG_FLAGS / RECVMSG_FLAGS and, at prep time,
   restrict it to the non-vectorized IORING_OP_SEND / IORING_OP_RECV
   opcodes. It is mutually exclusive with buffer select, bundles and
   (for recv) multishot, and records sqe->buf_index.

 - For recv, set REQ_F_IMPORT_BUFFER in setup so the registered buffer
   is imported lazily at issue time, mirroring the send path.

 - In io_send()/io_recv(), import the registered buffer via
   io_import_reg_buf() (ITER_SOURCE for send, ITER_DEST for recv) and
   clear REQ_F_IMPORT_BUFFER. The resulting bvec iter persists in
   async_data, so MSG_WAITALL partial send/recv retries resume at the
   right offset.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 io_uring/net.c | 47 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 45 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index f01f1d25e930..c2bbf9dd2790 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -418,7 +418,8 @@ static int io_sendmsg_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	return io_net_import_vec(req, kmsg, msg.msg_iov, msg.msg_iovlen, ITER_SOURCE);
 }
 
-#define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_BUNDLE | IORING_SEND_VECTORIZED)
+#define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_BUNDLE | \
+			IORING_SEND_VECTORIZED | IORING_RECVSEND_FIXED_BUF)
 
 int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
@@ -431,6 +432,15 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~SENDMSG_FLAGS)
 		return -EINVAL;
+	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
+		/* registered buffer send only supported for plain IORING_OP_SEND */
+		if (req->opcode != IORING_OP_SEND ||
+		    (sr->flags & IORING_RECVSEND_BUNDLE) ||
+		    (sr->flags & IORING_SEND_VECTORIZED) ||
+		    (req->flags & REQ_F_BUFFER_SELECT))
+			return -EINVAL;
+		req->buf_index = READ_ONCE(sqe->buf_index);
+	}
 	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
@@ -662,6 +672,15 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return -EAGAIN;
 
+	if (req->flags & REQ_F_IMPORT_BUFFER) {
+		ret = io_import_reg_buf(req, &kmsg->msg.msg_iter,
+					(u64)(uintptr_t)sr->buf, sr->len,
+					ITER_SOURCE, issue_flags);
+		if (unlikely(ret))
+			return ret;
+		req->flags &= ~REQ_F_IMPORT_BUFFER;
+	}
+
 	flags = sr->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
@@ -777,6 +796,10 @@ static int io_recvmsg_prep_setup(struct io_kiocb *req)
 
 		if (req->flags & REQ_F_BUFFER_SELECT)
 			return 0;
+		if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
+			req->flags |= REQ_F_IMPORT_BUFFER;
+			return 0;
+		}
 		return import_ubuf(ITER_DEST, sr->buf, sr->len,
 				   &kmsg->msg.msg_iter);
 	}
@@ -785,7 +808,7 @@ static int io_recvmsg_prep_setup(struct io_kiocb *req)
 }
 
 #define RECVMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECV_MULTISHOT | \
-			IORING_RECVSEND_BUNDLE)
+			IORING_RECVSEND_BUNDLE | IORING_RECVSEND_FIXED_BUF)
 
 int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
@@ -803,6 +826,14 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~RECVMSG_FLAGS)
 		return -EINVAL;
+	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
+		/* registered buffer recv only for plain IORING_OP_RECV */
+		if (req->opcode != IORING_OP_RECV ||
+		    (sr->flags & (IORING_RECV_MULTISHOT | IORING_RECVSEND_BUNDLE)) ||
+		    (req->flags & REQ_F_BUFFER_SELECT))
+			return -EINVAL;
+		req->buf_index = READ_ONCE(sqe->buf_index);
+	}
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
@@ -1199,6 +1230,18 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 
+	if (req->flags & REQ_F_IMPORT_BUFFER) {
+		ret = io_import_reg_buf(req, &kmsg->msg.msg_iter,
+					(u64)(uintptr_t)sr->buf, sr->len,
+					ITER_DEST, issue_flags);
+		if (unlikely(ret)) {
+			kmsg->msg.msg_inq = -1;
+			sel.buf_list = NULL;
+			goto out_free;
+		}
+		req->flags &= ~REQ_F_IMPORT_BUFFER;
+	}
+
 retry_multishot:
 	sel.buf_list = NULL;
 	if (io_do_buffer_select(req)) {
-- 
2.54.0


