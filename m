Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E4F216B98
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 13:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgGGLc6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 07:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbgGGLc5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 07:32:57 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F35C061755;
        Tue,  7 Jul 2020 04:32:57 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id c16so42755283ioi.9;
        Tue, 07 Jul 2020 04:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W8ex225kaSlTw3bKIjQVMp0nQkgTYotTwezAeDJJGSM=;
        b=V0VDkhWyiWeGyV+CN+dV54Jnb8Nt8eFvJmNyrzeALh2XaauRfX0i4VhIEJ5v9cZR54
         TUd3dawNxnyDGld6umFTsrpEZeosRDpxdsqDQRflh7n8Ge+w5T99GP//WdJyZM5QGAL9
         CVyROJ4mUi7d3irvAk0zNURosRTdi2f3i8EBXAIM7AsE0vBlq44rXf3B/uT+pZHvmrNz
         UEzCmZJmEHuKSTrHZVYReka0NBH155TdG8oYl9VtY3bjvROi67EIKTraBw2f0uPd75zh
         jGXnDXWcU9h2O9kCNJ+IuQvn+i4F9cMo1z9mkHPO3kSrt8cSkqRkA/sYJB5nxYBj470b
         pN6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W8ex225kaSlTw3bKIjQVMp0nQkgTYotTwezAeDJJGSM=;
        b=ku1CWfn32PkPeyY50bvxbiAOFzStl56JdlffiGDZ5CEpbMo6IVxtYC+pK+tlYeLMRD
         yLvjQGVKyd8nvvy+PrFuYiUv+c2uyrVwgjl3v87rI+E5M+Z+zh+kcC+Vx+5o0wT2Zj7G
         3dHgHHIjiDskmKlQMsBLRsBfABrEM3MBewZlbRze5VaR2Yj8xwLmW2IxftOiLeTb9BLY
         ibngSjBuShQtwONlhFXylA2cTL7/RfDMgA5UdqUc6W9AdR7yGRN+dUaR5NzjkfyM0+ij
         BH1FJyMwSY8meY6+RnHxtmXFBbomCt67thSb3fi9jB6VXXttnjh2+KIgU4ab/qD7hi9w
         24MQ==
X-Gm-Message-State: AOAM533TJE7rx4yOj3UW2dszy2eirth7lgH+XuPWSLSdjuCirUhCpDGn
        VeuYEg+6dy4hGPvn+7k3Vlc/3D0g9geK0yJSvSo=
X-Google-Smtp-Source: ABdhPJzuuI6n7OsTdd7jnUI/qPbTnVF/a+HsCSK/l7Rso+5GNXncpB05vSj3V+aHPq7XbW31Ea8gnQV2CmT1CRNtnpI=
X-Received: by 2002:a02:1784:: with SMTP id 126mr60838088jah.53.1594121576660;
 Tue, 07 Jul 2020 04:32:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200618144355.17324-1-axboe@kernel.dk> <20200618144355.17324-8-axboe@kernel.dk>
In-Reply-To: <20200618144355.17324-8-axboe@kernel.dk>
From:   =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date:   Tue, 7 Jul 2020 13:32:44 +0200
Message-ID: <CAHpGcM+iUnrLg+2jLzUPS45+E0ne8EiNEHt81Bjqko51u--+CA@mail.gmail.com>
Subject: Re: [PATCH 07/15] mm: add support for async page locking
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens,

