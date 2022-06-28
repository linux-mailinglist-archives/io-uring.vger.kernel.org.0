Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439C455E784
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 18:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347679AbiF1PCv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 11:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347674AbiF1PCt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 11:02:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA21433E89
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:02:47 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SABx70014952
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:02:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=pyAltF8DYKNcGBUwgWnhf6MefK8rwWmpC3KIBrdgbWM=;
 b=gIsKjSgVCHFLr+AU4YJ/Sfi1sw97O2hx1MsCJkcvTAQewoP7DzFpIS+vDKamWQOfSBVK
 NfSPs1iEeWLT5klSTzLAX5ViE20bNK3U9jz2isB08FG9SFH4ZojiBok/iqdM20ffaLPA
 91nHSxjWeOmPbUrjZ/BdNwOy3ewHEYyyVaE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gyp234bp8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:02:47 -0700
Received: from twshared25478.08.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 28 Jun 2022 08:02:45 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 7377F244BBC2; Tue, 28 Jun 2022 08:02:37 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next 0/8] io_uring: multishot recv
Date:   Tue, 28 Jun 2022 08:02:20 -0700
Message-ID: <20220628150228.1379645-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: gI-4HPkrNOD4AkIK542pbUh5FdzPKWDo
X-Proofpoint-GUID: gI-4HPkrNOD4AkIK542pbUh5FdzPKWDo
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_08,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series adds support for multishot recv/recvmsg to io_uring.

The idea is that generally socket applications will be continually
enqueuing a new recv() when the previous one completes. This can be
improved on by allowing the application to queue a multishot receive,
which will post completions as and when data is available. It uses the
provided buffers feature to receive new data into a pool provided by
the application.

This is more performant in a few ways:
* Subsequent receives are queued up straight away without requiring the
  application to finish a processing loop.
* If there are more data in the socket (sat the provided buffer
  size is smaller than the socket buffer) then the data is immediately
  returned, improving batching.
*  Poll is only armed once and reused, saving CPU cycles

Running a small network benchmark [1] shows improved QPS of ~6-8% over a ra=
nge of loads.

[1]: https://github.com/DylanZA/netbench/tree/multishot_recv

Dylan Yudaken (8):
  io_uring: allow 0 length for buffer select
  io_uring: restore bgid in io_put_kbuf
  io_uring: allow iov_len =3D 0 for recvmsg and buffer select
  io_uring: recycle buffers on error
  io_uring: clean up io_poll_check_events return values
  io_uring: add IOU_STOP_MULTISHOT return code
  io_uring: add IORING_RECV_MULTISHOT flag
  io_uring: multishot recv

 include/uapi/linux/io_uring.h |   5 ++
 io_uring/io_uring.h           |   7 ++
 io_uring/kbuf.c               |   4 +-
 io_uring/kbuf.h               |   8 ++-
 io_uring/net.c                | 119 ++++++++++++++++++++++++++++------
 io_uring/poll.c               |  30 ++++++---
 6 files changed, 140 insertions(+), 33 deletions(-)


base-commit: 755441b9029317d981269da0256e0a7e5a7fe2cc
--=20
2.30.2

