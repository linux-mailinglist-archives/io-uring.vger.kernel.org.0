Return-Path: <io-uring+bounces-6703-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65518A42CED
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 20:45:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 785C83B6E0C
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 19:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68B362045B5;
	Mon, 24 Feb 2025 19:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U5CugzmN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACAA200138
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 19:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740426268; cv=none; b=qxDOGiWdfhriOnbsv9j0zYvm3opqdjkcf0ArWfFotLriirAO4S4LyMHqEIOsFD9bgFrqEs8vvAy3cDUPoYVkkzBUPJPswa5Uz+AFA4033Oyaq6yDX6c1zLxJGWmWLIuTZD5QVP6iuj8xxpuMXBIu8w+GrpjteKLum2Ad/kfG5BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740426268; c=relaxed/simple;
	bh=c2dr56Otg6QzVB7KxPlpb7otqsKJtZ8w8OfoNqMegvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xf//I40eZJYkle7BjvlpbzEbDeA6Hm7mPsT6mvT36CYseyXY8Q/6ujCRfIiwjIZU6M1Y/x2SAECZ0lCLi2qLen5i6Bmtc5+aRR99dzC8FaY8ioGOGdR3czkkW3jwzVwf1YlZ+xkI+cg1p3DXfJB8rCsJDHoPZonknGaxDxEXqNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U5CugzmN; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-38f286b5281so2381017f8f.1
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 11:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740426264; x=1741031064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pry5JnUH8YKwWMbGiu+3GyU5H3hss/Z+v4KLGyqRHE8=;
        b=U5CugzmNgvk8R+6/uyLgWdjfFCXnzBh/NvreyfDRHdplKagy03vdv42Ax86LdYZ7/8
         x5ZLTNQpJGGdcq9RRANeiQsmsEjvMq3hZjKTxAvXR+1q7dAhxHTTJaPmy5WMs6x0s2TC
         NgaL+kP0AnBau4vWxc6FU4wjlTa/RFNaQUJ9rZmenXdHcbtreWFO1B8CN2jRsiOvrP3Y
         JOHJfKOpjsNlaRhA3r0FB3UscFSIpeJGzKGVbLcsSule8zhax79si1m+5A45jsGstS97
         IvhB/mHpAGAl7umWs1cd2dlxgwaU1ezg3BkwBGF8H6tBcUfWS6eD3k8yITVEFITCaZ1d
         zIFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740426264; x=1741031064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pry5JnUH8YKwWMbGiu+3GyU5H3hss/Z+v4KLGyqRHE8=;
        b=g3whiRT+RxwYTbovRLflihiR5YiT8spmGfqxk9xhf3nLEZTP+Ui2Elf3JLQ2AYfQ1D
         GEeeQMCWncvbMkj/Qfi6KTXPw2BMGJRiwzilYZDJicYl+1qVyKliBukORWpRpYoOCnId
         s9CPnFQ45vxeFNiVAcXIAGqVPGiTxI8nJhUb+2qcpoheGn353tEF/GDdX6gcb23i+jew
         V0ZomelMCOcMJJMBpigNwNAXb8RQE8DvTGfZ9kvJbr5+J7jEOEf0h04+5mwtSd83CoTl
         3wOvvn1lYnBDqvQDD2Wpeww7gEkHXf1JDDXPzcfTZ/Gir2RZhmgFMmJm9KeHdw7NTyPf
         9t3w==
X-Gm-Message-State: AOJu0YxsvmnGt7MbGs9iTnOUAa4QUvEC1R3/gTwWHm7bHz/YpdNilXxr
	52xqoqrY866j+tbsiAN7QB2452YMApJghzqX/XcUTKi/fsXB+iWj5VlXWQ==
X-Gm-Gg: ASbGncun1S9hH/E8WekLlh/C3/tHBeHe0zHTadVAKMiVSQ8OkPsmzXA3vtZIayQ72b2
	wj82YQSdoiL0kNHA9CYtRCwvtYRVJ0/ZbgRXJEiED/rJq/4F39+phtQZAiRB/xJOba9DT86ZdJj
	wAnTL4FGJrc5gSGz8S8TBpDA57erIVGP1G9ASwCb/MUBVYpdtHrrlPMvkHryYeB4gBJV/snDLuQ
	RntJ7Ew2BDEKRJgH3PeFuwjn5GRntWW2VUipjh3Efm9A4f73MQEWWxE0UfuAWKUtk1ZVHPTB+zl
	shsoQSMVKqUDXEjJ14dfPSVhVZaXnSIrFyZ+soE=
X-Google-Smtp-Source: AGHT+IEa2V7jE1QCv+WkeJPq4WeMpoUkXRVW5Em9Ao9ZoVuhrsxz08eD43yRaxsIHksW3Rz6ozq1bQ==
X-Received: by 2002:a5d:584b:0:b0:38d:b28f:564a with SMTP id ffacd0b85a97d-38f7078bf21mr12447784f8f.21.1740426264198;
        Mon, 24 Feb 2025 11:44:24 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ab14caa5esm1548305e9.0.2025.02.24.11.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 11:44:22 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v2 3/4] io_uring/rw: extract helper for iovec import
Date: Mon, 24 Feb 2025 19:45:05 +0000
Message-ID: <075470cfb24be38709d946815f35ec846d966f41.1740425922.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740425922.git.asml.silence@gmail.com>
References: <cover.1740425922.git.asml.silence@gmail.com>
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
index e636be4850a7..4f7fa2520820 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -76,41 +76,24 @@ static int io_iov_buffer_select_prep(struct io_kiocb *req)
 	return 0;
 }
 
-static int __io_import_rw_buffer(int ddir, struct io_kiocb *req,
-			     struct io_async_rw *io,
-			     unsigned int issue_flags)
+static int io_import_vec(int ddir, struct io_kiocb *req,
+			 struct io_async_rw *io,
+			 const struct iovec __user *uvec,
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
@@ -122,6 +105,28 @@ static int __io_import_rw_buffer(int ddir, struct io_kiocb *req,
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
+	if (def->vectored && !(req->flags & REQ_F_BUFFER_SELECT))
+		return io_import_vec(ddir, req, io, buf, sqe_len);
+
+	if (io_do_buffer_select(req)) {
+		buf = io_buffer_select(req, &sqe_len, issue_flags);
+		if (!buf)
+			return -ENOBUFS;
+		rw->addr = (unsigned long) buf;
+		rw->len = sqe_len;
+	}
+	return import_ubuf(ddir, buf, sqe_len, &io->iter);
+}
+
 static inline int io_import_rw_buffer(int rw, struct io_kiocb *req,
 				      struct io_async_rw *io,
 				      unsigned int issue_flags)
-- 
2.48.1


