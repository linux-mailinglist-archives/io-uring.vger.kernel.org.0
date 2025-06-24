Return-Path: <io-uring+bounces-8477-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E9DBAE66BC
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 15:40:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E62B01925776
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 13:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98BC11A2630;
	Tue, 24 Jun 2025 13:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jTOsLQda"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83952F43
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 13:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750772365; cv=none; b=N8z3mlCPF1vZIT4v+JsjUKGj7Zu0bo42FuCsWaRme161jWyMXd93isFrJaONYw3xHnlq7ReYQHTAbntKSBN0bvcxTofS6HioEp1EETS/WsQ5PamBJoa1pbFKaXadwow82BSizIjy4eVQP6f4DHT339gb1jBYZF9XSqVFN0avtJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750772365; c=relaxed/simple;
	bh=alDrcBczh/zLgglB893Pgk/X8u16PwMiZCxap5paS0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imvLozAo/wlLBka3w9S+H7OUgyGJJP08VKgOHn+ke+J/g8KXRCMX43+CJvToa9l8E3hzI4H+vqoyGd3aP0WLL1g4cnSqTBbLPEcFCP4HSM0ubXG0qo3tWifVKKQZ+IwqBYdgmgYb3syQujdL/ErPLqA06twcC38mFI3iDLYbnbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jTOsLQda; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-60702d77c60so877222a12.3
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 06:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750772357; x=1751377157; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dtmZfbvCItCFme/rtUJPCdctxkHEaHPnKauFh33zosk=;
        b=jTOsLQdaEHwYyQxnNmgUfq3pQ/INWS6JhW4neR0DMtx9Z0XSLlJ9ruwLqvfrXZgfoe
         ov7o6EMtC8tXqsLFNd991Ub192WRSLT7k1W/Q4iDcDyxgb/Q9KOEBecKsKt5M1M0kB6F
         btmUa397GzPdHHWuiEQSdVTIhFBPAJpbXEXPJnoZa3CrbhTXrmuzDi/jYOVq2Fq3tuLr
         D7JKqwMbfMY6lwFT6H/uZRu7pCDMu/lxL/OTfbbhAaz+Q/HGRNCMATWWWWeZQ+RmecYp
         m9XvyiggOkTi/ugW3X7CKqQ9QvHGG4AR9Ocf+csxAj6qIf9wBLkFK6Xs8D80NVS6rsOa
         yp5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750772357; x=1751377157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dtmZfbvCItCFme/rtUJPCdctxkHEaHPnKauFh33zosk=;
        b=lPZPdFLIVai/qc+TFSkiNewKL/bat3rTaygyI4VFky31sFC3pIYjNBVj249ZKdx1jA
         71xMp/ziqY0uZ9BPLMqq3cfOL9M/dWIy3Buo0ubxf9EbPsiPpNpFa4wXQ6tLTHkfAEUr
         NCNBbbt4QeqY+Yx6Wz7B8bNgNvrbqffMlwxD4WlWkXQj3e4qajayb/Dgf2zdmr53oSkU
         kHHCDYTG2eN1MnR5yFIq9cNm0SzbVbbeVRszEZqlYUHWiG6uPsL3pFBFwt0HOyzDSJgg
         tqkwQGGnlYZv4PiHKBtZRvpEgJQRy+XlXOdh8HN48Xiktqw3VDu6m5sny4siFtR0uNo+
         mKgQ==
X-Gm-Message-State: AOJu0Yw/hqd/A67/W3pnH5nctdh4o9cf3wLWco9ttTlvgln2TJR8pL9z
	Y+Z0HjCqZTnThYRP+bR6SgreLNdFF65mv4FNauHPvSyA328onM6ZJfi6r4/Opg==
