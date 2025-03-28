Return-Path: <io-uring+bounces-7292-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 248E3A752CE
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 00:10:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2034F7A7141
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 23:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A1FE1F4C8D;
	Fri, 28 Mar 2025 23:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QFxV/liv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646F61F4167
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 23:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743203431; cv=none; b=D/HYcijGPvVVGFErNfY907OTZIGtvQBRoxYOW7zvrVHkypM7xBp9Y5/xK0EHE9ClQRU98ZXfXZrm7LPlA75M9zt4vSdBm/NFsz5bpHkT8fFC7utp8cjVfvBDk22ep2oJ8rl2Xs/DgWzgQfSqicXWQEkpT1V01hdEL6sJAsjaqDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743203431; c=relaxed/simple;
	bh=Sh4H/2tYm/gesORQ7UXULXbYqsk4VSd2hXxSsadCTvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pt06ERWrHrLrOdnLfKLjp6y6dS5udGULDBwJmJW+zI9I4MSvS4RfoPoFLurvbP3qCoJ3ZFSqZbDusuYP4rh6poXMfrnq0C40nqv/1rouD+zrkr9Vqzr+Tx0pDkZclzzaCjgZwYzNSNTCY5pGQWCwqA+D1KJGmKyuElu3unJkm5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QFxV/liv; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ac3eb3fdd2eso529302366b.0
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 16:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743203427; x=1743808227; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=utAzfAKpwciWumQY5hOPviH80Nc7+i4uRCtsmEiZtiU=;
        b=QFxV/livYistNlfSq0KCXoiKFBOckzXVE0JDMT/lxavYw+mT19JEdYaDtPbP3jlE2a
         iejxnYNPzyzzEZz9XdG83aLRoiX7kyUGVFyCLgD8CIibHD/MBbwdWIbxz6opzVrrDnie
         6Pg3PNj59L9UJ5jRAlkk3Gag3H6nMaugMX9OJFU5lttscD94Hg28+izyAfzWgzveOo2g
         FVXgg5lIKmF+W3/DxatbE3YnTUXojn9k0acsde/9BMrnHUYbhG/UlTQTa7Shv3I3QCK7
         6+9CuuEZz5eivvW6T4PZg7MkL/jgNeBH15oeEtitTUnLwxsvOStTtQKH6x0fijRNvdsJ
         MUyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743203427; x=1743808227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=utAzfAKpwciWumQY5hOPviH80Nc7+i4uRCtsmEiZtiU=;
        b=PQ4Uc5DCYyj5oYYCyuQBNw61/0qDedSvVhLM5iEVH0smUi7CKQG6sWnReKsorNDaxz
         29STAkBfAdVBNVhrryXVeySZCRD4WA0reHs75DMoh4t/IMZcOJUC52Hsl5GKxxV09Gqi
         cKAtdi4gtyG9uXzFEZLrLSFenaL/Z7Ck/ZIz59+jsFG+U0Gok9o1wsD5Fc+Un1LYMA0L
         S9MBsDaPvr6V/+IRx8BNt2a2Be9gK4qQ1CnUnEhPmymPoOYTnWV9N2crGruwiawGgMdq
         sro3/1tzbBBYPbj8qQ1zbgX8L8up1trXpB8dLjcJmG9ShKMubQh5EBQ1vslbwS/uKJyA
         VSbg==
X-Gm-Message-State: AOJu0YwFggeAQDNW2csW9Pu5oQmCUYd0WWJMIFpVN8edeUH0ikei5PUa
	gMwoDerTbBrYeCRkCQ9QGEBjSSJTVOYzvFqtItG1HfQ1jHuD9J8DcVUDsw==
X-Gm-Gg: ASbGnctCRN4OPyMwTHdm/wNGD7vlrhFvIIa+dIs6hZyP9N7dhzfy3Q7qExUXB1eaV6J
	eMr2XaD4E6rtCg8xEygJDHoFTe5RahlBYahBFbH56YfbpF9XtnORRN0H1aSBgR0uZNAMUq4fj4f
	9v5AFGriCg+8zrUs6+ZKkAuuyGpcxWgKf1jYYbV1IY6ce954inoCEV2yenogADWRsO/kKHEllqA
	gH6OA51qgsDGOcPMcw71ti2PtiXYmAm6d893ewPSXWWUrgXExTwpKHcrHGQod49znuTFVgn8Wsc
	cE59cML78w+Blj2VQMOLMIVzQmOKdrzwQxXTqgfGHgJ5UOc/i4COJVft7bA=
X-Google-Smtp-Source: AGHT+IEsaY3nHB/nkyXEEHZDqC7azJjvlNLox7t345cDzLL748VHTfQQoA+bHXTklmFTWfU+Vb/bkg==
X-Received: by 2002:a17:907:72c2:b0:ac3:3e43:3b2b with SMTP id a640c23a62f3a-ac738aaa69amr74071166b.18.1743203427053;
        Fri, 28 Mar 2025 16:10:27 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.232])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71961f04dsm228915966b.91.2025.03.28.16.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 16:10:26 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 5/7] io_uring/net: clusterise send vs msghdr branches
Date: Fri, 28 Mar 2025 23:10:58 +0000
Message-ID: <33abf666d9ded74cba4da2f0d9fe58e88520dffe.1743202294.git.asml.silence@gmail.com>
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

We have multiple branches at prep for send vs sendmsg handling, put them
together so that the variant handling is more localised.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 6514323f4c60..9162dc6ac5e9 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -395,12 +395,6 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	sr->done_io = 0;
 	sr->retry = false;
-
-	if (req->opcode != IORING_OP_SEND) {
-		if (sqe->addr2 || sqe->file_index)
-			return -EINVAL;
-	}
-
 	sr->len = READ_ONCE(sqe->len);
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~SENDMSG_FLAGS)
@@ -426,6 +420,8 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -ENOMEM;
 	if (req->opcode != IORING_OP_SENDMSG)
 		return io_send_setup(req, sqe);
+	if (unlikely(sqe->addr2 || sqe->file_index))
+		return -EINVAL;
 	return io_sendmsg_setup(req, sqe);
 }
 
@@ -1304,11 +1300,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		}
 	}
 
-	if (req->opcode != IORING_OP_SEND_ZC) {
-		if (unlikely(sqe->addr2 || sqe->file_index))
-			return -EINVAL;
-	}
-
 	zc->len = READ_ONCE(sqe->len);
 	zc->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL | MSG_ZEROCOPY;
 	req->buf_index = READ_ONCE(sqe->buf_index);
@@ -1324,6 +1315,8 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req->flags |= REQ_F_IMPORT_BUFFER;
 		return io_send_setup(req, sqe);
 	}
+	if (unlikely(sqe->addr2 || sqe->file_index))
+		return -EINVAL;
 	ret = io_sendmsg_setup(req, sqe);
 	if (unlikely(ret))
 		return ret;
-- 
2.48.1


