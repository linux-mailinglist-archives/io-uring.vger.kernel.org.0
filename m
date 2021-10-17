Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388AD430C04
	for <lists+io-uring@lfdr.de>; Sun, 17 Oct 2021 22:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242900AbhJQUf1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Oct 2021 16:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242908AbhJQUfZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Oct 2021 16:35:25 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F08C061765
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 13:33:15 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w19so62153720edd.2
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 13:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7pfepTmtTpzWcKGnNxOyFO/05evJpN2HwsNDV2ctlLc=;
        b=TVy3bEqDyqrD/x4sVwxtBWSJW8HQX4aiFbW4SwXQXwO+3ypGjORqufrnLvJQL/5fj1
         uet6DWMdlNLQfT3Ma8A+xwDlVIV+3exYde3dGUbG7Aenkd7OkBU/KYaE1dEhvP2AV1/1
         SsCGcm6ZQu1knMEz/NL+R85x/Q9ixksHJ0XLTXGuPe6DrGsmXjgZEblMakvfxJuv9++W
         xsvxb67KjEUwBMd6PX1Vz5OSSrHAU4zTDdcXGrWSKV9ZhP4+GSRHLz0tA5UL6fAsNyYD
         LTBSWquGbUcjWPbKLPSo/9VUfNVJJ9FdOJlt25aWh5Mv6TjdaD+hWKt63oNbpZ9NPQPm
         orkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7pfepTmtTpzWcKGnNxOyFO/05evJpN2HwsNDV2ctlLc=;
        b=DuVuhTW87hZmGxsHVTwqwnkLMlpBiD2I0iluMdHX/BLCKgc15evUPTzf2U5r7/5fDZ
         66Z9+fJtpR6IneX2q+2JnrlZ9hncSZFlYwpMpqNKFvj+OOlZuhilven8F8EX/+okeilT
         qReRrZ0VYuAsGAvtZv1oYuj4FTNpDpxgNqxazHihkGhhBcj2Cw7aUVE/scuFSFVZv4dj
         19ze8LZSxyN6Xim1jNJdYFLOv0pJW1rnAI+8XsO85KU8gFSLMJ2DFLzTGpDrjs8U+gal
         bF5G0xVvBK3ig/O+KNiuBGGnGrvCO5gBz5GSiUKugeReO5P7D1CBcs5kO9K+rq6Vai7e
         8yfg==
X-Gm-Message-State: AOAM533kAMRWeLGNr+y0sOYIAEpO7+8Hpx6Z6n6+jx5QilH4i+a/rxwP
        Rrubwd0t2wfq3S7uWh6eZiQz0bv3kIPRLw==
X-Google-Smtp-Source: ABdhPJznZuWnnkK01BMeFd6ZszIz0TE1B9bJUWJ6fRhQpeR6h0v3VyONptn9v3/Q8ZWqsuMLMeq14Q==
X-Received: by 2002:a17:906:fcbb:: with SMTP id qw27mr24603267ejb.366.1634502793465;
        Sun, 17 Oct 2021 13:33:13 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.145.195])
        by smtp.gmail.com with ESMTPSA id ca4sm8119651ejb.1.2021.10.17.13.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 13:33:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 2/2] io_uring: fix async_data checks for msg setup
Date:   Sun, 17 Oct 2021 20:33:22 +0000
Message-Id: <6c5577b5189d22112e5d5716e5f1118b25418a19.1634501363.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1634501363.git.asml.silence@gmail.com>
References: <cover.1634501363.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We should use req_has_async_data() instead of directly testing
->async_data to see if async_data has been allocated, there is one spot
slipped that doesn't follow the rule.

Fixes: 016e0451e9ed0 ("io_uring: control ->async_data with a REQ_F flag")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 40b1697e7354..7ead1507be9b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4683,9 +4683,9 @@ static int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
 static int io_setup_async_msg(struct io_kiocb *req,
 			      struct io_async_msghdr *kmsg)
 {
-	struct io_async_msghdr *async_msg = req->async_data;
+	struct io_async_msghdr *async_msg;
 
-	if (async_msg)
+	if (req_has_async_data(req))
 		return -EAGAIN;
 	if (io_alloc_async_data(req)) {
 		kfree(kmsg->free_iov);
-- 
2.33.1

