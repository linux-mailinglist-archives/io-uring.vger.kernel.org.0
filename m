Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D382F3DEA
	for <lists+io-uring@lfdr.de>; Wed, 13 Jan 2021 01:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730693AbhALVtL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jan 2021 16:49:11 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48282 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391153AbhALVgL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jan 2021 16:36:11 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLXgB8114997;
        Tue, 12 Jan 2021 21:35:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=6R8odMkKzcQPn88MEd9F5p2AfPjCKUEAW3f2j2IUZaY=;
 b=xMTMWtUUbeJBMTyH71CajF9ya4LskSx7MU4JvyqA9G1kGmiU1U1W3zFaWiScQfHtTlLu
 hNd8DT2YzOg7BCx6Ruvv7Ujt97R1oAF1crbW7bJ2eK8duyA0YlKJL2B91KCgWRKP1C8s
 8C07/u4+vx795MaXWn2PY2b+25IHzQhgwGawrAheGvyheiHZbVxiwZSYqPBZATq4Kc3S
 ePTwSLVTbvOxwSWVgWpJDAvtBGXr+i/EuqgVehtoQeUFsM0i668d31B9W6jWITl+kyVy
 a6inxHOGhLeTZxKTqV/iiBXtumLh1/sMtpQhBWkQjbHu1Hg70xmT6pZcF6Va6AZ1NWzx vw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 360kg1rk5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:35:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLGUg3174462;
        Tue, 12 Jan 2021 21:33:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 360kf665tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:33:27 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10CLXPCq011338;
        Tue, 12 Jan 2021 21:33:26 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 13:33:25 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v5 00/13] io_uring: buffer registration enhancements
Date:   Tue, 12 Jan 2021 13:33:00 -0800
Message-Id: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=929 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=921 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120128
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

v5:

- call io_get_fixed_rsrc_ref for buffers
- make percpu_ref_release names consistent
- rebase on for-5.12/io_uring

v4:

- address v3 comments (TBD REGISTER_BUFFERS)
- rebase

v3:

- batch file->rsrc renames into a signle patch when possible
- fix other review changes from v2
- fix checkpatch warnings

v2:

- drop readv/writev with fixed buffers patch
- handle ref_nodes both both files/buffers with a single ref_list
- make file/buffer handling more unified

This patchset implements a set of enhancements to buffer registration
consistent with existing file registration functionality:

- buffer registration updates		IORING_REGISTER_BUFFERS_UPDATE
					IORING_OP_BUFFERS_UPDATE

- buffer registration sharing		IORING_SETUP_SHARE_BUF
					IORING_SETUP_ATTACH_BUF

Patch 1-5 generalize fixed_file functionality to fixed_rsrc.

Patch 6 applies fixed_rsrc functionality for fixed buffers support.

Patch 7-8 generalize files_update functionality to rsrc_update.

Patch 9 implements buffer registration update, and introduces
IORING_REGISTER_BUFFERS_UPDATE and IORING_OP_BUFFERS_UPDATE, consistent
with file registration update.

Patch 10 generalizes fixed resource allocation 

Patch 11 renames percpu release routines for consistency

Patch 12 calls io_get_fixed_rsrc_ref() for buffers as well as files

Patch 13 implements buffer sharing among multiple rings; it works as follows:

- A new ring, A,  is setup. Since no buffers have been registered, the
  registered buffer state is an empty set, Z. That's different from the
  NULL state in current implementation.

- Ring B is setup, attaching to Ring A. It's also attaching to it's
  buffer registrations, now we have two references to the same empty
  set, Z.

- Ring A registers buffers into set Z, which is no longer empty.

- Ring B sees this immediately, since it's already sharing that set.

Testing

I have used liburing file-{register,update} tests as models for
buffer-{register,update,share}, tests and they run ok.

TBD

- Need a patch from Pavel to address a race between fixed IO from async
context and buffer unregister, or force buffer registration ops to do
full quiesce.

- Need to still address Pavel's comments about unkillable deadlocks. It
seems that we should no long hange unkillably in io_rsrc_ref_quiesce()
because of Pavel's changes.

- I tried to use a single opcode for files/buffers but ran into an
issue since work_flags is different for files/buffers.  This should
be ok for the most part since req->work.flags is ultimately examined;
however, there are place where io_op_defs[opcode].work_flags is examined
directly, and I wasn't sure what would the best way to handle that.

Bijan Mottahedeh (13):
  io_uring: rename file related variables to rsrc
  io_uring: generalize io_queue_rsrc_removal
  io_uring: separate ref_list from fixed_rsrc_data
  io_uring: split alloc_fixed_file_ref_node
  io_uring: add rsrc_ref locking routines
  io_uring: implement fixed buffers registration similar to fixed files
  io_uring: create common fixed_rsrc_ref_node handling routines
  io_uring: generalize files_update functionlity to rsrc_update
  io_uring: support buffer registration updates
  io_uring: create common fixed_rsrc_data allocation routines
  io_uring: make percpu_ref_release names consistent
  io_uring: call io_get_fixed_rsrc_ref for buffers
  io_uring: support buffer registration sharing

 fs/io_uring.c                 | 803 ++++++++++++++++++++++++++++++++----------
 include/uapi/linux/io_uring.h |  13 +-
 2 files changed, 626 insertions(+), 190 deletions(-)

-- 
1.8.3.1

