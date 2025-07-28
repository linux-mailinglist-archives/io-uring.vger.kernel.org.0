Return-Path: <io-uring+bounces-8838-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9726BB141F6
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 20:29:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD885189BB87
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 18:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FDF8220694;
	Mon, 28 Jul 2025 18:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="PXt1Oroi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BA3273D96
	for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 18:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753727364; cv=none; b=uBbXXy56fCO/I5y4XTDoLuGS2IcoWilf+ikwcjxkrMUNC8bKxCPAHtnmcwPoh1ditVdur3CVGc2D/TF/F/rouIlSB1cHtc3RvERN0iyA1RkakjszzqW8fT0z2KVAaWHONhT4KPM+KKTkG5+I+cPnljff5QMRFtjs9eMsFW1Cy4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753727364; c=relaxed/simple;
	bh=cO7qssLJn9Qz2ZmxqvIt2lOKlA/8v2x+WqxmGmby17A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SMqM51ZHxNFWfFKfr02JJmfgu5V2/zAzg/pDdV3fEtjZNKuWmhTfTG6iPO7F5mquWavF8Zhe705wFqIILAY0+JTT2r3+oV2PCjBkMrCZZUc0JSGV+8oMW7LxWmLOUbO/JpHBr2RifyBVzm6RGICdt8eCve1CCV+YN7+HIwRG5ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=PXt1Oroi; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-23c8f179e1bso54064275ad.1
        for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 11:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1753727362; x=1754332162; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9SR3DfxdttwMViNdmeFqq5ZBv/fIShOrdA+84ze4wQ8=;
        b=PXt1Oroi5ptX2jjXTogXbf1LFfLxOzlbWX/NCBcl3pKgN+g1Po6WYLYtEAUfL7C4yw
         RaLghyIQ/IbTFJ2Oh8Uv0kzpXwpqFJxp0YfW43bhM3lK/8wgsj+iPsVsH5JJoNFprRcx
         lz72J61H6OZXrcV8HG3R+9RL4D229tTzG9ob2QEHUr7zPfcesIe4eZsrZdFatUWjpGWR
         k3rFFm/TMXVfVSE8T5F8KhK91/8yWXmXx6FkhfQtlO79ZewDIZXDCJdlb9MNls8UV7Zi
         4RjCVMYrscUuCmoX5iNbs3YpVZPjwxbKrqi7Xve8UJuX8WMvMfmJAiu8zGPSTGAhBwoR
         Ucqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753727362; x=1754332162;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9SR3DfxdttwMViNdmeFqq5ZBv/fIShOrdA+84ze4wQ8=;
        b=skEXJPzIO2QDgURFTVo7ZmOsnoZru2xYTci3QqyGm3dJEUHBnExzcI7r/YjFdW6UCV
         mvOd4ODG1C/HSq4jM/wB6lDL9TaKy4kD0v6aF7M2KWXzweEtjkjU5YgIf4SXlsuMWr79
         7TiNWlN96ZODRyxOXWdqW4FnGqDZwL2yFCFTki0wQITi9c8sP2nBb4loocnDNqH/7zdv
         tkPgda1+yyH+vgM1L5W7dStGK+S1nmtxo84M2dqwpJHxgYD9WGPeAUJxvrn1IG1vNRi0
         3P/Agn77SwgMOUmkNUhco/zTG5YATfNh4UY7YwnKL3UfD0U+wcWQTaZuLpVz6O7RKMaw
         w5vQ==
X-Gm-Message-State: AOJu0Yw0zkyrQhZZo3B/uG8jZEr1kPIYDRKpRfxIEfXUVuneKmawrwVa
	zVsmAwjGDGEJ7pajLSxLnLsPKMj2y+DBPWH20Iq1FbmFccEm6Wu9ldcXyw9PYdgd
