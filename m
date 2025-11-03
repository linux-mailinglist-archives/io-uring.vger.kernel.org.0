Return-Path: <io-uring+bounces-10348-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C8A09C2E705
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 00:42:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3D2D234540E
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 23:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77DEA238C1B;
	Mon,  3 Nov 2025 23:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="fS0dqLql"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99886312811
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 23:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762213287; cv=none; b=CY3wiUHXEFaa5qiWMX5IvcBzfjPhTASJBP8mh6IuGJ0TOmrGsEfGFQ4urLF+z6ff4TDMu77m1ed2OSHKEnsj3HRuxaTsiBAAkdXF0Sxl6Nfn2KBb/HofPRki2HjJqxnVP4bcrA/D918qhCl5rmDtS3owd1R+wkJ15Wtsi33B8PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762213287; c=relaxed/simple;
	bh=P+5GnNMT90O6UeRe6i0ljyQYv36MaDXJxMkhwF7LEZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqBGvDpV3DtCDpFsPXH5MqB0e9CVDih+M0I4wprvdu42ljkioMgAep1SmsOeH0sT4TN+VuAo+YawUav6hDIqNkBONlCMkTRIugFZsKVoAold2P/CjjCpioSTGvGpSvo0xWnSrDeRjlDrMkUlyb0XQsDPkRWhicV23rd+iXmjNj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=fS0dqLql; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-654f151d223so2659063eaf.2
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 15:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762213285; x=1762818085; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q40vB7kCqmdilUB0dvDzCxv6iw86KfavrfdQYR4MxNI=;
        b=fS0dqLql0z7/VZzPKps1YTu3Ns26r6OdCfQabbAqyuy83DB8Q8ZTzWtL1BVMco/Djp
         LZhOt7NWIzii6ScXuc9yzMc2+r4O30bCxmNPj0m7wSV+28BfVigaOmnMyT/qDi7f6vW9
         FlibMu6rmRx3TI6zjx2dHuaM2rXpVpEmKoPYJkBouxPnabbQ5dVyjlBRRYyUOoG7WFhS
         S5Pje5S9MJhidWGebuH0JUEgNaFswgIuKM5hSvsXjIuaCM6JCaXn/93m3pdeIO0OYlHe
         rC9ltyoLNzSGAblcfjrwGedkR99akR+h4FBUaSIpQ+0P5suoKj3B2JeSO/hPegns++KX
         qgoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762213285; x=1762818085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q40vB7kCqmdilUB0dvDzCxv6iw86KfavrfdQYR4MxNI=;
        b=icqarBZQn5FghC0VgfmhDAPRmQCu/ogEZxA0reNYcKDwxxyV6Z4uOoMylAHnuu5bHp
         kQcOog2Roe5zL2GtViXnTr5InMnRpyILJH0Zka5sPJLfA0wyoQS9KFbOXhikhBxe75lm
         ivjlgZhgxxSV/xQU6fR9P4LcwD36m3QQHyfXkNZjODpwINusRola+gR0Pb05Ni61kohN
         1zkLT9yXbWqMtJ+OYMCgjXdV5UW9twP4usdW9+r0sTkmbslXosoyFKv8dIjMHLSGx7Cq
         T/K4t8gr3tT7Knc09Tg3wMsuJymMpz/TLQWC6+V2YImrmFbTCq59EEDprW4NIsI45Oc4
         dKtQ==
X-Gm-Message-State: AOJu0YyNZOUQ8D8MxVxMW5kZicQVCZ8r2Mt+SrME9N/4yzL9Ijpe2jfZ
	SNKNPz87trldHUZkdJGI7Q1REpxVoc1NpIEj6/iRgqJ5sHeOgurGFmGY+qHObJ8xG2G3BImOMdP
	p/K8O
X-Gm-Gg: ASbGncvQbCeGkPUZ//Qysf9sXV/b4eWg1KvyJnKlmPSFL1nORStjFnCsd3z5IMaZi4H
	Z2s/4B18Kn5bCWMlJv9NBzXlJziRmEQyIncXIFiGioUWh5tfskKnOOitnbcrYR+gWYl7rVW9bwy
	gUgtJH8T60O9mA8C0CtmUH8Tc7qytaRrAvwe0vzrFpxeX5eMszXZl2moGPkBx0UWvG98ugpyYcw
	sTESP85Gg7tnlsdE21c+QQKYdLy1CHWsHxzFLgJu5WkPGNw45vcBBJ050kJ4o2/y/48mf+vUnkq
	ej4gPDxDE+hVTttcyYNMjUSd+wVtuz21QdEXr17l6qcqY80I74cNTCr9xIDn46reOmcgT7WmK7V
	XKmLZrzYFSreTOqlyyrdHReSFc97ihGF2u/bfvGEJTQzg9/tFg9dKAzjH6H97RFdOTHOTLdOvep
	rhQ/7JKer4UJo80dk9Xw==
