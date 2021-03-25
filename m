Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103653492D1
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhCYNMe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbhCYNMa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:12:30 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79E6C06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:29 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id v4so2198065wrp.13
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SM67bliCgPjbQsU0EwBoEioUpb/9N9mFg3JVdXGaaGo=;
        b=oVzdNHK2VNFfguvu35kmTTfeG74ZmXBTqaaehuIai9EaoF1boTJWub1y6b2hiF8lRK
         VjudJhKWnCzSXlPjbVVRIjuZzbfkpO1/TAO7lUjRnGDKaaR1+sjV5bZJ0SWGaVT99xkX
         BIJk45Lw3HjBXQsgecYFikbY5sjFWPabF52o3aykdl35FVem/debDvyC+AMgjZPb+A42
         pt1OvvC//5FCQ9ByzQyLmiRPVgSLHeBfc1aTXzZcyqJ8lBWysn1VK72AOAEI5/lYO+ZV
         srzNYhVlNvA9L2d14RIvPMCSMGhWMWpitdEh+csByAkFpTrN+SrfqbEcXD0IaNGAQ5h3
         Wohg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SM67bliCgPjbQsU0EwBoEioUpb/9N9mFg3JVdXGaaGo=;
        b=ghVWBDVUj6NT89Apaca5mfzSwahz249Xw8HVxsDGzOmBO4bmN8tf2NiqngBOKX9Fic
         9WbjovQQUfkEbPDaxIRqeii/QzeoIiPTbgPyCOzsK6E00xVfIv7F7B0g2y6Xw6nFqJM6
         TsL+aFFTx3I23VDTskDZBGzWg22nHHTJwhHNWJ8hvRwWv4X5UI3jejN67WovR9hmOwaG
         Bi701ajll6Q8S5Vpr4qr6DZHM6w4WwvooxinFm/iZAaZYv74Hb+3+p74hL5VzZyMhFmC
         Vblwml52FiKE1yoAAO+tAtfTijcNlzkVloezPX1vMh2gf2hrRUZ64ffKl+/VG/KyS77u
         yeIA==
X-Gm-Message-State: AOAM5318t/gKalF4MDNV4aIbe+TOQDfWUvlZojxKFVqygY84OXXdxrL0
        ZVR3hzy283zBzXEFfAQ1/sg=
X-Google-Smtp-Source: ABdhPJzE1cX4GbOrak/M+yxl/xWUdqzXMQZEefSPprNTzMcH4sq1h7Pza5iveoQB4ezG4HlFh2Pdiw==
X-Received: by 2002:adf:f4ce:: with SMTP id h14mr8809756wrp.257.1616677948488;
        Thu, 25 Mar 2021 06:12:28 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i4sm5754285wmq.12.2021.03.25.06.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 06:12:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 14/17] io_uring: refactor io_async_cancel()
Date:   Thu, 25 Mar 2021 13:08:03 +0000
Message-Id: <6ee835b2e57784ab3d8b0a827ff1d0de71f20994.1616677487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616677487.git.asml.silence@gmail.com>
References: <cover.1616677487.git.asml.silence@gmail.com>
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
index ebd152b1cd6d..b324f7c7a5cc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5696,8 +5696,6 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		struct io_uring_task *tctx = node->task->io_uring;
 
-		if (!tctx || !tctx->io_wq)
-			continue;
 		ret = io_async_cancel_one(tctx, req->cancel.addr, ctx);
 		if (ret != -ENOENT)
 			break;
-- 
2.24.0

