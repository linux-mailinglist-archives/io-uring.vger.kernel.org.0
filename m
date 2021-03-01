Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1623232915F
	for <lists+io-uring@lfdr.de>; Mon,  1 Mar 2021 21:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239147AbhCAUYn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Mar 2021 15:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242489AbhCAUUv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Mar 2021 15:20:51 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BF5C061756
        for <io-uring@vger.kernel.org>; Mon,  1 Mar 2021 12:19:55 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id 7so17521912wrz.0
        for <io-uring@vger.kernel.org>; Mon, 01 Mar 2021 12:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1TMh1VbJdaP1J+Cm/poDwktFvisup0GJgu3Qp9PKjxk=;
        b=JIFTW6xCpCbZzDSmveKgSBXEAiDbGr077KjgfoudMucY0wrgU4zOscXxxAyMWulsaF
         Ww2R76bAfu1TtzxAvMiNNty6OLAfAXilmI90VboPkzs2hSt7Cp1xLjbtymJEK2MW0kI2
         ddodVnH00r3WLo/iGGdsU6M23BUiIWTlrjcszP52E9sZF37ccJPPQCEeMs1oGwQOXiDW
         G3LpITG++Gqidz4ssEtu3WlecjckYqB8bvudQRioyDHMAplRL6lZ78ShYWSR6ZY0WO5N
         v7VCnOW2EF/WVf7m1uKitKWPZAbJP+YzGPVQepIg2z8Nc6BZSib91Ix8dWBIlnaDsMWY
         0uuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1TMh1VbJdaP1J+Cm/poDwktFvisup0GJgu3Qp9PKjxk=;
        b=KXW5Us4+/JijHRfJVTtrmyOaw+osbcrn/qHBWVdhwom7uyBX9G+c1iN/rc8NIqYcSw
         0OpcxM/wQEers7skLRDv2l6TG/OjF4q1B8w3b7+azVVcYZokXETwiThr0O4HByf9kl61
         3XQtCDaPErUDJgN1MHdMpDOakuWtuceuwiOwd9ePWCJWz1kgVwHh6ALpcTWm4zmOix2z
         lzhz0UdWpKhmn2bSC19zvjkH/WTrRCnQDrvXnw2B+4x7I8UzhdeKicvjUq2vmFiystXm
         U+z8NZ5CM3t1N68abfdG2MpE0n9f0O4CrwsYkZfF0slsqyB+5CrKfNDM/HN3FGM8XMw0
         6aWQ==
X-Gm-Message-State: AOAM532udQ7E4wuqhzt6G2/o42EKOu3JcTYy/OgXpEL2WrePSS3n3dMX
        9MQnTXcAbKLpuQUINv8iMkvlVEg6XxYJ6w==
X-Google-Smtp-Source: ABdhPJzNi9UDPRFROXXF7nputvtrtaPcRhW85uXA24H/RnzgrcNArFRrTJmqo3Fiuh6v3xgN8tzXGA==
X-Received: by 2002:a5d:6a86:: with SMTP id s6mr4918936wru.307.1614629994111;
        Mon, 01 Mar 2021 12:19:54 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.35])
        by smtp.gmail.com with ESMTPSA id l8sm11409947wrx.83.2021.03.01.12.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 12:19:53 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] io-wq: deduplicate destroying wq->manager
Date:   Mon,  1 Mar 2021 20:15:55 +0000
Message-Id: <d419494ff45686994526804a0b27e18f88da776b.1614629733.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a helper io_wq_destroy_manager(), for killing an io-wq manager and
not repeating it three times.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 9828722fdee9..c9d886d1a73c 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1059,20 +1059,24 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	return ERR_PTR(ret);
 }
 
-static void io_wq_destroy(struct io_wq *wq)
+static void io_wq_destroy_manager(struct io_wq *wq)
 {
-	int node;
-
-	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
-
-	set_bit(IO_WQ_BIT_EXIT, &wq->state);
 	if (wq->manager) {
 		wake_up_process(wq->manager);
 		wait_for_completion(&wq->exited);
 		put_task_struct(wq->manager);
 		wq->manager = NULL;
 	}
+}
+
+static void io_wq_destroy(struct io_wq *wq)
+{
+	int node;
+
+	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
 
+	set_bit(IO_WQ_BIT_EXIT, &wq->state);
+	io_wq_destroy_manager(wq);
 	spin_lock_irq(&wq->hash->wait.lock);
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
@@ -1095,12 +1099,7 @@ void io_wq_put(struct io_wq *wq)
 void io_wq_put_and_exit(struct io_wq *wq)
 {
 	set_bit(IO_WQ_BIT_EXIT, &wq->state);
-	if (wq->manager) {
-		wake_up_process(wq->manager);
-		wait_for_completion(&wq->exited);
-		put_task_struct(wq->manager);
-		wq->manager = NULL;
-	}
+	io_wq_destroy_manager(wq);
 	io_wq_put(wq);
 }
 
@@ -1146,12 +1145,7 @@ void io_wq_unshare(struct io_wq *wq)
 {
 	refcount_inc(&wq->refs);
 	set_bit(IO_WQ_BIT_EXIT, &wq->state);
-	if (wq->manager) {
-		wake_up_process(wq->manager);
-		wait_for_completion(&wq->exited);
-		put_task_struct(wq->manager);
-		wq->manager = NULL;
-	}
+	io_wq_destroy_manager(wq);
 	clear_bit(IO_WQ_BIT_EXIT, &wq->state);
 	io_wq_put(wq);
 }
-- 
2.24.0

