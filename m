Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9667C43B014
	for <lists+io-uring@lfdr.de>; Tue, 26 Oct 2021 12:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhJZKfm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Oct 2021 06:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbhJZKfj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Oct 2021 06:35:39 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F724C061745
        for <io-uring@vger.kernel.org>; Tue, 26 Oct 2021 03:33:15 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id e138so22646139ybc.3
        for <io-uring@vger.kernel.org>; Tue, 26 Oct 2021 03:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/K8qRfWz6WWnF1FBtemCSJ/+bgi/DzOjq0Ewdft0ykE=;
        b=ci1iwdu7guUxzCoYsuDdjBgySP8gXtcqkgQueGBwXsrDB8txBq1LcsLAIYwygM8tJV
         9eQ2gogUmsPJQSu6I3q4ouqvQKo7D0mSHEKw/2Xpo3C8la3OupZN4I+pYSECb3wRAZxX
         3y/pgn6kb01k9igShzYvVxv8AvhV3ikrHUKTF+KwCfKdBFb8+i0LINxFeHL+IkLyR0yz
         TmJ70h1aek3rnGwvcjDV8aQAA7ZpzQFJFTgMd/tb8D9x5lJUZ43htNIyq17p/BmFzD9l
         6rHpqEiPavWv63TdftPSHrZ11MyRD5unS8Ep0+Ss73sU8HMN5S7yMHE1t3sCkEHLfbck
         AF3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/K8qRfWz6WWnF1FBtemCSJ/+bgi/DzOjq0Ewdft0ykE=;
        b=n0xQRPS6E/Mhw++DbHiY5uizVvEaJIAZFNwFDTRrQ9kjJPtINKB8H5ATD9jSYBRaDt
         bCWiPRYhIP2HY93Xed7y7uY47ub7qoPyCNIFBt3rtaEfJZw3GQJJspaKmTEFbUxAnJqx
         nVoZFj0MpUHzMdZoCB7bdDP2Z6IXg76b71ld06EaDf+m8zYmCERmbPPLwS+cXgYuu9cG
         zBf5PuE6FupbfpaRzkPpVEKyUad4rPrhWtK6um7okyEZRvB+GwsIlB2zgYoumGPin8QL
         5Ivd7IXULyxKO8cnOUZV5pRdLDRvjkz84yDR8O2WOLNJZAIBIFRNsjy7E9Ipa7660wpX
         2Zmg==
X-Gm-Message-State: AOAM532F3AqHtob2pAqtI7P2aOF2ZyuD9WXLoX05CJJEfxWFJGEkmxMM
        RGnGknR34+0qTsFz1I0eIEzoXa3DMki+6t9eu2ZKww==
X-Google-Smtp-Source: ABdhPJx0hMX0lwPetHg9MgsT5TyVvVJGwRpb9keYjE9mznzxA4MWUGRj85dix2FR3dP6TFMJ2nAFMyw6m9l06kb5EhY=
X-Received: by 2002:a25:fc08:: with SMTP id v8mr24492265ybd.404.1635244394513;
 Tue, 26 Oct 2021 03:33:14 -0700 (PDT)
MIME-Version: 1.0
References: <20211026032304.30323-1-qiang.zhang1211@gmail.com>
In-Reply-To: <20211026032304.30323-1-qiang.zhang1211@gmail.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 26 Oct 2021 18:32:38 +0800
Message-ID: <CAMZfGtUXq=nQyijktRaP7xp=sAmVCryTjU4Jo5Z=ufed8arnKQ@mail.gmail.com>
Subject: Re: [PATCH] io-wq: Remove unnecessary rcu_read_lock/unlock() in raw
 spinlock critical section
To:     Zqiang <qiang.zhang1211@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Oct 26, 2021 at 11:23 AM Zqiang <qiang.zhang1211@gmail.com> wrote:
>
> Due to raw_spin_lock/unlock() contains preempt_disable/enable() action,
> already regarded as RCU critical region, so remove unnecessary
> rcu_read_lock/unlock().
>
> Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
> ---
>  fs/io-wq.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index cd88602e2e81..401be005d089 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -855,9 +855,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
>         io_wqe_insert_work(wqe, work);
>         clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
>
> -       rcu_read_lock();

Add a comment like:
/* spin_lock can serve as an RCU read-side critical section. */

With that.

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

Thanks.

>         do_create = !io_wqe_activate_free_worker(wqe, acct);
> -       rcu_read_unlock();
>
>         raw_spin_unlock(&wqe->lock);
>
> --
> 2.17.1
>
