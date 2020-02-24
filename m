Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9110E16B5A5
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 00:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgBXXc7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 18:32:59 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58362 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBXXc6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 18:32:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01ONVPTr195994;
        Mon, 24 Feb 2020 23:32:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=a8ubdp8TUaTsUfIREXDEbgh9tTowTVfz3WviG2xF3SA=;
 b=EDtpydoGkAM2RvvhzezAX6jdwWZ5J3VE+v1s+/yGeddua1nkTcs54pKKV5Jc3yMjoh+l
 kUL5xwsY1YS25fIKQ8j0s5fxmGil+u5WwW7kfsDe3InlmmXNwM2TrUyN8Gqctw4bIgi8
 Mtf0x3jIaagoabaYimTEb8orNF6e3cRDrFlnqXJ7FBy5n89Gk0mAoHuZixjOeL5aG6h6
 Hs7L4YbGyAydYcIBrEYSN7IMwbLdDr82xseQiHJAyFttqt9mpRDfk6bmYAxMnkC3femS
 5sjRB+Dis3i4OJLTY8RWHUlKQDUnlT5Sk2UWhaeWqkZYBsr0pSOaxm8IwyX4XnhWYPu+ zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ycppr8c65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 23:32:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01ONS750130848;
        Mon, 24 Feb 2020 23:32:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ybe12c6tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 23:32:50 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01ONWniO010039;
        Mon, 24 Feb 2020 23:32:49 GMT
Received: from [10.154.136.165] (/10.154.136.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 15:32:49 -0800
Subject: Re: [PATCH 1/1] block: Manage bio references so the bio persists
 until necessary
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        MATTHEW_WILCOX <matthew.wilcox@oracle.com>
References: <1580441022-59129-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1580441022-59129-2-git-send-email-bijan.mottahedeh@oracle.com>
 <20200131064230.GA28151@infradead.org>
 <9f29fbc7-baf3-00d1-a20c-d2a115439db2@oracle.com>
 <20200203083422.GA2671@infradead.org>
 <aaecd43b-dd44-f6c5-4e2d-1772cf135d2a@oracle.com>
 <20200204075124.GA29349@infradead.org>
 <46bf2ea0-7677-44af-8e23-45a10710ca3d@kernel.dk>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <8111469e-713d-88d3-7f12-55e90edaf52b@oracle.com>
Date:   Mon, 24 Feb 2020 15:32:45 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <46bf2ea0-7677-44af-8e23-45a10710ca3d@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Antivirus: Avast (VPS 200223-0, 02/23/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=2 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=2 impostorscore=0
 spamscore=0 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240175
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/4/2020 12:59 PM, Jens Axboe wrote:
> On 2/4/20 12:51 AM, Christoph Hellwig wrote:
>> On Mon, Feb 03, 2020 at 01:07:48PM -0800, Bijan Mottahedeh wrote:
>>> My concern is with the code below for the single bio async case:
>>>
>>>                             qc = submit_bio(bio);
>>>
>>>                             if (polled)
>>>                                     WRITE_ONCE(iocb->ki_cookie, qc);
>>>
>>> The bio/dio can be freed before the the cookie is written which is what I'm
>>> seeing, and I thought this may lead to a scenario where that iocb request
>>> could be completed, freed, reallocated, and resubmitted in io_uring layer;
>>> i.e., I thought the cookie could be written into the wrong iocb.
>> I think we do have a potential use after free of the iocb here.
>> But taking a bio reference isn't going to help with that, as the iocb
>> and bio/dio life times are unrelated.
>>
>> I vaguely remember having that discussion with Jens a while ago, and
>> tried to pass a pointer to the qc to submit_bio so that we can set
>> it at submission time, but he came up with a reason why that might not
>> be required.  I'd have to dig out all notes unless Jens remembers
>> better.
> Don't remember that either, so I'd have to dig out emails! But looking
> at it now, for the async case with io_uring, the iocb is embedded in the
> io_kiocb from io_uring. We hold two references to the io_kiocb, one for
> submit and one for completion. Hence even if the bio completes
> immediately and someone else finds the completion before the application
> doing this submit, we still hold the submission reference to the
> io_kiocb. Hence I don't really see how we can end up with a
> use-after-free situation here.
>
> IIRC, Bijan had traces showing this can happen, KASAN complaining about
> it. Which makes me think that I'm missing a case here, though I don't
> immediately see what it is.
>
> Bijan, could post your trace again, I can't seem to find it?
>

I think the problem may be in the nvme driver's handling of multiple 
pollers sharing the same CQ, due to the fact that nvme_poll() drops 
cq_poll_lock before completing the CQEs found with nvme_process_cq():

nvme_poll()
{
     ...
     spin_lock(&nvmeq->cq_poll_lock);
     found = nvme_process_cq(nvmeq, &start, &end, -1);
     spin_unlock(&nvmeq->cq_poll_lock);

     nvme_complete_cqes(nvmeq, start, end);
     ...
}

Furthermore, nvme_process_cq() rings the CQ doorbell after collecting 
the CQEs but before processing them:

static inline int nvme_process_cq(struct nvme_queue *nvmeq, u16 *start, 
u16 *end, unsigned int tag)
{
     ...
     while (nvme_cqe_pending(nvmeq)) {
         ...
         nvme_update_cq_head(nvmeq);
     }
     ...
         nvme_ring_cq_doorbell(nvmeq);
     return found;
}

Each poller effectively tells the controller that the CQ is empty when it rings the CQ doorbell. This is ok if there is only one poller but with many of them, I think enough tags can be freed and reissued that CQ could be overrun.

In one specific example:

- Poller 1 find a CQ full of entries in nvme_process_cq()
- Poller 1 processes CQEs, and more pollers find CQE ranges to process
   Pollers 2-4 start processing additional non-overlapping CQE ranges
- Poller 5 finds a CQE range that is overlapping with Poller 1

CQ size 1024

Poller          1   2    3    4    5
CQ start index  10  9    214  401  708
CQ end index    9   214  401  708  77
CQ start phase  1   0    0    0    0
CQ end phase    0   0    0    0    1

Poller 1 finds the CQ phase has flipped when processing CQE 821 and  indeed the phase has flipped because of poller 5.  If I interpret this data correctly, it suggests that Pollers 1 and 5 overlap.

After that I start seeing errors.

A simpler theoretical example with two threads suggested by Matthew Wilcox:

Thread 1 submits enough I/O to fill the CQ
Thread 1 then processes two CQEs, two block layer tags become available.
Thread 1 is preempted by thread 2.
Thread 2 submits two I/Os.
Thread 2 processes the two CQEs which it owns.
Thread 2 submits two more I/Os.
Those CQEs overwrite the next two CQEs that will be processed by thread 1.

Two of thread 1's IOs will not receive a completion.  Two of
thread 2's IOs will receive two completions.

Just as a workaround, I held cq_poll_lock while completing the CQEs and see no errors.

Does that make sense?

Thanks.

--bijan

