Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854961BAEA1
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 22:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgD0UCT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 16:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726205AbgD0UCT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Apr 2020 16:02:19 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A51BC0610D5
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 13:02:19 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id t9so100935pjw.0
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 13:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SJUiFIUz+jYhmeeOdf91/kUmb2lZxBIGXq8GfSxZaIQ=;
        b=pzc0odECCJ5RHjTip4pkdwoXsg4H1BsO7whFj0U9Nr+ZwI+hIXoH7X/zH4jIbKjYI9
         Y8iPFyRvVJgvak6xm9YHS9OCBt6HEXIxuXow1b3ydEIU4lu2MW+vXkpAfnFpHf6ompwI
         fKoC/IVLYy97YS5BJ5Wcp3OXBAR+Ry+tLxB48YYgfppOdqmuvLLF+GAOqie0I/gpznLJ
         4xOqaVIT1TapW4kyKUag542OZXXefeacMjpVF3n+s2GXb6tB2JzNCKg7ii4qYFemirea
         A5cQDHToAduVhf0kxw5j+Cxtl2k4SzZQNuBeJHtmNMsldAYpKj6rmw/opF6PyirhxbVY
         tukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SJUiFIUz+jYhmeeOdf91/kUmb2lZxBIGXq8GfSxZaIQ=;
        b=BK+f/Jttdjaf5KRaiTZ+DMO0e46TX8WQxRVn3L4ar3KMhO90M4RzNYWRqliIbfl005
         L9mwvNorI4OwUpQiXiHCJxf2kvjlsM/Wis4/YyJAGRvUIMh3YibO8IFy5EnKHhf51HMT
         rFX7D9wRXvANsh8s8WvZz2/XvIDQxRKJ1xhaCAh8coibuOfz0LhW0E4IKmCQD//zoB01
         +wEeRX5XsqyN4mJ8r8trQ3A4xNR/y/xs+hV2wqelCsCqQ6Cuwj1wnV1LIPrueAl4o36X
         pZ1XP5w/Db7/+XKm3m+TK9GPU+7SiKhrYWY/WZrOuZv/2c/4TsiIVk0J1txicuxlIk5E
         Zdqw==
X-Gm-Message-State: AGi0PuY3vNq0KPD7qBQUBKDzvmzG9rY0kArthkXTYhcW+tD/K+GOjlRi
        FcujAD19WDH7JLfL3ndoKl+itfv6uFs6DA==
X-Google-Smtp-Source: APiQypJqpEzejPwBFOlSXGoq/3MdbOJ005jL7j9JhleEmbz1CTUM9gKqmcGX6vtUrFiXEEIKFMXzZQ==
X-Received: by 2002:a17:90a:fd0c:: with SMTP id cv12mr383317pjb.95.1588017738637;
        Mon, 27 Apr 2020 13:02:18 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id d126sm11410337pfc.81.2020.04.27.13.02.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 13:02:18 -0700 (PDT)
Subject: Re: Feature request: Please implement IORING_OP_TEE
To:     Jann Horn <jannh@google.com>
Cc:     Clay Harris <bugs@claycon.org>,
        io-uring <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20200427154031.n354uscqosf76p5z@ps29521.dreamhostps.com>
 <c76b09f0-3437-842e-7106-efb2cac38284@kernel.dk>
 <CAG48ez1fc1_U7AtWAM+Jh6QjV-oAtAW2sQ2XSz9s+53SN_wSFg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6a444e4c-bd51-b32c-b9e0-5e157b20e79d@kernel.dk>
Date:   Mon, 27 Apr 2020 14:02:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez1fc1_U7AtWAM+Jh6QjV-oAtAW2sQ2XSz9s+53SN_wSFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/27/20 12:22 PM, Jann Horn wrote:
> On Mon, Apr 27, 2020 at 5:56 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 4/27/20 9:40 AM, Clay Harris wrote:
>>> I was excited to see IORING_OP_SPLICE go in, but disappointed that tee
>>> didn't go in at the same time.  It would be very useful to copy pipe
>>> buffers in an async program.
>>
>> Pavel, care to wire up tee? From a quick look, looks like just exposing
>> do_tee() and calling that, so should be trivial.
> 
> Just out of curiosity:
> 
> What's the purpose of doing that via io_uring? Non-blocking sys_tee()
> just shoves around some metadata, it doesn't do any I/O, right? Is
> this purely for syscall-batching reasons? (And does that mean that you
> would also add syscalls like epoll_wait() and futex() to io_uring?) Or
> is this because you're worried about blocking on the pipe mutex?

Right, it doesn't do any IO. It does potentially block on the inode
mutex, but that's about it. I think the reasons are mainly:

- Keep the interfaces the same, instead of using both sync and async
  calls.
- Bundling/batch reasons, either in same submission, or chained.

Some folks have talked about futex, and epoll_wait would also be a
natural extension as well, since we already have the ctl part.

-- 
Jens Axboe

