Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D755105AB
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 19:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349994AbiDZRrH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 13:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345863AbiDZRrC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 13:47:02 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001D21816A7
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:43:53 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 23QGQPgd029690
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:43:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=IyOMWlLMB9dnYwVT+rkwaA9mGTqBnrjUHzxD6nps8do=;
 b=UaCfUNHVD/o7GzdhkeMDJv/9zfS4UtzY3HJOS5U3+2qcWNHp9mNdJ5kJYfk3JuseZcvF
 rI56HpkjltgcmZ7HyiulsToH6gIl+WfueLeSvDXCWztJNz9NEg/4VVEzCyaSt3yO5RGP
 iCJHDcyHQXe6JtXAM3lPD9hTShSjL6HKqLk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3fpec4k2sh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:43:53 -0700
Received: from twshared4937.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 10:43:45 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 7A64BE2D4857; Tue, 26 Apr 2022 10:43:40 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>
Subject: [RFC PATCH v1 02/18] mm: add FGP_ATOMIC flag to __filemap_get_folio()
Date:   Tue, 26 Apr 2022 10:43:19 -0700
Message-ID: <20220426174335.4004987-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426174335.4004987-1-shr@fb.com>
References: <20220426174335.4004987-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: vgnIAV_iS9BIF6LrgNQLwQHiY0X-7m-V
X-Proofpoint-ORIG-GUID: vgnIAV_iS9BIF6LrgNQLwQHiY0X-7m-V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Define FGP_ATOMIC flag and add support for the new flag in the function
__filemap_get_folio().

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 include/linux/pagemap.h | 1 +
 mm/filemap.c            | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 993994cd943a..b8d839e10780 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -509,6 +509,7 @@ pgoff_t page_cache_prev_miss(struct address_space *ma=
pping,
 #define FGP_HEAD		0x00000080
 #define FGP_ENTRY		0x00000100
 #define FGP_STABLE		0x00000200
+#define FGP_ATOMIC		0x00000400
=20
 struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t=
 index,
 		int fgp_flags, gfp_t gfp);
diff --git a/mm/filemap.c b/mm/filemap.c
index 9a1eef6c5d35..dd3c5682276e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1929,6 +1929,7 @@ static void *mapping_get_entry(struct address_space=
 *mapping, pgoff_t index)
  * * %FGP_NOFS - __GFP_FS will get cleared in gfp.
  * * %FGP_NOWAIT - Don't get blocked by page lock.
  * * %FGP_STABLE - Wait for the folio to be stable (finished writeback)
+ * * %FGP_ATOMIC - Use atomic allocations
  *
  * If %FGP_LOCK or %FGP_CREAT are specified then the function may sleep =
even
  * if the %GFP flags specified for %FGP_CREAT are atomic.
@@ -1988,6 +1989,8 @@ struct folio *__filemap_get_folio(struct address_sp=
ace *mapping, pgoff_t index,
 			gfp |=3D __GFP_WRITE;
 		if (fgp_flags & FGP_NOFS)
 			gfp &=3D ~__GFP_FS;
+		if (fgp_flags & FGP_ATOMIC)
+			gfp |=3D GFP_ATOMIC;
=20
 		folio =3D filemap_alloc_folio(gfp, 0);
 		if (!folio)
--=20
2.30.2

