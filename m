Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053F129678E
	for <lists+io-uring@lfdr.de>; Fri, 23 Oct 2020 01:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373278AbgJVXOS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 19:14:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40640 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373209AbgJVXOS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 19:14:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MNBk5m125333;
        Thu, 22 Oct 2020 23:14:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=eokDqNH9A7N9YriPOWvphXpHrme1CSSlUrQcDVgFQvo=;
 b=MinEqoFt1ejTsL/oCDMJZgfng3a4F1/c0GmScLU1jxB1hVeleZ6i2Jas92mTvGbPoT8I
 bDI3j1T+vYS+4r9Kxj6tKdYGJaTTTTARQ0dCFarjX9d0VGY7LHDfIyjdR/tNdKuVqG4i
 8RHYpx7Joab67hphmU4nuVoEp8mwr9HfOftUThtObgEE/5UU73PHmbsLVzve+EGX6/hr
 9Gg5ameYQicnNIr/+KRdJEjy/8I8seCVataeXrRQNAQ0d+mamOI9G3JwYKesGC+PMIE1
 2AUPOpq79XhFlLbt0l3fM05ysUKsfpPflr/ZnsqLZic9Ticred9rg61h2yMllorU6Pww /Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 349jrq0pc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 23:14:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MN5jWO095219;
        Thu, 22 Oct 2020 23:14:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 348ah1dchk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 23:14:15 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09MNEFlK023344;
        Thu, 22 Oct 2020 23:14:15 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 16:14:15 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [RFC 0/8] io_uring: buffer registration enhancements
Date:   Thu, 22 Oct 2020 16:13:55 -0700
Message-Id: <1603408443-51303-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=707
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=718 mlxscore=0 spamscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220148
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

This RFC implements a set of enhancements to buffer registration consistent
with existing file registration functionality:

- buffer registration updates		IORING_REGISTER_BUFFERS_UPDATE
					IORING_OP_BUFFERS_UPDATE

- readv/writev with fixed buffers	IOSQE_FIXED_BUFFER

- buffer registration sharing		IORING_SETUP_SHARE_BUF
					IORING_SETUP_ATTACH_BUF

Patches 1,2 modularize existing buffer registration code.

Patch 3 generalizes fixed_file functionality to fixed_rsrc.

Patch 4 applies fixed_rsrc functionality for fixed buffers support.

Patch 5 generalizes files_update functionality to rsrc_update.

Patch 6 implements buffer registration update, and introduces
IORING_REGISTER_BUFFERS_UPDATE and IORING_OP_BUFFERS_UPDATE, consistent
with file registration update.

Patch 7 implements readv/writev support with fixed buffers, and introduces
IOSQE_FIXED_BUFFER, consistent with fixed files.

Patch 8 implements buffer sharing among multiple rings; it works as
follows based on previous conversations:

- A new ring, A,  is setup. Since no buffers have been registered, the
  registered buffer state is an empty set, Z. That's different from the
  NULL state in current implementation.

- Ring B is setup, attaching to Ring A. It's also attaching to it's
  buffer registrations, now we have two references to the same empty
  set, Z.

- Ring A registers buffers into set Z, which is no longer empty.

- Ring B sees this immediately, since it's already sharing that set.

TBD

- I think I have to add IORING_UNREGISTER_BUFFERS to
  io_register_op_must_quiesce() but wanted to confirm.

- IORING_OP_SHUTDOWN has been removed but still in liburing, not sure why.
  I wanted to verify before removing that functionality.

I have used liburing file-{register,update} tests as models for
buffer-{register,update}, and it seems to work ok.

Bijan Mottahedeh (8):
  io_uring: modularize io_sqe_buffer_register
  io_uring: modularize io_sqe_buffers_register
  io_uring: generalize fixed file functionality
  io_uring: implement fixed buffers registration similar to fixed files
  io_uring: generalize files_update functionlity to rsrc_update
  io_uring: support buffer registration updates
  io_uring: support readv/writev with fixed buffers
  io_uring: support buffer registration sharing

 fs/io_uring.c                 | 1021 ++++++++++++++++++++++++++++++++---------
 include/uapi/linux/io_uring.h |   15 +-
 2 files changed, 807 insertions(+), 229 deletions(-)

-- 
1.8.3.1

