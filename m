Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D0C5EAA1C
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 17:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbiIZPRo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 11:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235791AbiIZPQw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 11:16:52 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422F04DF2D
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:03:28 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28PNoUIG001064
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:03:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=trOb7zdgzaJYx7Ddm7fnVqCb5q4PP+7i5q9EzUcUcA8=;
 b=GF8H3Zxofde8cZ5N4edwTAaNHCivCtSRFARz3JHHQpDBKbQrzesXgO8BEbY4DOp/ulME
 SbQ9HWcPsLBnrgS/iWq6m4sDCv14QF9kNzEDsPNRpKS3zZ4fhNb9l6xAsG4aV6L//v23
 HvoCLhq5TFagRG+3+7XBCqriFfEOqplbs14= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jsw7nkhap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:03:27 -0700
Received: from twshared2996.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 07:03:23 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 749C56AEBEF3; Mon, 26 Sep 2022 07:03:17 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 0/3] io_uring: register single issuer task at creation
Date:   Mon, 26 Sep 2022 07:03:01 -0700
Message-ID: <20220926140304.1973990-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 3DhPcVF3j4-oIOmzIqHl5YCH--Qb_YsT
X-Proofpoint-ORIG-GUID: 3DhPcVF3j4-oIOmzIqHl5YCH--Qb_YsT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_08,2022-09-22_02,2022-06-22_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Registering the single issuer task from the first submit adds unnecesary
complications to the API as well as the implementation. Where simply
registering it at creation should not impose any barriers to getting the
same performance wins.

There is another problem in 6.1, with IORING_SETUP_DEFER_TASKRUN. That
would like to check the submitter_task from unlocked contexts, which woul=
d
be racy. If upfront the submitter_task is set at creation time it will
simplify the logic there and probably increase performance (though this i=
s
unmeasured).

Patch 1 registers the task at creation of the io_uring, this works
standalone in case you want to only merge this part for 6.0

Patch 2/3 cleans up the code from the old style

Dylan Yudaken (3):
  io_uring: register single issuer task at creation
  io_uring: simplify __io_uring_add_tctx_node
  io_uring: remove io_register_submitter

 io_uring/io_uring.c |  5 ++++-
 io_uring/tctx.c     | 42 ++++++++++++++++++------------------------
 io_uring/tctx.h     |  6 ++++--
 3 files changed, 26 insertions(+), 27 deletions(-)


base-commit: f76349cf41451c5c42a99f18a9163377e4b364ff
--=20
2.30.2