Am Do., 18. Juni 2020 um 16:47 Uhr schrieb Jens Axboe <axboe@kernel.dk>:
> Normally waiting for a page to become unlocked, or locking the page,
> requires waiting for IO to complete. Add support for lock_page_async()
> and wait_on_page_locked_async(), which are callback based instead. This
> allows a caller to get notified when a page becomes unlocked, rather
> than wait for it.
>
> We add a new iocb field, ki_waitq, to pass in the necessary data for this
> to happen. We can unionize this with ki_cookie, since that is only used
> for polled IO. Polled IO can never co-exist with async callbacks, as it is
> (by definition) polled completions. struct wait_page_key is made public,
> and we define struct wait_page_async as the interface between the caller
> and the core.
>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/fs.h      |  7 ++++++-
>  include/linux/pagemap.h | 17 ++++++++++++++++
>  mm/filemap.c            | 45 ++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 67 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 6c4ab4dc1cd7..6ac919b40596 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -315,6 +315,8 @@ enum rw_hint {
>  #define IOCB_SYNC              (1 << 5)
>  #define IOCB_WRITE             (1 << 6)
>  #define IOCB_NOWAIT            (1 << 7)
> +/* iocb->ki_waitq is valid */
> +#define IOCB_WAITQ             (1 << 8)
>
>  struct kiocb {
>         struct file             *ki_filp;
> @@ -328,7 +330,10 @@ struct kiocb {
>         int                     ki_flags;
>         u16                     ki_hint;
>         u16                     ki_ioprio; /* See linux/ioprio.h */
> -       unsigned int            ki_cookie; /* for ->iopoll */
> +       union {
> +               unsigned int            ki_cookie; /* for ->iopoll */
> +               struct wait_page_queue  *ki_waitq; /* for async buffered IO */
> +       };
>
>         randomized_struct_fields_end
>  };
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 2f18221bb5c8..e053e1d9a4d7 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -535,6 +535,7 @@ static inline int wake_page_match(struct wait_page_queue *wait_page,
>
>  extern void __lock_page(struct page *page);
>  extern int __lock_page_killable(struct page *page);
> +extern int __lock_page_async(struct page *page, struct wait_page_queue *wait);
>  extern int __lock_page_or_retry(struct page *page, struct mm_struct *mm,
>                                 unsigned int flags);
>  extern void unlock_page(struct page *page);
> @@ -571,6 +572,22 @@ static inline int lock_page_killable(struct page *page)
>         return 0;
>  }
>
> +/*
> + * lock_page_async - Lock the page, unless this would block. If the page
> + * is already locked, then queue a callback when the page becomes unlocked.
> + * This callback can then retry the operation.
> + *
> + * Returns 0 if the page is locked successfully, or -EIOCBQUEUED if the page
> + * was already locked and the callback defined in 'wait' was queued.
> + */
> +static inline int lock_page_async(struct page *page,
> +                                 struct wait_page_queue *wait)
> +{
> +       if (!trylock_page(page))
> +               return __lock_page_async(page, wait);
> +       return 0;
> +}
> +
>  /*
>   * lock_page_or_retry - Lock the page, unless this would block and the
>   * caller indicated that it can handle a retry.
> diff --git a/mm/filemap.c b/mm/filemap.c
> index c3175dbd8fba..e8aaf43bee9f 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1180,6 +1180,36 @@ int wait_on_page_bit_killable(struct page *page, int bit_nr)
>  }
>  EXPORT_SYMBOL(wait_on_page_bit_killable);
>
> +static int __wait_on_page_locked_async(struct page *page,
> +                                      struct wait_page_queue *wait, bool set)
> +{
> +       struct wait_queue_head *q = page_waitqueue(page);
> +       int ret = 0;
> +
> +       wait->page = page;
> +       wait->bit_nr = PG_locked;
> +
> +       spin_lock_irq(&q->lock);
> +       __add_wait_queue_entry_tail(q, &wait->wait);
> +       SetPageWaiters(page);
> +       if (set)
> +               ret = !trylock_page(page);
> +       else
> +               ret = PageLocked(page);
> +       /*
> +        * If we were succesful now, we know we're still on the
> +        * waitqueue as we're still under the lock. This means it's
> +        * safe to remove and return success, we know the callback
> +        * isn't going to trigger.
> +        */
> +       if (!ret)
> +               __remove_wait_queue(q, &wait->wait);
> +       else
> +               ret = -EIOCBQUEUED;
> +       spin_unlock_irq(&q->lock);
> +       return ret;
> +}
> +
>  /**
>   * put_and_wait_on_page_locked - Drop a reference and wait for it to be unlocked
>   * @page: The page to wait for.
> @@ -1342,6 +1372,11 @@ int __lock_page_killable(struct page *__page)
>  }
>  EXPORT_SYMBOL_GPL(__lock_page_killable);
>
> +int __lock_page_async(struct page *page, struct wait_page_queue *wait)
> +{
> +       return __wait_on_page_locked_async(page, wait, true);
> +}
> +
>  /*
>   * Return values:
>   * 1 - page is locked; mmap_lock is still held.
> @@ -2131,6 +2166,11 @@ ssize_t generic_file_buffered_read(struct kiocb *iocb,
>                 }
>
>  readpage:
> +               if (iocb->ki_flags & IOCB_NOWAIT) {
> +                       unlock_page(page);
> +                       put_page(page);
> +                       goto would_block;
> +               }

This hunk should have been part of "mm: allow read-ahead with
IOCB_NOWAIT set" ...

>                 /*
>                  * A previous I/O error may have been due to temporary
>                  * failures, eg. multipath errors.
> @@ -2150,7 +2190,10 @@ ssize_t generic_file_buffered_read(struct kiocb *iocb,
>                 }
>
>                 if (!PageUptodate(page)) {
> -                       error = lock_page_killable(page);
> +                       if (iocb->ki_flags & IOCB_WAITQ)
> +                               error = lock_page_async(page, iocb->ki_waitq);
> +                       else
> +                               error = lock_page_killable(page);
>                         if (unlikely(error))
>                                 goto readpage_error;
>                         if (!PageUptodate(page)) {
> --
> 2.27.0
>

Andreas
