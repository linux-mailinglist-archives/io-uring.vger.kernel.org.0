Return-Path: <io-uring+bounces-7218-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96B2CA6DEB9
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 16:32:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABB671695E7
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 15:32:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE146261396;
	Mon, 24 Mar 2025 15:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JZ9TvvCa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1086F25DB0B
	for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 15:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742830314; cv=none; b=GEvxSsoYcXWKKXEk6jW8gl3vL02WOHy67mMdOYA2W0pc39pW6lZS3Fp+OWNlSXU1YsaPzs52CpRv4bir6YTRZr51P0mTHaRdyDiDJyffMn46iY6vw3QAmJQ5n2QeMWfL2doWKCRNl3NkUjPbLblLHb4EHjSh7cmbHftU285wUFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742830314; c=relaxed/simple;
	bh=+LsSCXMy0wLYtyjSd2Q0+yFAhDEV76k9CzWax0P1/Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mG3zkIo/TbxPvsgI3dUas0+8dbmG+FhcZNosOZnAtth7viMOSC9jrEfU+64t3Kl9NHbDhAVvOwazr34oJfdJ2jv/KMV2pTLdCO+k187LHZikWifJtK86b+uC5QeTuw6zJ4WbeVAJIhaW2GxnaPfbW43qZrxCtnaTIlBnmrwm6YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JZ9TvvCa; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5e5b56fc863so6658799a12.3
        for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 08:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742830311; x=1743435111; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sjLoWtXoKPAYsYlYGElbZjQ1gNZodMxMjWeNjImTVG0=;
        b=JZ9TvvCa4KD+FNwRcoLL7vKbsUOLQpvrMDOSEOCqP24hkkoqS0YUD4TJbSdtu6xFir
         k9su4reAG+vxyv9GqKlwtZgxpVYuHMo8BQG9RbtaPujl91Vj36RRiPPXzcpE08ZEcTzi
         QEkECKkIM7Kc19IWwZeWN2DLKc5rJzW5G78Wa55jxEjSPCa7DEJoBiXSJLMnbTsTG/MO
         JXrs6k5RKOElHGazOfN+Tz2kJMS0HwqTShfyL1JFXntnYy3AMQ2Uy75GeTzV3/+eYHto
         yIL4Dnk3kkd11as94KDRFpVFpnRDT8PtTrL7XiviXiso3TZopp/BMO/y6qvL3+An+N3/
         Kc3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742830311; x=1743435111;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sjLoWtXoKPAYsYlYGElbZjQ1gNZodMxMjWeNjImTVG0=;
        b=VjS8GEc8nBOijuiP5cBGHX1uqc+Ce04SEeTycaoc9Jil6A+mdOnKBIgdpYQ8tIU1BF
         d0q/ioJTdEXp27x/9oPZNpJ3ELv/HehXJB+TrQtFUsErXTIgMNJ7u8vWYtZZRKseiTy7
         yR7CxrUiuBPa+OGM9s14f1qxo3qqoBDDuc9JKTwoo34CGDvODf1K0qf3IlbuLfspilCM
         Hi8oTcNQAw4uxUJ4aO75Oegs79yz0o/MGL/odQ7WqBo5mz6acMawLtjeOB/KvryWvFw0
         up91fqEzGLEiDy9v8GKzfCRvnlMj7zoZlY4tnEXNWYi+5T6LqFs1IziEw6dDRlEtqpqx
         iUlA==
X-Gm-Message-State: AOJu0Yy52PkxJX3hKkeY2frGXljav0GQymqwieoOVx/dwjSK6ZvBQfTj
	WLqO+LEBfw7+tyTanpYfQLXxmA42Z2Ci9pgS6MmJSUmCsfbouJJlctfYSQ==
X-Gm-Gg: ASbGncv2vlhrDf+HqNvpWofu4vsuKzgwBOdQwFk9WBplnPeHTPFErQxmq2zJXYR+rTw
	qaSUBCJpUDSKaJnRyjHi74W6pIO7AHLvSEAbkk/CfUoayB2omwr2srVVnViLyO4uPzUqjmSrIlB
	EoeFCGHX8JbSjlJfzW8Y6lY5cfcnVq/3XmqFbiRnqlS7T9VoJ9zW74rRcCvDV6P/7RV5M8IW8Ic
	KXbD6Rp2LPJAJ+/YcpZF9Rk+81NgpP0hXqAIJYqKclrfKyUi2MzYlBMXndv/hXIHLp+7J/7hh3b
	MXn4TGlpjrbloo1w0Xjh3+2hTbL40cHN5P9w9P0=
X-Google-Smtp-Source: AGHT+IEECY4XrLwvEAhGnYsJNEszLN6Yw+TyggM+A7FnPqScFM6sjXLzSP8jDQv4o3K2XIFkYy5D4Q==
X-Received: by 2002:a17:907:e841:b0:ac3:c7c6:3c97 with SMTP id a640c23a62f3a-ac3f1e16b61mr1369169366b.0.1742830310635;
        Mon, 24 Mar 2025 08:31:50 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8aa1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3ef86e514sm688103866b.35.2025.03.24.08.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 08:31:50 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/5] io_uring: defer iowq cqe overflow via task_work
Date: Mon, 24 Mar 2025 15:32:33 +0000
Message-ID: <9046410ac27e18f2baa6f7cdb363ec921cbc3b79.1742829388.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1742829388.git.asml.silence@gmail.com>
References: <cover.1742829388.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't handle CQE overflows in io_req_complete_post() and defer it to
flush_completions. It cuts some duplication, and I also want to limit
the number of places directly overflowing completions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e6c462948273..1fcfe62cecd9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -892,6 +892,7 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	bool completed = true;
 
 	/*
 	 * All execution paths but io-wq use the deferred completions by
@@ -905,18 +906,20 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 	 * the submitter task context, IOPOLL protects with uring_lock.
 	 */
 	if (ctx->lockless_cq || (req->flags & REQ_F_REISSUE)) {
+defer_complete:
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
 		return;
 	}
 
 	io_cq_lock(ctx);
-	if (!(req->flags & REQ_F_CQE_SKIP)) {
-		if (!io_fill_cqe_req(ctx, req))
-			io_req_cqe_overflow(req);
-	}
+	if (!(req->flags & REQ_F_CQE_SKIP))
+		completed = io_fill_cqe_req(ctx, req);
 	io_cq_unlock_post(ctx);
 
+	if (!completed)
+		goto defer_complete;
+
 	/*
 	 * We don't free the request here because we know it's called from
 	 * io-wq only, which holds a reference, so it cannot be the last put.
-- 
2.48.1


