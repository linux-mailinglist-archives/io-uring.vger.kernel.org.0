Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD81F62BEB9
	for <lists+io-uring@lfdr.de>; Wed, 16 Nov 2022 13:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbiKPMyh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Nov 2022 07:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiKPMyg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Nov 2022 07:54:36 -0500
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76601C910
        for <io-uring@vger.kernel.org>; Wed, 16 Nov 2022 04:54:33 -0800 (PST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20221116125432euoutp0296ea4094955793c9976e8cce5e90c975~oEdXzV2-U0154301543euoutp02a
        for <io-uring@vger.kernel.org>; Wed, 16 Nov 2022 12:54:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20221116125432euoutp0296ea4094955793c9976e8cce5e90c975~oEdXzV2-U0154301543euoutp02a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668603272;
        bh=TxWotFK+57ao1MHMBti9drMLgYODQtIDnlGm53G/KvU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=HO7JwsDIZOECdEDq+XmKnKtZarLoPIiCMyanLHoEqmK+MMVmldhT/ztHwleCCO5hd
         FMEMnWHxlFhf0h5LaedeSQlqTyvhQNBWnBy0/fiqGGUr+oMIHVtq6/0vj/nql7pEKu
         KpBelMe4GvyernwiN0EkEwuZc3R078XHdGxGbkWc=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221116125432eucas1p15df7be8da9b1e0620ba8b8dc934f9126~oEdXfZxgC1056610566eucas1p15;
        Wed, 16 Nov 2022 12:54:32 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 7F.38.09549.88DD4736; Wed, 16
        Nov 2022 12:54:32 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20221116125431eucas1p1dfd03b80863fce674a7c662660c94092~oEdXDpXLd0841108411eucas1p1a;
        Wed, 16 Nov 2022 12:54:31 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221116125431eusmtrp1e0f9080be51edf6a26036c53b2333bdb~oEdXCvH0b2218422184eusmtrp13;
        Wed, 16 Nov 2022 12:54:31 +0000 (GMT)
X-AuditID: cbfec7f5-f5dff7000000254d-26-6374dd88ecba
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 40.F6.09026.78DD4736; Wed, 16
        Nov 2022 12:54:31 +0000 (GMT)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221116125431eusmtip2f45d30679e1987235715298ba27fc392~oEdW0qdt71240812408eusmtip2f;
        Wed, 16 Nov 2022 12:54:31 +0000 (GMT)
Received: from localhost (106.110.32.33) by CAMSVWEXC01.scsc.local
        (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Wed, 16 Nov 2022 12:54:30 +0000
From:   Joel Granados <j.granados@samsung.com>
To:     <joshi.k@samsung.com>, <ddiss@suse.de>, <mcgrof@kernel.org>,
        <paul@paul-moore.com>
CC:     <linux-security-module@vger.kernel.org>,
        <io-uring@vger.kernel.org>,
        "Joel Granados" <j.granados@samsung.com>
Subject: [RFC 1/1] Use ioctl selinux callback io_uring commands that
 implement the ioctl op convention
Date:   Wed, 16 Nov 2022 13:50:51 +0100
Message-ID: <20221116125051.3338926-2-j.granados@samsung.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221116125051.3338926-1-j.granados@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [106.110.32.33]
X-ClientProxiedBy: CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) To
        CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsWy7djPc7odd0uSDWZs5rD4+n86i8W71nMs
        Fh96HrFZ3JjwlNHi9qTpLA6sHptWdbJ5rN37gtFj8+lqj8+b5AJYorhsUlJzMstSi/TtErgy
        evf5FNzmqth/W62B8QdHFyMHh4SAicSLhoouRi4OIYEVjBLz/65gg3C+MEosXTMByvkM5Fx/
        ztrFyAnWseXDTxaIxHJGicN/fjHBVS3e/4kVwtnMKDF54l4mkBY2AR2J82/uMIPYIgIREvOn
        /2cEsZkFiiW27Z/HDmILC2RIrP80H2wFi4CqxKTvR5hADuQVsJXonZwKsVleou36dLBWTgE7
        ifkvD7KA2LwCghInZz5hgRgpL9G8dTYzhC0hcfDFC2aIXkWJLXO+Q31QK/HgTQ8zyJ0SAhc4
        JF78/sAGkXCROHV3I1SDsMSr41vYIWwZidOTe1gg7GyJnVN2QdUUSMw6OZUNEpDWEn1nciDC
        jhLt8zczQoT5JG68FYQ4h09i0rbpzBBhXomONqEJjCqzkDwwC8kDs5A8sICReRWjeGppcW56
        arFxXmq5XnFibnFpXrpecn7uJkZgGjn97/jXHYwrXn3UO8TIxMF4iFGCg1lJhDd/ckmyEG9K
        YmVValF+fFFpTmrxIUZpDhYlcV62GVrJQgLpiSWp2ampBalFMFkmDk6pBiafn6dczm7r0Zp0
        asluhk+/l//Ki/P7P2GF3PLFeacZq9gT839eWVweMeP9Hu0dbxS3akxZsq0j5eYJ5j03LYzE
        /oZLLBWOVrKXkP+x+sTirsW+KafLQjLkqjd+eff82Sx5hjWJmZtZq+SmNB1mco2u23wgr+/c
        GpGbtwt2fbBnS118n7Pu0f3Dcv0OJzeEGt/22/1ukZJZzQ69IwwiBilxS6eoL8z6GfaMf3Zp
        gpTJheio/s6riusWXFE4zNG95Pxal0XLH2s8DZaK09kZa+LQPnU/03PTOe8Nb/BUCe968++k
        3ZqY7jDdxpTVFTs6wxLnmW1aXv1o5RN/xrO6rZ4WVRZOenmvD5rfCfK6/WmfEktxRqKhFnNR
        cSIA/Fg2tpIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t/xe7rtd0uSDf5cV7H4+n86i8W71nMs
        Fh96HrFZ3JjwlNHi9qTpLA6sHptWdbJ5rN37gtFj8+lqj8+b5AJYovRsivJLS1IVMvKLS2yV
        og0tjPQMLS30jEws9QyNzWOtjEyV9O1sUlJzMstSi/TtEvQyevf5FNzmqth/W62B8QdHFyMn
        h4SAicSWDz9Zuhi5OIQEljJKdExfwQSRkJH4dOUjO4QtLPHnWhcbRNFHRonLB55BdWxmlHjZ
        fY8RpIpNQEfi/Js7zCC2iECExPzp/8HizALFEmsndAN1c3AIC6RJrN/oABJmEVCVmPT9CBNI
        mFfAVqJ3cirELnmJtuvTwTo5Bewk5r88yAJSIgRUMumwD0iYV0BQ4uTMJywQw+UlmrfOZoaw
        JSQOvnjBDDFGUWLLnO+sEHatxKbX65kmMIrMQtI+C0n7LCTtCxiZVzGKpJYW56bnFhvpFSfm
        Fpfmpesl5+duYgRG2bZjP7fsYFz56qPeIUYmDsZDjBIczEoivPmTS5KFeFMSK6tSi/Lji0pz
        UosPMZoCfTmRWUo0OR8Y53kl8YZmBqaGJmaWBqaWZsZK4ryeBR2JQgLpiSWp2ampBalFMH1M
        HJxSDUyuV85tYOpYKb/175FppopOxSJaN39WLg+8bSQ7manp3atlHbaGQnNPqD7et4hxV/++
        mfr3O7eveD07cA63YshNj0O7QttYmg6FM/4zdOdL2a+hrlCYHcq387JofY3GWlMRszk/JC6u
        ervpYnD0pEXRDV7ONUVTv8lu/iibPONuy5dHtxfaPLLMNjk//fSRma3mhrl/+2SZs0MUolOK
        5qSz5AirXfE8Vpp5T8LIU/dBqeVc3Yb04AkfXE7Yb6qR5J/2RdxXo9c288f+vkaJbf0pD2XY
        8t3ktpr0nXrF+iDoQPD+oz3Lcz6f5opeVKP1475Az4RZbakyDy0yjzJdc2jbMa+OsSn9bhhr
        /Lo3K5VYijMSDbWYi4oTAcr59Xs7AwAA
X-CMS-MailID: 20221116125431eucas1p1dfd03b80863fce674a7c662660c94092
X-Msg-Generator: CA
X-RootMTR: 20221116125431eucas1p1dfd03b80863fce674a7c662660c94092
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221116125431eucas1p1dfd03b80863fce674a7c662660c94092
References: <20221116125051.3338926-1-j.granados@samsung.com>
        <CGME20221116125431eucas1p1dfd03b80863fce674a7c662660c94092@eucas1p1.samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Joel Granados <j.granados@samsung.com>
---
 security/selinux/hooks.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f553c370397e..a3f37ae5a980 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -21,6 +21,7 @@
  *  Copyright (C) 2016 Mellanox Technologies
  */
 
+#include "linux/nvme_ioctl.h"
 #include <linux/init.h>
 #include <linux/kd.h>
 #include <linux/kernel.h>
@@ -7005,12 +7006,22 @@ static int selinux_uring_cmd(struct io_uring_cmd *ioucmd)
 	struct inode *inode = file_inode(file);
 	struct inode_security_struct *isec = selinux_inode(inode);
 	struct common_audit_data ad;
+	const struct cred *cred = current_cred();
 
 	ad.type = LSM_AUDIT_DATA_FILE;
 	ad.u.file = file;
 
-	return avc_has_perm(&selinux_state, current_sid(), isec->sid,
-			    SECCLASS_IO_URING, IO_URING__CMD, &ad);
+	switch (ioucmd->cmd_op) {
+	case NVME_URING_CMD_IO:
+	case NVME_URING_CMD_IO_VEC:
+	case NVME_URING_CMD_ADMIN:
+	case NVME_URING_CMD_ADMIN_VEC:
+		return ioctl_has_perm(cred, file, FILE__IOCTL, (u16) ioucmd->cmd_op);
+	default:
+		return avc_has_perm(&selinux_state, current_sid(), isec->sid,
+				    SECCLASS_IO_URING, IO_URING__CMD, &ad);
+	}
+
 }
 #endif /* CONFIG_IO_URING */
 
-- 
2.30.2

