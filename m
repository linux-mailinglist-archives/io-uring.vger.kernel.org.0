Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A61BD123ACC
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 00:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfLQXbq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 18:31:46 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35469 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfLQXbq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 18:31:46 -0500
Received: by mail-pj1-f67.google.com with SMTP id s7so82781pjc.0
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 15:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=cDR6dB5iHTX3mAZkKGzaI63EdL/MxGLZ2WcpfIyLM9I=;
        b=OQ7guJUdx6GhP94QWJyRDRg4/0+6a/DZj1bDlPSx29RmJembu2CSzW9xPZ47HHDupZ
         vnXqpZrXpU1jVSJ6r2txfDkPJarb2qGJfgto2g8KvD9r7MoTcljSeCKPd/11nd2ad51o
         Z/0XvhnjB1nnmh9apoDVnFoahxxZ+VyErkdREc4MmuIwMHZs8P/xhYFuNKL/nmJBHOK6
         YxTyH954288aWL1CVRf4Jwj5tXgF0wRnB1qweC5y3EFZ2gwCSNj5d/SOKw+pDAJsHNvd
         AoIVoxlsmAXego86v6PkUgatV0iFgITHCuuViefOxZ0oy4sNUPBfHOYZKEsLzewnNnSu
         e22A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cDR6dB5iHTX3mAZkKGzaI63EdL/MxGLZ2WcpfIyLM9I=;
        b=Aew7OMWjCz8hnDJTKeg5ybfcff9DtmsQBywUQhDoaKT5vXCuykxkxPPM1n2PoAsZRz
         ETJH4iZ0rBFRIWGE9e/NOpeBoyBI+rT+8djDjI2cE6Vvxhrk72l/MWhA/zbGl3crLL0W
         +q2DZQG9xt7rLwvRFPd/8KRksrTfz+ZIU/yanXl+tTzSZ80WpHEfHvuVAcTo6qscBvd3
         uvUe//keytq/ByWIyLeeMij+Qhlakh6wuE8exfHTF/S98xONodteafBKHELDYrZi1Tdy
         ZR/v+udVQsyKkWWhx0gqvlCNQ32bPfzoiaSAsHcGXLRLWrlEbay9gRJ7YOygwdyo33z5
         1oIA==
X-Gm-Message-State: APjAAAVLaSMBp6AuO3juEAbs8BzkaaCfHKdvRvCpLQ6P/K3BWNgshUIY
        PiyBS0K0P8W2YFvRq3w6012w0Q==
X-Google-Smtp-Source: APXvYqxLO1fHh/2I7vcDoXQtDrPaOaQv1joybrHHoj0vl9q+mGObuWZh16p2OsNK99e+M/7WhG+1HA==
X-Received: by 2002:a17:90b:d85:: with SMTP id bg5mr2665pjb.99.1576625505378;
        Tue, 17 Dec 2019 15:31:45 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1131::13f4? ([2620:10d:c090:180::6446])
        by smtp.gmail.com with ESMTPSA id o7sm124164pfg.138.2019.12.17.15.31.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 15:31:44 -0800 (PST)
Subject: Re: [PATCH 2/2] io_uring: batch getting pcpu references
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576621553.git.asml.silence@gmail.com>
 <b72c5ec7f6d9a9881948de6cb88d30cc5e0354e9.1576621553.git.asml.silence@gmail.com>
 <e54d77e4-9357-cb9e-9d06-d96b24f49a44@kernel.dk>
Message-ID: <6f29aacb-a067-fc9d-5625-0625557be2e1@kernel.dk>
Date:   Tue, 17 Dec 2019 16:31:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <e54d77e4-9357-cb9e-9d06-d96b24f49a44@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/17/19 4:21 PM, Jens Axboe wrote:
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

This also needs to come before the submit_state_start().

I forgot to mention that I really like the idea, no point in NOT batching
the refs when we know exactly how many refs we need.

-- 
Jens Axboe

