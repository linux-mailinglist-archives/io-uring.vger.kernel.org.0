Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E15218954
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 15:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgGHNkI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 09:40:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44689 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729798AbgGHNkH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 09:40:07 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200708134004epoutp045eb8d5ba334017a24747cd07a8139366~fyqVY6aJI0192701927epoutp04h
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 13:40:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200708134004epoutp045eb8d5ba334017a24747cd07a8139366~fyqVY6aJI0192701927epoutp04h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594215604;
        bh=8olNTXPEO9AiHbyDOEdhyHG15yYRp1t1bGMsJZeRYXo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LVS9aFnDk0/1nT634YDsgL7rYhv3gcPCC9DLgYgSRN/UE3JdGFFMeHTV5aozWT35t
         bPv55ZiGNZieWLvvbR+zDM+HQ0+XrB+BKj8CRObGYtdurqgjDxDthZszjsbqyiAMw9
         dNzVQYrpdePcHrsUwr96nCDOjCoyFyLzUbal1g7M=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200708134003epcas5p3b8d4642c76d4a9e1a0be1a799bedadbc~fyqUpO3BM3071330713epcas5p3G;
        Wed,  8 Jul 2020 13:40:03 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2E.72.09475.3BCC50F5; Wed,  8 Jul 2020 22:40:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200708130103epcas5p3d4d6a9a340f405e2a955e25018ee3556~fyIRMr2S42478724787epcas5p3s;
        Wed,  8 Jul 2020 13:01:03 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200708130103epsmtrp270b27ef57ecfe75ed707c6eca2d72753~fyIRLoUAN0037100371epsmtrp25;
        Wed,  8 Jul 2020 13:01:03 +0000 (GMT)
X-AuditID: b6c32a4b-39fff70000002503-5d-5f05ccb34d82
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        23.6C.08303.F83C50F5; Wed,  8 Jul 2020 22:01:03 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200708130101epsmtip241d423671fe7c7d46015b34ba48814a3~fyIOx-zaa1837818378epsmtip2g;
        Wed,  8 Jul 2020 13:01:00 +0000 (GMT)
