Return-Path: <io-uring+bounces-13578-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WJBIEDJfHWo/ZwkAu9opvQ
	(envelope-from <io-uring+bounces-13578-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 12:30:10 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AC9C61D6AD
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 12:30:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 88CA830CEFAF
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2026 10:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2C6C3A2544;
	Mon,  1 Jun 2026 09:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iazXf01H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65023A1695
	for <io-uring@vger.kernel.org>; Mon,  1 Jun 2026 09:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780307960; cv=none; b=gCJXd82dlFstgm5HlupnVSax1470AreECwXvyZw/E5hTe6qU84fMFdnjQ4w1LVd+3XXqt3C6ROmqErF+eMkd/Cq2hjX2yOv1qrtk1s3/IjaID5mMQH2MHKrNOUqT0UjSNI9qdCD3cavDuFOSFDI9MN0V+5HaxFhphRO4ZW3gkZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780307960; c=relaxed/simple;
	bh=oaSu704thTEIsKTMx9jabMGY1yuSA9u2OcQKbMBc+5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNe6dzWCHZyvd0MOtY7COiWD3snPjf50p21uYRdigTNDKed65xVELO8uR/iqApkmD1/c09uvbXZ+PQDuyqDmP62Yf/WZ28eGamda6eHynC6Bb/OH9XLxCmTfdvHLiYaCW1gsNLN26IdsMee2AXwS+W1NcCwFaE/dDw08yuZ6S28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iazXf01H; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-91550eced6bso146489485a.1
        for <io-uring@vger.kernel.org>; Mon, 01 Jun 2026 02:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780307948; x=1780912748; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EBUfAGlitSUKReOFJpXDHcRybWcP3L9jhfdBKg1UgCU=;
        b=iazXf01HWIam54oZLqE/hRnWq008B9cYaPn3dbq+QddSm28TlVkZ2qFRll1l4NQQu/
         h4KMkwICLQgy72xKNGzK3A5rT/RkQ4G2jxmM818LcDeePa3gZEUqCzcjdeCX0piOQ9c1
         ejcaYx/spgRJtyI+obEutsFufc4dfrpqaCLzWh1CndRVRmjmwbePVF3CPhiQgB2jxLlC
         R4+nswSLa4iOKBET8pR9FfO3WxEhIuextuIBrCTZCDAIF+me29RgcrKVZ+mu+cNkBEdS
         U/TrVceNKLNC3twSG0/nwb0CaxOPF1DYxwN5lhZAKKY1gMOCedlLV6E6eDvSbl4JGVfa
         yf6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780307948; x=1780912748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EBUfAGlitSUKReOFJpXDHcRybWcP3L9jhfdBKg1UgCU=;
        b=ZZjleaiXBwgfWy86u9u5IotzOpVNpTax/CkQ4B2PdPVN4KV4FMuHR6VECKF6Tt8Zsp
         8oshE2V48AjrEo5+sIdZ2kkEe9aBoIcbS47RBU+ULF6UxZPsyebMxAQ37Z/2amLUVYNy
         xk72da/1G/Tq2L7zPIhKqna1ueQ3PgtXMoDXSCT19JtDmOaPuNjgCJK1wBKu10sgP1JV
         UHpLqtoW0SJye708+b15VZDscNze0kt9ec1mjPs6bNzHO93fn/BmG2FfPI0+vQMdCrSZ
         a9dC2wlH1DGl3zHfWXExa9i3wanuB8aqK18vgFpPL7Vh0I8feIP/PH0ng1D3Xc32YB5h
         hF8g==
X-Forwarded-Encrypted: i=1; AFNElJ8YhGSqNDkQh28aF6Km7LIGy3ixvEIZDU+GipXH5mnUQA7KWI2K8J1wUhbneRx8FtVGz0Ec/HKYtQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxU9iErUJDdGnmg9cgV9g37Spa/B43MOZX1/86zV4qeHNQ52PGL
	vK+YGIE1r08Btj4LxFa1aXPJucDa3EBkMk4vkLC4lIzz4NtACogiK8pzBPLyv0tA
X-Gm-Gg: Acq92OFGzVKv1t5UpaRSoNdAJwhPddoGr2LRd/HcCOGLtcvIzI95dSv+A83JNN3I2YS
	m1+M8kssWflPNi5n86CSsxb1kc5jZXb6kZNO6NtMYwApn7fnHqEul15zF/3sUtsGjGZzCxgnmZI
	5SRkVTC5zi5F+mReK7JwIYntLpOBkZ1fwb0Ja5BshPAw6XS4A/+JS4vQ8KdfU+WXWaiG4Nv/BF0
	6yeZyrj5oYuQb0Tcol078YXLirzlHoXL7afsQpblD+B5A4f3Ic9huyuzmLjrWOm88cgDSzde4B0
	ToORVHloIkcMXYf4iV8+72olVPwpPjSlGBRl6iOh1fKC4SHmTkoWcTpKJ0lxpH2X6pioxAElsCU
	lrdrB/HAFsDhc1wkXbwT3FpUw9ND2km26ZZ5Qv9qDbD/rTd6DBOiy9K7uVrjmj0AP0dS7B76bQM
	z2uRA9crZgLJmqiSRLV8XSfpZYwl/lHt2MqTQV6NwnxPuvX9iuIlox0dDUte71A7i2pZkeeg6jt
	OxvQiJ94CQvqmjacPwBuFQwQMtvwTJrTaFl+kCPzmxDCrALZMEOgA==
X-Received: by 2002:a05:620a:7005:b0:913:b4b9:5eca with SMTP id af79cd13be357-9153db7f411mr1610159585a.58.1780307948346;
        Mon, 01 Jun 2026 02:59:08 -0700 (PDT)
Received: from fedora.tail348456.ts.net ([172.245.82.59])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915721f7d75sm32658285a.18.2026.06.01.02.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 02:59:07 -0700 (PDT)
From: Ming Lei <tom.leiming@gmail.com>
X-Google-Original-From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 1/2] io_uring/net: support registered buffer for plain send and recv
Date: Mon,  1 Jun 2026 04:58:45 -0500
Message-ID: <20260601095853.3670199-2-ming.lei@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601095853.3670199-1-ming.lei@redhat.com>
References: <20260601095853.3670199-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13578-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tomleiming@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 9AC9C61D6AD
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Ming Lei <tom.leiming@gmail.com>

