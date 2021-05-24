Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400F738F680
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 01:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhEXXxF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 19:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhEXXxF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 19:53:05 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002ABC06138A
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:35 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id h3so2960676wmq.3
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=i0G4W628X7owgeHUreL3p9W7dk2G7WvdEdFqkEl81QQ=;
        b=XXlk0N28D6bhqSolsOx79zfILJnNLsesPNJKxA0t136LBTB7zVw3Bphio12jljwSXP
         0LIOraDyhf+a2xsXyjc2zdYkuz6Ts3v7Tt/aq68J7lKgQEkJLCa6rUVl3L1grbA5LoQP
         zoqWH+Mk8Ck6KJRpHJNLgkAiAM/rvZ52OAQ7uOJ6UU5mwe3n/09QhpTdcUk/+rErW+rx
         Pvmbw7g2Pw+bJZ/XyaEPGSn7yhSuRBgLb6weBMJmbAFzSk/Neon14ULwUW4BSdCk+D3a
         0YCDOwqp7LhutI5fxMdT2WywsFd673nQHFr9RYS7MyXCehUe3KFJsTvlppT+PkUfVQAq
         mdew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i0G4W628X7owgeHUreL3p9W7dk2G7WvdEdFqkEl81QQ=;
        b=psiQnKWGTKodivXvzRkNO70SGRD9iUmQm6pKgmzgZe+X2UK6Ok41KMecGvuJGAuSzZ
         upAV/oZzKP2QJRVV1top8JD6ifUMe5hDwjLeDNjNWNV50upiq2djZ9sVesUORgWsY02G
         4orU0D4Hib+ZErvEaZCjTQIjUVA0QUb/QzHMYtJbncUydOhsyS/T+dU+KIoAudW0liPl
         oiVgJuk3iCb35Fp7rafpGVZAsaHeMllG5PorFojoj+PONI1/Vsgh8n9dwEvdxCI4YvK0
         Sx/dVdLwhTpFWQysQDm266KNkagT9y9NuPYHKP1TYiITOOBQtTjOJJI83NRdXAroYPuG
         gssg==
X-Gm-Message-State: AOAM530PL24dnpLSHPtUMaAAYxnexMljnpaiAAUx9ZDa7pHza8eFdoeF
        TJobx+uR7j8x2VeVnPQDDuRPjI4lP5EO2jiF
X-Google-Smtp-Source: ABdhPJzZ8GEEcsRA+oo9UPEbjyL6wwlEsoDbxdbUrCJxaSYlBs0hPxMlkiEBy32ww6Fz9N2jRvLW7g==
X-Received: by 2002:a1c:7c0e:: with SMTP id x14mr1141455wmc.41.1621900294689;
        Mon, 24 May 2021 16:51:34 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.116])
        by smtp.gmail.com with ESMTPSA id f7sm8961069wmq.30.2021.05.24.16.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:51:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/13] io-wq: simplify worker exiting
Date:   Tue, 25 May 2021 00:51:06 +0100
Message-Id: <36a443771b9be95a8b67e3fc1353d8f52bb90194.1621899872.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621899872.git.asml.silence@gmail.com>
References: <cover.1621899872.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_worker_handle_work() already takes care of the empty list case and
releases spinlock, so get rid of ugly conditional unlocking and
unconditionally call handle_work()

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 27a9ebbbf68e..c57dd50d24d9 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -566,10 +566,7 @@ static int io_wqe_worker(void *data)
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		raw_spin_lock_irq(&wqe->lock);
-		if (!wq_list_empty(&wqe->work_list))
-			io_worker_handle_work(worker);
-		else
-			raw_spin_unlock_irq(&wqe->lock);
+		io_worker_handle_work(worker);
 	}
 
 	io_worker_exit(worker);
-- 
2.31.1

