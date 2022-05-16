Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A77528AD7
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 18:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343854AbiEPQsn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 12:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343842AbiEPQsm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 12:48:42 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38F73C73A
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:37 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GFP7h8030125
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=lG16viWiL0fgqGwpPbfMTmF+zs4wNm89FAHhNuXwt9I=;
 b=jtsVzelj0G3GOjVBTz0uWkWszgSVWDwkNSVorSOspgU+2v/IUA6HuktkyMCFhLV4CKwE
 7+KUTncFwNwrjgDyYv8LrEUinmUxeFmdyPxzxHiqqs0rksv+jXvIfJUF/V7zFW87EuQm
 41W9fSwquC1HSFYkJmej44sjcs38ocaEm5g= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g2a5yakea-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:36 -0700
Received: from twshared6696.05.ash7.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 16 May 2022 09:48:34 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 37B3EF146DCF; Mon, 16 May 2022 09:48:25 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v2 00/16] io-uring/xfs: support async buffered writes
Date:   Mon, 16 May 2022 09:47:02 -0700
Message-ID: <20220516164718.2419891-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: BMdY25sQrPZubktRSE4gqx2VCL39E_rI
X-Proofpoint-GUID: BMdY25sQrPZubktRSE4gqx2VCL39E_rI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

  Split of a _balance_dirty_pages() function that tells wether to sleep o=
r not.
  The function is called by the async buffered writes in iomap_write_iter=
() to
  determine if write throttling is required or not. In case write throttl=
ing is
  necessary, return -EAGAIN to the caller in io-uring. The request will t=
hen be
  handled in io-uring io-worker.
 =20
  The existing function balance_dirty_pages() will call _balance_dirty_pa=
ges().

Enable async buffered write support in xfs
  Patch 18: xfs: enable async buffered write support
    This enables the flag that enables async buffered writes for xfs.


Testing:
  This patch has been tested with xfstests and fio.


Changes:
  V2:
  - Remove atomic allocation
  - Use direct write in xfs_buffered_write_iomap_begin()
  - Use xfs_ilock_for_iomap() in xfs_buffered_write_iomap_begin()
  - Remove no_wait check at the end of xfs_buffered_write_iomap_begin() f=
or
    the COW path.
  - Pass xfs_inode pointer to xfs_ilock_iocb and rename function to
    xfs_lock_xfs_inode
  - Replace exisitng uses of xfs_ilock_iocb with xfs_ilock_xfs_inode
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
   =20


Stefan Roesch (16):
  block: add check for async buffered writes to generic_write_checks
  iomap: add iomap_page_create_gfp to allocate iomap_pages
  iomap: use iomap_page_create_gfp() in __iomap_write_begin
  iomap: add async buffered write support
  xfs: add iomap async buffered write support
  fs: split off need_remove_file_privs() do_remove_file_privs()
  fs: split off need_file_update_time and do_file_update_time
  fs: add pending file update time flag.
  xfs: enable async write file modification handling.
  xfs: add async buffered write support
  io_uring: add support for async buffered writes
  mm: factor out _balance_dirty_pages() from balance_dirty_pages()
  mm: add balance_dirty_pages_ratelimited_flags() function
  iomap: use balance_dirty_pages_ratelimited_flags in iomap_write_iter
  io_uring: add tracepoint for short writes
  xfs: enable async buffered write support

 fs/inode.c                      | 146 +++++++---
 fs/io_uring.c                   |  32 +-
 fs/iomap/buffered-io.c          |  67 ++++-
 fs/read_write.c                 |   3 +-
 fs/xfs/xfs_file.c               |  36 ++-
 fs/xfs/xfs_iomap.c              |  14 +-
 include/linux/fs.h              |   7 +
 include/linux/writeback.h       |   1 +
 include/trace/events/io_uring.h |  25 ++
 mm/page-writeback.c             | 500 +++++++++++++++++---------------
 10 files changed, 520 insertions(+), 311 deletions(-)


base-commit: 0cdd776ec92c0fec768c7079331804d3e52d4b27
--=20
2.30.2

