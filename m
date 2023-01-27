Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2750967E719
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 14:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbjA0Nwv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 08:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbjA0Nwr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 08:52:47 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D797F7E6EB
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 05:52:44 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30R933eJ024220
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 05:52:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=4rJEoWyZLBmY7BheniENvqdPM1pPdLbnkrdA60tZU1U=;
 b=W/NETikFKi+9JK2AEdpjOnjPuzmL4zew7YJ7sAS1jn9kkUDHyEGdXJgLmh6WTMy34PpY
 Epe+0a9iPcJw/VznQ3txw4SJSYMZZHIxHgR/7R5554qBozuie8lH8N7mcHGtYR/NVUdY
 vUv59FYRMNireg1pAK5pHWzx6NG5aEnG0MFlRnovuykFEixOjS4j2qEOpWtnf6mNp94x
 a+WH/Rv/hLDHDOBVycy5I04OeCrKFg0q4mKgcRdMcKSAI8blegRdIeLJ3geWgLa90o9L
 yuX2JrvBlLrsJSQhb8vDhOQ5Zxn56YeB9nDUdWjYL/ywAYqjawEe45uabwr8SkI6xcxO 3Q== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nbb804x1p-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 05:52:44 -0800
Received: from twshared5320.05.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Fri, 27 Jan 2023 05:52:40 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id E5A8BEA2811C; Fri, 27 Jan 2023 05:52:34 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 0/4] io_uring: force async only ops to go async
Date:   Fri, 27 Jan 2023 05:52:23 -0800
Message-ID: <20230127135227.3646353-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 06Tztr7Ddlw2K_HH92LjhabZqGaq_xbG
X-Proofpoint-GUID: 06Tztr7Ddlw2K_HH92LjhabZqGaq_xbG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_08,2023-01-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Many ops such as statx do not support nonblock issuing (for now). At the
moment the code goes through the issue call just to receive -EAGAIN and
then be run async. There is no need for this as internally the
REQ_F_FORCE_ASYNC flag can just be added on.

The upside for this is generally minimal, and possibly you may decide tha=
t
it's not worth the extra risk of bugs. Though as far as I can tell the
risk is simply doing a blocking call from io_uring_enter(2), which while
still a bug is not disasterous.

While doing this I noticed that linked requests are actually issued with
IO_URING_F_NONBLOCK first regardless of the IOSQE_ASYNC flag, and so I
fixed this at the same time. The difference should be neglegible I assume=
.

Note this depends on the drain fix I have just sent for 6.2.

Patch 1 is the fix.
Patch 2 forces async for the easy cases where it is always on
Patch 3/4 is for fadvise/open which require a bit of logic to determine w=
hether
or not to force async

Dylan Yudaken (4):
  io_uring: if a linked request has REQ_F_FORCE_ASYNC then run it async
  io_uring: for requests that require async, force it
  io_uring: always go async for unsupported fadvise flags
  io_uring: always go async for unsupported open flags

 io_uring/advise.c    | 29 +++++++++++++++++------------
 io_uring/fs.c        | 20 ++++++++++----------
 io_uring/io_uring.c  |  8 +++++---
 io_uring/net.c       |  4 ++--
 io_uring/openclose.c | 18 ++++++++++++------
 io_uring/splice.c    |  7 +++----
 io_uring/statx.c     |  4 ++--
 io_uring/sync.c      | 14 ++++++++------
 io_uring/xattr.c     | 14 ++++++--------
 9 files changed, 65 insertions(+), 53 deletions(-)


base-commit: cea6756d62abfc4791efc81d1f6afa016ed8df8c
--=20
2.30.2

