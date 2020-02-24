Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB5A416ADC4
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 18:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgBXRjs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 12:39:48 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:32768 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbgBXRjp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 12:39:45 -0500
Received: by mail-io1-f66.google.com with SMTP id z8so11160482ioh.0
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 09:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xc346JEoq4ZgOjqjqc/SZL17JugPBMQ/dyd7ko+nsLA=;
        b=PsaAAu32qyWCt4YomU6eDH/rdjnCG6aPbtG+AscKQQn+37krJF/+YJ2R1EKXrTzKVC
         QMWS71fgcFA/rUQFjRL2W84r3B0FfKdc0mvZwwLwDQJiBtVXww6Ok5BWJMDRN1HgVqL1
         ZkP7RK0lPeUUGqL9E2R+cocLPGhicDKnJxXkbYs6du9tlSxdDBa/OzFkzlNNlGUUCdtl
         lDUz7+wgSAb6vkAjJLrqdYzdEHNKDRJESkNzKYV1ryaFVWECftb6qItu7PepstoIPL39
         KYdJOebyGvHjZmnp59ShEDlMLM8IThEnQ4f2DBAcqUFhsxuRKk9Pprdao/aynJZ6Mlaa
         n7mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xc346JEoq4ZgOjqjqc/SZL17JugPBMQ/dyd7ko+nsLA=;
        b=JC1mp4jz8nMDrXEKZbxQqxlyKnL25lUeQTvyIMWNwC16rgep/ZWEw3fvkTdgVQoNZV
         KJGoK5PdZ6qbuQwAwkLODTSLaYK2gAmND8234vpMa8+9rtZkJSHVdpE2ar+MkYTltjzf
         w/N1gCGIdeuUi1LVkphRld38gXRNm0KgImU2ieK+7jwJR4s0i+2hjTZek271QRMTXdgh
         BSewASK5rpoNLcECEu8LWxdsIVwBbNe7F9q8uWZru9uDkSfhk5o+HwVYppf3y/ITJ38Q
         VPR84ZQgvdh6PbaMbEXbwU6ifJIm8COJnFHI5qzicKgkKP4RsdHg12m/rogfMWlps8Ga
         1E3Q==
X-Gm-Message-State: APjAAAXnWGqkk2tqWwScDST+Ca3S+WpSuIiVZLdSQS3iasTZ9EFSoqmv
        NI8w0mQbwyDAJbJYhcFoDMgwsW7cXYw=
X-Google-Smtp-Source: APXvYqyinMdhD5PHOuvJpfzJo1TdU8ho9BVVd12YPW0qViJOUGNrBbizh4AnTu3BNEQBys4l+9w+NQ==
X-Received: by 2002:a5e:940f:: with SMTP id q15mr47064024ioj.218.1582565982464;
        Mon, 24 Feb 2020 09:39:42 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p79sm4541982ill.66.2020.02.24.09.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 09:39:42 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring: store io_kiocb in wait->private
Date:   Mon, 24 Feb 2020 10:39:34 -0700
Message-Id: <20200224173937.16481-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200224173937.16481-1-axboe@kernel.dk>
References: <20200224173937.16481-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Store the io_kiocb in the private field instead of the poll entry, this
is in preparation for allowing multiple waitqueues.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 89e3467e905b..2b8b86a2ead8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3730,8 +3730,8 @@ static void io_poll_trigger_evfd(struct io_wq_work **workptr)
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			void *key)
 {
-	struct io_poll_iocb *poll = wait->private;
-	struct io_kiocb *req = container_of(poll, struct io_kiocb, poll);
+	struct io_kiocb *req = wait->private;
+	struct io_poll_iocb *poll = &req->poll;
 	struct io_ring_ctx *ctx = req->ctx;
 	__poll_t mask = key_to_poll(key);
 
@@ -3854,7 +3854,7 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
 	/* initialized the list so that we can do list_empty checks */
 	INIT_LIST_HEAD(&poll->wait.entry);
 	init_waitqueue_func_entry(&poll->wait, io_poll_wake);
-	poll->wait.private = poll;
+	poll->wait.private = req;
 
 	INIT_LIST_HEAD(&req->list);
 
-- 
2.25.1

