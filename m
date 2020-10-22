Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286382961D8
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 17:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368714AbgJVPqR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 11:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368712AbgJVPqR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 11:46:17 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB473C0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:46:16 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s9so3024370wro.8
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7ocGOWd4noZiy7O57cwBO3o5SZMCinSYDLLcRs4qKBE=;
        b=U4dh23ZCWJeI99UXRPSTKsX4WJbPfA+A77jeD/+60QWSyv13lat1+7DRLBzXrQYRYJ
         xw9kemwSpLEHIlpeBGB5jKS6IqnuGB90myxb8H0NdoabyUlLD3ciMbvsVp2HWaBgrI3c
         +yQlycPSiiNeMxFmHbhtDn9yZLEns58Rt/4xz9ZSTE85vquuQwbdWK17Vg1gH8E85erO
         ajlWkzJeM+JLdBQuVcWFQjOeYsJcPxZxC0u4d5gvBbm8UNnc5tISF/oUTysKg+2sQXYg
         lP4aSxWEJKDPI6tRWicLMTH/zFF9Gm8uynSt3p2ACjswZuM7w+k8dACknWCMRCKl+2tE
         LcnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7ocGOWd4noZiy7O57cwBO3o5SZMCinSYDLLcRs4qKBE=;
        b=TxVC0gwKWSyjgQXN3v50jl1dqmMTk4Iuhv5m1JrExUGoRCdQKvPc3xUCL37lWfdJSc
         VywdGZQyNidNF/pP7YQCbgspvWWyw9LuTCqiuzRrQ+iS//rCmw5KZ2nNgG5+8oURanfq
         pCCxbtvODYoFSJ9AmBvaxddbjGW6m9Ck46Aaz8KUkDtRxkTi1DYAgZD0SjUdoWCQ/xo4
         kPILiLsdq2xN7XlAhmgF8nBjvmsv69jYUqEFT/Admu3gppd0oFY1k/Ze9QYrBf1rLuKy
         Pi/Ov3kGNgOxh86NOho5R9kFtlSrEgP+BA3UKKThS4xU1O0zXIPyULIhTwsCN+M4z3LG
         fxMw==
X-Gm-Message-State: AOAM5306CaLF8zjLrVvzoyaNPbGaO4YuHTxZ3szDSU0RBs2a+jnjvxuI
        KtkVdPFyqC9yKpCACsFXLfVDnmv0xfe17w==
X-Google-Smtp-Source: ABdhPJwwvQ/9v98QdD743jgO4rhYSKqcNMZ8DeIWh3nqaScirvmVVjh03DkSgOFhN/Tqewtn/Dm47g==
X-Received: by 2002:adf:f986:: with SMTP id f6mr3663096wrr.38.1603381575725;
        Thu, 22 Oct 2020 08:46:15 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id s11sm4329536wrm.56.2020.10.22.08.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 08:46:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/4] io_uring: remove opcode check on ltimeout kill
Date:   Thu, 22 Oct 2020 16:43:08 +0100
Message-Id: <5cab0ef8f72674ccabc685ce640b209b4c3e0c39.1603381140.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1603381140.git.asml.silence@gmail.com>
References: <cover.1603381140.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_kill_linked_timeout() already checks for REQ_F_LTIMEOUT_ACTIVE and
it's set only for linked timeouts. No need to verify next request's
opcode.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 29170bbdd708..8d9a017b564a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1872,8 +1872,7 @@ static bool __io_kill_linked_timeout(struct io_kiocb *req)
 	if (list_empty(&req->link_list))
 		return false;
 	link = list_first_entry(&req->link_list, struct io_kiocb, link_list);
-	if (link->opcode != IORING_OP_LINK_TIMEOUT)
-		return false;
+
 	/*
 	 * Can happen if a linked timeout fired and link had been like
 	 * req -> link t-out -> link t-out [-> ...]
-- 
2.24.0

