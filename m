Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F09D49BF32
	for <lists+io-uring@lfdr.de>; Tue, 25 Jan 2022 23:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbiAYW6H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Jan 2022 17:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234789AbiAYW6G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Jan 2022 17:58:06 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14578C06173B
        for <io-uring@vger.kernel.org>; Tue, 25 Jan 2022 14:58:06 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id o12so16185093lfg.12
        for <io-uring@vger.kernel.org>; Tue, 25 Jan 2022 14:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vUEaRvAeqO4wB5ShFfH+VshVtU3ztYzAw/eGT2KcLXg=;
        b=emXX7F+vgI8KhnQH9o8EoWDuLk34WEtKEuctbuMWmeiFTDs04Yti6LC1oiu8hvoE0F
         6zHK6uDducjGcgdYBRTb/60kK0eZSzL099gOzXGM+UvZ2vcGKri/cniF0gpJYUVnWRea
         6dGK8DLP2OcCP90vFMP7G/3sSDZi7vsl0YXErQRmv4pNYTWuvtBLkg0s3XkX0t93bXLX
         1OF5dZjc6ezxkmX4OZJavqEQKMXuh+0Jok/FvIWwPv+o/Ck56Z/kEONKFEdFsr8xnxJ3
         6kjKUATDq6/IYyps70N9u/r+ZwJx3zo8OXiUl5ue0/cHQkVTBeKKA9HgNz4/nTD/6vmB
         uMuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vUEaRvAeqO4wB5ShFfH+VshVtU3ztYzAw/eGT2KcLXg=;
        b=rbqbvLw+UeU7DgaqJEet/UcZIT3pkw7Zr6ieA55OTovjqZFKNIS+AlbMBd5sc68re1
         SLJAlmYBayrcfp0ZnWH2j8CLjzbrUPZ2zW+wq6lG0wcVIhtijSE6HvqHnuist6xFmP9z
         ex2AZuyL6UuFnfnALcExj1hWqin52j0YeoEOnBCcDzPEGRGClfurBpnj0tahwfoR22T4
         PFVm1znLZ4EF4MyPvi8KYg9EKgRHn7w4/ZE5MOJVBIkerGJVJu3NMJWpNPo52d6iFrOB
         nJ93eBaOS2RfY6NBI/G02V5bSeNUgDxb1quxHwZ8tkC/0yOFHcaCfAbOPK6nMNEw6932
         6Mjg==
X-Gm-Message-State: AOAM531UnhT9cQxQFlJbynkLtIz2BDG8HuF/ixSH9CtcWRQuUFueVaQv
        f3vS8rh+GqSd1xos330CUZCBlYHx29sKG8HbqpYUTg==
X-Google-Smtp-Source: ABdhPJzS7mt6iG3Pp05PQnOZLNNTR53sS7DB6BxYN+I6qmf5VodV069J0P5dkoLqwCzN7ToUVidHyehHCQRs1LfEyXA=
X-Received: by 2002:a05:6512:33d5:: with SMTP id d21mr18778383lfg.8.1643151483817;
 Tue, 25 Jan 2022 14:58:03 -0800 (PST)
MIME-Version: 1.0
References: <20220125051736.2981459-1-shakeelb@google.com> <2bec4db-1533-2d39-77f9-bf613fc262d9@google.com>
In-Reply-To: <2bec4db-1533-2d39-77f9-bf613fc262d9@google.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Tue, 25 Jan 2022 14:57:52 -0800
Message-ID: <CALvZod5B_nQdU_MHmcYyOpHhGrv5YUnMY-rBPE11Tou6XU_mSA@mail.gmail.com>
Subject: Re: [PATCH] mm: io_uring: allow oom-killer from io_uring_setup
To:     David Rientjes <rientjes@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jan 25, 2022 at 10:35 AM David Rientjes <rientjes@google.com> wrote:
>
> On Mon, 24 Jan 2022, Shakeel Butt wrote:
>
> > On an overcommitted system which is running multiple workloads of
> > varying priorities, it is preferred to trigger an oom-killer to kill a
> > low priority workload than to let the high priority workload receiving
> > ENOMEMs. On our memory overcommitted systems, we are seeing a lot of
> > ENOMEMs instead of oom-kills because io_uring_setup callchain is using
> > __GFP_NORETRY gfp flag which avoids the oom-killer. Let's remove it and
> > allow the oom-killer to kill a lower priority job.
> >
>
> What is the size of the allocations that io_mem_alloc() is doing?
>
> If get_order(size) > PAGE_ALLOC_COSTLY_ORDER, then this will fail even
> without the __GFP_NORETRY.  To make the guarantee that workloads are not
> receiving ENOMEM, it seems like we'd need to guarantee that allocations
> going through io_mem_alloc() are sufficiently small.
>
> (And if we're really serious about it, then even something like a
> BUILD_BUG_ON().)
>

The test case provided to me for which the user was seeing ENOMEMs was
io_uring_setup() with 64 entries (nothing else).

If I understand rings_size() calculations correctly then the 0 order
allocation was requested in io_mem_alloc().

For order > PAGE_ALLOC_COSTLY_ORDER, maybe we can use
__GFP_RETRY_MAYFAIL. It will at least do more aggressive reclaim
though I think that is a separate discussion. For this issue, we are
seeing ENOMEMs even for order 0 allocations.
