Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B088604A0F
	for <lists+io-uring@lfdr.de>; Wed, 19 Oct 2022 16:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiJSO5n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 10:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiJSO53 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 10:57:29 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AEA3DBCC
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 07:50:52 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JB18i2028697
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 07:50:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=E/01jsseyWIld6sxzQETVDPBaI3ukh4IqjEvEyxEQHw=;
 b=Jiw1aqf50LAFnw1XNWT8ZDh1p6/0IOYrbGeAVDCm7FxbH7h75HgzJph77GHisTABi3zg
 vtMa3J2xO/IASwTpz3lQJgbMLB4Gom2+Foi16f5ZXcqJQYLiB6WJULQjYf1VB0mbNQvR
 4HgRX9mMzVjc0Opy/G5Wkrl5dwQqeuYJszmLNFqwtF8ugFy9BCtqsPMBXJY7Cd3q7bgn
 nsf2ETMO8aFqyfZp3oF4H03pSL22OyLSgIRtXBmXKuzXCE96OI6ncsqQ1GPOksKj/rp1
 9HwnWvd6UhTOo6+zjYtHaYj2Lfsy+OLGjbrEVlHxbd2JFN9jTWj2AXoGq21Sqt+r0UJw lw== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kag05t14f-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 07:50:52 -0700
Received: from twshared26370.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 07:50:50 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 1C2127E52F4C; Wed, 19 Oct 2022 07:50:47 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH liburing 0/2] liburing: fix shortening api issues
Date:   Wed, 19 Oct 2022 07:50:40 -0700
Message-ID: <20221019145042.446477-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: BFtvsysXhKqJ44GCrlPMxLUpLoeX2IRE
X-Proofpoint-GUID: BFtvsysXhKqJ44GCrlPMxLUpLoeX2IRE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_09,2022-10-19_03,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The liburing public API has a couple of int shortening issues found by
compiling with cc=3D"clang -Wshorten-64-to-32 -Werror"

There are a few more in the main library, and a *lot* in the tests, which
would be nice to fix up at some point. The public API changes are
particularly useful for build systems that include these files and run
with these errors enabled.


Dylan Yudaken (2):
  fix int shortening bug in io_uring_recvmsg_validate
  fix len type of fgettxattr etc

 src/include/liburing.h | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)


base-commit: 13f3fe3af811d8508676dbd1ef552f2b459e1b21
--=20
2.30.2

