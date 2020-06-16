Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F168B1FC25F
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 01:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgFPXgV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 19:36:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48580 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgFPXgU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 19:36:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05GNVkjS132636;
        Tue, 16 Jun 2020 23:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=tm3AvGmoVJE4TYkBNYqNhKgQB2CAZGe3uf8z43jsHZk=;
 b=hg7Nc1g3B5H3gDqHHAPaLq0yqLYN90CKbtko2aveTLVnlj7zZn53kr+7Aj0GmyjydhNp
 Mw+8xVSR6rqe/6yWNXHvopER8x6VSXHKIKnZbkgdxQf7Ao8H2WrfHpZa3pwItV/bUCfn
 WkhTYlAKq3Zo1gWaWdpbIuwT5lLwcB13pyESW6xSSQO1Bbo7HziZgoAtV5Ec18Uo81ZI
 exl9YAPwwr1YgXV0gsOB7LIgVxx1AM/Hwe/TymGBZc/QaxtBuF1+IwlBiXidg8sS/o/T
 6IuhA5/bYsG2fKquaWcIJvjcIxFT6IfeqUO0zyZwSOSziFyAkd6WhgzRUV0WMYfJ3wNs 9Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31q63y8afq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 23:36:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05GNT3o5193498;
        Tue, 16 Jun 2020 23:36:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31q66m863r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 23:36:16 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05GNaGwf019772;
        Tue, 16 Jun 2020 23:36:16 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jun 2020 16:36:16 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 0/4] io_uring: report locked memory usage
Date:   Tue, 16 Jun 2020 16:36:06 -0700
Message-Id: <1592350570-24396-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9654 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=892
 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9654 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 impostorscore=0
 mlxlogscore=930 priorityscore=1501 adultscore=0 malwarescore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 bulkscore=0 suspectscore=1
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160162
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch set adds support for reporting of locked memory usage.

Patches 1 and 2 are prep patches to facilitate the reporting.

Patch 3 reports all locked memory as pinned.

Patch 4 reports ring memory as locked and registered memory as pinned.
This seems more appropriate but kept it a separate patch in case it
should be dropped.

Bijan Mottahedeh (4):
  io_uring: add wrappers for memory accounting
  io_uring: rename ctx->account_mem field
  io_uring: report pinned memory usage
  io_uring: separate reporting of ring pages from registered pages

 fs/io_uring.c | 93 ++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 66 insertions(+), 27 deletions(-)

-- 
1.8.3.1

