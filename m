Return-Path: <io-uring+bounces-3249-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC52397DC0E
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 10:03:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70EF11F21B07
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 08:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A6A05FEE4;
	Sat, 21 Sep 2024 08:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uqPdCjKh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A260C14D6F7
	for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 08:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726905807; cv=none; b=UevNZ1ewuouNgCLTX/gHiPLCnOt+GVvI5MT8EAa5IKrxATnT8DkPdyRifJbd0T0Mxp5c4UwlSMtj4xl8EhUW4zyoMT4xSwBbU9dP0Zn9vG/Dw6h5qNNsOYOMuSixddZhD8JtHfeRoOkCdthe46XXlcryixPO/ajEqS6zNq1o6Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726905807; c=relaxed/simple;
	bh=8kpVYAu/rfjpcg1zaI6yoQAGGLSuu+Z19WdJKOJ6tSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzv/9DXRFB3j4vxvPtLRY7RTHoVpPSJjDCLAaxP6SeqsChIEwL3TagGptiJP6kECW2l9brBs+1gmr49vnEm5HQqK9Sttfl1A0iX/rLyrhtNKnhabaRjJI1rewCugOD6GLTzT2DhtvebmC27YHWMPkRHXoW/3eeVDAS/HuhS8K68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uqPdCjKh; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a8d6d0fe021so389398266b.1
        for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 01:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726905803; x=1727510603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4crEGMlbWLkjKo7VKVg8cTe/h5B6C2vYnkowsodrkr8=;
        b=uqPdCjKhVH2YaJKS72hp4wFuOt5Hr0poQaw5n1HiDuUc5Mwf1q7/GxQwZpRUZ6+79J
         HqKd/SoJehzy2FydPdp/s4Oxx3WBe1R7JeUiEggxWhcOCcr6hgVMJcLtc8BGlNk3z1xy
         l2wI8oqQCJ8hoaUFDhGSkjkziyzYXQfKgc9cfNdVnJi12lZzxYggMBSJv1X726j++F4V
         AtOAwUTZYu8QHIEycQZ3sdBgIooVD6X83EQbt6uj2AxyMAGK07XDNLZWYk531kMmG3hf
         bmsGhoJUClQBinJwKQhsPBnYTC0YwrvYdu83sMOl7GG2l5UotmFUlCnHl9L2GZ3p1bP+
         KOhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726905803; x=1727510603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4crEGMlbWLkjKo7VKVg8cTe/h5B6C2vYnkowsodrkr8=;
        b=pYjH3dp7OKr0rIQ8SUwiCrwjA0Dv9yaxkTUyGKDmtMsFIPKuUjL9p0iU/XYJtdoz+E
         PYFFkzctWY4EushmQbQ8OfKhhylK1oDzmsmoX0d8CrRAWUC0SljO6cWCpdGJnJOt56RL
         xU0F9MpaVkKJtbqxTev+tI1G/zDrXN5mE+alROvjn7rsVf5o6q6Dw2sUmGsGXzQgIX0B
         wk4Y7ncYaTvCzo9gXlPsKByQCP3Kg+G7jHHOidibV8wiUtSNdvbIsr4uAoBfwBytidH5
         sIWEYG07JSObBPfXIFOYnMyaNG0aHPk+ne8T7CyNaXupevpkb2DVRm30RWIFT12GUgS4
         nkrA==
X-Gm-Message-State: AOJu0Yw4QH8NzM6mZzvaNsC960LeF4YlFlXaqaDuIe1lad1tPeaoLR9I
	Av2sNWBbL9kvxImEtdAfIT/TAJ9FMwHY2Bq6jejltvtX5/UKzonCNDAJ8OcwXvzl9P739TIlmXE
	SJRzirMui
X-Google-Smtp-Source: AGHT+IGNvrHuDYIPePwM2mqWfjCVNGOY3bEcx2+vSs7pZeG9YJU1zgaEahVMkSnoeloXEvBakvU6cg==
X-Received: by 2002:a17:907:f721:b0:a8d:51a7:d5e8 with SMTP id a640c23a62f3a-a90d4ffd5d3mr488398766b.15.1726905802688;
        Sat, 21 Sep 2024 01:03:22 -0700 (PDT)
Received: from localhost.localdomain (cpe.ge-7-3-6-100.bynqe11.dk.customer.tdc.net. [83.91.95.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90612df51asm964583666b.148.2024.09.21.01.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 01:03:21 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io_uring/eventfd: move actual signaling part into separate helper
Date: Sat, 21 Sep 2024 01:59:49 -0600
Message-ID: <20240921080307.185186-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240921080307.185186-1-axboe@kernel.dk>
References: <20240921080307.185186-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for using this from multiple spots, move the signaling
into a helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/eventfd.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index 829873806f9f..58e76f4d1e00 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -47,6 +47,22 @@ static void io_eventfd_put(struct io_ev_fd *ev_fd)
 		call_rcu(&ev_fd->rcu, io_eventfd_free);
 }
 
+/*
+ * Returns true if the caller should put the ev_fd reference, false if not.
+ */
+static bool __io_eventfd_signal(struct io_ev_fd *ev_fd)
+{
+	if (eventfd_signal_allowed()) {
+		eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
+		return true;
+	}
+	if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops)) {
+		call_rcu_hurry(&ev_fd->rcu, io_eventfd_do_signal);
+		return false;
+	}
+	return true;
+}
+
 void io_eventfd_signal(struct io_ring_ctx *ctx)
 {
 	struct io_ev_fd *ev_fd = NULL;
@@ -73,16 +89,8 @@ void io_eventfd_signal(struct io_ring_ctx *ctx)
 		return;
 	if (!refcount_inc_not_zero(&ev_fd->refs))
 		return;
-
-	if (likely(eventfd_signal_allowed())) {
-		eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
-	} else {
-		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops)) {
-			call_rcu_hurry(&ev_fd->rcu, io_eventfd_do_signal);
-			return;
-		}
-	}
-	io_eventfd_put(ev_fd);
+	if (__io_eventfd_signal(ev_fd))
+		io_eventfd_put(ev_fd);
 }
 
 void io_eventfd_flush_signal(struct io_ring_ctx *ctx)
-- 
2.45.2


