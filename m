Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74252202A01
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2020 12:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbgFUKLo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 06:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729784AbgFUKLc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 06:11:32 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A374C061795;
        Sun, 21 Jun 2020 03:11:30 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id dr13so14919026ejc.3;
        Sun, 21 Jun 2020 03:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=LTC8WIRe2SvRxOQDsI5QqZufGpx2iiQGCpDsMSVsUVY=;
        b=P7vxIP2dRSkGnsZkQwzSa7GefIC2hru2h68cDu5Uo7PBRM4AsrmY8czlHgELNHVbaK
         5RfqADGiCEbw5lw/U64Q8Cr35/JSYgKxzu7BvUcwczY/oUnK8hRyFl4YNUuqLtpc+PMu
         hajFN1t9jWDKTGKRJh+3/BzLLdLWj/UQ6IRxdL6wPi3Q9vmMRMYlvXxIqSpTWogAzznm
         L+WOALX9alaaSPLDITAWHRjo5qK7cRNRnp47HhRPeL9dBXDE6umdRZmIDlm0hdoAcwsc
         BcCXmVAeJYvpAeuVPWMGa/TgX2+WZG6ibRP01+jr+xV6Sfe3w4E8UCBGPo2PnwlADf8+
         +eLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LTC8WIRe2SvRxOQDsI5QqZufGpx2iiQGCpDsMSVsUVY=;
        b=eSDbgZ3+q1Hoxe/ug4Kcp6apY/ZDKQREV2wrCYQnBV43acN4wc4wf4QZWH/TDXQX+M
         76rDjCWf5cEr04BGUUK8U1SRqyXvYRBoe8JI3YbTeLhp4aqIlbB5HyLBXqGQvkwVcVY2
         0NmGDkbUBCAnITWRjAAKIaWLNt/6HaWEvQI0ycZLHumV3D8mAPNWM7SGblZYT3sOPjb8
         01/G5OAgRD7HCwcgu/YKFqckFzJih/cGoCG42pzTo4FO5sFI7xhZu9f9T0gHGx9dTFVz
         Rna8IsIUN71fXF90czEI0kD7L+6JSxXsMJ+48FY0qAq6EZor9j4EeUHcd4+zS/MJPPlM
         oKxQ==
X-Gm-Message-State: AOAM532vtDrHpYD/3ALnttck+Y94RX9KdJesNgSQIEn2aVeL148VkPSv
        hN98fLwcQSWk05Mn4nDtsFQ=
X-Google-Smtp-Source: ABdhPJwnbXfowAWtAtEszmu4NOD6C9xbGgQUSWBvEX6Emf5CNpXm+ytOuJBMUGgMSx12okmRVHhfxg==
X-Received: by 2002:a17:906:7e04:: with SMTP id e4mr2817464ejr.502.1592734289177;
        Sun, 21 Jun 2020 03:11:29 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id y26sm9717201edv.91.2020.06.21.03.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 03:11:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] io_uring: remove setting REQ_F_MUST_PUNT in rw
Date:   Sun, 21 Jun 2020 13:09:50 +0300
Message-Id: <c302765282443434e8a0dc4a83f73bf2b5c7845c.1592733956.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1592733956.git.asml.silence@gmail.com>
References: <cover.1592733956.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_{read,write}() {
	...
copy_iov: // prep async
  	if (!(flags & REQ_F_NOWAIT) && !file_can_poll(file))
		flags |= REQ_F_MUST_PUNT;
}

REQ_F_MUST_PUNT there is pointless, because if it happens then
REQ_F_NOWAIT is known to be _not_ set, and the request will go
async path in __io_queue_sqe() anyway. file_can_poll() check
is also repeated in arm_poll*(), so don't need it.

Remove the mentioned assignment REQ_F_MUST_PUNT in preparation
for killing the flag.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 44614571e285..e7ce1608087f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2915,10 +2915,6 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 						inline_vecs, &iter);
 			if (ret)
 				goto out;
-			/* any defer here is final, must blocking retry */
-			if (!(req->flags & REQ_F_NOWAIT) &&
-			    !file_can_poll(req->file))
-				req->flags |= REQ_F_MUST_PUNT;
 			/* if we can retry, do so with the callbacks armed */
 			if (io_rw_should_retry(req)) {
 				ret2 = io_iter_do_read(req, &iter);
@@ -3050,10 +3046,6 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 						inline_vecs, &iter);
 			if (ret)
 				goto out_free;
-			/* any defer here is final, must blocking retry */
-			if (!(req->flags & REQ_F_NOWAIT) &&
-			    !file_can_poll(req->file))
-				req->flags |= REQ_F_MUST_PUNT;
 			return -EAGAIN;
 		}
 	}
-- 
2.24.0

