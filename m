Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD335AA362
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 00:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbiIAW7Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 18:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbiIAW7P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 18:59:15 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027FA786E2
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 15:59:14 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 281Mndqe024297
        for <io-uring@vger.kernel.org>; Thu, 1 Sep 2022 15:59:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=pOeLR7xmdM88xwwC8tHg94MHHdooLeshYcrJC5bEeSY=;
 b=I9kFd2WoxAUsM66Yu0JvQ4uC1rAJkS8tCBGa12HrMZhjxB0hoXIrlr83V0k0gr6b+zaW
 ZTIDeiilBjtmYsntLq+GW3AmfmkgFRa2svp6NlM8Wl79++TzHj7Mi7igzDf4h3YzhyWi
 dAbILy6UuqKQvLAe9Z3XQaLthGV8zSzetmQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jaab32mry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 15:59:14 -0700
Received: from twshared20183.05.prn5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 15:59:13 -0700
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id 6947C19149B1; Thu,  1 Sep 2022 15:59:06 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <kernel-team@fb.com>, <io-uring@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
CC:     <shr@fb.com>, <axboe@kernel.dk>, <josef@toxicpanda.com>
Subject: [PATCH v1 00/10] io-uring/btrfs: support async buffered writes
Date:   Thu, 1 Sep 2022 15:58:39 -0700
Message-ID: <20220901225849.42898-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: qsLGKuDyhq1OULxgGsb_Bbu7GW-1btsq
X-Proofpoint-ORIG-GUID: qsLGKuDyhq1OULxgGsb_Bbu7GW-1btsq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_12,2022-08-31_03,2022-06-22_01
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
  For fio the following results have been obtained with a queue depth of
  1 and 4k block size (runtime 600 secs):

                 sequential writes:
                 without patch           with patch      libaio     psync
  iops:              55k                    134k          117K       148K
  bw:               221MB/s                 538MB/s       469MB/s    592M=
B/s
  clat:           15286ns                    82ns         994ns     6340n=
s


For an io depth of 1, the new patch improves throughput by over two times
(compared to the exiting behavior, where buffered writes are processed by=
 an
io-worker process) and also the latency is considerably reduced. To achie=
ve the
same or better performance with the exisiting code an io depth of 4 is re=
quired.
Increasing the iodepth further does not lead to improvements.


BTRFS changes:
  Add option for NOWAIT IOCB's to tell that searches do not wait on locks=
. This
  adds the nowait option to btrfs_path.

  For NOWAIT buffered writes on PREALLOC or NOCOW extents tell can_nocow_=
extent()
  that we don't want to wait on any locks or metadata IO.

  Support no_flush reservations for nowait buffered writes.

  Add btrfs_try_lock_ordered_range() function.

  Add nowait flag to btrfs_check_nocow_lock() to use it in write code pat=
h.

  Add nowait parameter to prepare_pages() function.

  Plumb nowait through the write code path.

  Enable nowait buffered writes.


Testing:
  This patch has been tested with xfstests, fsx, fio. xfstests shows no n=
ew
  diffs compared to running without the patch series.


Josef Bacik (5):
  btrfs: implement a nowait option for tree searches
  btrfs: make can_nocow_extent nowait compatible
  btrfs: add the ability to use NO_FLUSH for data reservations
  btrfs: add btrfs_try_lock_ordered_range
  btrfs: make btrfs_check_nocow_lock nowait compatible

Stefan Roesch (5):
  btrfs: make prepare_pages nowait compatible
  btrfs: make lock_and_cleanup_extent_if_need nowait compatible
  btrfs: btrfs: plumb NOWAIT through the write path
  btrfs: make balance_dirty_pages nowait compatible
  btrfs: enable nowait async buffered writes

 fs/btrfs/block-group.c    |   2 +-
 fs/btrfs/ctree.c          |  39 +++++++++++-
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
 17 files changed, 229 insertions(+), 59 deletions(-)


base-commit: b90cb1053190353cc30f0fef0ef1f378ccc063c5
--=20
2.30.2

