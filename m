Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455194B58D4
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 18:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344316AbiBNRo2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 12:44:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357201AbiBNRo1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 12:44:27 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364F165481
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:19 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21ECHTrW024115
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=m7BP5GqmDIx7PKgEuSQ5KsLYXYPqHLneIHsLUxw8VqM=;
 b=q7iAOXwnhAV8vL1tvl8A+lof5fKTNAVeDvmM6GjoOo/r5iw1Fy936NzNF3esAJRYjxg3
 Cd6pNjYKzKXDnQSQZAZCpt3eHdiIRhzFqVPYixUHs9l2iv6+Kk9v/9VXttpapId86UmT
 7PbCZaKCWvU/BntOURXgBiJ3zFJDqRNHYyo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e7py4j416-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:44:18 -0800
Received: from twshared0654.04.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Feb 2022 09:44:18 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 8C557ABBD0F3; Mon, 14 Feb 2022 09:44:09 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 00/14] Support sync buffered writes for io-uring
Date:   Mon, 14 Feb 2022 09:43:49 -0800
Message-ID: <20220214174403.4147994-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: tYt-hoUBRkzeHyLaESlI6dWT4VRlEZ5D
X-Proofpoint-GUID: tYt-hoUBRkzeHyLaESlI6dWT4VRlEZ5D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 clxscore=1015 spamscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140105
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
  Patch 3: mm: add noio support in filemap_get_pages
    This allows to allocate pages with noio, if a page for async
    buffered writes is not yet loaded in the page cache.
   =20
  Patch 4: mm: Add support for async buffered writes
    For async buffered writes allocate pages without blocking on the
    allocation.

  Patch 5: fs: split off __alloc_page_buffers function
    Split off __alloc_page_buffers() function with new gfp_t parameter.

  Patch 6: fs: split off __create_empty_buffers function
    Split off __create_empty_buffers() function with new gfp_t parameter.

  Patch 7: fs: Add aop_flags parameter to create_page_buffers()
    Add aop_flags to create_page_buffers() function. Use atomic allocatio=
n
    for async buffered writes.

  Patch 8: fs: add support for async buffered writes
    Return -EAGAIN instead of -ENOMEM for async buffered writes. This
    will cause the write request to be processed by an io worker.

  Patch 9: io_uring: add support for async buffered writes
    This enables the async buffered writes for block devices in io_uring.
    Buffered writes are enabled for blocks that are already in the page
    cache or can be acquired with noio.

  Patch 10: io_uring: Add tracepoint for short writes

Support for write throttling of async buffered writes:
  Patch 11: sched: add new fields to task_struct
    Add two new fields to the task_struct. These fields store the
    deadline after which writes are no longer throttled.

  Patch 12: mm: support write throttling for async buffered writes
    This changes the balance_dirty_pages function to take an additonal
    parameter. When nowait is specified the write throttling code no
    longer waits synchronously for the deadline to expire. Instead
    it sets the fields in task_struct. Once the deadline expires the
    fields are reset.
   =20
  Patch 13: io_uring: support write throttling for async buffered writes
    Adds support to io_uring for write throttling. When the writes
    are throttled, the write requests are added to the pending io list.
    Once the write throttling deadline expires, the writes are submitted.
   =20
Enable async buffered write support
  Patch 14: fs: add flag to support async buffered writes
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




Stefan Roesch (14):
  fs: Add flags parameter to __block_write_begin_int
  mm: Introduce do_generic_perform_write
  mm: add noio support in filemap_get_pages
  mm: Add support for async buffered writes
  fs: split off __alloc_page_buffers function
  fs: split off __create_empty_buffers function
  fs: Add aop_flags parameter to create_page_buffers()
  fs: add support for async buffered writes
  io_uring: add support for async buffered writes
  io_uring: Add tracepoint for short writes
  sched: add new fields to task_struct
  mm: support write throttling for async buffered writes
  io_uring: support write throttling for async buffered writes
  block: enable async buffered writes for block devices.

 block/fops.c                    |   5 +-
 fs/buffer.c                     | 103 ++++++++++++++++---------
 fs/internal.h                   |   3 +-
 fs/io_uring.c                   | 130 +++++++++++++++++++++++++++++---
 fs/iomap/buffered-io.c          |   4 +-
 fs/read_write.c                 |   3 +-
 include/linux/fs.h              |   4 +
 include/linux/sched.h           |   3 +
 include/linux/writeback.h       |   1 +
 include/trace/events/io_uring.h |  25 ++++++
 kernel/fork.c                   |   1 +
 mm/filemap.c                    |  34 +++++++--
 mm/folio-compat.c               |   4 +
 mm/page-writeback.c             |  54 +++++++++----
 14 files changed, 298 insertions(+), 76 deletions(-)


base-commit: f1baf68e1383f6ed93eb9cff2866d46562607a43
--=20
2.30.2

