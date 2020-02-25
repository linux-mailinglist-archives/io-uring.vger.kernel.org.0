Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6950516F146
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 22:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgBYVl6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 16:41:58 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:35894 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgBYVl5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 16:41:57 -0500
Received: by mail-io1-f68.google.com with SMTP id d15so995644iog.3
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 13:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xqWPfNAF3i7Lyv+TetXm82s5l+UxxYbn04KXxXAQalY=;
        b=KYQRtEnjfeGoZ0zx2s3vJ7zffrcP17jR7W+e8Q+c28jtyrk58kT9AjG3t7/QGdy6Gq
         C5mu/LAJOe5YR/LoCMrFYr7sv+Vwy8tn5whkF1W56JcrfEd6SC0OCjNaVeMlnejSqHrf
         gYxdI62G3e4gSCBACnA6LJPGtmQPtiYQJiAPhDj/5YLSd4BhbIKAsVoLS/WxVRYbBvRn
         bItp4OEyyH/1VlV9wC1vvPRx7dbXO8GVqmfDyBL4quUGfvuADHx/8a7WWkvxJfvTiy+V
         XTPePHWnl8C0P/vpQerectPvOw9CglvypSEl2jmdLvoImqzhOAlkxs1aTEJvlUmuuHlF
         JEdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xqWPfNAF3i7Lyv+TetXm82s5l+UxxYbn04KXxXAQalY=;
        b=VPRzgFnA+INKpTtLhbkoxpIWwyiPGwX8B5tz0sA5fc+/km60Fz9CYHSQM5VuY0Hsr+
         IKsJu1QvtowIHN0SRGnnmOTTvlDVgChxGuTt9Of400MnK6c7IewTu14eBVg8MpTJe2KB
         m3L/Qitp+oxiqfL3vrcfuvQoxqvsbVxQVxXO3EdHiNR/2w958ZPwhDJS1L7WP+tLnNcy
         zDj03Fpeh7JFRFvQE9MqD9lAFPyuYiHx41NJeXVLVbSfTMWUQdKASFAkqYO0EaxmRWsG
         sxwUhgHfR0bnqEMVUSnmmdK1CsaphpRPaEDBJozC6Gdk/mcPreDUMDQ/9eE7o8goO9F+
         YDAQ==
X-Gm-Message-State: APjAAAXzsq4NntF4WPXnBqG4PEEHLjfRzPnSe9+9M2hysNS/J6ak0ozA
        DAozdocMFx+U1Wf9BH4znyw24/TZjAqQgg==
X-Google-Smtp-Source: APXvYqwRDHUfNwIxHlE+xMjz1RxfmlZppGA4KE63aoR2mZ4gc6sVQFIZQy1+gfjqoO6/lnlsrMrH9g==
X-Received: by 2002:a05:6602:210a:: with SMTP id x10mr936872iox.151.1582666916919;
        Tue, 25 Feb 2020 13:41:56 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z4sm40906ioh.26.2020.02.25.13.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 13:41:56 -0800 (PST)
Subject: Re: [PATCH] io_uring: pick up link work on submit reference drop
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <1c5f074e-22dd-095a-6be7-730c81eeb1b1@kernel.dk>
 <82423419-1c14-418e-8085-2d8b902b0a2d@gmail.com>
 <71add82f-9d25-b879-5fe5-8e2a4eb26877@kernel.dk>
Message-ID: <32c9037d-d515-9065-3315-e023edaa4578@kernel.dk>
Date:   Tue, 25 Feb 2020 14:41:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <71add82f-9d25-b879-5fe5-8e2a4eb26877@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/25/20 2:25 PM, Jens Axboe wrote:
> On 2/25/20 2:22 PM, Pavel Begunkov wrote:
>> On 25/02/2020 23:27, Jens Axboe wrote:
>>> If work completes inline, then we should pick up a dependent link item
>>> in __io_queue_sqe() as well. If we don't do so, we're forced to go async
>>> with that item, which is suboptimal.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>> ---
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index ffd9bfa84d86..160cf1b0f478 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -4531,8 +4531,15 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
>>>  		} while (1);
>>>  	}
>>>  
>>> -	/* drop submission reference */
>>> -	io_put_req(req);
>>> +	/*
>>> +	 * Drop submission reference. In case the handler already dropped the
>>> +	 * completion reference, then it didn't pick up any potential link
>>> +	 * work. If 'nxt' isn't set, try and do that here.
>>> +	 */
>>> +	if (nxt)
>>
>> It can't even get here, because of the submission ref, isn't it? would the
>> following do?
>>
>> -	io_put_req(req);
>> +	io_put_req_find_next(req, &nxt);
> 
> I don't think it can, let me make that change. And test.

Because I'm a clown, the patch applied with offset. I meant to modify
the __io_queue_sqe() path, as mentioned in the commit message. Here's
the right one, dropped the check

The other one would not be correct without the nxt check, as the work
queue handler could pass it back. For the __io_queue_sqe() path, we
should do a 5.7 cleanup of the 'nxt passing, though. I don't want to
do that for 5.6.

commit 7df2fa5c9f6e92b2f80f4699425b463973d5242b
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Feb 25 13:25:41 2020 -0700

    io_uring: pick up link work on submit reference drop
    
    If work completes inline, then we should pick up a dependent link item
    in __io_queue_sqe() as well. If we don't do so, we're forced to go async
    with that item, which is suboptimal.
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ffd9bfa84d86..c4ed8601e225 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4749,7 +4749,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 err:
 	/* drop submission reference */
-	io_put_req(req);
+	io_put_req_find_next(req, &nxt);
 
 	if (linked_timeout) {
 		if (!ret)


-- 
Jens Axboe

