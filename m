Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A85020C755
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 11:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgF1Jy2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 05:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgF1Jy2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 05:54:28 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309DDC061794
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:28 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id mb16so13384950ejb.4
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=lFj17AkyvI+s6Y+BzRlbxGZ0DvjoGvaXQ5bOK54MNps=;
        b=ZRqX+UtOh+PHCAzZU2We9GmvOKuGwbfaFnBlAPId6YnQecMEVjPKabHftoFo2fPBaT
         i0CMAHYF+zfO3oEZgQCjEJ3DxxeL64Cd5lsv59qyBmQHHwC89Vwiqr8QSM4Y6uQJFJCj
         vO4KM3HrKVillk6Gtgx7OlGU04sdqUUM5TpUMpryFYbN259wJnxSt0fSmN2u8HF1RZIz
         Bxo+roNCU1YO1UV4HHacsJc2rzqntSpQ+0rTPKOWXP+qGT0Tde2mECWJWC3lWAFSTNo0
         1HEsTTBkJN0khf/yaANTdM1/2OeepWXIGGa/09KXe9h4lptWawk4JDhnoRTROiunnoF5
         VmRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lFj17AkyvI+s6Y+BzRlbxGZ0DvjoGvaXQ5bOK54MNps=;
        b=AjDm+I49gM6K6jtNB8G0ubtZnEFbMEZSBSrnWSpB10qDLMrLrB2cH+vrOwwaO04CE5
         NiHYExRSAqDs/ES1XRh1MG3edFdIMSuHghsHQ/PSqwOUKNKtA+3bd83+tYgVsHSJs/P/
         fM76c59jh0zP01hIoOAtfQImQYjByTH8Z8UZCeFN7dW8T5H8qxT/+j4pgkqekqk7D0zh
         m0QhBe80zuieJj6fYQorCYeVSBUoZ7G3GHIzDB51P83ZJu3zSqg5dNfHW4apaI9WnzDy
         +RN+WU6LAJISrjomfFyuFXWlk6RU5eELp01XClOGoBldMfqt2w8wki0qXEX7YqBf7YDx
         XjUw==
X-Gm-Message-State: AOAM5338puR1qhsQn9vB+fBdFyXqwfrcngMQ7VUYr8AykRTz6uoojCGb
        gq/aYC8PiOXyqD+kakrXX2eyJ1VC
X-Google-Smtp-Source: ABdhPJz9A98KEmrzES6rpXfuS5tnIuhwuYKDHhorLsQrJCmgqCRRnChIVwj48ZCJJAwFT6v6YZoHqg==
X-Received: by 2002:a17:906:3282:: with SMTP id 2mr9268036ejw.93.1593338066956;
        Sun, 28 Jun 2020 02:54:26 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id w15sm10089490ejk.103.2020.06.28.02.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 02:54:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/10] io_uring: do task_work_run() during iopoll
Date:   Sun, 28 Jun 2020 12:52:37 +0300
Message-Id: <14af64712d6f80c457775ad2c972858e89359b3f.1593337097.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593337097.git.asml.silence@gmail.com>
References: <cover.1593337097.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are a lot of new users of task_work, and some of task_work_add()
may happen while we do io polling, thus make iopoll from time to time
to do task_work_run(), so it doesn't poll for sitting there reqs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 79d5680219d1..75ec0d952cb5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2052,6 +2052,8 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
 		 */
 		if (!(++iters & 7)) {
 			mutex_unlock(&ctx->uring_lock);
+			if (current->task_works)
+				task_work_run();
 			mutex_lock(&ctx->uring_lock);
 		}
 
-- 
2.24.0

