Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E487E185026
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2020 21:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgCMUSv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Mar 2020 16:18:51 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34223 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgCMUSv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Mar 2020 16:18:51 -0400
Received: by mail-lj1-f193.google.com with SMTP id s13so11976676ljm.1
        for <io-uring@vger.kernel.org>; Fri, 13 Mar 2020 13:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1dyaDXD6kKcsjU3cdaN9tJMCmO/tIPHlkK3dbzeZyfg=;
        b=IyxmDZ+MInB7hJJiSvQ8M6SvkLSa6alEsIj47Hf+qqZ5CYMCROkdK8r49X48qyOGZZ
         DvHajJVv4/N9Xt+1+F5wfePvt104x04McIxOVjzj8DY7AvoCiMni8wf4vkLGHwgkAqKb
         NXkS+J6hgxY+A06g0a4K+hKEe7gxItoNaFqjc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1dyaDXD6kKcsjU3cdaN9tJMCmO/tIPHlkK3dbzeZyfg=;
        b=Ee+rFJUgaLAfgrM7YJ8ZdlEfxV3O7IIV53mGURwopNHtuVXXSYQ+oALRg6lwvZwb+Z
         6Yw8Alrpd4kmusY3YFihpf5brztpJzshvBFbj/LQzTKZg4np7Kcr71poGmYnJIXtLONX
         yq2zjWb/qeNcJLODOTvZLT0x6/zu+M/r4jmjAocCmX2oDJyMYXb2wGIPL7Z55fZ9vlqP
         6Ro0Pkw9VFOzQhy9+dc3eyZ3Jkq/xLL0JZiHbH4PoL8PhwumEFaTheld/KTP2XO6dVjb
         GvYg9Wh5vk4tngFMO6IMy1tSGQ3YxEfjr09fbrHpj2ULjmGCuxgsAQnR4TmeBIV8jw4X
         7J1g==
X-Gm-Message-State: ANhLgQ1EO/MAa3MIgyp0lzMHbKPxqLxrN8G37ObxKReBGOazdX180E2j
        Zv8BeDOx4mU9BYguYj9wNRyaVFG3RsA=
X-Google-Smtp-Source: ADFU+vtaSsWugEIw22EhMa9/KydkzmAQZduAHWxpQAlo3Jge0JwEzfFCJN1Ovxe5+9wx3zTtqtu04g==
X-Received: by 2002:a2e:95c8:: with SMTP id y8mr9282124ljh.153.1584130728253;
        Fri, 13 Mar 2020 13:18:48 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id r2sm6128721lfn.92.2020.03.13.13.18.46
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2020 13:18:47 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id r9so3415595lff.13
        for <io-uring@vger.kernel.org>; Fri, 13 Mar 2020 13:18:46 -0700 (PDT)
X-Received: by 2002:ac2:5508:: with SMTP id j8mr9590741lfk.31.1584130726499;
 Fri, 13 Mar 2020 13:18:46 -0700 (PDT)
MIME-Version: 1.0
References: <00e5ab7d-f0ad-bc94-204a-d2b7fb88f594@fb.com>
In-Reply-To: <00e5ab7d-f0ad-bc94-204a-d2b7fb88f594@fb.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 13 Mar 2020 13:18:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgGN-9dmso4L+6RWdouEg4zQfd74m23K6c9E_=Qua+H1Q@mail.gmail.com>
Message-ID: <CAHk-=wgGN-9dmso4L+6RWdouEg4zQfd74m23K6c9E_=Qua+H1Q@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 5.6-rc
To:     Jens Axboe <axboe@fb.com>, "Paul E. McKenney" <paulmck@kernel.org>,
        Tejun Heo <tj@kernel.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 13, 2020 at 10:50 AM Jens Axboe <axboe@fb.com> wrote:
>
> Just a single fix here, improving the RCU callback ordering from last
> week. After a bit more perusing by Paul, he poked a hole in the
> original.

Ouch.

If I read this patch correctly, you're now adding a rcu_barrier() onto
the system workqueue for each io_uring context freeing op.

This makes me worry:

 - I think system_wq is unordered, so does it even guarantee that the
rcu_barrier happens after whatever work you're expecting it to be
after?

Or is it using a workqueue not because it wants to serialize with any
other work, but because it needs to use rcu_barrier in a context where
it can't sleep?

But the commit message does seem to imply that ordering is important..

 - doesn't this have the potential to flood the system_wq be full of
flushing things that all could take a while..

I've pulled it, and it may all be correct, just chalk this message up
to "Linus got nervous looking at it".

Added Paul and Tejun to the participants explicitly.

             Linus
