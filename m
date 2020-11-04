Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD4F2A5E48
	for <lists+io-uring@lfdr.de>; Wed,  4 Nov 2020 07:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgKDGru (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 01:47:50 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:45728 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727986AbgKDGrt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 01:47:49 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UEATY5e_1604472464;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UEATY5e_1604472464)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 04 Nov 2020 14:47:44 +0800
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
Message-ID: <f165f38a-91d1-79aa-829d-a9cc69a5eee6@linux.alibaba.com>
Date:   Wed, 4 Nov 2020 14:47:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201102152822.GA20466@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
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

Yes I noticed this recently. Since the depth-first splitting introduced 
in commit 18a25da84354

("dm: ensure bio submission follows a depth-first tree walk"), one bio 
to dm device can be

split into multiple bios to this dm device.

```

one bio to dm device (dm0) = one dm_io (to nvme0) + one bio to this same 
dm device (dm0)

```


In this case we need a mechanism to track all split sub-bios of the very 
beginning original bio.

I'm doubted if this should be implemented in block layer like:

```

struct bio {

     ...

     struct list_head  cookies;

};

```

After all it's only used by bio-based queue, or more specifically only 
dm device currently.


Another design I can come up with is to maintain a global data structure 
for the very beginning

original bio. Currently the blocking point is that now one original bio 
to the dm device (@bio of

dm_submit()) can correspond to multiple dm_io and thus we have nowhere 
to place the

@cookies list.


Now we have to maintain one data structure for every original bio, 
something like

```

struct dm_poll_instance {

     ...

     struct list_head cookies;

};

```


We can transfer this dm_poll_instance between split bios by 
bio->bi_private, like

```

dm_submit_bio(...) {

     struct dm_poll_instance *ins;

     if (bio->bi_private)

         ins = bio->bi_private;

     else {

         ins = alloc_poll_instance();

         bio->bi_private = ins;

     }

     ...

}

```



-- 
Jeffle
Thanks

