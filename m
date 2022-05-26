Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C1B535296
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 19:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348305AbiEZRi6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 May 2022 13:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344134AbiEZRi5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 May 2022 13:38:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E679994D1
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:38:56 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24QGRKxR009858
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:38:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=hKApRetDHP7lPOI5DiT073yP/mEw3uAhNIIoin1tkJU=;
 b=NLKFLC2BJ2a3bNrXPimlGGenozHcvSXmmW+x68t9ACH9/dZBAu1sl40j2kjS+B5Kp3wZ
 gRX35jOe74st8h4bPnA6Igtcdy8oHyJgniQYH9Nx7axqjiNty7gI5dIGkzgJ8Y+zZjOf
 G2e3Ja8l/3FQYXk5NhqM3vtfT2sEzg7Sxe4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g93upptyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:38:55 -0700
Received: from twshared24024.25.frc3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 26 May 2022 10:38:54 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 5D6A7FA621CC; Thu, 26 May 2022 10:38:45 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [PATCH v6 00/16] io-uring/xfs: support async buffered writes
Date:   Thu, 26 May 2022 10:38:24 -0700
Message-ID: <20220526173840.578265-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 6oJfm-aM8S_lIy9Iksw5Kw-HE3JSNMiG
X-Proofpoint-ORIG-GUID: 6oJfm-aM8S_lIy9Iksw5Kw-HE3JSNMiG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-26_09,2022-05-25_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch series adds support for async buffered writes when using both
xfs and io-uring. Currently io-uring only supports buffered writes in the
slow path, by processing them in the io workers. With this patch series i=
t is
now possible to support buffered writes in the fast path. To be able to u=
se
the fast path the required pages must be in the page cache, the required =
locks
in xfs can be granted immediately and no additional blocks need to be rea=
d
form disk.

Updating the inode can take time. An optimization has been implemented fo=
r
the time update. Time updates will be processed in the slow path. While t=
here
is already a time update in process, other write requests for the same fi=
le,
can skip the update of the modification time.
 =20

Performance results:
  For fio the following results have been obtained with a queue depth of
  1 and 4k block size (runtime 600 secs):

                 sequential writes:
                 without patch           with patch      libaio     psync
  iops:              77k                    209k          195K       233K
  bw:               314MB/s                 854MB/s       790MB/s    953M=
B/s
  clat:            9600ns                   120ns         540ns     3000n=
s


For an io depth of 1, the new patch improves throughput by over three tim=
es
(compared to the exiting behavior, where buffered writes are processed by=
 an
io-worker process) and also the latency is considerably reduced. To achie=
ve the
same or better performance with the exisiting code an io depth of 4 is re=
quired.
Increasing the iodepth further does not lead to improvements.

In addition the latency of buffered write operations is reduced considera=
bly.



Support for async buffered writes:

  To support async buffered writes the flag FMODE_BUF_WASYNC is introduce=
d. In
  addition the check in generic_write_checks is modified to allow for asy=
nc
  buffered writes that have this flag set.

  Changes to the iomap page create function to allow the caller to specif=
y
  the gfp flags. Sets the IOMAP_NOWAIT flag in iomap if IOCB_NOWAIT has b=
een set
  and specifies the requested gfp flags.

  Adds the iomap async buffered write support to the xfs iomap layer.
  Adds async buffered write support to the xfs iomap layer.

Support for async buffered write support and inode time modification

  Splits the functions for checking if the file privileges need to be rem=
oved in
  two functions: check function and a function for the removal of file pr=
ivileges.
  The same split is also done for the function to update the file modific=
ation time.

  Implement an optimization that while a file modification time is pendin=
g other
  requests for the same file don't need to wait for the file modification=
 update.=20
  This avoids that a considerable number of buffered async write requests=
 get
  punted.

  Take the ilock in nowait mode if async buffered writes are enabled and =
enable
  the async buffered writes optimization in io_uring.

Support for write throttling of async buffered writes:

  Add a no_wait parameter to the exisiting balance_dirty_pages() function=
. The
  function will return -EAGAIN if the parameter is true and write throttl=
ing is
  required.

  Add a new function called balance_dirty_pages_ratelimited_async() that =
will be
  invoked from iomap_write_iter() if an async buffered write is requested=
.
 =20
Enable async buffered write support in xfs
   This enables async buffered writes for xfs.


Testing:
  This patch has been tested with xfstests and fio.


