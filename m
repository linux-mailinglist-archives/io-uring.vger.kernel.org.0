Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FC32B124D
	for <lists+io-uring@lfdr.de>; Fri, 13 Nov 2020 00:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgKLXBL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Nov 2020 18:01:11 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53188 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgKLXBL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Nov 2020 18:01:11 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACMtMce078843;
        Thu, 12 Nov 2020 23:01:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=2Tsw6MZTEQGZHSoTyop5+6M9Zk0JI9qaXJ+b2eeOzeM=;
 b=yV9dto490l/XiqJ64xVYZv2IWHiRP25+WhznKxu2a1gSjzFzyRurW+YsaqCa1eTvvWlR
 tuEsnXdcz+o2cP1/YMJQ6e5YFuEd4jY84P8h8kG65juo18Uzq93yY0CXmWBZCmCDGRhi
 BHeyVPGLC6+ZzGL66sef0HMmJaggQKPFL5ABoysXkAVhluOl3umaUsl6fnUWEOAxYe82
 SMqCWapdaGB4wAWWyqsIWgFUgYRvDhTr4E3nKSdT+6G2uMjx624e7aj2iqZFqCvt3Sfu
 MTKAMOfYEXkurfogGfcr85Hxk3Aywko6HoBcGL+zXaJZbAn24RJqPh3lNehDKORq0bhp WA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34p72ex9ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 23:01:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACMoIem021736;
        Thu, 12 Nov 2020 23:01:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34rtksjcyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 23:01:08 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ACN174N015706;
        Thu, 12 Nov 2020 23:01:07 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 15:01:07 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 0/8] io_uring: buffer registration enhancements
Date:   Thu, 12 Nov 2020 15:00:34 -0800
Message-Id: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=1 bulkscore=0 malwarescore=0 mlxlogscore=682 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=697 mlxscore=0
 malwarescore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120129
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset is the follow-on to my previous RFC which implements a
set of enhancements to buffer registration consistent with existing file
registration functionality:

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

Patch 8 implements buffer sharing among multiple rings; it works as follows:

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

I have used liburing file-{register,update} tests as models for
buffer-{register,update,share}, tests and they run ok.

The liburing test suite fails for "self" with/without this patchset.

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

