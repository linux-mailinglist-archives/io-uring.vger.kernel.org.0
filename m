Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B124E3EC860
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 11:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237133AbhHOJlg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 05:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhHOJlf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 05:41:35 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8C8C061764
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:05 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id h13so19390360wrp.1
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=O+uFvWlR4lOcQLMxy+BEWzTOXs3QyMA9Pr2S70OOr+E=;
        b=bl+YDDwe1gLQ3cpYGB22WXKe6QGKuZAxayftcc/wosrQ25EKbZI5aXmdLfaTLzdt4R
         NcXZMg3QDA2dTA1hi1lCYxk6eEBMODGRPUkfcI048dyw5Bnr/t3dl6WGiN3ZVhbs+z7/
         W4b4hNeQR/2BU4C1755lAkomV6Bfzx73+dVNW5wKZV8jyY2vr5RVJS3n6YnFTfiu7Yet
         NDYoYwc5Z8CJfBYAT8BlSbCLH0AnouXwOKmsx66Q23SEtIqksLLLcb7526FatuMUX2dR
         wyWtDKI6kd9YyqzMk+BxMmvwOO8CdS12lmYezb33eAhpinA/RzZKfiPhn1PrdubJ2WzC
         mKog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O+uFvWlR4lOcQLMxy+BEWzTOXs3QyMA9Pr2S70OOr+E=;
        b=tSDijEeR9Vbd30aEj6uGE6qtA0kiDrxswBQx+Zfep4HSR0y0/Pr2p/J5G97UFRdfbL
         akMnR0XxO1vCz4kWLVYYgkL4Vo/i9LTTXOy8kIWD5lfS0yWjpHviS/Uvkr79tGo6M22c
         QJxDg0+TovHy71ZLQdxhUsNQCrdlpsfCCbrrYE3d1H0KziJVz0KXLjKLks0Rm/mK8dFa
         GXbcaeXHAIbdHLEns4KKxrKnoqTcljQHC6zCD4U2iW7Z251YxiIkwDPLJYdIEC9rfMWE
         4wGGFD1F6i0jfb4Ae4hHaPymTUhrLPtcrxBaUPRJ0GF3y0bQG490Nz1W0cYiKLzmuAha
         YOxQ==
X-Gm-Message-State: AOAM533t23T7InTdtKdTlCrd+jlOjMHIcGtTri376KNVbP00BP3kOlxr
        L3W78FBS8SqO5mr1152IdCw=
X-Google-Smtp-Source: ABdhPJwBIivf3qe0hA0wcTmj+pKWfNIH5sWS1HurstD7z/faI7Dr6tGKrGZSd9uQFZMaKF3cak863Q==
X-Received: by 2002:adf:f704:: with SMTP id r4mr12919448wrp.389.1629020464619;
        Sun, 15 Aug 2021 02:41:04 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id t8sm8828815wrx.27.2021.08.15.02.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 02:41:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 2/9] io_uring: don't inflight-track linked timeouts
Date:   Sun, 15 Aug 2021 10:40:19 +0100
Message-Id: <e1b05cf47cb69df2305efdbee8cf7ba36f46c1a3.1628981736.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628981736.git.asml.silence@gmail.com>
References: <cover.1628981736.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Tracking linked timeouts as infligh was needed to make sure that io-wq
is not destroyed by io_uring_cancel_generic() racing with
io_async_cancel_one() accessing it. Now, cancellations issued by linked
timeouts are done in the task context, so it's already synchronised.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 761bfb56ed3b..fde76d502fff 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5699,8 +5699,6 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	data->mode = io_translate_timeout_mode(flags);
 	hrtimer_init(&data->timer, CLOCK_MONOTONIC, data->mode);
-	if (is_timeout_link)
-		io_req_track_inflight(req);
 	return 0;
 }
 
-- 
2.32.0

