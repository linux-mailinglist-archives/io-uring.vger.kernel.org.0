Return-Path: <io-uring+bounces-10269-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC96BC164FF
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 18:52:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F91E404DAA
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 17:47:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6C7A34DB67;
	Tue, 28 Oct 2025 17:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="HJ/m2lQV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231A034CFB9
	for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 17:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761673606; cv=none; b=hCJsNTFpMSBOPMF8niIiuybrkiAHNAhl6vlFERMXLgIIokUtphJIOYFtSTT2j5hqZBi6xvKVU51J6tPzJgIrntqjsGoakEWKcU6cGN9jcenknxoLv+fnELLDNUXNkypzXOeX88y180RTu1R7GXu5V6KDELr5kVMP9ZQw3qmoR5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761673606; c=relaxed/simple;
	bh=yC5dgrKNYULbqJexR4PKQGtUHhJ4sTzYDh5lsrc8wVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8OP4BG/dTi9qw2RYPddX9Utgpc4l24+P4ozp4BXxzCbuDUltoPQtr8TchPDgJGLQX+anzGDcAW8RtDKN9jWfmaz36jPLzoVKlQ9HJOoWiL858gexDsd8yqWhQILuBS1lLUtGhXsIiUevVseoEuU0VrEcIjxVmyCAacbCaB5IsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=HJ/m2lQV; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7c281c649ccso4286300a34.2
        for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 10:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761673604; x=1762278404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zA+MIvsz3oHo5qpD2FIHZUBV7OZPnR+HBMVbUSiqp/s=;
        b=HJ/m2lQV76mRPpRKx7YiuQ2rD6b14jQX5+n75WOPmwXHkdY/HlAw6bI5ZaV9lG1snV
         G2pOW/byxxR3qBuqvkNePDRM5rqcOCqR0RMTHQWZFtPU7Sj9pAKUn7Ea8w68YPADorrF
         yR85b89Sbo9kbUNhzizPIzKcNZ0iTk5P+BAu5ZycXGNKuZVICIcn8qE4/A+2ny4AKgZV
         Fv9YBd6adhF83AmNPmlkzRGPtABjldAjzFW0+AaT1wJHU02Pef5RlSv/JJpe36x18B3v
         8zRJiz1SutGr2utaiUisCx+e9G3ggeQitM9Tjka/jLMyXvjjtVttw8ZgUYESyPh/Oo1a
         /tjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761673604; x=1762278404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zA+MIvsz3oHo5qpD2FIHZUBV7OZPnR+HBMVbUSiqp/s=;
        b=deWmaxLbDKypOUGQMtA1jTAT3HdlaBGoGtOGJoyFn9mPVPIjfZ0RUApOznhJ+s7orJ
         R+g7M2pZChLZbj/R/xqiQWvaGfFswGZ/VuwfXmx+JsrPPYRhVtK1xxad18eNrFsK1IRy
         vZoQ60OqfiWWuW3N/Zd+ZU2UOuEtpmO4Ver0vFeiDk81mQnnRqdIv0LYGyg7PQ/9VNze
         3hQvBVi6YZLi6UDw/NpPQtQfqNoEZbFDwuWzkrnyk1XsE2yvr8abeFIR/q4ynMc832Qt
         EQaXdYXE8sIE5t95bOSCIf4PM2Zk5vSSEoO5h+CDL3fEGt7brK+gb1Crm/YE1RnSLCN2
         pwbA==
X-Gm-Message-State: AOJu0Yzmx2Q1OoAD68kdadnDMfrpjJ0KVmg2okq+W1gF/Ohd5WvUYlUN
	w4G/Uf6kLav9Gn72A941C7KOgp2FMc0JwCUju1WUuhQ+MyLnz/qRdGCrc+or0vbu6BcYVeZXJgp
	mWt45
X-Gm-Gg: ASbGncsREBRchNOBHqVFyWxYc96e1y3/0OUrvn23QDTELFuKuv6C7+k8nwzb8jZM9Tr
	vIf9Cmub+E0j7SUJjkDijaf9Q9ZdIBFHJ97czNykJn3/hCO88ks/l/uYxvoMflrxoe/fRZfCGG9
	Qe3OXhyic618A75OCKEUDx9VIKj5sZ/qzpHd9R3l8ssFS9ctrehXK+EfwoNNkcnQqcnnYFk+Coh
	y0IO1ATYGgZ94wcT325hcMbRL1YTa7+lX1ArLfqDZpJ35CVpu/zuYCS28rewhzZyhV5SOq4QuIF
	th2L7pTazAtz84Fn2A98XzfI4BgnJZpX232hmOCO6Z9EUq5KbBpIFXHNPSPRPxgHJQC5T37DCUQ
	71RWAlEYVLj5Uia31glSuE21q2am14QTih4tfS/SSdtUxbHHVxCbhenDifSQ33Fd9j3nbwYqA9O
	riAtM1JJg8y0lpdMhK3g==
X-Google-Smtp-Source: AGHT+IHBB1olE0TwRbr57hCOWNNnA0QEhGS7G614Y7HS+DB8rZNvLWzbSslYwLX20yzwjW3+PyldXg==
X-Received: by 2002:a05:6830:dca:b0:79a:36bb:1086 with SMTP id 46e09a7af769-7c6830cec49mr121386a34.22.1761673604266;
        Tue, 28 Oct 2025 10:46:44 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:2::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c5301e32fesm3356589a34.16.2025.10.28.10.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 10:46:44 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 3/8] io_uring/rsrc: refactor io_{un}account_mem() to take {user,mm}_struct param
Date: Tue, 28 Oct 2025 10:46:34 -0700
Message-ID: <20251028174639.1244592-4-dw@davidwei.uk>
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
index d15453884004..30d3a7b3c407 100644
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


