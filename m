Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2C150E838
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 20:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244401AbiDYS3x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 14:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244399AbiDYS3w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 14:29:52 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03558255BA
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:26:47 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PHP50F006636
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:26:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=xKnumDaplyREtCqa6XOJoytQTTxQkKxXzpcMvsp20hc=;
 b=rQsaNvBacOo0FGjzhNu5tWdATNQ+ZRiU6S5gw6NBzueWThhj2mhgH6umRKB4Bha1gve8
 Tt2TL2+WoF1W/GiGo+vBBmQAGG5SCbaNL/ItgDH1RAB45lrXWKRxT5aRmb5UB8EMSJSO
 zxwqZCU3fEx3A1wPyIne/EFg09yqfl8fxKY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmdgfvder-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:26:47 -0700
Received: from twshared4937.07.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 11:26:46 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 9CB6DE1F2B2B; Mon, 25 Apr 2022 11:26:43 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>
Subject: [PATCH v3 0/6] liburing: add support for large CQE sizes
Date:   Mon, 25 Apr 2022 11:26:33 -0700
Message-ID: <20220425182639.2446370-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: mV-ITYn7p7Ou1nqsbCYQFToy1HNf1U8M
X-Proofpoint-GUID: mV-ITYn7p7Ou1nqsbCYQFToy1HNf1U8M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_10,2022-04-25_03,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support for large CQE sizes in the liburing layer. The large CQ=
E
sizes double the size compared to the default CQE size.

To support larger CQE sizes the mmap call needs to be modified to map a l=
arger
memory region for large CQE's. For default CQE's the size of the mapping =
stays
the same.
Also the ring size calculation needs to change.

Finally when large CQE's are indexed, they need to take into account the =
bigger
CQE size. The index manipulation remains unchanged, only when the CQE arr=
ay is
accessed, the offset is changed for large CQE's.

The nop test has been modified to test that the new values are set correc=
tly.

Testing:
The liburing test suite has been run with the four different configuratio=
ns:
- default
- large SQE
- large CQE
- large SQE & large CQE
To do this the default setting has been changed for the test run to the a=
bove
values.:

To use these changes, also the corresponding kernel changes are required.


Changes:
  V2: the changed kernel definition of io_uring_cqe_extra has been applie=
d to
      the first patch in this patch series.
  V3: - change definition of extra io_uring_cqe fields like in linux kern=
el
      - remove io_uring_cqe_extra definition


Stefan Roesch (6):
  liburing: Update io_uring.h with large CQE kernel changes
  liburing: increase mmap size for large CQE's
  liburing: return correct ring size for large CQE's
  liburing: index large CQE's correctly
  liburing: add large CQE tests to nop test
  liburing: Test all configurations with NOP test

 src/include/liburing.h          | 18 +++++++-
 src/include/liburing/io_uring.h |  7 ++++
 src/queue.c                     |  6 ++-
 src/setup.c                     | 13 ++++--
 test/nop.c                      | 74 ++++++++++++++++++++-------------
 test/test.h                     | 35 ++++++++++++++++
 6 files changed, 117 insertions(+), 36 deletions(-)
 create mode 100644 test/test.h


base-commit: c0ba24d1215e9f2b08266b28b35436988c6f3543
--=20
2.30.2

