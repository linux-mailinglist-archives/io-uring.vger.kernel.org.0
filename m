Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3048643475D
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 10:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhJTIzZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Oct 2021 04:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhJTIzY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Oct 2021 04:55:24 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CC1C06161C
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 01:53:10 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id b189-20020a1c1bc6000000b0030da052dd4fso8393617wmb.3
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 01:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4giO67OyaI7jss5Kv99M/4BSgGdJR/v+BeORfRvtrdY=;
        b=gFKoEyFYayRCS04ROdc3IYkN4wimH4+n5BJALHuV+7F0b96APQCDUg3wiajsexlJCC
         yp9Dy9yoyDKfK+ZJY4OQz4wZCqgisa4IW0iD122oA/xBkeYf/nq4dWKE5kf7aIcKkamH
         tscGt8ah6Um+vBzEBGDpAicyz1m7eJ1+k3Cz8u+9l6nYHyXASrM7xPpybxujh1/x9roe
         f58EPkKsQReiPigfHEg+l84SCoKbrBgGTsYhWSB/Ah1gtQu0uoZEcaKlQRG/ukX/77Ap
         EcKAlPZ8MeyjQ4Nq58vN7N7WgDTcDXiJ6yJAYGv8AiLK0INDhnZ806R4Wwr6SgypftUO
         mUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4giO67OyaI7jss5Kv99M/4BSgGdJR/v+BeORfRvtrdY=;
        b=c89irsRaa64sLSNy8DFfNSnw1FSgkezej/Xj3w+RZFVDOx3GOMbPhVMz47CUe4PlX5
         i2TdWf93I23mSz0Iqk06LF7+WIxnSa5zCYJIor4zOUh0lp6VLByC+nGpBO98eWNALdpY
         dZqZqh5I0kSTvT+dFwOgZzQansWjstnW5FegLLuhqYfIT1dlqxuedYnEbhs9rz7pE8qk
         Viev58x1O8WV2M37kzGQ2iIbWO0IzyuwjzUnjy4dJ2WHWXm0G3/ZRAhvn2M2IvDOCq4i
         XdQvfnweZgch6IUGktFSVTXZ5T9Z5b6fPjhYWNrgz7d1QmLv1Pj7s3tefR7G4fj0mFhX
         Ikbg==
X-Gm-Message-State: AOAM530XwbJScxvUGGIDSOpkuY1KLD+k1Qov4ErfPvAZKKFUdJc03imW
        OrvgrOKbxi8uoqYT/H0JvamxGXMmCH4r8A==
X-Google-Smtp-Source: ABdhPJyL5UK7yZ9MYRu00Izl6EyO6ZZR9wqTaFzehtD9BOdfPphbNyX3ViYbQHzV1o+lNJpoYZ5pDg==
X-Received: by 2002:a05:600c:a0b:: with SMTP id z11mr12691357wmp.147.1634719989147;
        Wed, 20 Oct 2021 01:53:09 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.145.194])
        by smtp.gmail.com with ESMTPSA id r4sm1715761wrz.58.2021.10.20.01.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 01:53:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Beld Zhang <beldzhang@gmail.com>
Subject: [PATCH v2 1/1] io_uring: fix ltimeout unprep
Date:   Wed, 20 Oct 2021 09:53:02 +0100
Message-Id: <51b8e2bfc4bea8ee625cf2ba62b2a350cc9be031.1634719585.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_unprep_linked_timeout() is broken, first it needs to return back
REQ_F_ARM_LTIMEOUT, so the linked timeout is enqueued and disarmed. But
now we refcounted it, and linked timeouts may get not executed at all,
leaking a request.

Just kill the unprep optimisation.

Fixes: 906c6caaf586 ("io_uring: optimise io_prep_linked_timeout()")
Reported-by: Beld Zhang <beldzhang@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: rebase

 fs/io_uring.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e8b71f14ac8b..d5cc103224f1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1370,11 +1370,6 @@ static void io_req_track_inflight(struct io_kiocb *req)
 	}
 }
 
-static inline void io_unprep_linked_timeout(struct io_kiocb *req)
-{
-	req->flags &= ~REQ_F_LINK_TIMEOUT;
-}
-
 static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
 {
 	if (WARN_ON_ONCE(!req->link))
@@ -6985,7 +6980,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 		switch (io_arm_poll_handler(req)) {
 		case IO_APOLL_READY:
 			if (linked_timeout)
-				io_unprep_linked_timeout(req);
+				io_queue_linked_timeout(linked_timeout);
 			goto issue_sqe;
 		case IO_APOLL_ABORTED:
 			/*
-- 
2.33.1

