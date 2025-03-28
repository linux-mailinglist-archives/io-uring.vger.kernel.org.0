Return-Path: <io-uring+bounces-7296-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B326A752D2
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 00:11:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 450FA16E059
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 23:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7940F1DD9A8;
	Fri, 28 Mar 2025 23:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lO46vkl8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDE155E69
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 23:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743203473; cv=none; b=U+u02YqsAM/UKR3ioIovRzx5xOP6IZv4cOaFyUObFHfFyEG62hIvAOU8WWeKwkax/kUOdXiRBpkTTwWkqmGCYbcc+7J5v3MsBnZLo9P/JAa2ttrt8IEHsNBqc6PQXbqCcmdGqKLfeDezIoBNqoVWSnksW17qcxYMOY/B5O8jErs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743203473; c=relaxed/simple;
	bh=D7krbmuYve0DsUzSGJuy4gGE+xr8UsknmSyBE4k9xNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4a0nVu9PP1U91MwF6IkisZRzhMLbBTP1eEym7cCfugSBkR0AjEV3Ub3Q+OXITUvXTsYtyfkdwgJHlckS8iI9YgLuktTafXsn1H3GgwdO85OFHrkwy6u5G6GWII5OQzt+zVuSyB8nm4Qaea9+cdZ1lF7Rt2XWiG8+1C60Q//mUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lO46vkl8; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ac2963dc379so424533166b.2
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 16:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743203469; x=1743808269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SsfRn4RUHJtUdIBF40MRyCJyqwoeBE4HQI/IKJFFVyU=;
        b=lO46vkl8QPJNX6rWZy60Y8yny91gqB43XspmJYRBkX6NF11Vn/x5g6vQQFNosBm0jB
         XC+SUetsKSLQtJ0p1RKqfcRhdIzT1aMiX7ht2xrvbArX0xjrscQ0fq2fHq4WsSYXE6+0
         WVmhVn7h9dvwn2dMP0iyKQk7RXsglOoDGtbr45B6mEQ5ZTV3ppzu1i9iJeXCix56wibM
         1fDmRIz6xPTkHuoD16sVpnTbnnhc+ERGO2eiFuqYQ9eiZHZLt9PH7mdePpIp5nM3Ginp
         yolcKN1s6/8WNoDjPbMWN/fW6BUZdPBDhqvQ28La8EkivgCXmdlCCFf0FyF0iDYFg2Ap
         mohA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743203469; x=1743808269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SsfRn4RUHJtUdIBF40MRyCJyqwoeBE4HQI/IKJFFVyU=;
        b=qMy53ktXs2q+TDmKyjeC5+Q6FnwCaZltkNdiaIfHy+nJ2rAEuX8WAR5+WH1Cdfc+BY
         N0GMo1c2q8QE4eZPpT3AXvbfbnDnT3wRgKQqfH4J0vHKdOTDi8hf6zOHsj9Yrl5CUFyc
         cCjhl3ldnBxUrlJlt6X+baek09x1S/uCVUBdMcBW/A2Z4wfQFlAoh7ZuT56NFUmOIbDL
         R9yXBJmUPYefygVanfoBphtapR6u3/gFKe6tUHd3eNYl9ryXcdyPO1k2ztjB+Nvg6Sr0
         YC333jKWOpLLB4cawx36Rh3PiUxqnNK/wNzNGvHSgHbMlyLvN1shlRGtw09IgAAAuZhJ
         0UEg==
X-Gm-Message-State: AOJu0YzORwsHdn8k9oIXISgo3f/Fc8wcXkeNvGER652hPTyT3wMhm1/l
	4A8c004pkGousf/JoDZPcTsx7HvoNXvr5Xj0B2yHbjVyOfZHO8kkEB2x3g==
X-Gm-Gg: ASbGncspiKQLyrMWpHFRjmNmbTNzYpiZdcGqf+ErVpT6jOyvlL07RV5uw0i5URyfpGl
	EshD22dd+SxJCfGj1YXNps81Pu+YuXYDGHf8tCDSwacLe0EKX2aAQyBFhQAe83Ka3v7zWKBNU0l
	/PiScmz2t+nc3nhlfwf34ojzFocv+RYUgF4uMu5JlpLjgOW9b3NDR3ZREY29f59RJPC/ILX05b9
	fpLTysGKHEFGzN/DcgpYP0o1vUzDXf4rnv6nzbjhDuXfWFVIdetCafDDumdKuAJ+AEfNEcB9StC
	/dkKyna+MurRchk9ijlx4af2pOFaslikCTFbjlPaiH8CkvPmkNY7ee0i+12WoBQj9xPnPQ==
X-Google-Smtp-Source: AGHT+IE5Utxl2xhLFx2wlRVD3+gsADjjAiL8Q7tCdrasiJg1kUqOOkhMM/cf85YBLEGHDVlg6AwUgw==
X-Received: by 2002:a17:907:a08a:b0:ac7:1ba8:d2ce with SMTP id a640c23a62f3a-ac738a5a614mr79842866b.32.1743203469394;
        Fri, 28 Mar 2025 16:11:09 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.232])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71966df80sm222838166b.125.2025.03.28.16.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 16:11:08 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/3] io_uring/msg: rename io_double_lock_ctx()
Date: Fri, 28 Mar 2025 23:11:49 +0000
Message-ID: <9e5defa000efd9b0f5e169cbb6bad4994d46ec5c.1743190078.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743190078.git.asml.silence@gmail.com>
References: <cover.1743190078.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_double_lock_ctx() doesn't lock both rings. Rename it to prevent any
future confusion.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/msg_ring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 0bbcbbcdebfd..bea5a96587b7 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -38,8 +38,8 @@ static void io_double_unlock_ctx(struct io_ring_ctx *octx)
 	mutex_unlock(&octx->uring_lock);
 }
 
-static int io_double_lock_ctx(struct io_ring_ctx *octx,
-			      unsigned int issue_flags)
+static int io_lock_external_ctx(struct io_ring_ctx *octx,
+				unsigned int issue_flags)
 {
 	/*
 	 * To ensure proper ordering between the two ctxs, we can only
@@ -154,7 +154,7 @@ static int __io_msg_ring_data(struct io_ring_ctx *target_ctx,
 
 	ret = -EOVERFLOW;
 	if (target_ctx->flags & IORING_SETUP_IOPOLL) {
-		if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
+		if (unlikely(io_lock_external_ctx(target_ctx, issue_flags)))
 			return -EAGAIN;
 	}
 	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, flags))
@@ -199,7 +199,7 @@ static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flag
 	struct file *src_file = msg->src_file;
 	int ret;
 
-	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
+	if (unlikely(io_lock_external_ctx(target_ctx, issue_flags)))
 		return -EAGAIN;
 
 	ret = __io_fixed_fd_install(target_ctx, src_file, msg->dst_fd);
-- 
2.48.1


