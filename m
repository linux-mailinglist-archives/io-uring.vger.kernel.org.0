Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB58158478
	for <lists+io-uring@lfdr.de>; Mon, 10 Feb 2020 21:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgBJU4z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Feb 2020 15:56:55 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:33960 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgBJU4z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Feb 2020 15:56:55 -0500
Received: by mail-io1-f68.google.com with SMTP id z193so9232033iof.1
        for <io-uring@vger.kernel.org>; Mon, 10 Feb 2020 12:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PQ+X/J4PnDcqhsKtuqhySGeAq2vXuu2agzW1bzkCXng=;
        b=znJuxNIm0MczmCC+kOcXFBMp+HkdYVf9trDSjS70YeveHriHDP5B8fFSDuMElC3zXq
         O1TNTJJtjg8fU4C0KSQ3LSLoMMimpYnIE8evXXJh0lSTeN3rEca3MoiZwWQVhJPaKMv8
         nMOnTwKle+jvcN13SBG8SSExfOPrdkgCwplMgYaXlI9EoUl54AjePWRQuO2WaJCUcUt4
         D7OXw7mgBfc/kBqgEtPlQtU0omALPhz/unaDOmi211xjpkPhA0N/f8VDVRD5JjWUjS6S
         uqXzdbqm1DTFwXeFDw0k2M6RSQ0hDpsbtlzH8dcWr7V6GBB2I7erwLfgLbHLngNHMVub
         4unQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PQ+X/J4PnDcqhsKtuqhySGeAq2vXuu2agzW1bzkCXng=;
        b=eWgGA+I/L2/4wNIavFTJvsswg2QKD48e+Fus2tnSzAGJ5GIFWG0E1cOXyfmh8oKjSo
         2uDorXFv9dbdg0mvPJVQFCxcu10ovZXbKOybEmZOYyCXhfIvFHEDg8CRKTxMBb7eO5FZ
         rdE8Bckdpxu2VYKVu+8g3V8cOnN57Bat48PSYhH1IJ0ve+oTC+Pd1OWZpFmBBwl5oES3
         Xa9d3fqyo9Gbd5mmoUjUuaiaRFld4dnyvWgwFWlra7GiPOplvnHepcAUfknV0Gv8OOQy
         lzqylANrLGN6G+dnXloh6xW5UjwhqGu93K0xEOz8jbKSZQ0xYxY1OVgFSiS6Oq1s/PA8
         0Nyg==
X-Gm-Message-State: APjAAAWBVOoY/dK4K8KRElAJ+OQBJIlC7aqDlMXg3AcF0PDXdBxY5jOz
        Xb75FUWlg/RSIslG8McDBaOcT/MaU4A=
X-Google-Smtp-Source: APXvYqxjom8KrvrXWAMBZ2OhmdHlBHz3YD+9DnpXgfAzXF1qWZfhg+3OesBdH+QTzWF/Je5lzo0/8Q==
X-Received: by 2002:a02:c78f:: with SMTP id n15mr11913519jao.100.1581368213351;
        Mon, 10 Feb 2020 12:56:53 -0800 (PST)
Received: from localhost.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c4sm391479ioa.72.2020.02.10.12.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 12:56:52 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: store io_kiocb in wait->private
Date:   Mon, 10 Feb 2020 13:56:48 -0700
Message-Id: <20200210205650.14361-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210205650.14361-1-axboe@kernel.dk>
References: <20200210205650.14361-1-axboe@kernel.dk>
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
index 63beda9bafc5..3a0f7d190650 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3624,8 +3624,8 @@ static void io_poll_trigger_evfd(struct io_wq_work **workptr)
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			void *key)
 {
-	struct io_poll_iocb *poll = wait->private;
-	struct io_kiocb *req = container_of(poll, struct io_kiocb, poll);
+	struct io_kiocb *req = wait->private;
+	struct io_poll_iocb *poll = &req->poll;
 	struct io_ring_ctx *ctx = req->ctx;
 	__poll_t mask = key_to_poll(key);
 
@@ -3748,7 +3748,7 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
 	/* initialized the list so that we can do list_empty checks */
 	INIT_LIST_HEAD(&poll->wait.entry);
 	init_waitqueue_func_entry(&poll->wait, io_poll_wake);
-	poll->wait.private = poll;
+	poll->wait.private = req;
 
 	INIT_LIST_HEAD(&req->list);
 
-- 
2.25.0

