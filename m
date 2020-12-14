Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095CD2DA25F
	for <lists+io-uring@lfdr.de>; Mon, 14 Dec 2020 22:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387738AbgLNVKF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 16:10:05 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40700 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503638AbgLNVKD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 16:10:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEKsDjD144059;
        Mon, 14 Dec 2020 21:09:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=ZWdRj2AV+UvW5kp+pTaO/9sR5udt2UbOXWkw3ShjHtY=;
 b=AmbEBYOXNU4CAyxDWGUG71uokOyZbf+0Vyi+BZXKtwMHWD6SkGGSTvLQcWA3LaquZ2iq
 te5cqyBaVoiWkR4Exg2EcJpspDoKM6f7tQH+Hi50DKiBZda0D4VkZAYbZ2Z+9IOxUNJc
 6Oq2VWxtWTypSJdKQrb7s5uZ02qTJxox9kU24UhRVXCb2+aJPR6w//FJmYovBaOY1/D0
 IBflRB79rKvnFgSI8c8UBYDiv7NGCo1jJ2LpJtJwSki+TsASg7SiZCDAVrkgjketYg3r
 NkKBUbMBuUwaBTGNAZThvJxXQrnAZZ5FgOTR8TreOB7gWiI4swdUmecQqVIZYsj1xojT Rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35cn9r7h3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 21:09:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEKt51W135896;
        Mon, 14 Dec 2020 21:09:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 35e6jq0pme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 21:09:20 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BEL9J0k027030;
        Mon, 14 Dec 2020 21:09:19 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 13:09:19 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [PATCH 0/5] liburing: buffer registration enhancements
Date:   Mon, 14 Dec 2020 13:09:06 -0800
Message-Id: <1607980151-18816-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140140
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset is the liburing changes for buffer registration enhancements.

Patch 1-2 implement the actual liburing changes

Patch 3-4 are the buffer-registration/update test cases, copied from
          corresponding file tests and adapted for buffers

Patch 5   is the buffer-sharing test

Bijan Mottahedeh (5):
  liburing: support buffer registration updates
  liburing: support buffer registration sharing
  test/buffer-register: add buffer registration test
  test/buffer-update: add buffer registration update test
  test/buffer-share: add buffer registration sharing test

 .gitignore                      |    3 +
 src/include/liburing.h          |   12 +
 src/include/liburing/io_uring.h |   12 +-
 src/register.c                  |   27 +-
 test/Makefile                   |    7 +
 test/buffer-register.c          |  701 +++++++++++++++++++++++
 test/buffer-share.c             | 1184 +++++++++++++++++++++++++++++++++++++++
 test/buffer-update.c            |  165 ++++++
 8 files changed, 2108 insertions(+), 3 deletions(-)
 create mode 100644 test/buffer-register.c
 create mode 100644 test/buffer-share.c
 create mode 100644 test/buffer-update.c

-- 
1.8.3.1

