Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA66351BDB
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbhDASLh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 14:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238085AbhDASFY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 14:05:24 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E05C0045FF
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:32 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id j7so2117447wrd.1
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=6vNsxzzdQBpD3WSNpgkTA5459Jsgdzq6EQD/NZyVvk8=;
        b=bC0xl0l1SUcAynNAuV+WItMevW6u3BVwE+AWdUFlXGnrczzpY4arkLH46H/IxnwMPv
         EbnrkBLSy2vwrZVwp1xt4B1tIBBKkJIa3X3U2ST1kjzqbvN1A/iovVrIQz7548f1SbrA
         lladWMUUrGxe03HcpYx6+qbKzG4+NDQzpLfSypZKaOuFgsJQsnfHfYrL+Qn3fy3pcrii
         6Y6ikirVJG5A54g/o5Ps4Rj+aZpk6JtHi6iHBYrUNuknDr7FHH/ELVbH8ISxPj+B4doF
         GsTYNntOwtaHAUXyR30EJE01NOT3nhknZXGxMEgWvTWGK+nnRJFiJkSRdJHmVfX9GkTb
         vUpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6vNsxzzdQBpD3WSNpgkTA5459Jsgdzq6EQD/NZyVvk8=;
        b=b8xJskqUWkhlS64ACr3Kjl/5lvh2CxoTOitYEfFmhgqIMO+bcvy393WTEtzx69/gO5
         ykHsBRG+6lkRK9lQjw3vkGESrCum2NzHTmxaPVEw6olyo0VFy5+0RffvZ6eslDr2ydoh
         bAyqh56Vd7KROYeOoIqciLVN8Cs3Ar17IYKCFizT5D8lsrQ3vCtc73zX9W+dtELmWSGU
         8MUDtGitNpQHgC0gH63KCLn1SZueJDoJpez5apnPfWM17vMyJO4Lvr/Z1YaJ8sG8i+Rm
         P5F4v5MTPK9L6xBGvo30TNeS9S48ziz2/RzZHa8X5ua5rTTRxVr01WF6XFTCUMZ/StZs
         mWpA==
X-Gm-Message-State: AOAM532yMWKrjb8Vz3yQ8mGm3LeqVpgChpXnhrAGzc+LvmnosS8GG45q
        MN7PQVw3fGxmztiMtwKkvYrJU1qVDR7c5w==
X-Google-Smtp-Source: ABdhPJwzRAowhTCMvzWvPHNZdsx/Vsp+HTwUy1l6q4QpxkIqkC44PrIjN69eBsGIyWxRUWpZG1+8KA==
X-Received: by 2002:a5d:4564:: with SMTP id a4mr10148584wrc.3.1617288511493;
        Thu, 01 Apr 2021 07:48:31 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 14/26] io_uring: refactor io_async_cancel()
Date:   Thu,  1 Apr 2021 15:43:53 +0100
Message-Id: <70c2a8b958d942e86958a28af0452966ce1095b0.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove extra tctx==NULL checks that are already done by
io_async_cancel_one().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4314e738c2ad..c3cbc3dfa7f3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5804,8 +5804,6 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		struct io_uring_task *tctx = node->task->io_uring;
 
-		if (!tctx || !tctx->io_wq)
-			continue;
 		ret = io_async_cancel_one(tctx, req->cancel.addr, ctx);
 		if (ret != -ENOENT)
 			break;
-- 
2.24.0

