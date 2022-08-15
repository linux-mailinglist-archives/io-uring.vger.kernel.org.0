Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E235592F6C
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 15:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiHONJ1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 09:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbiHONJZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 09:09:25 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B431E1BEB4
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:09:19 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27FBOT4m007726
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:09:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=fGnv4Ul5b7g3ZN0ccRxUD7DGjSIHpe8eu506Qmeadi8=;
 b=Z12mR0XEN8CnR6b1OXQxpJFJTRwD6Erynewc63SAtvKp1fOGG+3F9kKGWvsMz73/0ViP
 HQPi5UvRm2ERwEig8hAN+wTowi45xr34B94uPSsj+Pk6MqcxKN4xxnU8Wc46EfPXzlR8
 XOylv8IZMDA5w+6P46qrkDBd08GfsoioUMw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hyn83rexe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:09:18 -0700
Received: from twshared25684.07.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 15 Aug 2022 06:09:17 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 0C28A49B6CA1; Mon, 15 Aug 2022 06:09:13 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next 0/7] io_uring: defer task work to when it is needed
Date:   Mon, 15 Aug 2022 06:09:04 -0700
Message-ID: <20220815130911.988014-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: N2xHIYGZGXcX-MBXIP86969Hl8aTs38b
X-Proofpoint-GUID: N2xHIYGZGXcX-MBXIP86969Hl8aTs38b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have seen workloads which suffer due to the way task work is currently
scheduled. This scheduling can cause non-trivial tasks to run interruptin=
g
useful work on the workload. For example in network servers, a large asyn=
c
recv may run, calling memcpy on a large packet, interrupting a send. Whic=
h
would add latency.

This series adds an option to defer async work until user space calls
io_uring_enter with the GETEVENTS flag. This allows the workload to choos=
e
when to schedule async work and have finer control (at the expense of
complexity of managing this) of scheduling.

Patches 1/2/3 are prep patches
Patch 4 changes io_uring_enter to not always pre-run task work. It is not
obvious that this is useful regardless of this series
Patch 5/6/7 adds the new flag and functionality

Dylan Yudaken (7):
  io_uring: use local ctx variable
  io_uring: remove unnecessary variable
  io_uring: introduce io_has_work
  io_uring: do not always run task work at the start of io_uring_enter
  io_uring: add IORING_SETUP_DEFER_TASKRUN
  io_uring: move io_eventfd_put
  io_uring: signal registered eventfd to process deferred task work

 include/linux/io_uring_types.h |   3 +
 include/uapi/linux/io_uring.h  |   7 +
 io_uring/cancel.c              |   2 +-
 io_uring/io_uring.c            | 232 +++++++++++++++++++++++++--------
 io_uring/io_uring.h            |  31 ++++-
 io_uring/rsrc.c                |   2 +-
 6 files changed, 221 insertions(+), 56 deletions(-)


base-commit: ff34d8d06a1f16b6a58fb41bfbaa475cc6c02497
--=20
2.30.2

