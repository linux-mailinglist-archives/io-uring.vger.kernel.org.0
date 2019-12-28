Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE3D012BEA9
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 20:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfL1TVW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 14:21:22 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33628 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfL1TVW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 14:21:22 -0500
Received: by mail-pg1-f194.google.com with SMTP id 6so16102158pgk.0
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2019 11:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g7AxaW92arx9yT6vScWQcw783EksnKA+20RBNSBXEJ4=;
        b=p7ilHNNLdGpT4626c86ElKBnCPYtmgVzZlBD/VNJ6A1rIIyz7S0vp1Pq2lU/YL8ZQk
         8W4OcAwJyvSZbPNaEYHAHAde0Jiql2hmu92IZQAdKJ6gyCLruLzAClXbHvq6Hj0mSQE2
         yxT5mS93jopL57MDELYdiLPzJYlezgRDAFSaBa4YOfMOCu7ezf1E/Qq5O61bWDeEMdfx
         4eqky29HDk0ljxt89tWkc5d1OJ2GEKQc2E7yNXbevqvdb1tvRLedkmTYNL9Hzqx6NavY
         Qj5e2CNIAS2zP46v/R1nQRVu5wfpZP3SHu4Wk1Rrlx6J/pbsKIZQkDwiW5IU2pfa2GVO
         Omwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g7AxaW92arx9yT6vScWQcw783EksnKA+20RBNSBXEJ4=;
        b=h42KCWN6zcdVmGXTaO3F7xb9K3rboejPXNiMx5BJpP7QcPyLW5K1zLxBoui1tpxw8Y
         7DwPgaVRvHo6OtGy7MSCRN6HaaBzuIqcDUuwW3H9eaImNtQEoE3ssBL/HZwAKzG1pTZR
         Sqr0eCb+kjAJY0VJSAHlsjaZD7aRLmtMRMC8rAD9cubU1i6tNoC8vAE6V8ZTSK0o3VGX
         6db/v9GwTZg5K+nWiX0HXZIU/N4QDmwnvWi3/P4CLnriYih83wYQDYhNp7s0Rz5my60q
         j10rdkJ0J7CwrXP/8x4TkeKHcIJACtOQ5AKnLGvqpI3fPp1bXFdT8LziUXawapCv0MkW
         Snhw==
X-Gm-Message-State: APjAAAWnzJpLscbwZ5JIOc77LBfZtljSvE6KjSP2VhcD2HF6T1YUDkQh
        lwSHVp/8EcfZBHIoaHreA7IARcsscuA2aA==
X-Google-Smtp-Source: APXvYqz4PPPh2NqZ85nH1CtRmMTE5suWBwmCU5KQMoU5c5F2QnS8k2w3c73J44KtmX5Bj3A6h/Zk4g==
X-Received: by 2002:a63:5818:: with SMTP id m24mr62113792pgb.358.1577560881594;
        Sat, 28 Dec 2019 11:21:21 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z30sm47067902pfq.154.2019.12.28.11.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 11:21:21 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/9] io_uring: remove two unnecessary function declarations
Date:   Sat, 28 Dec 2019 12:21:10 -0700
Message-Id: <20191228192118.4005-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191228192118.4005-1-axboe@kernel.dk>
References: <20191228192118.4005-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_free_req() and io_double_put_req() aren't used before they are
defined, so we can kill these two forwards.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d787a97febf8..40735ecc09c9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -518,9 +518,7 @@ struct io_submit_state {
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
-static void __io_free_req(struct io_kiocb *req);
 static void io_put_req(struct io_kiocb *req);
-static void io_double_put_req(struct io_kiocb *req);
 static void __io_double_put_req(struct io_kiocb *req);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
-- 
2.24.1

