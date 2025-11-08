Return-Path: <io-uring+bounces-10461-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 54CF3C4331C
	for <lists+io-uring@lfdr.de>; Sat, 08 Nov 2025 19:15:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BEB43188DA89
	for <lists+io-uring@lfdr.de>; Sat,  8 Nov 2025 18:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D75632765EA;
	Sat,  8 Nov 2025 18:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="hH97iHbD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419B724C676
	for <io-uring@vger.kernel.org>; Sat,  8 Nov 2025 18:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762625672; cv=none; b=n46I5mgT4+WTdGDqMq+4zkUsVtUom7MZ8XCUflUhb2hf93LjmXwZ2FeqaLULKjWM2XDaIoi33WOGGgwZEVC20xshu8WEYJjPt1CopYPQlhQA75baYvtVlr0tp60gG1oQ59U+pI1Kxd0jb9DbHA+9PqeqRWd0TkOaLLxBPi1FrSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762625672; c=relaxed/simple;
	bh=ALbMxBYQ50i2cGIbwMNo3sk7XS5JKfJDyg4VskKilwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/WIUtareqqjZLWFV8t8khAELULmyky3Vyse0miL8YxlygrT3IGH1lWi0jP3Rt6Y4LlXMiAduq4bUhOHCWuOxyOJM7RN+1CNVsoJ9NFnjTokDYEBI5WlFi/I59Q5UR3O20Pq+4SRURbakLssD5JvvZA+zKMuuMlb1vUZ1Z8wm90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=hH97iHbD; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-3d3ed0c9f49so460916fac.3
        for <io-uring@vger.kernel.org>; Sat, 08 Nov 2025 10:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762625670; x=1763230470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ARwsIgR1zNahkjeX92ETMk2JAHXE0bgOJE+HQapN4EA=;
        b=hH97iHbDNMPsyGrGDqhOXSfl+JGSLkmO+sSG8z5CVOh6m2j0PBYO+x1lws5v6efvtO
         5louZCx1ssYMmprDDaTv2TcHiuyUfOXNy5aUBw90jC+QU+l8bNzcolGINH5y3MNrIF4d
         pQRNTST+H2X3Zg4mse0VZz6R6K7cWbuXwZD5Zj2Yll2MpHpy0RHiLAn4hJZjOz6kMSva
         BO/HmMy8JD3cHHyrJ1hoSCElJV2brvBBJyxypFdBf76qBy338YU8fjTkrAlkW56jtR00
         SBFoMvDC3amh6FkV//aTsL8nbTo8ffx4JeKewxh7lvoVPw30Q6/PZE6YOj6O3YFRlmzp
         3zsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762625670; x=1763230470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ARwsIgR1zNahkjeX92ETMk2JAHXE0bgOJE+HQapN4EA=;
        b=c42O/KS0MUk3BJCUG/Q/OwXPhOSc00sjwC1ed66Luo+opNrQXKDVi8EiwHTdEOZXH9
         grHepOXYjx0tJHnrzz4YAePtaYVeu5JYLuwSzTXVXB7WA0JsUu/XZSDVnNBtpBdw1LZH
         V9Kq87a2k0/bk7mI566lmMi6E48HpPwiTogzW/FfkLjlNuguwcFrK8BWmBdwtQBvUKaC
         oiAhrfKvA2qQkUmCEtcx6IgioecFJbVq51GrSbla+8qv+MtJh8On66xndlXHkd/fGtB/
         aG0vfZcYDhDpT/3TW9AiofelswR2MGbLnue1T7zbfMzKjDjQyYQDRrjhBmXmY6ItfKTM
         V76A==
X-Gm-Message-State: AOJu0Yyo5t8l2IwLl+17rLNt4vGMiCN9Xkl57T9atljkFgFwPRMhp03Y
	dENT971SH4sfMcZqhaVmeI4RazZ9kb/04mpVQcQSkVIsVbkdyaigFwoKoMZpchsJWI52u6WbBp0
	ebjiB
X-Gm-Gg: ASbGncvdV/1126a/pxDaaEyQKjp/fUJWKty/dhj7WUL4+KnSsvcX+FLkqpnc/EcGhlh
	XTKONe0Io8MaqrKMmcHqGg6+hdiHBq2c8QvnXPbp8jhlu6FATyyKHPnY8q4DU6UvFASipucQ5Az
	MOK11K5s0ppXZIwOvbivkzxH8NzdaKjKaaPmqYSqBezIzxYNBNL5ouERpdUa+lp74YYi9Nl8H0h
	OJxtZcewGjztjA3MLxdjCNf677fK8yStTxIgY6HOZ5CGm91GAezy61VMP2CL1C4qYZeGmi9kCda
	PgNrB9N8XD1PU1rlixnxv/y/Wu3xVm3Wmw+/Xa1ATkOscP0kzHhM8fTDKmrv9OqARIS4kIxzQV0
	dHJfqSdI3bDQ5jtfeRQKBNVW9Gd8iAjdH8GrEklQ/MCzZ/yjf5Z5UdlgnZ/XOAUWNTk+FiC+0Vt
	CNQSCoAeXy82JyhSOjbnnrga0RUGkqaQ==
