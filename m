Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D7741FF06
	for <lists+io-uring@lfdr.de>; Sun,  3 Oct 2021 03:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhJCBIR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Oct 2021 21:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234236AbhJCBIR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Oct 2021 21:08:17 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D6DC0613EC
        for <io-uring@vger.kernel.org>; Sat,  2 Oct 2021 18:06:30 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 133so13092538pgb.1
        for <io-uring@vger.kernel.org>; Sat, 02 Oct 2021 18:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E3cvN9oaAfAUZYwOTDnzYbZjYKSLlsXfSC6qD8UnGi4=;
        b=Jezl3I+APuf14tU4u3nZ+MnIMBodHeLAFAQQ0WtmXG+TXPxpcxxwqw+K//BBUyzeqw
         r3vdpMy6AEg9Mau2PDhBubIrl12pb77pbdD6MB2538LuwqvyooP9tbm+YDFl7fT9X0Ov
         fQPgx+sb+UeUcLzbQ4bnpQmgIwdkOFnyUTAltNL5wVIoKJtGORHXy1OOkNdH4jeunsOu
         afoC8iTFSyS/l1sYYWdJV0RCgtpy3jIfL+dcnA9Rs2YxU63399SACIrlN2EY+m1ItSAD
         c3meD8YziE+DH4yNg6DIW3Ok8MhDA4RDquryknVMCRHZcw0/E0HTDR8B016/kNEXf9A5
         NbGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E3cvN9oaAfAUZYwOTDnzYbZjYKSLlsXfSC6qD8UnGi4=;
        b=nyQTWIxh/rT279aMM8fhru1Mr5zwuB6y3n2QN+LDII+qCmCg0pm/ANIsH8w5svFOEO
         w9wcTob2YJznHHcs4liKG5gE1cfSYwXrZOpeyHjwlcDCIRlW2WyhSzoEsiaICzVkvVhV
         /Z5Yseh8oHkESrWWT0TtlZagLAdMLJKHiKEKcmXJ7y0tyZUKuNOGrcEgDEHYGKsHiI9f
         IrGxL8gqNxpLVFqYrRK001FDdv8/Lg+5PLm71zyzT4KHToVz4JUh/EBMCMYd02ykW73w
         YqdP/vSdoy0CqFd4T6+OZteJkouK0GosUe3MTQ7TWAhVFngm/sZI79CgobDY9Ur7016Y
         E3Gw==
X-Gm-Message-State: AOAM533KBMmIN1xccf87tj3TAm9PSZ/Sfq7O/72gbeayan60WGseulSr
        0YOUzNqxupQ6uBMgAG8dpmEBEg==
X-Google-Smtp-Source: ABdhPJxXS9tDh+/r4GmPbkEW6JGmowEK78ZaIFQZDXF4QBOlBUHd1llPU48B29s3kOGkALgOf4kcVg==
X-Received: by 2002:aa7:954a:0:b0:44b:bc53:1e2b with SMTP id w10-20020aa7954a000000b0044bbc531e2bmr17664635pfq.64.1633223189934;
        Sat, 02 Oct 2021 18:06:29 -0700 (PDT)
Received: from integral.. ([182.2.37.211])
        by smtp.gmail.com with ESMTPSA id x9sm10271444pfo.172.2021.10.02.18.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 18:06:29 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH liburing] test/probe: Use `io_uring_free_probe()` instead of `free()`
Date:   Sun,  3 Oct 2021 08:06:08 +0700
Message-Id: <20211003010608.58380-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

`io_uring_free_probe()` should really be used to free the return value
of `io_uring_get_probe_ring()`. As we may not always allocate it with
`malloc()`. For example, to support no libc build [1].

Link: https://github.com/axboe/liburing/issues/443 [1]
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 test/probe.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/test/probe.c b/test/probe.c
index 29239ff..fd59612 100644
--- a/test/probe.c
+++ b/test/probe.c
@@ -45,6 +45,7 @@ static int verify_probe(struct io_uring_probe *p, int full)
 
 static int test_probe_helper(struct io_uring *ring)
 {
+	int ret;
 	struct io_uring_probe *p;
 
 	p = io_uring_get_probe_ring(ring);
@@ -53,12 +54,9 @@ static int test_probe_helper(struct io_uring *ring)
 		return 1;
 	}
 
-	if (verify_probe(p, 1)) {
-		free(p);
-		return 1;
-	}
-
-	return 0;
+	ret = verify_probe(p, 1);
+	io_uring_free_probe(p);
+	return ret;
 }
 
 static int test_probe(struct io_uring *ring)
-- 
2.30.2

