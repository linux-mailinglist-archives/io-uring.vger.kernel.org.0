Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46299509020
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 21:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348639AbiDTTRy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 15:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245254AbiDTTRw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 15:17:52 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EECB5F58
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:03 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 23KILRtU008189
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=W1/RoBuGT0olDtCGqJAF4D+uCYei4IGePSU6v67zbvE=;
 b=Z2g9D0TO/Y/DeWiBJ6S5mV4e8x+W3JP5O2bTz7mGaRRTJtRqTfS91UxunvmlJYBCqvpi
 xg5WFIV9POjmryCbSadxjjgdlXI3OOn9Ewq1WgVYiCbZVsh4M1uMqprcK2hQy4KRpIk1
 J16qELR+Sv0tY50ngyF6+HPKwETR/isXVcg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3fj7k3dfgu-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:02 -0700
Received: from twshared14141.02.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Apr 2022 12:15:01 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 83AE4DE0C404; Wed, 20 Apr 2022 12:14:53 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 00/12] add large CQE support for io-uring
Date:   Wed, 20 Apr 2022 12:14:39 -0700
Message-ID: <20220420191451.2904439-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2XttdTJ8LGMGuyJp9-TagIfoKwKP79h9
X-Proofpoint-GUID: 2XttdTJ8LGMGuyJp9-TagIfoKwKP79h9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_05,2022-04-20_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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

 fs/io_uring.c                   | 224 +++++++++++++++++++++++++++-----
 include/trace/events/io_uring.h |  18 ++-
 include/uapi/linux/io_uring.h   |  12 ++
 3 files changed, 220 insertions(+), 34 deletions(-)


base-commit: fd1cf8f1947eb7b009eb79807ec8af0e920fc57b
--=20
2.30.2

