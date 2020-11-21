Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23D22BBC4B
	for <lists+io-uring@lfdr.de>; Sat, 21 Nov 2020 03:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgKUClc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Nov 2020 21:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgKUClc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Nov 2020 21:41:32 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912E7C0613CF
        for <io-uring@vger.kernel.org>; Fri, 20 Nov 2020 18:41:32 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id 131so9676302pfb.9
        for <io-uring@vger.kernel.org>; Fri, 20 Nov 2020 18:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cupvgOMTVBwgkkLbVCBqW4EIqgBQFYF/NJXddxs0Ids=;
        b=lok14dlodxTxd9wKn3eNEOoZBxck6S1fvcVxPO5TKkdTvSC0GSpU11sa6g68umZCfd
         gl/5tUH5791LPuiP9+fVn+cxF7+mF5LswxE3V2c1Y/3oseQZ1bV7vTWllEYErR3BMFjW
         xqhT4kBVsiMMZelG0kWMTzwzu66yhebsQBGX/eBl5Gd77OW+uvuvoREdZfGwKyR9okWJ
         Ku8pxK+rRJZvKaO/PqaN0CGztAullrVUBTqdKxfAiqpHOjS/FNkBv8qo8vmOPqj8ZU9a
         uiDV9i7LwjXmBQQmQyWp74PC7XAUDEf5Lasf3EVigZziYbIcT2IAwzDc6ZVBVzoeUEjt
         JmEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cupvgOMTVBwgkkLbVCBqW4EIqgBQFYF/NJXddxs0Ids=;
        b=rdjbe+bkooeaSf5DAi7AVGrcrgYY4/BCH+EDUyvyfR58ZdVgszqh7HwvC6vs7s2UH+
         /0M+LHR5TlgF3cEcZuJzwU+CE4dr4TS4U2avS2OXjmXGQAEI9wsxxpKhDDS6zx13pmmY
         6i/mnAkSwKBNnee/eiFZGM2TFKlv1VZMB0JosCpitxSPtzyJblrUrDnqq7yVpjvud7WW
         TllPZWH9T/s0pZZCvSVczEL/+2OtufThkEkhBJZOgxZCpIlqPKDgKQdO8iFwgISG2eT6
         uaAz1A9IngqFQ3DeOBddhp30ATeyB+rAnuXYyKLdpCtlOx8REgv12u3XHTjBMwhTmyCj
         BHog==
X-Gm-Message-State: AOAM532gpfJvkOnrMf3WcPFQ+mWKlTQcO9VLCXKbWZxxYnF7huwUS5uY
        VCr8A5h0z4cc9CIgnZzd1bngdw==
X-Google-Smtp-Source: ABdhPJyTGr25/i38e9pCVggSwQu2afnGJfCQV65ikcDcihrduikXQRsEfcBYJM3OcuxV3WYuCaeykw==
X-Received: by 2002:a17:90a:d105:: with SMTP id l5mr13471254pju.17.1605926492123;
        Fri, 20 Nov 2020 18:41:32 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p127sm5216086pfp.93.2020.11.20.18.41.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 18:41:31 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fixes for 5.10-rc
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <6535286b-2532-dc86-3c6e-1b1e9bce358f@kernel.dk>
 <CAHk-=wjrayP=rOB+v+2eTP8micykkM76t=6vp-hyy+vWYkL8=A@mail.gmail.com>
 <4bcf3012-a4ad-ac2d-e70b-17f17441eea9@kernel.dk>
 <CAHk-=wimYoUtY4ygMNknkKZHqgYBZbkU4Koo5cE6ar8XjHkzGg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ad8db5d0-2fac-90b6-b9e4-746a52b8ac57@kernel.dk>
Date:   Fri, 20 Nov 2020 19:41:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wimYoUtY4ygMNknkKZHqgYBZbkU4Koo5cE6ar8XjHkzGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/20/20 5:23 PM, Linus Torvalds wrote:
> On Fri, Nov 20, 2020 at 1:36 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> I don't disagree with you on that. I've been a bit gun shy on touching
>> the VFS side of things, but this one isn't too bad. I hacked up a patch
>> that allows io_uring to do LOOKUP_RCU and a quick test seems to indicate
>> it's fine. On top of that, we just propagate the error if we do fail and
>> get rid of that odd retry loop.
> 
> Ok, this looks better to me (but is obviously not 5.10 material).
> 
> That said, I think I'd prefer to keep 'struct nameidata' internal to
> just fs/namei.c, and maybe we can just expert that
> 
>         struct nameidata nd;
> 
>         set_nameidata(&nd, req->open.dfd, req->open.filename);
>         file = path_openat(&nd, &op, op.lookup_flags | LOOKUP_RCU);
>         restore_nameidata();
>         return filp == ERR_PTR(-ECHILD) ? -EAGAIN : filp;
> 
> as a helper from namei.c instead? Call it "do_filp_open_rcu()" or something?

Yes, that's probably a better idea. I'll move in that direction.

> That "force_nonblock" test seems a bit off, though. Why is that RCU
> case only done when "!force_nonblock"? It would seem that if
> force_nonblock is set, you want to do this too?

Taking a second look at it, it's inverted. So if force_nonblock == true,
we want to do just the RCU lookup.

But I think the bit that you're missing is that the other case will do
the normal lookup, which does an RCU lookup first. It looks needs to
look like this:

if (force_nonblock)
	file = do_filp_open_rcu();
else
	file = do_filp_open();

-- 
Jens Axboe

