Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58F6E135CD6
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2020 16:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgAIPcv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jan 2020 10:32:51 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41544 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbgAIPcv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jan 2020 10:32:51 -0500
Received: by mail-lj1-f194.google.com with SMTP id h23so7674464ljc.8
        for <io-uring@vger.kernel.org>; Thu, 09 Jan 2020 07:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MB81QrjZekm8whqT+u445YAdxon+0x8KlSRDGhkq69U=;
        b=dSl1OO1CQJxtVY8s5K16mJOVod1r2IIsePuD1TcWoTX6IdiS/9dTHr3zclnxklCMJ/
         gvZf8KQxNu+N28VSrFjj7xOmhKoSmjOhJ+1Bs/WMi6KZxIX8awAtcE9sfJ9NmDDZ0tTY
         XVlydshiIOZBjxEu7Lmp31SJuWeYseF/5FwkGMULXKgUanGLUNtOVeIZU1+z02HUIq88
         Ji05HrBzLHHXkjsENiJBVfBDBv5jkYZjNvUwmG3ZekoT4Blow/svCAcnQPkFzwDJBZs2
         ZTt0wD3+RYvnf5dytSxJTB5NBPN/P3Z3dasjpENMs184k+8GuqpNqW7W1R0DsHD9cwpQ
         xWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MB81QrjZekm8whqT+u445YAdxon+0x8KlSRDGhkq69U=;
        b=sRzBXdPefrLDBi0dAYqkVKg3HqqbrHXR7U2U7fahwBvHPNOA9oAoMmcUKtSvfdOpHt
         tt2Wl+YaETqt73PWDuje+Ym/zm1NIwePbidzJJGvTOoPIjjlSJ4r64Vpz4/wzFIskloA
         2tTvtY/CIb2JVDiEnuZiW8jQZjYdZc+BGOHpGbc8hENLIGqySPE8DXvRLw/YAXI49YWf
         81OuYfrjIfF8mYaNduiCI3sNJFHmSiJFXvDaXOVpDdfURj1A2j0i/6URxtQJ9ovDObsu
         sgAqKhj77FRdqceq5kGXD8ggeV+9EteDgoHTf4xUxsqEFH/5FZKu8OnAashsl8qIqHj5
         PWwg==
X-Gm-Message-State: APjAAAVQ+FsXvHEQZjZKvBmNtentZ30nf9XGrOaB1w1+HqZ1Yt6cpKg8
        dIh3A+kL4gLjvSeBYda07ze4z8CDdOQ=
X-Google-Smtp-Source: APXvYqz5SmEyX99kitenHNNn3xEmnBeqoDRSRXCtt6gRR7lrNnlxIXGVpvIKjwyP3CoaF3duNOS81Q==
X-Received: by 2002:a2e:8e22:: with SMTP id r2mr7033198ljk.51.1578583968684;
        Thu, 09 Jan 2020 07:32:48 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id r9sm3498500lfc.72.2020.01.09.07.32.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 07:32:47 -0800 (PST)
Subject: Re: [RFC] Check if file_data is initialized
To:     Jens Axboe <axboe@kernel.dk>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        io-uring@vger.kernel.org
References: <20200109131750.30468-1-9erthalion6@gmail.com>
 <e6cd2afe-565f-8cde-652c-26c52b888962@gmail.com>
 <07aeb2b5-b459-746b-30a2-b63550b288df@kernel.dk>
 <73e00d5c-e36e-6614-9de1-19978efd7e61@gmail.com>
 <e44a3ebd-5f4a-ff7b-7c42-e1b5710a4edd@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <04eeb8a8-809e-a417-860b-afd06bb05f2c@gmail.com>
Date:   Thu, 9 Jan 2020 18:32:46 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <e44a3ebd-5f4a-ff7b-7c42-e1b5710a4edd@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/9/2020 6:23 PM, Jens Axboe wrote:
> On 1/9/20 8:17 AM, Pavel Begunkov wrote:
>> On 1/9/2020 5:51 PM, Jens Axboe wrote:
>>> On 1/9/20 7:26 AM, Pavel Begunkov wrote:
>>>> On 1/9/2020 4:17 PM, Dmitrii Dolgov wrote:
>>>>> With combination of --fixedbufs and an old version of fio I've managed
>>>>> to get a strange situation, when doing io_iopoll_complete NULL pointer
>>>>> dereference on file_data was caused in io_free_req_many. Interesting
>>>>> enough, the very same configuration doesn't fail on a newest version of
>>>>> fio (the old one is fc220349e4514, the new one is 2198a6b5a9f4), but I
>>>>> guess it still makes sense to have this check if it's possible to craft
>>>>> such request to io_uring.
>>>>
>>>> I didn't looked up why it could become NULL in the first place, but the
>>>> problem is probably deeper.
>>>>
>>>> 1. I don't see why it puts @rb->to_free @file_data->refs, even though
>>>> there could be non-fixed reqs. It needs to count REQ_F_FIXED_FILE reqs
>>>> and put only as much.
>>>
>>> Agree on the fixed file refs, there's a bug there where it assumes they
>>> are all still fixed. See below - Dmitrii, use this patch for testing
>>> instead of the other one!
>>>
>>>> 2. Jens, there is another line bothering me, could you take a look?
>>>>
>>>> io_free_req_many()
>>>> {
>>>> ...
>>>> 	if (req->flags & REQ_F_INFLIGHT) ...;
>>>> 	else
>>>> 		rb->reqs[i] = NULL;
>>>> ...
>>>> }
>>>>
>>>> It zeroes rb->reqs[i], calls __io_req_aux_free(), but did not free
>>>> memory for the request itself. Is it as intended?
>>>
>>> We free them at the end of that function, in bulk. But we can't do that
>>> with the aux data.
>>
>> Right, we can't do that with the aux data. But we NULL a req in the
>> array, which then passed to kmem_cache_free_bulk(). So, it won't be
>> visible to the *_free_bulk(). Am I missing something?
>>
>> e.g.
>> 1. initial reqs [req1 with files, ->io, etc]
>> 2. set to NULL, so [NULL]
>> 3. __io_req_aux_free(req)
>> 4. bulk_free([NULL]);
> 
> Yeah that looks wrong, I don't think you're missing something. We
> should just use the flags check again. I'll double check this in
> testing now.

Great, thanks!

BTW, if by any chance you missed it, there was another comment in my
previous mail regarding your fix for the put problem.

> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 49622a320317..d7a77830a2f2 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1235,8 +1235,6 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
>  			}
>  			if (req->flags & REQ_F_INFLIGHT)
>  				inflight++;
> -			else
> -				rb->reqs[i] = NULL;
>  			__io_req_aux_free(req);
>  		}
>  		if (!inflight)
> @@ -1246,7 +1244,7 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
>  		for (i = 0; i < rb->to_free; i++) {
>  			struct io_kiocb *req = rb->reqs[i];
>  
> -			if (req) {
> +			if (req->flags & REQ_F_INFLIGHT)
>  				list_del(&req->inflight_entry);
>  				if (!--inflight)
>  					break;
> 

-- 
Pavel Begunkov
