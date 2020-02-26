Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8F816F9A6
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 09:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgBZIis (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 03:38:48 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57220 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgBZIis (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Feb 2020 03:38:48 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q8ci7S159127;
        Wed, 26 Feb 2020 08:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=QPaeCoKjz0Hj1DSh69y7fdDukch0dAgnsq4X9qRIdnk=;
 b=k1gJKmYZfkL8zdhTMAd3ZlyQPX33X2vUUCTVeS2anrA+vibpba4e2to7JXK0vgrNELs3
 sa279arv+/E+rUXvro8f/zTCyP3ptwaBykfyyhda2XdMfFhVcZzPlNmvc/jFKodMoe4G
 1s9N+5JGIJRxbZOBqJd5eqpIuOtKUD0ZSGwkm31WxBq2QX968TmaHJGRBc9g89n/Jv/p
 uYl2M4NrbhwA0KtUUmnyCFT89p0SpMMR/4nLf5Hvn4sT/RqpZCGqbEA3Tqf2qXONc7cQ
 ZhBmiFf7Yz2tW0GGAMrBNf7NWHK6QHXI18o+ajUPZBSQq1tSUYGw7nBAlk2+FHumD3Gq mA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2ydct31ws9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 08:38:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q8cEiP091708;
        Wed, 26 Feb 2020 08:38:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ydcs1hs08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 08:38:44 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01Q8cfVl028122;
        Wed, 26 Feb 2020 08:38:41 GMT
Received: from localhost.localdomain (/114.88.246.185)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 00:38:40 -0800
From:   Bob Liu <bob.liu@oracle.com>
To:     linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, martin.petersen@oracle.com,
        linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com,
        io-uring@vger.kernel.org, Bob Liu <bob.liu@oracle.com>
Subject: [RFC PATCH 0/4] userspace PI passthrough via io_uring
Date:   Wed, 26 Feb 2020 16:37:15 +0800
Message-Id: <20200226083719.4389-1-bob.liu@oracle.com>
X-Mailer: git-send-email 2.9.5
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=550 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=620 mlxscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260065
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This RFC provides a rough implementation of a mechanism to allow
userspace to attach protection information (e.g. T10 DIF) data to a
disk write and to receive the information alongside a disk read.
The interface is an extension to the io_uring interface:
two new commands (IORING_OP_READV{WRITEV}_PI) are provided.
The last struct iovec in the arg list is interpreted to point to a buffer
containing the the PI data.

Patch #1 add two new commands to io_uring.
Patch #2 introduces two helper funcs in bio-integrity.
Patch #3 implement the PI passthrough in direct-io of block-dev.
(Similar extensions may add to fs/direct-io.c and fs/maps/directio.c)
Patch #4 add io_uring use space test case to liburing.

Welcome any feedbacks.
Thanks!

There was attempt before[1], but was based on AIO at that time.
[1] https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg27537.html

Bob Liu (3):
  io_uring: add IORING_OP_READ{WRITE}V_PI cmd
  bio-integrity: introduce two funcs handle protect information
  block_dev: support protect information passthrough

 block/bio-integrity.c         | 77 +++++++++++++++++++++++++++++++++++++++++++
 fs/block_dev.c                | 17 ++++++++++
 fs/io_uring.c                 | 12 +++++++
 include/linux/bio.h           | 14 ++++++++
 include/linux/fs.h            |  1 +
 include/uapi/linux/io_uring.h |  2 ++
 6 files changed, 123 insertions(+)

-- 
2.9.5

