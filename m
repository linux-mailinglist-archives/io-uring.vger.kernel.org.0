Return-Path: <io-uring+bounces-7291-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4A6BA752CD
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 00:10:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 891ED16DADA
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 23:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D29991F471D;
	Fri, 28 Mar 2025 23:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hcA0eHde"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A2D1F09BB
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 23:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743203429; cv=none; b=t26rUJ7Jj6SGV9CqUdpARTPPNPEtJHv5fC7B74zIhlFsyoCGDRKgdcb2OgOjIXzVxgmA4DqPOSZvrhlDxpQcOXcvmlLDL5Ioq0H+KQ7c2naQCLinJ2/TtRz/2WKkxDapYeah0xypmaXUQv2EqwgUA0rMwAHZjyXw3aJR+ADRy4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743203429; c=relaxed/simple;
	bh=MRwPtSTtoUKe8z6mtJ6YexyKPQcc9oq2ThB6nlAw6hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKRcgsxRGQs5jJ3GN5LmX0xDXZLZ+QcCMVyojYwXsJhK1kYUCFY5Xs3htGgOIEtDWkj/zKtB90R+ElhrMxSydPA9k1JleS6wspJfID23qxBhsW2kv3fbccrnV1Be1WiV6l9uQgGSy6GY10SNJnlv8W3OSMaVLiIK/Q4QWzQu4SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hcA0eHde; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ac2af2f15d1so351065966b.1
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 16:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743203426; x=1743808226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QpLC+APiMQo6GwLi+pSxmIAR52vwZUqDPZ+ebbatanQ=;
        b=hcA0eHdeA6z5YINto1S5owNAY8SSlGiDUWhpLX7ck/PQEGwSSSecjw/vlw4Xc5rmM5
         kOMO7pOYaIPFC9WvtTxsUWxzo1oUeaCiAUUF2N37DdcEqg3hdG0fUqNdk1WQjdy7DtR2
         ZcWEDWn8QSGJSVK9bIdkQFjjkvosUgONsJEwUJxat2sPNcgh8UXCiFewV9493NCf/BUm
         bUzd7uQD4dN8V96EMj8gq4Rpu8MPru2wCvDoMD6Av8oXd0Hy+ArGqYBIxDCAgwBg2NBK
         VZmff1HSUc+7dfrvhjTOeTZ8R1WtzLKpNOx9Z4IYGB+mEwuLeG9rS25KuMAUDC1haBbn
         T/Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743203426; x=1743808226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QpLC+APiMQo6GwLi+pSxmIAR52vwZUqDPZ+ebbatanQ=;
        b=wOxA+iVvUjkMEIoGdEeOvxhlIPMT4jKFv86HvkL0ZGBns85pzvl09h24H9d14TcDQM
         1oXECfniLuGwh4Gi3aXRGJ09ZfEJe8+fB8zLf+8TiPRhCfM2OgzyANMCWEhdZJb0CG82
         fDhXOSLTFIrfwatz8edf19dbdOMRgDrCL7cPlo+gEBZrvfmfVh7DnQXXGD2wQWmhNCGk
         5bb/qnVMj1boFBphmPaashG6lJnTz9SDh63zUCypBQiODLcHg12E7urpUQgyc5xRfl8r
         87G818lidyIIK+Y009uQFpDjE0p6qEdnGFCGQLYx9ZKcIYI7FXUtuoAHRBOur4LcCh4r
         0wCA==
X-Gm-Message-State: AOJu0YwHJLLoexVtY3t4YZT9qsuMYNfGZsNPeogn75Er3K90VYkBPwlG
	qdwUozkFKMaWG72imZP6R4SLRTVO9Rzo8/lS/JrTS7yl0GeiMHmjYjamOw==
X-Gm-Gg: ASbGnctjS2IOnHb0gCakTPmedqL70qLJLUwkG1Wi2XJ11y+QmbwGVWhSWhVPd8q7ulE
	Aq0ToShXY6FBs+rq5xl/G8OqWUSTqbQpOMcUJf/yI80zrDYOsEMGKel/1rYOGY/ccwtHGAwXD/q
	2IoyzIdb7QGbQHaJXR1QZ1OybVsWTp0T2MfpsE2zph6eDq7gkTjYgvb4kg3mFpn8NOENCYz+Gkc
	QAQKRbesN0uAD+oXggZjMdJvnZNcZHYvyLqM6vWZjkrelPhzDZObw04u44spGhPIlaJvaQC1/i+
	qhBsUqrqx4Jn7HOE5PmTH/sc01UyBk6ecV56QliYXW9VcFUspMt6ZjlZBnU=
X-Google-Smtp-Source: AGHT+IGoglNTmlquoSng+mSKPAfJwhQz4D7rop41nljG8h6cv0GkXzitrPJWRdqol3IN0CXUgX57Yg==
X-Received: by 2002:a17:907:2d87:b0:ac3:cff:80e1 with SMTP id a640c23a62f3a-ac738baeab8mr73516966b.56.1743203425532;
        Fri, 28 Mar 2025 16:10:25 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.232])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71961f04dsm228915966b.91.2025.03.28.16.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 16:10:24 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 4/7] io_uring/net: unify sendmsg setup with zc
Date: Fri, 28 Mar 2025 23:10:57 +0000
Message-ID: <7e5ec40f9dc93355399dc6fa0cbc8b31f0b20ac5.1743202294.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743202294.git.asml.silence@gmail.com>
References: <cover.1743202294.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_sendmsg_zc_setup() duplicates parts of io_sendmsg_setup(), and the
only difference between them is that the former support vectored
registered buffers with nothing zerocopy specific. Merge them together,
we want regular sendmsg to eventually support fixed buffers either way.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index e293f848a686..6514323f4c60 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -377,32 +377,16 @@ static int io_sendmsg_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	/* save msg_control as sys_sendmsg() overwrites it */
 	sr->msg_control = kmsg->msg.msg_control_user;
 
+	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
+		kmsg->msg.msg_iter.nr_segs = msg.msg_iovlen;
+		return io_prep_reg_iovec(req, &kmsg->vec, msg.msg_iov,
+					 msg.msg_iovlen);
+	}
 	if (req->flags & REQ_F_BUFFER_SELECT)
 		return 0;
 	return io_net_import_vec(req, kmsg, msg.msg_iov, msg.msg_iovlen, ITER_SOURCE);
 }
 
-static int io_sendmsg_zc_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *kmsg = req->async_data;
-	struct user_msghdr msg;
-	int ret;
-
-	if (!(sr->flags & IORING_RECVSEND_FIXED_BUF))
-		return io_sendmsg_setup(req, sqe);
-
-	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
-
-	ret = io_msg_copy_hdr(req, kmsg, &msg, ITER_SOURCE, NULL);
-	if (unlikely(ret))
-		return ret;
-	sr->msg_control = kmsg->msg.msg_control_user;
-	kmsg->msg.msg_iter.nr_segs = msg.msg_iovlen;
-
-	return io_prep_reg_iovec(req, &kmsg->vec, msg.msg_iov, msg.msg_iovlen);
-}
-
 #define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_BUNDLE)
 
 int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -1340,7 +1324,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req->flags |= REQ_F_IMPORT_BUFFER;
 		return io_send_setup(req, sqe);
 	}
-	ret = io_sendmsg_zc_setup(req, sqe);
+	ret = io_sendmsg_setup(req, sqe);
 	if (unlikely(ret))
 		return ret;
 
-- 
2.48.1