Date:   Wed, 8 Jul 2020 18:28:05 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        mb@lightnvm.io, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200708125805.GA16495@test-zns>
MIME-Version: 1.0
In-Reply-To: <145cc0ad-af86-2d6a-78b3-9ade007aae52@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsWy7bCmlu7mM6zxBhuXalvMWbWN0WL13X42
        i65/W1gsWtu/MVmcnrCIyeJd6zkWi8d3PrNbTJnWxGix95a2xZ69J1ksLu+aw2axYvsRFott
        v+czW7z+cZLN4vzf46wWv3/MYXMQ8Ng56y67x+YVWh6Xz5Z6bPo0id2j++oPRo++LasYPT5v
        kvNoP9DN5LHpyVumAM4oLpuU1JzMstQifbsErozrc26wFswXrZjS9JGlgbFVsIuRk0NCwERi
        4Z4XLCC2kMBuRomFOwu7GLmA7E+MEk/adrBBOJ8ZJb5M+MQC07Fo0w1miMQuRom9tyeyQjjP
        GCV+b2wFq2IRUJHYsHotexcjBwebgKbEhcmlIGERAQWJnt8rwaYyC2xklri59BtYvbCAo8Tn
        nScZQep5BXQl3p4qAQnzCghKnJz5BKyEU8BW4smrq4wgtqiAssSBbceZIA56wCGxscMApFVC
        wEWib4IORFhY4tXxLewQtpTE53d72SDsYolfd46C3S8h0MEocb1hJtRj9hIX9/wFm8kskCGx
        Y+scqGZZiamn1kHF+SR6fz+B2ssrsWMejK0ocW/SU1YIW1zi4YwlULaHxIVbx9kh4fOPWWLl
        lEusExjlZyH5bRaSfRC2lUTnhybWWUD/MAtISyz/xwFhakqs36W/gJF1FaNkakFxbnpqsWmB
        cV5quV5xYm5xaV66XnJ+7iZGcArU8t7B+OjBB71DjEwcjIcYJTiYlUR4DRRZ44V4UxIrq1KL
        8uOLSnNSiw8xSnOwKInzKv04EyckkJ5YkpqdmlqQWgSTZeLglGpgao8wWM/8uPLt0V47sWMV
        Qhl/rpz8feV3cdm9ew0cL+JWFCQ+e7ltSXaqT5H3T86LW/e0CBbtzc6ZEp2TuL6xxM9H6LzV
        jvVsT7K+PFbfzfs77MT/r8emtVdIrVBY/mBX9bUKVtGsyY9sA4N4Pxd8z/s5Mf7Gn++lv/Jv
        nl5x5+KZ8AdCn1c4Mbgu57zkpM37TtjWKdb29+r0h7FX+rRYvdpi72xYIRLMHyDuEa4u9NHy
        YsJKa7GpMhfSnvB0vLq7+8rlHB1LqfOJ1iwsE8RU7mqFG6XPK6kIXFAnOSWUV+6Y3xHV4+5r
        3+aXZ8UrpHxdYjnD6u1CP5nDIhnzqyeE3y6790zbzKjynWDnlndrlViKMxINtZiLihMB1E5i
        +PADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWy7bCSvG7/YdZ4g/lXlCzmrNrGaLH6bj+b
        Rde/LSwWre3fmCxOT1jEZPGu9RyLxeM7n9ktpkxrYrTYe0vbYs/ekywWl3fNYbNYsf0Ii8W2
        3/OZLV7/OMlmcf7vcVaL3z/msDkIeOycdZfdY/MKLY/LZ0s9Nn2axO7RffUHo0ffllWMHp83
        yXm0H+hm8tj05C1TAGcUl01Kak5mWWqRvl0CV0b7xOlMBReFKuZdvszUwHiRr4uRk0NCwERi
        0aYbzF2MXBxCAjsYJQ7vbGCCSIhLNF/7wQ5hC0us/PecHaLoCaPE+yd3mUESLAIqEhtWrwVK
        cHCwCWhKXJhcChIWEVCQ6Pm9kg2knllgK7PE14Oz2UASwgKOEp93nmQEqecV0JV4e6oEYuY/
        ZolZf7eALeMVEJQ4OfMJC4jNLGAmMW/zQ2aQemYBaYnl/zhAwpwCthJPXl1lBLFFBZQlDmw7
        zjSBUXAWku5ZSLpnIXQvYGRexSiZWlCcm55bbFhglJdarlecmFtcmpeul5yfu4kRHH9aWjsY
        96z6oHeIkYmD8RCjBAezkgivgSJrvBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHer7MWxgkJpCeW
        pGanphakFsFkmTg4pRqY+KqKZfdM2KjitqXh4Z0D4tEPG5aqnfshnDl540qvozfWWv5eq5d3
        wLHAcaJKsJD8xvpcM+eLmdMqJyxZVfztb9+5gOKvxwM2puT0LnDfw3Woc/elReFrftjw2f2Z
        /9n4dERSdKpOetodd4638hfETqxivC8b2mgVHlLUt0+/4qKA/KMZKs9fn7v0wVf31X6/rwXn
        KyQ8KoOvqP6zXSJus+dnyh2Tz7ULXGa0N1c+N5nJfnVXy3kxYf3fTrOl/F7xmTAa7XhwJWBd
        r3/6HfVLyxxF+zMPxpQuP3Rtrf1UI9EXv+clhGt7h/0q3ZLLYq6sYXHW/r+YbbHee17xiwmL
        23NERT/cmOl16N6ZjTMYlFiKMxINtZiLihMB9zl9Yy4DAAA=
