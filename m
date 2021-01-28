Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352FE306B62
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 04:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhA1DHd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 22:07:33 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:50661 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229545AbhA1DHc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 22:07:32 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UN61yfy_1611803201;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UN61yfy_1611803201)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Jan 2021 11:06:41 +0800
Subject: Re: [PATCH v2 0/6] dm: support IO polling for bio-based dm device
To:     Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
 <20210127171941.GA11530@redhat.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <2ed9966f-b390-085a-1a51-5bf65038d533@linux.alibaba.com>
Date:   Thu, 28 Jan 2021 11:06:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210127171941.GA11530@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 1/28/21 1:19 AM, Mike Snitzer wrote:
> On Mon, Jan 25 2021 at  7:13am -0500,
> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> 
>> Since currently we have no simple but efficient way to implement the
>> bio-based IO polling in the split-bio tracking style, this patch set
>> turns to the original implementation mechanism that iterates and
>> polls all underlying hw queues in polling mode. One optimization is
>> introduced to mitigate the race of one hw queue among multiple polling
>> instances.
>>
>> I'm still open to the split bio tracking mechanism, if there's
>> reasonable way to implement it.
>>
>>
>> [Performance Test]
>> The performance is tested by fio (engine=io_uring) 4k randread on
>> dm-linear device. The dm-linear device is built upon nvme devices,
>> and every nvme device has one polling hw queue (nvme.poll_queues=1).
>>
>> Test Case		    | IOPS in IRQ mode | IOPS in polling mode | Diff
>> 			    | (hipri=0)	       | (hipri=1)	      |
>> --------------------------- | ---------------- | -------------------- | ----
>> 3 target nvme, num_jobs = 1 | 198k 	       | 276k		      | ~40%
>> 3 target nvme, num_jobs = 3 | 608k 	       | 705k		      | ~16%
>> 6 target nvme, num_jobs = 6 | 1197k 	       | 1347k		      | ~13%
>> 3 target nvme, num_jobs = 6 | 1285k 	       | 1293k		      | ~0%
>>
>> As the number of polling instances (num_jobs) increases, the
>> performance improvement decreases, though it's still positive
>> compared to the IRQ mode.
> 
> I think there is serious room for improvement for DM's implementation;
> but the block changes for this are all we'd need for DM in the longrun
> anyway (famous last words).

Agreed.


> So on a block interface level I'm OK with
> block patches 1-3.
> 
> I don't see why patch 5 is needed (said the same in reply to it; but I
> just saw your reason below..).
> 
> Anyway, I can pick up DM patches 4 and 6 via linux-dm.git if Jens picks
> up patches 1-3. Jens, what do you think?

cc Jens.

Also I will send a new version later, maybe some refactor on patch5 and
some typo modifications.

> 
>> [Optimization]
>> To mitigate the race when iterating all the underlying hw queues, one
>> flag is maintained on a per-hw-queue basis. This flag is used to
>> indicate whether this polling hw queue currently being polled on or
>> not. Every polling hw queue is exclusive to one polling instance, i.e.,
>> the polling instance will skip this polling hw queue if this hw queue
>> currently is being polled by another polling instance, and start
>> polling on the next hw queue.
>>
>> This per-hw-queue flag map is currently maintained in dm layer. In
>> the table load phase, a table describing all underlying polling hw
>> queues is built and stored in 'struct dm_table'. It is safe when
>> reloading the mapping table.
>>
>>
>> changes since v1:
>> - patch 1,2,4 is the same as v1 and have already been reviewed
>> - patch 3 is refactored a bit on the basis of suggestions from
>> Mike Snitzer.
>> - patch 5 is newly added and introduces one new queue flag
>> representing if the queue is capable of IO polling. This mainly
>> simplifies the logic in queue_poll_store().
> 
> Ah OK, don't see why we want to eat a queue flag for that though!
> 
>> - patch 6 implements the core mechanism supporting IO polling.
>> The sanity check checking if the dm device supports IO polling is
>> also folded into this patch, and the queue flag will be cleared if
>> it doesn't support, in case of table reloading.
> 
> Thanks,
> Mike
> 

-- 
Thanks,
Jeffle