X-Gm-Gg: ASbGncvX8wJRSoxcp71b0adlpIXSkQb7AESb4aFMIcL+Q1DuDNV8TvBHMAQlU5xOLmU
	hg/lJI1r9i13t/R7Z3pNuirRSGBt7N1fHRp69NBQ5owGHd5OfqyJ8ROEM6gWH/D0xDRn4j/aHXr
	L+yVVSEJ8F5NKx1B1kTulOWTdOyZosa34HsVKh+ZWoxByNgGfZ5aseXKddWeddatXqThWTmFJYa
	poVhudR2nsj8BNS2IKDz11Uloa37PrEMju0ZggSSpKt/+LKizhWr+iUDAAeK9aLXDyItq82uPl3
	kglQtmWXlhSw7Tgovv9cToyKqgE+7YUvQAALK6nhmeN1FJNvjlBVIsiNj6xP5jzMcBBVsBIvxSV
	ygUKZuRMfbZUwOto64hCsT8vqGJOMwHZlU1kOyb5LUdQhB2qaMqSiEjVeOFtbCl88R4e9GHAW/G
	xW/qomyp6PoPf1qIqRGiRi+Efh
X-Google-Smtp-Source: AGHT+IH5B/bj50W77mJyutCoXFLkHH9J83ngN69Elpka2AanjexB7V0b2uJbYqnFxX9sZrXH+I3H0w==
X-Received: by 2002:a17:903:1b67:b0:234:e655:a632 with SMTP id d9443c01a7336-23fb31e5b55mr197022365ad.51.1753727362125;
        Mon, 28 Jul 2025 11:29:22 -0700 (PDT)
Received: from mr55p01nt-relayp03.apple.com (syn-072-130-199-032.res.spectrum.com. [72.130.199.32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24025f4a908sm27999575ad.89.2025.07.28.11.29.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Jul 2025 11:29:21 -0700 (PDT)
From: norman.maurer@googlemail.com
X-Google-Original-From: norman_maurer@apple.com
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	Norman Maurer <norman_maurer@apple.com>
Subject: [PATCH v2] io_uring/net: Allow to do vectorized send
Date: Mon, 28 Jul 2025 08:26:58 -1000
Message-Id: <20250728182657.18090-1-norman_maurer@apple.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Norman Maurer <norman_maurer@apple.com>

At the moment you have to use sendmsg for vectorized send.
While this works it's suboptimal as it also means you need to
allocate a struct msghdr that needs to be kept alive until a
submission happens. We can remove this limitation by just
allowing to use send directly.

Signed-off-by: Norman Maurer <norman_maurer@apple.com>
---
Changes since v1: Simplify flag check and fix line length of commit message
---
 include/uapi/linux/io_uring.h | 4 ++++
 io_uring/net.c                | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b8a0e70ee2fd..6957dc539d83 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -392,12 +392,16 @@ enum io_uring_op {
  *				the starting buffer ID in cqe->flags as per
  *				usual for provided buffer usage. The buffers
  *				will be	contiguous from the starting buffer ID.
+ *
+ * IORING_SEND_VECTORIZED	If set, SEND[_ZC] will take a pointer to a io_vec
+ * 				to allow vectorized send operations.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
 #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
 #define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
 #define IORING_RECVSEND_BUNDLE		(1U << 4)
+#define IORING_SEND_VECTORIZED		(1U << 5)
 
 /*
  * cqe.res for IORING_CQE_F_NOTIF if
diff --git a/io_uring/net.c b/io_uring/net.c
index ba2d0abea349..e470ca370247 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -382,6 +382,10 @@ static int io_send_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	}
 	if (req->flags & REQ_F_BUFFER_SELECT)
 		return 0;
+
+	if (sr->flags & IORING_SEND_VECTORIZED)
+               return io_net_import_vec(req, kmsg, sr->buf, sr->len, ITER_SOURCE);
+
 	return import_ubuf(ITER_SOURCE, sr->buf, sr->len, &kmsg->msg.msg_iter);
 }
 
@@ -420,6 +424,9 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~SENDMSG_FLAGS)
 		return -EINVAL;
+	if (req->opcode == IORING_OP_SENDMSG && sr->flags & IORING_SEND_VECTORIZED)
+		return -EINVAL;
+
 	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
-- 
2.39.5 (Apple Git-154)


