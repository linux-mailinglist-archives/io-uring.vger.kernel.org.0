Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE59D61F3BE
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 13:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiKGMxA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 07:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiKGMxA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 07:53:00 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EA41C120
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 04:52:59 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A75wJvg012168
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 04:52:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=f9CQWjUZa5CYlWBcpQqpmH5uRx+/+uU4tbmcSsGLQo0=;
 b=JMa1dgieyWCp5/90y/C++LtTEkKIr26qNjMoGoNeETlsiMxLvudPhr3quYB0c30QODTh
 EdylsHW7DYMlidfXCi3+M+QVjQWy4Wq2w7kGxe7XJ8QFR5Eju/bviynkls4N0Ksb2RLa
 Gu2t8pGc+FXBAwTmIIzQvgfW2X7iHNVCSLDznoLef5Ekg5LLXN2vN9hbyuUDlDylZf9J
 VgrpmHlVvaoCUASAsb0+XMa/d0nMWSQQDWReEmemBlb12DnlD04zwKnfShjjmPK8CKdJ
 1FQ/zA0K4KLse0w3A+m5xraDxCvVllFWYxe3Qr5H4VgXXpgcl8b+tux11lPF6ViAIVzJ Ng== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3knnjxwk59-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 04:52:58 -0800
Received: from twshared9088.05.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 04:52:56 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 3830590D69E1; Mon,  7 Nov 2022 04:52:45 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 0/4] io_uring: cleanup allow_overflow on post_cqe
Date:   Mon, 7 Nov 2022 04:52:32 -0800
Message-ID: <20221107125236.260132-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Ci3He0_WlQ3nnwkn0CZDLja5bSLFXHZE
X-Proofpoint-GUID: Ci3He0_WlQ3nnwkn0CZDLja5bSLFXHZE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_05,2022-11-07_01,2022-06-22_01
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,RISK_FREE,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Previously, CQE ordering could be broken in multishot if there was an
overflow, and so the multishot was stopped in overflow. However since
Pavel's change in commit aa1df3a360a0 ("io_uring: fix CQE reordering"),
there is no risk of out of order completions being received by userspace.

So we can now clean up this code.

Dylan Yudaken (4):
  io_uring: revert "io_uring fix multishot accept ordering"
  io_uring: revert "io_uring: fix multishot poll on overflow"
  io_uring: allow multishot recv CQEs to overflow
  io_uring: remove allow_overflow parameter

 io_uring/io_uring.c | 13 ++++---------
 io_uring/io_uring.h |  6 ++----
 io_uring/msg_ring.c |  4 ++--
 io_uring/net.c      | 19 ++++++-------------
 io_uring/poll.c     |  6 ++----
 io_uring/rsrc.c     |  4 ++--
 6 files changed, 18 insertions(+), 34 deletions(-)


base-commit: 765d0e263fccc8b22efef8258c3260e9d0ecf632
--=20
2.30.2

