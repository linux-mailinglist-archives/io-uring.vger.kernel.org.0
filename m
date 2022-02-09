Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD654AFD76
	for <lists+io-uring@lfdr.de>; Wed,  9 Feb 2022 20:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbiBIT25 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Feb 2022 14:28:57 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbiBIT2D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Feb 2022 14:28:03 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0374E015674
        for <io-uring@vger.kernel.org>; Wed,  9 Feb 2022 11:26:07 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 219HJGQx009817
        for <io-uring@vger.kernel.org>; Wed, 9 Feb 2022 11:04:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=eDhPwAqDTFwHzsDqnFlzeturPOzQyIbwLl3QQUwuY+k=;
 b=Zr4NIqU5gTsaklTaLaRkXX44zEsLFgUI5CGww8xkLlgYIJ1S+BY+6e1I2hGk6EJGO8Bt
 gSJRyJ7Q8LX441KGw3MQnHvIdqZ2jylLW+8PbZossmpZDgmXoFSlUfDKFToRuu309mcp
 tD0yWUEHkN/sRFYRjsw3xMoUiO8J6AyWPR0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e4fxassmw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 09 Feb 2022 11:04:02 -0800
Received: from twshared18912.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Feb 2022 11:04:01 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 3147BA855530; Wed,  9 Feb 2022 11:03:52 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <viro@zeniv.linux.org.uk>, <shr@fb.com>
Subject: [PATCH v1 0/2] io-uring: Make statx api stable 
Date:   Wed, 9 Feb 2022 11:03:43 -0800
Message-ID: <20220209190345.2374478-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ZuHfZX5gae4LJnaxSg6YYRpMEaSr0DBt
X-Proofpoint-GUID: ZuHfZX5gae4LJnaxSg6YYRpMEaSr0DBt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_10,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 spamscore=0 mlxscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 clxscore=1015 impostorscore=0 mlxlogscore=780
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202090100
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


Stefan Roesch (2):
  fs: replace const char* parameter in vfs_statx and do_statx with
    struct filename
  io-uring: Copy path name during prepare stage for statx

 fs/internal.h |  4 +++-
 fs/io_uring.c | 22 ++++++++++++++++++++--
 fs/stat.c     | 49 ++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 59 insertions(+), 16 deletions(-)


base-commit: e6251ab4551f51fa4cee03523e08051898c3ce82
--=20
2.30.2

