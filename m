Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE15357D0A2
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 18:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiGUQEQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 12:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiGUQEP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 12:04:15 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CBA87371
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 09:04:15 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFQw9e013835
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 09:04:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=IGz1+8poNxSCZAF6S/dKjyZYOpvPM9g7VqAbQvH939c=;
 b=cW5vo4yeVr0VYtKv/p7Aq3Xmilz1QNq4luiD3iJqFHlaDBlhwdgBkBVjoOgxebz6Zu3G
 DpsFg04mOgPCm90C0GSh2z0yIpXcSUOnuBsyfMmo9uVV+dPW4JQOnwRyHgDoCoapv6Xf
 w3sTZQqwA/BsvSRaoNnip2WulZMwVjd/6+A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hehn2rjk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 09:04:15 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub102.TheFacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 09:04:14 -0700
Received: from twshared39111.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 09:04:14 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 3AC0735A05D3; Thu, 21 Jul 2022 09:04:07 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 0/2] test: fix poll-mshot-update tests
Date:   Thu, 21 Jul 2022 09:04:04 -0700
Message-ID: <20220721160406.1700508-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: irckvRxihVg_t3Wkg07aDTmq1PAwv2fC
X-Proofpoint-ORIG-GUID: irckvRxihVg_t3Wkg07aDTmq1PAwv2fC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This test did not look at the IORING_CQE_F_MORE flag, and so could start =
failing.
Update it to do this in patch 1, and then patch 2 runs the test with more=
/less
overflows to test these codepaths

Dylan Yudaken (2):
  fixup poll-mshot-update
  test: have poll-mshot-update run with both big and small cqe

 test/poll-mshot-update.c | 116 ++++++++++++++++++++++++++++-----------
 1 file changed, 83 insertions(+), 33 deletions(-)


base-commit: 4e6eec8bdea906fe5341c97aef96986d605004e9
--=20
2.30.2

