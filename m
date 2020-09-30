Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A118227F2C9
	for <lists+io-uring@lfdr.de>; Wed, 30 Sep 2020 21:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgI3T7q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Sep 2020 15:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgI3T7q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Sep 2020 15:59:46 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611DBC061755
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 12:59:46 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z1so3142582wrt.3
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 12:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bys/7epLqfhwFjLRik7WWynuCx3QpRkw3PfaDzmvNH0=;
        b=kjw69opy2euyDUwFCBkP1mpOtWmJ2Ec4Z2CRhP+l/TAYoYFrFRWMgo1rrBE990yoSb
         27DwAb+SnByX70VEKU9rjQts9JOC9XZkqlsQ+Cy64A0pHSZz1Xo7z1LuWGMoCQhajkvw
         d4iUTKq0DobsFyht1hbHYachsf5eBrS3OLByNvFrIFe52pqKfcISXVW952Q6q9t1CU9h
         52OE/HS7pSVtW49aIIFAXU0rTRXHNAFyzmfJrGAUZtlikXLDafrsR8aFPiLWGodTjvw8
         JzaJVyuF5GvzJNEAtC6EOdjMQOazryJtRQk/Vh29nl9TehswPxST10Q37YGAwBM1Bfr9
         +1hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bys/7epLqfhwFjLRik7WWynuCx3QpRkw3PfaDzmvNH0=;
        b=LLXGFPX/yI/3FDY4RMU0PIZhw311+kA5a/Wbml+vtJJzIpsrWjaNUOh3v/lV5d3/tx
         bJAN9BGwkc4avHDSWkACc68VINCpQpywMSG6Vi0tIduetdfQstBEH9UFc4L51EJNFmpN
         6Lr3+1TtN32OuLP3D46bqTC04fcPH26G52fzCK+adzxwuzYkPVo6tDjt8qDlcyhAsg86
         YmZbnbTOnhYBIdRHK9e5CWA+AdWtstsQ+D65HHhmz7YS8UJwTq1YcIIiq1+njakDhOGM
         wwumyiNEMX/G5XAYsvO1bvwHa2zur6VMuguneAFitVRpS5358jINkrJznBA3NTVnKQJi
         6V/Q==
X-Gm-Message-State: AOAM530o4/0O1wUZqxU8wzvtDvs330dUb0sQr6s3iIq6dh0R4o43lNpQ
        TFhYWiyM5lplcUXjvL3BWrcEH5O644o=
X-Google-Smtp-Source: ABdhPJxqMuxwmmig7FmaLqR+aiqRhCAtDKv5h53tzvyzIdx8BoV8dp1f0s1lSVAylTju2GFYewRDEA==
X-Received: by 2002:a05:6000:1282:: with SMTP id f2mr5167171wrx.251.1601495985057;
        Wed, 30 Sep 2020 12:59:45 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-194.range109-152.btcentralplus.com. [109.152.100.194])
        by smtp.gmail.com with ESMTPSA id u132sm592280wmu.2.2020.09.30.12.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 12:59:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next] io_uring: simplify io_alloc_req()
Date:   Wed, 30 Sep 2020 22:57:01 +0300
Message-Id: <440273832e0c2c048e8cba03a964b6a34504c4e1.1601492381.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Extract common code from if/else branches. That is cleaner and optimised
even better.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 33892c992b34..e13692f692f5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1568,10 +1568,8 @@ static struct io_kiocb *io_get_fallback_req(struct io_ring_ctx *ctx)
 static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
 				     struct io_submit_state *state)
 {
-	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
-	struct io_kiocb *req;
-
 	if (!state->free_reqs) {
+		gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 		size_t sz;
 		int ret;
 
@@ -1588,14 +1586,11 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
 				goto fallback;
 			ret = 1;
 		}
-		state->free_reqs = ret - 1;
-		req = state->reqs[ret - 1];
-	} else {
-		state->free_reqs--;
-		req = state->reqs[state->free_reqs];
+		state->free_reqs = ret;
 	}
 
-	return req;
+	state->free_reqs--;
+	return state->reqs[state->free_reqs];
 fallback:
 	return io_get_fallback_req(ctx);
 }
-- 
2.24.0

