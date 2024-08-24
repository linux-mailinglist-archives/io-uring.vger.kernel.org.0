Return-Path: <io-uring+bounces-2944-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 39E5D95DEBE
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 17:46:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0FE0282E67
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 15:46:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52B6415574A;
	Sat, 24 Aug 2024 15:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JyH89Tc5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBFC29CEB
	for <io-uring@vger.kernel.org>; Sat, 24 Aug 2024 15:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724514368; cv=none; b=jDx9zQ4PD8Ncoyd7g49NIZD/i3S0afeMqQzRhKCpiIZo0dxXXzoTnl+ybMs/2QfI/N/rz/xGQIwjn2Ic9/kO0ThdjrYCaBktiOoYCrwEwfnZK1kzcGrGhPCOzJX5PScqzkDAms4OsVLgBOM9/lTkcU1HAGJMxXKv8jEdCikF1so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724514368; c=relaxed/simple;
	bh=4eZS4mdX540H0maC/bvPRFHywgITJ7MiqVHUpXsLliM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+NUxD6hoCNdccGAdT6ooMD1DVEzuQW2LPj8nZX5HVE5wBf/vnneGLKm93FKBvhjtc533LnIjXp1Tg6kfiBiokRIQ38+guaLnmwvIvcI59FqWrw0dk0LmIhXz2IR3nmLuzHsPUU7AaGljzRLYaR4Vuu/BWZPFN/mK4qbTbRR/4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JyH89Tc5; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7cd967d8234so1845815a12.2
        for <io-uring@vger.kernel.org>; Sat, 24 Aug 2024 08:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724514365; x=1725119165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=13ZYkOezJuvE61Ji1KvE094MwNJk0Fd40sBkhiKcDII=;
        b=JyH89Tc5GqUADXsH4A2qqO2hlR8ISwt9riLY9el9O2lhUgUg4ciL/LfNDMbg4JNRAc
         NmVQCG67jHBboaYy80HRu8541Vm4hg0VMDROl2eeYDNLy4qtTeTlEtHe6+wacaIM0MtO
         DZTJzdACRTqlO1Z7dKF+Cd3+aImFWsfihoOkVgr8PfeRCu9Ow2x6QiKZb4MO1ooHAzvl
         9f5W689QVOV/wtQuXEG1cO0PWnEN5w0LgQkkryrBFS4O/2XsKtGCzipyutkUU7cedExc
         mYC5225wapvBQBWdpFsLOdY59utGh2whsDSQPUq0gVXWT+a7lGzTjR9FW5HZxp89Stld
         ZWDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724514365; x=1725119165;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=13ZYkOezJuvE61Ji1KvE094MwNJk0Fd40sBkhiKcDII=;
        b=i8Xkj264NayeZ0HO0nYLNsTzsKUL7BXe/9x74S6fWj6KThPj7FYLkOOAop4QGsllYP
         BKHAlGm8Wtom2H+THqSpkXQTwzsOzvtegu9GHoynoKHKgG/b0KKadjTAmUwv3tXng7gf
         CRsOzJKQvL5a9n63F3kweWXJNMm8m5lN9Dj5749Zy6BpDZW5eklmnQoxxit2n+rYjP3B
         iYnArZbXuNWChbY3mYKHiFjhEKQXGpl2G1oUQX/DaVYsc/fKY86zT+i+CYoAVNjVNLEM
         r4fKad66AXVYJQDwg0vnk6uhRWfZ7bR5vqjr7X2PKFYTBnNR9kr/LnHFnjSJlO1WSV3b
         1WbA==
X-Gm-Message-State: AOJu0YydMhEQjLThdcmabN9KuDtRnpYjQX+AJ8py51JiHpXzj0h5gXIN
	6MfwbHG5SbMX8ospgDWurFwCkIW/UTfTcKnyLCEy+ISGxMGyex8KlasVMB8NAfv54REjj1tx6rt
	f
X-Google-Smtp-Source: AGHT+IGlWElnzksMgcPhZ4ze0CUfmw/DnRIHH/mxU0ezw6xv5D3CGhO4XyBuIJxn14OP6WYN8QVdOA==
X-Received: by 2002:a17:90a:39c2:b0:2cf:cbc7:91f8 with SMTP id 98e67ed59e1d1-2d646bdcc74mr5006577a91.19.1724514365074;
        Sat, 24 Aug 2024 08:46:05 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5eb9049b0sm8596939a91.17.2024.08.24.08.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2024 08:46:04 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] Revert "io_uring: Require zeroed sqe->len on provided-buffers send"
Date: Sat, 24 Aug 2024 09:43:56 -0600
Message-ID: <20240824154555.110170-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240824154555.110170-1-axboe@kernel.dk>
References: <20240824154555.110170-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 79996b45f7b28c0e3e08a95bab80119e95317e28.

Revert the change that restricts a send provided buffer to be zero, so
it will always consume the whole buffer. This is strictly needed for
partial consumption, as the send may very well be a subset of the
current buffer. In fact, that's the intended use case.

For non-incremental provided buffer rings, an application should set
sqe->len carefully to avoid the potential issue described in the
reverted commit. It is recommended that '0' still be set for len for
that case, if the application is set on maintaining more than 1 send
inflight for the same socket. This is somewhat of a nonsensical thing
to do.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index dc83a35b8af4..cc81bcacdc1b 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -434,8 +434,6 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		sr->buf_group = req->buf_index;
 		req->buf_list = NULL;
 	}
-	if (req->flags & REQ_F_BUFFER_SELECT && sr->len)
-		return -EINVAL;
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
@@ -599,7 +597,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (io_do_buffer_select(req)) {
 		struct buf_sel_arg arg = {
 			.iovs = &kmsg->fast_iov,
-			.max_len = INT_MAX,
+			.max_len = min_not_zero(sr->len, INT_MAX),
 			.nr_iovs = 1,
 		};
 
-- 
2.43.0


