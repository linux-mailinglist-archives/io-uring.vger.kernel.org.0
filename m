Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124434C4E12
	for <lists+io-uring@lfdr.de>; Fri, 25 Feb 2022 19:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbiBYSyJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Feb 2022 13:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233495AbiBYSyI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Feb 2022 13:54:08 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E035EBFD
        for <io-uring@vger.kernel.org>; Fri, 25 Feb 2022 10:53:35 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21PEGMde003771
        for <io-uring@vger.kernel.org>; Fri, 25 Feb 2022 10:53:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=keiZoEA/mN/EC2yQReM//REMZUleXJTb0LpsMB8T54E=;
 b=INVh/10QSe049ymKNQ6EnhonAv6KE6S7UfkF0iSfZIESUtuDTKD57y22e22LQc0UvjYu
 pV0KcNcGA4JabtTW/R9VY95Y8KC6naj5lGR/Ke1+BJli9m3LUC+15ikWfQ4NZ8bk/IWh
 eCjNEXWiuaU3Gyoc0Osb47k32QtkEEOY2jw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ef0qf9v72-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 25 Feb 2022 10:53:35 -0800
Received: from twshared9880.08.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Feb 2022 10:53:34 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 52CE1B52F88B; Fri, 25 Feb 2022 10:53:28 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <viro@zeniv.linux.org.uk>, <shr@fb.com>, <rostedt@goodmis.org>,
        <m.szyprowski@samsung.com>
Subject: [PATCH v4 0/1] io-uring: Make statx api stable 
Date:   Fri, 25 Feb 2022 10:53:25 -0800
Message-ID: <20220225185326.1373304-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: zrtBurLkRbohl3atV1A8JamyZiLC3pPL
X-Proofpoint-GUID: zrtBurLkRbohl3atV1A8JamyZiLC3pPL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_10,2022-02-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 spamscore=0 mlxlogscore=625 suspectscore=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250107
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Patch:
 Part 1: fs: replace const char* parameter in vfs_statx and do_statx with
          struct filename
   Create filename object outside of do_statx and vfs_statx, so io-uring
   can create the filename object during the prepare phase

 Part 2: io-uring: Copy path name during prepare stage for statx
   Create and store filename object during prepare phase


There is also a patch for the liburing libray to add a new test case. Thi=
s
patch makes sure that the api is stable.
  "liburing: add test for stable statx api"

The patch has been tested with the liburing test suite and fstests.


Changes:
V2: don't check name in vfs_fstatat
V3: don't check name in statx syscall
V4: - incorporate Steven Rostedt's fix
    - Merge both patches to avoid bisect problem
      (the io-uring changes have a dependency on the parameter change in
       the fs layer)


Stefan Roesch (1):
  io-uring: Make statx API stable

 fs/internal.h |  4 +++-
 fs/io_uring.c | 22 ++++++++++++++++++++--
 fs/stat.c     | 49 +++++++++++++++++++++++++++++++++++--------------
 3 files changed, 58 insertions(+), 17 deletions(-)


base-commit: 5c1ee569660d4a205dced9cb4d0306b907fb7599
--=20
2.30.2

