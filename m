Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8D956C0C6
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 20:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239136AbiGHSSu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jul 2022 14:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238880AbiGHSSs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jul 2022 14:18:48 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E070E5721E
        for <io-uring@vger.kernel.org>; Fri,  8 Jul 2022 11:18:44 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 268HBmi1031195
        for <io-uring@vger.kernel.org>; Fri, 8 Jul 2022 11:18:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=MJjN8AZ4OPF/OazUp4pG1HYkqvUZCJm+Jjk+22de8/0=;
 b=Wcx5JPz8yh6qCJ3cIMqWJem7hP8usvCKvmkesu694Z5+43vePbkQTZ654QtTNsf2MeMO
 xZYwRr57M3cOIfFm+5ZQHpUrhgPhYPM7Pr8HK8uyxboq5tRZqVhhEgci2OV2zWzVbOIq
 ji3tdhaPpYhwOvRWr5GnOcePHmIhD2TG+bU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h6f69kset-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 08 Jul 2022 11:18:44 -0700
Received: from twshared5640.09.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 8 Jul 2022 11:18:42 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 791972B9EC1A; Fri,  8 Jul 2022 11:18:40 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next 0/4] io_uring: multishot recv cleanups
Date:   Fri, 8 Jul 2022 11:18:34 -0700
Message-ID: <20220708181838.1495428-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: rD4Nar10nh2SsCc7zvxXBHHq9rgHFLYV
X-Proofpoint-ORIG-GUID: rD4Nar10nh2SsCc7zvxXBHHq9rgHFLYV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_14,2022-07-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

These are some preparatory cleanups that are separate but required for a
later series doing multishot recvmsg (will post this shortly).

Patches:
1: fixes a bug where a socket may receive data before polling
2: makes a similar change to compat logic for providing no iovs
for buffer_select
3/4: move the recycling logic into the io_uring main framework which make=
s
it a bit easier for recvmsg multishot

Dylan Yudaken (4):
  io_uring: fix multishot ending when not polled
  io_uring: support 0 length iov in buffer select in compat
  io-uring: add recycle_async to ops
  io_uring: move netmsg recycling into io_uring cleanup

 io_uring/io_uring.c |  8 ++++++--
 io_uring/net.c      | 35 ++++++++++++++++++++---------------
 io_uring/net.h      |  1 +
 io_uring/opdef.c    |  2 ++
 io_uring/opdef.h    |  1 +
 5 files changed, 30 insertions(+), 17 deletions(-)


base-commit: 8007202a9a4854eb963f1282953b1c83e91b8253
--=20
2.30.2

