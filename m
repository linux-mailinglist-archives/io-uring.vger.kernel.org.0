Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA1F2A3F80
	for <lists+io-uring@lfdr.de>; Tue,  3 Nov 2020 09:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgKCI7f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Nov 2020 03:59:35 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:41169 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725988AbgKCI7f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Nov 2020 03:59:35 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UE4qbMW_1604393972;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UE4qbMW_1604393972)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 03 Nov 2020 16:59:33 +0800
Subject: Re: [RFC 0/3] Add support of iopoll for dm device
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
        joseph.qi@linux.alibaba.com, xiaoguang.wang@linux.alibaba.com,
        haoxu@linux.alibaba.com, io-uring@vger.kernel.org
References: <20201020065420.124885-1-jefflexu@linux.alibaba.com>
 <20201021203906.GA10896@redhat.com>
 <da936cfa-93a8-d6ec-bd88-c0fad6c67c8b@linux.alibaba.com>
 <20201026185334.GA8463@redhat.com>
 <33c32cd1-5116-9a42-7fe2-b2a383f1c7a0@linux.alibaba.com>
 <20201102152822.GA20466@redhat.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <ed72109d-0929-eb3a-0b73-b3d94abdea3f@linux.alibaba.com>
Date:   Tue, 3 Nov 2020 16:59:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201102152822.GA20466@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 11/2/20 11:28 PM, Mike Snitzer wrote:
> On Sun, Nov 01 2020 at 10:14pm -0500,
> JeffleXu <jefflexu@linux.alibaba.com> wrote:
>
>> On 10/27/20 2:53 AM, Mike Snitzer wrote:
>>> What you detailed there isn't properly modeling what it needs to.
>>> A given dm_target_io could result in quite a few bios (e.g. for
>>> dm-striped we clone each bio for each of N stripes).  So the fan-out,
>>> especially if then stacked on N layers of stacked devices, to all the
>>> various hctx at the lowest layers is like herding cats.
>>>
>>> But the recursion in block core's submit_bio path makes that challenging
>>> to say the least.  So much so that any solution related to enabling
>>> proper bio-based IO polling is going to need a pretty significant
>>> investment in fixing block core (storing __submit_bio()'s cookie during
>>> recursion, possibly storing to driver provided memory location,
>>> e.g. DM initialized bio->submit_cookie pointer to a blk_qc_t within a DM
>>> clone bio's per-bio-data).
>>>
>>> SO __submit_bio_noacct would become:
>>>
>>>     retp = &ret;
>>>     if (bio->submit_cookie)
>>>            retp = bio->submit_cookie;
>>>     *retp = __submit_bio(bio);
>> Sorry for the late reply. Exactly I missed this point before. IF you
>> have not started working on this, I'd like to try to implement this as
>> an RFC.
> I did start on this line of development but it needs quite a bit more
> work.  Even the pseudo code I provided above isn't useful in the context
> of DM clone bios that have their own per-bio-data to assist with this
> implementation.  Because the __submit_bio_noacct() recursive call
> drivers/md/dm.c:__split_and_process_bio() makes is supplying the
> original bio (modified to only point to remaining work).
>
> But sure, I'm not opposed to you carrying this line of work forward.  I
> can always lend a hand if you need help later or if you need to hand it
> off to me.

Thanks. I will continue working on this.

Jeffle


