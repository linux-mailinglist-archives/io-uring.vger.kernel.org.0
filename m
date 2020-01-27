Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0848114AA04
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 19:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgA0Sqg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 13:46:36 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44672 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgA0Sqg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 13:46:36 -0500
Received: by mail-pg1-f193.google.com with SMTP id x7so5580527pgl.11
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 10:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tOlByGG/z9eX7KBfPtN4oVs+iXd8DtbbVKWbuZoUZ0U=;
        b=tLa6xUkjTP/8me30/6p48asiVEiDxQuOuwvCONFNDxS7bVdFoYW2mA1HX8L6owJouD
         QguHw3C8P/5dfv8EHTh5k8yzEFJlBS2afuIk/bLw83xFZc334qvWmNcfiDztDuu2rw2a
         AsXoXhUVpl4KmVOVXHDtHsoNF15G1M+NvmGZZFQYYo2VQUFZcVj3mb/pRwDuWWpWQNBk
         2WuXuyEGnnb5nBcQyMBLinSkt8wFRXP7FOW4gDBWkPR7X2LgXcvK/FZpFzlpQbmTXsMm
         9CY723KCiDecQxN/yw2k3BqIn0XugWIQzfSOV1jKecz5cuWgrvvLrgbuZe2+O2Phn2qH
         ou9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tOlByGG/z9eX7KBfPtN4oVs+iXd8DtbbVKWbuZoUZ0U=;
        b=KFc1tFqKJWAuYY5Xprf+404DHD8Dt0a2vZmtnRTtFA7VfjUutV3c4iYxpqqFDLN8p0
         Q3tO0nZaQ7X6gCOmuLY/eXM6xK6ej9sbZ0e1gAcGLvuY7b3fcys3NUhOQ1FnlhiVrQ3I
         W//lx/5p6PBuRyRnT5Ldsb6Ra5JwLnu/+T4D+40riFHjDcppnN6QKeNqRumjxjFiOhSA
         KTROnb9JuwpT6E+cylSZJMt7F/zEa8bJbBBt9atuISbW3pA0mi53Ncddl5yuz9tc01s0
         rp2F5mNNIHrOoCvIuqdgOiFbJ0KmshAACHFFufiN+3desmE1Y9LZtHDNY8+jD7m6ZjKJ
         9dXg==
X-Gm-Message-State: APjAAAVfWbgNgv2jHoZUG9WJu3NpL+iQzyDy2dEH1mBmTn6yzIjj59JC
        ZNJxKtB4OYQ+1Txb9ItIdiCX0A==
X-Google-Smtp-Source: APXvYqwu0sbtWVgACK3oeP1zHft8Cu21lVg/Z5EAiACB+KnyO0D89XYQNS2eyhCO0OGMTzhqGcBvUw==
X-Received: by 2002:a63:2a8b:: with SMTP id q133mr20323238pgq.72.1580150795811;
        Mon, 27 Jan 2020 10:46:35 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1133::11c2? ([2620:10d:c090:180::dec1])
        by smtp.gmail.com with ESMTPSA id 136sm16741250pgg.74.2020.01.27.10.46.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 10:46:35 -0800 (PST)
Subject: Re: [PATCH liburing 1/1] test: add epoll test case
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200127161701.153625-1-sgarzare@redhat.com>
 <20200127161701.153625-2-sgarzare@redhat.com>
 <b1b26e79-507a-b339-2850-d2686661e669@kernel.dk>
 <20200127182534.5ljsj53vzpj6kkru@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <646cbb04-9bef-0d99-64ec-322d1584abe7@kernel.dk>
Date:   Mon, 27 Jan 2020 11:46:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200127182534.5ljsj53vzpj6kkru@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/20 11:25 AM, Stefano Garzarella wrote:
> On Mon, Jan 27, 2020 at 09:32:43AM -0700, Jens Axboe wrote:
>> On 1/27/20 9:17 AM, Stefano Garzarella wrote:
>>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>
>> You're not reaping CQ events, and hence you overflow the ring. Once
>> overflown, an attempt to submit new IO will returns in a -16/-EBUSY
>> return value. This is io_uring telling you that it won't submit more
>> IO until you've emptied the completion ring so io_uring can flush
>> the overflown entries to the ring.
> 
> How can I reaping CQ events? (I was hoping the epoll would help me with that)
> 
> What I'm seeing is that the producer (EPOLLOUT) can fill the SQ without issues,
> the consumer (read()) is receiving all the buffers produced, but the thread
> that frees the buffers (EPOLLIN) is not woken up.
> 
> I tried to set a timeout to the epoll_wait(), but the io_uring_peek_cqe()
> returns -EAGAIN.
> 
> If I'm using a ring with 16 entries, it seems to work better, but
> sometimes I lose events and the thread that frees the buffer doesn't wake up.
> 
> Maybe I'm missing something...

OK, so that helps in terms of understanding the issue you are seeing with
it. I'll take a look at this, but it'll probably be a few days. You can
try and enable tracing, I see events completed just fine. Maybe a race
with your epoll wait and event reaping?

-- 
Jens Axboe

