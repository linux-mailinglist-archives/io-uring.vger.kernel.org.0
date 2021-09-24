Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A5D417CA7
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346452AbhIXVCZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbhIXVCY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:24 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFB5C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:51 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id x7so26139991edd.6
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=J2w/KHajQRlhTInHjxaJBeGCAEGSbtoVxZSbC1qfq3U=;
        b=XHWvY6LC/bRGYZFs2bz6SZL/Qv1+JFCt+P97W9SyJsC4+9tIOfmF6a6p/P1P8HOODO
         +kqreU7HNakLTnsRVbFn8DJlxTJ8DDxZDt9wXlsfAQXf6G7T9neJfI59cjgDTulEDo4E
         3mjl53tCg3LeLFPr2BqetPIKFEDTdhzA8Sabr0fhdrdc3/NXm+X2LaxKOaCPHl/v2pkL
         4uUDMNG1YiVHhZ6Pdzj88b2zhXPPkeTZVHfZKnZjp6cXO85/L6ef9OeGW/vjCoAMiIxY
         NbFcpbmhkoOP01bVbhNjW6KtvHAuPWuk+0mOuw7D/dg84GDWWOKtonWi7C8G7WK6UJov
         mmgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J2w/KHajQRlhTInHjxaJBeGCAEGSbtoVxZSbC1qfq3U=;
        b=fhNzEhBv3HHIpBNtobdc/C1owykQQg35J+dVyPRiQqU4gjbSsF4MF9AYhMOPHe3dSW
         +f7tjR4cGLxi0GIedfCqCm9UFUBcY/8WHluG3Px4EaBI65URlx+BWJxDqSAwMTF15TD+
         uzI7+HZcPVuqZVBeTpKCVWRlbwRym+fGRH/pvcCz53M1tuwk/zoVt8c27ggi+H+TP5yb
         G/ld/Kxt0DvywIVVadmwrNI97PnEeOlUINbkzry1mAmhjcrfHsrejuPw0/tMTy3g4QKF
         GYUgCikRSVOyelTUbfLD6rxaqWcKKZmkybfFaYmKPMaMGioHRGZ/NjNRC47+xSIwXNeU
         xkcQ==
X-Gm-Message-State: AOAM533d8LQSfAHN0BFKfi4oq4G1z5BUkHhkXflmEEl/xaezrMbR6gaG
        iOfObgI0GLz/1upHdL7/bEebc3Z2vlQ=
X-Google-Smtp-Source: ABdhPJxS8tMivjNqq1lt3OSuKIcc3TJhlcyYN4m5d9lZ8hZ7rZct9Js5QPG7DZm4JfWAivSdXORlAA==
X-Received: by 2002:a17:906:7b54:: with SMTP id n20mr13438371ejo.525.1632517249884;
        Fri, 24 Sep 2021 14:00:49 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:00:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 01/24] io_uring: mark having different creds unlikely
Date:   Fri, 24 Sep 2021 21:59:41 +0100
Message-Id: <e7815251ac4bf5a4a23d298c752f029ae19f3837.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hint the compiler that it's not as likely to have creds different from
current attached to a request. The current code generation is far from
ideal, hopefully it can help to some compilers to remove duplicated jump
tables and so.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ad71c7ef7f6d..9e269fff3bbe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6645,7 +6645,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	const struct cred *creds = NULL;
 	int ret;
 
-	if ((req->flags & REQ_F_CREDS) && req->creds != current_cred())
+	if (unlikely((req->flags & REQ_F_CREDS) && req->creds != current_cred()))
 		creds = override_creds(req->creds);
 
 	switch (req->opcode) {
-- 
2.33.0

