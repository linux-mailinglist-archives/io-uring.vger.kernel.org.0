Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2FBD1783DC
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 21:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbgCCUXU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 15:23:20 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37572 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730081AbgCCUXU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Mar 2020 15:23:20 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023KI7o4074739;
        Tue, 3 Mar 2020 20:23:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+SFY3HBz9Z2ULJw4KsWuAD98K0owG7iTahY8eCqqWr8=;
 b=d3E/fwrPMYAK0j8NSlbi8uiEYbkNXN1Q+r+vg/3HP1cOud/Omg63zE+VFCQxxpmb0+/j
 BvOlluMG3a3oW8TI2tVdLUx2fQMAX8ujZxZQhR0l7aSSpMSqVxyTBDBWWMpAOgWzCwoI
 UCvym839eTQwB1szhxjPOtD+SETRJCBAaGYRsgTSHjnO92dG4y12yyPCsTJS+rVmzvgi
 5D+P95STopgV5ThrK6NWuapEUCMCNNTBRM4zDmb8yQlC0Ry6K1SOeW9DGL98nQ/6mi7m
 vywUrvGccbWyB6WdDfVfPRFqULKUt/ZQ+P/qo6uVhMyIuw+aVpDU3ufo0j2B+giK0LzJ OA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yffwqsqyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 20:23:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023KH1QK123176;
        Tue, 3 Mar 2020 20:23:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2yg1gy6mgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 20:23:17 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 023KNE24029486;
        Tue, 3 Mar 2020 20:23:14 GMT
Received: from [10.154.132.241] (/10.154.132.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 12:23:13 -0800
Subject: Re: io_uring performance with block sizes > 128k
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <53e29125-025c-2fc1-f9b3-fccdea3060e6@oracle.com>
 <f11a29b0-cb7f-37c6-5535-7d95958ebda6@kernel.dk>
 <83e00693-59df-1c18-6712-158f42656de7@kernel.dk>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <1bcca4cc-2b70-5d56-7d2d-bfd398ad85ad@oracle.com>
Date:   Tue, 3 Mar 2020 12:23:12 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <83e00693-59df-1c18-6712-158f42656de7@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Antivirus: Avast (VPS 200303-0, 03/02/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030130
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/2/2020 9:01 PM, Jens Axboe wrote:
> On 3/2/20 4:57 PM, Jens Axboe wrote:
>> On 3/2/20 4:55 PM, Bijan Mottahedeh wrote:
>>> I'm seeing a sizeable drop in perf with polled fio tests for block sizes
>>>   > 128k:
>>>
>>> filename=/dev/nvme0n1
>>> rw=randread
>>> direct=1
>>> time_based=1
>>> randrepeat=1
>>> gtod_reduce=1
>>>
>>> fio --readonly --ioengine=io_uring --iodepth 1024 --fixedbufs --hipri
>>> --numjobs=16
>>> fio --readonly --ioengine=pvsync2 --iodepth 1024 --hipri --numjobs=16
>>>
>>>
>>> Compared with the pvsync2 engine, the only major difference I could see
>>> was the dio path, __blkdev_direct_IO() for io_uring vs.
>>> __blkdev_direct_IO_simple() for pvsync2 because of the is_sync_kiocb()
>>> check.
>>>
>>>
>>> static ssize_t
>>> blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>>> {
>>>           ...
>>>           if (is_sync_kiocb(iocb) && nr_pages <= BIO_MAX_PAGES)
>>>                   return __blkdev_direct_IO_simple(iocb, iter, nr_pages);
>>>
>>>           return __blkdev_direct_IO(iocb, iter, min(nr_pages,
>>> BIO_MAX_PAGES));
>>> }
>>>
>>> Just for an experiment, I hacked io_uring code to force it through the
>>> _simple() path and I get better numbers though the variance is fairly
>>> high, but the drop at bs > 128k seems consistent:
>>>
>>>
>>> # baseline
>>> READ: bw=3167MiB/s (3321MB/s), 186MiB/s-208MiB/s (196MB/s-219MB/s)   #128k
>>> READ: bw=898MiB/s (941MB/s), 51.2MiB/s-66.1MiB/s (53.7MB/s-69.3MB/s) #144k
>>> READ: bw=1576MiB/s (1652MB/s), 81.8MiB/s-109MiB/s (85.8MB/s-114MB/s) #256k
>>>
>>> # hack
>>> READ: bw=2705MiB/s (2836MB/s), 157MiB/s-174MiB/s (165MB/s-183MB/s) #128k
>>> READ: bw=2901MiB/s (3042MB/s), 174MiB/s-194MiB/s (183MB/s-204MB/s) #144k
>>> READ: bw=4194MiB/s (4398MB/s), 252MiB/s-271MiB/s (265MB/s-284MB/s) #256k
>> A quick guess would be that the IO is being split above 128K, and hence
>> the polling only catches one of the parts?
> Can you try and see if this makes a difference?
>
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 571b510ef0e7..cf7599a2c503 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1725,8 +1725,10 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
>   		if (ret < 0)
>   			break;
>   
> +#if 0
>   		if (ret && spin)
>   			spin = false;
> +#endif
>   		ret = 0;
>   	}
>   
>
I didn't see a difference.

If the request is split into two bios, is REQ_F_IOPOLL_COMPLETED set 
only when the 2nd bio completes?

I think you mentioned before that the request is split with 
__blk_queue_split() but I haven't yet been able to see how that happens 
exactly.  I see that the request size nvme_queue_rq() is the same as the 
original (e.g. 256k), is that expected?

