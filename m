Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3087A2B929E
	for <lists+io-uring@lfdr.de>; Thu, 19 Nov 2020 13:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgKSMeS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Nov 2020 07:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgKSMeS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Nov 2020 07:34:18 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A15C0613CF;
        Thu, 19 Nov 2020 04:34:16 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id cq7so5644655edb.4;
        Thu, 19 Nov 2020 04:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Jaq+P4eBoyJUMxEqSu5b2JliRug3DQf4OBmXnABJNo=;
        b=sMX0jALzP3PsMDnPCcjo6q30KhLfs5BVqQDMHuVSZ8Q0dSedCyr4XDHozWyma8ro+3
         F6DI5k9siD0HFq7lP3Pe+z9ZI+ZY5XfJdBN4u78aKau02ip5tfzvpo0U4xq9jxP4XDyv
         ROnmEvqizgOg8VZF2DsgLHdsnl/kPt0BMTz1qhtTjZrr2jIGmCPX0qMEVKiPhEQKuUg4
         TUsaDIXgJfrUKhgMDleo8fWqJydG6fqsF14sRadFsQeuZUxrG/uSRS73abDTP9zthf/W
         rol1pz3G2xooWruR+Pmyd89QCsorC8Ee4G9CiCF3EEPAyPqfLr4KLo4YxqNUiAkjQFYB
         FHQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Jaq+P4eBoyJUMxEqSu5b2JliRug3DQf4OBmXnABJNo=;
        b=Bkf+Ps4VI7oW27HXG9ou5CP2i021H0v9ZiM//a6R4JlpaOVn3kbCLtN0e9h3TE/t3b
         /EX6mm7GDUzYcRZAKpUjkdA+5xqMdrRLj3jgdmWsR0StpLn1Ex1IX65r6IJ10+i4EuVg
         c1rB84H7ACiPC/hXHsLsK2dJdv3fmBavaZM2+SsiBI5RPJGk+w65QN+yGdO4IBm2whoA
         DOQm7h3JzJa37/1pG46BrkEWgxxQG8DVK/jP3jZtpeDHw8V08YPIia67x4x3nL7gfoa+
         8aK676Lmoc8W/cKzpvY1Zcipx1R20FYgsJBWEoNrjLbLtTgUHNFXcYVl2FSGE5pT/Zfw
         MbkA==
X-Gm-Message-State: AOAM530d4ekd5fnKR55KMKDJ0D76r2GTV+xPNi1MoK1E7RkfOg/WLZGh
        WTFQehZtJU1DVTYhkkWv6tw=
X-Google-Smtp-Source: ABdhPJzCFSRHOc15TIYWevGNHxidPWzf9TrVZoRwTEl6KgN3zRp68JFMOW8ridm7OpXhs5lqJiF3hA==
X-Received: by 2002:a50:9ee8:: with SMTP id a95mr1834544edf.351.1605789255575;
        Thu, 19 Nov 2020 04:34:15 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id l20sm14500091eja.40.2020.11.19.04.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 04:34:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: [PATCH] blk-mq: skip hybrid polling if iopoll doesn't spin
Date:   Thu, 19 Nov 2020 12:30:57 +0000
Message-Id: <cb5e5c3bb9ac13ca7e1026ceb484c03c0367e14b.1605788995.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring might be iterating over several devices/files iopoll'ing each
of them, for that it passes spin=false expecting quick return if there
are no requests to complete.

However, blk_poll() will sleep if hybrid poll is enabled. Skip sleeping
there if specified not to spin.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/blk-mq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 55bcee5dc032..d72166c46a4f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3865,7 +3865,7 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 	 * the IO isn't complete, we'll get called again and will go
 	 * straight to the busy poll loop.
 	 */
-	if (blk_mq_poll_hybrid(q, hctx, cookie))
+	if (!spin && blk_mq_poll_hybrid(q, hctx, cookie))
 		return 1;
 
 	hctx->poll_considered++;
-- 
2.24.0

