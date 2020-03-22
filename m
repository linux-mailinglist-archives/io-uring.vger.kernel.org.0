Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD08E18ECA9
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2020 22:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgCVVZA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 17:25:00 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38213 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbgCVVZA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 17:25:00 -0400
Received: by mail-wm1-f66.google.com with SMTP id l20so12561376wmi.3;
        Sun, 22 Mar 2020 14:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4eC7LgpYmufFPA4go7wViPXd9HrWnapviUO9r1ibY6k=;
        b=LapJvSgTCtjQi9nX184UGsDHpUX/TX22HBxdtaIyBUM0KT5jyDoxRaL5I7XpR2K95E
         TPbT4BbXDh81HPga7+arn8UlLXszTZ6GSo1m+nPJd4c7c1+vPklZnaZPGVfkVLth8iyy
         Nzu5E9TxkNlskexMQOg+eQmZ+7kOB7NTFqx3ys+kDksN56Wfmhj7DZ0g2ZGtC6ydF0Qo
         JBLII/YkKMxsI9/aW+gMUfTJxSvboNTQ4hDtAmllybZK76ZKWrOUrOMxLz0gY+ruVOqP
         Bb/BQZ6PeUbbsniMAhs6/g7M6kwNS1nzHiJe6M9/+BtpjFYxqwqH2qOkC05T/qTsSE4E
         DCFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4eC7LgpYmufFPA4go7wViPXd9HrWnapviUO9r1ibY6k=;
        b=ndUmlNgQ0szG6ir8IeklBsvypsUZNfolPKTW2cgtF+DfWiMMX+GGB+R0FjxlpF1qql
         a114DNQLAZP3QotIY/2dsBFnT4cC0817cWBYWtBPhtd1mFrkft4Aje6xBALGnzFA0pQH
         ncBDHL79MOV5OxVV+auqzzE1i6X/2HqhLiGo82ngeuWM2rwtmn9Gf5i5Ldtanf28vAdm
         eT9akOCP5msyNw+KVgL4WpPxQzfaJTUBTMrSHiYF0b7m9UTizsdXLP+ylGaIVnyW1V1Q
         S39f6NTQByjv0WeE+o7esKAnOdPovJErfDE0yaF2NqR3SsaOitCjl1KNF6hCRji4iPZm
         ruOQ==
X-Gm-Message-State: ANhLgQ3L2y6BeCHVI6Ia/hxrJHL5XOPsfeau4dx11z3aCNvIQXPoMbuC
        z6UhOkenwa0dMBGv2q9tiC57hF5X
X-Google-Smtp-Source: ADFU+vscviZCvQDrqB2KghMBcdXdMt4E+sfq3RIWA4PlYJeqq7tjYpaLmVwJuuozljUrk/MlCulg6w==
X-Received: by 2002:a7b:c308:: with SMTP id k8mr24245774wmj.40.1584912298099;
        Sun, 22 Mar 2020 14:24:58 -0700 (PDT)
Received: from localhost.localdomain ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id w67sm17620512wmb.41.2020.03.22.14.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2020 14:24:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] io_uring: Fix ->data corruption on re-enqueue
Date:   Mon, 23 Mar 2020 00:23:29 +0300
Message-Id: <c8d9cc69995858fd8859b339f77901f93574c528.1584912194.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

work->data and work->list are shared in union. io_wq_assign_next() sets
->data if a req having a linked_timeout, but then io-wq may want to use
work->list, e.g. to do re-enqueue of a request, so corrupting ->data.

->data is not necessary, just remove it and extract linked_timeout
through @link_list.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.h    | 5 +----
 fs/io_uring.c | 9 ++++-----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 298b21f4a4d2..d2a5684bf673 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -63,10 +63,7 @@ static inline void wq_node_del(struct io_wq_work_list *list,
 } while (0)
 
 struct io_wq_work {
-	union {
-		struct io_wq_work_node list;
-		void *data;
-	};
+	struct io_wq_work_node list;
 	void (*func)(struct io_wq_work **);
 	struct files_struct *files;
 	struct mm_struct *mm;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5267e331b4a4..ce8f38aa070a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1567,9 +1567,10 @@ static void io_free_req(struct io_kiocb *req)
 
 static void io_link_work_cb(struct io_wq_work **workptr)
 {
-	struct io_wq_work *work = *workptr;
-	struct io_kiocb *link = work->data;
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *link;
 
+	link = list_first_entry(&req->link_list, struct io_kiocb, link_list);
 	io_queue_linked_timeout(link);
 	io_wq_submit_work(workptr);
 }
@@ -1584,10 +1585,8 @@ static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
 
 	*workptr = &nxt->work;
 	link = io_prep_linked_timeout(nxt);
-	if (link) {
+	if (link)
 		nxt->work.func = io_link_work_cb;
-		nxt->work.data = link;
-	}
 }
 
 /*
-- 
2.24.0

