Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13DE119DFD3
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2020 22:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbgDCUvl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Apr 2020 16:51:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33550 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729143AbgDCUvl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Apr 2020 16:51:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033KhY8P120755;
        Fri, 3 Apr 2020 20:51:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=rZWU3SxwRPRN5p10/p1OkeN8zgevVHptxMyInPfN7qI=;
 b=oaZ/YMzzOOdGpArhnfMn2DmfKCAkf7juOrxf2x28qRXp1iwmC+6BdWVBmSREj1IvN6/y
 CgpldPF8/Jwf/fhgYAQfRsJAEo3UylSo50kR9KFAXC9IqqX4tpi/iXkCtgG8RcjHTpPa
 P6GdKLBTUuJJLS2DfIGNTX7DSYflNIZ5tDS94kGL7Tfchc0cmPyz3w4qxEh51EYMJeYP
 RA06+nPhtPX3lsXhx4MKmrSzL+GNilFZkkiVjNnfPFrfQtsKdjlN6OaHf0ynzGvuOKQy
 ZqWgYND4tabFbAGaMbfRYcP5HnNXuXBGhAzZwW7t60JQwSUebkieJxMnwF7gHU0/TDgo ZA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 303yunnrs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 20:51:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033KhFGq100126;
        Fri, 3 Apr 2020 20:51:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 304sjtx7mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 20:51:39 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 033KpclM014388;
        Fri, 3 Apr 2020 20:51:38 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 13:51:38 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 0/1] io_uring: process requests completed with -EAGAIN on poll list
Date:   Fri,  3 Apr 2020 13:51:32 -0700
Message-Id: <1585947093-41691-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=1 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=1 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030165
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Running fio polled tests with a large number of jobs ends up with stuck
polling threads.  This likely because of polling for requests that have
completed with -EAGAIN.

Running with the patch applied, and with sufficiently large nvme timeout
values, the fio tests complete.

Bijan Mottahedeh (1):
  io_uring: process requests completed with -EAGAIN on poll list

 fs/io_uring.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

-- 
1.8.3.1

