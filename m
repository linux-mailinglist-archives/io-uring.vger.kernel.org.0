Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2455417653A
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2020 21:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgCBUrK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Mar 2020 15:47:10 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:33685 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgCBUrK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Mar 2020 15:47:10 -0500
Received: by mail-wr1-f42.google.com with SMTP id x7so1617957wrr.0
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2020 12:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GOkchIsH+fJbRcVsItZnjeGr7jBvjP/k+9ebvFok7/g=;
        b=auSVC3PvC6dxKvxGolMibYXE1LBVldPHdsMvTxgE1Zc8Y6WL4lo9ERBknHtkdnBxcl
         /AagibGnJE5ZA0SkSPCajo0YJ1sWGZx9IOBvadtoNSWsvh31by3FZxDMPVeFdVPYHv6c
         pP0VNelwCxOYW8iWoXk/JNBIg0AqXormRo75YI8KwIWwjIksLz7Pa3pHnJBbwuiDCPgI
         NjHoKVEoykNdOZJ6FdXKnk0LTRphwoPpCd+vWvKizbZ5mezgA9oriEMSTdew2HTE/f15
         d0l2AtKsD2ENRh5VR1eCxBEnKpCiR8IccklCXjn7EyopaHcNUwS1/utn+5RM8+OvWXHD
         CJ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GOkchIsH+fJbRcVsItZnjeGr7jBvjP/k+9ebvFok7/g=;
        b=Tj7cwzZO8jNy/AczkJpCs8XdHmmpKxgHAKAKUW92DjQ+TNDioGc/1sCId7/Xvlwp4C
         AWWa1QASaPsDqPqZQvDmWm8IbHZtC5Zo59/OdQ3vbhg1SzA4t057Oth+kXFX2+MaFh1f
         Kjd5SDpLMR+vwXGGyhVNgkwOUfvo1fTUvIDpfw+ZneDCdKFYWVvcp6ZV/IYyEmPmq50p
         ZU6viunu623Q2BsekKth8vr5efeHyl9yqbViX0GtXBNMBWwcBAgkOAhVNQ/fbag2DcN7
         5A3HltAV3RFsF+NCyV0QgHqEyP4qkCgi9mfcIdZZebFgg+tSgAmBHCiZ2dVi90hmA2cw
         7WMg==
X-Gm-Message-State: ANhLgQ0n4RnBml8RMhIhPHidFO4hy4p5megT+bF9akN/P+dT10uZZpIu
        wxSBu5DRXkEzkiUVPKyK/4E=
X-Google-Smtp-Source: ADFU+vuSLXbmZTeYm7Zlps3YezBEre5Onekj+eEwo/eyop/ybx58s5ibVFpswfARoLynHIHtmTwYkA==
X-Received: by 2002:a5d:4b50:: with SMTP id w16mr1322397wrs.230.1583182028616;
        Mon, 02 Mar 2020 12:47:08 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id c16sm258981wrm.24.2020.03.02.12.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 12:47:08 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] io-wq: remove io_wq_flush and IO_WQ_WORK_INTERNAL
Date:   Mon,  2 Mar 2020 23:46:10 +0300
Message-Id: <d29bb1d27f45cb408bd7f530958235b0a4f251f2.1583181133.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_wq_flush() is buggy, during cancellation an flush associated work may
be passed to user's (i.e. io_uring) @match callback, which doesn't a
work of a different layout. Neither sounds right cancellation of
internal work by io-wq users.

As it's not used anyway, delete it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 38 +-------------------------------------
 fs/io-wq.h |  2 --
 2 files changed, 1 insertion(+), 39 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index f74a105ab968..042c7e2057ef 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -497,7 +497,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		if (test_bit(IO_WQ_BIT_CANCEL, &wq->state))
 			work->flags |= IO_WQ_WORK_CANCEL;
 
-		if (wq->get_work && !(work->flags & IO_WQ_WORK_INTERNAL)) {
+		if (wq->get_work) {
 			put_work = work;
 			wq->get_work(work);
 		}
@@ -1052,42 +1052,6 @@ enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid)
 	return ret;
 }
 
-struct io_wq_flush_data {
-	struct io_wq_work work;
-	struct completion done;
-};
-
-static void io_wq_flush_func(struct io_wq_work **workptr)
-{
-	struct io_wq_work *work = *workptr;
-	struct io_wq_flush_data *data;
-
-	data = container_of(work, struct io_wq_flush_data, work);
-	complete(&data->done);
-}
-
-/*
- * Doesn't wait for previously queued work to finish. When this completes,
- * it just means that previously queued work was started.
- */
-void io_wq_flush(struct io_wq *wq)
-{
-	struct io_wq_flush_data data;
-	int node;
-
-	for_each_node(node) {
-		struct io_wqe *wqe = wq->wqes[node];
-
-		if (!node_online(node))
-			continue;
-		init_completion(&data.done);
-		INIT_IO_WORK(&data.work, io_wq_flush_func);
-		data.work.flags |= IO_WQ_WORK_INTERNAL;
-		io_wqe_enqueue(wqe, &data.work);
-		wait_for_completion(&data.done);
-	}
-}
-
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 {
 	int ret = -ENOMEM, node;
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 001194aef6ae..a0978d6958f0 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -7,7 +7,6 @@ enum {
 	IO_WQ_WORK_CANCEL	= 1,
 	IO_WQ_WORK_HASHED	= 4,
 	IO_WQ_WORK_UNBOUND	= 32,
-	IO_WQ_WORK_INTERNAL	= 64,
 	IO_WQ_WORK_NO_CANCEL	= 256,
 	IO_WQ_WORK_CONCURRENT	= 512,
 
@@ -98,7 +97,6 @@ void io_wq_destroy(struct io_wq *wq);
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
 void io_wq_enqueue_hashed(struct io_wq *wq, struct io_wq_work *work, void *val);
-void io_wq_flush(struct io_wq *wq);
 
 void io_wq_cancel_all(struct io_wq *wq);
 enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork);
-- 
2.24.0

