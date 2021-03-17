Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A765F33F583
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 17:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhCQQaP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 12:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhCQQ3r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 12:29:47 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2A6C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:47 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id z13so41601203iox.8
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2QyYK7ddECLVWByTbcbwoQb27WIL6znx3V0IaxIsIV4=;
        b=QIPKQL8+e/nJBbBzIrC5m8jne6e/gzbTVrXEst03j1vfTqIZVlIXYdijVf8tVsUb8n
         hFpXBphuf4VWL8ym/PVPAbwRN9aB4R7z5/blNjP8icy/aWn2vMiACaOdvFowoCcdfNTZ
         2ytMhanIcB7YC0kr66gB8QbGtAXg/2j04lL+DZb7V9wAwHg9bqUIgbY5tI0BqEmOPdTC
         HSgVZ6xjqVQ+AEc89G19kz1E6zSdTXv/arFHrYv9g5FZi8zXZtMCfnyX5zGnWc2LsDmF
         99lFKfviPyBMZQEAEQd7SBDq7v1zu3zsUmKjOEG1/tgqeDjdC5qY68ibPFJjSteJ/Q4W
         UP0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2QyYK7ddECLVWByTbcbwoQb27WIL6znx3V0IaxIsIV4=;
        b=FHtEiYQnjZlxQOHdU5WE9rvRNz9ZnUNmAEw2CMD8xpymhs41s2Po3tzIuGGN3MaAf8
         gU8Fq7NxQ/cWNiugYfevNxpSlIiXWnG6J2iQl3PfbSFtEtG+g2SGOHpA6d+EvXAOzPnj
         q8NC3Qupr9S4dtYxKq0dr+zJrZpk93Z7cu0d03oq0IzQyub+JBm/yPrn7HFEk2CNYxOY
         R7HJ0bJGIycMBb/F/UY+nihIdAhRLvyrM1kp4K4zZIIcfUDoeKouEDhg/rzdkus1howu
         gYS9mBZrsFfKGZPL/CEAaFP34zWiR7R520hFIj2bMEpyakzw+e6rVMw9jV/sEftQqrcP
         ah3w==
X-Gm-Message-State: AOAM5331+atLf1+aICsv+rImee4K5RqltLU6sL1HVKgOs0MtMJSYVBOT
        mqN1eXnKD0laqmVKk1btZFqZqaLXNT2R9w==
X-Google-Smtp-Source: ABdhPJyVHPIsKBpZ39T3I+9tE+zit4lv/+otoKQ5x5tu7qfeM+grkjH0AfI7CIiVlh0pJii7vUardA==
X-Received: by 2002:a05:6638:102f:: with SMTP id n15mr3510839jan.28.1615998586824;
        Wed, 17 Mar 2021 09:29:46 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h1sm11164271ilo.64.2021.03.17.09.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 09:29:46 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/9] io_uring: transform ret == 0 for poll cancelation completions
Date:   Wed, 17 Mar 2021 10:29:36 -0600
Message-Id: <20210317162943.173837-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210317162943.173837-1-axboe@kernel.dk>
References: <20210317162943.173837-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We can set canceled == true and complete out-of-line, ensure that we catch
that and correctly return -ECANCELED if the poll operation got canceled.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4aa93dfa3186..dbca1de0be2f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4918,6 +4918,9 @@ static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
+	if (!error && req->poll.canceled)
+		error = -ECANCELED;
+
 	io_poll_remove_double(req);
 	req->poll.done = true;
 	io_cqring_fill_event(req, error ? error : mangle_poll(mask));
-- 
2.31.0

