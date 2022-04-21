Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF86D509BF4
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 11:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387427AbiDUJRH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 05:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376621AbiDUJRB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 05:17:01 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D9C24F24
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:14:12 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23L8AdK0000913
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:14:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=gbTkmP4OC3+yQ08kGFbROr+SigHxueVMyVvJ18BOaGc=;
 b=AqFjd4BcS7L37OpSYyEDJpQrEoQO61lMqAPq3hXub5ihjhDx/GWOWoEgWl44crzz7LIe
 Sr3U8UJ/UygSBtU7AVoBnCJoXw7Y1/HKdGrlbP/QOXZ30vqoVQjZ+N3tBruNdaj7iBzb
 2/ov/q4FvP3SGdBjg5Kyn5VzgpTe7CxsosM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fj36tb6ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:14:12 -0700
Received: from twshared8053.07.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 02:14:11 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id DD73F7CA75F8; Thu, 21 Apr 2022 02:14:01 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 0/6] return an error when cqe is dropped
Date:   Thu, 21 Apr 2022 02:13:39 -0700
Message-ID: <20220421091345.2115755-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: lTW67kSbunWPcWlvej0CVWBZZ856L57w
X-Proofpoint-ORIG-GUID: lTW67kSbunWPcWlvej0CVWBZZ856L57w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series addresses a rare but real error condition when a CQE is
dropped. Many applications rely on 1 SQE resulting in 1 CQE and may even
block waiting for the CQE. In overflow conditions if the GFP_ATOMIC
allocation fails, the CQE is dropped and a counter is incremented. Howeve=
r
the application is not actively signalled that something bad has
happened. We would like to indicate this error condition to the
application but in a way that does not rely on the application doing
invasive changes such as checking a flag before each wait.

This series returns an error code to the application when the error hits,
and then resets the error condition. If the application is ok with this
error it can continue as is, or more likely it can clean up sanely.

Patches 1&2 add tracing for overflows
Patches 3&4 prep for adding this error
Patch 5 is the main one returning an error
Patch 6 allows liburing to test these conditions more easily with IOPOLL

Dylan Yudaken (6):
  io_uring: add trace support for CQE overflow
  io_uring: trace cqe overflows
  io_uring: rework io_uring_enter to simplify return value
  io_uring: use constants for cq_overflow bitfield
  io_uring: return an error when cqe is dropped
  io_uring: allow NOP opcode in IOPOLL mode

 fs/io_uring.c                   | 89 ++++++++++++++++++++++-----------
 include/trace/events/io_uring.h | 42 +++++++++++++++-
 2 files changed, 102 insertions(+), 29 deletions(-)


base-commit: 7c648b7d6186c59ed3a0e0ae4b774aaf4b415ef2
--=20
2.30.2

