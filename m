Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE3330305D
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 00:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732720AbhAYXmo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jan 2021 18:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732689AbhAYXkk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 18:40:40 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA03AC061573
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 15:39:59 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id b26so20286212lff.9
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 15:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PiYaXaNdLHDYRJIbb9dUizilUpJDQTQluxxh3E1CnUc=;
        b=I+ueePi/OTkpWkk3KvHO4ZUfd6VE8k+je/vIAF65q7O3aMJcrFow5YJqnHJBaBSla2
         /YqaTgrY5SoI4BHMFfm1roUMjae9/AzbH7iC2wuoP59BeVDx+fpq6rWrz+k72DnJZYev
         RMcAs8hXJNDPHbhiLGY2VDo2p1YXfL/n1he3s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PiYaXaNdLHDYRJIbb9dUizilUpJDQTQluxxh3E1CnUc=;
        b=N+L7Kir3D8DLp/4yqwqtdGJpQjseBwGFwtZWky+pLEnVh0zpxrx4vHmaHjvZcDqbFI
         MIBaYBNsQXEByq5PjOQdLKTnz8Yz4V8tMV86VjIIbMyifAuQXhREkW+hvuSYGHrevz+y
         17tJpoMR3dMm+GVOykCQ4Un77vAOTQRd7tSHVZXMZUAI4RNg8yLJ78lbILArxo25OhRl
         9LWFWQF5sER04gMHmr2m2LjMzqXSFX0qPd2A8lHzFOv8Ofqhvl1fCWsvXKmFyg4n6a3I
         ZZBdRmYavkU7yCZsbNzqrXpJRgHcg0gCxdu3McGvRT7/tGP+tJIDiW7Ig7ep2MOgDaRr
         qGCA==
X-Gm-Message-State: AOAM530xuGGaUBc9KX54emLOm4CZIdGXlgtrjmZJqdZ7/ZUWgFWTCaD7
        MNr21vDbCUucWnghG08fxsNdZmNgs8WGtg==
X-Google-Smtp-Source: ABdhPJyTMN7qDf8e5sH0rYyX9VBEH4+Ll2RmMj7e8gW1YWAwA7FYJPGt6qAPHA8DR5uriwbFCX8Kmg==
X-Received: by 2002:ac2:598c:: with SMTP id w12mr1213391lfn.526.1611617997955;
        Mon, 25 Jan 2021 15:39:57 -0800 (PST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id d24sm2185619lfc.225.2021.01.25.15.39.56
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 15:39:57 -0800 (PST)
Received: by mail-lf1-f48.google.com with SMTP id q12so20293513lfo.12
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 15:39:56 -0800 (PST)
X-Received: by 2002:ac2:4436:: with SMTP id w22mr1249767lfl.41.1611617996447;
 Mon, 25 Jan 2021 15:39:56 -0800 (PST)
MIME-Version: 1.0
References: <20210125213614.24001-1-axboe@kernel.dk>
In-Reply-To: <20210125213614.24001-1-axboe@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 25 Jan 2021 15:39:40 -0800
X-Gmail-Original-Message-ID: <CAHk-=whh=+nkoZFqb1zztY9kUo-Ua75+zY16HeU_3j1RV4JR0Q@mail.gmail.com>
Message-ID: <CAHk-=whh=+nkoZFqb1zztY9kUo-Ua75+zY16HeU_3j1RV4JR0Q@mail.gmail.com>
Subject: Re: [PATCHSET RFC] support RESOLVE_CACHED for statx
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 25, 2021 at 1:36 PM Jens Axboe <axboe@kernel.dk> wrote:
>
>     Patch 2 is the
> mostly ugly part, but not sure how we can do this any better - we need
> to ensure that any sort of revalidation or sync in ->getattr() honors
> it too.

Yeah, that's not pretty, but I agree - it looks like this just
requires the filesystem to check whether it needs to revalidate or
not.

But I think that patch could do better than what your patch does. Some
of them are "filesystems could decide to be more finegrained") -  your
cifs patch comes to mind - but some of your "return -EAGAIN if cached"
seem to be just plain pointless.

In afs, for example, you return -EAGAIN instead of just doing the
read-seqlock thing. That's a really cheap CPU-only operation. We're
talking "cheaper than a spinlock" sequence.

           Linus
