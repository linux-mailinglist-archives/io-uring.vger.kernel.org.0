Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C8534B5F0
	for <lists+io-uring@lfdr.de>; Sat, 27 Mar 2021 11:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhC0KGA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Mar 2021 06:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbhC0KEh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Mar 2021 06:04:37 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3803C0613B1
        for <io-uring@vger.kernel.org>; Sat, 27 Mar 2021 03:03:43 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id k8so7974428wrc.3
        for <io-uring@vger.kernel.org>; Sat, 27 Mar 2021 03:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mhoga4ncDUj6ZYW4hlnq9oX/N+msNI79dV/aGq+PC30=;
        b=huMjvc8qi1oz90cBEjLgXJiVgvP6kY9iGQCoA2zniAuEfCu7/HfIkh3nkWqObgdOcI
         SPsJkQ1JLTffYBYdkFeEpXUODHbYhs/I+0da1Lxa5aTPxapmfWPSJq4NK0rsAy589A9p
         JLbnpTi/T7SMaT1u7odW4hFXc/vBhYKSxi/uowLMFF3PeJ1FuUNKlssanHsjTRwBW7AP
         mP3zGPXKnQlEOkOUuwn7G8NCoqOE9ki4NFUTtt06OfLt43QTi1wqbiGnF0d8zWPOyHSu
         6WCqXtxgof8W3cSihAHDUO7mdaV3FVuULjYJy/SpZyxJqUeViTIJGlvg5DHyQNENeOi9
         MIHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mhoga4ncDUj6ZYW4hlnq9oX/N+msNI79dV/aGq+PC30=;
        b=Ap9Dat7FFc6WH2n68TlE40xQ3CPrkIPsk0XEQsVR6cZbZscECfp1M0/KOGpPGYi6Gv
         FeAjdQ4Z174Y/MZEus7zoxoeF4Je0bqszmRW4mfPNwj8iLlBL+HfYGTs1oa5lmhqgXia
         daIICQ8yNQvLd9fCxwd6KUNxmdAOPfTUE2exMqIVqSoolV0EaBOG0HrZFu7xpW4g5zAI
         LZld8D3TpObrY7rQ92w7mpVPfdRBQemztSNwzHZksUVNvgN3z+fXG9ztJ3HfOPQYVuA3
         SVMMXEdKD/p4e+XLS6MGn+1JsxBbD4ESRZtAralN/fojEAevD1UB+HErrhZd8kKMwM2m
         Txkw==
X-Gm-Message-State: AOAM531XVlbwDzPEyDXmbbvhd3Oz/u014kDWcEHV+MatmeZVAJei+qTB
        sBLiayCtgRKqJKBI6upLCE9crjNAwRTI3g==
X-Google-Smtp-Source: ABdhPJzSMxw0km+4/imVytaXLu6d1CiA2FMgzGqdqzn8sZHnLgu9RO8bFbhFJDfDKQqa+ajRTbRIDQ==
X-Received: by 2002:a5d:684d:: with SMTP id o13mr19327871wrw.235.1616839422656;
        Sat, 27 Mar 2021 03:03:42 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id q207sm16374928wme.36.2021.03.27.03.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Mar 2021 03:03:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12] io_uring: always go for cancellation spin on exec
Date:   Sat, 27 Mar 2021 09:59:30 +0000
Message-Id: <0a21bd6d794bb1629bc906dd57a57b2c2985a8ac.1616839147.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Always try to do cancellation in __io_uring_task_cancel() at least once,
so it actually goes and cleans its sqpoll tasks (i.e. via
io_sqpoll_cancel_sync()), otherwise sqpoll task may submit new requests
after cancellation and it's racy for many reasons.

Fixes: 521d6a737a31c ("io_uring: cancel sqpoll via task_work")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 66ae46874d85..0bbfb05572d6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9004,6 +9004,8 @@ void __io_uring_task_cancel(void)
 
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
+	__io_uring_files_cancel(NULL);
+
 	do {
 		/* read completions before cancelations */
 		inflight = tctx_inflight(tctx);
-- 
2.24.0

