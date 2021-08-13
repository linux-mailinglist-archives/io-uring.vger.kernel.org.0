Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4776E3EB359
	for <lists+io-uring@lfdr.de>; Fri, 13 Aug 2021 11:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238980AbhHMJcv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Aug 2021 05:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238954AbhHMJcv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Aug 2021 05:32:51 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E97EC061756;
        Fri, 13 Aug 2021 02:32:24 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id w17so17599923ybl.11;
        Fri, 13 Aug 2021 02:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JpXtCZVKe4NN46MML6gjrpGLey5QNDfpVKJlaCdGXJw=;
        b=lkKIIH57IpdePfP89WdB5vQLc3fbc2axDpXXA5sLH45KfF9LYzB9fIFPbDu/LJ9W8M
         VPfP+niLiHw/PWsjBlXAaLHpK+6lGnyfU4FOg8C3kZU0+N4obSsinlJzH+vvA5ZQkbJV
         JOdyspvuP/YDnkYtvwbkUkVlAXzMsMhsiQPwU3DDoLod0QDYuwpBH+w4YoIN/aGR++Nj
         aJXrtEVsy8hIW7AbMSETdcNhCi9gwZ854rBMQBe9Z6E0XiZCHw50ABkgzaBnBMYpQnzt
         7NVOmDN5R223YR8gUOiHRRduJUicpe/r7paXjAQFyzuVCZMymKDwhttWh0xMiCM2hMi5
         0fMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JpXtCZVKe4NN46MML6gjrpGLey5QNDfpVKJlaCdGXJw=;
        b=JwQmu98WktUdsZJ0O7joj0/3kdXziJHteeFPvmxqNx68YJmYZ+pbrhUcJof8RqLosk
         HtwjEYUi0I1FRY8jMd1JKEavhWlkKrsjgswWrMMhl/5kqHErGDJoJffnsR5sQxORN33l
         BEbiEiNP+WIZszoaOrIBtyVFVAHsJ0DSrCEa/W6krA4ZmtV+IrVVdQRy3P6nduM93TgR
         u2i9K23MxbE9cN8RXKqRLBbb9Xtq60SVJWShnUWk0fvgUOLKJM1gCFmpkqT8r6F0DFEa
         85zn68eG/vKxUf9+Y+4emo9CPkL9FX1RnVOGrP0NYeIrctWMRY9Faa7YBQBq4iv+ltmX
         Pe/w==
X-Gm-Message-State: AOAM530jlCpeKNZ9xiifuh1Qoq+EuMTb5yFw1WlLR3wawU02QZVmxWKi
        MFPBlDVK536O4I1L430I6OOHm9d9IvamCus7vO4=
X-Google-Smtp-Source: ABdhPJwGPon6+zv48FPVKNyTaDfkGv5T3cSOEdkbqF5efnr5qE9DwxyOplhObQFgjipL1k4AehU/o1zqDJcsAFZj+EY=
X-Received: by 2002:a25:c6d6:: with SMTP id k205mr1700192ybf.168.1628847143896;
 Fri, 13 Aug 2021 02:32:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210708063447.3556403-1-dkadashev@gmail.com> <CAHk-=wjMFZ98ERV7V5u6R4FbYi3vRRf8_Uev493qeYCa1vqV3Q@mail.gmail.com>
 <cbddca99-d9b1-d545-e2eb-a243ce38270b@kernel.dk>
In-Reply-To: <cbddca99-d9b1-d545-e2eb-a243ce38270b@kernel.dk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Fri, 13 Aug 2021 16:32:12 +0700
Message-ID: <CAOKbgA5jHtR=tLAYS_rs77QppRm37HV1bqSLQEMv8GusQNDrAg@mail.gmail.com>
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

On Fri, Jul 9, 2021 at 2:25 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/8/21 12:34 PM, Linus Torvalds wrote:
> > On Wed, Jul 7, 2021 at 11:35 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
> >>
> >> v9:
> >> - reorder commits to keep io_uring ones nicely grouped at the end
> >> - change 'fs:' to 'namei:' in related commit subjects, since this is
> >>   what seems to be usually used in such cases
> >
> > Ok, ack from me on this series, and as far as I'm concerned it can go
> > through the io_uring branch.
>
> I'll queue it up in a separate branch. I'm assuming we're talking 5.15
> at this point.

Is this going to be merged into 5.15? I'm still working on the follow-up
patch (well, right at this moment I'm actually on vacation, but will be
working on it when I'm back), but hopefully it does not have to be
merged in the same merge window / version? Especially given the fact
that Al prefers it to be a bigger refactoring of the ESTALE retries
rather than just moving bits and pieces to helper functions to simplify
the flow, see here:

https://lore.kernel.org/io-uring/20210715103600.3570667-1-dkadashev@gmail.com/

-- 
Dmitry Kadashev
