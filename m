Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4637527F2CA
	for <lists+io-uring@lfdr.de>; Wed, 30 Sep 2020 22:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbgI3UAA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Sep 2020 16:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgI3T77 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Sep 2020 15:59:59 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87392C061755
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 12:59:59 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k18so728838wmj.5
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 12:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pE61Sd1vDuqaQbcCILrO6eiawNT9TIKWlsp4yXv/UZ0=;
        b=I9UU2Dg6ToW37vXCux0J803ya8LMi3UGT/KppGsXAI0a0v8hhJW4poYleYqrNBLrhM
         5A0mATkNifbVTkZoE7ey8aJcA/3o5jYWmvVrQ5bIf8RWmxbAqw4y26/SckDWuPsO3NDc
         6j/ikKrxYm81mw39tSzKWRZ03miBA1HLbu5JxPSDB0Raz10wOEEorILNqkKlkuHiZ8ns
         q8KUTI/32kufp/BYZmqHXWM2ttvvPBtz7xhNSoGrhQoeFVJY/qlknj+ExmjOZOPARa93
         03E12z404Uq8U2X97xgaJHyDaMOVmynWDx2suEd1+frQAdeC5qv6KTDx6jmd95gxH6lf
         r0XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pE61Sd1vDuqaQbcCILrO6eiawNT9TIKWlsp4yXv/UZ0=;
        b=jHvqOI3fkyAX9R7xTe9cmFQd2CCzOdUgZ9eetEtrIlUH6Z2+Y1D8UQDd44upYfSJoT
         bYLyY4b18yhAS3ne3A/2uGaaIglgDEPn5Xs5glM0B/8VyiDXA7m29cSdOLoeuyzDQ42i
         lSDasYwrCzC6KMBoore27sYhmBwaUFKGj6BKkrW7yzZ34L2DD86nsU84WkIc7f61k9w9
         XDdKWmVFdnOCV6+sQTNUNRNfFCwChVjhFBuPkBGsRJf9Ox3sDUsNM5pRZvVeDwJa+LGd
         /5xqr9GbHr9LW+X8J/4Y83y17EwxANKFCrI7TY7p7uP1O2ze4aOfvHyJOht48ka3Nk0V
         4+qg==
X-Gm-Message-State: AOAM532SPePn6OTMkQZIyLub3koDTZwZ/7Qf6cFwPxFdB9RLSVhA9m/2
        PL0DSynFpO7LsNdj+GNcgOPIu+CmcAw=
X-Google-Smtp-Source: ABdhPJwvSk7L0agHdF+JILYEL8PyZ/gd5aBE6vVqj4MRzd4uAXXM6wG7VTU9Dr1f6WRgQoRhJRw7TA==
X-Received: by 2002:a1c:a184:: with SMTP id k126mr4729260wme.39.1601495998270;
        Wed, 30 Sep 2020 12:59:58 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-194.range109-152.btcentralplus.com. [109.152.100.194])
        by smtp.gmail.com with ESMTPSA id 63sm5537278wrc.63.2020.09.30.12.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 12:59:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next] io_uring: io_kiocb_ppos() style change
Date:   Wed, 30 Sep 2020 22:57:15 +0300
Message-Id: <f8a94f99d76357cd8e838568f5ba805860b3a180.1601492253.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Put brackets around bitwise ops in a complex expression

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7ee5e18218c2..631648dd63ac 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2915,7 +2915,7 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 
 static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
 {
-	return kiocb->ki_filp->f_mode & FMODE_STREAM ? NULL : &kiocb->ki_pos;
+	return (kiocb->ki_filp->f_mode & FMODE_STREAM) ? NULL : &kiocb->ki_pos;
 }
 
 /*
-- 
2.24.0

