Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C882C3991
	for <lists+io-uring@lfdr.de>; Wed, 25 Nov 2020 08:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgKYHEB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Nov 2020 02:04:01 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:38023 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726059AbgKYHEB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Nov 2020 02:04:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UGULzvk_1606287837;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UGULzvk_1606287837)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 25 Nov 2020 15:03:57 +0800
Subject: Re: [PATCH v4 2/2] block,iomap: disable iopoll when split needed
To:     Christoph Hellwig <hch@infradead.org>
Cc:     axboe@kernel.dk, ming.lei@redhat.com, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, joseph.qi@linux.alibaba.com
References: <20201117075625.46118-1-jefflexu@linux.alibaba.com>
 <20201117075625.46118-3-jefflexu@linux.alibaba.com>
 <20201119175516.GB20944@infradead.org>
 <ed355fc8-6fc8-5ffd-f1e9-6ba19f761a09@linux.alibaba.com>
 <20201124112547.GA26805@infradead.org>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <4de531ca-e9bc-9ddb-e6b7-3c153a8a4658@linux.alibaba.com>
Date:   Wed, 25 Nov 2020 15:03:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201124112547.GA26805@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Sorry for that, I will send a new version later.

On 11/24/20 7:25 PM, Christoph Hellwig wrote:
> On Fri, Nov 20, 2020 at 06:06:54PM +0800, JeffleXu wrote:
>>
>> On 11/20/20 1:55 AM, Christoph Hellwig wrote:
>>>> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
>>>> index 933f234d5bec..396ac0f91a43 100644
>>>> --- a/fs/iomap/direct-io.c
>>>> +++ b/fs/iomap/direct-io.c
>>>> @@ -309,6 +309,16 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
>>>>   		copied += n;
>>>>   		nr_pages = iov_iter_npages(dio->submit.iter, BIO_MAX_PAGES);
>>>> +		/*
>>>> +		 * The current dio needs to be split into multiple bios here.
>>>> +		 * iopoll for split bio will cause subtle trouble such as
>>>> +		 * hang when doing sync polling, while iopoll is initially
>>>> +		 * for small size, latency sensitive IO. Thus disable iopoll
>>>> +		 * if split needed.
>>>> +		 */
>>>> +		if (nr_pages)
>>>> +			dio->iocb->ki_flags &= ~IOCB_HIPRI;
>>> I think this is confusing two things.
>>
>> Indeed there's two level of split concerning this issue when doing sync
>> iopoll.
>>
>>
>> The first is that one bio got split in block-core, and patch 1 of this patch
>> set just fixes this.
>>
>>
>> Second is that one dio got split into multiple bios in fs layer, and patch 2
>> fixes this.
>>
>>
>>>   One is that we don't handle
>>> polling well when there are multiple bios.  For this I think we should
>>> only call bio_set_polled when we know there is a single bio.
>>
>>
>> How about the following patch:
>>
>>
>> --- a/fs/iomap/direct-io.c
>> +++ b/fs/iomap/direct-io.c
>> @@ -60,12 +60,12 @@ int iomap_dio_iopoll(struct kiocb *kiocb, bool spin)
>> ??EXPORT_SYMBOL_GPL(iomap_dio_iopoll);
>>
>> ??static void iomap_dio_submit_bio(struct iomap_dio *dio, struct iomap
>> *iomap,
>> -???????????????????????????? struct bio *bio, loff_t pos)
>> +???????????????????????????? struct bio *bio, loff_t pos, bool split)
> 
> This seems pretty messed up by your mailer and I have a hard time
> reading it.  Can you resend it?
> 

-- 
Thanks,
Jeffle
