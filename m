Return-Path: <io-uring+bounces-10272-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CAF28C164ED
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 18:51:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 514215056B7
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 17:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA8A434DCF9;
	Tue, 28 Oct 2025 17:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="GySTAjes"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129FB34D933
	for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 17:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761673609; cv=none; b=XNPNt1kETMYaGWQL5S3sbXsK2ycmt3htTD3tHP7Xocw6Q6JhTREtR20lKx7hFxTqxe6g8nW35teDn4JWN+UGKhehSs5Y5gU8wNLoHr81R70v0IqKO1/TJLi4L1b/EzB4QFV1DzTEhTZIyMCe9qPr8FXDioV+TiwY9B4JLmX2iXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761673609; c=relaxed/simple;
	bh=4X7yplVhodWhw/RkySGYlwrpw581slqzwJbYHW/2BNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twiGpP+S3f5Xhd2lt8PP7KpsSRQ6EuZVOAc2L0UuCq3uH7IQtTAFSz7ip6KlHfAhqdiN0IQk3lYFOpCpxx2cV8Tg4/oB4aDzJUS7VbY4Hi4fbSKeLLEV2ddDdltDl8yV5lcc3SNcOJpdZWZldt6rSiikhqLxQkS89BPCwQx6vwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=GySTAjes; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7c284d4867eso1889642a34.3
        for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 10:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761673607; x=1762278407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EDyf8hnr6ftwJRjPNQhZsT5EFe6u4EruQiaSCRXzIjY=;
        b=GySTAjesw3WeotvxhJyl5gG5/gON04KEkEMyE+3DnzzzpeOuPTzWAKaLq0A1ZRT0nV
         /IFUsmZCEvSo+ErP8CJoDwwQ1iWW1TmQoNi4QINYMyGAO66aufQGScwRRcEcIsfHPAlP
         5nR0kYZWZPSY2Gp689XFCigAv0ywzmW76gHg8w0AVG5mvqhWZBXdIonLN7bbIeTdB8d+
         NK/4rLdPxZswsMCdzWqR1TWzrSllO4+k5/r4rxWeOhaw6xn5lwqSL5iIkplVpIKMDVBO
         16PG6uZKEgm1zsB9jMVd4unzUNNboeVrODyybYpoZ3bndsZzusMyAa49csd2pjxRlHVj
         L89A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761673607; x=1762278407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EDyf8hnr6ftwJRjPNQhZsT5EFe6u4EruQiaSCRXzIjY=;
        b=WWTzMMuGe9BWA1AfMoWqGVjVnO8RbUXKJj8TzgpDAfcLmtwvE6GnDVeSra3rdJYN2X
         ryMxqvmlXAcffoCZ2Jy4dwRMUuxnsT3vQEMw7Eu/fONT3+SYQSo24j+8AHdHjqf9EspA
         4BYoYSLTBswI8it2Ngdyx4a/DIFS0YdOnuNm3tKnQDZY/hgIZMFxyso74ZgeRTw7Hg0Y
         ZlxhDJ2cz4/xkwnEfTV1MrpBhlv9CiBNSReRYwxOL0Pq6LJZwb/syog0ghoEbYoDw1/2
         +tRalBotFCNQ1nZeXbGM9OX22sC0co5MKxRjbJ2g5oDCoTdtwe1omrYq9MeumTM2QY97
         BGaA==
X-Gm-Message-State: AOJu0YxymlkmlCDvKGx5oYbsb50yhgpMT3b3a23JSl/5Y+hSSTtJV0+P
	7Ut574GHaGnnUiPeycsvUQqMFOn/UtlYEmYwWG8sRY0sGEMVIPLv5P7cdyhx+J8vjkfETFcbuPt
	1unJS
X-Gm-Gg: ASbGncvF/gGYmX/hHFMRvXxdjIAiUVhmhzoqQ75Ln0LyyyBIdNP+HMv4EeuyHpa2aRx
	TN2ay3xtvw0F5gw74v7lh/O8vz5ESgK2yXPU6e+NVYWZ5owMWPSyF1NXuaMG6M4fdchMTZNxKR5
	iAZHVMMAmFhJoJeAOQZ6l6dl1ICxfMmXmE53cefSyzkNjKvlgOfTj1VV4Yt5TQQBqAu/pQCWzsO
	Q9mHriFHaqMX4sGCjIz8u1NxTMvxqLEmsZsIMG3YmC8RQ8aqaWc2IpcHACf0BN8TdmxpLWErwoU
	JGuvvmwglx9Y3x8DOqHoyYewHPSRa7EJ5obRS5/NUXmHoXxWRGHTwak2Mb2WDjrz8VhYLWZg4le
	3F1zS8SrT8+js9VnwCCvoB/LW9TX36OIqKNIBm5hJvLO5NqJSX+r4pq3YIzJlB1nws8++XZEhgs
	LlLKH32NZbnUIV8vBKiBWwkLqlR7oAbA==
X-Google-Smtp-Source: AGHT+IHy6oA+5SIa1EhB6DkbklhqEBYozMSXWJiOdcmQiwMz1qehwMqQblPJYpBg1hC9JfGHacdesA==
X-Received: by 2002:a05:6830:2a92:b0:7ae:39a2:2656 with SMTP id 46e09a7af769-7c6832d1bf7mr75178a34.25.1761673606975;
        Tue, 28 Oct 2025 10:46:46 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:44::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c5302068e3sm3373571a34.27.2025.10.28.10.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 10:46:46 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 6/8] io_uring/zcrx: move io_unregister_zcrx_ifqs() down
Date: Tue, 28 Oct 2025 10:46:37 -0700
Message-ID: <20251028174639.1244592-7-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251028174639.1244592-1-dw@davidwei.uk>
References: <20251028174639.1244592-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for removing the ref on ctx->refs held by an ifq and
removing io_shutdown_zcrx_ifqs(), move io_unregister_zcrx_ifqs() down
such that it can call io_zcrx_scrub().

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 774efbce8cb6..b3f3d55d2f63 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -662,28 +662,6 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	return ret;
 }
 
-void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
-{
-	struct io_zcrx_ifq *ifq;
-
-	lockdep_assert_held(&ctx->uring_lock);
-
-	while (1) {
-		scoped_guard(mutex, &ctx->mmap_lock) {
-			unsigned long id = 0;
-
-			ifq = xa_find(&ctx->zcrx_ctxs, &id, ULONG_MAX, XA_PRESENT);
-			if (ifq)
-				xa_erase(&ctx->zcrx_ctxs, id);
-		}
-		if (!ifq)
-			break;
-		io_zcrx_ifq_free(ifq);
-	}
-
-	xa_destroy(&ctx->zcrx_ctxs);
-}
-
 static struct net_iov *__io_zcrx_get_free_niov(struct io_zcrx_area *area)
 {
 	unsigned niov_idx;
@@ -749,6 +727,28 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 	}
 }
 
+void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
+{
+	struct io_zcrx_ifq *ifq;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	while (1) {
+		scoped_guard(mutex, &ctx->mmap_lock) {
+			unsigned long id = 0;
+
+			ifq = xa_find(&ctx->zcrx_ctxs, &id, ULONG_MAX, XA_PRESENT);
+			if (ifq)
+				xa_erase(&ctx->zcrx_ctxs, id);
+		}
+		if (!ifq)
+			break;
+		io_zcrx_ifq_free(ifq);
+	}
+
+	xa_destroy(&ctx->zcrx_ctxs);
+}
+
 static inline u32 io_zcrx_rqring_entries(struct io_zcrx_ifq *ifq)
 {
 	u32 entries;
-- 
2.47.3


