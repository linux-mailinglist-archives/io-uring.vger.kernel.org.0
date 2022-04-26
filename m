Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1096A5105A8
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 19:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbiDZRrD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 13:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243129AbiDZRrA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 13:47:00 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF181816ED
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:43:51 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGQR22024414
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:43:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=L9bCsWpK1sSy2SbZ0ozW3EIL4BqTxs2Dpb6c3uXdY3Y=;
 b=XG1WM87pFn+ABNzlg38vNPdckKMrggktEF0Y2fb32NWJMoLcY992rtx2JISUBIUr61Uh
 supEU+aQ7qmCd6JwQRZAJrMdWqjLxXCl/5qyyU4MsqRMLc9vxw1pJEdlDu0wOkXSQxtv
 m8MBTEJci0vO4ZL+EhsuKZWjw19Eji0LBxo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fn1ge03e0-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:43:50 -0700
Received: from twshared10896.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 10:43:47 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 71719E2D4853; Tue, 26 Apr 2022 10:43:40 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>
Subject: [RFC PATCH v1 00/18] io-uring/xfs: support async buffered writes
Date:   Tue, 26 Apr 2022 10:43:17 -0700
Message-ID: <20220426174335.4004987-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Jxf2RGjVYdeCoVUyUZ4zqQ_gbkFPX7dQ
X-Proofpoint-GUID: Jxf2RGjVYdeCoVUyUZ4zqQ_gbkFPX7dQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
                 without patch                 with patch
  iops:              80k                          269k


                 random writes:
                 without patch                 with patch
  iops:              76k                          249k

For an io depth of 1, the new patch improves throughput by over three tim=
es
(compared to the exiting behavior, where buffered writes are processed by=
 an
io-worker process) and also the latency is considerably reduced. To achie=
ve the
same or better performance with the exisiting code an io depth of 4 is re=
quired.
Increasing the iodepth further does not lead to any further improvements.

Especially for mixed workloads this is a considerable improvement.



Support for async buffered writes:

  Patch 1: block: add check for async buffered writes to generic_write_ch=
ecks
    Add a new flag FMODE_BUF_WASYNC so filesystems can specify that they =
support
    async buffered writes and include the flag in the check of the functi=
on
    generic_write_checks().
   =20
  Patch 2: mm: add FGP_ATOMIC flag to __filemap_get_folio()
    This adds the FGP_ATOMIC flag. This allows to specify the gfp flags
    for memory allocations for async buffered writes.
   =20
  Patch 3: iomap: add iomap_page_create_gfp to allocate iomap_pages
    Add new function to allow specifying gfp flags when allocating and
    initializing the structure iomap_page.

  Patch 4: iomap: use iomap_page_create_gfp() in __iomap_write_begin
    Add a gfp flag to the iomap_page_create function.
 =20
  Patch 5: iomap: add async buffered write support
    Set IOMAP_NOWAIT flag if IOCB_NOWAIT is set. Also use specific gfp fl=
ags if
    the iomap_page structure is allocated for an async buffered page.

  Patch 6: xfs: add iomap async buffered write support
    Add async buffered write support to the xfs iomap layer.

Support for async buffered write support and inode time modification


  Patch 7: fs: split off need_remove_file_privs() do_remove_file_privs()
    Splits of a check and action function, so they can later be invoked
    in the nowait code path.
   =20
  Patch 8: fs: split off need_file_update_time and do_file_update_time
    Splits of a check and action function, so they can later be invoked
    in the nowait code path.
   =20
  Patch 9: fs: add pending file update time flag.
    Add new flag so consecutive write requests for the same inode can
    proceed without waiting for the inode modification time to complete.

  Patch 10: xfs: enable async write file modification handling.
    Enable async write handling in xfs for the file modification time
    update. If the file modification update requires logging or removal
    of privileges that needs to wait, -EAGAIN is returned.

  Patch 11: xfs: add async buffered write support
    Take the ilock in nowait mode if async buffered writes are enabled.

  Patch 12: io_uring: add support for async buffered writes
    This enables the async buffered writes optimization in io_uring.
    Buffered writes are enabled for blocks that are already in the page
    cache.

  Patch 13: io_uring: Add tracepoint for short writes

Support for write throttling of async buffered writes:

  Patch 14: sched: add new fields to task_struct
    Add two new fields to the task_struct. These fields store the
    deadline after which writes are no longer throttled.

  Patch 15: mm: support write throttling for async buffered writes
    This changes the balance_dirty_pages function to take an additional
    parameter. When nowait is specified the write throttling code no
    longer waits synchronously for the deadline to expire. Instead
    it sets the fields in task_struct. Once the deadline expires the
    fields are reset.
   =20
  Patch 16: iomap: User throttling for async buffered writes.
    Enable async buffered write throttling in iomap.

  Patch 17: io_uring: support write throttling for async buffered writes
    Adds support to io_uring for write throttling. When the writes
    are throttled, the write requests are added to the pending io list.
    Once the write throttling deadline expires, the writes are submitted.

Enable async buffered write support in xfs
  Patch 18: xfs: enable async buffered write support
    This enables the flag that enables async buffered writes for xfs.


Testing:
  This patch has been tested with xfstests and fio.


Stefan Roesch (18):
  block: add check for async buffered writes to generic_write_checks
  mm: add FGP_ATOMIC flag to __filemap_get_folio()
  iomap: add iomap_page_create_gfp to allocate iomap_pages
  iomap: use iomap_page_create_gfp() in __iomap_write_begin
  iomap: add async buffered write support
  xfs: add iomap async buffered write support
  fs: split off need_remove_file_privs() do_remove_file_privs()
  fs: split off need_file_update_time and do_file_update_time
  fs: add pending file update time flag.
  xfs: Enable async write file modification handling.
  xfs: add async buffered write support
  io_uring: add support for async buffered writes
  io_uring: add tracepoint for short writes
  sched: add new fields to task_struct
  mm: support write throttling for async buffered writes
  iomap: User throttling for async buffered writes.
  io_uring: support write throttling for async buffered writes
  xfs: enable async buffered write support

 fs/inode.c                      | 127 +++++++++++++++++++++----------
 fs/io_uring.c                   | 131 +++++++++++++++++++++++++++++---
 fs/iomap/buffered-io.c          |  63 +++++++++++++--
 fs/read_write.c                 |   3 +-
 fs/xfs/xfs_file.c               |  51 +++++++++++--
 fs/xfs/xfs_iomap.c              |  33 +++++++-
 include/linux/fs.h              |  14 ++++
 include/linux/pagemap.h         |   1 +
 include/linux/sched.h           |   3 +
 include/linux/writeback.h       |   1 +
 include/trace/events/io_uring.h |  25 ++++++
 kernel/fork.c                   |   1 +
 mm/filemap.c                    |   3 +
 mm/page-writeback.c             |  54 +++++++++----
 14 files changed, 424 insertions(+), 86 deletions(-)


base-commit: af2d861d4cd2a4da5137f795ee3509e6f944a25b
--=20
2.30.2

