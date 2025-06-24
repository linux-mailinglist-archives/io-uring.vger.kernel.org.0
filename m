Return-Path: <io-uring+bounces-8461-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4FC6AE6287
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 12:34:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D08C44060AA
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 10:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE1E81E22E6;
	Tue, 24 Jun 2025 10:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="To96xGNh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213BF25C821
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 10:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750761249; cv=none; b=ktge3YKpbuocBZr5x9tS0UNxWa2ir0EygvnqPRmxyUB6DwqORLgh2rSL6ohovRLAaK22z0gWJm9OsPfkJbOuCAlna6X69ZWw+UgoYbgYAn3XJTsGack4LDo41aAStrkBFYKvpdL0jUD6cZytridkFVyMnvYrgfCkBcMV6xW1He8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750761249; c=relaxed/simple;
	bh=u9+mXJdhRRyVKIBtUBmZtQGAzmaFnHu95mj6c6mVBWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e29v55lrBDbcn/JNOznPr3mauywjyxwrtMsVb+UnLnRqS/Cp8fs67AVqfLYrb0+eJpThMc/Aq+vzpylj4vMF8LHtKDcT2OEHPeX/SQ4N4MSeAbMCV4uG6r+AHKj5oc8ko9Klfa7DWypUEL4zSgqW9MAx8OMw6/f9p645AtBITq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=To96xGNh; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-60707b740a6so7868571a12.0
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 03:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750761246; x=1751366046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fOVM3FyYnoQQic4PIOdrS1yDk5bWQTFh95+ffWjGvA=;
        b=To96xGNhJLgpoZaj/XNYBSsjQUKH+u5SnMgfYu/idTZKhPa+H9ipnn6SpRzXvAc7CR
         WLiRnQRZGBJY/SaW8dg4auysBqPP1qU9eKbAFuNASIOl9coHx1lUGpb43QLXRNLkSzX+
         lt1PecKjtzS5QQkgKAbBV4LfPcgrB2BMKR9lnB9GmdLAaMFVwH2xOdDo+1YrHpUs1AVa
         l/1oZQHzrl1ZLjBtlC0YLWM/vku3jOpDGsmIL1yIevNc4LN671i6wHK1KRkTSYKjbX4y
         EcGEqh/cFQqIMLgO1JTsAz5bzjIlNTEg8otx3fECBECtAo09RHDAK//KDoc6urzVl5ZS
         pTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750761246; x=1751366046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6fOVM3FyYnoQQic4PIOdrS1yDk5bWQTFh95+ffWjGvA=;
        b=vnQs6Sd3dboC7flRocQzGtg031HPwvUNLVwXvrCu7Q5BumhbWOa2VxV71AdVtatRrl
         lMDRzZScGTBs3hlFIheXiP0XarIwzakw+U0BDUeZ0Qf/EHRixL+m450CurFW9dX5FaxC
         vqelo23VfobrdEjj11k8S8v94pgvh/0A12bGzZN/sh1aZ9DDWUMkSSM8jMvCAON2FYLR
         wkRDxGz8FCMNXYs6bLuPMzXXdoTvw9zpxeIqsmhJj7B8aVIwQQGSH0pNbjiKBwULWlTc
         JK25ioRZEOH/IX+or7Ok9X/5twzGrC0ktKefcdWbaYURuu1QJsFNc+fy/fRNJbkSgNN5
         Sbfw==
X-Gm-Message-State: AOJu0Yxk0sWteVXQQp6tVsT/aX1o665UHKWMn2YCw1J1ZonhKMSnYQwF
	WGz47TfQaRG8TV41VpYsPvR9rIPseIcVeT1Sr12Bp9GSnG9yvWtSJeX6DySnKA==
X-Gm-Gg: ASbGnctckPTTRwgA9PSpPIVMpJ3st3/wZh1bjo7xfCok9NEdy8y3mvERQma7CWx9G2K
	6Dhh/xSDn5IIgzgxViQkkfQKvxctzjp+w9YxoVZvCEeWrNoNj/BWc3RWMdAaWZDv5+1t47eMxZ5
	g2GcRInBaybOiwXx97Cf+9A1WivvOzpJUSTeWjiiNy4wlIuJ6Bbsy+mVZwqzp7e+/vmT4rjzlQk
	xJpJHmit8wxj5objE/9ZA8gp0VBGBG/iEXNLlGGpluoD1wz/W1UQM0HcMP5rYZ3fXZEyd1/GSVJ
	tesnmfi/dHfWhWd7cXs513vtG8UEXUq8sRl4jH7hXs53SQ==
X-Google-Smtp-Source: AGHT+IHkJhYOye+80EYUeneVCBxmDhFkf9QK+V+gbSUKahLR/+VGCM46RWKa4kH8BQ/cBFKlkswMSg==
X-Received: by 2002:a05:6402:254f:b0:604:e6fb:e2e1 with SMTP id 4fb4d7f45d1cf-60a1d1a4b54mr15416917a12.33.1750761245818;
        Tue, 24 Jun 2025 03:34:05 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:112b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60c3c213b1dsm320999a12.54.2025.06.24.03.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 03:34:04 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v1 1/3] io_uring/rsrc: fix folio unpinning
Date: Tue, 24 Jun 2025 11:35:19 +0100
Message-ID: <380d4fed5a9c49448f7ae030c54a6c0c5ec514c0.1750760501.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750760501.git.asml.silence@gmail.com>
References: <cover.1750760501.git.asml.silence@gmail.com>
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
Reported-by: David Hildenbrand <david@redhat.com>
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


