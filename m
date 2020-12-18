Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454D22DE8C3
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 19:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgLRSIW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 13:08:22 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:41134 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgLRSIW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 13:08:22 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII3nCB111102;
        Fri, 18 Dec 2020 18:07:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=pXrd5Z+UOITUfTTxTRplLfB7O2/7IjyUiPB4BrWzBks=;
 b=TwDUX839XA8BA3YkD6RBIbd2uNYZZbReFmf4zczS+h0sRYrnZJTW1vYcrNmURouCTeTN
 NQmm1bm7a9egdLCCkkfHxY3Ufedk1mWMrURMIehq8/NYWlnl7iSbW04t33MbHbwP1aC+
 A8V+0i1wvTYf2rJ/+bb3z3qtqMvT2+BqaxIrWsN7jhbAKuyexHLm5m/fBAQp6fS6Cist
 TS/U5LrePx09v+Sfw0hFG4Ncro0EuR+v7j95GNSufDDDt1E6+1Iw22SQgybgt1cy3sYR
 AVEuXHO3NyJJVyjhwLIH0id58lngLiBVjSxMyqzbLLljKvtlret+FvSgdxFKdAvR4AnK Kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35ckcbuq8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Dec 2020 18:07:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII5Ol7117414;
        Fri, 18 Dec 2020 18:07:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35g3rgfawy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 18:07:38 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BII7b1Y015962;
        Fri, 18 Dec 2020 18:07:37 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Dec 2020 10:07:37 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v3 00/13] io_uring: buffer registration enhancements
Date:   Fri, 18 Dec 2020 10:07:15 -0800
Message-Id: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180124
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

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

- I tried to use a single opcode for files/buffers but ran into an
issue since work_flags is different for files/buffers.  This should
be ok for the most part since req->work.flags is ultimately examined;
however, there are place where io_op_defs[opcode].work_flags is examined
directly, and I wasn't sure what would the best way to handle that.

- Need to still address Pavel's comments about deadlocks. I figure
to send out the set anyway since this is a last patch and may even be
handled separately.

Bijan Mottahedeh (13):
  io_uring: modularize io_sqe_buffer_register
  io_uring: modularize io_sqe_buffers_register
  io_uring: rename file related variables to rsrc
  io_uring: generalize io_queue_rsrc_removal
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
 2 files changed, 735 insertions(+), 281 deletions(-)

-- 
1.8.3.1

