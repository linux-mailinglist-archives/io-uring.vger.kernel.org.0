Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E67215EC3E
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 18:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391861AbgBNRZ7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 12:25:59 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:33568 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391020AbgBNRZ5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 12:25:57 -0500
Received: by mail-ot1-f66.google.com with SMTP id w6so669852otk.0
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2020 09:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pSMjarGrsUPgAx4tKo+8H+L0Szt0s9yVAf2VYNsMa0o=;
        b=mvatJYP90LnHgm4N3PgyesVQnHTRUe3LaAPWZ8NIe/6hGTT9VXzGU4p93LbBGMbcjX
         /yS+R0dEibti1vzOD9ljhXo77ULGzns2X3pNni2DVSQZLibtfeHATYRWKLw7hUcFvwrb
         kZvvSwqU8+PCs/3gZBUwSpBAWg2eV6/8nYAhDloNoFzfqXj3FLn0igJIUnlgGxFRnqp7
         Yyx9Tbb5VcHJwVWeLWoCCt8BWIUPNSuibtHv9hDWURcgYOJUrI1WjA+YHwa/H24k6Wic
         UcGcSvj50fKLOtLiH8Xl62mzM2CoJd6JwKQw4ClcmGH5keWOYMc+C2kftdXdx+iFwwWv
         zolQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pSMjarGrsUPgAx4tKo+8H+L0Szt0s9yVAf2VYNsMa0o=;
        b=Lp2JQpsYYHcTDu/cw6dWO6w1xBYmwamfgrIjMgh2nefh8vQCUkQbzLQ4d1mkB9u5eV
         7Q6jADIc3tsmy0qKcBzzYVitaK7lNgLFk14I9UTElzIKRQAfSc/aO7VXM9zLdpSD+zaU
         LZR1KB/gA/8okKZS/3T12eptC6Rz7+F3SutXdw+JdMN7/meZQKlFgfn27jpCvbDMx52Q
         kjHo/1uuLkPbLcSMydVbUVxNs52qkQj0LRK6JWn9bY8UzvcAhQhyesbYSmHwldZ64IHf
         dYsFM2rnt6BBzXh2lrciy8tiKyUuQ5N3CmNxdJ70KzjfGmt0c1peAmBub38ybGH4NUQ4
         eowg==
X-Gm-Message-State: APjAAAX4gJoM0TIaTrB+lhCnkIrMA5l6mmk1S8UgpxG1pkT2bM5xDqZB
        c7LJ0ld9qaFDShWOJEn1QpS3wQG0gwuucnCPDTHTbA==
X-Google-Smtp-Source: APXvYqxPBAMd0tGmcjPd0FZvV4wf35i2R/TBjgEwIelMFvAF+MVxbxS6HVKJ8WwbllYOc5XQ8Fb54aD+vOj9De/2vRU=
X-Received: by 2002:a05:6830:1d6e:: with SMTP id l14mr3117234oti.32.1581701156723;
 Fri, 14 Feb 2020 09:25:56 -0800 (PST)
MIME-Version: 1.0
References: <20200214170520.160271-1-minchan@kernel.org> <20200214170520.160271-2-minchan@kernel.org>
In-Reply-To: <20200214170520.160271-2-minchan@kernel.org>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 14 Feb 2020 18:25:30 +0100
Message-ID: <CAG48ez3S5+EasZ1ZWcMQYZQQ5zJOBtY-_C7oz6DMfG4Gcyig1g@mail.gmail.com>
Subject: Re: [PATCH v5 1/7] mm: pass task and mm to do_madvise
To:     Minchan Kim <minchan@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Linux API <linux-api@vger.kernel.org>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Tim Murray <timmurray@google.com>,
        Daniel Colascione <dancol@google.com>,
        Sandeep Patil <sspatil@google.com>,
        Sonny Rao <sonnyrao@google.com>,
        Brian Geffon <bgeffon@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        John Dias <joaodias@google.com>,
        Joel Fernandes <joel@joelfernandes.org>, sj38.park@gmail.com,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

+Jens and io-uring list

On Fri, Feb 14, 2020 at 6:06 PM Minchan Kim <minchan@kernel.org> wrote:
> In upcoming patches, do_madvise will be called from external process
> context so we shouldn't asssume "current" is always hinted process's
> task_struct.
[...]
> [1] http://lore.kernel.org/r/CAG48ez27=pwm5m_N_988xT1huO7g7h6arTQL44zev6TD-h-7Tg@mail.gmail.com
[...]
> diff --git a/fs/io_uring.c b/fs/io_uring.c
[...]
> @@ -2736,7 +2736,7 @@ static int io_madvise(struct io_kiocb *req, struct io_kiocb **nxt,
>         if (force_nonblock)
>                 return -EAGAIN;
>
> -       ret = do_madvise(ma->addr, ma->len, ma->advice);
> +       ret = do_madvise(current, current->mm, ma->addr, ma->len, ma->advice);
>         if (ret < 0)
>                 req_set_fail_links(req);
>         io_cqring_add_event(req, ret);

Jens, can you have a look at this change and the following patch
<https://lore.kernel.org/linux-mm/20200214170520.160271-4-minchan@kernel.org/>
("[PATCH v5 3/7] mm: check fatal signal pending of target process")?
Basically Minchan's patch tries to plumb through the identity of the
target task so that if that task gets killed in the middle of the
operation, the (potentially long-running and costly) madvise operation
can be cancelled. Just passing in "current" instead (which in this
case is the uring worker thread AFAIK) doesn't really break anything,
other than making the optimization not work, but I wonder whether this
couldn't be done more cleanly - maybe by passing in NULL to mean "we
don't know who the target task is", since I think we don't know that
here?
