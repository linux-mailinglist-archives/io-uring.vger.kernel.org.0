Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0275B61BD
	for <lists+io-uring@lfdr.de>; Mon, 12 Sep 2022 21:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiILT2k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Sep 2022 15:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiILT2d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Sep 2022 15:28:33 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADBF46238
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:30 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CIm5mw004537
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=HgZUbO7apXTpfUq7KyjEgw2oorrYQGuiLIcFfxgsjkY=;
 b=GKze7BczTFInz/J2jfOcLFZWzLd3s4IqvoJKZyh/JIdTv7eZRq5HRoNXrLZGGHz0nPoV
 G+9Rafv4dTQ/veBNSflYJk7ySdlFadYEdN2dM32RaCZIsHxEuvePUVRgXNMEEgSkrGzG
 c5cSxRkzfVMVs4w5CgNX4rCjNFCy2su2Pxk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jgr9smhb4-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:30 -0700
Received: from twshared20183.05.prn5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 12:28:27 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id 2BB8B208523C; Mon, 12 Sep 2022 12:27:54 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, <linux-mm@kvack.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>,
        <fdmanana@gmail.com>
Subject: [PATCH v3 11/12] btrfs: assert nowait mode is not used for some btree search functions
Date:   Mon, 12 Sep 2022 12:27:51 -0700
Message-ID: <20220912192752.3785061-12-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220912192752.3785061-1-shr@fb.com>
References: <20220912192752.3785061-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: cY1h97Wr3fKh7Mwg8wfL6N3yfeKe0Hva
X-Proofpoint-GUID: cY1h97Wr3fKh7Mwg8wfL6N3yfeKe0Hva
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_13,2022-09-12_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds nowait asserts to btree search functions which are not used
by buffered IO and direct IO paths.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/btrfs/ctree.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 71b238364939..d973d6702cd0 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2164,6 +2164,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, =
const struct btrfs_key *key,
=20
 	lowest_level =3D p->lowest_level;
 	WARN_ON(p->nodes[0] !=3D NULL);
+	ASSERT(!p->nowait);
=20
 	if (p->search_commit_root) {
 		BUG_ON(time_seq);
@@ -4465,6 +4466,7 @@ int btrfs_search_forward(struct btrfs_root *root, s=
truct btrfs_key *min_key,
 	int ret =3D 1;
 	int keep_locks =3D path->keep_locks;
=20
+	ASSERT(!path->nowait);
 	path->keep_locks =3D 1;
 again:
 	cur =3D btrfs_read_lock_root_node(root);
@@ -4645,6 +4647,8 @@ int btrfs_next_old_leaf(struct btrfs_root *root, st=
ruct btrfs_path *path,
 	int ret;
 	int i;
=20
+	ASSERT(!path->nowait);
+
 	nritems =3D btrfs_header_nritems(path->nodes[0]);
 	if (nritems =3D=3D 0)
 		return 1;
--=20
2.30.2

