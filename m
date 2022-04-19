Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43905507B8C
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 22:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357874AbiDSVBS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 17:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355486AbiDSVBR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 17:01:17 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E7C41FA5
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:58:32 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23JGdrc2024365
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:58:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=DqjLzNF903Ry9kByF/aH2YPJ7OCTuBQ9GpYnYw2S+Ss=;
 b=RptCvrwVSNlpukMjpL5rTNF+aGokJR3uTajIcXgd+ooPuIyx3Esd4fFjsnvaLR8/xLMZ
 0WQntqsWmbCrHAPxwklA4VTwNd5pgSbgbIj8fmEcQW62/q2ZsdJL0l6QULeQZiwQ+8zt
 O7KUUszMXur4zd2uEVRDTY/50pNG4UGQJy4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fhn4vnr6p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:58:32 -0700
Received: from twshared10896.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 13:58:30 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 49BCEDD46114; Tue, 19 Apr 2022 13:58:26 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 0/6] liburing: add support for large CQE sizes
Date:   Tue, 19 Apr 2022 13:58:11 -0700
Message-ID: <20220419205817.1551377-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: qoAFisgLhmvMAF5xEFMD5zwDSx_QI66G
X-Proofpoint-ORIG-GUID: qoAFisgLhmvMAF5xEFMD5zwDSx_QI66G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-19_08,2022-04-15_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

To use these
changes, also the corresponding kernel changes are required.


Stefan Roesch (6):
  liburing: Update io_uring.h with large CQE kernel changes
  liburing: increase mmap size for large CQE's
  liburing: return correct ring size for large CQE's
  liburing: index large CQE's correctly
  liburing: add large CQE tests to nop test
  liburing: Test all configurations with NOP test

 src/include/liburing.h          | 18 +++++++-
 src/include/liburing/io_uring.h | 13 ++++++
 src/queue.c                     |  6 ++-
 src/setup.c                     | 13 ++++--
 test/nop.c                      | 74 ++++++++++++++++++++-------------
 test/test.h                     | 35 ++++++++++++++++
 6 files changed, 123 insertions(+), 36 deletions(-)
 create mode 100644 test/test.h


base-commit: c0ba24d1215e9f2b08266b28b35436988c6f3543
--=20
2.30.2

