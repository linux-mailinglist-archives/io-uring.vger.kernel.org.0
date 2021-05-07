Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA3D37689B
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 18:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238107AbhEGQYQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 12:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbhEGQYK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 12:24:10 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB8CC061574
        for <io-uring@vger.kernel.org>; Fri,  7 May 2021 09:23:10 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id s8so9863601wrw.10
        for <io-uring@vger.kernel.org>; Fri, 07 May 2021 09:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=egAM4kudW9HwuMqJS3amJJitMYqEtePECgqEBg/KPkw=;
        b=npWKQg6HtSxwOeLKjH585oZ+uEhhbwRdlWejnJqabOU47MpCBn3vddM11QHndm8Oqq
         1uI/qo9s3Eh/KZifjWyHtGkrpLbUYVsi/K0RZXVbYNzzUN0sFH5xmgTtYAXAI8jVBCTL
         qcDHRfHXKAbQZKlvefSWbLveOoD1ORR49ZoZyZkD9BTsjnr3jOmfPOXdaEOddg3IYreO
         jHoro7YbkICwb842iZ9aT7BqkhTHgw/nHf2rG3jKQnoa1YXu8/ZpFRbuNZVqsBrgwMdq
         JUlRhIzhaKeHSe72/iCpoq0KdJEDbeJyT6nQeChkWnA18ucGLXhyMTXOgdlhCfmZYkPy
         EBxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=egAM4kudW9HwuMqJS3amJJitMYqEtePECgqEBg/KPkw=;
        b=GDF0Zs0i2xWWfZ7IA0tF38K6GfBrTuvqDud4zlMdjY0ww1W+35XkClEK2q8lBhkk9p
         UkeJxZGZIqrXBpbKhCvgqzlaaJbwSsDOVFXwgNbHtEZktgPEBR+BwPtenPgnzdcPjBzI
         JFWaNntaUkNbGcgU0pyuVwIe05cvb3KKzELQzqAqFkZ+zb93PrD7ysXrLrwVLLTN2R18
         DmoIucG3JwDL1XEqjgtnmigJBa85Ogy01kt76I2IfptQGQ6/xdH7XKHfjnSF1++aBcot
         BvPzPR56cnCzYmwba+U4erswKwMIsPg/ogqjci330TQ30Dgq3Zc8rL4txlaf6DHYxYL3
         /laA==
X-Gm-Message-State: AOAM530Y4E8dEl0VUurK7UxY6ys0ToIzbfRc+TMQ9MTbvRMQ5s7QYsX1
        1r1ByyHfdWIj1zt+/cG+gwo=
X-Google-Smtp-Source: ABdhPJztJAdJErTAtTWmO6af5mmXXbcthSfc8KSIZkhHQoda6oG3d9o5RvV2E5sAngx43+p3JUu0eA==
X-Received: by 2002:a5d:6544:: with SMTP id z4mr13697512wrv.246.1620404588825;
        Fri, 07 May 2021 09:23:08 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id w4sm8765630wrl.5.2021.05.07.09.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 09:23:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 4/4] tests: fix minor connect flaws
Date:   Fri,  7 May 2021 17:22:51 +0100
Message-Id: <8b81dadc9c5060e7d6099d22ce4f39fcadaf303c.1620404433.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1620404433.git.asml.silence@gmail.com>
References: <cover.1620404433.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use inet_aton() to set address, otherwise can lead to problems depending
on endianness.

Also, set user_data only after io_uring_prep_link_timeout(), otherwise
will be rewritten.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/connect.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/test/connect.c b/test/connect.c
index ab81bb8..91b5578 100644
--- a/test/connect.c
+++ b/test/connect.c
@@ -14,6 +14,7 @@
 #include <sys/socket.h>
 #include <netinet/in.h>
 #include <netinet/tcp.h>
+#include <arpa/inet.h>
 
 #include "liburing.h"
 
@@ -125,9 +126,8 @@ static int configure_connect(int fd, struct sockaddr_in* addr)
 	memset(addr, 0, sizeof(*addr));
 	addr->sin_family = AF_INET;
 	addr->sin_port = use_port;
-	addr->sin_addr.s_addr = 0x0100007fU;
-
-	return 0;
+	ret = inet_aton("127.0.0.1", &addr->sin_addr);
+	return ret;
 }
 
 static int connect_socket(struct io_uring *ring, int fd, int *code)
@@ -292,9 +292,9 @@ static int test_connect_timeout(struct io_uring *ring)
 		fprintf(stderr, "unable to get sqe\n");
 		goto err;
 	}
+	io_uring_prep_link_timeout(sqe, &ts, 0);
 	sqe->user_data = 2;
 
-	io_uring_prep_link_timeout(sqe, &ts, 0);
 	ret = io_uring_submit(ring);
 	if (ret != 2) {
 		fprintf(stderr, "submitted %d\n", ret);
-- 
2.31.1

