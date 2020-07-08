Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F55218A75
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 16:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgGHOyL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 10:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729689AbgGHOyK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 10:54:10 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0BBC08C5DC
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 07:54:10 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id v8so47208536iox.2
        for <io-uring@vger.kernel.org>; Wed, 08 Jul 2020 07:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cREv3rZvN4Yo/5YgjBmWEsOZvAdLXz7UPWWz2pKlQ9E=;
        b=ucOznK9IILbhxf+nT10Izgudiaar596unf8NWa0m/o0Jiph3G2hRVDYzB+xxkbCE2M
         G590FSnAm7skRHO+QkI52tf7ossC1S7j6RBi132SOgfj6eEjsP8GDBCHnNB6o6r5/zOT
         GbeoE4VsBS22IZmU3o3ERZcFWR1bBvvqYHeoEh0JcHQ0y3PRp67ylDO3ieWC9VXq5PMD
         HsgG0WgZ9Vk9FMB8LEVGXsM3Cj4Tzz/6lFqgZrlTgR/joLp/dHr5rf7NRjdE2F28iTr0
         jLrM2gkAuDySNGXgfDswcAcO/8x5/jZz0Aq4JqGnGF4yU9sHRHdH+APOdpunsCNlUCnq
         ehbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cREv3rZvN4Yo/5YgjBmWEsOZvAdLXz7UPWWz2pKlQ9E=;
        b=Ec1YHrpEojvhteTFfzOaRSYcQk0f8FCmj2sbVwkYHurw50IdRNKJl/KecDply7FKYB
         TXL4XmPrqbsDk/VaEma7gOukyyq/c0pvbmMhozkzIAsUFGqlbu4Aa4BCPr6v0tQFjvxB
         Q/Y2QVv0btg9hpWRm5rmBQGZ8hDxoQFd76/8V/VGZNDULiZyHVTVUBO2kPg4mu1egGqe
         MBLjEBAQCLq9kqxWbHdWaJSZzepRgUPUh8Ct4ugG5CqI8k+GcL8+xnzve6RVWrOgbhi2
         BVX2MU0bs2KitI85BYLuQ1gO6bxzwg4RlwTIdCWaiyBylzsUjFN8KY+IrfFG90M+7lQJ
         IKjQ==
X-Gm-Message-State: AOAM533r89W8FLft9BLTlCQBCsNZLaAPBUzGb+SSXmgfMhzmskvp+5VO
        jqBO+gqk6JXJ8PpCn/7DLNQx1A==
X-Google-Smtp-Source: ABdhPJwvxt6/cEh1jwInQ9172/X1P+ZmWFDn2UVC6foDaqaig1JsByh1HsQke/oaidprcVkvcdQ1LQ==
X-Received: by 2002:a5d:9dc4:: with SMTP id 4mr37851090ioo.172.1594220049556;
        Wed, 08 Jul 2020 07:54:09 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k3sm14966359ils.8.2020.07.08.07.54.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 07:54:08 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        mb@lightnvm.io, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
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
 <20200708125805.GA16495@test-zns>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2962cd68-de34-89be-0464-8b102a3f1d0e@kernel.dk>
Date:   Wed, 8 Jul 2020 08:54:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200708125805.GA16495@test-zns>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/8/20 6:58 AM, Kanchan Joshi wrote:
> On Tue, Jul 07, 2020 at 04:37:55PM -0600, Jens Axboe wrote:
>> On 7/7/20 4:18 PM, Matthew Wilcox wrote:
>>> On Tue, Jul 07, 2020 at 02:40:06PM -0600, Jens Axboe wrote:
>>>>>> so we have another 24 bytes before io_kiocb takes up another cacheline.
>>>>>> If that's a serious problem, I have an idea about how to shrink struct
>>>>>> kiocb by 8 bytes so struct io_rw would have space to store another
>>>>>> pointer.
>>>>> Yes, io_kiocb has room. Cache-locality wise whether that is fine or
>>>>> it must be placed within io_rw - I'll come to know once I get to
>>>>> implement this. Please share the idea you have, it can come handy.
>>>>
>>>> Except it doesn't, I'm not interested in adding per-request type fields
>>>> to the generic part of it. Before we know it, we'll blow past the next
>>>> cacheline.
>>>>
>>>> If we can find space in the kiocb, that'd be much better. Note that once
>>>> the async buffered bits go in for 5.9, then there's no longer a 4-byte
>>>> hole in struct kiocb.
>>>
>>> Well, poot, I was planning on using that.  OK, how about this:
>>
>> Figured you might have had your sights set on that one, which is why I
>> wanted to bring it up upfront :-)
>>
>>> +#define IOCB_NO_CMPL		(15 << 28)
>>>
>>>  struct kiocb {
>>> [...]
>>> -	void (*ki_complete)(struct kiocb *iocb, long ret, long ret2);
>>> +	loff_t __user *ki_uposp;
>>> -	int			ki_flags;
>>> +	unsigned int		ki_flags;
>>>
>>> +typedef void ki_cmpl(struct kiocb *, long ret, long ret2);
>>> +static ki_cmpl * const ki_cmpls[15];
>>>
>>> +void ki_complete(struct kiocb *iocb, long ret, long ret2)
>>> +{
>>> +	unsigned int id = iocb->ki_flags >> 28;
>>> +
>>> +	if (id < 15)
>>> +		ki_cmpls[id](iocb, ret, ret2);
>>> +}
>>>
>>> +int kiocb_cmpl_register(void (*cb)(struct kiocb *, long, long))
>>> +{
>>> +	for (i = 0; i < 15; i++) {
>>> +		if (ki_cmpls[id])
>>> +			continue;
>>> +		ki_cmpls[id] = cb;
>>> +		return id;
>>> +	}
>>> +	WARN();
>>> +	return -1;
>>> +}
>>
>> That could work, we don't really have a lot of different completion
>> types in the kernel.
> 
> Thanks, this looks sorted.

Not really, someone still needs to do that work. I took a quick look, and
most of it looks straight forward. The only potential complication is
ocfs2, which does a swap of the completion for the kiocb. That would just
turn into an upper flag swap. And potential sync kiocb with NULL
ki_complete. The latter should be fine, I think we just need to reserve
completion nr 0 for being that.

-- 
Jens Axboe

