Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D294D554B84
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 15:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244815AbiFVNk4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 09:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351878AbiFVNky (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 09:40:54 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC11437001
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 06:40:51 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25MDcS9b016198
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 06:40:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=lV4lzCY349TFdxkrXcpzKogMmM0TixG1Hc+Ol5ZaWko=;
 b=qCNNduYisOizIQouu4V390ZHLCv47IKsV8aGkS8aLJQD7QdhqrfIXhuwAbixBkBN0hLQ
 f2rmZeHzcqiL6OSWDD3rSkSSJMWYKifxytjMLXvSI9khAzwRiXAz1FdMdUdktx7m2Gps
 IprQfH//fG6809uPYFTg9EHGzD88qJZgC98= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gukcgdcxb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 06:40:51 -0700
Received: from twshared17349.03.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 22 Jun 2022 06:40:48 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id B70B42013A9D; Wed, 22 Jun 2022 06:40:30 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 4/8] io_uring: introduce llist helpers
Date:   Wed, 22 Jun 2022 06:40:24 -0700
Message-ID: <20220622134028.2013417-5-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220622134028.2013417-1-dylany@fb.com>
References: <20220622134028.2013417-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: fjv56bGzkwBgztuvHCQBtQwlPPygBS64
X-Proofpoint-ORIG-GUID: fjv56bGzkwBgztuvHCQBtQwlPPygBS64
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-22_04,2022-06-22_03,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce helpers to atomically switch llist.

Will later move this into common code

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/io_uring.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 985b46dfebb6..eb29e3f7da5c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1009,6 +1009,36 @@ static void handle_tw_list(struct llist_node *node=
,
 	} while (node);
 }
=20
+/**
+ * io_llist_xchg - swap all entries in a lock-less list
+ * @head:	the head of lock-less list to delete all entries
+ * @new:	new entry as the head of the list
+ *
+ * If list is empty, return NULL, otherwise, return the pointer to the f=
irst entry.
+ * The order of entries returned is from the newest to the oldest added =
one.
+ */
+static inline struct llist_node *io_llist_xchg(struct llist_head *head,
+					       struct llist_node *node)
+{
+	return xchg(&head->first, node);
+}
+
+/**
+ * io_llist_xchg - possibly swap all entries in a lock-less list
+ * @head:	the head of lock-less list to delete all entries
+ * @old:	expected old value of the first entry of the list
+ * @new:	new entry as the head of the list
+ *
+ * perform a cmpxchg on the first entry of the list.
+ */
+
+static inline struct llist_node *io_llist_cmpxchg(struct llist_head *hea=
d,
+						  struct llist_node *old,
+						  struct llist_node *new)
+{
+	return cmpxchg(&head->first, old, new);
+}
+
 void tctx_task_work(struct callback_head *cb)
 {
 	bool uring_locked =3D false;
--=20
2.30.2

