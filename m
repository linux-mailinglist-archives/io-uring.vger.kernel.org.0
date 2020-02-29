Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21B15174689
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 12:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgB2LgT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Feb 2020 06:36:19 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38727 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbgB2LgT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Feb 2020 06:36:19 -0500
Received: by mail-lj1-f194.google.com with SMTP id w1so6313185ljh.5
        for <io-uring@vger.kernel.org>; Sat, 29 Feb 2020 03:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=82tNrIONbX4v3FKcdP3GgF1VCsSFdWzg5CxMMtau5I4=;
        b=f+oJHSUjMSgMz5nMqEzFwHUdcSEU1LD2aQRyUEJqe7eexiSofNRvvr++m1evflVK4r
         6UKcJqR0F+KXBhq2zUL7kyK6pMNopVLcIAb9sfpXt0wTRlYJuOzh6FWIum9Hpxnt55Xt
         cb/7RIkPe8yPkAUbwI39u08spUYxWdgzUXQf2CnNBqNuLsg4B0+0yqbuU20T9aHMycbS
         w28F7BKkA+j+d2214+M/BYXXMQtr65zQUudH5YfiKXIlbLt3Id0afgrQERQN92TNYk/s
         LDmG8VULQYVyNuPe9iIuKCHSWZ4G2G7i03DagRkwriXrKwTlO+uI+D7bGOx6yL3HNMFt
         UhkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=82tNrIONbX4v3FKcdP3GgF1VCsSFdWzg5CxMMtau5I4=;
        b=VzUcHgN2oK2vhtXHwbxxHWvfc1wKEPezp+aVa1cjgsp6mwqZWEil/MqH6vc/XKZOPg
         M5/XSdzN3UWB1RaSqw4DpZqH3P6QW+lyoZK5A1DIEysmFzcY0FuadfF3oTYmocn2hZe/
         2OAEbcdo4Z8snQOb0iJRA6B2ngd3lBJhmGpFA6AffnJUSjcURN1ym+32GW+d508Waa72
         xgtW16Wgca2KAO6596zIAqDW2qWf4gSykUqh+m1jGUMunAlW8sq3F4JOjtVkBvs6YJgN
         Lv+csp/6iiK+NZPCb1z9r40kc9WkD9C6C6PhTCKCwMM5s2J/I3PRG2Bk76IDBvI6HsYx
         ZawQ==
X-Gm-Message-State: ANhLgQ2u8HkyyQ8+vuoMSczGCB3tRV3uexUT3Zuhxp+IMLW5x8YbhhGP
        AtXfq2hPh4A5+6dYaZB1AaNlqcBMmbY=
X-Google-Smtp-Source: ADFU+vtp06O52Ho7U1Wd9GYYhLf4o81fBmbH7Rn/NaXY6Z+3S0nkAKphOeRzum4ygv39Q9/DOJuq7A==
X-Received: by 2002:a2e:2c13:: with SMTP id s19mr3691955ljs.210.1582976175624;
        Sat, 29 Feb 2020 03:36:15 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id m24sm9352138ljb.81.2020.02.29.03.36.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 03:36:14 -0800 (PST)
Subject: Re: [PATCH 2/6] io_uring: add IORING_OP_PROVIDE_BUFFERS
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     andres@anarazel.de
References: <20200228203053.25023-1-axboe@kernel.dk>
 <20200228203053.25023-3-axboe@kernel.dk>
 <7671b196-99cc-d0a9-3b7e-86769c304b10@gmail.com>
 <297b6e91-b683-80a3-38a2-9c3b845c4d06@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <d7eebc93-4efb-730c-21fd-d866dd54eaa6@gmail.com>
Date:   Sat, 29 Feb 2020 14:36:14 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <297b6e91-b683-80a3-38a2-9c3b845c4d06@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/29/2020 7:50 AM, Jens Axboe wrote:
> On 2/28/20 5:43 PM, Pavel Begunkov wrote:
>>> +static int io_provide_buffers(struct io_kiocb *req, struct io_kiocb **nxt,
>>> +			      bool force_nonblock)
>>> +{
>>> +	struct io_provide_buf *p = &req->pbuf;
>>> +	struct io_ring_ctx *ctx = req->ctx;
>>> +	struct list_head *list;
>>> +	int ret = 0;
>>> +
>>> +	/*
>>> +	 * "Normal" inline submissions always hold the uring_lock, since we
>>> +	 * grab it from the system call. Same is true for the SQPOLL offload.
>>> +	 * The only exception is when we've detached the request and issue it
>>> +	 * from an async worker thread, grab the lock for that case.
>>> +	 */
>>> +	if (!force_nonblock)
>>> +		mutex_lock(&ctx->uring_lock);
>>
>> io_poll_task_handler() calls it with force_nonblock==true, but it
>> doesn't hold the mutex AFAIK.
> 
> True, that's the only exception. And that command doesn't transfer data
> so would never need a buffer, but I agree that's perhaps not fully
> clear. The async task handler grabs the mutex.

Hmm, I meant io_poll_task_func(), which do __io_queue_sqe() for @nxt
request, which in its turn calls io_issue_sqe(force_nonblock=true).

Does io_poll_task_func() hold @uring_mutex? Otherwise, if @nxt happened
to be io_provide_buffers(), we get there without holding the mutex and
with force_nonblock=true.


>>> +	lockdep_assert_held(&ctx->uring_lock);
>>> +
>>> +	list = idr_find(&ctx->io_buffer_idr, p->gid);
>>> +	if (!list) {
>>> +		list = kmalloc(sizeof(*list), GFP_KERNEL);
>>> +		if (!list) {
>>> +			ret = -ENOMEM;
>>> +			goto out;
>>> +		}
>>> +		INIT_LIST_HEAD(list);
>>> +		ret = idr_alloc(&ctx->io_buffer_idr, list, p->gid, p->gid + 1,
>>> +					GFP_KERNEL);
>>> +		if (ret < 0) {
>>> +			kfree(list);
>>> +			goto out;
>>> +		}
>>> +	}
>>> +
>>> +	ret = io_add_buffers(p, list);
>>
>> Isn't it better to not do partial registration?
>> i.e. it may return ret < pbuf->nbufs
> 
> Most things work like that, though. If you ask for an 8k read, you can't
> unwind if you just get 4k. We return 4k for that. I think in general, if
> it fails, you're probably somewhat screwed in either case. At least with
> the partial return, you know which buffers got registered and how many
> you can use. If you return 0 and undo it all, then the application
> really has no way to continue except abort.
> 

-- 
Pavel Begunkov
