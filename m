Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F5C3F02F8
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 13:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235943AbhHRLoE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Aug 2021 07:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235830AbhHRLoA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Aug 2021 07:44:00 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7FDC0613CF
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 04:43:24 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id k8so3060579wrn.3
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 04:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5w/kE82Yz3dT5tUz57dXIgCPKRi0ouLSWddkiiwLQUM=;
        b=PJxaslB5dM4RxSXaMevKEBOlrY5sH7KLEGRCR0trwabfFz3bw/m7tTZRjmFLZ5V1pf
         I3vu6iyTHqMKc1Y0Rcfs3msxSTYwcgFKcoHcL2GaHvnSiOcmMD3RYiiS6Iw2ZUAWi0Qy
         UX9ZtpnAw/hZE574P/hC9aIHOGWSjslxFjDfBLhLdM3bpM12NpmiZfcuNnAMPr3QoGfn
         ProdYpwagggyYt6owUQe35Shc0/TiaGEhD3N/z++e6NQyxv+H+pEhU7vrQyOEgtwofYd
         0uJF3qT9MWmUhPMTw860UQSJ3bmX4ddYaqPP5daWCIbYbMuANuLboUjxd1bTbEOJ044a
         1Yfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5w/kE82Yz3dT5tUz57dXIgCPKRi0ouLSWddkiiwLQUM=;
        b=OV3SFoHkawKz7occkr3TOfax7cqSnZAy4rF7gf2trzMneG+qpsZLNoBZ1xX6sVC9Yo
         OJa5yulhlAXM0LyTAIjOUo+A9M17toyAtIWzT+qWTyVVvTVxv/7bs2uIDoLe+7VMJcMh
         UmkZ6xWh7jnwAyrAvrtu+6Brh8tSoF/pHRar5aKgAHZhNHroJ7mch7LLx0pIa6g/Vdlp
         5VrAKKNEfrmqobQ3swWVErIbk8ToVm6XRfOTayPYHoW2rojLkR/FlYN/C36aGTVZjOFk
         4vj3Irod7vAxfaF0cUhH2ix7huGhv4s08CT8qmTKnx/nRSzcX3hMx4QGNgCuvK6o92Xb
         5S8Q==
X-Gm-Message-State: AOAM5313fqd8v1P/kEff53/AUwLq6/d9+xFT7F+uGZFKAERVp7NNBaZw
        cKMeiFIKyCkA5JX5vpB99aw=
X-Google-Smtp-Source: ABdhPJxhEAc8ptnMiA9OUMUn8b0XaINdtgPSRnPMsSqEaCHUgG/5rSofNzStlVpJw5BWE8UOGlROeg==
X-Received: by 2002:a5d:680e:: with SMTP id w14mr10071417wru.57.1629287003481;
        Wed, 18 Aug 2021 04:43:23 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.2])
        by smtp.gmail.com with ESMTPSA id c7sm4581918wmq.13.2021.08.18.04.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 04:43:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: flush completions for fallbacks
Date:   Wed, 18 Aug 2021 12:42:45 +0100
Message-Id: <8b941516921f72e1a64d58932d671736892d7fff.1629286357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629286357.git.asml.silence@gmail.com>
References: <cover.1629286357.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_fallback_req_func() doesn't expect anyone creating inline
completions, and no one currently does that. Teach the function to flush
completions preparing for further changes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3da9f1374612..ba087f395507 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1197,6 +1197,11 @@ static void io_fallback_req_func(struct work_struct *work)
 	percpu_ref_get(&ctx->refs);
 	llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
 		req->io_task_work.func(req);
+
+	mutex_lock(&ctx->uring_lock);
+	if (ctx->submit_state.compl_nr)
+		io_submit_flush_completions(ctx);
+	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
 }
 
-- 
2.32.0

