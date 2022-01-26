Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1B049C0CF
	for <lists+io-uring@lfdr.de>; Wed, 26 Jan 2022 02:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbiAZBmE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Jan 2022 20:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235906AbiAZBmE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Jan 2022 20:42:04 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFACC06173B
        for <io-uring@vger.kernel.org>; Tue, 25 Jan 2022 17:42:03 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so4683451pjp.0
        for <io-uring@vger.kernel.org>; Tue, 25 Jan 2022 17:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=jcmJBIHPwHjznYtDDk6Boea8e5KryTYO/GlCBZebjjA=;
        b=LOwzPM1SoqHGYd2SxQWQ8hws35Uh7wvjYPKYB5Vh9boIA9KB527XTHrptuNGzj2Uh2
         9Gzd2tVgY2UZyHU48NroEeNTAWCywS2x9INKK+1IK5i9lsAZCMTaZzmA4LWILH3HimDC
         wfJh0+pz/FeSZ5hr/mvz+1AhQjAETXbg8E1NLIjPZ3vvoGZraatWgm9+Q68bDIl3wiqD
         SLu42ZcdTKzdWP5hUXqLGNflzredT1NSUsJ4f59mxVCJcXFpR9mdl3eWf1mYPJ+Xksqi
         K+VDa96hrD3GXv6dOyFhbbKx4sZ70jFhGbqt02q98tBDPsDVYbBv/CWJ9vhk+cSWFwOF
         5BDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=jcmJBIHPwHjznYtDDk6Boea8e5KryTYO/GlCBZebjjA=;
        b=nqLNWwTfkM0ptgUrQ5sPiaNWQ635/p7vrZQJzpvtmQElRaLxXwpuHErRCsILnQ2jNC
         2xLMKHK6FmbD8bwJoCoGA7ltxHnbEaHVJW9joaaGUDvay13Q5NqAFNvqFWNakzkPcF6A
         TkhAfMzzKo19vdbG0wtDeFScSFZYZLcvkT9JpVmSYA2APbLZAC8Vz7bZ0GVvr6OX/07u
         wlOKTCCxBW0g2hyYKrff6Hl4w+5WdEQMwuYNdxbbyWE0iszm9/nFL3i2ILK7PrrgzKTz
         1qSYEoer41G436YRbalLU7Be+u6XRl9dn4ttl/aExRef03KirqF+O/ug2KNeAynEmpEn
         bSIg==
X-Gm-Message-State: AOAM533gGwPmUJgc7cvFZFG253e/NYmTwNz8tgYD4k9TY0zD/AllGKWq
        /VRypcHkWcdmK8T3mV/8Iqo+1G6jlrw0tg==
X-Google-Smtp-Source: ABdhPJx+SJ7RolZNSesy0gS5Wemy2a8+KnwlbY3SOtckqU1aE7x7sgZI+kUHGuvyC4nw0We4h+a5Vg==
X-Received: by 2002:a17:90a:aa95:: with SMTP id l21mr6393110pjq.207.1643161322880;
        Tue, 25 Jan 2022 17:42:02 -0800 (PST)
Received: from [2620:15c:29:204:6f7a:fc02:d37c:a8b0] ([2620:15c:29:204:6f7a:fc02:d37c:a8b0])
        by smtp.gmail.com with ESMTPSA id nv13sm1561492pjb.18.2022.01.25.17.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 17:42:01 -0800 (PST)
Date:   Tue, 25 Jan 2022 17:42:01 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
To:     Shakeel Butt <shakeelb@google.com>
cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org
Subject: Re: [PATCH] mm: io_uring: allow oom-killer from io_uring_setup
In-Reply-To: <CALvZod5B_nQdU_MHmcYyOpHhGrv5YUnMY-rBPE11Tou6XU_mSA@mail.gmail.com>
Message-ID: <a3bf6a4a-96ef-755e-12d5-56f4d792a34f@google.com>
References: <20220125051736.2981459-1-shakeelb@google.com> <2bec4db-1533-2d39-77f9-bf613fc262d9@google.com> <CALvZod5B_nQdU_MHmcYyOpHhGrv5YUnMY-rBPE11Tou6XU_mSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 25 Jan 2022, Shakeel Butt wrote:

> > > On an overcommitted system which is running multiple workloads of
> > > varying priorities, it is preferred to trigger an oom-killer to kill a
> > > low priority workload than to let the high priority workload receiving
> > > ENOMEMs. On our memory overcommitted systems, we are seeing a lot of
> > > ENOMEMs instead of oom-kills because io_uring_setup callchain is using
> > > __GFP_NORETRY gfp flag which avoids the oom-killer. Let's remove it and
> > > allow the oom-killer to kill a lower priority job.
> > >
> >
> > What is the size of the allocations that io_mem_alloc() is doing?
> >
> > If get_order(size) > PAGE_ALLOC_COSTLY_ORDER, then this will fail even
> > without the __GFP_NORETRY.  To make the guarantee that workloads are not
> > receiving ENOMEM, it seems like we'd need to guarantee that allocations
> > going through io_mem_alloc() are sufficiently small.
> >
> > (And if we're really serious about it, then even something like a
> > BUILD_BUG_ON().)
> >
> 
> The test case provided to me for which the user was seeing ENOMEMs was
> io_uring_setup() with 64 entries (nothing else).
> 
> If I understand rings_size() calculations correctly then the 0 order
> allocation was requested in io_mem_alloc().
> 
> For order > PAGE_ALLOC_COSTLY_ORDER, maybe we can use
> __GFP_RETRY_MAYFAIL. It will at least do more aggressive reclaim
> though I think that is a separate discussion. For this issue, we are
> seeing ENOMEMs even for order 0 allocations.
> 

Ah, gotcha, thanks for the background.  IIUC, io_uring_setup() can be done 
with anything with CAP_SYS_NICE so my only concern would be whether this 
could be used maliciously on a system not using memcg, but in that case we 
can already fork many small processes that consume all memory and oom kill 
everything else on the system already.
