Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929F9417B73
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 21:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346143AbhIXTHf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 15:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhIXTHe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 15:07:34 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD82C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:06:01 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id v24so39827890eda.3
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cCBippya0qAlrDWjCDXpC96DZ/espE7IgfPBM6spC4k=;
        b=WMwFnUm2OxuAL+IKmw3pbvoGJ4Eegb8zAA3bzTxsYcnDi2udCRRvqn2kGaSWx17cYP
         Z8zhIPBJ+Aik4p5jFKNWJO4sJaGNEhfVYrwX+7QFOejKCxKWy6pI430yx4M3AVXIt8FY
         1qfedR9bvE3vUSHmvWCRJ5pPtTzitNBJUEEARbj1EZQ/3gKNhcqKnvdJPzSNNHT7cXZw
         i+NiktTb2aMmdQeXkofMltm90zNwNMZ6224Br+c+GLMTyylO94ST64jIxE/c/4BlInaY
         tQZXFPBLwt/EJg7flJLECxTeHEiZLcqIktvY3j1wGue9awSeWOEpMTSqpw+ss/UgcOWv
         kafw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cCBippya0qAlrDWjCDXpC96DZ/espE7IgfPBM6spC4k=;
        b=xBrW9ne3gUUbibuA7NJb5HUx1wDJP98g/qh1GAio0Bokcn4w9yeR1X/aaTE6EmTCPl
         2v3/vdqfX/1SpXRDdBVRUZasx+N72opUudQvV1k/DmHWInzYYO7mIVZxV3hXXzeziVJc
         gcnxE1oB77M2KI9vLpNEyyZDXcLGRwRd0AUseFjkSOar+EJLr7XeiQRyxW5RG7F2YhAb
         tkYyssPqef9c23hgKUpq3D8rjx1rWBchxXcW6ycBUsjupkoesgNj/vM0uVe35HDTQSuK
         xYWb6zynp+7mxhj87aSvrl/yxKM2u3X/NkNr07PSofBFe7X1+GpLV26XFJck5kjKqKmx
         M2sQ==
X-Gm-Message-State: AOAM533x9C+1BrZTC80NxVPrjy4AeExavJfeLNZYf5Qi6F+WL6cXreap
        Suildo6lZZBWgQHDkT9DCHD+wAG27E8=
X-Google-Smtp-Source: ABdhPJyg3UdXYzxDzrurpUAZ0GNbukaqu2jaVzmv0ssgwm3EZ7mX59oxDrlOgR4dl1n3PH4V5SJl3A==
X-Received: by 2002:a50:fa81:: with SMTP id w1mr6712803edr.277.1632510359971;
        Fri, 24 Sep 2021 12:05:59 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id m10sm5380301ejx.76.2021.09.24.12.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 12:05:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/2] tests: improve multicqe_drain
Date:   Fri, 24 Sep 2021 20:05:16 +0100
Message-Id: <3ab7e2b2e52dba8dff11253b2b7ea3f57074c24e.1632507515.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632507515.git.asml.silence@gmail.com>
References: <cover.1632507515.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Small improvements for multicqe_drain test.
- close pipes
- use a helper for multishot poll
- don't touch cqe after io_uring_cqe_seen()

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/multicqes_drain.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/test/multicqes_drain.c b/test/multicqes_drain.c
index d04cf37..b107a48 100644
--- a/test/multicqes_drain.c
+++ b/test/multicqes_drain.c
@@ -288,9 +288,9 @@ static int test_simple_drain(struct io_uring *ring)
 		}
 	}
 
-	io_uring_prep_poll_add(sqe[0], pipe1[0], POLLIN);
-	sqe[0]->len |= IORING_POLL_ADD_MULTI;
+	io_uring_prep_poll_multishot(sqe[0], pipe1[0], POLLIN);
 	sqe[0]->user_data = 0;
+
 	io_uring_prep_poll_add(sqe[1], pipe2[0], POLLIN);
 	sqe[1]->user_data = 1;
 
@@ -320,6 +320,7 @@ static int test_simple_drain(struct io_uring *ring)
 
 	io_uring_prep_poll_remove(sqe[0], 0);
 	sqe[0]->user_data = 2;
+
 	io_uring_prep_nop(sqe[1]);
 	sqe[1]->flags |= IOSQE_IO_DRAIN;
 	sqe[1]->user_data = 3;
@@ -333,18 +334,21 @@ static int test_simple_drain(struct io_uring *ring)
 		goto err;
 	}
 
-
 	for (i = 0; i < 6; i++) {
 		ret = io_uring_wait_cqe(ring, &cqe);
 		if (ret < 0) {
 			printf("wait completion %d\n", ret);
 			goto err;
 		}
-		io_uring_cqe_seen(ring, cqe);
 		if ((i == 5) && (cqe->user_data != 3))
 			goto err;
+		io_uring_cqe_seen(ring, cqe);
 	}
 
+	close(pipe1[0]);
+	close(pipe1[1]);
+	close(pipe2[0]);
+	close(pipe2[1]);
 	return 0;
 err:
 	return 1;
-- 
2.33.0

