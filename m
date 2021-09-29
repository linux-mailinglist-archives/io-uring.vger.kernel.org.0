Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F7141C294
	for <lists+io-uring@lfdr.de>; Wed, 29 Sep 2021 12:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245545AbhI2KT0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Sep 2021 06:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245516AbhI2KTN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Sep 2021 06:19:13 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1D8C061772
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 03:17:21 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id y186so2254287pgd.0
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 03:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sUPXU68Cu9vvHGM0C0dqecgBfPZd9jfNcRECIjJ9m/0=;
        b=LN0CLSEKRWYY/+9ZUXghZgxDc7Xa17nwLs9C2qIpWV3QAEnyBupN3Jm1salwEUpby9
         RIe6qr3YIwRy30rPd6tSf5PXo3SbCj7pn8ae6MjIt6Gh5/d1qbW7+JgPLqK8eIC+XfeS
         h2Mt+E0jieNzYql7bUjSxfYGNbCDzCHu+iEb28X4kmtom8gfeYPnfcrBmUBYLtHnomvy
         cwdSD6XaVITtSXLzeQ0PoUT+mp33j3R8Ann5M1WzjZoP8lYr/5RnygfdeI/ms8EW/Xd9
         cJCouj4g3TZUgaKj3SH7Ka+kKegqpdc5JFalGRb9LMknSt6fylHWWcwqmDhOqb31num1
         KetQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sUPXU68Cu9vvHGM0C0dqecgBfPZd9jfNcRECIjJ9m/0=;
        b=7Wcjuv82OrAwem2WndUjhRFvcHY3lexh9brtIctcaEVNRY13jZFqzNp5WFMsoUi5+V
         CSuyAjf+1QwXnncMhZr7MDE8u8FpxSVwYJeO1JtPIlmyQ1OerSUkt3OtSTCU6abMVFh5
         LJUwFBEPTosOGZ+Nblp+rCKnpMjIpuZe+IciNHsGb5EcXRWuVZpScjH/IG2IaVCUJo+y
         p/2OVuNfTy7vypRcUySSg6jdAMpAnd3M9zSH0LUikz/W4KmoA81nYqoeH6kOWtaRXHGI
         mg6+GT97zULCiLLGKiQOVQiABY491nRnOkF14Ss5NtU+rWZQsyldLfCUBm4TMp1t4GSA
         peHQ==
X-Gm-Message-State: AOAM531b7ju0X5GuG1Y/8CJdFld3QNnJaDLw5xtAkF7WSK4xoGQoscER
        6MtlTnXDW9v+1f4GBuHANvZ0dw==
X-Google-Smtp-Source: ABdhPJzexl/slekXNhJrdZ8x+oU0oJND4vSjwV3NiLQwXFwaYOQ379S3f0vS4zQSZVgdMNJ9HC68Vg==
X-Received: by 2002:a63:cd4e:: with SMTP id a14mr8865059pgj.429.1632910640621;
        Wed, 29 Sep 2021 03:17:20 -0700 (PDT)
Received: from integral.. ([68.183.184.174])
        by smtp.gmail.com with ESMTPSA id f16sm2001512pfk.110.2021.09.29.03.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 03:17:20 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammarfaizi2@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCHSET v1 RFC liburing 6/6] src/{queue,register,setup}: Remove `#include <errno.h>`
Date:   Wed, 29 Sep 2021 17:16:06 +0700
Message-Id: <20210929101606.62822-7-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210929101606.62822-1-ammar.faizi@students.amikom.ac.id>
References: <20210929101606.62822-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't need `#include <errno.h>` in these files anymore. For now,
`errno` variable is only allowed to be used in `src/syscall.c` to
separate the dependency from other liburing sources.

Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/queue.c    | 1 -
 src/register.c | 1 -
 src/setup.c    | 1 -
 3 files changed, 3 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index e85ea1d..24ff8bc 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -5,7 +5,6 @@
 #include <sys/stat.h>
 #include <sys/mman.h>
 #include <unistd.h>
-#include <errno.h>
 #include <string.h>
 #include <stdbool.h>
 
diff --git a/src/register.c b/src/register.c
index 0908e3e..2b8cbac 100644
--- a/src/register.c
+++ b/src/register.c
@@ -6,7 +6,6 @@
 #include <sys/mman.h>
 #include <sys/resource.h>
 #include <unistd.h>
-#include <errno.h>
 #include <string.h>
 
 #include "liburing/compat.h"
diff --git a/src/setup.c b/src/setup.c
index 52f3557..486a3a1 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -5,7 +5,6 @@
 #include <sys/stat.h>
 #include <sys/mman.h>
 #include <unistd.h>
-#include <errno.h>
 #include <string.h>
 #include <stdlib.h>
 #include <signal.h>
-- 
2.30.2