X-Google-Smtp-Source: AGHT+IGEiCKYZ3whC5s4dVkEbRJF+F5VGrXjpc8n1ZdUsVw4xUyn930uRQr3wn5loxBN2vKxJHMQ8g==
X-Received: by 2002:a05:6870:3194:b0:3e1:4ab8:d7cb with SMTP id 586e51a60fabf-3e7c2b97663mr2411213fac.36.1762625670389;
        Sat, 08 Nov 2025 10:14:30 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:45::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3e41f1d0326sm3782743fac.19.2025.11.08.10.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 10:14:30 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v6 2/5] io_uring/zcrx: move io_zcrx_scrub() and dependencies up
Date: Sat,  8 Nov 2025 10:14:20 -0800
Message-ID: <20251108181423.3518005-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251108181423.3518005-1-dw@davidwei.uk>
References: <20251108181423.3518005-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for adding zcrx ifq exporting and importing, move
io_zcrx_scrub() and its dependencies up the file to be closer to
io_close_queue().

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 84 ++++++++++++++++++++++++-------------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index de4ba6e61130..48eabcc05873 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -544,6 +544,48 @@ static void io_put_zcrx_ifq(struct io_zcrx_ifq *ifq)
 		io_zcrx_ifq_free(ifq);
 }
 
+static void io_zcrx_return_niov_freelist(struct net_iov *niov)
+{
+	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
+
+	spin_lock_bh(&area->freelist_lock);
+	area->freelist[area->free_count++] = net_iov_idx(niov);
+	spin_unlock_bh(&area->freelist_lock);
+}
+
+static void io_zcrx_return_niov(struct net_iov *niov)
+{
+	netmem_ref netmem = net_iov_to_netmem(niov);
+
+	if (!niov->desc.pp) {
+		/* copy fallback allocated niovs */
+		io_zcrx_return_niov_freelist(niov);
+		return;
+	}
+	page_pool_put_unrefed_netmem(niov->desc.pp, netmem, -1, false);
+}
+
+static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
+{
+	struct io_zcrx_area *area = ifq->area;
+	int i;
+
+	if (!area)
+		return;
+
+	/* Reclaim back all buffers given to the user space. */
+	for (i = 0; i < area->nia.num_niovs; i++) {
+		struct net_iov *niov = &area->nia.niovs[i];
+		int nr;
+
+		if (!atomic_read(io_get_user_counter(niov)))
+			continue;
+		nr = atomic_xchg(io_get_user_counter(niov), 0);
+		if (nr && !page_pool_unref_netmem(net_iov_to_netmem(niov), nr))
+			io_zcrx_return_niov(niov);
+	}
+}
+
 struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
 					    unsigned int id)
 {
@@ -684,48 +726,6 @@ static struct net_iov *__io_zcrx_get_free_niov(struct io_zcrx_area *area)
 	return &area->nia.niovs[niov_idx];
 }
 
-static void io_zcrx_return_niov_freelist(struct net_iov *niov)
-{
-	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
-
-	spin_lock_bh(&area->freelist_lock);
-	area->freelist[area->free_count++] = net_iov_idx(niov);
-	spin_unlock_bh(&area->freelist_lock);
-}
-
-static void io_zcrx_return_niov(struct net_iov *niov)
-{
-	netmem_ref netmem = net_iov_to_netmem(niov);
-
-	if (!niov->desc.pp) {
-		/* copy fallback allocated niovs */
-		io_zcrx_return_niov_freelist(niov);
-		return;
-	}
-	page_pool_put_unrefed_netmem(niov->desc.pp, netmem, -1, false);
-}
-
-static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
-{
-	struct io_zcrx_area *area = ifq->area;
-	int i;
-
-	if (!area)
-		return;
-
-	/* Reclaim back all buffers given to the user space. */
-	for (i = 0; i < area->nia.num_niovs; i++) {
-		struct net_iov *niov = &area->nia.niovs[i];
-		int nr;
-
-		if (!atomic_read(io_get_user_counter(niov)))
-			continue;
-		nr = atomic_xchg(io_get_user_counter(niov), 0);
-		if (nr && !page_pool_unref_netmem(net_iov_to_netmem(niov), nr))
-			io_zcrx_return_niov(niov);
-	}
-}
-
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 	struct io_zcrx_ifq *ifq;
-- 
2.47.3


