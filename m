Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556A558931D
	for <lists+io-uring@lfdr.de>; Wed,  3 Aug 2022 22:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbiHCUYg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Aug 2022 16:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236138AbiHCUYf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Aug 2022 16:24:35 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1E61839C;
        Wed,  3 Aug 2022 13:24:34 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id ct13so10081126qvb.9;
        Wed, 03 Aug 2022 13:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B96Bdg0Onzy13s4UbCLzMdjvnIzLbs1ULEk+vwxhe6w=;
        b=mFNpMDWYQmBz4RM0qPHCKdPz3JSdS9ucyx/cPWERWMYyZr+LnBr/HfoI9HgbxRh+MX
         5HPqvCZgeyYMZhhyHiyauF/J+cHYBqm0D5LFuW70QqkCFkxgNVxPGmBONmVB0WKnKmmC
         wOKNiKpS2z3BaZUK5chEGmeofqTxGL+tSh92WIPAuvx3Y1+Ni9tpihVS9a0fPwCG9Na1
         W/AvTKR4oJaLR5pNH7TudPv9Hn7kpsU7pGLb7c7LFhQWb/HeaCvdnaLjYLko3FdBRSBS
         x7mAv5coCAencpv+t+przbZsdu2ERsUajGftT/IENDfLo5h5DRaT6ZsEn4cPQD0EQqwR
         jE2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B96Bdg0Onzy13s4UbCLzMdjvnIzLbs1ULEk+vwxhe6w=;
        b=itk7aW3pD0qu1hZJi3VKNC74dUuIw+OXXElRPuzVWrSFK4SU3/5IEtP5vYyr/6v7P8
         VD2DBXGvDBJJ07YtlCmlDLJSEo+6b8CfYwyKZqsWYlgjmEThx4yLYcccPetooizRVdHf
         ls9dwUaHb6EPiLsmBQCDJgpS7YLqFj6y/Y/kFhu7rk08qrn9yZGPk3yfGUEJOqHybtEQ
         Loveu3SuwfuwgirNnUj9qlUu9EETj6x7aa6pwjA0cC9Q8uTe61CmqbHT8a1ScUBRr1aw
         IsmFOQuima/cDQp08T0XqSlVLefNd8yVfyLRv1xxVidTwYXHARvKLp0PwOevJPFvPbbS
         avJw==
X-Gm-Message-State: ACgBeo25RByOOirDVt4tVtxJ8BUS6eJunUf+M9U4dGfYiQKnUuGjaSAC
        E37voGGH81aMhKZ+OlKyb/RrHJBw6w==
X-Google-Smtp-Source: AA6agR4zPKE+bteQz7BICzyQdDD01B8OZ+skbS9NvxF6LTbmkCquatAxhuNVjhJ3ZBa7Pdm0mVzWfA==
X-Received: by 2002:a0c:cb0c:0:b0:476:d5e7:e0ca with SMTP id o12-20020a0ccb0c000000b00476d5e7e0camr8783614qvk.57.1659558273197;
        Wed, 03 Aug 2022 13:24:33 -0700 (PDT)
Received: from bytedance ([74.199.177.246])
        by smtp.gmail.com with ESMTPSA id dm40-20020a05620a1d6800b006a6ab259261sm3415250qkb.29.2022.08.03.13.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 13:24:31 -0700 (PDT)
Date:   Wed, 3 Aug 2022 13:24:26 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Eric Paris <eparis@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: Re: [PATCH] audit, io_uring, io-wq: Fix memory leak in
 io_sq_thread() and io_wqe_worker()
Message-ID: <20220803202426.GA31375@bytedance>
References: <20220803050230.30152-1-yepeilin.cs@gmail.com>
 <CAHC9VhRXypjNgDAwdARZz-md_DaSTs+9BpMik8AzWojG7ChexA@mail.gmail.com>
 <CAHC9VhRYGgCLiWx5LCoqgTj_RW_iQRLrzivWci7_UneN_=rwmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRYGgCLiWx5LCoqgTj_RW_iQRLrzivWci7_UneN_=rwmw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On Wed, Aug 03, 2022 at 03:28:19PM -0400, Paul Moore wrote:
> On Wed, Aug 3, 2022 at 9:16 AM Paul Moore <paul@paul-moore.com> wrote:
> > On Wed, Aug 3, 2022 at 1:03 AM Peilin Ye <yepeilin.cs@gmail.com> wrote:
> > > Hi all,
> > >
> > > A better way to fix this memleak would probably be checking
> > > @args->io_thread in copy_process()?  Something like:
> > >
> > >     if (args->io_thread)
> > >         retval = audit_alloc_kernel();
> > >     else
> > >         retval = audit_alloc();
> > >
> > > But I didn't want to add another if to copy_process() for this bugfix.
> > > Please suggest, thanks!
> >
> > Thanks for the report and patch!  I'll take a closer look at this
> > today and get back to you.
> 
> I think the best solution to this is simply to remove the calls to
> audit_alloc_kernel() in the io_uring and io-wq code, as well as the
> audit_alloc_kernel() function itself.  As long as create_io_thread()
> ends up calling copy_process to create the new kernel thread the
> audit_context should be allocated correctly.  Peilin Ye, are you able
> to draft a patch to do that and give it a test?

Sure, I will write a v2 today.  Thanks for the suggestion!

> For those that may be wondering how this happened (I definitely was!),
> it looks like when I first started working on the LSM/audit support
> for io_uring it was before the v5.12-rc1 release when
> create_io_thread() was introduced.  Prior to create_io_thread() it
> appears that io_uring/io-wq wasn't calling into copy_process() and
> thus was not getting an audit_context allocated in the kernel thread's
> task_struct; the solution for those original development drafts was to
> add a call to a new audit_alloc_kernel() which would handle the
> audit_context allocation.  Unfortunately, I didn't notice the move to
> create_io_thread() during development and the redundant
> audit_alloc_kernel() calls remained :/

Thanks,
Peilin Ye

