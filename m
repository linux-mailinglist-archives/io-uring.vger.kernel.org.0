Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A04C219C935
	for <lists+io-uring@lfdr.de>; Thu,  2 Apr 2020 20:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389244AbgDBSyw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Apr 2020 14:54:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39228 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388843AbgDBSyw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Apr 2020 14:54:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032Ico8I137722;
        Thu, 2 Apr 2020 18:54:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=eFiADQqafEeuNoI+7TDE1TB2PKDkh55Qp9S2xGkihHs=;
 b=yUpWKsGqVI6WRhSTm7JoX01505y2FC2PUQrB/iN/SiFmod76F+LAdbzNBMeE9tRF7/TV
 uZwoPP7iTACvfouU363zyeWmkeBbXqO+4JAbKGQyxD1QOzC0UmdvXHm3dFC+M4XiPRKK
 pgazKVhca59rfiC/AhZt0SafYR+eY/L9HTK5g5HfRnyUcLKgWoNZQjMWk507VNUdqbdc
 GSBoyAe+5JEmoo1wDjipaVxWnp04lwN03R8Gfybyl4dVBAQ63zC8Ht55K+k4t0LxnFVv
 ISP2hdu04FsEyBnfuU1eRwIm1SKuRVoRqOCU4PYQrzlGFidpoeRlFQWXl8bHt+m05FK6 vA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 303aqhwrc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 18:54:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032IcIPe069925;
        Thu, 2 Apr 2020 18:54:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 302ga2xgj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 18:54:49 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 032Iskwv011982;
        Thu, 2 Apr 2020 18:54:46 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 11:54:46 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [RFC 0/1] io_uring: process requests completed with -EAGAIN on poll list
Date:   Thu,  2 Apr 2020 11:54:24 -0700
Message-Id: <1585853665-8705-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004020141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020141
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Running fio polled tests with a large number of jobs ends up with stuck
polling threads.  I think this because of polling for requests that have
completed with -EAGAIN.

Running with the RFC applied, and with sufficiently large nvme timeout
values, the fio tests complete.

The RFC creates a retry list similar to the done list.  I'm not sure
if that's the best approach and whether there may be ordering issues
processing the two lists but I haven't seen any problems.

Bijan Mottahedeh (1):
  io_uring: process requests completed with -EAGAIN on poll list

 fs/io_uring.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

-- 
1.8.3.1

