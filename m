Return-Path: <io-uring+bounces-545-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F0F584BAE5
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:27:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C11561F25B41
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F084B130AE8;
	Tue,  6 Feb 2024 16:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="e++tOjeG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD1B134CFB
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707236858; cv=none; b=Px2wv9dk3/6rukND9ThIOeYmTog/6C+Z8th2i/pW7+abXuLlvTRZN05v0z48JKZLeVTsm3avKCqOeQeRsZBtA8eMp/hKWeZpXgMQCeimiXu7cP1pr69J/gApAZ1R5PcOjqMzrnHO7gviQhvbGGDZ1aOIGCtwcrnNUY1lvZ9025U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707236858; c=relaxed/simple;
	bh=U2Clrm09ZhoM7Wa+PuhSc+fENSYu0dlRhn130hTzr5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDKxQEDrKjiVrLTxZkmUiIHVMHCmtX1bt38UGZ4OUofKp3n0GhGU57SOqB1SId4RPgeOmjPIj2jJTDOc9+JdWEM8CibFok6rzvt/0KeMhvr5bJnro+1/Zi+j6vXiB+G5sSYONzztkL+pGQ0xm2+1acz+iIuJhUQkDMew7exauJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=e++tOjeG; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so59141939f.0
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707236856; x=1707841656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fMvLhIjj8u1cNNDBwKcaKvfUao8xbMSae4H1f8ns5ZM=;
        b=e++tOjeGk06Uo09sH2qV2NTlHMlMvl3zO9NtUGfvFY0dayBKWw+ZlrvHRE3oBZtR7p
         +uYDP/lCvAcdb4W+GRh44T0Gj4MApCzZjfWTWfP5wbLMlqtHOt4kDLDpFrXIT3KajQIa
         b9lNxdq7VCo8hU3KkQl6B1vOkYBvVKiPvvnl6KM4lGr50hOn67FCG/lfs1V7dNdF39Cm
         9t04eHjMsbslolQVxQusj729Xpa7E2Nv4jSsDXOy67usPd4g0HgdangOS+yAzbQDBsTm
         3uSzUiKcf+050lmPUkrgaXlQt1wV0odw5Ami4vrZwPDd90bEu1HlQLpJjxKQ3x0TuyVc
         oTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707236856; x=1707841656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fMvLhIjj8u1cNNDBwKcaKvfUao8xbMSae4H1f8ns5ZM=;
        b=REFp4Cf7sJ0jfvPrxw7NLilGsLdYcIX4CNeC8TIoGFhDg6RqIdZ7hN5vxoc9g7mxcG
         0ZCDJQv9jCst0hRC2Fg1VzQImDthAp6IQwQCGddPZZa8NpILZOwSEipuH1oxUtT1PFtm
         e+AX8vXC94qXMa3tnzi1OfpPhQFoy5eTL48dc47l2uH9Io5chzz/fbUQiP0bU7mh8ATv
         VLDBqmr+3AA3oYXhgrG2Agyk0ld6Xe+OSANO3GpMU8+j4Ux2JFSvdJh6N9zAvJcrJ5Y0
         79HZqPprub0KzBbpRbpv+Q9ng3alL2o8wYuff96XAfh2GMDREWNzr9JcaaQwSoeVvoKV
         181g==
X-Gm-Message-State: AOJu0YwdJe0PHYq7mnBvxzp/ZLcN0LZtP7WKikQhK8L7d6xmGU+k/lkr
	9kWHs8MfZVtY5I/JoKfeHbU/UjWX2C8aSdiXywBFnvYxGgnKcORWMMsHF8JBu9xhikK2RFkgAmY
	ZCkY=
X-Google-Smtp-Source: AGHT+IG4cQE56HQ3GoiJkEDBFDpUzrae3W56dJMoLLnJsBMCzEgr0zh8sBsYQkFcQq1XTVnYF49ejw==
X-Received: by 2002:a05:6602:123a:b0:7c0:2ea0:b046 with SMTP id z26-20020a056602123a00b007c02ea0b046mr3677335iot.1.1707236856201;
        Tue, 06 Feb 2024 08:27:36 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a1-20020a6b6601000000b007bffd556183sm513309ioc.14.2024.02.06.08.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:27:34 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/10] io_uring: handle traditional task_work in FIFO order
Date: Tue,  6 Feb 2024 09:24:38 -0700
Message-ID: <20240206162726.644202-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206162726.644202-1-axboe@kernel.dk>
References: <20240206162726.644202-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For local task_work, which is used if IORING_SETUP_DEFER_TASKRUN is set,
we reverse the order of the lockless list before processing the work.
This is done to process items in the order in which they were queued, as
the llist always adds to the head.

Do the same for traditional task_work, so we have the same behavior for
both types.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ced15a13fcbb..47d06bc55c95 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1266,7 +1266,7 @@ void tctx_task_work(struct callback_head *cb)
 
 	node = llist_del_all(&tctx->task_list);
 	if (node)
-		count = handle_tw_list(node, &ctx, &ts);
+		count = handle_tw_list(llist_reverse_order(node), &ctx, &ts);
 
 	ctx_flush_and_put(ctx, &ts);
 
-- 
2.43.0


