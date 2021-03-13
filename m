Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282A133A0F0
	for <lists+io-uring@lfdr.de>; Sat, 13 Mar 2021 21:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbhCMUOX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 Mar 2021 15:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbhCMUNx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 Mar 2021 15:13:53 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB98C061574
        for <io-uring@vger.kernel.org>; Sat, 13 Mar 2021 12:13:53 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id s21so4149235pfm.1
        for <io-uring@vger.kernel.org>; Sat, 13 Mar 2021 12:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1WGMhdpP5vC/vC8w/IDbadIoGw0+QQTDeEGENrN60I4=;
        b=JyCztF/Gb925MHcJgpUKuIxOcB6LE7iutHrzOtyb3PWhHufC9jBG2LuXlcm+FJ8HfT
         C1XBFsfluwY/e6Nkzx43NoTSyAWWa83zMZmxtqjDZJrpAdjMM1zkwDhs0XmCI/rcohPo
         bK4bkqggaOSCT3ZfNc7HHdycJ2QpvpBiPJGiY4VHtYXZgDFZXVQog/hNPDgf8vARCyut
         slYDlHj57r+gAR0f71Wvvfnfb70pMjXrANItiFZJS8Jz80M6d/iaKgCC41X/LhOi7dpl
         j9BjXZcQYC3gy17RwFUX+uOz0DwVWkYH5iL7Yglz+3xjX+iMwlSLC6j1aE9UOUcYIP3z
         726A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1WGMhdpP5vC/vC8w/IDbadIoGw0+QQTDeEGENrN60I4=;
        b=nOYKuSZ5Eh1ZfANgcR6/opTBGT3MURPTNYCXX3K69Jogcwnaanfk87b3/mgjffCqc2
         dxZQ+CzeJVZLOR9Sjbfttq5V8AlqQVbmEONX0/KcXn4tOQsghUq6uVitl/dp2h8JmZy/
         GXSb2TPi8N8IfvCsvBSzXTc6vaJhU+YT3RuadDk/5/yiJvBbbClZkQEhbuxYD9UfZb3N
         CVsrtvsTvAi/CMNoRv8rXsYa6U3XEwiM88aA7l2j9FpRJpazFvQdaVjEvrqErqu9tnNi
         hhYds4GLGvLPNqwwVSKXD6zbfkkC5GCO/rtR+8j1m9+b3rvlkmvXJ8aFsB1tqqFYJ3MV
         3/5Q==
X-Gm-Message-State: AOAM532bhLZPYERA6Jyn7vOvOPlUqUrWLqi8QlvDu3Wtpw23mKv0P5Gp
        rAWnNl0kUqBdrVU1BHn0iN/rbOkOa0pKgw==
X-Google-Smtp-Source: ABdhPJykybBDXIw7p/9jz70KCsyii5YZIEyoOB3eQjkQpmK/YNruKTPvB1TZBhupDAGF8EJxU/mAvA==
X-Received: by 2002:aa7:8f31:0:b029:1f8:987a:53dc with SMTP id y17-20020aa78f310000b02901f8987a53dcmr17925490pfr.58.1615666432240;
        Sat, 13 Mar 2021 12:13:52 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a1sm8774752pff.156.2021.03.13.12.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Mar 2021 12:13:51 -0800 (PST)
Subject: Re: [PATCH 5.12] io_uring: Convert personality_idr to XArray
To:     Matthew Wilcox <willy@infradead.org>
Cc:     yangerkun <yangerkun@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
        yi.zhang@huawei.com
References: <7ccff36e1375f2b0ebf73d957f037b43becc0dde.1615212806.git.asml.silence@gmail.com>
 <803bad80-093a-5fbf-7677-754c9afad530@gmail.com>
 <8b553635-b3d9-cb36-34f0-83777bec94ab@huawei.com>
 <81464ae1-cac4-df4c-cd0e-1d518461d4c3@huawei.com>
 <7a905382-8598-f351-8a5b-423d7246200a@kernel.dk>
 <e6c9ed79-827b-7a45-3ad8-9ba5a21d5780@kernel.dk>
 <d98051ba-0c85-7013-dd93-a76efc9196ad@kernel.dk>
 <20210313195402.GK2577561@casper.infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <91b46511-48c9-394b-bf32-ac5f7e0951c8@kernel.dk>
Date:   Sat, 13 Mar 2021 13:13:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210313195402.GK2577561@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/13/21 12:54 PM, Matthew Wilcox wrote:
> On Sat, Mar 13, 2021 at 12:30:14PM -0700, Jens Axboe wrote:
>> @@ -2851,7 +2852,7 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
>>  			list_del(&kbuf->list);
>>  		} else {
>>  			kbuf = head;
>> -			idr_remove(&req->ctx->io_buffer_idr, bgid);
>> +			__xa_erase(&req->ctx->io_buffer, bgid);
> 
> Umm ... __xa_erase()?  Did you enable all the lockdep infrastructure?
> This should have tripped some of the debugging code because I don't think
> you're holding the xa_lock.

Not run with lockdep - and probably my misunderstanding, do we need xa_lock()
if we provide our own locking?

>> @@ -3993,21 +3994,20 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
>>  
>>  	lockdep_assert_held(&ctx->uring_lock);
>>  
>> -	list = head = idr_find(&ctx->io_buffer_idr, p->bgid);
>> +	list = head = xa_load(&ctx->io_buffer, p->bgid);
>>  
>>  	ret = io_add_buffers(p, &head);
>> -	if (ret < 0)
>> -		goto out;
>> +	if (ret >= 0 && !list) {
>> +		u32 id = -1U;
>>  
>> -	if (!list) {
>> -		ret = idr_alloc(&ctx->io_buffer_idr, head, p->bgid, p->bgid + 1,
>> -					GFP_KERNEL);
>> -		if (ret < 0) {
>> +		ret = __xa_alloc_cyclic(&ctx->io_buffer, &id, head,
>> +					XA_LIMIT(0, USHRT_MAX),
>> +					&ctx->io_buffer_next, GFP_KERNEL);
> 
> I don't understand why this works.  The equivalent transformation here
> would have been:
> 
> 		ret = xa_insert(&ctx->io_buffers, p->bgid, head, GFP_KERNEL);
> 
> with various options to handle it differently.

True, that does look kinda weird (and wrong). I'll fix that up.

>>  static void io_destroy_buffers(struct io_ring_ctx *ctx)
>>  {
>> -	idr_for_each(&ctx->io_buffer_idr, __io_destroy_buffers, ctx);
>> -	idr_destroy(&ctx->io_buffer_idr);
>> +	struct io_buffer *buf;
>> +	unsigned long index;
>> +
>> +	xa_for_each(&ctx->io_buffer, index, buf)
>> +		__io_remove_buffers(ctx, buf, index, -1U);
>> +	xa_destroy(&ctx->io_buffer);
> 
> Honestly, I'd do BUG_ON(!xa_empty(&ctx->io_buffers)) if anything.  If that
> loop didn't empty the array, something is terribly wrong and we should
> know about it somehow instead of making the memory leak harder to find.

Probably also my misunderstanding - do I not need to call xa_destroy()
if I prune all the members? Assumed we needed it to free some internal
state, but maybe that's not the case?

-- 
Jens Axboe