X-CMS-MailID: 20200708130103epcas5p3d4d6a9a340f405e2a955e25018ee3556
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----FBC7EIImzEv-3WQrgwRbJYn4xAlwhlhWWV1zALX9mq8rjZSB=_e89f5_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20200707223803epcas5p41814360c764d6b5f67fdbf173a8ba64e
References: <20200706141002.GZ25523@casper.infradead.org>
        <4a9bf73e-f3ee-4f06-7fad-b8f8861b0bc1@kernel.dk>
        <20200706143208.GA25523@casper.infradead.org>
        <20200707151105.GA23395@test-zns>
        <20200707155237.GM25523@casper.infradead.org>
        <20200707202342.GA28364@test-zns>
        <7a44d9c6-bf7d-0666-fc29-32c3cba9d1d8@kernel.dk>
        <20200707221812.GN25523@casper.infradead.org>
        <CGME20200707223803epcas5p41814360c764d6b5f67fdbf173a8ba64e@epcas5p4.samsung.com>
        <145cc0ad-af86-2d6a-78b3-9ade007aae52@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------FBC7EIImzEv-3WQrgwRbJYn4xAlwhlhWWV1zALX9mq8rjZSB=_e89f5_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, Jul 07, 2020 at 04:37:55PM -0600, Jens Axboe wrote:
>On 7/7/20 4:18 PM, Matthew Wilcox wrote:
>> On Tue, Jul 07, 2020 at 02:40:06PM -0600, Jens Axboe wrote:
>>>>> so we have another 24 bytes before io_kiocb takes up another cacheline.
>>>>> If that's a serious problem, I have an idea about how to shrink struct
>>>>> kiocb by 8 bytes so struct io_rw would have space to store another
>>>>> pointer.
>>>> Yes, io_kiocb has room. Cache-locality wise whether that is fine or
>>>> it must be placed within io_rw - I'll come to know once I get to
>>>> implement this. Please share the idea you have, it can come handy.
>>>
>>> Except it doesn't, I'm not interested in adding per-request type fields
>>> to the generic part of it. Before we know it, we'll blow past the next
>>> cacheline.
>>>
>>> If we can find space in the kiocb, that'd be much better. Note that once
>>> the async buffered bits go in for 5.9, then there's no longer a 4-byte
>>> hole in struct kiocb.
>>
>> Well, poot, I was planning on using that.  OK, how about this:
>
>Figured you might have had your sights set on that one, which is why I
>wanted to bring it up upfront :-)
>
>> +#define IOCB_NO_CMPL		(15 << 28)
>>
>>  struct kiocb {
>> [...]
>> -	void (*ki_complete)(struct kiocb *iocb, long ret, long ret2);
>> +	loff_t __user *ki_uposp;
>> -	int			ki_flags;
>> +	unsigned int		ki_flags;
>>
>> +typedef void ki_cmpl(struct kiocb *, long ret, long ret2);
>> +static ki_cmpl * const ki_cmpls[15];
>>
>> +void ki_complete(struct kiocb *iocb, long ret, long ret2)
>> +{
>> +	unsigned int id = iocb->ki_flags >> 28;
>> +
>> +	if (id < 15)
>> +		ki_cmpls[id](iocb, ret, ret2);
>> +}
>>
>> +int kiocb_cmpl_register(void (*cb)(struct kiocb *, long, long))
>> +{
>> +	for (i = 0; i < 15; i++) {
>> +		if (ki_cmpls[id])
>> +			continue;
>> +		ki_cmpls[id] = cb;
>> +		return id;
>> +	}
>> +	WARN();
>> +	return -1;
>> +}
>
>That could work, we don't really have a lot of different completion
>types in the kernel.

Thanks, this looks sorted.
The last thing is about the flag used to trigger this processing. 
Will it be fine to intoduce new flag (RWF_APPEND2 or RWF_APPEND_OFFSET)
instead of using RWF_APPEND? 

New flag will do what RWF_APPEND does and will also return the 
written-location (and therefore expects pointer setup in application).

------FBC7EIImzEv-3WQrgwRbJYn4xAlwhlhWWV1zALX9mq8rjZSB=_e89f5_
Content-Type: text/plain; charset="utf-8"


------FBC7EIImzEv-3WQrgwRbJYn4xAlwhlhWWV1zALX9mq8rjZSB=_e89f5_--
