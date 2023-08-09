Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B48F776900
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 21:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbjHITnQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 15:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjHITnP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 15:43:15 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C5F10FE
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 12:43:14 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1bc4dc65aa7so403545ad.0
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 12:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691610193; x=1692214993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KOs86fuyNp8imIS7vN17G0ksXsvzBl6U0d5kE/G4TKU=;
        b=AT81NWIfINjuKPvd3d2fcxKGVjUn+vX4dYqr+PA/ElISgtcHlqRDFMdbCJPcw2pG1j
         8KgHd4AbQBMAq1sGlCjLfeIff3HezF4xCmPzrnu/R+nojqQJ0OvAJ6G7qwUEpmavxgqH
         GKMthBCdPt0I7zGmXIzQ27MkxTm5lISFxr8FNvgYk6/MPRMe6g3VavAE4W07k26z+Puk
         o4PkMnoKSilDBoIlQz/I91oGVA6CJbeSX17pIzDfldEwimgIfHZPsUj3leNpJSAYVwT2
         WM+7yBSqu0cW/nwvCEOAUo1zQuQwP82/AgsYuQIRrP8TKdq19czpa2VdbBvMA/hGc6/d
         xD6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691610193; x=1692214993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KOs86fuyNp8imIS7vN17G0ksXsvzBl6U0d5kE/G4TKU=;
        b=XUeK/755zfd5H5bxYPoZcDnxPVwhfEJHJhR0cKQ/wkeDLMyOH/fbJI+wjrtfTgppZK
         SM8XgJ3XBN/IqEvImKKDTwr/zySDHJM3QCmop9Ndh3SaDot3RqrdoA7E98N+wfrKNyBD
         c7NcVo4a1YBzN+3piSKETd/WUou+/LPeN9OiyagwSeD4+kvi2Ctkq7Ph57KFT6XHgTNY
         74/NvPjc7A+rAb5oNGo8e/kH5Jx8BNvYcEPMUSeWYI9w6zqJRvPANzgVpDpIx5Lrd/06
         3igLVSM2HaRudjOL0T2YfvR7UK3hZivHCGGbjbnLWJbuJLoQYLMvFQEGhU4rDCJXraGv
         t31A==
X-Gm-Message-State: AOJu0YyVsCMI/7h/X47e1fwmrh0hbfnuAINCVIMugF2vqH5N4MzYLBpu
        d8OawLiqZXu8Ey4DwszBmteoOVSpeIjRu2a5Hx4=
X-Google-Smtp-Source: AGHT+IFwaEtO0uUhbrSpcAHYQDa6Wwq8OLDbcJBNLBJE+6A3/QGzo2GNF7HhGF2LdxoN+MECQTmtew==
X-Received: by 2002:a17:903:41cf:b0:1b8:ac61:ffcd with SMTP id u15-20020a17090341cf00b001b8ac61ffcdmr82671ple.3.1691610193612;
        Wed, 09 Aug 2023 12:43:13 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l19-20020a170902eb1300b001b8953365aesm11588919plb.22.2023.08.09.12.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 12:43:13 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/io-wq: don't gate worker wake up success on wake_up_process()
Date:   Wed,  9 Aug 2023 13:43:06 -0600
Message-Id: <20230809194306.170979-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230809194306.170979-1-axboe@kernel.dk>
References: <20230809194306.170979-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

All we really care about is finding a free worker. If said worker is
already running, it's either starting new work already or it's just
finishing up existing work. For the latter, we'll be finding this work
item next anyway, and for the former, if the worker does go to sleep,
it'll create a new worker anyway as we have pending items.

This reduces try_to_wake_up() overhead considerably:

23.16%    -10.46%  [kernel.kallsyms]      [k] try_to_wake_up

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io-wq.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 18a049fc53ef..2da0b1ba6a56 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -276,11 +276,14 @@ static bool io_wq_activate_free_worker(struct io_wq *wq,
 			io_worker_release(worker);
 			continue;
 		}
-		if (wake_up_process(worker->task)) {
-			io_worker_release(worker);
-			return true;
-		}
+		/*
+		 * If the worker is already running, it's either already
+		 * starting work or finishing work. In either case, if it does
+		 * to go sleep, we'll kick off a new task for this work anyway.
+		 */
+		wake_up_process(worker->task);
 		io_worker_release(worker);
+		return true;
 	}
 
 	return false;
-- 
2.40.1

