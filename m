Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF91613836
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 14:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiJaNll (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 09:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbiJaNlk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 09:41:40 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFA2101FC
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:38 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VDFXe2007794
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=kK7g1Lujtkd2mfDFDGcBFNvGpEoKwNNfCjLnYvNGz74=;
 b=VtZRCRWGtuwwt+ENx+fBaMFWcTtHNoSmVbF3YhLZdQ3ZXr3683x8fM+m63wIxtpBi7KT
 nPPQUoVu5Mq7giE67KTotnwbSAqm6kSzq8rp3wCf5QkvWYswiJFcVfkrF7yG+etXRL29
 0E84oBP0tMLLPbGydf3pOXAN+2eJ2w4Dd1jqzhmBE0VTtu84v4gRHviTWjXVnskMqLWl
 FNK48jsSjT1JNZjPj9/Sg4iJW9QkO80o5qEKkbNWTdZgsyHe0cG8QoXqwtjo1KDOhw72
 hSbn8vIJj09Z+ng4OYFYj8l1k9GkIIGuWaowi9flRIbkKmIO/6Q9Zpwws+DGJaPYRgNF +g== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kh07p6943-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:38 -0700
Received: from twshared5476.02.ash7.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 06:41:37 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id A17438A19647; Mon, 31 Oct 2022 06:41:35 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 00/12] io_uring: retarget rsrc nodes periodically
Date:   Mon, 31 Oct 2022 06:41:14 -0700
Message-ID: <20221031134126.82928-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: IycgthpKJzo1wyzMTTJV4gbsRoaJ5lh-
X-Proofpoint-ORIG-GUID: IycgthpKJzo1wyzMTTJV4gbsRoaJ5lh-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_15,2022-10-31_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is a problem with long running io_uring requests and rsrc node
cleanup, where a single long running request can block cleanup of all
subsequent nodes. For example a network server may have both long running
accepts and also use registered files for connections. When sockets are
closed and returned (either through close_direct, or through
register_files_update) the underlying file will not be freed until that
original accept completes. For the case of multishot this may be the
lifetime of the application, which will cause file numbers to grow
unbounded - resulting in either OOMs or ENFILE errors.

To fix this I propose retargeting the rsrc nodes from ongoing requests to
the current main request of the io_uring. This only needs to happen for
long running requests types, and specifically those that happen as a
result of some external event. For this reason I exclude write/send style
ops for the time being as even though these can cause this issue in
reality it would be unexpected to have a write block for hours. This
support can obviously be added later if needed.

In order to retarget nodes all the outstanding requests (in both poll
tables and io-wq) need to be iterated and the request needs to be checked
to make sure the retargeting is valid. For example for FIXED_FILE request=
s
this involves ensuring the file is still referenced in the current node.
This O(N) operation seems to take ~1ms locally for 30k outstanding
requests. Note it locks the io_uring while it happens and so no other wor=
k
can occur. In order to amortize this cost slightly, I propose running thi=
s
operation at most every 60 seconds. It is hard coded currently, but would
be happy to take suggestions if this should be customizable (and how to d=
o
such a thing).

Without customizable retargeting period, it's a bit difficult to submit
tests for this. I have a test but it obviously takes a many minutes to ru=
n
which is not going to be acceptable for liburing.

Patches 1-5 are the basic io_uring infrastructure
Patch 6 is a helper function used in the per op customisations
Patch 7 splits out the zerocopy specific field in io_sr_msg
Patches 8-12 are opcode implementations for retargeting

Dylan Yudaken (12):
  io_uring: infrastructure for retargeting rsrc nodes
  io_uring: io-wq helper to iterate all work
  io_uring: support retargeting rsrc on requests in the io-wq
  io_uring: reschedule retargeting at shutdown of ring
  io_uring: add tracing for io_uring_rsrc_retarget
  io_uring: add fixed file peeking function
  io_uring: split send_zc specific struct out of io_sr_msg
  io_uring: recv/recvmsg retarget_rsrc support
  io_uring: accept retarget_rsrc support
  io_uring: read retarget_rsrc support
  io_uring: read_fixed retarget_rsrc support
  io_uring: poll_add retarget_rsrc support

 include/linux/io_uring_types.h  |   2 +
 include/trace/events/io_uring.h |  30 +++++++
 io_uring/io-wq.c                |  49 +++++++++++
 io_uring/io-wq.h                |   3 +
 io_uring/io_uring.c             |  28 ++++--
 io_uring/io_uring.h             |   1 +
 io_uring/net.c                  | 114 ++++++++++++++++--------
 io_uring/net.h                  |   2 +
 io_uring/opdef.c                |   7 ++
 io_uring/opdef.h                |   1 +
 io_uring/poll.c                 |  12 +++
 io_uring/poll.h                 |   2 +
 io_uring/rsrc.c                 | 148 ++++++++++++++++++++++++++++++++
 io_uring/rsrc.h                 |   2 +
 io_uring/rw.c                   |  29 +++++++
 io_uring/rw.h                   |   2 +
 16 files changed, 390 insertions(+), 42 deletions(-)


base-commit: 30209debe98b6f66b13591e59e5272cb65b3945e
--=20
2.30.2

