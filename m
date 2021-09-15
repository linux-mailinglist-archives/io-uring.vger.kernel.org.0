Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5EB740C17E
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 10:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhIOIQG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 04:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbhIOIQF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 04:16:05 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7ECC061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 01:14:47 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id r2so1910281pgl.10
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 01:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eE9YnS7MUTEVObeooaY3ixTPa6oIbV7f0qRC1KVMJaA=;
        b=Q5NTOUjTi1/SAmSQwrWjM+XDPRP7QtxTH3NwoQ2COO22GttjB89l3NCLkbvSF0V0yh
         DrhrO6Y9U/2ppQQpHeOEUIO766g20rBqihdymGHYed4fwvWtFHqTTWM2duuQWaflnRQ5
         DxVVAu8NKgHA1WHiuSJrZbsfnMT/USD2m56tAb50A0WWQjnJP1Z/TEfvelmZ5g5O1pQg
         RLJ4bo7Kk9mneW5ckDbf72C8H9L1g17qNl97+5XFPKDLr2pllxydiIP+tN4zOUGmRNUP
         WPCvcWQS8Bj/NJki5uduoAXkwiKo/JRFk0+h76ciWJL72XVSDtigG5mKJ/h0AGrXirAG
         6BBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eE9YnS7MUTEVObeooaY3ixTPa6oIbV7f0qRC1KVMJaA=;
        b=QBmEUe4XmQCtsBY7ydd8nVyZ67jKq7XVytw+/S1VV7+oGs/wS8xTvVFMhwotunWMH/
         nraMxKmfC+LR+L84DaX8vBR+gEYdYPsNhsIMSyolhni7Ask6s/ai0wkYvxrAYRV9ZFL+
         DSrtI+NOm696fZEL4YxJ3u2tuRyFY1qncCez5n3Ldnpg/exXCbNhHcNVNhrZDte9kK5k
         MBWPueIZzHkr21HX+ENViRYGKEq2ISWzscOg52v1yEqxGzQsPPD0zyPQJVFtRwlKei58
         XS0NI7XiSqpHRW4v4QCu+U5TLlQajcmsfkQcN5oyTMA5W+y1HaSZDK12sLA81QuTdl2b
         dleA==
X-Gm-Message-State: AOAM533651jcmEiFAaoKyhfYrMyNMLA/Erto6iI1MpOJDYxbuBQ5Lzom
        h01OJRkRuWmHy6Xs2EsIV8/NI3e2h5s=
X-Google-Smtp-Source: ABdhPJxlXBtYRwUNucdl1VOG16vkkSVVRlDceyqm8XrxPNnC++vysR7hmFRQJW8LzyeWL5OytNMvUw==
X-Received: by 2002:a63:4303:: with SMTP id q3mr19192867pga.375.1631693687084;
        Wed, 15 Sep 2021 01:14:47 -0700 (PDT)
Received: from integral.. ([182.2.71.184])
        by smtp.gmail.com with ESMTPSA id x22sm12643076pfm.102.2021.09.15.01.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 01:14:46 -0700 (PDT)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        Louvian Lyndal <louvianlyndal@gmail.com>
Subject: [PATCH liburing 1/3] test/io_uring_setup: Don't use `__errno` as local variable name
Date:   Wed, 15 Sep 2021 15:11:56 +0700
Message-Id: <2d53ef3f50713749511865a7f89e27c5378e316d.1631692342.git.ammarfaizi2@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210915081158.102266-1-ammarfaizi2@gmail.com>
References: <20210915081158.102266-1-ammarfaizi2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This commit fixes build for armv8l.

On some systems, the macro `errno` is defined as
`#define errno (*__errno())`

It is clear that `__errno` is a global function on such systems.

The problem is, `io_uring_setup.c` uses `int __errno` as a local
variable, so it shadows the `__errno` function, result in the
following error:

```
       CC io_uring_setup
  io_uring_setup.c:116:12: error: called object type 'int' is not a function or function pointer
          __errno = errno;
                    ^~~~~
  /usr/include/errno.h:58:24: note: expanded from macro 'errno'
  #define errno (*__errno())
                  ~~~~~~~^
  1 error generated.
  make[1]: *** [Makefile:163: io_uring_setup] Error 1
  make[1]: *** Waiting for unfinished jobs....
```

Fix this by not using `__errno` as local variable name.

Reported-by: Louvian Lyndal <louvianlyndal@gmail.com>
Tested-by: Louvian Lyndal <louvianlyndal@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---
 test/io_uring_setup.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/test/io_uring_setup.c b/test/io_uring_setup.c
index a0709a7..94b54fd 100644
--- a/test/io_uring_setup.c
+++ b/test/io_uring_setup.c
@@ -99,7 +99,7 @@ dump_resv(struct io_uring_params *p)
 int
 try_io_uring_setup(unsigned entries, struct io_uring_params *p, int expect, int error)
 {
-	int ret, __errno;
+	int ret, err;
 
 	printf("io_uring_setup(%u, %p), flags: %s, feat: %s, resv: %s, sq_thread_cpu: %u\n",
 	       entries, p, flags_string(p), features_string(p), dump_resv(p),
@@ -113,13 +113,13 @@ try_io_uring_setup(unsigned entries, struct io_uring_params *p, int expect, int
 			close(ret);
 		return 1;
 	}
-	__errno = errno;
-	if (expect == -1 && error != __errno) {
-		if (__errno == EPERM && geteuid() != 0) {
+	err = errno;
+	if (expect == -1 && error != err) {
+		if (err == EPERM && geteuid() != 0) {
 			printf("Needs root, not flagging as an error\n");
 			return 0;
 		}
-		printf("expected errno %d, got %d\n", error, __errno);
+		printf("expected errno %d, got %d\n", error, err);
 		return 1;
 	}
 
-- 
2.30.2

