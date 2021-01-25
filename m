Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E18E3027E3
	for <lists+io-uring@lfdr.de>; Mon, 25 Jan 2021 17:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbhAYQcU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jan 2021 11:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730737AbhAYQcF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 11:32:05 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE7DC061788
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 08:31:25 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id n25so9270829pgb.0
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 08:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4k4YyiKKGbjoC4kENlp8xGiKvvyWMZKEFZ8j8O/kjeA=;
        b=vznUqezTIVnPGbrfwV+b9YrzKg4Ejd3mZtBifOZzJHV0QVyxnux/kMDpc7gbyZ583w
         7wIQYzi0CQcDV6CnjzI3csYo/0n/YGPXODZwNbNTr+EaJymua452rX7V2FZ10U0jsMtC
         jxxaZnCpH6oMguoFfzpbyYDg8wRmkLj/3kGS/kBINwgTrT6koAa2GtMsmKWq7Gii47Rn
         AgWEQcvl6mpONEYvaLqM6wx+9/KTrSxqgEDQDOZFkcE4A5svXnkyMPTMUorZNguOQIE0
         Xnd49uygZn5ebP2pkSiFcAtMjcPYo8mi5NhKa8gXQ9aep1p3xgJpWe8vVCSiclPkjoS0
         afbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4k4YyiKKGbjoC4kENlp8xGiKvvyWMZKEFZ8j8O/kjeA=;
        b=Ia9kAMsJTYAnvTULbzwglrTI4ffqNryxrIb7FPjgYrGEc4A1mvHGbdXi7MAxoF8I75
         L7qKRrBvKFvt2eRkril5Zo09i6A6/r2U28y8ZtL9GKDkaz0YCpxbF3uMdUECh00LQQ8K
         F4iZ6mF7Fbf20ACNq2diQkroMLetsumR9rblrSmOQPjcQVLsz06s3u0QgRnBlMul/Na+
         K5DCvXMhR1MCRpJDZVrVy7+WGFwUhyyXrv2uSixKdl7pAmDQoN4kroF+niELdwhQa8zo
         GWByMNz8zLAr5xedc3R2FqMkzEIshWWZp3QXLICvhbAtqetqNbRWHUhU44a5StTS9q4f
         VbeQ==
X-Gm-Message-State: AOAM531hNK3FxvEctJIayiD5iDgkrbtdvyGOOARwWHeei3jDR4TTdIqU
        CVR3coSdqJTDPc06NUbJj7a4yfnGHEFaCg==
X-Google-Smtp-Source: ABdhPJxMMv4xJJB1lQSupyX82fEwNrARQ+3PYR+sSqELug9xY0HURshn3h16GWdKVNrkqeXdoe6kwA==
X-Received: by 2002:a65:628a:: with SMTP id f10mr1334798pgv.380.1611592284659;
        Mon, 25 Jan 2021 08:31:24 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id s9sm10762665pfd.38.2021.01.25.08.31.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 08:31:24 -0800 (PST)
Subject: Re: [PATCH 3/8] io_uring: don't keep submit_state on stack
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1611573970.git.asml.silence@gmail.com>
 <dc52b7b5761ad78f0883ec7ca433c0a8d7089285.1611573970.git.asml.silence@gmail.com>
 <d802eb6f-f491-d35c-f556-c7d0285c6974@kernel.dk>
 <86406a3b-7d8e-5521-f6b5-f3a940a0565d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <db57bed7-40ad-0251-941c-60ab6c872baa@kernel.dk>
Date:   Mon, 25 Jan 2021 09:31:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <86406a3b-7d8e-5521-f6b5-f3a940a0565d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/25/21 9:25 AM, Pavel Begunkov wrote:
> On 25/01/2021 16:00, Jens Axboe wrote:
>> On 1/25/21 4:42 AM, Pavel Begunkov wrote:
>>> struct io_submit_state is quite big (168 bytes) and going to grow. It's
>>> better to not keep it on stack as it is now. Move it to context, it's
>>> always protected by uring_lock, so it's fine to have only one instance
>>> of it.
>>
>> I don't like this one. Unless you have plans to make it much bigger,
>> I think it should stay on the stack. On the stack, the ownership is
>> clear.
> 
> Thinking of it, it's not needed for this series, just traversing a list
> twice is not nice but bearable.
> 
> For experiments I was using its persistency across syscalls + grew it
> to 32 to match up completion flush (allocating still by 8) to add req
> memory reuse, but that's out of scope of these patches.
> I haven't got a strong opinion on that one yet, even though
> alloc/dealloc are pretty heavy, this approach may loose allocation
> locality. 

Agree on all of that. Locality is important, but reuse usually gets
pretty useful as long as the total number (and life time) can be
managed.

-- 
Jens Axboe

