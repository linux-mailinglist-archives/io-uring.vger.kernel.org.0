Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7FA1600CB
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 23:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbgBOWCZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 17:02:25 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37095 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgBOWCY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Feb 2020 17:02:24 -0500
Received: by mail-wm1-f67.google.com with SMTP id a6so14585744wme.2;
        Sat, 15 Feb 2020 14:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KGaOhDjvd7/47O4h5yLjj5gIn3lPBQYnlraxVtTV/Iw=;
        b=AaKum9z1hR/GpU4R3E8Dw9ya0aT/oY878btwx9OK5+UQz6QTt6HsVMbZiD7rN7bleV
         8eJHv7pxGaVG5If+kSESuJuTTOpJEDMqDJOmQggkRegoYYKjp+/AbaGNB+r8EM7bsq3G
         D82Dar8Ws6/sqtoslkZB3R/jhq/DY6bNhYLW7rfe5/cJQ7Q5oaoJir6xIRJB94ROIk71
         PNuz0BClH0qKW6IX0YIxxz+GL9xDjAGlzOV7F5mfW4KA7b9lfvG/BUdO8X7tqbVeSeyz
         9VsubRxE7/kVN/TaqO97h52YfB2e2IyTiD8p/ZL0bwKZn4TZobTKphk7cPxYdjKaeExy
         KIYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KGaOhDjvd7/47O4h5yLjj5gIn3lPBQYnlraxVtTV/Iw=;
        b=n5aMR4fQL55x3BCCPrvbQYfnqhD87xadWlEzn6UPF8WvMO5Iym0TZec/rUhnNuOsCx
         3xRrr9v+oTEHbIUyMQRzvSkc9K9jC8fnH7h/8ua83CL4kZFPzxKM7iXWfDKRJoh8ugry
         Wtp6KVt3X7iGlAFylo5B6oRVViLGfRFPSvjeMRhNFs+FlSzPr4lSaKI5IM9FAerc/nOg
         rssLzHm8l4Igr7LML035vCQ4Hl6RdNpli4EaEItPkKbDNGn/uDnp1teIG5SMeklvpD+N
         Q3A596x6WFt9qAaU86+REyi30SiwVpGvjK7I5YgB6VTNgrkrnr1qgsCB7AfqzYUjM0k8
         WbUA==
X-Gm-Message-State: APjAAAXEHLlTmFMWWnkucFL50wkLYOkBUIHvoMPtdMq1d26KqkxPG9av
        XHHlBgg8n/o+elejaRRVs5Wxr9DO
X-Google-Smtp-Source: APXvYqwqKfZ92Iz2t+RVLmUQ/6dTTuTN0shCZ8SgyXd+yk9CocI2QpPTFaRBA31ouUCCsRSyByiUjA==
X-Received: by 2002:a1c:a9c3:: with SMTP id s186mr11863491wme.64.1581804142385;
        Sat, 15 Feb 2020 14:02:22 -0800 (PST)
Received: from localhost.localdomain ([109.126.146.5])
        by smtp.gmail.com with ESMTPSA id b18sm13377021wru.50.2020.02.15.14.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 14:02:21 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] io_uring: add missing io_req_cancelled()
Date:   Sun, 16 Feb 2020 01:01:18 +0300
Message-Id: <da924cbc76ca1e5b2d1528ffd88bcb180704e531.1581785642.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581785642.git.asml.silence@gmail.com>
References: <cover.1581785642.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

fallocate_finish() is missing cancellation check. Add it.
It's safe to do that, as only flags setup and sqe fields copy are done
before it gets into __io_fallocate().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5a826017ebb8..7a132be72863 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2517,6 +2517,9 @@ static void io_fallocate_finish(struct io_wq_work **workptr)
 	struct io_kiocb *nxt = NULL;
 	int ret;
 
+	if (io_req_cancelled(req))
+		return;
+
 	ret = vfs_fallocate(req->file, req->sync.mode, req->sync.off,
 				req->sync.len);
 	if (ret < 0)
@@ -2904,6 +2907,7 @@ static void io_close_finish(struct io_wq_work **workptr)
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
 	struct io_kiocb *nxt = NULL;
 
+	/* not cancellable, don't do io_req_cancelled() */
 	__io_close_finish(req, &nxt);
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
-- 
2.24.0

