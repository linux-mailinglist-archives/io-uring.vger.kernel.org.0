Return-Path: <io-uring+bounces-6167-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF1D1A21352
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 21:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6D283A7744
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 20:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98DBB1DFDA2;
	Tue, 28 Jan 2025 20:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jwDcvyQH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06641DE8A5
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 20:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738097769; cv=none; b=VZs4KHCILSLc4K/1fJfcLlb9lwKvcrS+jPUStjAAN+QG8T0rf+uPHhaKy7WCBv3yYXB2xScU6S6xvj1whpQ4HapGUW1wZ7IgBTW00h2ScBlgZTL0UcYKhz/vWulX/Wu93FNf0VIEZqbEEaz11j6q2WlabcoacPczto+dOhOAtB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738097769; c=relaxed/simple;
	bh=O0dnlT1QGcTU/CfLmAbFNQEFSpdY/ex5go7HT3c4cjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxaD2fIzFwxUMSBhsntjU846kZaOOVdj+zu+npL/kCot1baXsi4/sjoTcG3RvPXH34B+xWsHH+LPincFi3octBprXaWvsJZ6UHD+eojGXnghL2ZtFM+HUUNMY4NfziS7M87Q7KPjkQ+wdqyLwxPOus7H687ybLn6FRxTZ9qxPqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jwDcvyQH; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5d4e2aa7ea9so11964196a12.2
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 12:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738097765; x=1738702565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I3ttnJoPVlJrcZwExbZmxI1HDuVRLvx04RN+P1Nl5Mg=;
        b=jwDcvyQHXmjKpC+oUZ5ybHupnhYtm889UXwdj51tCcz5fxF0sphj0KjSm6YR1C5KsU
         VwNHQ1/iOI5unSUNPChC1urVohVN6+UPP6cD66CthQAPmVQn+egwus2mTtQ3YIO0TLuM
         8504/H7MAIBfObbqXvEYg8Ry1vysSzTGlRzgSv6ZPqbaR6GlXoC45eWX5lMHA7cqjGKw
         zThDwh4G9akgx4KMO3H5RF4F+JMb9XEPTXXHslDrXVMcZD7eL+fuLp+4n19Yrk/SMe9C
         H2mSuliwP/4asKDmCl3cZCWTSFI+4fCYVPrv8X3mNchcwatTy5qPJNbnXHLnc/EoclW0
         o23A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738097765; x=1738702565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I3ttnJoPVlJrcZwExbZmxI1HDuVRLvx04RN+P1Nl5Mg=;
        b=OumQZVurMuOeBK9AWVsRENzJJZweIpvnAQ4Oz1IirjWvI5fgB6eX+EM5v0uldHjE/x
         WFCI+sMfpVnd3RQYh7UadYwg5X/pD99AE4xOvXz3QOYexTRzr4pl0W8klUVnXhjYJ4W8
         X8eTxvuXbi76TLo73zd3IhV2/Ayhsrx0VNTxKU+KvtyluYHgxVwkaBDXdzTi6HnXh2Ew
         trNpnYzlXBc2dkidUfFqrGxn2uyhP1IRPxH+W0Bv2r2uRPUFEdPiwMpZ5QK974IbusED
         dtbb1SFgnrDbpNJPOOmhUJ9sg/Cw1hx1H0M5zQvEOebAK14oUYRcKzFgHagRLRAXIzzF
         U6VA==
X-Gm-Message-State: AOJu0YzxLJbFVjvYNX58rfGb6kB5fIMH3Vqh2GxINPU8Bz1ZvCHmG9AB
	0D7ZtVO6ZMA8AM/FoBwP+hQnBJjGEbCKoRBY536cvpLfAoFm4M/xJOL6ig==
X-Gm-Gg: ASbGnctwkPrbolAzB1YNwWWPfX80R9vTgADyh326pCYy3Z/2ZEgXpbaJw1VfbhmBfVB
	3bnIuLj3Nncdyy87J9Cel7kOrH1FWsIc3PewUP824rGK9xD9m3K29/GA7rZSjt9TSyatXzvPfEc
	R8aWu9kvNrBaW0JWccLjPFf4UFzzmYxLaWoM4tWDDYgI8jq0avSa8JVnz8HdLO+Od0Bt4xxXuua
	DxNEYrTJpauoy9b0PyAqKmbIuXp1ZH5mJ21tIwchzFI3KivYLSW42m39c/AgyFDPcwq3g2gJ0Yt
	JcR8SciIpzZuvviEnraU+g8o8awX
