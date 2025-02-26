Return-Path: <io-uring+bounces-6779-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2613A45D5D
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 12:40:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5FA53A9B2B
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 11:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6113E2153D1;
	Wed, 26 Feb 2025 11:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RPv2+6Xa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D8217BB35
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 11:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740570037; cv=none; b=XzsQbMvMYWsaBgWhwaxJBpzkLVL9diCYSaWUqww1SLHUKHZAHELuuy9Byrbab/AoTgitf2GA2GbGoioQ9uY/iwJUl7qYT1em8SLSw7oRiIISb3X/Kh89lpdQRJatt+PKNZfvAxI+KlsNBdID6VcKwDRnlYsx4wiKoUdBBk7bywI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740570037; c=relaxed/simple;
	bh=/pxwft0KfZH7w3fHGORDU64FaSwjat6dBOf5sp4tL5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2p1C5u05yFqJpBYk7zYfqWKJd9xges9NeULF+c/4stxwVxX5uhLa17BRKsKNbmMGElyyW5cN4cfkkx7zdEkV8OvI+zUCOhomlGS1aVx4oo+SjAchc+OdF1DWJmorYriEUGyyLj3zKRArRkjAUEj+oRuGmNZZqsKc2v33ApRN34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RPv2+6Xa; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5dca468c5e4so11963609a12.1
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 03:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740570033; x=1741174833; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0LXbnwcIBc2J1W8+NT/KbDyiw6ZmnDEsBSK3rUjcCzQ=;
        b=RPv2+6XavdwBnJGiIMj92UQt+y1vgAf9n6SlzKm90PXa4hwZAB6AoGeEjIckJTNNNv
         ypCgFbQ33xFp+BuYDyiYF2C23v3ff+2THaVd8ZlvN4b8uwSMjy0h5RGEPtf9E21/k23I
         M6LryG731DrJ7HTzQAKfF/wzi5jCOoa+4kIEmynRIM0K+/AN/cwtMBs7+RnocHlTP7dl
         QKSs0a2upyGeLeXx2p/k/HhW5GwMLjs54zZ9wDJFg9dzyZN6YUvtVucapoyINmp1ORaB
         C/nNQu3iRJ+YUmMDzNcq9WHXMIp0uHFv7EaR6UkWpDD63iXdR2vjdZ7/A6IEqn9mbaM7
         +bjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740570033; x=1741174833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0LXbnwcIBc2J1W8+NT/KbDyiw6ZmnDEsBSK3rUjcCzQ=;
        b=p9sep1XgjhkijEFjz1RxTjsmtCKOhlmqSegqxuxAaVeG2wXvSHDamByaFODymwHrlq
         uqoFlFTYrBeQNrGQxUBrsnM79+5NdxaGLsLmdCG7GeOLzNdlqxVDavjZGlxejDoouZ8w
         uSRSfj17vGhzGbmTQZwGL+N/Wy+olmWcKLua0pOQ3x2F5eIMdleNfQ7ReJ7PMCh92dXw
         6OHjKLi/+XP9ckyZg5eQNC7JNU4z3MRAOEfKo9xL0VxViOHiqG1p5Tiqr/i7stjIigY8
         T4lXp9LnzcaSLYWcBJCemffoH2AL73W8g6AUz980jZ5BODPhigMK8UbdsFlNLwaZO8QW
         0vMA==
X-Gm-Message-State: AOJu0YweL2eMgWbMNVgdM/GqMBxEwx5aF9RLZaCxm+NGPpfaZAoxpqAK
	0ijnNn9uyeShmg9K8wozmGtPnDk4G50MRoDAkDQ9xhreME4EBSX5TqIqaA==
X-Gm-Gg: ASbGnct8Fa308i9KXDY427bKklfDCgF+cb4q2oC9RduM5u2obdph1nuSuWkKQEYYDk8
	F/oW1LFzU33R4tU12rW2VeVZXdSwd/OeeiH4sJhxW4f5JJU/NVr/CfU9fwhfz9428uzt8d5utkb
	5T8TgjFVchHLDoPVN7OC39XaYD9cQ1ToQiFJv9TRupiacpG7Wy5k9MUk6OSPsMlFVIZUrnfcX9t
	CmGVsz7ZHvHsAOafJBcPTGRJ5N7qXY5YJFwmOscae/Wk7yvdHbZfPPj/XoqAHrzDk7/XWVdRCpK
	0Imc8kjQ9Q==
X-Google-Smtp-Source: AGHT+IH5N+MU1rm63geijzZE5ziA1EbI/NAfepVyuGX2dIZldjZoZj0k8JdvJygqXoqUe2jlu2EXJQ==
X-Received: by 2002:a05:6402:2743:b0:5df:4181:d2c6 with SMTP id 4fb4d7f45d1cf-5e4469dd8d8mr7902700a12.19.1740570033268;
        Wed, 26 Feb 2025 03:40:33 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:7b07])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e45b80b935sm2692418a12.41.2025.02.26.03.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 03:40:32 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/7] io_uring/net: remove unnecessary REQ_F_NEED_CLEANUP
Date: Wed, 26 Feb 2025 11:41:15 +0000
Message-ID: <6aedc3141c1fc027128a4503656cfd686a6980ef.1740569495.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740569495.git.asml.silence@gmail.com>
References: <cover.1740569495.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

REQ_F_NEED_CLEANUP in io_recvmsg_prep_setup() and in io_sendmsg_setup()
are relics of the past and don't do anything useful, the flag should be
and are set earlier on iovec and async_data allocation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index bce75d64be92..c78edfd5085e 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -388,14 +388,10 @@ static int io_sendmsg_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
-	int ret;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 
-	ret = io_sendmsg_copy_hdr(req, kmsg);
-	if (!ret)
-		req->flags |= REQ_F_NEED_CLEANUP;
-	return ret;
+	return io_sendmsg_copy_hdr(req, kmsg);
 }
 
 #define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_BUNDLE)
@@ -774,10 +770,7 @@ static int io_recvmsg_prep_setup(struct io_kiocb *req)
 		return 0;
 	}
 
-	ret = io_recvmsg_copy_hdr(req, kmsg);
-	if (!ret)
-		req->flags |= REQ_F_NEED_CLEANUP;
-	return ret;
+	return io_recvmsg_copy_hdr(req, kmsg);
 }
 
 #define RECVMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECV_MULTISHOT | \
-- 
2.48.1


