Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2BF32E551
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 10:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhCEJxF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 04:53:05 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:50421 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229517AbhCEJwt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 04:52:49 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UQa8kae_1614937966;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQa8kae_1614937966)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Mar 2021 17:52:47 +0800
Subject: Re: [dm-devel] [PATCH 4/4] dm: support I/O polling
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, axboe@kernel.dk,
        caspar@linux.alibaba.com, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, hch@lst.de
References: <20210302190555.201228400@debian-a64.vm>
 <33fa121a-88a8-5c27-0a43-a7efc9b5b3e3@linux.alibaba.com>
 <alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <157a750d-3d58-ae2e-07f1-b677c1b471c7@linux.alibaba.com>
Date:   Fri, 5 Mar 2021 17:52:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 3/3/21 6:09 PM, Mikulas Patocka wrote:
> 
> 
> On Wed, 3 Mar 2021, JeffleXu wrote:
> 
>>
>>
>> On 3/3/21 3:05 AM, Mikulas Patocka wrote:
>>
>>> Support I/O polling if submit_bio_noacct_mq_direct returned non-empty
>>> cookie.
>>>
>>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>>
>>> ---
>>>  drivers/md/dm.c |    5 +++++
>>>  1 file changed, 5 insertions(+)
>>>
>>> Index: linux-2.6/drivers/md/dm.c
>>> ===================================================================
>>> --- linux-2.6.orig/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
>>> +++ linux-2.6/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
>>> @@ -1682,6 +1682,11 @@ static void __split_and_process_bio(stru
>>>  		}
>>>  	}
>>>  
>>> +	if (ci.poll_cookie != BLK_QC_T_NONE) {
>>> +		while (atomic_read(&ci.io->io_count) > 1 &&
>>> +		       blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
>>> +	}
>>> +
>>>  	/* drop the extra reference count */
>>>  	dec_pending(ci.io, errno_to_blk_status(error));
>>>  }
>>
>> It seems that the general idea of your design is to
>> 1) submit *one* split bio
>> 2) blk_poll(), waiting the previously submitted split bio complets
> 
> No, I submit all the bios and poll for the last one.
> 
>> and then submit next split bio, repeating the above process. I'm afraid
>> the performance may be an issue here, since the batch every time
>> blk_poll() reaps may decrease.
> 
> Could you benchmark it?

I only tested dm-linear.

The configuration (dm table) of dm-linear is:
0 1048576 linear /dev/nvme0n1 0
1048576 1048576 linear /dev/nvme2n1 0
2097152 1048576 linear /dev/nvme5n1 0


fio script used is:
```
$cat fio.conf
[global]
name=iouring-sqpoll-iopoll-1
ioengine=io_uring
iodepth=128
numjobs=1
thread
rw=randread
direct=1
registerfiles=1
hipri=1
runtime=10
time_based
group_reporting
randrepeat=0
filename=/dev/mapper/testdev
bs=4k

[job-1]
cpus_allowed=14
```

IOPS (IRQ mode) | IOPS (iopoll mode (hipri=1))
--------------- | --------------------
           213k |		   19k

At least, it doesn't work well with io_uring interface.


-- 
Thanks,
Jeffle
