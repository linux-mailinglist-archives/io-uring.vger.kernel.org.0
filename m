Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 496BD16A18B
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 10:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgBXJQC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 04:16:02 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39393 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgBXJQC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 04:16:02 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so622167wrn.6
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 01:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eeqCgoua34K4Ulvjo1lAurX+uxPOpWUtE7r7fknazug=;
        b=rXGs6mHABEtkKlzuKpCzyV5aF5YZjkJS8kio8krjAQKBJJD2+QPwsUUn9oip2RrQIo
         kfbBFs2EZXV62qa5gkJTAl7ZDjw3PV4n2yT6WnVdx8zVuuRyfvzWW8R0Q5ctSpPPJlQI
         32pH5VSmpXBFdnjQ2fAPLx7ThupkPTSYxT5s1lnaBAbVh36yx5azFRbYX04NrU52iSUv
         7OF/bqy9fMRSn7+nFv+42rKt/MdCzQ4D7Qhzrr4OArO/dmMzQx5iQ8e6eADyWQJ4zYqQ
         alUQeTqhV+UbQuejaoiVk/3/7L2AJEiQHKPSQQfFitgKvdcRPLWbi/lr5sKFQCcPeDay
         J4HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eeqCgoua34K4Ulvjo1lAurX+uxPOpWUtE7r7fknazug=;
        b=WK+EUgh+s73KRj8Qaqy9jaupzHAxi7/sIKtDdfK9RHlWgS+b2ZJMgwqhQYVz94UFfC
         ubSp8RVbEbfHrSo+v69WYRSthz1Ff2G+7STICgJ9ETGMViWpJ9EAlsGFqlflQe5LrUvS
         kPFZKwFDxmkmp6//qhAgHvHlmwjsiuugadkpio1X0aeIJiL9CgSFTaP7ulGgRmObnyrM
         K/cTIg78J6PSD9lVkN/y6rOhm/mVYqtckMj1nLGTVbPWqI7LMAg69eOEeZ0L/C5cBOPS
         qdTJOD0KHYYo7BkrS+FRP4y2GrUSNGbZHZV38YEIEbf0xoE7QxHyaRf6BsECwp4UdKCh
         BkJg==
X-Gm-Message-State: APjAAAXA7jZTd6hgv9+uM64RJYx6epp8qQD+WiqrDOfsdJBQiXIjZh5z
        P9VA7IKIH4UBXTT3/ucIfLUVbZW4
X-Google-Smtp-Source: APXvYqwAXjpNN2EE6DWgw5VAzl9ve7lx2BhzlEFji5wt3pQnE38s7XCy3qTcUZjK+oliX6svudIm6A==
X-Received: by 2002:adf:8294:: with SMTP id 20mr223482wrc.175.1582535760713;
        Mon, 24 Feb 2020 01:16:00 -0800 (PST)
Received: from localhost.localdomain ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id 18sm17568780wmf.1.2020.02.24.01.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 01:16:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH RFC] io_uring: remove retries from io_wq_submit_work()
Date:   Mon, 24 Feb 2020 12:15:11 +0300
Message-Id: <843cc96a407b2cbfe869d9665c8120bdde34683e.1582535688.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It seems no opcode may return -EAGAIN for non-blocking case and expect
to be reissued. Remove retry code from io_wq_submit_work().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b9dd94143c30..b2ce8a3d3dd1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4622,26 +4622,14 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 	struct io_wq_work *work = *workptr;
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_kiocb *nxt = NULL;
-	int ret = 0;
+	int ret;
 
 	/* if NO_CANCEL is set, we must still run the work */
 	if ((work->flags & (IO_WQ_WORK_CANCEL|IO_WQ_WORK_NO_CANCEL)) ==
 				IO_WQ_WORK_CANCEL) {
 		ret = -ECANCELED;
-	}
-
-	if (!ret) {
-		do {
-			ret = io_issue_sqe(req, NULL, &nxt, false);
-			/*
-			 * We can get EAGAIN for polled IO even though we're
-			 * forcing a sync submission from here, since we can't
-			 * wait for request slots on the block side.
-			 */
-			if (ret != -EAGAIN)
-				break;
-			cond_resched();
-		} while (1);
+	} else {
+		ret = io_issue_sqe(req, NULL, &nxt, false);
 	}
 
 	/* drop submission reference */
-- 
2.24.0

