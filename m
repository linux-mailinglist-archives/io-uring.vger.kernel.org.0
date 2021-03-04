Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF3F32CAA3
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 04:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbhCDC7J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 21:59:09 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:44419 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232059AbhCDC6i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 21:58:38 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UQJ-nD5_1614826675;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQJ-nD5_1614826675)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 04 Mar 2021 10:57:56 +0800
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
Message-ID: <f9dd41f1-7a4c-5901-c099-dca08c4e6d65@linux.alibaba.com>
Date:   Thu, 4 Mar 2021 10:57:55 +0800
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
> 

I will once I finished some other issues.


>> Besides, the submitting routine and polling routine is bound together
>> here, i.e., polling is always synchronous.
> 
> __split_and_process_bio calls __split_and_process_non_flush in a loop

I also noticed that you sent this patch.
https://patchwork.kernel.org/project/dm-devel/patch/alpine.LRH.2.02.2103010457510.631@file01.intranet.prod.int.rdu2.redhat.com/

I agree with you that this while() loop here is unnecessary. And thus
there's no loop calling __split_and_process_non_flush() in
__split_and_process_bio().


> __split_and_process_non_flush records the poll cookie in ci.poll_cookie. 
> When we processed all the bios, we poll for the last cookie here:
> 
>         if (ci.poll_cookie != BLK_QC_T_NONE) {
>                 while (atomic_read(&ci.io->io_count) > 1 &&
>                        blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
>         }

So what will happen if one bio submitted to dm device crosses the device
boundary among several target devices (e.g., dm-stripe)? Please refer
the following call graph.

```
submit_bio
  __submit_bio_noacct
    disk->fops->submit_bio(), calling into __split_and_process_bio(),
call __split_and_process_non_flush() once, submitting the *first* split bio
    disk->fops->submit_bio(), calling into __split_and_process_bio(),
call __split_and_process_non_flush() once, submitting the *second* split bio
    ...
```


So the loop is in __submit_bio_noacct(), rather than
__split_and_process_bio(). Your design will send the first split bio,
and then poll on this split bio, then send the next split bio, polling
on this, go on and on...

-- 
Thanks,
Jeffle
