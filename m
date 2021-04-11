Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116CE35B113
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 02:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhDKAvX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 20:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbhDKAvX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 20:51:23 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6ACDC06138B
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:07 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id j5so8272131wrn.4
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SS8O3SR8NZYraTt8GHPm5FeTuezpgXWRUGfHos79mr0=;
        b=YqTQdwXX0K06QV4zfk+JEieuvfyy9V/mD9JoB6PVYDp77hsUxofSrRcKmsDiay5J1w
         y05Pm4+eKgqW76LzrtJa9yB5+Im5+sqDkhWBS0FXrbtraXIps9wjFiPilL39ehi+K+vQ
         QRE1PU1LLlrj6JNWcU2JUWGWAVuEAnl2XD4/QTHTzq+Fu5wDcKKnFlCKGUliGYosuMa8
         G+1HwQykhQZJjI4jNwk4NTmI6+vM9JtwiyfpXyGs0NDQGGqQpo8QKJtKHgNT2CYZV/b/
         w+zu+vlI0s88ipZJiAnONsZTYw3dZCkFQ4PjvytrYm3aa2L36G0HvebYl/8FDFmfMBYA
         FJvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SS8O3SR8NZYraTt8GHPm5FeTuezpgXWRUGfHos79mr0=;
        b=tXB/DEvlZoFEq8vXQJJ0szOLGv9NEmSW5GxbflFAQ7nmhElQddvbOhZ8uz4qijVnjT
         QgEHC4hXp/f2alXrPtblCTxMjP8zfMce3z79tLxLJyUidVukVfbfki9SqppkURQMbMKx
         7xIHHA0n7W2QaAr3NdY6kyQUBQCInTCU4ISoVMxQQ+kjuKwfeCsYNaKZUw0H9HzuTWDH
         RvjQ72OwLjmCQ2rvPW9tCP81r/icLxlcwEueucj18W1hPKrAtjkBiN5XtdlNfur+oWRk
         BtQlxS5QoXUZlyV7Rl2M054azfrd3GbUWKfvc6R8HgJZytoLLiMDuifzLixF8mC8pV0z
         yXLA==
X-Gm-Message-State: AOAM533vgYv1hxZkyQwc7akT4admTYERGHdPGNIvYKZ60xYIsMm7nztS
        mHmWIBhsNOXHzoXqikbS9yPGjAxedu1e2w==
X-Google-Smtp-Source: ABdhPJzYedoHQMAW0xMarWJ4YdbXewuL5Yq3Vqnqs3AzEcv854A4NPrsgaj1nRW4neSVydjhH0Za5g==
X-Received: by 2002:a05:6000:18d2:: with SMTP id w18mr24564298wrq.88.1618102266555;
        Sat, 10 Apr 2021 17:51:06 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id y20sm9204735wma.45.2021.04.10.17.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 17:51:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 15/16] io_uring: improve hardlink code generation
Date:   Sun, 11 Apr 2021 01:46:39 +0100
Message-Id: <96a9387db658a9d5a44ecbfd57c2a62cb888c9b6.1618101759.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618101759.git.asml.silence@gmail.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req_set_fail_links() condition checking is bulky. Even though it's
always in a slow path, it's inlined and generates lots of extra code,
simplify it be moving HARDLINK checking into helpers killing linked
requests.

          text    data     bss     dec     hex filename
before:  79318   12330       8   91656   16608 ./fs/io_uring.o
after:   79126   12330       8   91464   16548 ./fs/io_uring.o

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4e6a6f6df6a2..2a465b6e90a4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1103,7 +1103,7 @@ static bool io_match_task(struct io_kiocb *head,
 
 static inline void req_set_fail_links(struct io_kiocb *req)
 {
-	if ((req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) == REQ_F_LINK)
+	if (req->flags & REQ_F_LINK)
 		req->flags |= REQ_F_FAIL_LINK;
 }
 
@@ -1812,7 +1812,8 @@ static bool io_disarm_next(struct io_kiocb *req)
 
 	if (likely(req->flags & REQ_F_LINK_TIMEOUT))
 		posted = io_kill_linked_timeout(req);
-	if (unlikely(req->flags & REQ_F_FAIL_LINK)) {
+	if (unlikely((req->flags & REQ_F_FAIL_LINK) &&
+		     !(req->flags & REQ_F_HARDLINK))) {
 		posted |= (req->link != NULL);
 		io_fail_links(req);
 	}
-- 
2.24.0

