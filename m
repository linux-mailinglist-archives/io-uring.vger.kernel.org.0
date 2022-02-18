Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98354BC0DB
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 20:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238866AbiBRT6p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 14:58:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238821AbiBRT61 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 14:58:27 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887FD1DA57
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:10 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21IILs86019472
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=PrMhbqwOga++xb/Ni5mVt/2MYejdr64cMoOG2i2n2Bc=;
 b=ELJLbBl+g8Q1wQJeP3oaqUX4Wvd1a+umnXXcH3u+FcbHmQKnvu1dlveB/+yl6nI16pdh
 MXTUftat+KVM/7PtxZzNcvhPYcVP0haB5uENjPTKy3SyXSxuR+nptecSnNdCI8upWga1
 UfTf2EV4pEHt1/CEREJZs6NNzbCjnx9wHOc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ea6knvaxw-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:09 -0800
Received: from twshared6457.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 11:58:07 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id C2103AEB6611; Fri, 18 Feb 2022 11:57:50 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 10/13] sched: add new fields to task_struct
Date:   Fri, 18 Feb 2022 11:57:36 -0800
Message-ID: <20220218195739.585044-11-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220218195739.585044-1-shr@fb.com>
References: <20220218195739.585044-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: SXKljcvvxmmcy_oY88UVQchsEK7TArjQ
X-Proofpoint-GUID: SXKljcvvxmmcy_oY88UVQchsEK7TArjQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_08,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 impostorscore=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180121
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add two new fields to the task_struct to support async
write throttling.

  - One field to store how long writes are throttled: bdp_pause
  - The other field to store the number of dirtied pages:
    bdp_nr_dirtied_pause

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 include/linux/sched.h | 3 +++
 kernel/fork.c         | 1 +
 2 files changed, 4 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75ba8aa60248..97146b7539c5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1324,6 +1324,9 @@ struct task_struct {
 	/* Start of a write-and-pause period: */
 	unsigned long			dirty_paused_when;
=20
+	unsigned long			bdp_pause;
+	int				bdp_nr_dirtied_pause;
+
 #ifdef CONFIG_LATENCYTOP
 	int				latency_record_count;
 	struct latency_record		latency_record[LT_SAVECOUNT];
diff --git a/kernel/fork.c b/kernel/fork.c
index d75a528f7b21..d34c9c00baea 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2246,6 +2246,7 @@ static __latent_entropy struct task_struct *copy_pr=
ocess(
 	p->nr_dirtied =3D 0;
 	p->nr_dirtied_pause =3D 128 >> (PAGE_SHIFT - 10);
 	p->dirty_paused_when =3D 0;
+	p->bdp_nr_dirtied_pause =3D -1;
=20
 	p->pdeath_signal =3D 0;
 	INIT_LIST_HEAD(&p->thread_group);
--=20
2.30.2

