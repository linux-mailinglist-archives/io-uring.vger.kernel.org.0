Return-Path: <io-uring+bounces-3337-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 595AD98AE94
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 22:40:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06A371F238F7
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 20:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29514199E8E;
	Mon, 30 Sep 2024 20:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aYaXsE/Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F432C190
	for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 20:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727728827; cv=none; b=HqgsqfiE191NyJAaq4N7aQOY4wBc/CPkpn39an+nGgWjPDyOE/Ld4wBE+wTiX2nIo67QPVOJ9Eoyp35dFiGdBcvJMA7HG1mGns2yT2WBl5uJ5PaZaTuTuZ3bjnJBwtZYxwbEOij2aC8BO4xVPbmUXyRwPiZRLDX3cRC2taCE0BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727728827; c=relaxed/simple;
	bh=7f3B/9vwhvFQH3WS9Kwb/5kXTSA7kbzx32roevP58ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9+Q+Md9D7o4KzTap2DVMgMWiV7dTDkyvQ9CKnUB1e20SUbvNYG7Maxq71ayCUv8pUtiHGqCeUXzJ9p4CpGvl6AzGYqG5cMmutDAHywsOAcmB2CXIRya4oAUJIq7M48t0m9/w3LneEfu+HMiSrrOuuBi1DFMhbLZ7ZOXwZlUx9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aYaXsE/Q; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3a3525ba6aaso5803315ab.2
        for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 13:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727728823; x=1728333623; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uzedQLOXkQza5ujxTJxGLPoQiEEKfSfG+LpallEDVjg=;
        b=aYaXsE/QTsX8DH8kPYIMi5gbVrZEt2+QZ6GI4XjZpc1gbs0d+vHj+EyU6BLC/8UtSN
         n4L1qnYlKtqwIfcCkVrzawaWF5Qg7xJgj7b/JI6vaG4z1L3IN76iWSLJrEkY7HN8C6tP
         LO4JaRolXSLcx8RBU+jSsWsHXZ2QfzFxv5wxYAuCfwZNLSUDba5+170TFLkpasA80mce
         kiVc9w1mRokBDzb1MzOw2mx2Esq61J8JDjWRERCOF8+oR6cOEWqM6kodJtHLhrl4kBAc
         2mcTG83TCERgKJs/t1FyhQtyAze5jSfXMhnFYstjtM9uymXSFTzGcgCRcYK1kJUcaCUE
         Rp9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727728823; x=1728333623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uzedQLOXkQza5ujxTJxGLPoQiEEKfSfG+LpallEDVjg=;
        b=IgfDbu4CxGj+BsLGa3gPpoxNNUzaxwUMDRh+yMJlunejT25guGVz+rrhZlD2lw0/Q5
         nCpzzVo+SL5xXVO8rycz08fa+nqx9Xf8SikSU+dKZE9Bg0dPSYpXStL1/+FgycK+CqZM
         AJJk1ibxiwj0II890E6fwW5SqUymCK7XOSzsP//dZxKanTktoBafrPT/yChXp5wz45n3
         bAQwN4eGTTCZotGSIuqph3DkODhZH01y7xt7CECSkqgufzX06GISiE2hDDJsTwoU+7ps
         5UheDyFjLeaV0LlCjS8qNP0Q/wF8C/UTWRjBX97jUfErrv8WqTF/MrussoxwIVBLjobE
         y0lg==
X-Gm-Message-State: AOJu0YxKkZ3CyqA/43j6+Sy7XcFTKTlgrEr7M191aRcBQqkJJxrh9Gg4
	/0PKhV2qCN047EHnlf6fBK0PCttBHKrh1Vi+YrvIxz79bbxTJ3jSfaIf406199IMBg+Qga/+OYM
	sefo=
X-Google-Smtp-Source: AGHT+IEjt0GzZ6RVff1vWv/hbhrJHRkN4YWl3iBXXG5hLVokiHew4mSQIDK68JjUBWMcdUIlORYH2A==
X-Received: by 2002:a92:c266:0:b0:3a0:9fc6:5437 with SMTP id e9e14a558f8ab-3a3451a2361mr106267025ab.18.1727728822877;
        Mon, 30 Sep 2024 13:40:22 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a344d60728sm26430175ab.2.2024.09.30.13.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 13:40:21 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring/poll: remove 'ctx' argument from io_poll_req_delete()
Date: Mon, 30 Sep 2024 14:37:45 -0600
Message-ID: <20240930204018.109617-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240930204018.109617-1-axboe@kernel.dk>
References: <20240930204018.109617-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's always req->ctx being used anyway, having this as a separate
argument (that is then not even used) just makes it more confusing.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/poll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 1f63b60e85e7..175c279e59ea 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -129,7 +129,7 @@ static void io_poll_req_insert(struct io_kiocb *req)
 	spin_unlock(&hb->lock);
 }
 
-static void io_poll_req_delete(struct io_kiocb *req, struct io_ring_ctx *ctx)
+static void io_poll_req_delete(struct io_kiocb *req)
 {
 	struct io_hash_table *table = &req->ctx->cancel_table;
 	u32 index = hash_long(req->cqe.user_data, table->hash_bits);
@@ -165,7 +165,7 @@ static void io_poll_tw_hash_eject(struct io_kiocb *req, struct io_tw_state *ts)
 		hash_del(&req->hash_node);
 		req->flags &= ~REQ_F_HASH_LOCKED;
 	} else {
-		io_poll_req_delete(req, ctx);
+		io_poll_req_delete(req);
 	}
 }
 
-- 
2.45.2


