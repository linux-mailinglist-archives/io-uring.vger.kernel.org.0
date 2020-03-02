Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40B281767E7
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 00:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCBXMy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Mar 2020 18:12:54 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44973 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgCBXMw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Mar 2020 18:12:52 -0500
Received: by mail-pf1-f193.google.com with SMTP id y5so440992pfb.11
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2020 15:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PGCq0Yxy6j7pG4Hgd2v0OpuTunQST9E5OQ5veDQNTCg=;
        b=KrHXnZUYAhKGPwUXQ7QATo42DDOE+114Ge1Ieb8g15n1qqbGcfEQwltwgTA1D+lH4i
         qfQy1RhrgyxdN+HTFUf3qDSoXHXfu8vYjFhMoDhQMxk+YqtkRWevbLTtfzKzomvfD0YB
         C4X5GhQz/J7LzuG7cXtkEwTxChsQQOsT2S8I5VMuV3v6PRduAmACWb2VicfhPJw3Revt
         YFl82Ix73WEG5QlH/JbydfuKSEd/fTMpVQg5FCC6hhq478J28Uy34XkiG7Bpf90cOOll
         ySatTnIc6JtVrvtvOJilc7o8YsGC/x30Ee3su3mO/6r1+5fbQdoCcZlS6ou+gup3KZ91
         VSyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PGCq0Yxy6j7pG4Hgd2v0OpuTunQST9E5OQ5veDQNTCg=;
        b=F9bjCstd8IK7DLjzsgwQz+/7HXZnyxLz9yKwjtqY4geI8fAIhU0Sask0W9/BzncD4T
         3puPJEOM3t1HH9Efy9LXG+3HPamF/8JSRu2U5kEVu6HYTTvRt80V9HQ0bGKj1DnkYKX9
         KALt0Hv8A+/Qba1s4DCvwNX+98Cv2hDQbaGnNM8fXtdquE9ywOj5aNM82qDeBtMfKHNb
         4rWbTsybYdYLcdnqp1MPdaRwUIub/M9lLIksCVUVJSduf6qHMZ7bnPSLi/IFvmsIn2U5
         iH939qnKZHrPMqUjHjG+kM5z9u5q89KbXDiiC4wtEi3N4HwRGE9mw5SVkzIaFQCA5J8C
         ASYw==
X-Gm-Message-State: ANhLgQ2nBZtm652FdDT7trLYUDVqzN2gNxmkdKooBBxR2xDwHXJ+pO3r
        ltu0Juo0yrmqWQDttkfGx1wk4Q==
X-Google-Smtp-Source: ADFU+vtJmj/Ml44U7waVC2V86PxWEvYlH6wIHLS8TEXnapOegAfQw93a0gQzrYPIzBamNk82KXK6Lw==
X-Received: by 2002:a63:aa07:: with SMTP id e7mr1193941pgf.90.1583190770018;
        Mon, 02 Mar 2020 15:12:50 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id k5sm6476833pfp.66.2020.03.02.15.12.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 15:12:49 -0800 (PST)
Subject: Re: [PATCH -next] io_uring: Ensure mask is initialized in
 io_arm_poll_handler
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20200302230118.12060-1-natechancellor@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <afe86a1d-dcc4-856e-48ea-f12761036e98@kernel.dk>
Date:   Mon, 2 Mar 2020 16:12:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200302230118.12060-1-natechancellor@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/2/20 4:01 PM, Nathan Chancellor wrote:
> Clang warns:
> 
> fs/io_uring.c:4178:6: warning: variable 'mask' is used uninitialized
> whenever 'if' condition is false [-Wsometimes-uninitialized]
>         if (def->pollin)
>             ^~~~~~~~~~~
> fs/io_uring.c:4182:2: note: uninitialized use occurs here
>         mask |= POLLERR | POLLPRI;
>         ^~~~
> fs/io_uring.c:4178:2: note: remove the 'if' if its condition is always
> true
>         if (def->pollin)
>         ^~~~~~~~~~~~~~~~
> fs/io_uring.c:4154:15: note: initialize the variable 'mask' to silence
> this warning
>         __poll_t mask, ret;
>                      ^
>                       = 0
> 1 warning generated.
> 
> io_op_defs has many definitions where pollin is not set so mask indeed
> might be uninitialized. Initialize it to zero and change the next
> assignment to |=, in case further masks are added in the future to avoid
> missing changing the assignment then.
> 
> Fixes: d7718a9d25a6 ("io_uring: use poll driven retry for files that support it")
> Link: https://github.com/ClangBuiltLinux/linux/issues/916
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
> 
> I noticed that for-next has been force pushed; if you want to squash
> this into the commit that it fixes (or fix it in a different way), feel
> free.

Great thanks, applied. I wonder why gcc doesn't warn about that...

-- 
Jens Axboe

