Return-Path: <io-uring+bounces-12544-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OH+DAfnWpmnHWgAAu9opvQ
	(envelope-from <io-uring+bounces-12544-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Mar 2026 13:41:29 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 886C51EF9D1
	for <lists+io-uring@lfdr.de>; Tue, 03 Mar 2026 13:41:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BDADC30470DE
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2026 12:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0730F31F999;
	Tue,  3 Mar 2026 12:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dFhi6GGN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F3332FA29
	for <io-uring@vger.kernel.org>; Tue,  3 Mar 2026 12:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772541147; cv=none; b=utE4ausptBzvLrU2HPxkY5VYG5TnRNWULFBpQnv1JMPJhL8deppRPub/8yojK5Lz4l+lfhU+Z7P1wLrUwJuRapkD4t5hCCvtzBk66KeXoKkPcfWJSRSv0VTxj0Ut07WpM5U3JrlYt2+GbXTfE413orSXqEw6jId74OfCMvOXLKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772541147; c=relaxed/simple;
	bh=jYx3QAd+51lSALhpqnMENhkD36+m+K3ERaraIU7f21s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hs308IHRA0I7ov2Y0cW1t/quCnXcHdMuuGx4LC2OHm7RqB6fsgUUjU9L5qeZxbjV74yACcEaNZG2Hujuk6uGNi3/w0/t/1+6evTvhIZL+cH+WbZTNdtiKpQGHZR/IC4a7vSCMt6dvfZbt4HKP6kBJRP8RwyAqcLyLXy1zDgKlwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dFhi6GGN; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48371119eacso69438215e9.2
        for <io-uring@vger.kernel.org>; Tue, 03 Mar 2026 04:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772541145; x=1773145945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=69v1zzXRdVhWn/a60Ya5fAkzLXMfJlxuVkxsve457k4=;
        b=dFhi6GGNJ5h0ZGmyaDCddwH7X7KQF52ovnBJVTW5kewTqda7XHzWVWVgruVidxvw4m
         e8j0WK4iI6op7Po9ACxxL8ju7tokiYYR1JGLbzdqhKOFTtjNZBozZgSt1CiFS67RLVfg
         vHo7ilidTKUZwZxQBI4BRn++8y0HHhcMgaBxwV86bFmymJTAMuHLF5l96vI2mK45v5Ul
         ns8nvYCmx4LO6JgtDbJZgUNn1WMT8ngaxlPX/d0QYKXOx3eIN/YRYinQ16jgdvlqoT/o
         MmY6DDPg8f6zVpvluxae+xJBrcHQzEZyQ2OSTLksm31hGvWx89A7egDJo0dLY5Zyu54f
         yFQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772541145; x=1773145945;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=69v1zzXRdVhWn/a60Ya5fAkzLXMfJlxuVkxsve457k4=;
        b=Aa0eUlK2Wr0a6ydRkH5BxjQM3VBaHgH7Hoh5zpkQhoUj+H2KNPANj2g+yazyIEQSrJ
         k/vS+9MQvXq6VtylZC5LtycWOQPy7CXoE8MjsnXPxJZSY0puVaMSWHSXcR5r7esRlXji
         kBbCHEcLEAZTrlgFUSksBFO7x1DimnFtMQnrM9gGHrDuU6rnh6+gD2JPxXCHJCZ4a+kw
         NKPlxN0th6gC7s3lZaAMSCWk5WJk+p+a0uTYmg0mOj2tVjSE/8TFDRnV54qpRmzT8TzB
         ZpKEixgyEBzJucE1LlisijGnpfG9ELEdDhZ1GAysuTvp8Xv6mqMsHNxFcl378fQghRkj
         Z6mA==
X-Gm-Message-State: AOJu0Ywf+nI2xH4D6udfP5QhJokAPgmyJvqTk6abrBydSnHShhI6FKm8
	thPiRRBzzT74LxctUp8xWgZci6dr32Q6rga67/NuC0MTGGy2pUmGq4pl8yIUlg==
X-Gm-Gg: ATEYQzzNP0+RYWDPOAISmd7mVlfg5/tIQ1e9GTFvn4QVbnFbFXo4gJqNYeR6TZRVRDV
	dLPnft3qtenwPjkQF3r44SscHYJNGvpegrWV6jNJUfIGt7C0KJ94/ptuLs2zcQpdSzKSreOWWbR
	XGEK0mEcq9WBVas8QK0Y0aiWqvuK0K1spuunBxdV1haMWLb/2+/BtkPxuocSK1tBVDJefvlUfMl
	up/OVjG+qsI4gJZXzi09RuFWTQngZjB7358BFqS3bL01WujKbDJhGmVtHqTWCHm7c59sS1HNqUZ
	eiudkJAZl71pV2DXskaTcZtkh80I5vI2fV6DOHMWxRFvbysDLhmopt4tOHiZzoTHjh+r+gqtQTm
	XOPvg9K9BgBm2usineLNOZ7YVD5sa1NORGiQpAmwK3OsZ8PnL6zT+glVMr8Zlq48YQpmw0rQ+dH
	cJ9iRCmza6RTN15AOjcPTfvFsiarzNJgPuxwMLx42mHiU2ydXOF1O4xZfH/rm7ELWA6MYQWkSiI
	e80wG9toKSMD8fxdtPJg8FIMvpJ2Q==
X-Received: by 2002:a05:600c:a16:b0:483:c35d:3662 with SMTP id 5b1f17b1804b1-483c9c0b96fmr269112815e9.18.1772541144038;
        Tue, 03 Mar 2026 04:32:24 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485135d0676sm18922765e9.29.2026.03.03.04.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 04:32:23 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH 1/1] io_uring/net: allow vectorised regbuf send zc
