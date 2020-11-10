Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0E92ACA9F
	for <lists+io-uring@lfdr.de>; Tue, 10 Nov 2020 02:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbgKJBnR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Nov 2020 20:43:17 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:34121 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729452AbgKJBnQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Nov 2020 20:43:16 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UEq6B8P_1604972592;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UEq6B8P_1604972592)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 10 Nov 2020 09:43:12 +0800
Subject: Re: [dm-devel] [RFC 0/3] Add support of iopoll for dm device
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     axboe@kernel.dk, xiaoguang.wang@linux.alibaba.com,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, haoxu@linux.alibaba.com,
        io-uring@vger.kernel.org
References: <20201021203906.GA10896@redhat.com>
 <da936cfa-93a8-d6ec-bd88-c0fad6c67c8b@linux.alibaba.com>
 <20201026185334.GA8463@redhat.com>
 <33c32cd1-5116-9a42-7fe2-b2a383f1c7a0@linux.alibaba.com>
 <20201102152822.GA20466@redhat.com>
 <f165f38a-91d1-79aa-829d-a9cc69a5eee6@linux.alibaba.com>
 <20201104150847.GB32761@redhat.com>
 <2c5dab21-8125-fcdf-078e-00a158c57f43@linux.alibaba.com>
 <20201106174526.GA13292@redhat.com>
 <23c73ad7-23e3-3172-8f0e-3c15e0fa5a87@linux.alibaba.com>
 <20201109181528.GA8599@redhat.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <0b133186-024b-76e2-ef29-6bd6fa865a1c@linux.alibaba.com>
Date:   Tue, 10 Nov 2020 09:43:12 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201109181528.GA8599@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 11/10/20 2:15 AM, Mike Snitzer wrote:
> On Sat, Nov 07 2020 at  8:09pm -0500,
> JeffleXu <jefflexu@linux.alibaba.com> wrote:
>
>> On 11/7/20 1:45 AM, Mike Snitzer wrote:
>>> On Thu, Nov 05 2020 at  9:51pm -0500,
>>> JeffleXu <jefflexu@linux.alibaba.com> wrote:
>>>
>>>> blk-mq.c: blk_mq_submit_bio
>>>>
>>>>      if (bio->orig)
>>>>
>>>>          init blk_poll_data and insert it into bio->orig's @cookies list
>>>>
>>>> ```
>>> If you feel that is doable: certainly give it a shot.
>> Make sense.
>>
>>> But it is not clear to me how you intend to translate from cookie passed
>>> in to ->blk_poll hook (returned from submit_bio) to the saved off
>>> bio->orig.
>>>
>>> What is your cookie strategy in this non-recursive implementation?  What
>>> will you be returning?  Where will you be storing it?
>> Actually I think it's a common issue to design the cookie returned
>> by submit_bio() whenever it's implemented in a recursive or
>> non-recursive way. After all you need to translate the returned cookie
>> to the original bio even if it's implemented in a recursive way as you
>> described.
> Yes.
>
>> Or how could you walk through the bio graph when the returned cookie
>> is only 'unsigned int' type?
> You could store a pointer (to orig bio, or per-bio-data stored in split
> clone, or whatever makes sense for how you're associating poll data with
> split bios) in 'unsigned int' type but that's very clumsy -- as I
> discovered when trying to do that ;)

Fine, that's also what I thought.


>
>> How about this:
>>
>>
>> ```
>>
>> typedef uintptr_t blk_qc_t;
>>
>> ```
>>
>>
>> or something like union
>>
>> ```
>>
>> typedef union {
>>
>>      unsigned int cookie;
>>
>>      struct bio *orig; // the original bio of submit_bio()
>>
>> } blk_qc_t;
>>
>> ```
>> When serving for blk-mq, the integer part of blk_qc_t is used and it
>> stores the valid cookie, while it stores a pointer to the original bio
>> when serving bio-based device.
> Union looks ideal, but maybe make it a void *?  Initial implementation
> may store bio pointer but it _could_ evolve to be 'struct blk_poll_data
> *' or whatever.  But not a big deal either way.

Of course you could define blk_qc_t as a pointer type (e.g. void *), or 
integer type (e.g. unsigned int),

but you will get a gcc warning in each case. For example, if it's 
defined as "void *", then gcc will warn

'return makes pointer from integer without a cast' in request_to_qc_t() 
as cookie returned by mq

device is actually integer type. Vice versa. So we need a type cast in 
request_to_qc_t().


The union is also not perfect though, as we also need type cast.


So both these two designs are quite equal to me, though 'void *' may be 
more concise though.

But one annoying issue is that the request_to_qc_t() and blk_poll() 
should be revised somehow

if it's defined as a union or 'void *'. For example if it's defined as 
'void *', then in request_to_qc_t()

integer need to be cast to pointer and in blk_poll() pointer need to be 
cast to integer.


The benefit of uintptr_t is that, it's still integer type which means 
the original request_to_qc_t()/

blk_poll() routine for blk-mq can retain unchanged, while the size of 
the data type can be large

enough to contain a pointer type. So we only need  type cast in 
bio-based routine, while keeping

the request-based routine unchanged.


And yes it's a trivial issue though.


>> By the way, would you mind sharing your plan and progress on this
>> work, I mean, supporting iopoll for dm device. To be honest, I don't
>> want to re-invent the wheel as you have started on this work, but I do
>> want to participate in somehow. Please let me know if there's something
>> I could do here.
> I thought I said as much before but: I really don't have anything
> meaningful to share.  My early exploration was more rough pseudo code
> that served to try to get my arms around the scope of the design
> problem.
>
> Please feel free to own all aspects of this work.
>
> I will gladly help analyze/test/refine your approach once you reach the
> point of sharing RFC patches.

Got it. Thanks for that. Really. I will continue working on this.


-- 
Thanks,
Jeffle

