Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 872604B5EF7
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 01:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbiBOAVq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 19:21:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiBOAVp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 19:21:45 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFB81019FF
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 16:21:34 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21EKsQGx006811
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 16:21:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=YrJY39DxvPriFlYj4T5MmWbxRdvj714z/HGGhnUVBLg=;
 b=PcOEZORIB2zfrd2m6PJW65p+Z0xhlCGt+AoPgEm9b9KK4MBgDRTm1K6WT2lYmGJWp5+0
 G1w+GDzV4L7po3XrjsERzNb8gaDvvDYSkKd5EOiyUAvFRr33IHWtE+qVHhVW8MrfWqtl
 vpi5jMTnZth2J8gfb29YmjRlbHfMY6UogAE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e7hpceenj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 16:21:34 -0800
Received: from twshared29821.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Feb 2022 16:21:33 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 3B026AC1ADC6; Mon, 14 Feb 2022 16:21:27 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <viro@zeniv.linux.org.uk>, <shr@fb.com>
Subject: [PATCH v2 0/2] io-uring: Make statx api stable 
Date:   Mon, 14 Feb 2022 16:21:19 -0800
Message-ID: <20220215002121.2049686-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: sQFT6R8B0ctWWionh4v9V8eQeafW0f8u
X-Proofpoint-ORIG-GUID: sQFT6R8B0ctWWionh4v9V8eQeafW0f8u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0 phishscore=0
 clxscore=1015 suspectscore=0 adultscore=0 mlxlogscore=754
 lowpriorityscore=0 malwarescore=0 impostorscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202150000
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


One of the key architectual tenets of io-uring is to keep the
parameters for io-uring stable. After the call has been submitted,
its value can be changed.  Unfortunaltely this is not the case for
the current statx implementation.

Patches:
 Patch 1: fs: replace const char* parameter in vfs_statx and do_statx wit=
h
          struct filename
   Create filename object outside of do_statx and vfs_statx, so io-uring
   can create the filename object during the prepare phase

 Patch 2: io-uring: Copy path name during prepare stage for statx
   Create and store filename object during prepare phase


There is also a patch for the liburing libray to add a new test case. Thi=
s
patch makes sure that the api is stable.
  "liburing: add test for stable statx api"

The patch has been tested with the liburing test suite and fstests.


Changes:
V2: don't check name in vfs_fstatat


Stefan Roesch (2):
  fs: replace const char* parameter in vfs_statx and do_statx with
    struct filename
  io-uring: Copy path name during prepare stage for statx

 fs/internal.h |  4 +++-
 fs/io_uring.c | 22 ++++++++++++++++++++--
 fs/stat.c     | 48 +++++++++++++++++++++++++++++++++++-------------
 3 files changed, 58 insertions(+), 16 deletions(-)


base-commit: 754e0b0e35608ed5206d6a67a791563c631cec07
--=20
2.30.2

