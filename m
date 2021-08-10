Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A8F3E5A1B
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 14:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240651AbhHJMjy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 08:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240634AbhHJMjv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 08:39:51 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB813C061798;
        Tue, 10 Aug 2021 05:39:29 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id d131-20020a1c1d890000b02902516717f562so2429091wmd.3;
        Tue, 10 Aug 2021 05:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NLK72B5urU0UwVv0qLYpZgO0C3RQFN8VOZ4PaW442xk=;
        b=P/IX2RmDusrmcB4jW//WJS0K/rp9UXsF/Rn33G31uI2qY4eHS2Kx1J6tppJJNRDPF0
         twAgtPphTE/ZurlT1p1qzCY7gl65ldvrWezKLtdjfe9QtnNAHRyLVneEMvdAmtkRkGGS
         Q9IK8kD9unUvybY0y+ZrIcLeGDJaDTHLjrG3OPz3tAgoNfmdaibvm6qQvltwB+3U1QzE
         lqOzBd90ilgxxGWEZ98RAn+z/qsTvHjn9gof0lrxqqCaG61NYdHB09UntcCYZ02Y02cL
         qXY5grDCtX7GVrZGFv3X/nqQe7KW65s+mJjvTPlASVHfqmxkpuq+8yVOUv31vh6OJZbN
         1/PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NLK72B5urU0UwVv0qLYpZgO0C3RQFN8VOZ4PaW442xk=;
        b=HQriX2KwJxmagTzuaa+mSzo0n8vutTHhqNGMCIeuydE/ers6Qg7srlkcoFZGZaw+pm
         3vKC7Fx84IjKfBAHXXhjh99wz+Pa+xXZ5d4bMDpai/8ruEBpti2KUMJam8/hOvNb2AB1
         4f2PEUdbpMI1W5mJqRl7/zuQS2mt4OuXNXrprGyN3YgGL2XjJGukk8Mp5GqGFOcJ9607
         DYdU+tw91cn9YjsRu6SkOIh1IVkNcYn2J+Tejdmi4CShuGzuM+mn5N/9TRpQc+crzALB
         tqFSXBaprJRjiNJHDZf6J+qn6En2l17XGbZ9d0+omwST3u4GtGVPnH8lJu+EodEIRLJU
         +CIg==
X-Gm-Message-State: AOAM531dK5TlJn6TxvfGRdDb5kBiqe4hW9309hK72bMsxeAsOnPjJhzX
        14b0vbW1ig2LH2TwA/ekx7qna+gHm+EhevBPRPI=
X-Google-Smtp-Source: ABdhPJwhRBR8EwNHVtrEr1Di4rhxi01q7oV+u6/ee4sUUDvaAPd/g50MUPeuWXHl+er8MQdbBoHfDV1OumEI3CeAF6g=
X-Received: by 2002:a1c:4606:: with SMTP id t6mr14312334wma.25.1628599168308;
 Tue, 10 Aug 2021 05:39:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210809212401.19807-1-axboe@kernel.dk> <20210809212401.19807-5-axboe@kernel.dk>
In-Reply-To: <20210809212401.19807-5-axboe@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 10 Aug 2021 18:09:03 +0530
Message-ID: <CA+1E3rKS+m6kuci7PmRw7LUbwVmF-ge6AV78SSnAkdegK0__Gw@mail.gmail.com>
Subject: Re: [PATCH 4/4] block: enable use of bio allocation cache
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 10, 2021 at 6:40 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> If a kiocb is marked as being valid for bio caching, then use that to
> allocate a (and free) new bio if possible.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/block_dev.c | 30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)
>
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 9ef4f1fc2cb0..36a3d53326c0 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -327,6 +327,14 @@ static int blkdev_iopoll(struct kiocb *kiocb, bool wait)
>         return blk_poll(q, READ_ONCE(kiocb->ki_cookie), wait);
>  }
>
> +static void dio_bio_put(struct blkdev_dio *dio)
> +{
> +       if (!dio->is_sync && (dio->iocb->ki_flags & IOCB_ALLOC_CACHE))
> +               bio_cache_put(&dio->bio);

I think the second check (against IOCB_ALLOC_CACHE) is sufficient here.
