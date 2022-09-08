Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A585B10F1
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 02:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiIHA0g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Sep 2022 20:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiIHA0d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Sep 2022 20:26:33 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F221213F7B
        for <io-uring@vger.kernel.org>; Wed,  7 Sep 2022 17:26:32 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 287Hne4U006018
        for <io-uring@vger.kernel.org>; Wed, 7 Sep 2022 17:26:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=tArxVrq0k2OSiB82LYYz96Za/5QZHxy2tKRMamgWKpw=;
 b=Wnd/p3mUnrYMYFaAki9Ozb13y5ONMeiXVVyBij8HcHPkFkbgFcaMWgGCnVC4VhjJ9XCn
 /VmL6m13FGUK++dPBd/WN4VG7/MbDa0Gwjv9t4N4tEaY0D6Tbz72qFMoMzUNtWXMDWay
 qiil6TR9naKgvTf+9mSE3TWa9vKQ/R0QOJE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jeamhj35r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 07 Sep 2022 17:26:32 -0700
Received: from twshared13315.14.prn3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Sep 2022 17:26:30 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id B0A8C1D2F034; Wed,  7 Sep 2022 17:26:19 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>,
        <fdmanana@gmail.com>, kernel test robot <lkp@intel.com>
Subject: [PATCH v2 01/12] mm: export balance_dirty_pages_ratelimited_flags()
Date:   Wed, 7 Sep 2022 17:26:05 -0700
Message-ID: <20220908002616.3189675-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220908002616.3189675-1-shr@fb.com>
References: <20220908002616.3189675-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: FeC0zXP4pzDCTdN9ZPjjJGfOT21HjeRE
X-Proofpoint-GUID: FeC0zXP4pzDCTdN9ZPjjJGfOT21HjeRE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_10,2022-09-07_02,2022-06-22_01
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