X-Google-Smtp-Source: AGHT+IFs1zzJGOeJoSxouHEhzYPG8ZZlWByucFLgg/TwXToV5IjFPkEcjYgnAJ7VF5wgNxorriyJTg==
X-Received: by 2002:a05:6402:50d3:b0:5dc:1239:1e40 with SMTP id 4fb4d7f45d1cf-5dc5f00851bmr317029a12.31.1738097765231;
        Tue, 28 Jan 2025 12:56:05 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.145.92])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc18619351sm7736949a12.5.2025.01.28.12.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 12:56:04 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 6/8] io_uring/net: extract io_send_select_buffer()
Date: Tue, 28 Jan 2025 20:56:14 +0000
Message-ID: <26a769cdabd61af7f40c5d88a22469c5ad071796.1738087204.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1738087204.git.asml.silence@gmail.com>
References: <cover.1738087204.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extract a helper out of io_send() for provided buffer selection to
improve readability as it has grown to take too many lines.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 87 +++++++++++++++++++++++++++++---------------------
 1 file changed, 50 insertions(+), 37 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index dedf274fc049a..4d21f7bd2149e 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -566,6 +566,54 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+static int io_send_select_buffer(struct io_kiocb *req, unsigned int issue_flags,
+				 struct io_async_msghdr *kmsg)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+
+	int ret;
+	struct buf_sel_arg arg = {
+		.iovs = &kmsg->fast_iov,
+		.max_len = min_not_zero(sr->len, INT_MAX),
+		.nr_iovs = 1,
+	};
+
+	if (kmsg->free_iov) {
+		arg.nr_iovs = kmsg->free_iov_nr;
+		arg.iovs = kmsg->free_iov;
+		arg.mode = KBUF_MODE_FREE;
+	}
+
+	if (!(sr->flags & IORING_RECVSEND_BUNDLE))
+		arg.nr_iovs = 1;
+	else
+		arg.mode |= KBUF_MODE_EXPAND;
+
+	ret = io_buffers_select(req, &arg, issue_flags);
+	if (unlikely(ret < 0))
+		return ret;
+
+	if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_iov) {
+		kmsg->free_iov_nr = ret;
+		kmsg->free_iov = arg.iovs;
+		req->flags |= REQ_F_NEED_CLEANUP;
+	}
+	sr->len = arg.out_len;
+
+	if (ret == 1) {
+		sr->buf = arg.iovs[0].iov_base;
+		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
+					&kmsg->msg.msg_iter);
+		if (unlikely(ret))
+			return ret;
+	} else {
+		iov_iter_init(&kmsg->msg.msg_iter, ITER_SOURCE,
+				arg.iovs, ret, arg.out_len);
+	}
+
+	return 0;
+}
+
 int io_send(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
@@ -589,44 +637,9 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 
 retry_bundle:
 	if (io_do_buffer_select(req)) {
-		struct buf_sel_arg arg = {
-			.iovs = &kmsg->fast_iov,
-			.max_len = min_not_zero(sr->len, INT_MAX),
-			.nr_iovs = 1,
-		};
-
-		if (kmsg->free_iov) {
-			arg.nr_iovs = kmsg->free_iov_nr;
-			arg.iovs = kmsg->free_iov;
-			arg.mode = KBUF_MODE_FREE;
-		}
-
-		if (!(sr->flags & IORING_RECVSEND_BUNDLE))
-			arg.nr_iovs = 1;
-		else
-			arg.mode |= KBUF_MODE_EXPAND;
-
-		ret = io_buffers_select(req, &arg, issue_flags);
-		if (unlikely(ret < 0))
+		ret = io_send_select_buffer(req, issue_flags, kmsg);
+		if (ret)
 			return ret;
-
-		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_iov) {
-			kmsg->free_iov_nr = ret;
-			kmsg->free_iov = arg.iovs;
-			req->flags |= REQ_F_NEED_CLEANUP;
-		}
-		sr->len = arg.out_len;
-
-		if (ret == 1) {
-			sr->buf = arg.iovs[0].iov_base;
-			ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
-						&kmsg->msg.msg_iter);
-			if (unlikely(ret))
-				return ret;
-		} else {
-			iov_iter_init(&kmsg->msg.msg_iter, ITER_SOURCE,
-					arg.iovs, ret, arg.out_len);
-		}
 	}
 
 	/*
-- 
2.47.1


