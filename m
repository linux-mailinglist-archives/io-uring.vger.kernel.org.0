Return-Path: <io-uring+bounces-7176-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B62B2A6C35D
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 20:31:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 406B0189C43A
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 19:32:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D0A1D54CF;
	Fri, 21 Mar 2025 19:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UfjK7qUx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CF618FC75
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 19:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742585506; cv=none; b=H6mLIKjxYhAZsQZ/YLwYiq90puA8p3dI2wTqHjewg5eiZI9B2yZTvn9+or3i7ttY1SbaxQka6w0nljw4xYvR8wjTpelO4UKUJceZZ2uRusPpkx8Lj0BrP436coWRU+7CR9Tr/fn6AK2w1l5jwkcd4z/EklQ3S2x5ryIDXGy7uXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742585506; c=relaxed/simple;
	bh=KZ+Ic+BWyQcR0e6F7+GzTLf/KD3WATnb9NZNaa4mV4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyZAbNoyclZJydeSAqaXu0/Emzqj+GU+egzOdorn6HyN5JAMRhI7zKFZHTNjKo60DfVecF1ZwceDJSGQCbg/AyUs8Gz9PoK0qUCXRUJONel1oilIY8RHeVvYQ99lXIk9hgJgzP3p+QUOYei1Hm/WzzQRKGccZlZe5BerTSKTXkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UfjK7qUx; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3cf8e017abcso9601305ab.1
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 12:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742585503; x=1743190303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tU56+PQ2vZTfTRhA3cEUcccF09LVLkb7uS6dS9cTzOw=;
        b=UfjK7qUxQZSeq1dJ4wWRIhtYozEBtEpEJ4tS7psKGiesaSd6Yfd3Yyk7vpDyV6T7F2
         8eNg+bm9fqb2nthy46LqKlE35GxExQkTayGeFkV8nKyZSKyoLlvFP/BSZP06prd5TG7k
         hRQKuIBO4kNStU3DX9fe8/NTRRvAAj5lp3d4llBVj0tLY8Nebqv9qY6z6556qsIFjmBW
         +8wUF7ho4uSysKwNs56udXj20sOe93sKhaGUmxaS6p6NnoBKk2lBCQ3BnIORQtbxTvnW
         EowZ2BGnaLfTGi5Php2n3zkw1OD71PInFt14u8QQ0GrRxisoB+WUGlc7aWlLIZ1FK+r1
         Ddmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742585503; x=1743190303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tU56+PQ2vZTfTRhA3cEUcccF09LVLkb7uS6dS9cTzOw=;
        b=kDdkn4p44B2lkS/UYJgucuDXrBYRDcHxq8720eiVT0xkMiTkCTSzUD69q2gzXmDGAr
         VbPjwYbgBf6Wa+gZFP1aqW1cjbtUbbMd2ClYO98Bh8lrPeV16SkMCXOyzkt+KheQZQet
         VrrBhCWtDXcfdZypYGTzjfmtf2Y5jyUkDma0tQYxzuY8aAlJxb7SdpRmHHiLzcnnVGln
         u2GAsgIzoynH58iS7mFAcWd1Zgvg6mp5dfp/cvLCJQMyU0OuOwvu0FNTM0BgtS7vazzv
         Ei2sD1exl7nvX87zTYadSHpIDqM8VMhMhbth8OY5/zY206K/nJ7oKeFvieTZXkJXqmBB
         3ZTA==
X-Gm-Message-State: AOJu0Yy4bGo5GJcfYxYxdL+7ko6ns2QACDvSwJUcR4bPtIj8zIcIvDJF
	BTVVtNv/6WNV9oOMdodcr7FHF5gpJ7jjt6atVbO/hYazyGrPUZ1KR6AGU0DXbHznob9GyUMoH6j
	U
X-Gm-Gg: ASbGnct2EgBbt9o1LjCEhb0uq6DakhnH+1xM9rWjr1RSjQx6d3qWsp8eoM38vQQEZ2w
	OQPdmQI6/LZmAqtwfnjzYYLQfBllMRUYU2GUC5Qy9Oql3nXbB8ZE+jv88vVwmhPJODX4BPlA9W0
	m5XeurXmL8zMIPPbTi7g9/53iCNfT0Pg+8aln8V4GNtcHVrMzcYWfsPd1g63tPzN72XJrrKUN6T
	hQdvaFQStH8dWQuOQ4I5G29nP6XGN1RkEQUBG8c9UVKY8O2CnMyV39TSAyDFW1JPZ4pn77hkAlh
	BkX7Rd95lK6jdM6LSqjyVxJSltWS6JuDsovPbRZ5+JHIFnKxkg==
X-Google-Smtp-Source: AGHT+IF98xNhuR+iTPRcOpDSzKzkv/vrnFzdQso/HbsfIFcKJ/3wsGRa0pq6EI1L6XdrQW6J0qYahA==
X-Received: by 2002:a05:6e02:144a:b0:3d5:81aa:4d11 with SMTP id e9e14a558f8ab-3d5960e275emr41343825ab.9.1742585503558;
        Fri, 21 Mar 2025 12:31:43 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2cbdeac82sm571268173.71.2025.03.21.12.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 12:31:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring: consider ring dead once the ref is marked dying
Date: Fri, 21 Mar 2025 13:24:57 -0600
Message-ID: <20250321193134.738973-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250321193134.738973-1-axboe@kernel.dk>
References: <20250321193134.738973-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't gate this on the task exiting flag. It's generally not a good idea
to gate it on the task PF_EXITING flag anyway. Once the ring is starting
to go through ring teardown, the ref is marked as dying. Use that as
our fallback/cancel mechanism.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2b9dae588f04..984db01f5184 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -555,7 +555,8 @@ static void io_queue_iowq(struct io_kiocb *req)
 	 * procedure rather than attempt to run this request (or create a new
 	 * worker for it).
 	 */
-	if (WARN_ON_ONCE(!same_thread_group(tctx->task, current)))
+	if (WARN_ON_ONCE(!same_thread_group(tctx->task, current) &&
+			 !percpu_ref_is_dying(&req->ctx->refs)))
 		atomic_or(IO_WQ_WORK_CANCEL, &req->work.flags);
 
 	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
@@ -1254,7 +1255,8 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 		return;
 	}
 
-	if (likely(!task_work_add(tctx->task, &tctx->task_work, ctx->notify_method)))
+	if (!percpu_ref_is_dying(&ctx->refs) &&
+	    !task_work_add(tctx->task, &tctx->task_work, ctx->notify_method))
 		return;
 
 	io_fallback_tw(tctx, false);
-- 
2.49.0