X-Gm-Gg: ASbGncsESSkB1coL3Uow+RJHNOhM9AdFquRYB2NCGz6BsbsVEaTionv2IZBAsZqGnYO
	uQZjL0b2FHT4aOhD0ZgKZ6UKMRt7w2uNryhtOnDaPcrJdE0QiYJPjDjOe4vPFgaxbTdTKmA4bnJ
	he7YnABedy0CdItG5qce2xteg6M3XnUy1Ns5EoAu5mMG4am9UB7XoTLqNZcZk7E1xipb+JejM+F
	2zZZO4zuec9PvpVHrRsDM8MT5ve+j9xoMebWhpZbE3iSWg7YleVoPoO/UfBOkLpvArq4/kNgtFq
	YERI9LJGYtDnBLLreAdfE9+XbTx1UhuRyV6OEmK6wppcGg==
X-Google-Smtp-Source: AGHT+IFjwD0GGtgPYjgy0kfSCsluef2MTsDD7WmnWKyJJPdFNvdKk0rJKqx7JqbKMZdBYdipiREpAw==
X-Received: by 2002:a05:6402:3592:b0:60c:43d9:d075 with SMTP id 4fb4d7f45d1cf-60c43d9d44fmr236158a12.13.1750772356694;
        Tue, 24 Jun 2025 06:39:16 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:112b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60c2f196e13sm1052892a12.11.2025.06.24.06.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:39:16 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 1/3] io_uring/rsrc: fix folio unpinning
Date: Tue, 24 Jun 2025 14:40:33 +0100
Message-ID: <a28b0f87339ac2acf14a645dad1e95bbcbf18acd.1750771718.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750771718.git.asml.silence@gmail.com>
References: <cover.1750771718.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[  108.070381][   T14] kernel BUG at mm/gup.c:71!
[  108.070502][   T14] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
[  108.123672][   T14] Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20250221-8.fc42 02/21/2025
[  108.127458][   T14] Workqueue: iou_exit io_ring_exit_work
[  108.174205][   T14] Call trace:
[  108.175649][   T14]  sanity_check_pinned_pages+0x7cc/0x7d0 (P)
[  108.178138][   T14]  unpin_user_page+0x80/0x10c
[  108.180189][   T14]  io_release_ubuf+0x84/0xf8
[  108.182196][   T14]  io_free_rsrc_node+0x250/0x57c
[  108.184345][   T14]  io_rsrc_data_free+0x148/0x298
[  108.186493][   T14]  io_sqe_buffers_unregister+0x84/0xa0
[  108.188991][   T14]  io_ring_ctx_free+0x48/0x480
[  108.191057][   T14]  io_ring_exit_work+0x764/0x7d8
[  108.193207][   T14]  process_one_work+0x7e8/0x155c
[  108.195431][   T14]  worker_thread+0x958/0xed8
[  108.197561][   T14]  kthread+0x5fc/0x75c
[  108.199362][   T14]  ret_from_fork+0x10/0x20

We can pin a tail page of a folio, but then io_uring will try to unpin
the the head page of the folio. While it should be fine in terms of
keeping the page actually alive, but mm folks say it's wrong and
triggers a debug warning. Use unpin_user_folio() instead of
unpin_user_page*.

Cc: stable@vger.kernel.org
Debugged-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+1d335893772467199ab6@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/683f1551.050a0220.55ceb.0017.GAE@google.com
Fixes: a8edbb424b139 ("io_uring/rsrc: enable multi-hugepage buffer coalescing")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index c592ceace97d..e83a294c718b 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -112,8 +112,11 @@ static void io_release_ubuf(void *priv)
 	struct io_mapped_ubuf *imu = priv;
 	unsigned int i;
 
-	for (i = 0; i < imu->nr_bvecs; i++)
-		unpin_user_page(imu->bvec[i].bv_page);
+	for (i = 0; i < imu->nr_bvecs; i++) {
+		struct folio *folio = page_folio(imu->bvec[i].bv_page);
+
+		unpin_user_folio(folio, 1);
+	}
 }
 
 static struct io_mapped_ubuf *io_alloc_imu(struct io_ring_ctx *ctx,
@@ -810,7 +813,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	imu->nr_bvecs = nr_pages;
 	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
 	if (ret) {
-		unpin_user_pages(pages, nr_pages);
+		for (i = 0; i < nr_pages; i++)
+			unpin_user_folio(page_folio(pages[i]), 1);
 		goto done;
 	}
 
-- 
2.49.0


