Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BC51EEEE8
	for <lists+io-uring@lfdr.de>; Fri,  5 Jun 2020 03:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgFEBCE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Jun 2020 21:02:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39370 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbgFEBCE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Jun 2020 21:02:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0550vlAs047540;
        Fri, 5 Jun 2020 01:02:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=QFxnuQCesEo5yiEs1iUruqBbl+fbdkBHNWNBIbgzptE=;
 b=D6cKW2UhExjQQ/ZohApzeK+5rPQA0Y/r8uWm1GNnsrDwg9kwL+KRrkzrelSC2dw+NF/H
 ZtlQe0hBoAEjFq6W1tT6WiPQ2QUskNMjJMaXBxvqKaA5vREvE73vo0+g+yN/KSdFAHqP
 17PmdpHlOd+iGlOE9qhukmSC0lOhHkinHwxoYXVq1ZQ4FYKJ3ea+8UnPsiYnJWaVQ1Co
 bZJkZgzUKD4eEHttNlRpVMHirBQ+tSuo9MgGg5JOdvFb4+RJJ16E0t/w1OF0wG6dANxx
 Ij468MEWOFLi5zs62TxdW6XIlxJnlNp4OTD2mBfRfAP4Nm/eUqcNA6wsPFN+ErUXpOEM 6A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31f91drf63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 05 Jun 2020 01:02:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0550w8AL104537;
        Fri, 5 Jun 2020 01:02:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31f926e547-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jun 2020 01:02:01 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 055120BX022971;
        Fri, 5 Jun 2020 01:02:00 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 04 Jun 2020 18:02:00 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 0/1] io_uring: validate the full range of provided buffers for access
Date:   Thu,  4 Jun 2020 18:01:51 -0700
Message-Id: <1591318912-34736-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9642 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=807 bulkscore=0 suspectscore=1 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006050004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9642 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 clxscore=1015 cotscore=-2147483648 malwarescore=0 adultscore=0
 priorityscore=1501 suspectscore=1 phishscore=0 spamscore=0 mlxscore=0
 impostorscore=0 mlxlogscore=861 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006050004
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I hard coded (user_max_address() - PAGESIZE) as the start address 
in liburing/test/read-write.c:test_buf_select() and provided two buffers
of PAGESIZE each.  Without the patch, io_uring_prep_provide_buffers()
succeeds but the subsequent __test_io() obviously fails with -EFAULT.
With the patch, io_uring_prep_provide_buffers() fails with -EFAULT.
I think this would be a good test case to add but I'm not sure what
would be a generic way to implement it.

Bijan Mottahedeh (1):
  io_uring: validate the full range of provided buffers for access

 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.8.3.1

