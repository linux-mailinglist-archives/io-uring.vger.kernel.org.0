Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9101218A95
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 16:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgGHO7x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 10:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729921AbgGHO7x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 10:59:53 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495CAC08C5DC
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 07:59:53 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id o3so21934259ilo.12
        for <io-uring@vger.kernel.org>; Wed, 08 Jul 2020 07:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tOY5WWCurwXjUIdxuXnE2O00KAaJIFSGqD8NNrWHd48=;
        b=J6Mu+tQo2VKTqNJY50vJGPEqgC2Hv2aO92KQYyUke8OoZ31C2NM3Uy7BOsMKJ19i+b
         FsZ+fS8EG0HEEzm9wMnX/88vLlZrLyIwGfMVOomLJO6ZuTg6C4UC/1jA5DqgJ79OuKWh
         wDtqW0c3HvdgHjm4+ZPTC653WUHfhOwIxvkevNULcfj8BacfLzKL9G9TfHZNt0NBcnzI
         2Wn1MTlzuFtMvQ9TcRRYi4oLArSc26gYcZOvwMSNZbipCBe1WQYV4tU6G0g5BPXX+pTq
         mtp2eou8bi3zeegoHKAZ1DbCm4/m4ExV1/lw+3CVBjqu47X75ckXC+LMgE2TuA+7YCGZ
         FQ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tOY5WWCurwXjUIdxuXnE2O00KAaJIFSGqD8NNrWHd48=;
        b=CO7P3eDGqTi4xguHspz+Rw/AzjXz5PJudM+LfjPcMukDNO1EhRVDncUg7CmhH8OE5M
         pbvRIc7aECAm/bogwTv2tnLGtafjWWu4L0sJsVJqOeHrAYkJjIsYYKw+Wo9/cZgqJc39
         Txfqs7y/4ArcSjtz078LFuhAtyrWnw0g9gdEK83fcKYQgpJ19qNkjQTsT6NQRQs922/L
         fHbLXT1W4YwcX6W9Q+R+kdaMHjhbBJcUh2QAXrnkBbPCKP4YAPGE5Qwgmvann15ZztHT
         1B1Owl/vyXD/XbDQN63vlDNEI5lwMfYsuIZLAagY/3wTIYYsIbV7D+9TTOL4Z8G8jsdD
         /UXg==
X-Gm-Message-State: AOAM530cukM55LZpP8j+auWYLWBlNYuk3dTt/AcdQ+etNNYWERuJUZbl
        3OTcQDlgqwaJyBuwa1qTE9bR5U9A/OOLkw==
X-Google-Smtp-Source: ABdhPJzW1SMwnOLpN7lFVQUfbRGF1gkxnasd9s/n2z/WxcfCHkKq5ESuknHV13j9k73vJICdlC1Zlg==
X-Received: by 2002:a92:d6d2:: with SMTP id z18mr40514146ilp.272.1594220392530;
        Wed, 08 Jul 2020 07:59:52 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m16sm13933887ili.26.2020.07.08.07.59.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 07:59:51 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        mb@lightnvm.io, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <20200706143208.GA25523@casper.infradead.org>
 <20200707151105.GA23395@test-zns>
 <20200707155237.GM25523@casper.infradead.org>
 <20200707202342.GA28364@test-zns>
 <7a44d9c6-bf7d-0666-fc29-32c3cba9d1d8@kernel.dk>
 <20200707221812.GN25523@casper.infradead.org>
 <CGME20200707223803epcas5p41814360c764d6b5f67fdbf173a8ba64e@epcas5p4.samsung.com>
 <145cc0ad-af86-2d6a-78b3-9ade007aae52@kernel.dk>
 <20200708125805.GA16495@test-zns>
 <2962cd68-de34-89be-0464-8b102a3f1d0e@kernel.dk>
 <20200708145826.GS25523@casper.infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b1c58211-496a-ed85-a9bb-0d0cc56e250c@kernel.dk>
Date:   Wed, 8 Jul 2020 08:59:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200708145826.GS25523@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/8/20 8:58 AM, Matthew Wilcox wrote:
> On Wed, Jul 08, 2020 at 08:54:07AM -0600, Jens Axboe wrote:
>> On 7/8/20 6:58 AM, Kanchan Joshi wrote:
>>>>> +#define IOCB_NO_CMPL		(15 << 28)
>>>>>
>>>>>  struct kiocb {
>>>>> [...]
>>>>> -	void (*ki_complete)(struct kiocb *iocb, long ret, long ret2);
>>>>> +	loff_t __user *ki_uposp;
>>>>> -	int			ki_flags;
>>>>> +	unsigned int		ki_flags;
>>>>>
>>>>> +typedef void ki_cmpl(struct kiocb *, long ret, long ret2);
>>>>> +static ki_cmpl * const ki_cmpls[15];
>>>>>
>>>>> +void ki_complete(struct kiocb *iocb, long ret, long ret2)
>>>>> +{
>>>>> +	unsigned int id = iocb->ki_flags >> 28;
>>>>> +
>>>>> +	if (id < 15)
>>>>> +		ki_cmpls[id](iocb, ret, ret2);
>>>>> +}
>>>>>
>>>>> +int kiocb_cmpl_register(void (*cb)(struct kiocb *, long, long))
>>>>> +{
>>>>> +	for (i = 0; i < 15; i++) {
>>>>> +		if (ki_cmpls[id])
>>>>> +			continue;
>>>>> +		ki_cmpls[id] = cb;
>>>>> +		return id;
>>>>> +	}
>>>>> +	WARN();
>>>>> +	return -1;
>>>>> +}
>>>>
>>>> That could work, we don't really have a lot of different completion
>>>> types in the kernel.
>>>
>>> Thanks, this looks sorted.
>>
>> Not really, someone still needs to do that work. I took a quick look, and
>> most of it looks straight forward. The only potential complication is
>> ocfs2, which does a swap of the completion for the kiocb. That would just
>> turn into an upper flag swap. And potential sync kiocb with NULL
>> ki_complete. The latter should be fine, I think we just need to reserve
>> completion nr 0 for being that.
> 
> I was reserving completion 15 for that ;-)
> 
> +#define IOCB_NO_CMPL		(15 << 28)
> ...
> +	if (id < 15)
> +		ki_cmpls[id](iocb, ret, ret2);
> 
> Saves us one pointer in the array ...

That works. Are you going to turn this into an actual series of patches,
adding the functionality and converting users?

-- 
Jens Axboe

