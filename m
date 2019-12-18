Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 314271242FE
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 10:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfLRJZT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 04:25:19 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35904 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfLRJZS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 04:25:18 -0500
Received: by mail-lj1-f193.google.com with SMTP id r19so1323786ljg.3;
        Wed, 18 Dec 2019 01:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=PLKwWIuTZDD+oQG31GvMuL5TYzCyN5KNCo0T2Wy+cds=;
        b=TfMoo8Xu+y+B+rq8CeEVgYOMWYrTQhV24sb8yvWhXilZIZxPeVoV1j+TgShyAmjRHD
         3qfEI0uYZjr4KKhJS/G0i4+YDv0SmICaGCVDXmOqvtRymMjsNdAMzXhgouyEkdMyqyO1
         EVuX347NJcAyyv52jPidJnzTi0KapVzmsOY8pd9bSCXTys4x4QZ1y9jcMRK8PoTyr3yw
         QpTejkC+a7NgNUDiGBKZhyOrDBjb4Hhu3M4rSBmOMmb806EZYd7G49vhQFIf0nDArbiH
         G6RXjdjFUxXepIvedrukBdwLHTrQD0d5LmtjsYcHTG5hdbaghoUmXsy4y1bw9jv919ft
         hDfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PLKwWIuTZDD+oQG31GvMuL5TYzCyN5KNCo0T2Wy+cds=;
        b=f+wOwcZ1be7lfHs0mkh4VPi4ECxRQo+zJAUvm20O8kHTs8I9oZ6UnA0+B2g8R7v2Xy
         F4jnt6JBGbPgYX5sZx8rFOWUqTaI0P6YtFV8bc0dhDlEB7PE112agJbyl1VKP00O9rmZ
         pAz0xppxDJau4a2QGJdmx0BG1Sd4z6PGjcNuTkosMnPsQcIwLT3JRNKhUxgGx7Sr/sOf
         BEqpWHCiCK5/l0Iq56te3x1vK1S76SZZSYb/nxbASXC9KZRB8Ih0CbFG9JjAUyZC3vdi
         cu9n2JWtXfN3jJbxEY3lcatSwWkEdKQiFhYU8UG0EDGw4iz0i5H6W4q8i8LBGHeiOL+h
         ivgA==
X-Gm-Message-State: APjAAAUOAu1vILEEPTtLcLKvAhIxmnTNDlrcw/uV2WM8nx3l+vY3DlBl
        jLOVgI7rf9xZARNF2cCfVUj9HMT62Y4=
X-Google-Smtp-Source: APXvYqzEd8z2QVSjJ9ymLRW7TE86+BRX0V+GQzH6a73ToOSO1dp9ZdoBwixCaIgv+9Uh6LSxQjYpqQ==
X-Received: by 2002:a2e:84d0:: with SMTP id q16mr970913ljh.138.1576661116588;
        Wed, 18 Dec 2019 01:25:16 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id q14sm761785ljm.68.2019.12.18.01.25.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 01:25:16 -0800 (PST)
Subject: Re: [PATCH 2/2] io_uring: batch getting pcpu references
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576621553.git.asml.silence@gmail.com>
 <b72c5ec7f6d9a9881948de6cb88d30cc5e0354e9.1576621553.git.asml.silence@gmail.com>
 <e54d77e4-9357-cb9e-9d06-d96b24f49a44@kernel.dk>
 <6f29aacb-a067-fc9d-5625-0625557be2e1@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <bc774cca-00ae-1a31-1f34-d223f45455e8@gmail.com>
Date:   Wed, 18 Dec 2019 12:25:15 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <6f29aacb-a067-fc9d-5625-0625557be2e1@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/18/2019 2:31 AM, Jens Axboe wrote:
> On 12/17/19 4:21 PM, Jens Axboe wrote:
>> On 12/17/19 3:28 PM, Pavel Begunkov wrote:
>>> percpu_ref_tryget() has its own overhead. Instead getting a reference
>>> for each request, grab a bunch once per io_submit_sqes().
>>>
>>> basic benchmark with submit and wait 128 non-linked nops showed ~5%
>>> performance gain. (7044 KIOPS vs 7423)
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>
>>> For notice: it could be done without @extra_refs variable,
>>> but looked too tangled because of gotos.
>>>
>>>
>>>  fs/io_uring.c | 11 ++++++++---
>>>  1 file changed, 8 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index cf4138f0e504..6c85dfc62224 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -845,9 +845,6 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
>>>  	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
>>>  	struct io_kiocb *req;
>>>  
>>> -	if (!percpu_ref_tryget(&ctx->refs))
>>> -		return NULL;
>>> -
>>>  	if (!state) {
>>>  		req = kmem_cache_alloc(req_cachep, gfp);
>>>  		if (unlikely(!req))
>>> @@ -3929,6 +3926,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>>>  	struct io_submit_state state, *statep = NULL;
>>>  	struct io_kiocb *link = NULL;
>>>  	int i, submitted = 0;
>>> +	unsigned int extra_refs;
>>>  	bool mm_fault = false;
>>>  
>>>  	/* if we have a backlog and couldn't flush it all, return BUSY */
>>> @@ -3941,6 +3939,10 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>>>  		statep = &state;
>>>  	}
>>>  
>>> +	if (!percpu_ref_tryget_many(&ctx->refs, nr))
>>> +		return -EAGAIN;
>>> +	extra_refs = nr;
>>> +
>>>  	for (i = 0; i < nr; i++) {
>>>  		struct io_kiocb *req = io_get_req(ctx, statep);
>>>  
> 
> This also needs to come before the submit_state_start().
> 
Good catch, forgot to handle this. Thanks

> I forgot to mention that I really like the idea, no point in NOT batching
> the refs when we know exactly how many refs we need.
> 

-- 
Pavel Begunkov
