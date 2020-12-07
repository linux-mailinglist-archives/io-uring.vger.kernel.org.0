Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DA22D1D1D
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 23:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgLGWQt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 17:16:49 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38478 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727704AbgLGWQs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 17:16:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7MB5vC133145;
        Mon, 7 Dec 2020 22:16:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=gSK0USgX8yoVRle2byyzlf7k21P01ChDqSUrdTPAv30=;
 b=K1zMMDXQnDvK2C5hNa+XbR/wL+5G96iNz9uus6CvZZMPx9ijL6OPYn7b0cjiWz27l+Vn
 xiJNPYfp/MaVbS/neEsOZho8MEYlZRvO/p3ld9dhjsB54RAoxeqLqgO1nzJYV7DeAH4Z
 4WNFJsSbmHleOzfjiiyvNcF8Q0AMKDwyQVsMQQMi/38MbM0LNsD2jdFDf3l1KTcwYJPj
 RHSKNXYOgF9UMsGxPC85UThIp+RfWRHlo5qAzu6Vp3mgYXb5RSQLNzxZCuzcpGka1+5L
 k6of2vkRn7KTZpMcb0zLWvDxhf1x3rMh8QFKRlMPYORGuzlk7YiHgDXJefZtpBjGFSlk /w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3581mqqv5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 22:16:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7MAbsg049065;
        Mon, 7 Dec 2020 22:16:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 358kyrxk0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 22:16:04 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B7MG3R8006684;
        Mon, 7 Dec 2020 22:16:04 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 14:16:03 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v2 00/13] io_uring: buffer registration enhancements
Date:   Mon,  7 Dec 2020 14:15:39 -0800
Message-Id: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=796 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=805
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070145
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

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

I have kept the original patchset unchanged for the most part to
facilitate reviewing and so this set adds a number of additional patches
mostly making file/buffer handling more unified.

Patch 1-2 modularize existing buffer registration code.

Patch 3-7 generalize fixed_file functionality to fixed_rsrc.

Patch 8 applies fixed_rsrc functionality for fixed buffers support.

Patch 9-10 generalize files_update functionality to rsrc_update.

Patch 11 implements buffer registration update, and introduces
IORING_REGISTER_BUFFERS_UPDATE and IORING_OP_BUFFERS_UPDATE, consistent
with file registration update.

Patch 12 generalizes fixed resource allocation 

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

- Haven't addressed Pavel's comment yet on using a single opcode for
files/buffers update, pending Jen's opinion.  Could we encode the resource
type into the sqe (e.g. rw_flags)?

Bijan Mottahedeh (13):
  io_uring: modularize io_sqe_buffer_register
  io_uring: modularize io_sqe_buffers_register
  io_uring: generalize fixed file functionality
  io_uring: rename fixed_file variables to fixed_rsrc
  io_uring: separate ref_list from fixed_rsrc_data
  io_uring: generalize fixed_file_ref_node functionality
  io_uring: add rsrc_ref locking routines
  io_uring: implement fixed buffers registration similar to fixed files
  io_uring: create common fixed_rsrc_ref_node handling routines
  io_uring: generalize files_update functionlity to rsrc_update
  io_uring: support buffer registration updates
  io_uring: create common fixed_rsrc_data allocation routines.
  io_uring: support buffer registration sharing

 fs/io_uring.c                 | 1004 +++++++++++++++++++++++++++++------------
 include/uapi/linux/io_uring.h |   12 +-
 2 files changed, 732 insertions(+), 284 deletions(-)

-- 
1.8.3.1

