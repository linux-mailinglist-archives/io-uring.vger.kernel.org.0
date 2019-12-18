Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A139E1242EE
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 10:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbfLRJXt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 04:23:49 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39853 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfLRJXs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 04:23:48 -0500
Received: by mail-lj1-f193.google.com with SMTP id l2so1309828lja.6;
        Wed, 18 Dec 2019 01:23:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RH/3pIkBAM41IgPfuqR6bLwL0RxJ1F0qEqp81yR0S2c=;
        b=uiquEotPwT2i9ZvPw9+uymjy+avh2+xFagaE6JWlPs5tgDTa8EjzRkp43NHWEnrilw
         3uANIRKL93SLXp9Ok/h8xLxspV99nHVnYPWSwxxT/wkPXyed1s28jUePBLBH+wXfv46d
         ykNOe1v7aF8RsiFOB2xNYBRG8lFSdBduFXJA/93Il7KVRGweqW6yykJl6d/GpT3qCeNw
         jar/m69/QH3VRtuji4/PxgLtjDy7f2G/l1y4kuqtNJ/ePXUP4mRMmkc5glCjrXVDOt3n
         +TPGf9amwTOzdDgEwV0Kr/XgjAJaTyv0eLFvFsO8QkEKcWeA7YFpMkvdWuvcFm7i8VMc
         PBbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RH/3pIkBAM41IgPfuqR6bLwL0RxJ1F0qEqp81yR0S2c=;
        b=fTQo9D3aZsNehTEPI58cM96xHzcr/jnp0bEFigO3nR+oqHloIxDZzkjcxxUdelHfVd
         JagTWD5fGaIA5sx0a2iN4GIw9PH7wIJf79zJ6ejT9ES6kP/aJLsQSSv9L2Rj7bB6cct1
         rUXTOhOpvgNmqREZL/c6lwh0F/a04NtlN+Poqqe79/u2TiNcN9qI+uuH/4Vtxxfpyzwr
         lUTCkGpv7s9d63s3xozk0vQZO8SuXsLw4YAjI1OrP/5hSyLdpsBXiD321h3Nqbde66zr
         IrwZv3nll6iojXHh7vEiEhY/xxKn7er/7ESCUs/tjTQCphDVEssI/lCzu26k3gD0Ydqs
         lo/w==
X-Gm-Message-State: APjAAAWXKNbrDXz1TxidGdrNcRW7+fZkFToFGA8a9V5fTlGwoh+6hSPT
        Qc3a6kMq0pVWJC1ArAzpKslwPmuZTMM=
X-Google-Smtp-Source: APXvYqwmUSAsIaYzl1SPa390TP+ZYiYJdPeV5kopgthsZvzdXsYS8Ti61sC2L8IZiOoSm/sAi2+c8A==
X-Received: by 2002:a2e:9e03:: with SMTP id e3mr1007538ljk.186.1576661025860;
        Wed, 18 Dec 2019 01:23:45 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id p15sm772056lfo.88.2019.12.18.01.23.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 01:23:45 -0800 (PST)
Subject: Re: [PATCH 2/2] io_uring: batch getting pcpu references
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576621553.git.asml.silence@gmail.com>
 <b72c5ec7f6d9a9881948de6cb88d30cc5e0354e9.1576621553.git.asml.silence@gmail.com>
 <e54d77e4-9357-cb9e-9d06-d96b24f49a44@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <161c01e5-d007-af45-c6a5-ccebf1e00533@gmail.com>
Date:   Wed, 18 Dec 2019 12:23:43 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <e54d77e4-9357-cb9e-9d06-d96b24f49a44@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/18/2019 2:21 AM, Jens Axboe wrote:
> On 12/17/19 3:28 PM, Pavel Begunkov wrote:
>> percpu_ref_tryget() has its own overhead. Instead getting a reference
>> for each request, grab a bunch once per io_submit_sqes().
>>
>> basic benchmark with submit and wait 128 non-linked nops showed ~5%
>> performance gain. (7044 KIOPS vs 7423)
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>
>> For notice: it could be done without @extra_refs variable,
>> but looked too tangled because of gotos.
>>
>>
>>  fs/io_uring.c | 11 ++++++++---
>>  1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index cf4138f0e504..6c85dfc62224 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -845,9 +845,6 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
>>  	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
>>  	struct io_kiocb *req;
>>  
>> -	if (!percpu_ref_tryget(&ctx->refs))
>> -		return NULL;
>> -
>>  	if (!state) {
>>  		req = kmem_cache_alloc(req_cachep, gfp);
>>  		if (unlikely(!req))
>> @@ -3929,6 +3926,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>>  	struct io_submit_state state, *statep = NULL;
>>  	struct io_kiocb *link = NULL;
>>  	int i, submitted = 0;
>> +	unsigned int extra_refs;
>>  	bool mm_fault = false;
>>  
>>  	/* if we have a backlog and couldn't flush it all, return BUSY */
>> @@ -3941,6 +3939,10 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>>  		statep = &state;
>>  	}
>>  
>> +	if (!percpu_ref_tryget_many(&ctx->refs, nr))
>> +		return -EAGAIN;
>> +	extra_refs = nr;
>> +
>>  	for (i = 0; i < nr; i++) {
>>  		struct io_kiocb *req = io_get_req(ctx, statep);
>>  
>> @@ -3949,6 +3951,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>>  				submitted = -EAGAIN;
>>  			break;
>>  		}
>> +		--extra_refs;
>>  		if (!io_get_sqring(ctx, req)) {
>>  			__io_free_req(req);
>>  			break;
>> @@ -3976,6 +3979,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>>  		io_queue_link_head(link);
>>  	if (statep)
>>  		io_submit_state_end(&state);
>> +	if (extra_refs)
>> +		percpu_ref_put_many(&ctx->refs, extra_refs);
> 
> Might be cleaner to introduce a 'ret' variable, and leave submitted to be just
> that, the number submitted. Then you could just do:
> 
> if (submitted != nr)
> 	percpu_ref_put_many(&ctx->refs, nr - submitted);
> 
> and not need that weird extra_refs.
> 
That won't work as is, because  __io_free_req() after io_get_sqring()
puts a ref. And that's the reason why --extra_refs; placed in between
those 2 if's. Also, percpu_ref_put_many() is inline, so I want to have
only 1 call site.

I'll send another version, which won't even need the "if" at the end,
but is more knotty.

-- 
Pavel Begunkov
