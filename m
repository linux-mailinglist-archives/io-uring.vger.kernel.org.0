Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84991424077
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 16:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238440AbhJFOxL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 10:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238436AbhJFOxL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 10:53:11 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE0BC061753
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 07:51:19 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 133so2711249pgb.1
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 07:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w10ptv2W+0oTgVD0G3IWeJmlF3BwCg8bYeSUolmb3ok=;
        b=B+z3Z+pDl1gb7dfRGYBaVFXNM+LQbdkrAvirTxwxnx5h9wmSWr9ePlQgKi7Qxcb8pl
         ovTORcV/hYzreoQN4+V3d9vvRdYzXy5yfz5iz3B42/FPOOXDUr3yE7FkDZvExRw0Gfd6
         TqHRgG4xpl9yTUiwBtT03NTivBd5+KCdKe8pI56fhBCeFMH8QMd1F8Iz33FNmNopd8Tn
         tZFp3r6yakvuwlFgHubFMiUobvhI/XJ2sn079ZD2lVTOkZzEp2n3dNT/jrMbOrPbh8+x
         x+kERB6C2kJ23h/Nuch9PeW2aWvfG8ywXHLaINHAvJqTmjztwrlllVL7CRQsnuBNOBP9
         UwIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w10ptv2W+0oTgVD0G3IWeJmlF3BwCg8bYeSUolmb3ok=;
        b=sBHdofUpjpSb6Qts2rZU/x8P6LohJeqgTb+A27iKSnvwa8RgNi6Mgbnp1CE3/y99Jj
         GAbLwazkElIUQ9p0IA28bSzW+cS19lTNJpo0Bjy/Y9p9TxcAaQglr7SCMnht7GIBgmiz
         T1DWGCOVbWb8zNbFz+0AFVn5ily66zW+bQtyvZv7cRZzpm1ECVp66GZnuYbuFTAuKUXg
         v6V+n1hPaq3aXgCXow5mi1kLBt0ajdgmIIbBfbr5v1MiehEpLR7A1TV89IoPjZCJCVVP
         EEFS6XiI+EuUTLAM6XW4Sdm0ijvlneflhHI0DCJlPadrm4i4Y5/SOBTFzgTYGOpgk4Cx
         5f7Q==
X-Gm-Message-State: AOAM5300pfMsFmbyxAO8+3199k2KreRd4TYYULmzBs+QpQ5/eFwWiwZN
        6Syb7B27B/hppcwFqmCEuNCcxg==
X-Google-Smtp-Source: ABdhPJySYQfs2wYIwJxOVroAcTI4Zf/u75gqAxoVB6uKkDGfeX6TuA7sSpgeB656gXLp9t5YRAWBDw==
X-Received: by 2002:a05:6a00:1509:b0:44c:84b2:513 with SMTP id q9-20020a056a00150900b0044c84b20513mr8724831pfu.76.1633531878660;
        Wed, 06 Oct 2021 07:51:18 -0700 (PDT)
Received: from integral.. ([182.2.71.97])
        by smtp.gmail.com with ESMTPSA id y197sm19155429pfc.56.2021.10.06.07.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 07:51:18 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v1 RFC liburing 4/6] test/cq-size: Don't use `errno` to check liburing's functions
Date:   Wed,  6 Oct 2021 21:49:10 +0700
Message-Id: <20211006144911.1181674-5-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211006144911.1181674-1-ammar.faizi@students.amikom.ac.id>
References: <20211006144911.1181674-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When we build liburing without libc, we can't check `errno` variable
with respect to liburing's functions. Don't do that it in test.

Note:
The tests themselves can still use `errno` to check error from
functions that come from the libc, but not liburing.

Cc: Bedirhan KURT <windowz414@gnuweeb.org>
Cc: Louvian Lyndal <louvianlyndal@gmail.com>
Link: https://github.com/axboe/liburing/issues/443
Fixes: https://github.com/axboe/liburing/issues/449
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 test/cq-size.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/test/cq-size.c b/test/cq-size.c
index b7dd5b4..4e6e3d1 100644
--- a/test/cq-size.c
+++ b/test/cq-size.c
@@ -45,14 +45,20 @@ int main(int argc, char *argv[])
 	p.cq_entries = 0;
 
 	ret = io_uring_queue_init_params(4, &ring, &p);
-	if (ret >= 0 || errno != EINVAL) {
+	if (ret >= 0) {
 		printf("zero sized cq ring succeeded\n");
+		io_uring_queue_exit(&ring);
+		goto err;
+	}
+
+	if (ret != -EINVAL) {
+		printf("io_uring_queue_init_params failed, but not with -EINVAL"
+		       ", returned error %d (%s)\n", ret, strerror(-ret));
 		goto err;
 	}
 
 done:
 	return 0;
 err:
-	io_uring_queue_exit(&ring);
 	return 1;
 }
-- 
2.30.2