Changes:
  V6:
  - pass in iter->flags to calls in iomap_page_create()
 =20
  V5:
  - Refreshed to 5.19-rc1
  - Merged patch 3 and patch 4
    "mm: Prepare balance_dirty_pages() for async buffered writes" and
    "mm: Add balance_dirty_pages_ratelimited_flags() function"
  - Reformatting long file in iomap_page_create()
  - Replacing gfp parameter with flags parameter in iomap_page_create()
    This makes sure that the gfp setting is done in one location.
  - Moved variable definition outside of loop in iomap_write_iter()
  - Merged patch 7 with patch 6.
  - Introduced __file_remove_privs() that get the iocb_flags passed in
    as an additional parameter
  - Removed file_needs_remove_privs() function
  - Renamed file_needs_update_time() inode_needs_update_time()
  - inode_needs_update_time() no longer passes the file pointer
  - Renamed file_modified_async() to file_modified_flags()
  - Made file_modified_flags() an internal function
  - Removed extern keyword in file_modified_async definition
  - Added kiocb_modified function.
  - Separate patch for changes to xfs_ilock_for_iomap()
  - Separate patch for changes to xfs_ilock_inode()
  - Renamed xfs_ilock_xfs_inode()n back to xfs_ilock_iocb()
  - Renamed flags parameter to iocb_flags in function xfs_ilock_iocb()
  - Used inode_set_flags() to manipulate inode flags in the function
    file_modified_flags()

  V4:
  - Reformat new code in generic_write_checks_count().
  - Removed patch that introduced new function iomap_page_create_gfp().
  - Add gfp parameter to iomap_page_create() and change all callers
    All users will enforce the number of blocks check
  - Removed confusing statement in iomap async buffer support patch
  - Replace no_wait variable in __iomap_write_begin with check of
    IOMAP_NOWAIT for easier readability.
  - Moved else if clause in __iomap_write_begin into else clause for
    easier readability
  - Removed the balance_dirty_pages_ratelimited_async() function and
    reverted back to the earlier version that used the function
    balance_dirty_pages_ratelimited_flags()
  - Introduced the flag BDP_ASYNC.
  - Renamed variable in iomap_write_iter from i_mapping to mapping.
  - Directly call balance_dirty_pages_ratelimited_flags() in the function
    iomap_write_iter().
  - Re-ordered the patches.
 =20
  V3:
  - Reformat new code in generic_write_checks_count() to line lengthof 80=
.
  - Remove if condition in __iomap_write_begin to maintain current behavi=
or.
  - use GFP_NOWAIT flag in __iomap_write_begin
  - rename need_file_remove_privs() function to file_needs_remove_privs()
  - rename do_file_remove_privs to __file_remove_privs()
  - add kernel documentation to file_remove_privs() function
  - rework else if branch in file_remove_privs() function
  - add kernel documentation to file_modified() function
  - add kernel documentation to file_modified_async() function
  - rename err variable in file_update_time to ret
  - rename function need_file_update_time() to file_needs_update_time()
  - rename function do_file_update_time() to __file_update_time()
  - don't move check for FMODE_NOCMTIME in generic helper
  - reformat __file_update_time for easier reading
  - add kernel documentation to file_update_time() function
  - fix if in file_update_time from < to <=3D
  - move modification of inode flags from do_file_update_time to file_mod=
ified()
    When this function is called, the caller must hold the inode lock.
  - 3 new patches from Jan to add new no_wait flag to balance_dirty_pages=
(),
    remove patch 12 from previous series
  - Make balance_dirty_pages_ratelimited_flags() a static function
  - Add new balance_dirty_pages_ratelimited_async() function
 =20
  V2:
  - Remove atomic allocation
  - Use direct write in xfs_buffered_write_iomap_begin()
  - Use xfs_ilock_for_iomap() in xfs_buffered_write_iomap_begin()
  - Remove no_wait check at the end of xfs_buffered_write_iomap_begin() f=
or
    the COW path.
  - Pass xfs_inode pointer to xfs_ilock_iocb and rename function to
    xfs_lock_xfs_inode
  - Replace existing uses of xfs_ilock_iocb with xfs_ilock_xfs_inode
  - Use xfs_ilock_xfs_inode in xfs_file_buffered_write()
  - Callers of xfs_ilock_for_iomap need to initialize lock mode. This is
    required so writes use an exclusive lock
  - Split of _balance_dirty_pages() from balance_dirty_pages() and return
    sleep time
  - Call _balance_dirty_pages() in balance_dirty_pages_ratelimited_flags(=
)
  - Move call to balance_dirty_pages_ratelimited_flags() in iomap_write_i=
ter()
    to the beginning of the loop


Jan Kara (3):
  mm: Move starting of background writeback into the main balancing loop
  mm: Move updates of dirty_exceeded into one place
  mm: Add balance_dirty_pages_ratelimited_flags() function

Stefan Roesch (13):
  iomap: Add flags parameter to iomap_page_create()
  iomap: Add async buffered write support
  fs: Add check for async buffered writes to generic_write_checks
  fs: add __remove_file_privs() with flags parameter
  fs: Split off inode_needs_update_time and __file_update_time
  fs: Add async write file modification handling.
  fs: Optimization for concurrent file time updates.
  io_uring: Add support for async buffered writes
  io_uring: Add tracepoint for short writes
  xfs: Specify lockmode when calling xfs_ilock_for_iomap()
  xfs: Change function signature of xfs_ilock_iocb()
  xfs: Add async buffered write support
  xfs: Enable async buffered write support

 fs/inode.c                      | 177 ++++++++++++++++++++++++--------
 fs/io_uring.c                   |  32 +++++-
 fs/iomap/buffered-io.c          |  50 +++++++--
 fs/read_write.c                 |   4 +-
 fs/xfs/xfs_file.c               |  34 +++---
 fs/xfs/xfs_iomap.c              |  11 +-
 include/linux/fs.h              |   7 ++
 include/linux/writeback.h       |   7 ++
 include/trace/events/io_uring.h |  25 +++++
 mm/page-writeback.c             |  86 +++++++++-------
 10 files changed, 311 insertions(+), 122 deletions(-)


base-commit: 140e40e39a29c7dbc188d9b43831c3d5e089c960
--=20
2.30.2

