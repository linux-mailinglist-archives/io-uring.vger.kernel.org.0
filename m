Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB6C3054CC
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 08:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbhA0Hhj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 02:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317419AbhA0AAI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 19:00:08 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E322C0611C0
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 15:29:23 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id hs11so112625ejc.1
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 15:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rfWJYSRHkHvaDzwPFMckI6nLAl72eruca5Q39bWAA0A=;
        b=jjmTX/VPLN0s1VLGhl5fkIqdYXcXg3CGFGJR62wWkU4eaRDACiGD3UAWzTyh1hPWOr
         caB5fYB2eYD/ND9qt+LDqN1t/Fv6A1EA8KiZ4Kwfgwl3FGiacWvxUBILN4UAOloKgufe
         2crqkFtaI0vVlXUbX9jthd8KfTNg1wB0i63HF1RDjG5EqNg1WgQkitOxbcvoYs9XiHhb
         pXEXnAR4ah15mZCUf3C/oUB9VSfCVMaPY5KhnMh02Gyr2jQ11+MWkd/WQqWXfoecPHkY
         O4u7sKTfB89/sgDiDBSYfDH0JoWmCuZCN6hON7tuGdBXLHK71jAh0oPoPEqtyfdOkonR
         9o0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rfWJYSRHkHvaDzwPFMckI6nLAl72eruca5Q39bWAA0A=;
        b=MDiMypGQK7ZfkeCl3NyyYwi48pQlEu8AE6YXlsCgXKblJJn5ESsJsyTXx3VSM+T7BE
         /KqlcxFz65NizQf4ZPA2PB9Cgk0ZQJ+vbG5PBYrWBZBZdjLT48p4owUibDjA9+16X3yL
         TZOWlPl6NP1vAZIgspK2bhod5kWFNcYFgdV08G5o/WIOnD8WTA0OLE3gagX7m9VHmw5A
         8oF8kurBFnOv36ugAVRuVhmFxMIaC46xmvMpVWa8j6gwdRpFGJOBwE5tFIQjn4hr0P3l
         vxKz8XnrU5ppLEfP12q/xygP5DEO6njYWrGBNO8WmhvH0HlM1zv2Op9ObOb4iJaAKlpl
         Q8CQ==
X-Gm-Message-State: AOAM532sOZGA413FWUn+60Q6ZqOwWpicCGWutDHYPHFZ+HPbEwqi7CVH
        ZsYMxSGm7G3cVD3+On9PrH1I5ozxwgg=
X-Google-Smtp-Source: ABdhPJyr2c+n9ns2u2ii2NYcGeo6pkl8CAvk1k4O+Lzv+nBSJIqe2M4+4SBUXGkzN+2YeNRJmeugVw==
X-Received: by 2002:a17:906:ae42:: with SMTP id lf2mr4658414ejb.487.1611703762039;
        Tue, 26 Jan 2021 15:29:22 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id b17sm147295edv.56.2021.01.26.15.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 15:29:21 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] test/drain: test draining linked timeouts
Date:   Tue, 26 Jan 2021 23:25:19 +0000
Message-Id: <b5213397eaeb9d6c7225b8d6dcfa6faae22b5ab0.1611703489.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make sure references are accounted well when we defer reqs with linked
timeouts.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/defer.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/test/defer.c b/test/defer.c
index 05833d4..4bcc1cc 100644
--- a/test/defer.c
+++ b/test/defer.c
@@ -148,6 +148,41 @@ err:
 	return 1;
 }
 
+static int test_drain_with_linked_timeout(struct io_uring *ring)
+{
+	const int nr = 5;
+	struct __kernel_timespec ts = { .tv_sec = 1, .tv_nsec = 0, };
+	struct test_context ctx;
+	int ret, i;
+
+	if (init_context(&ctx, ring, nr * 2))
+		return 1;
+
+	for (i = 0; i < nr; i++) {
+		io_uring_prep_timeout(ctx.sqes[2 * i], &ts, 0, 0);
+		ctx.sqes[2 * i]->flags |= IOSQE_IO_LINK;
+		io_uring_prep_link_timeout(ctx.sqes[2 * i + 1], &ts, 0);
+	}
+
+	/* stall them all */
+	ctx.sqes[0]->flags |= IOSQE_IO_DRAIN;
+
+	ret = io_uring_submit(ring);
+	if (ret <= 0) {
+		printf("sqe submit failed: %d\n", ret);
+		goto err;
+	}
+
+	if (wait_cqes(&ctx))
+		goto err;
+
+	free_context(&ctx);
+	return 0;
+err:
+	free_context(&ctx);
+	return 1;
+}
+
 static int run_drained(struct io_uring *ring, int nr)
 {
 	struct test_context ctx;
@@ -269,5 +304,11 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	ret = test_drain_with_linked_timeout(&ring);
+	if (ret) {
+		printf("test_drain_with_linked_timeout failed\n");
+		return ret;
+	}
+
 	return 0;
 }
-- 
2.24.0

