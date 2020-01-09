Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB87135C69
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2020 16:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730484AbgAIPRh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jan 2020 10:17:37 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37385 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbgAIPRh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jan 2020 10:17:37 -0500
Received: by mail-lf1-f65.google.com with SMTP id b15so5466077lfc.4
        for <io-uring@vger.kernel.org>; Thu, 09 Jan 2020 07:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=DvjqJsrUewdB0onGr0piK28Cj0HbKzuA+KOck2+TkyI=;
        b=WoqNr6TSbHjblpBtHmldI59gmLRRE+R1UVSgaORrL8imaOogMHNcs3djV/wyAG6cYb
         F20iikJTGmePPeDPDxHsAseRDiAqQW/LLTgx18uZWegmVwti85gtPFdq/gIKrhZQt/MR
         7g5eHbmy//iCA6gyvKXP2rVXRG3cm5miQMECVLgH0Jw6H9niplxLdVb5fgZxoKN3iz5F
         q51xonyM5ZdV2nivF7UPmBXBSJuqqehb4UnQabRYuonU0rTMhYjHTwUzivz1TQbZDHVC
         Mp89Joothip6rxXe3FL1/cfqBVbKywFULTQo4R0XaNtA9ocVa2ir/zXCnzG+MQk6Gvbn
         DaYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DvjqJsrUewdB0onGr0piK28Cj0HbKzuA+KOck2+TkyI=;
        b=rpXY7R49wBi0rMtfhapJSlX26OnKWjd4ZgZ28VtlJKlJ76FhPgekhiLsd9k2clNIXB
         96T6SL6BASNxLvDyBAorf1ajgEocbISQKc/pfYr15uwlGa9l1z4TOE0SXW0m/R3aSjZB
         voaqVZEMXXbAEyI+zPwsRaM23gsIvLernI60ai4p6RQbtBAzO9BFuIv/N4tVs2a/aeO8
         1TMJE5/75utCEi2yGwTtuUUgP8ao5S924UNye+nVJf+YDBstA6OK+zbWUC2awrsUkI9h
         T2mX/8wb8rw3ChMnM/neUhrgqegH8k+ztHq5Y8mjVVaUhj1DF+y5aCOr3ckbr5sfU9Sh
         09gQ==
X-Gm-Message-State: APjAAAXMTHYXhi2Eftkk05t6p4I0KuGbnh959ELPiEVM5ghyGuR6qVTI
        55Z34K5eLrDVNZB/5B8hOPAXVTFDvP8=
X-Google-Smtp-Source: APXvYqwbtP4qHtZFkd5pw99sqJuMsgnJFXDpni+ObbQw3J3P9Pv559WRQdTYv/6ROdfT3t7aNDE/Gw==
X-Received: by 2002:a19:84d:: with SMTP id 74mr6437403lfi.122.1578583054718;
        Thu, 09 Jan 2020 07:17:34 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id u9sm3169146lji.49.2020.01.09.07.17.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 07:17:34 -0800 (PST)
Subject: Re: [RFC] Check if file_data is initialized
To:     Jens Axboe <axboe@kernel.dk>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        io-uring@vger.kernel.org
References: <20200109131750.30468-1-9erthalion6@gmail.com>
 <e6cd2afe-565f-8cde-652c-26c52b888962@gmail.com>
 <07aeb2b5-b459-746b-30a2-b63550b288df@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <73e00d5c-e36e-6614-9de1-19978efd7e61@gmail.com>
Date:   Thu, 9 Jan 2020 18:17:32 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <07aeb2b5-b459-746b-30a2-b63550b288df@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/9/2020 5:51 PM, Jens Axboe wrote:
> On 1/9/20 7:26 AM, Pavel Begunkov wrote:
>> On 1/9/2020 4:17 PM, Dmitrii Dolgov wrote:
>>> With combination of --fixedbufs and an old version of fio I've managed
>>> to get a strange situation, when doing io_iopoll_complete NULL pointer
>>> dereference on file_data was caused in io_free_req_many. Interesting
>>> enough, the very same configuration doesn't fail on a newest version of
>>> fio (the old one is fc220349e4514, the new one is 2198a6b5a9f4), but I
>>> guess it still makes sense to have this check if it's possible to craft
>>> such request to io_uring.
>>
>> I didn't looked up why it could become NULL in the first place, but the
>> problem is probably deeper.
>>
>> 1. I don't see why it puts @rb->to_free @file_data->refs, even though
>> there could be non-fixed reqs. It needs to count REQ_F_FIXED_FILE reqs
>> and put only as much.
> 
> Agree on the fixed file refs, there's a bug there where it assumes they
> are all still fixed. See below - Dmitrii, use this patch for testing
> instead of the other one!
> 
>> 2. Jens, there is another line bothering me, could you take a look?
>>
>> io_free_req_many()
>> {
>> ...
>> 	if (req->flags & REQ_F_INFLIGHT) ...;
>> 	else
>> 		rb->reqs[i] = NULL;
>> ...
>> }
>>
>> It zeroes rb->reqs[i], calls __io_req_aux_free(), but did not free
>> memory for the request itself. Is it as intended?
> 
> We free them at the end of that function, in bulk. But we can't do that
> with the aux data.

Right, we can't do that with the aux data. But we NULL a req in the
array, which then passed to kmem_cache_free_bulk(). So, it won't be
visible to the *_free_bulk(). Am I missing something?

e.g.
1. initial reqs [req1 with files, ->io, etc]
2. set to NULL, so [NULL]
3. __io_req_aux_free(req)
4. bulk_free([NULL]);

> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 32aee149f652..b5dcf6c800ef 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1218,6 +1218,8 @@ struct req_batch {
>  
>  static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
>  {
> +	int fixed_refs = 0;
> +

If all are fixed, then @rb->need_iter == false (see
io_req_multi_free()), and @fixed_refs will be left 0. How about to set
it to rb->to_free, and zero+count for rb->need_iter == true?

>  	if (!rb->to_free)
>  		return;
>  	if (rb->need_iter) {
> @@ -1227,8 +1229,10 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
>  		for (i = 0; i < rb->to_free; i++) {
>  			struct io_kiocb *req = rb->reqs[i];
>  
> -			if (req->flags & REQ_F_FIXED_FILE)
> +			if (req->flags & REQ_F_FIXED_FILE) {
>  				req->file = NULL;
> +				fixed_refs++;
> +			}
>  			if (req->flags & REQ_F_INFLIGHT)
>  				inflight++;
>  			else
> @@ -1255,8 +1259,9 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
>  	}
>  do_free:
>  	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
> +	if (fixed_refs)
> +		percpu_ref_put_many(&ctx->file_data->refs, fixed_refs);
>  	percpu_ref_put_many(&ctx->refs, rb->to_free);
> -	percpu_ref_put_many(&ctx->file_data->refs, rb->to_free);
>  	rb->to_free = rb->need_iter = 0;
>  }
> 

-- 
Pavel Begunkov
