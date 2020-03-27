Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 366B3194F4B
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2020 03:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgC0C5g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 Mar 2020 22:57:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60626 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0C5g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 Mar 2020 22:57:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R2tsni188526;
        Fri, 27 Mar 2020 02:57:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=9rmqY1S+C01mGZhzGsl9UXUwzzBW4vK1hY9ZzJ3eUns=;
 b=TnDoIMTzThq5n5c8D5sJqo7nlDWuXW5AZmqC3CL0FeXMnZiYq6SKHgE+DtvaF7BKv8V0
 BLRsIe3XR8bd/lG+xeWYu0bLcTPTmL4RkqkFTqkbLqKm9vj4KG7/t+9KwTvNPLa/gkPu
 BeiylB1H97tcMsFMD/lCE5nRcCbXmu+bHXaEkXc38fFRwgXRwfwXY67jhnu0BHyjlUJV
 gdhhprogR0EaeOzpoRp/OP8rzuAbz4C9tUIG3+PiWUMTpsZdOuFdi+2rr8rcrzQeClED
 9+Bwwr7q0YsOf39DJHNM7GGDhS+0fV+Zofjknn8vJejAMKBtqp7gjF0L29AwuZv8zvMo Fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 300urk3rhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 02:57:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R2qpvV065851;
        Fri, 27 Mar 2020 02:57:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3006r9hxkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 02:57:32 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02R2vS05000569;
        Fri, 27 Mar 2020 02:57:28 GMT
Received: from [10.154.171.202] (/10.154.171.202)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 19:57:28 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Polled I/O cannot find completions
Message-ID: <471572cf-700c-ec60-5740-0282930c849e@oracle.com>
Date:   Thu, 26 Mar 2020 19:57:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Antivirus: Avast (VPS 200325-0, 03/25/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=809 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=850 clxscore=1011 lowpriorityscore=0 mlxscore=0 phishscore=0
 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270023
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I'm seeing poll threads hang as I increase the number of threads in 
polled fio tests.  I think this is because of polling on BLK_QC_T_NONE 
cookie, which will never succeed.

A related problem however, is that the meaning of BLK_QC_T_NONE seems to 
be ambiguous.

Specifically, the following cases return BLK_QC_T_NONE which I think 
would be problematic for polled io:


generic_make_request()
...
         if (current->bio_list) {
                 bio_list_add(&current->bio_list[0], bio);
                 goto out;
         }

In this case the request is delayed but should get a cookie eventually.  
How does the caller know what the right action is in this case for a 
polled request?  Polling would never succeed.


__blk_mq_issue_directly()
...
         case BLK_STS_RESOURCE:
         case BLK_STS_DEV_RESOURCE:
                 blk_mq_update_dispatch_busy(hctx, true);
                 __blk_mq_requeue_request(rq);
                 break;

In this case, cookie is not updated and would keep its default 
BLK_QC_T_NONE value from blk_mq_make_request().  However, this request 
will eventually be reissued, so again, how would the caller poll for the 
completion of this request?

blk_mq_try_issue_directly()
...
         ret = __blk_mq_try_issue_directly(hctx, rq, cookie, false, true);
         if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE)
                 blk_mq_request_bypass_insert(rq, false, true);

Am I missing something here?

Incidentally, I don't see BLK_QC_T_EAGAIN used anywhere, should it be?

Thanks.

--bijan




