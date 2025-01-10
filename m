Return-Path: <io-uring+bounces-5811-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B814A09C81
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 21:36:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47BF1164C01
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 20:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EF721E1C01;
	Fri, 10 Jan 2025 20:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HHG11VJ6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CC1206F1D
	for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 20:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736541363; cv=none; b=oNDDK8chYe2sYoApjjJWLcbCrI8InNt4uvJQSDU+LinmvnkVhXaRHMDbKYdTHmGBuOtBRB0I+lXm8cpsIz/57SYZE+SmV9QMtGylb1LtbZEPZcyWVGYZz7FO0KjRropsimQZWeoay+nMjQbb6k33NzbHzkndzS/TNSkqGD+XHi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736541363; c=relaxed/simple;
	bh=2ku0CH/ES0h5CDcQzcGgZxFDjDaqTY8TZSSOpgSptmw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=or9yyKYd3nnkFofsFtZx6iO7HcGE4oCb9d0rLQISsimVsIOuJr3hkA1QyGonRpadZx2V4yrp3WKtWHgZ8koWfEJ3LfFD4eYEq6QOUgStzT3qEJ+hw38c7GVmcMiKk/L3yaZDd58JWzvr2qTYjw44j6TOhtbu8d2Gl+kpcf+3swE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HHG11VJ6; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aab6fa3e20eso444293266b.2
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 12:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736541359; x=1737146159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V2MjpE3klZWrTT3C8h27VWSltTtr8c99PCH18+G0LlI=;
        b=HHG11VJ64ZymAfaIJ35CFLoN55nPcnbrTv/FErd64U5f3wnfJ/s7FtyRpcGMXzmz8X
         ug84XqsF9ZBllRhjh3WqB7OLyHGJW5Y6kX6X84K+lInSi67h2QmENDGBH9fzYZoOSo5j
         Ys9ytx7ND5xZ+XztUDYldEtJNejwrhTbSDYb6dKexnZDI4b50zWjzZztnhpr6ftx05Va
         kRPeOkf/0DbHzmqEnT0+/wsWZ5ycqUzXQ4zefKDDt6Vc4ih0dOPU45X3On5NO/E6B6W7
         sbPwvf7zP64Ra3+4FbLHNfrNvZtrcaalIRCG8Rwf+rWU5mNQpVk4/8mJ9yyGpwZwdwb/
         bjNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736541359; x=1737146159;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V2MjpE3klZWrTT3C8h27VWSltTtr8c99PCH18+G0LlI=;
        b=B/ojtPt+U5rmQcvxpQW5Cd+MfbA35x9aDgZKG9qo1YnJeoUTUOqlv6Hps2ppq9xhWB
         6dRCpgoU/MPEhislM7lF71UPgbD/YjtTPjKlKgkYciaEVjZXUfnx1qDujkXqZAwKoY/n
         ox18ojei555jTIj8JXijrQiiP0/krDZ8H3Rr1ePnUh4TEqWnNl7uPaSbgvMnDLVaiO7n
         J+G3SE/mMDe7JmYWG10gdtVM/NCu9P1cGMVY3e2VpYAaPuxO3/RvrXhevng6CkQm1bze
         igP7Mk/EubHyj3nFFI1gSPNr6hld0b+B+zYlc2bCSMZS24oD3j+bWExdgjMMkNrzTD4l
         cv+A==
X-Gm-Message-State: AOJu0Yx8lxHARVGcaoztL92oQ//3zzBWlW3cTcRMNFckJ+QCGvw8isST
	IsckvTJ0/W6E2SYwwL0LIW8R5qHrWGMZx/U3B/TJjjBZNyByzStV2UYniH2U
X-Gm-Gg: ASbGncud74e4pW5V5w7DuTi5dhuq/UzmOnZLclr0+ShFEuqbKmGlMSP70LLTEjd6Pgv
	2ACWdZTtN5FiZOL/TqU4/9N+oDkRcMWYY9bWRwJooNSyjnjGD6V8+ARM02wJreAc9p5puzkgm+e
	EVGFmz/yPLobVG9voVwLcofiSsk4412zt/p1w/erGIm4lkPPnmh2yO//SWvZiuAPWPdhLH3Uj98
	npkXkNQ9OH2mLxI9dDzIQPABIB/5v/Tg0KKfKPQO16LXHApyC0VpYoHe2X27oneIjOLYuA=
X-Google-Smtp-Source: AGHT+IFE1aIecExMMdJAvUpOd7D1e88OwApRIZdAaRugNwno8L+/LP7tTjfIePix9ehcdDmjYYyT8A==
X-Received: by 2002:a17:907:3f9b:b0:aac:1e96:e7cf with SMTP id a640c23a62f3a-ab2ab6c6720mr1066459866b.20.1736541358744;
        Fri, 10 Jan 2025 12:35:58 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c95ae536sm200503066b.139.2025.01.10.12.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 12:35:58 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	lizetao <lizetao1@huawei.com>,
	Bui Quang Minh <minhquangbui99@gmail.com>
Subject: [PATCH 1/1] io_uring: don't touch sqd->thread off tw add
Date: Fri, 10 Jan 2025 20:36:45 +0000
Message-ID: <1cbbe72cf32c45a8fee96026463024cd8564a7d7.1736541357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With IORING_SETUP_SQPOLL all requests are created by the SQPOLL task,
which means that req->task should always match sqd->thread. Since
accesses to sqd->thread should be separately protected, use req->task
in io_req_normal_work_add() instead.

Note, in the eyes of io_req_normal_work_add(), the SQPOLL task struct
is always pinned and alive, and sqd->thread can either be the task or
NULL. It's only problematic if the compiler decides to reload the value
after the null check, which is not so likely.

Cc: stable@vger.kernel.org
Cc: Bui Quang Minh <minhquangbui99@gmail.com>
Reported-by: lizetao <lizetao1@huawei.com>
Fixes: 78f9b61bd8e54 ("io_uring: wake SQPOLL task when task_work is added to an empty queue")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index db198bd435b5..9b83b875d2e4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1225,10 +1225,7 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 
 	/* SQPOLL doesn't need the task_work added, it'll run it itself */
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		struct io_sq_data *sqd = ctx->sq_data;
-
-		if (sqd->thread)
-			__set_notify_signal(sqd->thread);
+		__set_notify_signal(tctx->task);
 		return;
 	}
 
-- 
2.47.1


