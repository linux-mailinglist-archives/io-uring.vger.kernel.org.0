Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D183A19FC
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 17:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbhFIPpG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 11:45:06 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:39696 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237575AbhFIPop (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 11:44:45 -0400
Received: by mail-ed1-f54.google.com with SMTP id dj8so29103803edb.6
        for <io-uring@vger.kernel.org>; Wed, 09 Jun 2021 08:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PUH9arYzJe+5jvwnJka2lh5JRkWsjPLQvtgxGUP7F3k=;
        b=YWDN0wXgDGFEIZ9PZjTHCsfpJdR0lV9EZVc5lYzTUY6mODYbQbgkhovCzNeul9ZH9U
         CK9S5j6IRfg5ZgaIv0uDMrvLnB7ZX5GfapGdWlxEgjxQXxnP53NUX9W6JIgqFbNgbkHz
         vjgCgLCi7Cw0VBVr7lTqtdo+7X5Iu0/KcZcLdzvICOu3oKGAX5BR+B+ZYkJcfJBB1l5z
         o92PO087/+ECzLyf/FV02ZlCy9iEnIokGj2sY7RH+GSIvSddEGLc9X/Dyp+WXqFkVgAz
         WEDL5I0kYo1Af7o8y0xog8nJhygBNvpJIyS6BhJ085hDxhhCPpAnEOuaVifC6nurfrE6
         SPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PUH9arYzJe+5jvwnJka2lh5JRkWsjPLQvtgxGUP7F3k=;
        b=WyMlV76v7xO1bNHYL4pyu3G+PUq7XLNeUPNbFlxLGWU36PRR2mPithbUHQnwUK02rg
         fvJZD80b1lq74BiuDb0c1B8NlcdnVplL7SYqfVCasTdWUdJ0HFvUSFOg8HYQm0YbuSni
         VauWYtFqb4G0S1b59g//I+899iNmUqhVf/PC2ZvnJoA7OnQa5IEYoZMwUE8VAF0I4FKq
         C6iLDM2yuZ5occDxcHcsLoH9wsImkC9T/hM6n5YMyl6hneBR27kTUJk1B9iAairSgawm
         aIq+NR4TZVbPpyTJ8PDyFdHMnvcQWHt0ev8hN7Lcol/omgor1p22O26ueg1bjlHvfckS
         LsLg==
X-Gm-Message-State: AOAM533lUyj8Nu6CAvD0JyQajS3vMa68uoGI5asABNmpg3C2DnT+t+og
        7+IoPOntnNIRFZ3V7HDqu0k=
X-Google-Smtp-Source: ABdhPJzs18gpEExjLtPlkJKwXZKoSDpoDhjM6YZSfanSvA7d3KXJ8gmSnOso0cvmYJIZD0Sgk+p/hw==
X-Received: by 2002:aa7:da94:: with SMTP id q20mr75129eds.310.1623253298279;
        Wed, 09 Jun 2021 08:41:38 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c093:600::2:f1a2])
        by smtp.gmail.com with ESMTPSA id u17sm60366edx.16.2021.06.09.08.41.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 08:41:37 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix blocking inline submission
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <d60270856b8a4560a639ef5f76e55eb563633599.1623236455.git.asml.silence@gmail.com>
 <e3edab99-624d-6f24-a6ba-63589d00eeee@kernel.dk>
 <e6283f40-52ab-ddcc-131c-309e34321613@gmail.com>
 <cb972cf9-c35b-51f3-7216-13437285cda2@kernel.dk>
Cc:     lonjil@gmail.com
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <a61a3394-0e18-ec9a-5674-dd4439c6b041@gmail.com>
Date:   Wed, 9 Jun 2021 16:41:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <cb972cf9-c35b-51f3-7216-13437285cda2@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/21 4:36 PM, Jens Axboe wrote:
> On 6/9/21 9:34 AM, Pavel Begunkov wrote:
>> On 6/9/21 4:07 PM, Jens Axboe wrote:
>>> On 6/9/21 5:07 AM, Pavel Begunkov wrote:
>>>> There is a complaint against sys_io_uring_enter() blocking if it submits
>>>> stdin reads. The problem is in __io_file_supports_async(), which
>>>> sees that it's a cdev and allows it to be processed inline.
>>>>
>>>> Punt char devices using generic rules of io_file_supports_async(),
>>>> including checking for presence of *_iter() versions of rw callbacks.
>>>> Apparently, it will affect most of cdevs with some exceptions like
>>>> null and zero devices.
>>>
>>> I don't like this, we really should fix the file types, they are
>>> broken if they don't honor IOCB_NOWAIT and have ->read_iter() (or
>>> the write equiv).
>>>
>>> For cases where there is no iter variant of the read/write handlers,
>>> then yes we should not return true from __io_file_supports_async().
>>
>> I'm confused. The patch doesn't punt them unconditionally, but make
>> it go through the generic path of __io_file_supports_async()
>> including checks for read_iter/write_iter. So if a chrdev has
>> *_iter() it should continue to work as before.
> 
> Ah ok, yes then that is indeed fine.
> 
>> It fixes the symptom that means the change punts it async, and so
>> I assume tty doesn't have _iter()s for some reason. Will take a
>> look at the tty driver soon to stop blind guessing.
> 
> I think they do, but they don't honor IOCB_NOWAIT for example. I'd
> be curious if the patch actually fixes the reported case, even though
> it is most likely the right thing to do. If not, then the fops handler
> need fixing for that driver.

Yep, weird, but fixes it for me. A simple repro was attached
to the issue.

https://github.com/axboe/liburing/issues/354

-- 
Pavel Begunkov
