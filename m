Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5982F38AF58
	for <lists+io-uring@lfdr.de>; Thu, 20 May 2021 14:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239130AbhETM5l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 May 2021 08:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243502AbhETM4D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 May 2021 08:56:03 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB82DC0612A4
        for <io-uring@vger.kernel.org>; Thu, 20 May 2021 05:21:33 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso5290976wmh.4
        for <io-uring@vger.kernel.org>; Thu, 20 May 2021 05:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hAz2/9emyvpiOFArBhmcOHQF/YB22ayrOJym7tYyK8s=;
        b=rymLsRNSNhUieLT1iImSe47/rdkX6zlCfjhrxHOPfyEBDishAF48rlCcnQV7lSF7pw
         dKWJONY0Yv0pH40Qd/FNfaJx/bAlfNyvA8vRpDzu0VDSw2RJefya86b169V+4nTm9ASh
         z8/DcPW1lWyln2falrBsPKEb1PKxv+tYd+gWsfR3/cR8RDbEtOfYUsP5G5tJrE059X6K
         0k7lgP+sMxtGhg9dWBNRCrbc5zkSmmz+FIMQFqXNfZcHfxLZitfDCDNDjzPZyQco5zLI
         mR0rAJHQwAye5YWnUEiBvyAKpa7rLzG1vxGyS1D/WVOStlXUawHchWhEnuY0ltsRGXO1
         LO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hAz2/9emyvpiOFArBhmcOHQF/YB22ayrOJym7tYyK8s=;
        b=jw3d7I4O2x5vQx2mG0edR4dA8A3/7M3wJ1x3fL+QAqx9YQqlwf9TrzMl9vBlenla56
         eNt8nY3npWIdoDClwpLs4yoIlfr+fS5mztI2L4dEAWmRYt0G8mv10/gk92WNe8zhWdT2
         xvfObcMyGvxKqaBrMorklYYyxGaObqiAhQ/9wcv1sCQsaKrPuzn77z8NQn/AARtkI/iK
         B0Ua702EdU74u6LHY9vZlZyCR0QJz9OLhFNmaufxCgGkumzLajWFmkyjm1oe7Bj0tWLy
         PaoajVCuFkL+w3VYwodKKe5xrqQWMJC2NX3BNsi83bGARUAD2gclwMU/SQ077udq96AM
         G1VQ==
X-Gm-Message-State: AOAM533wsGrbpQGuj5hpJHt0KWgr0sCsyH0q1tbPDKhIEJ70JVrsYUbO
        e029aNtvGiE0/D3NBsnWSSk=
X-Google-Smtp-Source: ABdhPJzZaR1Kqt4UbGdopJ/MRl1OR0N0//kJhdTvNBj/LcOAgspjAdyWsXUg4mgnAjfCo54d0fZPwg==
X-Received: by 2002:a1c:bdc4:: with SMTP id n187mr3756119wmf.175.1621513292571;
        Thu, 20 May 2021 05:21:32 -0700 (PDT)
Received: from agony.thefacebook.com ([2620:10d:c092:600::2:3d21])
        by smtp.gmail.com with ESMTPSA id x10sm3025048wrt.65.2021.05.20.05.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 05:21:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.13] io_uring: fortify tctx/io_wq cleanup
Date:   Thu, 20 May 2021 13:21:20 +0100
Message-Id: <827b021de17926fd807610b3e53a5a5fa8530856.1621513214.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't want anyone poking into tctx->io_wq awhile it's being destroyed
by io_wq_put_and_exit(), and even though it shouldn't even happen, if
buggy would be preferable to get a NULL-deref instead of subtle delayed
failure or UAF.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 89ec10471b30..5f82954004f6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9035,15 +9035,15 @@ static void io_uring_del_task_file(unsigned long index)
 
 static void io_uring_clean_tctx(struct io_uring_task *tctx)
 {
+	struct io_wq *wq = tctx->io_wq;
 	struct io_tctx_node *node;
 	unsigned long index;
 
+	tctx->io_wq = NULL;
 	xa_for_each(&tctx->xa, index, node)
 		io_uring_del_task_file(index);
-	if (tctx->io_wq) {
-		io_wq_put_and_exit(tctx->io_wq);
-		tctx->io_wq = NULL;
-	}
+	if (wq)
+		io_wq_put_and_exit(wq);
 }
 
 static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
-- 
2.31.1

