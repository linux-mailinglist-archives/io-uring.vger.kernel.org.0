Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0706055753F
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 10:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiFWIWN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 04:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiFWIWN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 04:22:13 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870BA4831A
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 01:22:12 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25N0wToC020061
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 01:22:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=mvw+2yYoHGKScafZeBbVyD4mkAWnoRUSIuH5EVqzFXw=;
 b=N5Q8+ISGRNYkzfYn3P8v4WzDXkViRGdg4zUogyszhvU1eXiTZpTwTf0Ph4CAKn/qwuW4
 mYgISHkItXpnjqFs4UGg7L3rC0bfzP/RpLy9009klJNC8x6SJUxZmSx3R5a2p1tPQgkC
 ByUUmQar1uE2WS1dv6/viECZOX8GBXPkw8U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gukdx3c9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 01:22:11 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub102.TheFacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 23 Jun 2022 01:22:10 -0700
Received: from twshared5640.09.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 23 Jun 2022 01:22:10 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id B223C209F410; Thu, 23 Jun 2022 01:21:59 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     Dylan Yudaken <dylany@fb.com>, kernel test robot <lkp@intel.com>
Subject: [PATCH for-next] io_uring: fix documentation
Date:   Thu, 23 Jun 2022 01:21:54 -0700
Message-ID: <20220623082154.2438260-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: hWSfz88wBMJTeIS0cgWWUFo0cuQ5n6GY
X-Proofpoint-ORIG-GUID: hWSfz88wBMJTeIS0cgWWUFo0cuQ5n6GY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_03,2022-06-22_03,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The doc strings were incorrect, fix these up

Reported-by: kernel test robot <lkp@intel.com>
Fixes: c0808632a83a ("io_uring: introduce llist helpers")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---

Hi,

You may want to just fold this into the original commit.

Dylan

 io_uring/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cbbec1cecad3..894652eae449 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1023,13 +1023,13 @@ static unsigned int handle_tw_list(struct llist_n=
ode *node,
  * The order of entries returned is from the newest to the oldest added =
one.
  */
 static inline struct llist_node *io_llist_xchg(struct llist_head *head,
-					       struct llist_node *node)
+					       struct llist_node *new)
 {
-	return xchg(&head->first, node);
+	return xchg(&head->first, new);
 }
=20
 /**
- * io_llist_xchg - possibly swap all entries in a lock-less list
+ * io_llist_cmpxchg - possibly swap all entries in a lock-less list
  * @head:	the head of lock-less list to delete all entries
  * @old:	expected old value of the first entry of the list
  * @new:	new entry as the head of the list

base-commit: 5ec69c3a15ae6e904d76545d9a9c686eb758def0
--=20
2.30.2

