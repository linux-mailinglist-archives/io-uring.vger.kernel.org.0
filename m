Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3FC91E73F1
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2020 05:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388051AbgE2D6a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 May 2020 23:58:30 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:53586 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388507AbgE2D63 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 May 2020 23:58:29 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R911e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TzwzceO_1590724705;
Received: from 30.225.32.167(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TzwzceO_1590724705)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 May 2020 11:58:26 +0800
Subject: Re: [PATCH v3 1/2] io_uring: avoid whole io_wq_work copy for requests
 completed inline
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, joseph.qi@linux.alibaba.com
References: <20200528091550.3169-1-xiaoguang.wang@linux.alibaba.com>
 <cc55b1e7-2ac1-c315-4c75-99da724d50f3@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <04d9ab52-4919-c3e6-8d21-f11a186750d8@linux.alibaba.com>
Date:   Fri, 29 May 2020 11:58:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <cc55b1e7-2ac1-c315-4c75-99da724d50f3@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi，

> On 5/28/20 3:15 AM, Xiaoguang Wang wrote:
>> If requests can be submitted and completed inline, we don't need to
>> initialize whole io_wq_work in io_init_req(), which is an expensive
>> operation, add a new 'REQ_F_WORK_INITIALIZED' to control whether
>> io_wq_work is initialized.
>>
>> I use /dev/nullb0 to evaluate performance improvement in my physical
>> machine:
>>    modprobe null_blk nr_devices=1 completion_nsec=0
>>    sudo taskset -c 60 fio  -name=fiotest -filename=/dev/nullb0 -iodepth=128
>>    -thread -rw=read -ioengine=io_uring -direct=1 -bs=4k -size=100G -numjobs=1
>>    -time_based -runtime=120
>>
>> before this patch:
>> Run status group 0 (all jobs):
>>     READ: bw=724MiB/s (759MB/s), 724MiB/s-724MiB/s (759MB/s-759MB/s),
>>     io=84.8GiB (91.1GB), run=120001-120001msec
>>
>> With this patch:
>> Run status group 0 (all jobs):
>>     READ: bw=761MiB/s (798MB/s), 761MiB/s-761MiB/s (798MB/s-798MB/s),
>>     io=89.2GiB (95.8GB), run=120001-120001msec
>>
>> About 5% improvement.
> 
> I think this is a big enough of a win to warrant looking closer
> at this. Just a quick comment from me so far:
Yeah, to be honest, I did't expect that we get this some obvious improvement.
But I have run multiple rounds of same tests, I always get similar improvement,
if you have some free time, you can have a test :)

> 
>> @@ -2923,7 +2943,10 @@ static int io_fsync(struct io_kiocb *req, bool force_nonblock)
>>   {
>>   	/* fsync always requires a blocking context */
>>   	if (force_nonblock) {
>> -		req->work.func = io_fsync_finish;
>> +		if (!(req->flags & REQ_F_WORK_INITIALIZED))
>> +			init_io_work(req, io_fsync_finish);
>> +		else
>> +			req->work.func = io_fsync_finish;
> 
> This pattern is repeated enough to warrant a helper, ala:
> 
> static void io_req_init_async(req, func)
> {
> 	if (req->flags & REQ_F_WORK_INITIALIZED)
> 		req->work.func = func;
> 	else
> 		init_io_work(req, func);
> }
> 
> also swapped the conditions, I tend to find it easier to read without
> the negation.
Thanks for your suggestions. I'll prepare a V4 soon.

Regards,
Xiaoguang Wang

> 
