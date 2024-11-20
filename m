Return-Path: <io-uring+bounces-4891-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D489D4485
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:33:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49CEE1F2228D
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1DF189521;
	Wed, 20 Nov 2024 23:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="moZgZTU9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0587A1C1F12
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145592; cv=none; b=i7cQThuxJFQwT/hdXgUILgt2VwR0KEjUD+rxreOx6WOq67c/o7CatBpEYc7DQZKnKLbPg5CLv1E+s0GMWm9bXtZ2AHN32h/L751OGAkFZ/hd4urWwSGoSWRZBkC7gibHNlgO9/UYQo4HHowJq5tAh6OPaNdYpKjjPS3Ea8hgCJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145592; c=relaxed/simple;
	bh=1gdiLeCNSwVhK3nzWHMR4xFD8ClHJFNdvlyHODABro0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IixObkvaf8dz9XopKtF34LtVWpZpvA3m0fPkiSesjVeHd7iqPu+uHoXUKhVUx+aVY63er18NZW2EcT6HusHxhDq5eEftUNfz1eahIFijwDARFAT0+rHUCqQpH8NUcosWs2X5yvYhMqs7dHKeW2B2Wx7D4fOkeRuH6xsvUoqBJ1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=moZgZTU9; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9aa8895facso51524066b.2
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732145589; x=1732750389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=usEgNxoUAlzm7LvnyJowdrWjygvIn9+DGkjQ7Uu9NSo=;
        b=moZgZTU9sxZD//zIyJ55/YNE7uAHYiXLdZOC/lrcyOSOdc1JTmLaBqrSLxTDV2Adb4
         NAj9JzmxhBra4cJoL5wCsASvneufzhT7IbXTI2ERxCDt4c37Az6CWT99gFDkgTybnwQy
         ZiUbWRUnRd1AF4XA1rPa4YQM2U/4sPKB5l/GdRcHSmUc2N0VH9OLaL7zRccS31elyUDt
         3EsHk1YF4Bw2gmkgJmW7dBcduNbnOaYd7hb4IvM2/bxwst7xEVnhy/UzXXOmsnxz44Op
         8G01OLcARPW7pvMOZ4+VYohEyRjDGG33ILxSN8bKw//puzD8iSiFOLp4To8mQvD0cblh
         Jotg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732145589; x=1732750389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=usEgNxoUAlzm7LvnyJowdrWjygvIn9+DGkjQ7Uu9NSo=;
        b=fWS8AcSqtcu0W+BbqpoA98S0b+IhSQuUHqeAc9HofgjgiYq3q6thSzSbRIP101UsOV
         xmEPLXqjJtpIBrJbhN5n8ihmjFunMkVMlNaZaE74uMavmHdoPK7k2WCt6aiow78oBJH2
         mmlmnU/nq6q0XWPgRUFolxBMjJYVGkU7Oj8+v9ocFap/xmE4/Yn0ujf29Vhal6gfSaR5
         VsN94iMJDwNimub9PAK6+DpVU0qnv3JP1vcchgK2DEZkTiqGuJNFBrEea4dQb+ZUDIj3
         0cwifcpYI92JCnv9Bx8DQSTu65vYoAtHCvJR53pPrpld9XPCuuw3lOxf26x3rZ7AdESi
         3Mhg==
X-Gm-Message-State: AOJu0Yw0QaiR4VxpInMQIFU7EDG4De5kMMiktPEMsHJzeix085/4C17g
	O4nFZ50p5fHdQmLgP9FPqpDFl4M9YvmA+R7lXnhWsn7Y8iwItBeRq7hWjw==
X-Gm-Gg: ASbGncu9NdwL5lUn6ES/nH8xWXHtO4Lo2lbvr8S6JDI7a+yq0ITymnOWh7HG5Q7ARzu
	8yXYEWcRJ/oQV9Wo3GAX2zi14iBfK7MsRG/a2ghT3Kkpd6YH6gZMMFaFKHJy+qBuYKIBoNNtRwL
	U+HFax0slBajgaiY8+BQlvLK3a8jhX7OrVPCBXUqx9qOBG76VmfpSxeH9QFH/xDz8hLs8lDCU0S
	0IiT+URVwJ9z1cfiozL+IAvzZ8XSg/uf+VxMFC00SGTC+Kl6M5PV1CASrFcAWhT
X-Google-Smtp-Source: AGHT+IECLULtaQx4yVcVrZwGwqgVD+QoYNTQm7pgrSh+VWpVMZZXO//20z6LIYoQgZKa/d1KB8xGMw==
X-Received: by 2002:a17:907:6eab:b0:a9a:7f92:782 with SMTP id a640c23a62f3a-aa4dd74b2eemr476852066b.52.1732145588951;
        Wed, 20 Nov 2024 15:33:08 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f415372bsm12166066b.13.2024.11.20.15.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 15:33:08 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 04/11] io_uring/memmap: flag regions with user pages
Date: Wed, 20 Nov 2024 23:33:27 +0000
Message-ID: <0ff910962678b2b4d896d59f592d89181309e1b8.1732144783.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1732144783.git.asml.silence@gmail.com>
References: <cover.1732144783.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation to kernel allocated regions add a flag telling if
the region contains user pinned pages or not.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 21353ea09b39..f76bee5a861a 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -197,12 +197,16 @@ void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 
 enum {
 	IO_REGION_F_VMAP			= 1,
+	IO_REGION_F_USER_PINNED			= 2,
 };
 
 void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
 {
 	if (mr->pages) {
-		unpin_user_pages(mr->pages, mr->nr_pages);
+		if (mr->flags & IO_REGION_F_USER_PINNED)
+			unpin_user_pages(mr->pages, mr->nr_pages);
+		else
+			release_pages(mr->pages, mr->nr_pages);
 		kvfree(mr->pages);
 	}
 	if ((mr->flags & IO_REGION_F_VMAP) && mr->ptr)
@@ -259,7 +263,7 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	mr->pages = pages;
 	mr->ptr = vptr;
 	mr->nr_pages = nr_pages;
-	mr->flags |= IO_REGION_F_VMAP;
+	mr->flags |= IO_REGION_F_VMAP | IO_REGION_F_USER_PINNED;
 	return 0;
 out_free:
 	if (pages_accounted)
-- 
2.46.0


