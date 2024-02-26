Return-Path: <io-uring+bounces-760-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C3F88680EF
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 20:25:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37D1028C8D1
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 19:25:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C869312FF7D;
	Mon, 26 Feb 2024 19:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Uzv8qwQG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962A312F39C
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 19:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708975516; cv=none; b=RP56chRrVuwVZ5KNmCAkMvAAtghI8sbJxtp9e0VIyhdCD9l5V5ZuezNCXPRVqYTy0/RKcOq/khxAStFo2LmW5nIMIuLF3lxIJd98VRcf0Zo9A54/SSsxKIEYZBhNkgjtQzrpkNcJ52ClhestpQ2raZMNsewWZe055+yH6M4QB9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708975516; c=relaxed/simple;
	bh=9b/DCj7tK0fcxeLK2v+Pwa51LsBoMsxTPtfHZXS+g7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHlY6DqY5+rwSoJ9cMU8uR3gM9h19qN8oOwJBsi233BBVCE6WnkDMhUDdn3ajDE6FfR3s9nF+y90a2nD8m6CnveDZTrStZRWZGsp4i1bAac4+cwwTCNEM8VSoF48rLto9ybrHEMwSPSqicikjELRK9xnqjNVsx2rUPLgGZp8Ed8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Uzv8qwQG; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so31753939f.0
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 11:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708975513; x=1709580313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lGlHQ7gE2+xdFImai+G8EFaBONPIZKbvS7mj7TDXAzc=;
        b=Uzv8qwQG4KDa236r4yxNrTn4odlpke6P8Y9fdydeSU9eF2gLnNA7iTLOz/WMJQQmtT
         uzAuKbAhFWLVZKoh51DVHxk+hEYMkGypEi5OJTykLT8Hy0zylNXJupkF+KjpYhSUL6XP
         pdMJgUvkTlOf0T0ewbv0rcUetmf9ePoj6t/RJdSk23kpMmR6rS5D4sjyA/mNrGFg7qRX
         XyMqR+ThiiFL3O3/Ze43InIK3fWc//y6HO37mwDGzrEjTV7MSDndjf2cWlWeSoevmPN5
         l6WlvMwdjHzlZJasKyARDeQstVaLALJIDjFvQ1T5apvpqSWU2+beKyRWSi17bgRyB45T
         03nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708975513; x=1709580313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lGlHQ7gE2+xdFImai+G8EFaBONPIZKbvS7mj7TDXAzc=;
        b=pE+0C3IEC+Yqc6W92PgmtQtTe6tW9FXGikjGcVIkJcZG33CeTRGqF3nEg2hfFVwjmd
         xYrxAsaP4TMVrHYZbpAr6sLF0R49EJKVMEItCvYc/mhcRj3VMXGRVGodrh3HQug7vOvo
         6AeblrbayHXbW91WQoHOVLjPHfCS+XM6APwx5X6HDxymrztphz5a8Oz68DQeGrJZ0kb6
         Rtprc+u+P9VFsD4RTQVBoNQZG+eV8ATZ9KphOxdF5KTh2ZgK9L3JBE5JU0Q3Ve6vat4Z
         rMTgwQQ7+JCHLJ6thjOlxQ1LiwjXQBx4ntxZNv7ee3JcvuUtzSvAs5wPVp7Wk0qYpiS3
         dcEg==
X-Gm-Message-State: AOJu0Yykigl9ZTzscfiE/OIysDm0g767pbDSeqwIxkaOTNzkrhLOgUbX
	rWmLdLRrOXVelrYgwiKvQK5MMp1Mw5w5pEhSNxA4e7bbsBHtRsBG5YitGGrzNtK0EtEPIwDG7sx
	Q
X-Google-Smtp-Source: AGHT+IFuVSw1pG6AMEcXJYuKAOuyXuV5NIhtrObDRCk9ADxU49DPsfuo7XLNLTk2/4pp2NIbmdQ8qg==
X-Received: by 2002:a05:6602:2195:b0:7c7:ce93:f532 with SMTP id b21-20020a056602219500b007c7ce93f532mr2750719iob.1.1708975513360;
        Mon, 26 Feb 2024 11:25:13 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id eh3-20020a056638298300b0047466fd3b1dsm1370484jab.22.2024.02.26.11.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 11:25:12 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dyudaken@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/9] io_uring/net: avoid redundant -ENOBUFS on recv multishot retry
Date: Mon, 26 Feb 2024 12:21:17 -0700
Message-ID: <20240226192458.396832-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240226192458.396832-1-axboe@kernel.dk>
References: <20240226192458.396832-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that we know if the buffer list is empty upfront, there's no point
doing a retry for that case. This can help avoid a redundant -ENOBUFS
which would terminate the multishot receive, requiring the app to
re-arm it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 679eefcd11c5..aaab4f121b7f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -698,6 +698,11 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		int mshot_retry_ret = IOU_ISSUE_SKIP_COMPLETE;
 
 		io_recv_prep_retry(req);
+
+		/* buffer list now empty, no point trying again */
+		if (req->flags & REQ_F_BL_EMPTY)
+			goto enobufs;
+
 		/* Known not-empty or unknown state, retry */
 		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq == -1) {
 			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
@@ -706,6 +711,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 			sr->nr_multishot_loops = 0;
 			mshot_retry_ret = IOU_REQUEUE;
 		}
+enobufs:
 		if (issue_flags & IO_URING_F_MULTISHOT)
 			*ret = mshot_retry_ret;
 		else
-- 
2.43.0


