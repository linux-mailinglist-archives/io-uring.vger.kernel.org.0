Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F9A638793
	for <lists+io-uring@lfdr.de>; Fri, 25 Nov 2022 11:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiKYKeb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Nov 2022 05:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiKYKea (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Nov 2022 05:34:30 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96873056B
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 02:34:27 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AP0pnMY024135
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 02:34:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=1X6XdfAoV/S+YS3Xpv7FZRCEt2MsaYLo5IYvr7/E++o=;
 b=PEwgYMQCbuTgT8GOd7/JgECkix/psPAu95HVgLthGDBSL0CVeXtRv8mFDNPI8iBSiRzk
 l2CeOIoIDI2+zEViG/P3PeqZbo3cAVPdwU4/dr6UdZI2ple1PmqdM0e92mxc0Z14ieyc
 gdXdPD3CmdFOmU2pc5HTI6OvfZsVh5eNqMlIeP2j2yZUHQFYO8kCk2dRbUxOfi65XYtj
 IR2xdbfv4L/VHItJdO13GXjkpZDwXPxMB25WQoR83a0Lw6EmRuBJsz7UqtA5cQELmqvT
 T7F+jgELbqo2Mh5ltxObryacZrfhrsobIjvu7ZrrZJt0nzT9ZWVj8L43mq6c9s0XUdIv 2Q== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m2b2hnq4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 02:34:27 -0800
Received: from twshared2003.08.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 02:34:25 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id DF5F6A283EC4; Fri, 25 Nov 2022 02:34:20 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 0/3] io_uring: completion cleanups
Date:   Fri, 25 Nov 2022 02:34:09 -0800
Message-ID: <20221125103412.1425305-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: qgMbq2VqnRYlnhsC2x8p7KFYcslD6FZ_
X-Proofpoint-GUID: qgMbq2VqnRYlnhsC2x8p7KFYcslD6FZ_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_02,2022-11-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

A couple of tiny cleanups and 1 revert. I think the revert may be neater
if you just drop it from your tree.

Patch 1: small cleanup removing a not-needed
Patch 2: spelling fix
Patch 3: I think I merged this badly, or at least misunderstood the recen=
t
changes. It was not needed, and confuses the _post suffix with also defer=
ring.

Dylan Yudaken (3):
  io_uring: remove io_req_complete_post_tw
  io_uring: spelling fix
  io_uring: Revert "io_uring: io_req_complete_post should defer if
    available"

 io_uring/io_uring.c | 8 +++-----
 io_uring/io_uring.h | 7 -------
 2 files changed, 3 insertions(+), 12 deletions(-)


base-commit: 43f3ae1898c9c6d907e5b5c1887a90409ff7ad30
--=20
2.30.2