So far IORING_RECVSEND_FIXED_BUF is only honoured on the SEND_ZC path,
even though the import wiring is already present for plain send and
completely absent for recv. Targets such as ublk's NBD backend want to
push/pull I/O data directly to/from an io_uring registered buffer over a
plain send/recv on a TCP socket, without the SEND_ZC notification
machinery.

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
 io_uring/net.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index f01f1d25e930..9c42c3dbccd7 100644
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
@@ -431,6 +432,14 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~SENDMSG_FLAGS)
 		return -EINVAL;
+	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
+		/* registered buffer send only supported for plain IORING_OP_SEND */
+		if (req->opcode != IORING_OP_SEND ||
+		    (sr->flags & IORING_RECVSEND_BUNDLE) ||
+		    (req->flags & REQ_F_BUFFER_SELECT))
+			return -EINVAL;
+		req->buf_index = READ_ONCE(sqe->buf_index);
+	}
 	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
@@ -662,6 +671,15 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -777,6 +795,10 @@ static int io_recvmsg_prep_setup(struct io_kiocb *req)
 
 		if (req->flags & REQ_F_BUFFER_SELECT)
 			return 0;
+		if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
+			req->flags |= REQ_F_IMPORT_BUFFER;
+			return 0;
+		}
 		return import_ubuf(ITER_DEST, sr->buf, sr->len,
 				   &kmsg->msg.msg_iter);
 	}
@@ -785,7 +807,7 @@ static int io_recvmsg_prep_setup(struct io_kiocb *req)
 }
 
 #define RECVMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECV_MULTISHOT | \
-			IORING_RECVSEND_BUNDLE)
+			IORING_RECVSEND_BUNDLE | IORING_RECVSEND_FIXED_BUF)
 
 int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
@@ -803,6 +825,14 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
@@ -1199,6 +1229,18 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
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


