Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2973C7561
	for <lists+io-uring@lfdr.de>; Tue, 13 Jul 2021 18:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhGMRAw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Jul 2021 13:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhGMRAw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Jul 2021 13:00:52 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8F5C0613E9
        for <io-uring@vger.kernel.org>; Tue, 13 Jul 2021 09:58:01 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id a18so51473151lfs.10
        for <io-uring@vger.kernel.org>; Tue, 13 Jul 2021 09:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yhm8DTXMwGH3edDwo8fP2AUueUVOXSOluzUis4TeCEM=;
        b=IouJxuG5ed7uAGJwLWz05WTIl3EyMHKLbOeZ/figWyyseOX1vqRylnWkg9X/sDBjjh
         6pRMGIxq99s6Lcm7Cc6a1DP+lO+eTYQP1SmjxNrY9YgOxxVm/OGSkQg5LBNWmcbLY/9e
         lqi5l7xqvWJEepIBLkDtBnHKIIRMeYnt4R2Sg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yhm8DTXMwGH3edDwo8fP2AUueUVOXSOluzUis4TeCEM=;
        b=gx25hNGDffHxTt1bQNRHU1rLpx7hGSlrLrtS1Flsq4csJC/tLVS0lJTRCEmS8wUqvi
         x3e7RE+nFV4pDrtPmhRsW0fD7xqMViJJ406GpokRIdE8xCW4mNVleOX28fU/ZAEfrlfH
         S02bf5hBaI7HrS6Z6neuBVKt4pHhbM6jfkA07Cxo3u/BDuXxkIKHuNyE4BXzmcmK+cJb
         KsUh89YLe89J//gzW/g9Esa8hgaS5TOPwI4TRXnW8aKLRkjSXZuzpOfYofgR0vfPY+/c
         DFctwGFgHdydHCY3QJHRcbhl45g+g2V+2vRONJM1y9YA+s6ZP+G9OrYq/x4Upl7rwmPp
         pCsg==
X-Gm-Message-State: AOAM5326vFvUUCA65IG7dRPh2ZZOc21aOSEgo3YodruPyXYotB8FmLmh
        j7z3iMzb1YVG7XNa4UWT5Nmnk1sQzDLqNew2FC8=
X-Google-Smtp-Source: ABdhPJz9iviVwK52MkIi5FNvXvZ+RRv/gIHT7QoSAm2cGtZkRPz19o95vCiX6YgnjWwMdK5ATHq9Uw==
X-Received: by 2002:a05:6512:36d8:: with SMTP id e24mr4364784lfs.8.1626195479406;
        Tue, 13 Jul 2021 09:57:59 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id f2sm1500850lfa.261.2021.07.13.09.57.58
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jul 2021 09:57:58 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id u13so12265851lfs.11
        for <io-uring@vger.kernel.org>; Tue, 13 Jul 2021 09:57:58 -0700 (PDT)
X-Received: by 2002:a05:6512:3f82:: with SMTP id x2mr3985242lfa.421.1626195478340;
 Tue, 13 Jul 2021 09:57:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210712123649.1102392-1-dkadashev@gmail.com> <20210712123649.1102392-2-dkadashev@gmail.com>
 <20210713145341.lngtd5g3p6zf5eoo@wittgenstein>
In-Reply-To: <20210713145341.lngtd5g3p6zf5eoo@wittgenstein>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 13 Jul 2021 09:57:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjJeGY0FAs+WLaz-cxjhYcYvF1UXtZVmqoLbZH0jqn0Qg@mail.gmail.com>
Message-ID: <CAHk-=wjJeGY0FAs+WLaz-cxjhYcYvF1UXtZVmqoLbZH0jqn0Qg@mail.gmail.com>
Subject: Re: [PATCH 1/7] namei: clean up do_rmdir retry logic
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Dmitry Kadashev <dkadashev@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 13, 2021 at 7:53 AM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> Instead of naming all these $something_helper I would follow the
> underscore naming pattern we usually do, i.e. instead of e.g.
> rmdir_helper do __rmdir() or __do_rmdir().

That's certainly a pattern we have, but I don't necessarily love it.

It would be even better if we'd have names that actually explain
what/why the abstraction exists. In this case, it's the "possibly
retry due to ESTALE", but I have no idea how to sanely name that.
Making it "try_rmdir()" or something like that is the best I can come
up with right now.

On  a similar note, the existing "do_rmdir()" and friends aren't
wonderful names either, but we expose that name out so changing it is
probably not worth it. But right now we have "vfs_rmdir()" and
"do_rmdir()", and they are just different levels of the "rmdir stack",
without the name really describing where in the stack they are.

Naming is hard, and I don't think the double underscores have been
wonderful either.

            Linus
