Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543B34319C6
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 14:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhJRMsr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 08:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbhJRMsr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 08:48:47 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E0BC061714
        for <io-uring@vger.kernel.org>; Mon, 18 Oct 2021 05:46:36 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id e7so16094464pgk.2
        for <io-uring@vger.kernel.org>; Mon, 18 Oct 2021 05:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PrqT27WqwnAiAj1y4BOZDaa+eKVDe5YdM9RZazdB5vA=;
        b=eE8tlRKQ7zyK1BWg+2ASYdyA0YXfSgyZ/0HpAVZ43rRvP2c4ZQfxiO8tUM2tHhP/tw
         yaq3+ykrchXqQMOufXAsMptIBw5mexe86kS54CFozEXZ5z5/+UhfaLXv10Q2Ifcs0KAh
         s01T0NPNTfYncnGoN8HvRDfMll6vsb/XeB6nkuRBoaiWGsW/YG2L1IgN5pA0IXTLtmZS
         Sk4DEiafHC9rabHEe6exchj+nKFJzRq/I1rcMGg4dZhonoOHhqUSrYmroG2+KOgmMSC/
         1Fy9P8IyfNAJ2P5S5Yq/ddQsY0V1PxXPOufeepxBphagD2jSA3tFE/RO9vA+XwRavGx2
         VHNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PrqT27WqwnAiAj1y4BOZDaa+eKVDe5YdM9RZazdB5vA=;
        b=MGJxfs96cj8NZXsSIx61pgK/ZU38Q87Vut8bPw64ZFjIsV285eCUsmn+SoLLZmu6dv
         GyExo7nzNZBWqt3wjOCy+EAeTJFa5ie2g9/2UHY2pqLBctQciMea91BELMISMdxMOtwW
         n0JXy5CO7NO2PDdihNUCz+Oo5yqsvuGifvQarLK1rTRHsOcs8Aj/bGjF83E0UJmp7+WI
         ZGKZzyzuvAuR+VcP/38dWamD6JuGPE3FxFFjsIT9DI3caqG7UoiHX0nFqnzdpNfFbVBi
         bTJmdsGFGQT/xVinxbiEbszqYIZGecuWqR/Ytn1vmT7PbK4tUXsqI/JNzi3NQ4YeI2Yo
         Pobg==
X-Gm-Message-State: AOAM5338RdItKoMSXJRSQysbOJV5r7vB9UuelXi3ZzRuPaibCAva9OiC
        y1a5xyIQCzUP121IDRW6fnUQEyVaIKfHsw==
X-Google-Smtp-Source: ABdhPJzHUYEzsuLy4VvlecL95aQ3TFdOMRsEvEWEOFEJ4WkaYaDnn8xNuT6WLOIPsEDZmq0oD9Cf4w==
X-Received: by 2002:a05:6a00:2388:b0:44d:4b5d:d5e with SMTP id f8-20020a056a00238800b0044d4b5d0d5emr28191948pfc.80.1634561195566;
        Mon, 18 Oct 2021 05:46:35 -0700 (PDT)
Received: from integral.. ([182.2.39.79])
        by smtp.gmail.com with ESMTPSA id l14sm20096041pjq.13.2021.10.18.05.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 05:46:35 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        zhangyi <yi.zhang@huawei.com>, yangerkun <yangerkun@huawei.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH liburing 2/2] test/timeout-overflow: Fix `-Werror=maybe-uninitialized`
Date:   Mon, 18 Oct 2021 19:46:01 +0700
Message-Id: <BULrcXMbevM-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <DdOIWk8hb7I-ammarfaizi2@gnuweeb.org>
References: <DdOIWk8hb7I-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fix this:
```
  In file included from timeout-overflow.c:12:
  timeout-overflow.c: In function ‘test_timeout_overflow’:
  ../src/include/liburing.h:406:9: error: ‘num’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
    406 |         io_uring_prep_rw(IORING_OP_TIMEOUT, sqe, -1, ts, 1, count);
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  timeout-overflow.c:104:26: note: ‘num’ was declared here
    104 |                 unsigned num;
        |                          ^~~
```

Fixes: a4b465536021ee9c4d6d450a9461ddfc116d08b1 ("Add test for overflow of timeout request's sequence")
Cc: yangerkun <yangerkun@huawei.com>
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 test/timeout-overflow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/timeout-overflow.c b/test/timeout-overflow.c
index f952f80..671f171 100644
--- a/test/timeout-overflow.c
+++ b/test/timeout-overflow.c
@@ -101,7 +101,7 @@ static int test_timeout_overflow(void)
 
 	msec_to_ts(&ts, TIMEOUT_MSEC);
 	for (i = 0; i < 4; i++) {
-		unsigned num;
+		unsigned num = 0;
 		sqe = io_uring_get_sqe(&ring);
 		switch (i) {
 		case 0:
-- 
2.30.2

