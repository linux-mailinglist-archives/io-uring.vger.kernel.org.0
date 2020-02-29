Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 278D617489A
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 19:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbgB2SLK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Feb 2020 13:11:10 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42256 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbgB2SLK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Feb 2020 13:11:10 -0500
Received: by mail-pg1-f193.google.com with SMTP id h8so3225121pgs.9
        for <io-uring@vger.kernel.org>; Sat, 29 Feb 2020 10:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rGRvX65KDulGtMGC8nwEa6O8Vu+947CWz9kLYpdb4Ro=;
        b=svQuk8O3JQNe2s9JpfYMgvJqW/uOI12J9iPymKj9k1TUDZIBXQkdUIiW2AKRIhd/Ft
         Vd6XlN60JMhKTz3x854nadcdZFgIprw5/3BID5HDLAeoGQxPYTIejhM72eBFxsEBOcXD
         TPZz2cBWBG3q/xi1CLo9PA/n+EtTTeYB0ivYlBpk7FuJ+QAO9AdNInxFY/qiZnfkTPrG
         VZnvj0P9E63hszQ2WXSls8cTb53lhs1c76od/aIS17k2Vi/TvXUBI78SFRsogakvXP+M
         HQ4MAlC1jTckPDOuEMK15NJEP6F6HzJk3OXpJiwGka0fgVTNYU5SkCN1dGOTPcG0x+y6
         a2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rGRvX65KDulGtMGC8nwEa6O8Vu+947CWz9kLYpdb4Ro=;
        b=V6M/XvhPzPdX3JBIlY4U8IeQ+vdNKlRhpIB1+jXZEJRlq6GZFArrjqGAJt6vMzqeqf
         m32x/v9P9HwP8D+zOvLAHmO8+PrXD8jioc5nLScW5gKidbJoALT/ua81FVa7bb6r8wyE
         4HyyEwJdvp2WnqdfG7ZWHuUtCH7fZJZoMX2v4KOYzg4m3/B+/LIxlK9a8urNEb9aamIv
         RiMzWB7ZpIDyAVjxkqIDKeOBqYMf6uvMxv5Obv6PKodrUFLTS/IFyGJwUUefSUIU633W
         q7iOmpG4d50oQ5J21zw3bawHYHbiM8d4XfIlmkJ/VvH0iHiHd3O11d0nzUFLz0Gse5s0
         EH+w==
X-Gm-Message-State: APjAAAWkK6q8GHVp3YAElMXGyz5pL6UZE3qAxSVs2QTNNMD0cM2utt2I
        GLG3FTZqASO5dELbl45rcLs6gQ==
X-Google-Smtp-Source: APXvYqxFIX3q97uSi10+5KE+6jQAEqRvfYnlJskFlqEbo8wuYSiiBEl9Z+ie8Gj62cvw7Xd5xCo+Jw==
X-Received: by 2002:aa7:9606:: with SMTP id q6mr8952559pfg.247.1582999869518;
        Sat, 29 Feb 2020 10:11:09 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id t63sm15813664pfb.70.2020.02.29.10.11.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 10:11:09 -0800 (PST)
Subject: Re: [PATCH 2/6] io_uring: add IORING_OP_PROVIDE_BUFFERS
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     andres@anarazel.de
References: <20200228203053.25023-1-axboe@kernel.dk>
 <20200228203053.25023-3-axboe@kernel.dk>
 <1717ee0c-9700-654e-d75b-6398b1c4c1a9@gmail.com>
 <a1dc31fb-36b5-3e54-7eb7-e88c67a6bb82@kernel.dk>
Message-ID: <237b97fc-62ea-c781-caef-4efa2df16382@kernel.dk>
Date:   Sat, 29 Feb 2020 11:11:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <a1dc31fb-36b5-3e54-7eb7-e88c67a6bb82@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/29/20 10:34 AM, Jens Axboe wrote:
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
>>> +
>>> +	lockdep_assert_held(&ctx->uring_lock);
>>> +
>>> +	list = idr_find(&ctx->io_buffer_idr, p->gid);
>>> +	if (!list) {
>>> +		list = kmalloc(sizeof(*list), GFP_KERNEL);
>>
>> Could be easier to hook struct io_buffer into idr directly, i.e. without
>> a separate allocated list-head entry.
> 
> Good point, we can just make the first kbuf the list, point to the next
> one (or NULL) when a kbuf is removed. I'll make that change, gets rid of
> the list alloc.

I took a look at this, and it does come with tradeoffs. The nice thing
about the list is that it provides a constant lookup pointer, whereas if
we just use the kbuf as the idr index and hang other buffers off that,
then we at least need an idr_replace() or similar when the list becomes
empty. And we need to grab buffers from the tail to retain the head kbuf
(which is idr indexed) for as long as possible. The latter isn't really
a tradeoff, it's just list management.

I do still think it'll end up nicer though, I'll go ahead and give it a
whirl.

-- 
Jens Axboe

