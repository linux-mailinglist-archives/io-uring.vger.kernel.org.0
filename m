Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2963719A323
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2020 03:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733010AbgDABBV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Mar 2020 21:01:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52012 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733006AbgDABBV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Mar 2020 21:01:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0310xZAl156490;
        Wed, 1 Apr 2020 01:01:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=IKnpS/F46fqqJhg5iRnQ8dZd/zS9QU2rwdZdOS9LtNM=;
 b=0NRa6zSgMFK9BKmB2jy/YKPrKhfbMtU/N5LP0sLWrbwpoZYcZMednPJcSLghHhbjplnS
 xnFipOQOSR4EvbZVWkOqmMd5x2NBSrh6Izv84beddB9/iXFk+VETmXBVpCcycBnUqzCY
 Dw3KQejOrong6FQdRx4QQesF8KaWYsBZrjLbAM8/Lks/NdIynHynOsdg4Gr9ToRn9haw
 l0GHg5jCaVs8mWvvkOWIxVSRRZEqdmJ+wXLRbhgbspiWFz0lGH88nsX/Djar81IvQT2q
 1pxk+uLCT+l1FLhFzeTDXrqXMFhKwKvVFaLfuh9Tlo9J9sbWUQCJ04sJMZ5s/wwS0rJH 0g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 303cev2kg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Apr 2020 01:01:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0310w2iP099326;
        Wed, 1 Apr 2020 01:01:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 302g9yd8sv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Apr 2020 01:01:18 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03111HRC000423;
        Wed, 1 Apr 2020 01:01:17 GMT
Received: from [10.154.118.208] (/10.154.118.208)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Mar 2020 18:01:17 -0700
Subject: Re: Polled I/O cannot find completions
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <471572cf-700c-ec60-5740-0282930c849e@oracle.com>
 <4098ab93-980e-7a17-31f7-9eaeb24a2a65@kernel.dk>
 <34a7c633-c390-1220-3c78-1215bd64819f@oracle.com>
 <d2f92d20-2eb0-e683-5011-e1c922dfcf71@kernel.dk>
 <400a73dc-78de-0de7-79b4-4a4e8bed34ce@oracle.com>
Message-ID: <b53a98a3-9e5e-59eb-bc9f-14c4e986d314@oracle.com>
Date:   Tue, 31 Mar 2020 18:01:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <400a73dc-78de-0de7-79b4-4a4e8bed34ce@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Antivirus: Avast (VPS 200330-0, 03/30/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9577 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 mlxlogscore=973 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004010006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9577 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=2 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004010006
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/31/2020 11:43 AM, Bijan Mottahedeh wrote:
>
>>> Does io_uring though have to deal with BLK_QC_T_NONE at all?  Or are 
>>> you
>>> saying that it should never receive that result?
>>> That's one of the things I'm not clear about.
>> BLK_QC_T_* are block cookies, they are only valid in the block layer.
>> Only the poll handler called should have to deal with them, inside
>> their f_op->iopoll() handler. It's simply passed from the queue to
>> the poll side.
>>
>> So no, io_uring shouldn't have to deal with them at all.
>>
>> The problem, as I see it, is if the block layer returns BLK_QC_T_NONE
>> and the IO was actually queued and requires polling to be found. We'd
>> end up with IO timeouts for handling those requests, and that's not a
>> good thing...
>
> I see requests in io_do_iopoll() on poll_list with req->res == 
> -EAGAIN, I think because the completion happened after an issued 
> request was added to poll_list in io_iopoll_req_issued().
>
> How should we deal with such a request, reissue unconditionally or 
> something else?
>

I mimicked the done processing code in io_iopoll_complete() for -EAGAIN 
as a test.  I can now get further and don't see polling threads hang; in 
fact, I eventually see I/O timeouts as you noted.

It seems that there might be two separate issues here. Makes sense?

Thanks.

--bijan

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 62bd410..a3e3a4e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1738,11 +1738,24 @@ static void io_iopoll_complete(struct 
io_ring_ctx *ctx,
         io_free_req_many(ctx, &rb);
  }

+static void io_iopoll_queue(struct list_head *again)
+{
+       struct io_kiocb *req;
+
+       while (!list_empty(again)) {
+               req = list_first_entry(again, struct io_kiocb, list);
+               list_del(&req->list);
+               refcount_inc(&req->refs);
+               io_queue_async_work(req);
+       }
+}
+
  static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
                         long min)
  {
         struct io_kiocb *req, *tmp;
         LIST_HEAD(done);
+       LIST_HEAD(again);
         bool spin;
         int ret;

@@ -1757,9 +1770,9 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, 
unsigned
                 struct kiocb *kiocb = &req->rw.kiocb;

                 /*
-                * Move completed entries to our local list. If we find a
-                * request that requires polling, break out and complete
-                * the done list first, if we have entries there.
+                * Move completed and retryable entries to our local lists.
+                * If we find a request that requires polling, break out
+                * and complete those lists first, if we have entries there.
                  */
                 if (req->flags & REQ_F_IOPOLL_COMPLETED) {
                         list_move_tail(&req->list, &done);
@@ -1768,6 +1781,13 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, 
unsigned
                 if (!list_empty(&done))
                         break;

+               if (req->result == -EAGAIN) {
+                       list_move_tail(&req->list, &again);
+                       continue;
+               }
+               if (!list_empty(&again))
+                       break;
+
                 ret = kiocb->ki_filp->f_op->iopoll(kiocb, spin);
                 if (ret < 0)
                         break;
@@ -1780,6 +1800,9 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, 
unsigned
         if (!list_empty(&done))
                 io_iopoll_complete(ctx, nr_events, &done);

+       if (!list_empty(&again))
+               io_iopoll_queue(&again);
+
         return ret;
  }