Date: Tue,  3 Mar 2026 12:32:19 +0000
Message-ID: <c151f006cbac6eb51863881d338b101186740cc1.1772493339.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 886C51EF9D1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12544-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Enable IORING_SEND_VECTORIZED with registered buffers for
IORING_OP_SEND_ZC. Set IORING_SEND_VECTORIZED for all msg send requests
to differentiate if the vectorised version is expected.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 3e6112beea88..3e68593e8164 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -375,10 +375,13 @@ static int io_send_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		kmsg->msg.msg_namelen = addr_len;
 	}
 	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
-		if (sr->flags & IORING_SEND_VECTORIZED)
-			return -EINVAL;
-		req->flags |= REQ_F_IMPORT_BUFFER;
-		return 0;
+		if (!(sr->flags & IORING_SEND_VECTORIZED)) {
+			req->flags |= REQ_F_IMPORT_BUFFER;
+			return 0;
+		}
+
+		kmsg->msg.msg_iter.nr_segs = sr->len;
+		return io_prep_reg_iovec(req, &kmsg->vec, sr->buf, sr->len);
 	}
 	if (req->flags & REQ_F_BUFFER_SELECT)
 		return 0;
@@ -396,6 +399,7 @@ static int io_sendmsg_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	struct user_msghdr msg;
 	int ret;
 
+	sr->flags |= IORING_SEND_VECTORIZED;
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	ret = io_msg_copy_hdr(req, kmsg, &msg, ITER_SOURCE, NULL);
 	if (unlikely(ret))
@@ -1453,7 +1457,7 @@ static int io_send_zc_import(struct io_kiocb *req,
 
 	notif->buf_index = req->buf_index;
 
-	if (req->opcode == IORING_OP_SEND_ZC) {
+	if (!(sr->flags & IORING_SEND_VECTORIZED)) {
 		ret = io_import_reg_buf(notif, &kmsg->msg.msg_iter,
 					(u64)(uintptr_t)sr->buf, sr->len,
 					ITER_SOURCE, issue_flags);
-- 
2.53.0


