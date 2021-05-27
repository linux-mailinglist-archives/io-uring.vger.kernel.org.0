Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C188392AD5
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 11:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235794AbhE0JeP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 05:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235810AbhE0JeP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 05:34:15 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C016C061760
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 02:32:42 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id n2so4069953wrm.0
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 02:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WUOW0aYMYacTttJcw/Wumsyv7jlobDPzPKJRlWNJDUo=;
        b=Fts2SzA7NlCiuPjoPjAYz0zx8cr0BkxmM+vJOFkwElZMHyM96QfAfWgc3HTPRIM2QC
         C49jhHv2WAQz67scRFNGP9YEJt2Wc1WsuKrRbguWnhIPUWcEySLHMNKLG8Qawz2O6fTC
         fhLIoYwzBm25hTiWmUcFAxFCAi/rEKqFpTrPXs/BPgYDY/I1EOKRPJigzLc7HC5rCadX
         Dyow/rpWI3yLED1KeOsd9j3O8UADvwzpJjPcKg1BZwGjOYRp5iPhzJAs3E10eAQA5JgF
         pK2hVMDl6ma5AgA+JG9R2AYtZUyAM5Whr2ippvA1hHysyKmDsVk3vJE8gf/yBr1SLsIG
         DjPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WUOW0aYMYacTttJcw/Wumsyv7jlobDPzPKJRlWNJDUo=;
        b=i9vXa2Bw2HCYVKtpSXehlN7X7TGZk9llvW4PFEakE3BTQk4x51rBch3BKBEnPxnj7Y
         Y6EZVZOxVlmVq7Z/9zY8qUfRcliV7wCH3yJV1GlBl+q+eNM0oRmyOwSuAouaPwxw7ImC
         p9QmohAlc5Rs2Q1n7TsCIqlDLXQVKXE3MR7JV8pd10lPgGhFV4HeyPhFC3t8w3lBhVuE
         uIDfdBnK/oktBOLMXDpbLosKeoryZ8MJuH4hWoA9pqkO9/3pb6AUTjMZaL7eFTiN+hyB
         tJ7GuCSQK0CrCz41Pe7mB/chk10m/IuSsVbZC0AHV/YpY1Fpda2kvkA45JxSZ5TNwS69
         dHmA==
X-Gm-Message-State: AOAM530/OeokV5hHpEi+M2+yoXx40GSRtk7KOJpH/VluFNc64yxv6Pav
        u7m3GfazHhgoQM+QcsuqMLnEQQ==
X-Google-Smtp-Source: ABdhPJwsj+iam2ha503lEq0q3f2HZtIBTocjpt2H8N3qkS5YcOaGp/53yu6T35+G43Z0XoJA+yu7mg==
X-Received: by 2002:adf:f5c5:: with SMTP id k5mr2256885wrp.81.1622107960640;
        Thu, 27 May 2021 02:32:40 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:15:13:74ba:ff42:8494:7f35])
        by smtp.gmail.com with ESMTPSA id m6sm11820746wml.3.2021.05.27.02.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 02:32:39 -0700 (PDT)
Date:   Thu, 27 May 2021 11:32:34 +0200
From:   Marco Elver <elver@google.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+73554e2258b7b8bf0bbf@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [syzbot] KCSAN: data-race in __io_uring_cancel /
 io_uring_try_cancel_requests
Message-ID: <YK9nMgamPsr9YsoY@elver.google.com>
References: <000000000000fa9f7005c33d83b9@google.com>
 <YK5tyZNAFc8dh6ke@elver.google.com>
 <YK5uygiCGlmgQLKE@elver.google.com>
 <b5cff8b6-bd9c-9cbe-4f5f-52552d19ca48@gmail.com>
 <CANpmjNP1CKuoK82HCRYpDxDrvy4DgN9yVknfsxHSwfojx5Ttug@mail.gmail.com>
 <5cf2250a-c580-4dbf-5997-e987c7b71086@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cf2250a-c580-4dbf-5997-e987c7b71086@gmail.com>
User-Agent: Mutt/2.0.5 (2021-01-21)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 26, 2021 at 09:31PM +0100, Pavel Begunkov wrote:
> On 5/26/21 5:36 PM, Marco Elver wrote:
> > On Wed, 26 May 2021 at 18:29, Pavel Begunkov <asml.silence@gmail.com> wrote:
> >> On 5/26/21 4:52 PM, Marco Elver wrote:
> >>> Due to some moving around of code, the patch lost the actual fix (using
> >>> atomically read io_wq) -- so here it is again ... hopefully as intended.
> >>> :-)
> >>
> >> "fortify" damn it... It was synchronised with &ctx->uring_lock
> >> before, see io_uring_try_cancel_iowq() and io_uring_del_tctx_node(),
> >> so should not clear before *del_tctx_node()
> > 
> > Ah, so if I understand right, the property stated by the comment in
> > io_uring_try_cancel_iowq() was broken, and your patch below would fix
> > that, right?
> 
> "io_uring: fortify tctx/io_wq cleanup" broke it and the diff
> should fix it.
> 
> >> The fix should just move it after this sync point. Will you send
> >> it out as a patch?
> > 
> > Do you mean your move of write to io_wq goes on top of the patch I
> > proposed? (If so, please also leave your Signed-of-by so I can squash
> > it.)
> 
> No, only my diff, but you hinted on what has happened, so I would
> prefer you to take care of patching. If you want of course.
> 
> To be entirely fair, assuming that aligned ptr
> reads can't be torn, I don't see any _real_ problem. But surely
> the report is very helpful and the current state is too wonky, so
> should be patched.

In the current version, it is a problem if we end up with a double-read,
as it is in the current C code. The compiler might of course optimize
it into 1 read into a register.

Tangent: I avoid reasoning in terms of compiler optimizations where
I can. :-) It's is a slippery slope if the code in question isn't
tolerant to data races by design (examples are stats counting, or other
heuristics -- in the case here that's certainly not the case).
Therefore, my wish is that we really ought to resolve as many data races
as we can (+ mark intentional ones appropriately). Also, so that we're
left with only the interesting cases like in the case here.  (More
background if you're interested: https://lwn.net/Articles/816850/)

The problem here, however, has a nicer resolution as you suggested.

> TL;DR;
> The synchronisation goes as this: it's usually used by the owner
> task, and the owner task deletes it, so is mostly naturally
> synchronised. An exception is a worker (not only) that accesses
> it for cancellation purpose, but it uses it only under ->uring_lock,
> so if removal is also taking the lock it should be fine. see
> io_uring_del_tctx_node() locking.

Did you mean io_uring_del_task_file()? There is no
io_uring_del_tctx_node().

> > So if I understand right, we do in fact have 2 problems:
> > 1. the data race as I noted in my patch, and
> 
> Yes, and it deals with it
> 
> > 2. the fact that io_wq does not live long enough.
> 
> Nope, io_wq outlives them fine. 

I've sent:
https://lkml.kernel.org/r/20210527092547.2656514-1-elver@google.com

Thanks,
-- Marco
