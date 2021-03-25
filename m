Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818C83492D2
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhCYNMd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbhCYNM3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:12:29 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DDBC06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:28 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id d191so1155268wmd.2
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0pv2i8HwWdb+1JMrkjc2WY5gR9zbXXwUWVMaRZpvkFY=;
        b=XURxfK4dJJVZW438lDmmrM5WkLCnovM57MmOxJBIR4wKf9G1giPvQ3vrY9XkP8Uob6
         V+7h8iPClRx7I0zwYhtBIgIqtAo8cA6jvAUAsD+TPPS/eKVd7cy5tMVeqtFKuHLZ7yb3
         kRurp4kAgMR4ccMndoFKdKW0QcRhs4GAcSL2GUHNRJ4TcYychMJADGE76iJ81n+vVJCj
         Gk9ZYNfPqxbC9gKg9xfig+vDaSphEsZ/lVNe7twZ2h+h2XGrcTEEUTpFxdQgi8Dy/22L
         00WZQVKR6Re7duHmjzM1IIOh9FfTmgjibdn27K2JOgnFg6+Gsa+mqBVNLEH4qU1z8x4I
         m+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0pv2i8HwWdb+1JMrkjc2WY5gR9zbXXwUWVMaRZpvkFY=;
        b=ukkTCPJejEd5m/9OIfLoG66SRqhgFtqwk+WZDFHRpPGWzK4zzbNRpVWn1h4A68yXVg
         j0zexWBhbL/DuFEjkb2Qfy3tNdAi6gQfmMQ2Hu0AJt6y6R0fputzImsLZvD3nSrcRVo2
         c4gFVkzv+IRk8nWzxQLy4UAnYAARhnXWToLnyzw+5AUGtGiO3iRRRTkq7+JSgEnZD9qj
         Wg+OE1jBV0zj6o82ssk+1jvKwTIKELfsBEN7B1b5d/mWBE2fZQLvEu3/6Dv7ZzRfR0N8
         Rut2WpJVUeAvEFpQHXFobPhZa835NgI6l0m/1Gh1paXF9gHm5lTbGhFKy6OmMyjrEvfq
         nUjg==
X-Gm-Message-State: AOAM531htJK5hlSPUNPi3T+oFjoPis0LjnWyS5aM1NrBPt9DDQenMz/p
        eS1XCGOc4WihiX/aMm5IhHE=
X-Google-Smtp-Source: ABdhPJyzI5YvNbrJr4SPafrQxGeK86Q4TMcTb99QtyAgNSSoLdNhE6S8vrWBNeuzww8oEId0gpeI6g==
X-Received: by 2002:a1c:1f4a:: with SMTP id f71mr7938526wmf.101.1616677947611;
        Thu, 25 Mar 2021 06:12:27 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i4sm5754285wmq.12.2021.03.25.06.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 06:12:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 13/17] io_uring: remove unused hash_wait
Date:   Thu, 25 Mar 2021 13:08:02 +0000
Message-Id: <98a0def45ec985b903e442733b04b48e61e7be72.1616677487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616677487.git.asml.silence@gmail.com>
References: <cover.1616677487.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No users of io_uring_ctx::hash_wait left, kill it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a4c94dc7edc8..ebd152b1cd6d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -451,8 +451,6 @@ struct io_ring_ctx {
 	/* exit task_work */
 	struct callback_head		*exit_task_work;
 
-	struct wait_queue_head		hash_wait;
-
 	/* Keep this last, we don't need it for the fast path */
 	struct work_struct		exit_work;
 	struct list_head		tctx_list;
-- 
2.24.0

