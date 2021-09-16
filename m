Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A8C40D28A
	for <lists+io-uring@lfdr.de>; Thu, 16 Sep 2021 06:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhIPE3U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Sep 2021 00:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhIPE3T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Sep 2021 00:29:19 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3DCC061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 21:28:00 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q68so4937506pga.9
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 21:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rljiJDKg/RRzl3sozhTOOXmUU7EFHR2D2bDPywxsH0U=;
        b=nzUNdA/wT/3sxCWUVE8fvcVOPAvBQqRdr1lQIdMqnzNPhRLM9Tp8CV9K96yrYz30lE
         unL76OZXQL9npeYvQ5KQVc1CT8BwVDGpGhLZQY8r4U1wgSMeYftlOwnHRjwS6v0UH3U1
         6o/HLue9TyyEawisJM8lytsOypKBDDmXAUFTN+lBS5Z9XfNh7ly1SGU3rJh60M7TIKSj
         d8bXMtl0SdJSIbonzK0gNeCXWpL6MOHDkGGa9IHJkGghJKGpzs23JMNneGr1joTxRUtN
         kpY0W93M+/LtyDuRMvgdZ40iYpShgj2anfRhaVoCNbStIJv11eZFJ8pyVVqSJitwRdHQ
         QRXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rljiJDKg/RRzl3sozhTOOXmUU7EFHR2D2bDPywxsH0U=;
        b=S2xxF8Q3l/n9Vy0c+XimZg9RlcR5F5EtqW1qmGMZk/AEgA2eRkR+xG0Y0Q6hjJUK3Y
         zfrZZs+IPnbyL98PfTmU8n8k5hHS1xbUU0S9ImyEueejnB6cJ9BBzKFHiLClN2Wz8Arp
         hMIXeYj4rXL3oh73podkSENaUIKIAW0c14lCFeIvpGs1jfSPruP8OZEYn5n7KT9UCPAp
         tNYR9kAJOzE3pmH9+9xljYOmqQiaqIMKUHvC0KBj6kR9fcY000Mh0/pZl97T/JJzsWTl
         olSyP3qfP4mlJHQjKb+WB2KPGRaIgXRjiyqnEjutg2++1cAb4KpGLFf+6jAiLj9BRcTq
         Ig7g==
X-Gm-Message-State: AOAM530owxgylqEsaVk+sOz5GZOpvc9Y6A0m8ZL9hASwHlq8OkyVWjGO
        /dz2gHpdjSs+JTtRXWNv7Is8FTudae0=
X-Google-Smtp-Source: ABdhPJz2gjTIAue/BbpVym4whJrMoNMxUQ+zRfeHccC7fOa3xKIwuf2HePJBPVwTVM6yeXnLbrqvuQ==
X-Received: by 2002:a62:64d3:0:b0:43d:ba3:1e2c with SMTP id y202-20020a6264d3000000b0043d0ba31e2cmr3022819pfb.5.1631766479789;
        Wed, 15 Sep 2021 21:27:59 -0700 (PDT)
Received: from integral.. ([182.2.37.93])
        by smtp.gmail.com with ESMTPSA id q3sm1521216pgf.18.2021.09.15.21.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 21:27:59 -0700 (PDT)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>
Subject: [PATCH liburing 2/2] test/file-verify: fix 32-bit build -Werror=shift-count-overflow
Date:   Thu, 16 Sep 2021 11:27:31 +0700
Message-Id: <20210916042731.210100-3-ammarfaizi2@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916042731.210100-1-ammarfaizi2@gmail.com>
References: <20210916042731.210100-1-ammarfaizi2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

`off_t` may not always be 64-bit in size.
```
  file-verify.c: In function 'test':
  file-verify.c:193:26: error: left shift count >= width of type [-Werror=shift-count-overflow]
      sqe->user_data = (off << 32) | i;
                            ^
  cc1: all warnings being treated as errors
  Makefile:164: recipe for target 'file-verify' failed
  make[1]: *** [file-verify] Error 1
  make[1]: Leaving directory '/root/liburing/test'
  Makefile:12: recipe for target 'all' failed
  make: *** [all] Error 2
```
Fix this by using (uint64_t) cast.

Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---
 test/file-verify.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/file-verify.c b/test/file-verify.c
index ffedd87..cd6c4de 100644
--- a/test/file-verify.c
+++ b/test/file-verify.c
@@ -190,7 +190,7 @@ static int test(struct io_uring *ring, const char *fname, int buffered,
 				else
 					io_uring_prep_read(sqe, fd, buf[i], this, off);
 			}
-			sqe->user_data = (off << 32) | i;
+			sqe->user_data = ((uint64_t)off << 32) | i;
 			off += this;
 			left -= this;
 			pending++;
-- 
2.30.2

