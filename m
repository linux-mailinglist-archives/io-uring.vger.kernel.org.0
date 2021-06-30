Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C723B899C
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 22:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbhF3URE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 16:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbhF3URD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 16:17:03 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A645BC061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 13:14:34 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id s11so2866651ilt.8
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 13:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R8olpWRwve0EYX+GJhV/HBZnPRPZuAflLejczEl/frE=;
        b=Uegc4mVEDYUkmXMhCFRvrSNeS6Wdvnr5+I62MlJvgIngndR4/u90hxk6NCTZDzyuOd
         DhWnY43WzYSrMc5XZZY/M1yAM55jGv89ZKAwkkxn1RI5v6xSu5ChRzbTimuaIVOWxck+
         8B2CaSNPwdBbdRZ26AOhEQih+EAxqjgz1c/DbRq0oda9jdt7gfDFhmzFUOjcLQK3goNj
         YP45TgVpdYc0wC1AnQgza5xQSMBESeV+F7Td1BY59zq6AN15BwzHAAnVMlPuqCT5FGrM
         7ugFD88yZtEpPuR9OfALIrNQ+ogADG9TahPC2li94mEV/6usOHiKXoyKFZsFv/A2ov5d
         NXLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R8olpWRwve0EYX+GJhV/HBZnPRPZuAflLejczEl/frE=;
        b=JyewIX83p82d/16/LA9BC9gJJlusuuLyLCm4cVUhYbVhf4cSLxxFNdAZU1vOlyHLNO
         yclrOErP5qPc+K6jjOtHwev4qEETYq7F6cmy4gxWjBV8sHoIORUDC++7wke4ky3AEElz
         GYXWuqepwpnqJRs5O2mWrWniUO8B11mhgVR91BefNRKHNnMIIpUEmgwSDb3kTR9874V7
         ZXFdeN9pHC9ObWa/v0Ei7yN6fzOBvWUnR27ogg4zuJK2ZowGnOjIJZq3tkFbiZHFLlwk
         RNFm9V2hC6vthxmqtx8+o0iyCJ9USL7N3CupYCp7p2+PijdYkuXnhpgOsp9siwKbcudG
         03+Q==
X-Gm-Message-State: AOAM533azUnpT1LIxw/NMb/JSYogubcFbGdR8Ro9Hbd83Rnx+DHns2vn
        nA07Rbi/+hMVnpk7Uar2MT9r4mp/bubHuQ==
X-Google-Smtp-Source: ABdhPJx+3wyLV+w9YltS+7Y2rlSArN3TsLZdQ7EdGbRuio8cb4FlzqxE9wuPLRlaPbES826qZKzBNA==
X-Received: by 2002:a05:6e02:b4a:: with SMTP id f10mr27622379ilu.280.1625084073880;
        Wed, 30 Jun 2021 13:14:33 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id w21sm12530817iol.52.2021.06.30.13.14.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 13:14:33 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring updates for 5.14-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Dmitry Kadashev <dkadashev@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <c9a79f27-02e9-b0d6-78ae-2e777eed8fe0@kernel.dk>
 <CAHk-=wgCac9hBsYzKMpHk0EbLgQaXR=OUAjHaBtaY+G8A9KhFg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <00f21ea0-2f38-f554-63e9-ef07e806a0cd@kernel.dk>
Date:   Wed, 30 Jun 2021 14:14:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgCac9hBsYzKMpHk0EbLgQaXR=OUAjHaBtaY+G8A9KhFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/21 2:05 PM, Linus Torvalds wrote:
> On Tue, Jun 29, 2021 at 1:43 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> - Support for mkdirat, symlinkat, and linkat for io_uring (Dmitry)
> 
> I pulled this, and then I unpulled it again.
> 
> I hate how makes the rules for when "putname()" is called completely
> arbitrary and very confusing. It ends up with multiple cases of
> something like
> 
>         error = -ENOENT;
>         goto out_putnames;
> 
> that didn't exist before.
> 
> And worse still ends up being that unbelievably ugly hack with
> 
>         // On error `new` is freed by __filename_create, prevent extra freeing
>         // below
>         new = ERR_PTR(error);
>         goto out_putpath;
> 
> that ends up intentionally undoing one of the putnames because the
> name has already been used.
> 
> And none of the commits have acks by Al. I realize that he can
> sometimes be a bit unresponsive, but this is just *UGLY*. And we've
> had too many io_uring issues for me to just say "I'm sure it's fine".

I think Dmitry has been beyond patient for this series, I think we
beyond 6 months of very little feedback on the core changes. I've
pinged Al multiple times, but we did have Christian Brauner make
suggestions and acking it. That's not to say that it's perfect,
we'll make changes and improve things.

> I can see a few ways to at least de-uglify things:
> 
>  - Maybe we can make putname() just do nothing for IS_ERR_OR_NULL() names.
> 
>    We have that kind of rules for a number of path walking things,
> where passing in an error pointer is fine. Things like
> link_path_walk() or filename_lookup() act that way very much by
> design, exactly to make it easy to handle error conditions.
> 
>  - callers of __filename_create() and similar thar eat the name (and
> return a dentry or whatever) could then set the name to NULL, not as
> part of the error handling, but unconditionally as a "it's been used".
> 
> So I think this is fixable.

I like the first suggestion in particular, that should be straight
forward. I'll drop this series for now and hopefully we can get it
in an acceptable form soon.

> But I'm *VERY* tired of io_uring being so buggy and doing "exciting"
> things, and when it then starts affecting very core functionality and
> I don't even see ack's from the one person who understands all of
> that, I put my foot down.
>
> No more flaky io_uring pulls. Give me the unambiguously good stuff,
> not this kind of unacked ugly stuff.

I think you're being very unfair here, last release was pretty
uneventful, and of course 5.12 was a bit too exciting with the
thread changes, but that was both expected and a necessary evil.

-- 
Jens Axboe

