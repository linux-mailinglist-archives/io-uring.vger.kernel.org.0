Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6573B5B1121
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 02:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiIHA3s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Sep 2022 20:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiIHA3q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Sep 2022 20:29:46 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9041ADB2
        for <io-uring@vger.kernel.org>; Wed,  7 Sep 2022 17:29:34 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 287HndTa020483
        for <io-uring@vger.kernel.org>; Wed, 7 Sep 2022 17:29:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=is9Y7XjgKHvRGTljgTWJnvm7mK7pSl22GMfdkPrRC9w=;
 b=Zx6pCPf7KnmJhls6XsNxbW/U3vfIbE3UgvQi8t9L/awKTDsUNYaqJH6TfjOwW4tiXEHB
 ZS17iTNi9Gkwjh2BedQFNPl/v+O6f2JZS7sYtQmeIj7+gmxKnOYZ9Ve8n7QjKju3Xt0e
 EfFvaE+/Zt/fCM9MxxE/KMG2av44th9RLt4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3jee6bgf6e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 07 Sep 2022 17:29:21 -0700
Received: from twshared13579.04.prn5.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Sep 2022 17:29:19 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id EA1711D2F048; Wed,  7 Sep 2022 17:26:19 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>,
        <fdmanana@gmail.com>
Subject: [PATCH v2 11/12] btrfs: add assert to search functions
Date:   Wed, 7 Sep 2022 17:26:15 -0700
Message-ID: <20220908002616.3189675-12-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220908002616.3189675-1-shr@fb.com>
References: <20220908002616.3189675-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: d0Xl7k50sf_TsMRyyGq-wmJQloWnYpLn
X-Proofpoint-GUID: d0Xl7k50sf_TsMRyyGq-wmJQloWnYpLn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_10,2022-09-07_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds warnings to search functions, which should not have the nowait
flag set when called.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/btrfs/ctree.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 71b238364939..9caf0f87cbcb 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2165,6 +2165,9 @@ int btrfs_search_old_slot(struct btrfs_root *root, =
const struct btrfs_key *key,
 	lowest_level =3D p->lowest_level;
 	WARN_ON(p->nodes[0] !=3D NULL);
=20
+	if (WARN_ON_ONCE(p->nowait =3D=3D 1))
+		return -EINVAL;
+
 	if (p->search_commit_root) {
 		BUG_ON(time_seq);
 		return btrfs_search_slot(NULL, root, key, p, 0, 0);
@@ -4465,6 +4468,9 @@ int btrfs_search_forward(struct btrfs_root *root, s=
truct btrfs_key *min_key,
 	int ret =3D 1;
 	int keep_locks =3D path->keep_locks;
=20
+	if (WARN_ON_ONCE(path->nowait =3D=3D 1))
+		return -EINVAL;
+
 	path->keep_locks =3D 1;
 again:
 	cur =3D btrfs_read_lock_root_node(root);
@@ -4645,6 +4651,9 @@ int btrfs_next_old_leaf(struct btrfs_root *root, st=
ruct btrfs_path *path,
 	int ret;
 	int i;
=20
+	if (WARN_ON_ONCE(path->nowait =3D=3D 1))
+		return -EINVAL;
+
 	nritems =3D btrfs_header_nritems(path->nodes[0]);
 	if (nritems =3D=3D 0)
 		return 1;
--=20
2.30.2

