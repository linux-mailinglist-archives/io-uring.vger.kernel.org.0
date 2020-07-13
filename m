Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4BB221E202
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 23:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGMV0O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 17:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgGMV0N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 17:26:13 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A3FC061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 14:26:13 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id a12so15065798ion.13
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 14:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2lLTcCbzk0HyI+W/DXm25NeggkXrEiIUgF/iRb4LD3c=;
        b=g4iDoo5kY76WGsdI7xtzI4VfCQpTfE8zH9Y4Ws9uYOnLJE1Z/AtGUFmT1KE1ac4k+W
         OQv/cE4cNeb9pUTYbQYEI1+fRuq5gw7yA9Yb261i2sP9stqnBdaGV7gxVmfi0cD1gEuI
         e4CZY5BF5zKTVglxepLaq35DHKYKqEuTkX5OUbJNvuoERHjs2ytRBulBam3Mv3/h6dOc
         bRqvhHYvsGU3eRSiEaZwPT+2Ja1+o+b9V/In3KKuH/QHvJPxv+2S8AKimBr1eESdEsL0
         McxRBt58ynJIpXtcUVbKy6NFnv7Cvz8HoRcHddQmpRSAKKekab37QwKzgU+lv6soCkzn
         32kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2lLTcCbzk0HyI+W/DXm25NeggkXrEiIUgF/iRb4LD3c=;
        b=i7O5Dn3byzb6aff1s3k8lHvqGPf0VtkIvlw1PsqsQjP/NdUGVWUoP63ZfEhfrfcatQ
         KBdHlwo4lL14jNAlKz9NA0Z/dzrSYHrM19RlzDMqGCSJuu1BGF0rnkthz1UcvQXB/IEL
         OLXMGXXL+61ulpUNX+Ow0U9f4z1KpiUZHxC+SWS/+RIY0ZE8XxJC32SLiBwPGy88jQKE
         eEZsZrXeEgr94qezmY3bj06TZ1eryPpbtljk6pu1TijWkypQBE+Ougi76HIZVYLYdozL
         8nIGvnsOyoHGDIb4cFBwXZCXqe617dRHmrZ87oUUO+sOi+wu4tpul9Wa8Bpt6IFGoKmv
         Pn5w==
X-Gm-Message-State: AOAM531n5DHI7Pvge+ZNjFEZBCQBCaDpbNKAwUJE2RiScNbS8wNaXnJS
        cZoTJS+QUqeVZe4xuxz/Br0vjZxAVBUsrQ==
X-Google-Smtp-Source: ABdhPJwTQU6AgcERvaq06Hl0XKTfKPKeyucCJdCeKcdPdEbKY1A4ZmljSiBUVWscrBGPVPlqiMmTyA==
X-Received: by 2002:a05:6602:1555:: with SMTP id h21mr1699551iow.163.1594675572483;
        Mon, 13 Jul 2020 14:26:12 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i12sm3795425ioi.48.2020.07.13.14.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 14:26:11 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: follow **iovec idiom in io_import_iovec
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1594669730.git.asml.silence@gmail.com>
 <49c2ae6de356110544826092b5d08cb1927940ce.1594669730.git.asml.silence@gmail.com>
 <e3ac43ac-be8c-2812-1008-6a66542a2592@kernel.dk>
 <d14f8f12-7627-7afa-97f8-37f03a58715b@gmail.com>
 <b96292d5-5d07-fddd-69a8-25dbcc5af7da@kernel.dk>
 <ea4a93f5-9531-d328-8361-d59d2518a76b@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1613080c-3f5f-d382-f314-598d6ceb8da0@kernel.dk>
Date:   Mon, 13 Jul 2020 15:26:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ea4a93f5-9531-d328-8361-d59d2518a76b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/13/20 3:18 PM, Pavel Begunkov wrote:
> On 14/07/2020 00:16, Jens Axboe wrote:
>> On 7/13/20 3:12 PM, Pavel Begunkov wrote:
>>> On 14/07/2020 00:09, Jens Axboe wrote:
>>>> On 7/13/20 1:59 PM, Pavel Begunkov wrote:
>>>>> @@ -3040,8 +3040,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
>>>>>  		}
>>>>>  	}
>>>>>  out_free:
>>>>> -	if (!(req->flags & REQ_F_NEED_CLEANUP))
>>>>> -		kfree(iovec);
>>>>> +	kfree(iovec);
>>>>>  	return ret;
>>>>>  }
>>>>
>>>> Faster to do:
>>>>
>>>> if (iovec)
>>>> 	kfree(iovec)
>>>>
>>>> to avoid a stupid call. Kind of crazy, but I just verified with this one
>>>> as well that it's worth about 1.3% CPU in my stress test.
>>>
>>> That looks crazy indeed
>>
>> I suspect what needs to happen is that kfree should be something ala:
>>
>> static inline void kfree(void *ptr)
>> {
>> 	if (ptr)
>> 		__kfree(ptr);
>> }
>>
>> to avoid silly games like this. Needs to touch all three slab
>> allocators, though definitely in the trivial category.
> 
> Just thought the same, but not sure it's too common to have kfree(NULL).

Right, except the io_read/io_write path it'll be 100% common unless you
have more than the inline number of segments.

I see the same thing for eg the slab should_failslab() call, which isn't
inlined even if the kconfig isn't enabled. And for should_fail_bio()
as well. Those two add up to another ~1% or so of pointless overhead.

> The drop is probably because of extra call + cold jumps with unlikely().
> 
> void kfree() {
> 	trace_kfree(_RET_IP_, objp);
> 
> 	if (unlikely(ZERO_OR_NULL_PTR(objp)))
> 		return;
> }

Must be, since the kfree() one adds up to more than the two above ones
that are just the call itself.

-- 
Jens Axboe

