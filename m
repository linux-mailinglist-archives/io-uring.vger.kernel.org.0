Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14C332C998
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbhCDBJ5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376858AbhCDAb1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:31:27 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD669C0613BA
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:15 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id s23so5516002pji.1
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9xJvdvjmnl7jR1nQUGt2svaVG0mhZHqsLbj3H1rL+dM=;
        b=ipGIbOKUkottUCRFj78gK1OEbXmQo6aYr3wQWti3XRhK6PXydYADnoRwVQibuOWSyq
         rSitMFpWxMubDDhzjrrupQH54UndhBv0EDq7Ei/sDDoV1uP5ZdXsTzYcQ+LTJO0bWjyl
         hHq4j7hwPESS+4QFNlJ7/NAvyBaPgOLjrpRM+XEmYZ1PR8PaI9RKsO8O/VLQ2/z+WVB1
         kWVX5nnFPMzeN0t2eZXoAfYEp9yujFyXJefO2djxnxSpoS+gCc8nF6/bzpGSfntWO7fs
         zAvpXe9QEKfjvs/YRNktQxgShBUsq/iztb0p+JWlsk/yeTrITNJOjQtljpmCEO0fT9/2
         TMiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9xJvdvjmnl7jR1nQUGt2svaVG0mhZHqsLbj3H1rL+dM=;
        b=K2PJBEIdATS7UGTPZNO5YCNcdqvJ5wDYJdLOhCNcHiy1a9V6R12KYdh27EXG9/WgNf
         5ARvOsTfDx233Vd2QqoQMPyDQEDiK/mzPp/nsoS0F2ccvyH7C5LkoUg2JjfzDbYF8Hqu
         4ZWpjrkwLkT9HCVEiruRdyHdg8FlMmmZvoio8ukfYmUM0XCBZsqkGZc3nykhYJN4BlOd
         2qMx580wD/bcRY8Ynz7X3pRn+Vqi0QMFbKUNBaes8E9qJMsk1UkvuSz6q2Pd3WPboTzl
         7aiutt7bKvbM2W8zlKRz+fJArjMSQB3MLomQuIFeiYRdrhXIWCq7Iuf1OOfl3jSUAoPu
         axBQ==
X-Gm-Message-State: AOAM5337j7YOOdu3K5M4/xBanQJ41RIFt0HdW0N9wcL7KqPG/Eetz+Lz
        1MStJikIx2yX4rE3AlbwStR1FnDXGfNpf4lU
X-Google-Smtp-Source: ABdhPJzA0dAuglYoyWfI785XFVXYpVZzFfcpLDb62FnzqkO5R+OhGmcoEGJAjSwrU0tfu8tLefcZ1Q==
X-Received: by 2002:a17:902:ea09:b029:e3:a720:b83 with SMTP id s9-20020a170902ea09b02900e3a7200b83mr1537933plg.51.1614817634955;
        Wed, 03 Mar 2021 16:27:14 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:14 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/33] io_uring: run fallback on cancellation
Date:   Wed,  3 Mar 2021 17:26:35 -0700
Message-Id: <20210304002700.374417-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

io_uring_try_cancel_requests() matches not only current's requests, but
also of other exiting tasks, so we need to actively cancel them and not
just wait, especially since the function can be called on flush during
do_exit() -> exit_files().
Even if it's not a problem for now, it's much nicer to know that the
function tries to cancel everything it can.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d55c9ab6314a..9d6696ff5748 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8518,9 +8518,10 @@ static int io_remove_personalities(int id, void *p, void *data)
 	return 0;
 }
 
-static void io_run_ctx_fallback(struct io_ring_ctx *ctx)
+static bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
 {
 	struct callback_head *work, *head, *next;
+	bool executed = false;
 
 	do {
 		do {
@@ -8537,7 +8538,10 @@ static void io_run_ctx_fallback(struct io_ring_ctx *ctx)
 			work = next;
 			cond_resched();
 		} while (work);
+		executed = true;
 	} while (1);
+
+	return executed;
 }
 
 static void io_ring_exit_work(struct work_struct *work)
@@ -8677,6 +8681,7 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 		ret |= io_poll_remove_all(ctx, task, files);
 		ret |= io_kill_timeouts(ctx, task, files);
 		ret |= io_run_task_work();
+		ret |= io_run_ctx_fallback(ctx);
 		io_cqring_overflow_flush(ctx, true, task, files);
 		if (!ret)
 			break;
-- 
2.30.1

