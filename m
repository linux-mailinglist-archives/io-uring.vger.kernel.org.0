Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F60A3ED1E9
	for <lists+io-uring@lfdr.de>; Mon, 16 Aug 2021 12:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235747AbhHPKZc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Aug 2021 06:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235738AbhHPKZb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Aug 2021 06:25:31 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34292C061764;
        Mon, 16 Aug 2021 03:25:00 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id z5so31825205ybj.2;
        Mon, 16 Aug 2021 03:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z1ab7tyHPXHTeSGbIK5vAxswtCPScHuYYm9zAByhg3o=;
        b=f6PdIPZTzkzRz8qrh3emqJEM08E7Gprmj+cfRIsknZuFdb1yM7rqrSNjpMAp8Njscu
         QS0Dm7ZYCGXU67v09SO043Gdzi2a3WY9VzS412r+rii8M00SNXz/DF+IC3Uc9PjqZGXa
         yxcmNR01syOLzwwWHR2UjGkYVG8Y8zry47QaA/zH4vXstT7oUQMk634+vfLZA8yodcO+
         CJCvFkwRSHKnD8ct6pfwRErwGd09GwG6lE8y/5Fznuw2kw9pvJOYGRpjNiYlNwDFMzYR
         EHnxt5sK3IviB+OmhYQtx53HnIJ7SzMtalSamSBQIZhU0Bhiy7ozGrGZLVfn8sbZK0AY
         21rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z1ab7tyHPXHTeSGbIK5vAxswtCPScHuYYm9zAByhg3o=;
        b=p/aafuyYB4W3KZ0ZxjDtIOA9fjWQZSMJobrd8s09FRdcMMMkpaOgVz4ELS8fOhub8e
         8J6rScynQX7Jij7fOjXM1CpwicTuOAtXGJgAAs78bXKmgfDYqB5Ck8qte607+MOrh2KT
         4x7bbErz/xUejkNzIoTfz0FGVM0rE2D/4DMa55pEZ9t5w8OMDFMWLOcTOAPMaMZJXhgz
         6s5vlEhzBVjDJZKpcRnha+eVKSBZ4+4wacYEoipYmE9eieFdveR9xSaTylbDBJuEi5Qu
         3x2bQO6RgX3XhSm7ruip9+AYGw7jSg3hZ3yTkwBDkyP6MJIPZboGGgqPLd9ZPTg8iXTo
         NEog==
X-Gm-Message-State: AOAM531PYFAQeJqP67E+ppVve5NoD4WIQOIILsQbsTKYu3owIhNj3DtY
        scOKSZOct3rUaKm4O2HQ3ddCDJrsEgrgN+wTIDg=
X-Google-Smtp-Source: ABdhPJzF9ef9OrdyRxdi5s3ofIedsrHL9x2RyMAnB5rk/ipNKd2tcMG+2+8S9v9ZiXyhR85l4hbkv3ZEmX2MvuSXbqA=
X-Received: by 2002:a25:aa45:: with SMTP id s63mr1607329ybi.289.1629109499554;
 Mon, 16 Aug 2021 03:24:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210708063447.3556403-1-dkadashev@gmail.com> <CAHk-=wjMFZ98ERV7V5u6R4FbYi3vRRf8_Uev493qeYCa1vqV3Q@mail.gmail.com>
 <cbddca99-d9b1-d545-e2eb-a243ce38270b@kernel.dk> <CAOKbgA5jHtR=tLAYS_rs77QppRm37HV1bqSLQEMv8GusQNDrAg@mail.gmail.com>
 <506f544a-cb0b-68a2-f107-c77d9f7f34ed@kernel.dk>
In-Reply-To: <506f544a-cb0b-68a2-f107-c77d9f7f34ed@kernel.dk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Mon, 16 Aug 2021 17:24:48 +0700
Message-ID: <CAOKbgA4nYoaM84Gx+bxN3C_ewMa_V6QHbsX0dnmcVZap8GxMVw@mail.gmail.com>
Subject: Re: [PATCH v9 00/11] io_uring: add mkdir and [sym]linkat support
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 13, 2021 at 9:12 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/13/21 3:32 AM, Dmitry Kadashev wrote:
> > On Fri, Jul 9, 2021 at 2:25 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 7/8/21 12:34 PM, Linus Torvalds wrote:
> >>> On Wed, Jul 7, 2021 at 11:35 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
> >>>>
> >>>> v9:
> >>>> - reorder commits to keep io_uring ones nicely grouped at the end
> >>>> - change 'fs:' to 'namei:' in related commit subjects, since this is
> >>>>   what seems to be usually used in such cases
> >>>
> >>> Ok, ack from me on this series, and as far as I'm concerned it can go
> >>> through the io_uring branch.
> >>
> >> I'll queue it up in a separate branch. I'm assuming we're talking 5.15
> >> at this point.
> >
> > Is this going to be merged into 5.15? I'm still working on the follow-up
> > patch (well, right at this moment I'm actually on vacation, but will be
> > working on it when I'm back), but hopefully it does not have to be
> > merged in the same merge window / version? Especially given the fact
> > that Al prefers it to be a bigger refactoring of the ESTALE retries
> > rather than just moving bits and pieces to helper functions to simplify
> > the flow, see here:
> >
> > https://lore.kernel.org/io-uring/20210715103600.3570667-1-dkadashev@gmail.com/
>
> I added this to the for-5.15/io_uring-vfs branch:
>
> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.15/io_uring-vfs
>
> had one namei.c conflict, set_nameidata() taking one more parameter, and
> just a trivial conflict in each io_uring patch at the end. Can you double
> check them?

Looks good to me, thanks!

-- 
Dmitry Kadashev
