Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD68D5615C8
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiF3JOR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbiF3JOP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:14:15 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA0420F7E
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:14:14 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25U0LZjE012121
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:14:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=J3jHAef7pJ/WI/T7+2xR7U+5ImtGMBx6TbdEpajVzHg=;
 b=NMx9NkwVKuV3649LLjRE8fnUAnvHhHw1Y2Hgym8VlCopAOrvEp39ubQ7kSlOkvC9W8/Z
 qNiBsgrls9OUpIbLXbG9v9/UYnupOq10yvAdyBi2YFXNmGnm7mZPkPmfF1R/RxfTrhxQ
 n9140gh9XpXoMsLZaufei5y7tdvtR++gPnw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h0rk5wwhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:14:14 -0700
Received: from twshared14577.08.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 02:14:13 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 88CD72599FCB; Thu, 30 Jun 2022 02:14:08 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 00/12] io_uring: multishot recv
Date:   Thu, 30 Jun 2022 02:12:19 -0700
Message-ID: <20220630091231.1456789-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: L7h5EfJwZMH5T9qGk2wrJuuOEYbOKWjs
X-Proofpoint-GUID: L7h5EfJwZMH5T9qGk2wrJuuOEYbOKWjs
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_05,2022-06-28_01,2022-06-22_01
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

While building this I noticed a small problem in multishot poll which is a =
really
big problem for receive. If CQEs overflow, then they will be returned to th=
e user
out of order. This is annoying for the existing use cases of poll and accep=
t but
doesn't totally break the functionality. Both of these return results that =
aren't
strictly ordered except for the IORING_CQE_F_MORE flag. For receive this ob=
viously
is a critical requirement as otherwise data will be received out of order b=
y the
application.

To fix this, when a multishot CQE hits overflow we remove multishot. The ap=
plication
should then clear CQEs until it sees that CQE, and noticing that IORING_CQE=
_F_MORE is
not set can re-issue the multishot request.

Patches:
1-3: relax restrictions around provided buffers to allow 0 size lengths
4: recycles more buffers on kernel side in error conditions
5-6: clean up multishot poll API a bit allowing it to end with succesful
error conditions
7-8: fix existing problems with multishot poll on overflow
9: is the multishot receive patch
10-11: are small fixes to tracing of CQEs

v2:
* Added patches 6,7,8 (fixing multishot poll bugs)
* Added patches 10,11 (trace cleanups)
* added io_recv_finish to reduce duplicate logic


Dylan Yudaken (12):
  io_uring: allow 0 length for buffer select
  io_uring: restore bgid in io_put_kbuf
  io_uring: allow iov_len =3D 0 for recvmsg and buffer select
  io_uring: recycle buffers on error
  io_uring: clean up io_poll_check_events return values
  io_uring: add IOU_STOP_MULTISHOT return code
  io_uring: add allow_overflow to io_post_aux_cqe
  io_uring: fix multishot poll on overflow
  io_uring: fix multishot accept ordering
  io_uring: multishot recv
  io_uring: fix io_uring_cqe_overflow trace format
  io_uring: only trace one of complete or overflow

 include/trace/events/io_uring.h |   2 +-
 include/uapi/linux/io_uring.h   |   5 ++
 io_uring/io_uring.c             |  17 ++--
 io_uring/io_uring.h             |  20 +++--
 io_uring/kbuf.c                 |   4 +-
 io_uring/kbuf.h                 |   9 ++-
 io_uring/msg_ring.c             |   4 +-
 io_uring/net.c                  | 139 ++++++++++++++++++++++++++------
 io_uring/poll.c                 |  44 ++++++----
 io_uring/rsrc.c                 |   4 +-
 10 files changed, 190 insertions(+), 58 deletions(-)


base-commit: 864a15ca4f196184e3f44d72efc1782a7017cbbd
--=20
2.30.2

