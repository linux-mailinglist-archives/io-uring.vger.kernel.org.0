Return-Path: <io-uring+bounces-6684-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55B81A42786
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 17:12:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E56423B478A
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 16:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13778261580;
	Mon, 24 Feb 2025 16:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QLz9su/U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311A826158D
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 16:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740413202; cv=none; b=H/n4UPU2l1s+N8HD6csmAcaMWJS2urqp/sMrG/p9OIji7UxcOfWMO5qg+E4kLjl4Tw2DtEgTdCtdp2LZme14M0KVwEMPObuCj71js6cF1idhfCOAQqJ/uH5/vAChArBFKV5o/TLIisHt14DnQaR/sJqfPFGUQLzmtuXNvOBSaaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740413202; c=relaxed/simple;
	bh=PvuHJY1tomndor+upuIhjvvcJnPklhdETpzFR/6V5qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBlsRxp6NAfj40UimKv72KbIRQ5BKxSldVrt6Ov7vElDgUKspml+W/g/U34wSELq8s25Yi41t3B2AU0fV4A5lres06A86Yf1I6fA3l6A+6aCQeIoIYSVqzBbwP3eKx1sitsHAmRXG0X7lJGOUGUNKERygWCYg2YZXsSH3Vwm6UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QLz9su/U; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aaee2c5ee6eso669807266b.1
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 08:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740413198; x=1741017998; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YrxwZjz3oqJZKxsLAKf5JWC6HBJTle6L1MVSIMNCL3M=;
        b=QLz9su/UN2/mRUJiJh4Q78abQi8F1FmW+1uW+PcXTDWe5G5GiCZx9jCX+AWutVI80w
         Uk28Acp7cvLpS9vlMz0Alg++e3snZMg6uuepab5h7SsFQmI2XzMuPEq18J4yQnMRJ5Pz
         pjyCF4HJKNWDJme9F4BESEnJ+BCM2R9h2B/YAVP1WsiraQw3dBeg+BLsnIoHARP10UvY
         Cc1yI9mfB75jw7n00fT7UZHM20cvOlzNNDgOws1yDAIVTqJIxTOMyUKarLeDuRGrqvIG
         relVywWOZFFfkszfS38MEsOPYxIjfA7ZzJVj0Ci9E4D6jJUqC8sb8tddBG31ywsHmIUF
         UkVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740413198; x=1741017998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YrxwZjz3oqJZKxsLAKf5JWC6HBJTle6L1MVSIMNCL3M=;
        b=gNTV5wAAkEK90Cf4I/jr3n6n+F/jjMJD1YC4UwpAAuAoZ5iqdt8WKRIdQUmFvLsZ66
         2z7JIcTfxtkYaEUPw8xdCz65zR+KSMXcyi8AottR3H4UD/Ymms4oJaPPGrPGAnj0B+Bz
         6pew9+PuAwm8BYL4oG1hrIkB5Y+OmnataQVEdq/IbckCOXP8BRw/Gr/3j9H/uC6sWDpZ
         gjoPf2kDdilmi/sifrphv/3g/yiwPHLfWq+XUODih9Qw4Bm8MLU7/eQIyJWZbzGYDK0P
         9JkRwRVd3C9cBvYxtN+U73g65GCM0yEHTXzvXajTkNsSLTTqvtU3AQmDXGwnH6Y/iyXh
         j30g==
X-Gm-Message-State: AOJu0Yx79/5trt5gVvGO04LA1+xi+UD2AchxO7nzvbUI4B6VE7+9Ho/F
	5TIa4Ht8yiWiBUx9KMbJCeYgHzxT3FHjIu2niczooHkR8pNWi1SBKgcpvw==
X-Gm-Gg: ASbGncu1AERppHQsQMrRqdl8mQ4fA9NMi50okeTt1e2ahtjzeFPy6bvKKQX93t9YwCi
	VcmdfNt8lBXgq8Oj7HSNV+6B0oMOsdXx/1OqTx0JhloORDT025wF8WeaAcK3vb24vNPoBLFuirO
	Jox5/qcpN/VfzuOC3uPBsEQaWe5vYA8tGE6RgDcPeYfGkYA0GZeMDt/V7cXSvoKXXY9O12SN4ss
	A0jsGDAWeOXNnRS9CjeIe4jnKeC/ynSj9HdYjFZMRQ1fhLNFBpOawtp6D2jYdWgxiU1+Mq/Yq4G
	1eb7Tn9llQ==
