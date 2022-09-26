Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354BF5EAE5C
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 19:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiIZRma (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 13:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiIZRmM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 13:42:12 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB06DD133
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 10:09:33 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 28QADfFa020162
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 10:09:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=54Bgf2xY0Zg2e6Dq0/RfM1UcHe9yEbbljzjT/X/EXqE=;
 b=ffEf+dls6jlmcb3R2A+40lg0PP9TDCnRU7VdSHx8PQ0JZEwc+DOuJqPUfPeVssrZDpwP
 X1mThMw1FQd+WjPTLJWFE2ugT/IRgKVfbsqtnT91DUEYvJhZ3cCF5HMeczGfatcfosT7
 CoOuxokP0Sn0V67k6SF0l3pRSue5hMhQszU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3jswjumsc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 10:09:32 -0700
Received: from twshared3888.09.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 10:09:30 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id C41B76B0A929; Mon, 26 Sep 2022 10:09:27 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 0/3] io_uring: register single issuer task at creation
Date:   Mon, 26 Sep 2022 10:09:24 -0700
Message-ID: <20220926170927.3309091-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: fL0Z9wDs8OfHYr55EYnRLYSKKmcYFUHu
X-Proofpoint-ORIG-GUID: fL0Z9wDs8OfHYr55EYnRLYSKKmcYFUHu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_09,2022-09-22_02,2022-06-22_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Registering the single issuer task from the first submit adds unnecesary
complications to the API as well as the implementation. Where simply
registering it at creation should not impose any barriers to getting the
same performance wins. The only catch is users that might want to move th=
e
ring after creation but before submission. For these users allow them to
create the ring with IORING_SETUP_R_DISABLED and then enable it on the
submission task.

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

v2:
 - add the IORING_SETUP_R_DISABLED logic

Dylan Yudaken (3):
  io_uring: register single issuer task at creation
  io_uring: simplify __io_uring_add_tctx_node
  io_uring: remove io_register_submitter

 io_uring/io_uring.c |  9 ++++++++-
 io_uring/tctx.c     | 42 ++++++++++++++++++------------------------
 io_uring/tctx.h     |  6 ++++--
 3 files changed, 30 insertions(+), 27 deletions(-)


base-commit: f76349cf41451c5c42a99f18a9163377e4b364ff
--=20
2.30.2

