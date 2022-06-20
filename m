Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7175F552213
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 18:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240115AbiFTQTO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jun 2022 12:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbiFTQTN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jun 2022 12:19:13 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFB46559
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:12 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KFYSYq027274
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=nQ6xGvXvbATA46URCi6FcKXueWmJ4ZmHHir0bqpOuj0=;
 b=AuWsXrI78vvpUXVJCfIL7HOnAJo4frP1aHVurvP6/9rF2ty2IQpnr95hr4n78rDWJvXS
 GT9rdMnA4Ys3Eu6mZttKqGPyXhml+FhfBgkKlt7XDTErc/0agngd/5ydnIAep/bnhDdF
 wcJazPiwiFNGyyoNgVvvqBQ7EZA9lsZygVU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gtunfr9qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 09:19:12 -0700
Received: from twshared22934.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 09:19:11 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 780221EB9438; Mon, 20 Jun 2022 09:19:05 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH RFC for-next 0/8] io_uring: tw contention improvments
Date:   Mon, 20 Jun 2022 09:18:53 -0700
Message-ID: <20220620161901.1181971-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: dvPE2H9yhcCPMjctTRz847pJfvvV_lcc
X-Proofpoint-ORIG-GUID: dvPE2H9yhcCPMjctTRz847pJfvvV_lcc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Task work currently uses a spin lock to guard task_list and
task_running. Some use cases such as networking can trigger task_work_add
from multiple threads all at once, which suffers from contention here.

This can be changed to use a lockless list which seems to have better
performance. Running the micro benchmark in [1] I see 20% improvment in
multithreaded task work add. It required removing the priority tw list
optimisation, however it isn't clear how important that optimisation is.
Additionally it has fairly easy to break semantics.

Patch 1-2 remove the priority tw list optimisation
Patch 3-5 add lockless lists for task work
Patch 6 fixes a bug I noticed in io_uring event tracing
Patch 7-8 adds tracing for task_work_run

Dylan Yudaken (8):
  io_uring: remove priority tw list optimisation
  io_uring: remove __io_req_task_work_add
  io_uring: lockless task list
  io_uring: introduce llist helpers
  io_uring: batch task_work
  io_uring: move io_uring_get_opcode out of TP_printk
  io_uring: add trace event for running task work
  io_uring: trace task_work_run

 include/linux/io_uring_types.h  |   2 +-
 include/trace/events/io_uring.h |  72 +++++++++++++--
 io_uring/io_uring.c             | 150 ++++++++++++--------------------
 io_uring/io_uring.h             |   1 -
 io_uring/rw.c                   |   2 +-
 io_uring/tctx.c                 |   4 +-
 io_uring/tctx.h                 |   7 +-
 7 files changed, 127 insertions(+), 111 deletions(-)


base-commit: 094abe8fbccb0d79bef982c67eb7372e92452c0e
--=20
2.30.2

