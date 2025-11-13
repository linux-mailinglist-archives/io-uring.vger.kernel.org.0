Return-Path: <io-uring+bounces-10578-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5E68C57057
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:55:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 004D23BDEDD
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:48:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC865333740;
	Thu, 13 Nov 2025 10:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Utr/Ycqt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C6933507B
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763030798; cv=none; b=WenV/WNraeLK4AkAzjP8bW5ezo21YcsQ5dLOkVhSj4DHhO8RGNleqbdWiVNFSJ+A98OGY+EM4GhTz7Y0kG8gZ8YtooPQ3USvhu8bx+YW4nYeVuzCGRPDHeqBxf5KqMaNETydSlW65lC98HVwS8+OHYmiVHO0VHDr1JPoGMq48rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763030798; c=relaxed/simple;
	bh=+rhDk982EzCFvYQv00Owr92/Hx0avc4Ng/M3aSKvhV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qbe0txSdou0OUO1ge1rJKqNsFP5lSi2OP/l0u00zz8f91GAiv7RUGMyvK9aezyUjT8h2BcgAUGx1sul+Xs6BLoC0ViOsrehiygea9y8F/FAS5/tnPILB8qXPTf7RWrnTC/KvBPfhItCvBFQgIu5UMoP1aMBYNt5zbSADtTN+Fik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Utr/Ycqt; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-429c4c65485so573308f8f.0
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 02:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763030795; x=1763635595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D6L17PdjIQ0I4W/txT3ofY9NSqCulyqTttOKU1s6mNs=;
        b=Utr/YcqtenT3XiYCrgGN4FO2tov+BlzyOpMT3fPmlAcmcTgKQbG4RTx+iIMCdFGSr8
         +ynJXPxGKWFEgqNDUj+SUHLKWdO+SuhLyIMRxzbr1KxUrUnVOfaVontXoJgu7UwI4a97
         85rrZNwIDeUOpu5kLcPQ7WyBGVLs1qDdJzsxO5FzViqU2omHiQyF/pdA4YRpthke9nKR
         OqrgM52BHLbsBMHntgnsaLH71YS9qOArIghobjlT+S19hgdb424d1cj3Ch6AWrJk2rY3
         0xx9KdVOEre7Wg1ZVwePXSHNIlA35iZ3b+1RtTPi/vxRdleVlAPaQc2DPk4K4nKSQwKH
         Ea6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763030795; x=1763635595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D6L17PdjIQ0I4W/txT3ofY9NSqCulyqTttOKU1s6mNs=;
        b=Aa+tWMyQesuSxBBQ+zKl4NZlnVosoOOGdsNo8w5ApcU/kO15EWbCGG68l86RXpOdy8
         lcLO05S00yY5eJILyRgpdYRwhLikUvVu6b6mWhTyUNG+k62fNGv5hK5bfVsCjO0PcZ2k
         H4DDO9WBU991taUmGo8yoQjKIAaYNNzjYn9gEkORWNUdN193+WzEo0AeQhemXnNel4m8
         KX3eHoff6OBRHmmJPlvRFU+0UqBZvHyGZuRsvHNn8dqC9XLz01joQeHkQ8n4jkZ/OvZa
         criUKkCHgepjiHrEcHuG2nZa7m7SJR6r8STlk8rNvdpu2hnliSDotp0bj6WacnXbRSz0
         OMaQ==
X-Gm-Message-State: AOJu0YymM2HIQrVTmKQ0N7Umz3RPDEIEl4NLMLotLdvAOF98L0GHMCb6
	Q9WHXXa7/spkZ2hcwms/VzkZAJQU2DePV2LiwElnDPQsaLpmrP+DqpIwQL1BbQ==
X-Gm-Gg: ASbGncvYrv3pOf7KdqkdFvlaOlbCWOBOpF61jdG/w72E72Cwf+mhxX65eS18N6fjviF
	0Wy2hx7kw1hksgdySaUZUQE8fA+W3Qr7g+jPRBqHpIizMB1KarXBHH1g3x1Gs6Bfa3y7CtugFBy
	Z/GBEuq4w3NldbeSbTk6+fbtTF4HUyLVCLl7c0lJcf4JfBiqe9CB5McFCYelntdTjvBhlbKNHba
	GD7dmPunilHBlou5KDz2ukQc8u07r+wVwYISvu6dGUaB+YQCU1ExhkjSs0aQI7M9ymMic9IbOhk
	UnBdSDUOsNNdeBY1i7AuuvmruXkWX1WvM/Bb39eCGGot9H+wmZZLP8NCwTUMULhus7DVpdM+9bf
	SWsMKc5upuhxX2tTOmNS8h5zAZN3wxD3dDZXcIGc/yn4xwVDUXYFhm/dgZN8=
X-Google-Smtp-Source: AGHT+IEig4C1NTiH+dl6TVyWD3Z+E5tDcp+tu/v4WJtJG26QDirlwhDV+zuNkvKKfKGdeToMKxichQ==
X-Received: by 2002:a05:6000:2087:b0:429:ca7f:8d70 with SMTP id ffacd0b85a97d-42b4bb91a52mr6264315f8f.15.1763030794955;
        Thu, 13 Nov 2025 02:46:34 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e7b12asm3135210f8f.10.2025.11.13.02.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 02:46:33 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 07/10] io_uring/zcrx: move io_zcrx_scrub() and dependencies up
Date: Thu, 13 Nov 2025 10:46:15 +0000
Message-ID: <f8a6aed311288b3dfd486988261d102e5420a700.1763029704.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1763029704.git.asml.silence@gmail.com>
References: <cover.1763029704.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Wei <dw@davidwei.uk>

In preparation for adding zcrx ifq exporting and importing, move
io_zcrx_scrub() and its dependencies up the file to be closer to
io_close_queue().

Signed-off-by: David Wei <dw@davidwei.uk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 84 ++++++++++++++++++++++++-------------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 2335f140ff19..e60c5c00a611 100644
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
2.49.0