X-Google-Smtp-Source: AGHT+IG0BMLhsVTBv+cN/07Os4rshmF+lhWl4UgqLIf1FGZ0EbG7qnPbFzUIu0wfvFoZ6qBCb7Vobg==
X-Received: by 2002:a05:6820:22a5:b0:654:f9a7:76dc with SMTP id 006d021491bc7-6568a6c89b0mr6426854eaf.4.1762213284849;
        Mon, 03 Nov 2025 15:41:24 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:8::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-656ad292d31sm468988eaf.8.2025.11.03.15.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 15:41:24 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 05/12] io_uring/rsrc: refactor io_{un}account_mem() to take {user,mm}_struct param
Date: Mon,  3 Nov 2025 15:41:03 -0800
Message-ID: <20251103234110.127790-6-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251103234110.127790-1-dw@davidwei.uk>
References: <20251103234110.127790-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor io_{un}account_mem() to take user_struct and mm_struct
directly, instead of accessing it from the ring ctx.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/rsrc.c | 26 ++++++++++++++------------
 io_uring/rsrc.h |  6 ++++--
 io_uring/zcrx.c |  5 +++--
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d787c16dc1c3..59135fe84082 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -56,27 +56,29 @@ int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 	return 0;
 }
 
-void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
+void io_unaccount_mem(struct user_struct *user, struct mm_struct *mm_account,
+		      unsigned long nr_pages)
 {
-	if (ctx->user)
-		__io_unaccount_mem(ctx->user, nr_pages);
+	if (user)
+		__io_unaccount_mem(user, nr_pages);
 
-	if (ctx->mm_account)
-		atomic64_sub(nr_pages, &ctx->mm_account->pinned_vm);
+	if (mm_account)
+		atomic64_sub(nr_pages, &mm_account->pinned_vm);
 }
 
-int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
+int io_account_mem(struct user_struct *user, struct mm_struct *mm_account,
+		   unsigned long nr_pages)
 {
 	int ret;
 
-	if (ctx->user) {
-		ret = __io_account_mem(ctx->user, nr_pages);
+	if (user) {
+		ret = __io_account_mem(user, nr_pages);
 		if (ret)
 			return ret;
 	}
 
-	if (ctx->mm_account)
-		atomic64_add(nr_pages, &ctx->mm_account->pinned_vm);
+	if (mm_account)
+		atomic64_add(nr_pages, &mm_account->pinned_vm);
 
 	return 0;
 }
@@ -145,7 +147,7 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 	}
 
 	if (imu->acct_pages)
-		io_unaccount_mem(ctx, imu->acct_pages);
+		io_unaccount_mem(ctx->user, ctx->mm_account, imu->acct_pages);
 	imu->release(imu->priv);
 	io_free_imu(ctx, imu);
 }
@@ -684,7 +686,7 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 	if (!imu->acct_pages)
 		return 0;
 
-	ret = io_account_mem(ctx, imu->acct_pages);
+	ret = io_account_mem(ctx->user, ctx->mm_account, imu->acct_pages);
 	if (ret)
 		imu->acct_pages = 0;
 	return ret;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index a3ca6ba66596..d603f6a47f5e 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -120,8 +120,10 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags);
 int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages);
-int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages);
-void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages);
+int io_account_mem(struct user_struct *user, struct mm_struct *mm_account,
+		   unsigned long nr_pages);
+void io_unaccount_mem(struct user_struct *user, struct mm_struct *mm_account,
+		      unsigned long nr_pages);
 
 static inline void __io_unaccount_mem(struct user_struct *user,
 				      unsigned long nr_pages)
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index ec0a76b4f199..ac9abfd54799 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -200,7 +200,7 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 	}
 
 	mem->account_pages = io_count_account_pages(pages, nr_pages);
-	ret = io_account_mem(ifq->ctx, mem->account_pages);
+	ret = io_account_mem(ifq->ctx->user, ifq->ctx->mm_account, mem->account_pages);
 	if (ret < 0)
 		mem->account_pages = 0;
 
@@ -389,7 +389,8 @@ static void io_zcrx_free_area(struct io_zcrx_area *area)
 	io_release_area_mem(&area->mem);
 
 	if (area->mem.account_pages)
-		io_unaccount_mem(area->ifq->ctx, area->mem.account_pages);
+		io_unaccount_mem(area->ifq->ctx->user, area->ifq->ctx->mm_account,
+				 area->mem.account_pages);
 
 	kvfree(area->freelist);
 	kvfree(area->nia.niovs);
-- 
2.47.3


