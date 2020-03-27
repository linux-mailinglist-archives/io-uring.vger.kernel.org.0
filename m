Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D819F195B1D
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2020 17:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgC0Qbb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Mar 2020 12:31:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56266 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727242AbgC0Qbb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Mar 2020 12:31:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02RGMPtF134409;
        Fri, 27 Mar 2020 16:31:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tZCEhzQw79i1mgNdg1JLjiMgI0dXDqZctogGJ0CI6Fs=;
 b=ha7UGvJEsJs+nZAmhzYwBciztxxBmxfiuecmPg+kuiUK6tPDphyYprXCx7L3yQvLGgAR
 B6HBfJ9jkFPKyvvDBFS2R2SgA8nCgGQ6fSaExg9WcC5SC6KGmos27wuMbgrFvnDxkHK7
 9/DXXC7uEaZFiddVAgcdP7fBliugdyVhjmHdHUq/xv+jhrejilwUYDLNprhEC8X9lho3
 yDy4yZEvu2JfVFZ9R3qF30770KrVTkCZwhxey05hTfDg9rQibbrlNQQl/e+Pn9INrhOt
 V4XmJ+XZzCqQZFfmIkyyGZicaPh4D0YQR+jZ7iepIuB2KQAz5gjIsC8HvcYJrnOEF72x Jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3019veb81v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 16:31:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02RGJpAm045591;
        Fri, 27 Mar 2020 16:31:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3003gp8t9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 16:31:27 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02RGVQu5007140;
        Fri, 27 Mar 2020 16:31:26 GMT
Received: from [10.154.115.227] (/10.154.115.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 27 Mar 2020 09:31:26 -0700
Subject: Re: Polled I/O cannot find completions
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <471572cf-700c-ec60-5740-0282930c849e@oracle.com>
 <4098ab93-980e-7a17-31f7-9eaeb24a2a65@kernel.dk>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <34a7c633-c390-1220-3c78-1215bd64819f@oracle.com>
Date:   Fri, 27 Mar 2020 09:31:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <4098ab93-980e-7a17-31f7-9eaeb24a2a65@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Antivirus: Avast (VPS 200325-0, 03/25/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9573 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=957 bulkscore=0
 phishscore=0 adultscore=0 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9573 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 phishscore=0
 clxscore=1011 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270144
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Does io_uring though have to deal with BLK_QC_T_NONE at all?  Or are you 
saying that it should never receive that result?
That's one of the things I'm not clear about.

--bijan

> CC'ing linux-block, this isn't an io_uring issue.
>
>
> On 3/26/20 8:57 PM, Bijan Mottahedeh wrote:
>> I'm seeing poll threads hang as I increase the number of threads in
>> polled fio tests.  I think this is because of polling on BLK_QC_T_NONE
>> cookie, which will never succeed.
>>
>> A related problem however, is that the meaning of BLK_QC_T_NONE seems to
>> be ambiguous.
>>
>> Specifically, the following cases return BLK_QC_T_NONE which I think
>> would be problematic for polled io:
>>
>>
>> generic_make_request()
>> ...
>>           if (current->bio_list) {
>>                   bio_list_add(&current->bio_list[0], bio);
>>                   goto out;
>>           }
>>
>> In this case the request is delayed but should get a cookie eventually.
>> How does the caller know what the right action is in this case for a
>> polled request?  Polling would never succeed.
>>
>>
>> __blk_mq_issue_directly()
>> ...
>>           case BLK_STS_RESOURCE:
>>           case BLK_STS_DEV_RESOURCE:
>>                   blk_mq_update_dispatch_busy(hctx, true);
>>                   __blk_mq_requeue_request(rq);
>>                   break;
>>
>> In this case, cookie is not updated and would keep its default
>> BLK_QC_T_NONE value from blk_mq_make_request().  However, this request
>> will eventually be reissued, so again, how would the caller poll for the
>> completion of this request?
>>
>> blk_mq_try_issue_directly()
>> ...
>>           ret = __blk_mq_try_issue_directly(hctx, rq, cookie, false, true);
>>           if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE)
>>                   blk_mq_request_bypass_insert(rq, false, true);
>>
>> Am I missing something here?
>>
>> Incidentally, I don't see BLK_QC_T_EAGAIN used anywhere, should it be?
>>
>> Thanks.
>>
>> --bijan
>>
>>
>>
>>
>

