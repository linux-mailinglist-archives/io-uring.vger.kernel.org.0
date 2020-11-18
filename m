Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1FC2B73FA
	for <lists+io-uring@lfdr.de>; Wed, 18 Nov 2020 02:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgKRB4O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Nov 2020 20:56:14 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:58509 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726363AbgKRB4O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Nov 2020 20:56:14 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UFlUPVT_1605664568;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UFlUPVT_1605664568)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 18 Nov 2020 09:56:09 +0800
Subject: Re: [PATCH v4 2/2] block,iomap: disable iopoll when split needed
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     axboe@kernel.dk, hch@infradead.org, ming.lei@redhat.com,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com, linux-fsdevel@vger.kernel.org
References: <20201117075625.46118-1-jefflexu@linux.alibaba.com>
 <20201117075625.46118-3-jefflexu@linux.alibaba.com>
 <20201117173718.GB9688@magnolia>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <5be2803d-d26b-d381-2fdf-a277e7bbbf6e@linux.alibaba.com>
Date:   Wed, 18 Nov 2020 09:56:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201117173718.GB9688@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 11/18/20 1:37 AM, Darrick J. Wong wrote:
> On Tue, Nov 17, 2020 at 03:56:25PM +0800, Jeffle Xu wrote:
>> Both blkdev fs and iomap-based fs (ext4, xfs, etc.) currently support
> $ ./scripts/get_maintainer.pl fs/iomap/direct-io.c
> Christoph Hellwig <hch@infradead.org> (supporter:IOMAP FILESYSTEM LIBRARY)
> "Darrick J. Wong" <darrick.wong@oracle.com> (supporter:IOMAP FILESYSTEM LIBRARY)
> linux-xfs@vger.kernel.org (supporter:IOMAP FILESYSTEM LIBRARY)
> linux-fsdevel@vger.kernel.org (supporter:IOMAP FILESYSTEM LIBRARY)
> linux-kernel@vger.kernel.org (open list)
>
> Please cc both iomap maintainers and the appropriate lists when you
> propose changes to fs/iomap/.  At a bare minimum cc linux-fsdevel for
> changes under fs/.
Got it.
>
>> sync iopoll. One single bio can contain at most BIO_MAX_PAGES, i.e. 256
>> bio_vec. If the input iov_iter contains more than 256 segments, then
>> one dio will be split into multiple bios, which may cause potential
>> deadlock for sync iopoll.
>>
>> When it comes to sync iopoll, the bio is submitted without REQ_NOWAIT
>> flag set and the process may hang in blk_mq_get_tag() if the dio needs
>> to be split into multiple bios and thus can rapidly exhausts the queue
>> depth. The process has to wait for the completion of the previously
>> allocated requests, which should be reaped by the following sync
>> polling, and thus causing a potential deadlock.
>>
>> In fact there's a subtle difference of handling of HIPRI IO between
>> blkdev fs and iomap-based fs, when dio need to be split into multiple
>> bios. blkdev fs will set REQ_HIPRI for only the last split bio, leaving
>> the previous bios queued into normal hardware queues, and not causing
>> the trouble described above. iomap-based fs will set REQ_HIPRI for all
>> split bios, and thus may cause the potential deadlock described above.
>>
>> Noted that though the analysis described above, currently blkdev fs and
>> iomap-based fs won't trigger this potential deadlock. Because only
>> preadv2(2)/pwritev2(2) are capable of *sync* polling as only these two
>> can set RWF_NOWAIT.

s/RWF_NOWAIT/RWF_HIPRI


>>   Currently the maximum number of iovecs of one single
>> preadv2(2)/pwritev2(2) call is UIO_MAXIOV, i.e. 1024, while the minimum
>> queue depth is BLKDEV_MIN_RQ i.e. 4. That means one
>> preadv2(2)/pwritev2(2) call can submit at most 4 bios, which will fill
>> up the queue depth *exactly* and thus there's no deadlock in this case.
>>
>> However this constraint can be fragile. Disable iopoll when one dio need
>> to be split into multiple bios.Though blkdev fs may not suffer this issue,
>> still it may not make much sense to iopoll for big IO, since iopoll is
>> initially for small size, latency sensitive IO.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> ---
>>   fs/block_dev.c       |  9 +++++++++
>>   fs/iomap/direct-io.c | 10 ++++++++++
>>   2 files changed, 19 insertions(+)
>>
>> diff --git a/fs/block_dev.c b/fs/block_dev.c
>> index 9e84b1928b94..ed3f46e8fa91 100644
>> --- a/fs/block_dev.c
>> +++ b/fs/block_dev.c
>> @@ -436,6 +436,15 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
>>   			break;
>>   		}
>>   
>> +		/*
>> +		 * The current dio needs to be split into multiple bios here.
>> +		 * iopoll for split bio will cause subtle trouble such as
>> +		 * hang when doing sync polling, while iopoll is initially
>> +		 * for small size, latency sensitive IO. Thus disable iopoll
>> +		 * if split needed.
>> +		 */
>> +		iocb->ki_flags &= ~IOCB_HIPRI;
>> +
>>   		if (!dio->multi_bio) {
>>   			/*
>>   			 * AIO needs an extra reference to ensure the dio
>> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
>> index 933f234d5bec..396ac0f91a43 100644
>> --- a/fs/iomap/direct-io.c
>> +++ b/fs/iomap/direct-io.c
>> @@ -309,6 +309,16 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
>>   		copied += n;
>>   
>>   		nr_pages = iov_iter_npages(dio->submit.iter, BIO_MAX_PAGES);
>> +		/*
>> +		 * The current dio needs to be split into multiple bios here.
>> +		 * iopoll for split bio will cause subtle trouble such as
>> +		 * hang when doing sync polling, while iopoll is initially
>> +		 * for small size, latency sensitive IO. Thus disable iopoll
>> +		 * if split needed.
>> +		 */
>> +		if (nr_pages)
>> +			dio->iocb->ki_flags &= ~IOCB_HIPRI;
> Hmm, I was about to ask what happens if the user's HIPRI request gets
> downgraded from polling mode, but the manpage doesn't say anything about
> the kernel having to return an error if it can't use polling mode, so I
> guess downgrading is...fine?

Yes if the block device doesn't support iopoll, then HIPRI pread/pwrite 
will automatically

gets downgraded from polling mode.


> Well, maybe it isn't, since this also results in a downgrade when I send
> a 1MB polled pwrite to my otherwise idle MegaSSD that has thousands of
> queue depth.  I think?  <shrug> I'm not the one who uses polling mode,
> fwiw.

Indeed that's true. iopoll gets disabled once the dio gets split,
even though the block device has thousands of queue depth. This
design is chose just because it is the simplest one..., though
this one should have no big problem.

As I described in the comment, iopoll is initially for small size
IO. We have ever tested the latency of Optane SSD

bs | latency (us)

---- | ----

read 4k | 14

read 128k | 68

write 4k | 17

write 128k | 75


The overhead of interrupt is about several (under 10) microseconds. The 
overhead of

interrupt when doing 128k IO may not be as important as that of small 
size IO, thus

the performance gain of iopoll will decreased a lot at least for 128k IO.


In my computer, @max_sectors of one nvme SSD is 128k, so the split bio 
is much

likely larger than 128k, in which case the performance loss should be 
acceptable

(though I have not test it).


>
>> +
>>   		iomap_dio_submit_bio(dio, iomap, bio, pos);
>>   		pos += n;
>>   	} while (nr_pages);
>> -- 
>> 2.27.0
>>
-- 
Thanks,
Jeffle

