Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3997C50E827
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 20:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244376AbiDYS25 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 14:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244379AbiDYS24 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 14:28:56 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD09B1C92D
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:25:51 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PHP3v3019241
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:25:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=X1ZxMF5hfhykYhyHeWc0h7VbH/rjujMJazMMlxmiG4Q=;
 b=FsVAb7VGy975Loj7JBQHiH6K9tPVJe5jjnzt0fHQnUbpSICq/JcKadj8IKn5+4WvI3XV
 45Qtuc0F2dFuGm7P+GEY/vwrtddQzrHBKSgD2rNnHFVx0glJV1IvjaNbN7DbvyTr/p9q
 Sx83LD4uUu17eDx75RcG2PpZcBmLYcDK/cc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmf6v3wfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:25:50 -0700
Received: from twshared19572.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 11:25:49 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 194EDE1F2A53; Mon, 25 Apr 2022 11:25:41 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>
Subject: [PATCH v3 00/12] add large CQE support for io-uring
Date:   Mon, 25 Apr 2022 11:25:18 -0700
Message-ID: <20220425182530.2442911-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: qbtg_s8rmDjKc0m9wgEAImZeb89Uacsi
X-Proofpoint-ORIG-GUID: qbtg_s8rmDjKc0m9wgEAImZeb89Uacsi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_10,2022-04-25_03,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the large CQE support for io-uring. Large CQE's are 16 bytes lo=
nger.
To support the longer CQE's the allocation part is changed and when the C=
QE is
accessed.

The allocation of the large CQE's is twice as big, so the allocation size=
 is
doubled. The ring size calculation needs to take this into account.

All accesses to the large CQE's need to be shifted by 1 to take the bigge=
r size
of each CQE into account. The existing index manipulation does not need t=
o be
changed and can stay the same.

The setup and the completion processing needs to take the new fields into
account and initialize them. For the completion processing these fields n=
eed
to be passed through.

The flush completion processing needs to fill the additional CQE32 fields=
.

The code for overflows needs to be adapted accordingly: the allocation ne=
eds to
take large CQE's into account. This means that the order of the fields in=
 the io
overflow structure needs to be changed and the allocation needs to be enl=
arged
for big CQE's.
In addition the two new fields need to be copied for large CQE's.

The new fields are added to the tracing statements, so the extra1 and ext=
ra2
fields are exposed in tracing. The new fields are also exposed in the /pr=
oc
filesystem entry.

For testing purposes the extra1 and extra2 fields are used by the nop ope=
ration.


Testing:

The exisiting tests have been run with the following configurations and t=
hey all
pass:

- Default config
- Large SQE
- Large CQE
- Large SQE and large CQE.

In addition a new test has been added to liburing to verify that extra1 a=
nd extra2
are set as expected for the nop operation.

Note:
To use this patch also the corresponding changes to the client library
liburing are required. A different patch series is sent out for this.


Changes:
  V2: - added support for CQE32 in the /proc filesystem entry output func=
tion
      - the definition of the io_uring_cqe_extra field has been changed
        to avoid warning with the /proc changes.
  V3: - use __64 for big cqe in io_uring_cqe data structure
      - use io_req_complete_state helper in __io_req_complete32
      - support cached cqe's
      - use bool for cqe32 check in io_cqring_event_overflow
      - use bool for cqe32 check in __io_uring_show_fdinfo


Stefan Roesch (12):
  io_uring: support CQE32 in io_uring_cqe
  io_uring: wire up inline completion path for CQE32
  io_uring: change ring size calculation for CQE32
  io_uring: add CQE32 setup processing
  io_uring: add CQE32 completion processing
  io_uring: modify io_get_cqe for CQE32
  io_uring: flush completions for CQE32
  io_uring: overflow processing for CQE32
  io_uring: add tracing for additional CQE32 fields
  io_uring: support CQE32 in /proc info
  io_uring: enable CQE32
  io_uring: support CQE32 for nop operation

 fs/io_uring.c                   | 234 ++++++++++++++++++++++++++++----
 include/trace/events/io_uring.h |  18 ++-
 include/uapi/linux/io_uring.h   |   7 +
 3 files changed, 225 insertions(+), 34 deletions(-)


base-commit: fd1cf8f1947eb7b009eb79807ec8af0e920fc57b
--=20
2.30.2

