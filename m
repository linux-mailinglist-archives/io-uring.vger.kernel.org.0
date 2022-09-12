Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7515B61A9
	for <lists+io-uring@lfdr.de>; Mon, 12 Sep 2022 21:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiILT2H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Sep 2022 15:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiILT2F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Sep 2022 15:28:05 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641DF459A2
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:03 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CHVFj3010392
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=tArxVrq0k2OSiB82LYYz96Za/5QZHxy2tKRMamgWKpw=;
 b=EyBgo4f6ZmsFOzw008tyGPunFAaCqWFa4NkT6J8ChAg8ixDHLbFSEV1bHJYT1nlJ1Iig
 9djDC8xl9kLqJljYh66K3oQt1jorIgG5Oo+YZMW2+bxo7EtlIIEHBtuBF/f6kSCsHYgk
 HwJ0ChcLoqsPubVMjzi9/iIrLHcT+Bx4Cq0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jgr9smh6y-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:02 -0700
Received: from twshared20183.05.prn5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 12:28:01 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id E68CB2085228; Mon, 12 Sep 2022 12:27:53 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, <linux-mm@kvack.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>,
        <fdmanana@gmail.com>, kernel test robot <lkp@intel.com>
Subject: [PATCH v3 01/12] mm: export balance_dirty_pages_ratelimited_flags()
Date:   Mon, 12 Sep 2022 12:27:41 -0700
Message-ID: <20220912192752.3785061-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220912192752.3785061-1-shr@fb.com>
References: <20220912192752.3785061-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: DJPbmIiz2kRlGuMAis8Uu2MXE8o1LQyf
X-Proofpoint-GUID: DJPbmIiz2kRlGuMAis8Uu2MXE8o1LQyf
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

Export the function balance_dirty_pages_ratelimited_flags(). It is now
also called from btrfs.

Signed-off-by: Stefan Roesch <shr@fb.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 mm/page-writeback.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 032a7bf8d259..7e9d8d857ecc 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1933,6 +1933,7 @@ int balance_dirty_pages_ratelimited_flags(struct ad=
dress_space *mapping,
 	wb_put(wb);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(balance_dirty_pages_ratelimited_flags);
=20
 /**
  * balance_dirty_pages_ratelimited - balance dirty memory state.
--=20
2.30.2

