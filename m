Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171045B61A8
	for <lists+io-uring@lfdr.de>; Mon, 12 Sep 2022 21:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiILT2E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Sep 2022 15:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiILT2D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Sep 2022 15:28:03 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B408E4455E
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:01 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CHVFj0010392
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=FmPcMYlNEdzY+NAVa51bcno64s7MYjavMzUqAhehX/A=;
 b=TCtz/98aJSWsmTrVld8LoRZ/gCFSo1AdhrPMY00mJoHh+Bgw0u3L8BY25m3Pr0SEi5gh
 kcsfkV8i3Z0jdSBTotvozRvzdPu7zspXvClR8hRTwHAVvc8EWtA+Hn/2fFxBCqqFaejp
 GALsgY/Clhq0cT7rQIqK6VAPBCoc4T3xrTM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jgr9smh6y-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 12:28:01 -0700
Received: from twshared20183.05.prn5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 12:27:59 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id E35742085226; Mon, 12 Sep 2022 12:27:53 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, <linux-mm@kvack.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>,
        <fdmanana@gmail.com>
Subject: [PATCH v3 00/12] io-uring/btrfs: support async buffered writes 
Date:   Mon, 12 Sep 2022 12:27:40 -0700
Message-ID: <20220912192752.3785061-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ex41x4vK-PofjX5k5dT--BnuVPeLlmor
X-Proofpoint-GUID: ex41x4vK-PofjX5k5dT--BnuVPeLlmor
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_13,2022-09-12_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch series adds support for async buffered writes when using both
btrfs and io-uring. Currently io-uring only supports buffered writes (for=
 btrfs)
in the slow path, by processing them in the io workers. With this patch s=
eries
it is now possible to support buffered writes in the fast path. To be abl=
e to use
the fast path, the required pages must be in the page cache, the required=
 locks
in btrfs can be granted immediately and no additional blocks need to be r=
ead
form disk.

This patch series makes use of the changes that have been introduced by a
previous patch series: "io-uring/xfs: support async buffered writes"

Performance results:

The new patch improves throughput by over two times (compared to the exit=
ing
behavior, where buffered writes are processed by an io-worker process) an=
d also
the latency is considerably reduced. Detailled results are part of the ch=
angelog
of the first commit.


BTRFS changes:
 -Add option for NOWAIT IOCB's to tell that searches do not wait on locks=
. This
  adds the nowait option to btrfs_path.
 -For NOWAIT buffered writes on PREALLOC or NOCOW extents tell can_nocow_=
extent()
  that we don't want to wait on any locks or metadata IO.
 -Support no_flush reservations for nowait buffered writes.
 -Add btrfs_try_lock_ordered_range() function.
 -Add nowait flag to btrfs_check_nocow_lock() to use it in write code pat=
h.
 -Add nowait parameter to prepare_pages() function.
 -Plumb nowait through the write code path.
 -Enable nowait buffered writes.


Testing:
  This patch has been tested with xfstests, fsx, fio. xfstests shows no n=
ew
  diffs compared to running without the patch series.


Changes:

V3:
 - Updated changelog of "btrfs: implement a nowait option for tree search=
es"
   to say -EAGAIN.
 - Use bool return value in signature of btrfs_try_lock_ordered_range
 - Renamed variable tmp to can_nocow in btrfs_buffered_write
 - Fixed coding style in get_prepare_fgp_flags
 - Set pages[i] to NULL in error code path of lock_and_cleanup_extent_if_=
need()
 - Added const in definition of "bool nowait"
 - Removed unlikely from btrfs_buffered_write
 - Rephrased changelog for "btrfs: add assert to search functions" and us=
ed
   asserts instead of warnings
 - Explained why enocded writes are not supported in the changelog
 - Moved performance results to changelog of first commit
=20
V2:
 - Replace EWOULDBLOCK with EAGAIN. In Version 1 it was not used consiste=
ntly
 - Export function balance_dirty_pages_ratelimited_flags()
 - Add asserts/warnings for search functions when nowait is set, but we d=
on't
   expect that they are invoked with nowait set.



Josef Bacik (5):
  btrfs: implement a nowait option for tree searches
  btrfs: make can_nocow_extent nowait compatible
  btrfs: add the ability to use NO_FLUSH for data reservations
  btrfs: add btrfs_try_lock_ordered_range
  btrfs: make btrfs_check_nocow_lock nowait compatible

Stefan Roesch (7):
  mm: export balance_dirty_pages_ratelimited_flags()
  btrfs: make prepare_pages nowait compatible
  btrfs: make lock_and_cleanup_extent_if_need nowait compatible
  btrfs: plumb NOWAIT through the write path
  btrfs: make balance_dirty_pages nowait compatible
  btrfs: assert nowait mode is not used for some btree search functions
  btrfs: enable nowait async buffered writes

 fs/btrfs/block-group.c    |   2 +-
 fs/btrfs/ctree.c          |  43 ++++++++++++-
 fs/btrfs/ctree.h          |   8 ++-
 fs/btrfs/delalloc-space.c |  13 +++-
 fs/btrfs/delalloc-space.h |   3 +-
 fs/btrfs/extent-tree.c    |   5 ++
 fs/btrfs/file-item.c      |   4 +-
 fs/btrfs/file.c           | 124 ++++++++++++++++++++++++++++----------
 fs/btrfs/inode.c          |  22 ++++---
 fs/btrfs/locking.c        |  23 +++++++
 fs/btrfs/locking.h        |   1 +
 fs/btrfs/ordered-data.c   |  28 +++++++++
 fs/btrfs/ordered-data.h   |   1 +
 fs/btrfs/relocation.c     |   2 +-
 fs/btrfs/scrub.c          |   4 +-
 fs/btrfs/space-info.c     |   3 +-
 fs/btrfs/tree-log.c       |   6 +-
 mm/page-writeback.c       |   1 +
 18 files changed, 234 insertions(+), 59 deletions(-)


base-commit: 80e78fcce86de0288793a0ef0f6acf37656ee4cf
--=20
2.30.2

