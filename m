Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB73A4BC0D2
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 20:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238665AbiBRT61 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 14:58:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238707AbiBRT6W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 14:58:22 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF9A26109
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:05 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 21IB6C0g018136
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=xSLuOeBPvZ/ONaKzCljuDfPXUA6PK81pXc78puK8xUM=;
 b=j+lPxpMQTHqsGvpRU8TUldF3FbRAOK++k7ZVzQJ1ASAU0GI5cCoxSPdBGfMZhxRb5MlB
 GejPO5BpKcS/T4+EkxvmkXb1+JSsXFSlQnkqvsu4OSzgWWkdclpKLys3HUuKSDwcdy6L
 VGgXHNS1lLp3uYtcrR1lBk8pG1VVnLNjeCM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3e9e7xd4ss-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 11:58:04 -0800
Received: from twshared6457.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 11:58:02 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 8708BAEB65FD; Fri, 18 Feb 2022 11:57:50 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 00/13] Support sync buffered writes for io-uring
Date:   Fri, 18 Feb 2022 11:57:26 -0800
Message-ID: <20220218195739.585044-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: WrJFaFFzIavzNzsH5RyCFcAvEqt9enqF
X-Proofpoint-GUID: WrJFaFFzIavzNzsH5RyCFcAvEqt9enqF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_08,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 mlxscore=0 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180121
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch series adds support for async buffered writes. Currently
io-uring only supports buffered writes in the slow path, by processing
them in the io workers. With this patch series it is now possible to
support buffered writes in the fast path. To be able to use the fast
path the required pages must be in the page cache or they can be loaded
with noio. Otherwise they still get punted to the slow path.

If a buffered write request requires more than one page, it is possible
that only part of the request can use the fast path, the resst will be
completed by the io workers.

Support for async buffered writes:

  Patch 1: fs: Add flags parameter to __block_write_begin_int
    Add a flag parameter to the function __block_write_begin_int
    to allow specifying a nowait parameter.
   =20
  Patch 2: mm: Introduce do_generic_perform_write
    Introduce a new do_generic_perform_write function. The function
    is split off from the existing generic_perform_write() function.
    It allows to specify an additional flag parameter. This parameter
    is used to specify the nowait flag.
   =20
  Patch 3: mm: Add support for async buffered writes
    For async buffered writes allocate pages without blocking on the
    allocation.

  Patch 4: fs: split off __alloc_page_buffers function
    Split off __alloc_page_buffers() function with new gfp_t parameter.

  Patch 5: fs: split off __create_empty_buffers function
    Split off __create_empty_buffers() function with new gfp_t parameter.

  Patch 6: fs: Add gfp_t parameter to create_page_buffers()
    Add gfp_t parameter to create_page_buffers() function. Use atomic
    allocation for async buffered writes.

  Patch 7: fs: add support for async buffered writes
    Return -EAGAIN instead of -ENOMEM for async buffered writes. This
    will cause the write request to be processed by an io worker.

  Patch 8: io_uring: add support for async buffered writes
    This enables the async buffered writes for block devices in io_uring.
    Buffered writes are enabled for blocks that are already in the page
    cache or can be acquired with noio.

  Patch 9: io_uring: Add tracepoint for short writes

Support for write throttling of async buffered writes:

  Patch 10: sched: add new fields to task_struct
    Add two new fields to the task_struct. These fields store the
    deadline after which writes are no longer throttled.

  Patch 11: mm: support write throttling for async buffered writes
    This changes the balance_dirty_pages function to take an additonal
    parameter. When nowait is specified the write throttling code no
    longer waits synchronously for the deadline to expire. Instead
    it sets the fields in task_struct. Once the deadline expires the
    fields are reset.
   =20
  Patch 12: io_uring: support write throttling for async buffered writes
    Adds support to io_uring for write throttling. When the writes
    are throttled, the write requests are added to the pending io list.
    Once the write throttling deadline expires, the writes are submitted.
   =20
Enable async buffered write support
  Patch 13: fs: add flag to support async buffered writes
    This sets the flags that enables async buffered writes for block
    devices.


Testing:
  This patch has been tested with xfstests and fio.


Peformance results:
  For fio the following results have been obtained with a queue depth of
  1 and 4k block size (runtime 600 secs):

                 sequential writes:
                 without patch                 with patch
  throughput:       329 Mib/s                    1032Mib/s
  iops:              82k                          264k
  slat (nsec)      2332                          3340=20
  clat (nsec)      9017                            60
                  =20
  CPU util%:         37%                          78%



                 random writes:
                 without patch                 with patch
  throughput:       307 Mib/s                    909Mib/s
  iops:              76k                         227k
  slat (nsec)      2419                         3780=20
  clat (nsec)      9934                           59

  CPU util%:         57%                          88%

For an io depth of 1, the new patch improves throughput by close to 3
times and also the latency is considerably reduced. To achieve the same
or better performance with the exisiting code an io depth of 4 is require=
d.

Especially for mixed workloads this is a considerable improvement.


Changes:
V2: - removed patch 3 from patch series 1
    - replaced parameter aop_flags with with gfp_t in create_page_buffers=
()
    - Moved gfp flags to callers of create_page_buffers()
    - Removed changing of FGP_NOWAIT in __filemap_get_folio() and moved g=
fp
      flags to caller of __filemap_get_folio()
    - Renamed AOP_FLAGS_NOWAIT to AOP_FLAG_NOWAIT



Stefan Roesch (13):
  fs: Add flags parameter to __block_write_begin_int
  mm: Introduce do_generic_perform_write
  mm: Add support for async buffered writes
  fs: split off __alloc_page_buffers function
  fs: split off __create_empty_buffers function
  fs: Add gfp_t parameter to create_page_buffers()
  fs: add support for async buffered writes
  io_uring: add support for async buffered writes
  io_uring: Add tracepoint for short writes
  sched: add new fields to task_struct
  mm: support write throttling for async buffered writes
  io_uring: support write throttling for async buffered writes
  block: enable async buffered writes for block devices.

 block/fops.c                    |   5 +-
 fs/buffer.c                     |  98 +++++++++++++++---------
 fs/internal.h                   |   3 +-
 fs/io_uring.c                   | 130 +++++++++++++++++++++++++++++---
 fs/iomap/buffered-io.c          |   4 +-
 fs/read_write.c                 |   3 +-
 include/linux/fs.h              |   4 +
 include/linux/sched.h           |   3 +
 include/linux/writeback.h       |   1 +
 include/trace/events/io_uring.h |  25 ++++++
 kernel/fork.c                   |   1 +
 mm/filemap.c                    |  23 ++++--
 mm/folio-compat.c               |  12 ++-
 mm/page-writeback.c             |  54 +++++++++----
 14 files changed, 289 insertions(+), 77 deletions(-)


base-commit: 9195e5e0adbb8a9a5ee9ef0f9dedf6340d827405
--=20
2.30.2

