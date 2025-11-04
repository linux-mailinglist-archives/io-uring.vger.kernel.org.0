Return-Path: <io-uring+bounces-10372-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F3D5AC334C4
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 23:47:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2A4D74F458C
	for <lists+io-uring@lfdr.de>; Tue,  4 Nov 2025 22:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D6A92877C3;
	Tue,  4 Nov 2025 22:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="FCUUMxap"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94240315D30
	for <io-uring@vger.kernel.org>; Tue,  4 Nov 2025 22:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762296308; cv=none; b=Ro2R4PQkpjrsfZkEOHyfDJ0N19saQqG5uTqrsAe4zW6g/YwJVMmvnlnGscuJFI80EGauoDQ+z1wwRfoarcF5iflmiWDLiAC+qRsAD+/HzXj2zfQWZ4u4K//v1BPozG/RMDyqfKYqsZcHYCxEYxjSSSEpTPjmmWN8OeU4ITLD/PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762296308; c=relaxed/simple;
	bh=yC5dgrKNYULbqJexR4PKQGtUHhJ4sTzYDh5lsrc8wVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMLV6Pll+D/v7mmOi1gloEd+2qkUzaZl1aLfSMTFxlzcENg9rXMiYFKfg/ecXRnOMSpgex9H4AtILUsGPYdFQ1s3ta3gXuLmChSJesYiA2ZrDABJ28oV0+ttJp8UAyVaYpULVVXmOnEO8XkDdTNuDUCJOS516VwhV4XjBGmQDds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=FCUUMxap; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-656b1f906f8so670755eaf.1
        for <io-uring@vger.kernel.org>; Tue, 04 Nov 2025 14:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762296303; x=1762901103; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zA+MIvsz3oHo5qpD2FIHZUBV7OZPnR+HBMVbUSiqp/s=;
        b=FCUUMxapq5iZZ+cFBWhNbe4LfiBxnvKWfHc8JOPeCq8AkcizPn9eV+wFfDL8Gz3Dej
         kyp4RmiObLStOZThKI16EXqH8ayu/O/G5DEH5YaL9l83MSJQ6dPhS9h6dwWyW9K0qD04
         M/RdTbwBkR3UEhiY4Cvx/VSV8hWMHlqeqdCjgoNLcJreZzFdpGAerdRnuL0TUmIqegYv
         SA2zVzKucfRbY8a6cCCtuoWKH6rad/Ov9w2zMe9njl2NWoCfhhycoqMJmwKqvZmRiLRi
         IteMDkLbXGMzBRoPpqIGJ4ZDk2qe5bvOsslSkeiW1cpS8yV1oPB4h7NZipdiBvSQ+V3H
         7tog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762296303; x=1762901103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zA+MIvsz3oHo5qpD2FIHZUBV7OZPnR+HBMVbUSiqp/s=;
        b=CPbD+KtWo7IaoepVa1ESgeDV1aaW2PTx+qNlg0sGFo1q0PFYlQ0kwmyRCqh/FSxpuO
         k75eoS4JUN+8v/WctotDM0tFAObJh1s3S5iSMOP6t+e6kBF4T/stJvQaKyL9v5sr+1eX
         dKSmBCNbHbuE5Adf5KhGuQMy569ExiB0gZrxMy0wU4NvPK6dcdgLhXCGSUxTGLRPuo40
         7GA1acNtbJXoQIumzme72a4V6ydcADng/+pgQN5ALhQ0QvA5b1lFlEL/5ECj35Sd/WRD
         8zgxYIp1nJRGj46SYJB6HQAqc0H/Vlm8V/4zay0jP6KJ32/98IYNVOvmYnbFtoeb8PXb
         z0DQ==
X-Gm-Message-State: AOJu0YxS5qhEO+3Yfz1lmy7u42LddULrjdu2qJOyDfS9b4uX+n8N4Z7B
	oMvT3NJantLxiozDIR1+Y+i7T0Ae+gJtS7Vd68/b3n3Syh4w3iM68VIMi+dc+YCw3JrptXHNy47
	BwWF6
X-Gm-Gg: ASbGnctfGl9172xFXdBbU9nUgWF6TfLZF/4pBfng/4av1Oth/8QDzbe8LV8tYCa56dA
	q72/7DUKBq62XV82nwhKgJtxg2rt0RJ7r03BdlGxOo0r6oYvvwzTqmZU+LtYNqKzhx4QGnAFL6J
	YyBCAYGrn4AL/hdpmWk7jraBNFlFVh2E6gkDINeJD7N73s/snVJeudZg5lUCBVjcKbiv8kCA9Z6
	9H3PqNN0fW1KoxgtS9peXsG8LxrPE62deey8xuoKhG5ENaEvSeDRlq8SHfi01Y57WaYx97YWdQO
	U/ltURMIrUIDkayUAAL3pHRGn6xJVCRVBCwwGknMdaB/UGPFEARh4V3AY0315eUdZJAfTXdAzu9
	bp/q7fEMfPGvUrhLhcBPjZ3xWkHSpCtMtrVpddYn2Sl+kPuxmvrGNE7dttD2hEB8ZMn3NO8gPxo
	5Npvb0+FlkRoso9L3F8A==
X-Google-Smtp-Source: AGHT+IGaRdMoHxrYXRoFywkb9zzwtOseeYfUChxcZZvNvkul5gfGuN9xS0zLBpc7AsVgalBrl0Hahg==
X-Received: by 2002:a05:6820:2006:b0:656:84ec:64a with SMTP id 006d021491bc7-656bb64d4c7mr290855eaf.8.1762296303554;
        Tue, 04 Nov 2025 14:45:03 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:9::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-656ad43a2b4sm1178456eaf.18.2025.11.04.14.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 14:45:03 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1 3/7] io_uring/rsrc: refactor io_{un}account_mem() to take {user,mm}_struct param
Date: Tue,  4 Nov 2025 14:44:54 -0800
Message-ID: <20251104224458.1683606-4-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251104224458.1683606-1-dw@davidwei.uk>
References: <20251104224458.1683606-1-dw@davidwei.uk>
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


