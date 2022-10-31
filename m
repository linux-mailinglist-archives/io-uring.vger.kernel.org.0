Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A0D613837
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 14:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiJaNlq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 09:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiJaNlp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 09:41:45 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9A9101F7
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:44 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VDFR4G007556
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=avQGXtOlKbtlo+TC5tXjdl4zYZlh9/nGEAy2UqxdhPo=;
 b=kjsXX3xYdtBOEUzQFNhwF2oU4UPZO6p6EHsdTkkdcu/+CobZB16gPLMG4s8uUWWiAPTN
 dETg5tK5YMpMwOJhz6ASSq3UxOXAkI4mOzECojVDYb2ucWNQY8BCM5fNhhtTQcf42nyV
 /OEpaR/0hMn9dEfsp5TOFfSYnJvM1bsiSR1nIMVU1jk6aUvNRk8IAicb80VWPofzN5aH
 mLjg7jK/ZP+rciQv6iMp8/4HLw7LHaDshnBUbx5DXcxJNFjn6zwSMnOYxtFn2cxbAym+
 vG04FOUE2iPg186nWzTpP0WCfId8jIKrbuSgmvZlwW1ORvJcHnhu9Kak368VzLSv654S hw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kh1x1xc91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:43 -0700
Received: from twshared23862.08.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 06:41:42 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id AC65F8A1964A; Mon, 31 Oct 2022 06:41:35 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 02/12] io_uring: io-wq helper to iterate all work
Date:   Mon, 31 Oct 2022 06:41:16 -0700
Message-ID: <20221031134126.82928-3-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221031134126.82928-1-dylany@meta.com>
References: <20221031134126.82928-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: GcV0SimPA_Xfr9CWV-WVuhbmy_5uS8Is
X-Proofpoint-GUID: GcV0SimPA_Xfr9CWV-WVuhbmy_5uS8Is
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_15,2022-10-31_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a helper to iterate all work currently queued on an io-wq.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io-wq.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++
 io_uring/io-wq.h |  3 +++
 2 files changed, 52 insertions(+)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 6f1d0e5df23a..47cbe2df05c4 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -38,6 +38,11 @@ enum {
 	IO_ACCT_STALLED_BIT	=3D 0,	/* stalled on hash */
 };
=20
+struct io_for_each_work_data {
+	work_for_each_fn	*cb;
+	void			*data;
+};
+
 /*
  * One for each thread in a wqe pool
  */
@@ -856,6 +861,19 @@ static bool io_wq_for_each_worker(struct io_wqe *wqe=
,
 	return ret;
 }
=20
+static bool io_wq_for_each_work_cb(struct io_worker *w, void *data)
+{
+	struct io_for_each_work_data *f =3D data;
+
+	raw_spin_lock(&w->lock);
+	if (w->cur_work)
+		f->cb(w->cur_work, f->data);
+	if (w->next_work)
+		f->cb(w->next_work, f->data);
+	raw_spin_unlock(&w->lock);
+	return false;
+}
+
 static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 {
 	__set_notify_signal(worker->task);
@@ -1113,6 +1131,37 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq=
, work_cancel_fn *cancel,
 	return IO_WQ_CANCEL_NOTFOUND;
 }
=20
+void io_wq_for_each(struct io_wq *wq, work_for_each_fn *cb, void *data)
+{
+	int node, i;
+	struct io_for_each_work_data wq_data =3D {
+		.cb =3D cb,
+		.data =3D data
+	};
+
+	for_each_node(node) {
+		struct io_wqe *wqe =3D wq->wqes[node];
+
+		for (i =3D 0; i < IO_WQ_ACCT_NR; i++) {
+			struct io_wqe_acct *acct =3D io_get_acct(wqe, i =3D=3D 0);
+			struct io_wq_work_node *node, *prev;
+			struct io_wq_work *work;
+
+			raw_spin_lock(&acct->lock);
+			wq_list_for_each(node, prev, &acct->work_list) {
+				work =3D container_of(node, struct io_wq_work, list);
+				cb(work, data);
+			}
+			raw_spin_unlock(&acct->lock);
+		}
+
+
+		raw_spin_lock(&wqe->lock);
+		io_wq_for_each_worker(wqe, io_wq_for_each_work_cb, &wq_data);
+		raw_spin_unlock(&wqe->lock);
+	}
+}
+
 static int io_wqe_hash_wake(struct wait_queue_entry *wait, unsigned mode=
,
 			    int sync, void *key)
 {
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index 31228426d192..163cb12259b0 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -63,6 +63,9 @@ typedef bool (work_cancel_fn)(struct io_wq_work *, void=
 *);
 enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *canc=
el,
 					void *data, bool cancel_all);
=20
+typedef void (work_for_each_fn)(struct io_wq_work *, void *);
+void io_wq_for_each(struct io_wq *wq, work_for_each_fn *cb, void *data);
+
 #if defined(CONFIG_IO_WQ)
 extern void io_wq_worker_sleeping(struct task_struct *);
 extern void io_wq_worker_running(struct task_struct *);
--=20
2.30.2

