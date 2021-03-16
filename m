Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD2C33DD9B
	for <lists+io-uring@lfdr.de>; Tue, 16 Mar 2021 20:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbhCPTdb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Mar 2021 15:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237305AbhCPTdA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Mar 2021 15:33:00 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96740C061756
        for <io-uring@vger.kernel.org>; Tue, 16 Mar 2021 12:32:59 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so4093469pjb.1
        for <io-uring@vger.kernel.org>; Tue, 16 Mar 2021 12:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m51X9CHwtfCE5IH0P5AqXawZY6zUnwHs3ugCFSUHYWY=;
        b=O7izbeJETQwKGKZ937uPGZzffYmkBls3HZoWUKMlGCiundJ7Esi6XAj8SgsJvWW0bv
         EJUFAG+4vJqYaQUGivkM98LHXg2BKzD8QVMa4YwQpHq1qpaDrWp8lpCb3ag0Q4QiV/vF
         6tH4HcqcvVGLbNhOh8UgqfrH9b3TNRcSjeCPw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m51X9CHwtfCE5IH0P5AqXawZY6zUnwHs3ugCFSUHYWY=;
        b=Uj0nPQg6Ga+/mzKZRAcF7w9mI4fGoKNM5/tJJo1K2nIRAu/3qjBli8SYvqa9ugvUZc
         dF6+UxadfL0Qj/3MpL+Al6vDNhbWzg2bNKmTxvnHKRt2oxlAe9baO8hth4dMdxyrOxzj
         HZQQ9TW8ER3IuFk2zLJqr6My3swGzP26jSXX6R+UZWJ5UouyKDZ7yyJqRk3ug0EeoV6k
         BUkZD93kwSebRXQTdZ1l1U2/E9uLCmjkbk5cQmStnpmW+7y14nfSTtkPQ4AZ6MQLJYKd
         YJSldxnwISELru5CMkUeFiIoxLhnJpRiIf9TVC2fNhiZXOCh3SviqKvtGoIIGGaG1JvK
         3gag==
X-Gm-Message-State: AOAM530p7WJQIwe3ILSPWjQuhize6FRTjp4iFAgFRj3R0GrgphFYdIuL
        ngaWXq8x3Ah2KMbOlCTrw9RYow==
X-Google-Smtp-Source: ABdhPJymLmZUQcJf9mTPzHM6y4qPylvnlWR8uKp+iBIhoMb95+cXNuw7H/BK680P/1W8mJYXiVs6sg==
X-Received: by 2002:a17:902:c1d5:b029:e6:52e0:6bdd with SMTP id c21-20020a170902c1d5b02900e652e06bddmr902471plc.49.1615923179208;
        Tue, 16 Mar 2021 12:32:59 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id fr23sm193056pjb.22.2021.03.16.12.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 12:32:58 -0700 (PDT)
Date:   Tue, 16 Mar 2021 12:32:57 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Alexey Gladkov <gladkov.alexey@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Alexey Gladkov <legion@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 3/8] Use atomic_t for ucounts reference counting
Message-ID: <202103161229.75FDE42F@keescook>
References: <cover.1615372955.git.gladkov.alexey@gmail.com>
 <59ee3289194cd97d70085cce701bc494bfcb4fd2.1615372955.git.gladkov.alexey@gmail.com>
 <202103151426.ED27141@keescook>
 <CAHk-=wjYOCgM+mKzwTZwkDDg12DdYjFFkmoFKYLim7NFmR9HBg@mail.gmail.com>
 <202103161146.E118DE5@keescook>
 <CAHk-=wj7k2nCB8Q5kMYsYi1ajb99yZ-EYn_MYFMQ2bw3nWuT5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj7k2nCB8Q5kMYsYi1ajb99yZ-EYn_MYFMQ2bw3nWuT5Q@mail.gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 16, 2021 at 12:26:05PM -0700, Linus Torvalds wrote:
> Note that the above very intentionally does allow the "we can go over
> the limit" case for another reason: we still have that regular
> *unconditional* get_page(), that has a "I absolutely need a temporary
> ref to this page, but I know it's not some long-term thing that a user
> can force". That's not only our traditional model, but it's something
> that some kernel code simply does need, so it's a good feature in
> itself. That might be less of an issue for ucounts, but for pages, we
> somethines do have "I need to take a ref to this page just for my own
> use while I then drop the page lock and do something else".

Right, get_page() has a whole other set of requirements. :) I just
couldn't find the "we _must_ to get a reference to ucounts" code path,
so I was scratching my head.

> And it's possible that "refcount_t" could use that exact same model,
> and actually then offer that option that ucounts wants, of a "try to
> get a refcount, but if we have too many refcounts, then never mind, I
> can just return an error to user space instead".

Yeah, if there starts to be more of these cases, I think it'd be a
nice addition. And with the recent performance work Will Deacon did on
refcount_t, I think any general performance concerns are met now. But
I'd love to just leave refcount_t alone until we can really show a need
for an API change. :P

-- 
Kees Cook
