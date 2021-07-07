Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7681B3BF023
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 21:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhGGTV1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 15:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbhGGTV0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 15:21:26 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10978C06175F
        for <io-uring@vger.kernel.org>; Wed,  7 Jul 2021 12:18:45 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id v14so6909584lfb.4
        for <io-uring@vger.kernel.org>; Wed, 07 Jul 2021 12:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R9wzw9s9pccPViWEsY8sbnSaeYn/7vUWP9xwygDqDs4=;
        b=NoQPLrxQZk8EoEOlUUZVRXosJonGrxSLGFu6xFMxPMvCMMHac26nrUcjXYBrBwBeDl
         RJ8UMhLlU8cSMxee2WzlEXd823HKA65OloAIEzwETJYP70FbfPa7c5mL6sCfFzu26LXc
         7nF+arBFr7IB5+xtcwxmfpfZMr85NGyBjfFWs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R9wzw9s9pccPViWEsY8sbnSaeYn/7vUWP9xwygDqDs4=;
        b=n6UZeBFD4ctbCQgTl7ddBzIQepcLLY0Y2HrnH+NmO5XeEsD9MUzpnpg8gTz4aSjoRO
         q2qnTcIK6CwIHi3ZEY+YLNeWaev6fC1r4GbRlAwW9rma7LLWvc3A/UKljz0gLKEvSUHZ
         zwietX6Zi3HkYaKBhKCpZCqv2gsTCK43aANStI39aLmRoBNb3Ql9US0ZYWejVUaEagWS
         GqGajF+1msZVZtgqaoF4JJCzr9SfaygyRQCOHcTCV97ikUgZ24FsSmWnLAG3DbFphUNH
         /ydWKQE9AD4PeLmmbN9t/IQoEW2NLQV3B/xlMCHeCHvP752iha6GC1mNaGr2v2OhtD4S
         u9Yw==
X-Gm-Message-State: AOAM531XGh2Hkjk6S8L6Xuh7osyv2XFuwubj/6PXdE0WjBObpgsKq/4w
        U1AnxmNVv5iaL5LGMCRDkW1RwXC2PrDsUBTtI/I=
X-Google-Smtp-Source: ABdhPJwXvbXKKd23nocPc0+W169GlgAoXGmszEgOjJEk5q3/YWenp1hTGTpRCRoa1zdOrKPZEbxmew==
X-Received: by 2002:a05:6512:3fc:: with SMTP id n28mr1170423lfq.573.1625685523104;
        Wed, 07 Jul 2021 12:18:43 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id z9sm1678393lfu.120.2021.07.07.12.18.42
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 12:18:42 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id v14so6909390lfb.4
        for <io-uring@vger.kernel.org>; Wed, 07 Jul 2021 12:18:42 -0700 (PDT)
X-Received: by 2002:a05:6512:374b:: with SMTP id a11mr19869786lfs.377.1625685522128;
 Wed, 07 Jul 2021 12:18:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210707122747.3292388-1-dkadashev@gmail.com> <20210707122747.3292388-3-dkadashev@gmail.com>
In-Reply-To: <20210707122747.3292388-3-dkadashev@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 7 Jul 2021 12:18:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh=cpt_tQCirzFZRPawRpbuFTZ2MxNpXiyUF+eBXF=+sw@mail.gmail.com>
Message-ID: <CAHk-=wh=cpt_tQCirzFZRPawRpbuFTZ2MxNpXiyUF+eBXF=+sw@mail.gmail.com>
Subject: Re: [PATCH v8 02/11] namei: change filename_parentat() calling conventions
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 7, 2021 at 5:28 AM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> Hence this preparation change splits filename_parentat() into two: one
> that always consumes the name and another that never consumes the name.
> This will allow to implement two filename_create() variants in the same
> way, and is a consistent and hopefully easier to reason about approach.

I like it.

The patch itself is a bit hard to read, but the end result seems to make sense.

My main reaction is that this could have probably done a bit more
cleanup by avoiding some of the "goto exit1" kind of things.

Just as an example, now the rule is that "do_rmdir()" always does that

>         putname(name);
>         return error;

at the end, and I think this means that this whole function could be
split into a few trivial helper functions instead, and we'd have

   long do_rmdir(int dfd, struct filename *name)
  {
        int error;

        error = rmdir_helper(...)
        if (!retry_estale(error, lookup_flags)) {
                lookup_flags |= LOOKUP_REVAL;
                error = rmdir_helper(...);
        }
        putname(name);
        return error;
  }

which gets rid of both the "goto retry" and the "goto exit1".

With the meat of "do_rmdir()" done in that "rmdir_helper()" function.

I think the same is basically true of "do_unlinkat()" too.

But I wouldn't mind that cleanup as a separate patch. My point is that
I think this new rule for when the name is consumed is better and can
result in further cleanups.

(NOTE! This is from just reading the patch, I might have missed some case).

            Linus