X-Google-Smtp-Source: AGHT+IGYu44Iaa9x7wRVHyam1a72n7LbdGx1oKbelMKLDPqHKgK0eADpPip4J+WydVYRKwlQyM/C2g==
X-Received: by 2002:a17:907:948c:b0:ab7:e3cb:ca81 with SMTP id a640c23a62f3a-abc09aac8cbmr1399448766b.30.1740413197750;
        Mon, 24 Feb 2025 08:06:37 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:bd30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abb95cc7451sm1664684566b.92.2025.02.24.08.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 08:06:37 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/4] io_uring/rw: extract helper for iovec import
Date: Mon, 24 Feb 2025 16:07:24 +0000
Message-ID: <5cf589c0efb611bfe32fc3b69b47d2b067fc8a65.1740412523.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740412523.git.asml.silence@gmail.com>
References: <cover.1740412523.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Split out a helper out of __io_import_rw_buffer() that handles vectored
buffers. I'll need it for registered vectored buffers, but it also looks
cleaner, especially with parameters being properly named.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 57 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 26 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index e636be4850a7..0e0d2a19f21d 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -76,41 +76,23 @@ static int io_iov_buffer_select_prep(struct io_kiocb *req)
 	return 0;
 }
 
-static int __io_import_rw_buffer(int ddir, struct io_kiocb *req,
-			     struct io_async_rw *io,
-			     unsigned int issue_flags)
+static int io_import_vec(int ddir, struct io_kiocb *req,
+			 struct io_async_rw *io, void __user *uvec,
+			 size_t uvec_segs)
 {
-	const struct io_issue_def *def = &io_issue_defs[req->opcode];
-	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	int ret, nr_segs;
 	struct iovec *iov;
-	void __user *buf;
-	int nr_segs, ret;
-	size_t sqe_len;
-
-	buf = u64_to_user_ptr(rw->addr);
-	sqe_len = rw->len;
-
-	if (!def->vectored || req->flags & REQ_F_BUFFER_SELECT) {
-		if (io_do_buffer_select(req)) {
-			buf = io_buffer_select(req, &sqe_len, issue_flags);
-			if (!buf)
-				return -ENOBUFS;
-			rw->addr = (unsigned long) buf;
-			rw->len = sqe_len;
-		}
-
-		return import_ubuf(ddir, buf, sqe_len, &io->iter);
-	}
 
 	if (io->free_iovec) {
 		nr_segs = io->free_iov_nr;
 		iov = io->free_iovec;
 	} else {
-		iov = &io->fast_iov;
 		nr_segs = 1;
+		iov = &io->fast_iov;
 	}
-	ret = __import_iovec(ddir, buf, sqe_len, nr_segs, &iov, &io->iter,
-				io_is_compat(req->ctx));
+
+	ret = __import_iovec(ddir, uvec, uvec_segs, nr_segs, &iov, &io->iter,
+			     io_is_compat(req->ctx));
 	if (unlikely(ret < 0))
 		return ret;
 	if (iov) {
@@ -122,6 +104,29 @@ static int __io_import_rw_buffer(int ddir, struct io_kiocb *req,
 	return 0;
 }
 
+static int __io_import_rw_buffer(int ddir, struct io_kiocb *req,
+			     struct io_async_rw *io,
+			     unsigned int issue_flags)
+{
+	const struct io_issue_def *def = &io_issue_defs[req->opcode];
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	void __user *buf = u64_to_user_ptr(rw->addr);
+	size_t sqe_len = rw->len;
+
+	if (!def->vectored || req->flags & REQ_F_BUFFER_SELECT) {
+		if (io_do_buffer_select(req)) {
+			buf = io_buffer_select(req, &sqe_len, issue_flags);
+			if (!buf)
+				return -ENOBUFS;
+			rw->addr = (unsigned long) buf;
+			rw->len = sqe_len;
+		}
+		return import_ubuf(ddir, buf, sqe_len, &io->iter);
+	}
+
+	return io_import_vec(ddir, req, io, buf, sqe_len);
+}
+
 static inline int io_import_rw_buffer(int rw, struct io_kiocb *req,
 				      struct io_async_rw *io,
 				      unsigned int issue_flags)
-- 
2.48.1


