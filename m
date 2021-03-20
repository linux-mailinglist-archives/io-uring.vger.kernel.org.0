Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1F9342EB3
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 18:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhCTR5X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Mar 2021 13:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhCTR44 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Mar 2021 13:56:56 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AADFC061762
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 10:56:55 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id r20so15957465ljk.4
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 10:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qr5T61t0/jc8E3lWW0Exv0s6IfP06gKKY0jxUzzXYFU=;
        b=B1YmUmWwUaXDPggGJ6vO+ghH6m2Ri+VzWlR67wsIyPChLMY3pfeYm6CmkhLzQCmBVH
         wbn4OjdhGJAhSvzsDb7a6/uL53bKrmKp0tk1wGio11cxJb/4Sh1R2K8npAqo9Jz1+jk2
         ridKCeAwmBRlqMigRH0RRKhcA0SWdEl78eQBM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qr5T61t0/jc8E3lWW0Exv0s6IfP06gKKY0jxUzzXYFU=;
        b=NdocqAT0NFD0qYQNiGHgSHLmxaY9Esv9fet5PEB75mblEAgQPyuGQwYZZ/zzGnnP/Z
         S2X7UgOvrjqmPs248QRD/1As+y3z/6xrcP//ADYniGB4W7OjJYB3GC0Fp7TWlLfpGVj2
         UACFEzfno/xbAo7oAz9ZO4q5A1jq3R0AuZHgRJ0ULmjNWzntUYc6e0iFDh5Q71YVIEW0
         eLsQBkMZOyf9eqV6FL73b+QXpEuoqkxAbreQUe9Ux+fyVzAZ1+C8SUrmo+pCPpGEZtzy
         pYWWI4Fh7ODhBv85qESwycq9PwPiQZwl7Z9xQhTdaFG65kVYtGWuOgWfG9rjZJ3bYPsz
         OUmg==
X-Gm-Message-State: AOAM530JIksO0Ltax6WV36VtBAeIRB35hqD4e7ZFP/Ju3ZGM9VA0E7y4
        AqdPqcPRzVfKJuJcYXtGVTOafgIi/a31Zw==
X-Google-Smtp-Source: ABdhPJwQ5FRfqXNCqNtL39kc8DBqxUUK92Xevtg6dHOEIWpNx6ydLnFYqhtxWf0kFvd5fYL9lPkZWQ==
X-Received: by 2002:a2e:b524:: with SMTP id z4mr4473567ljm.410.1616263013918;
        Sat, 20 Mar 2021 10:56:53 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id j8sm1214284lji.8.2021.03.20.10.56.52
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Mar 2021 10:56:53 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id 75so14918321lfa.2
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 10:56:52 -0700 (PDT)
X-Received: by 2002:a05:6512:3d1c:: with SMTP id d28mr3960217lfv.41.1616263012501;
 Sat, 20 Mar 2021 10:56:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210320153832.1033687-1-axboe@kernel.dk> <20210320153832.1033687-2-axboe@kernel.dk>
 <m1eeg9bxyi.fsf@fess.ebiederm.org>
In-Reply-To: <m1eeg9bxyi.fsf@fess.ebiederm.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 20 Mar 2021 10:56:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjLMy+J20ZSBec4iarw2NeSu5sWXm6wdMH59n-e0Qe06g@mail.gmail.com>
Message-ID: <CAHk-=wjLMy+J20ZSBec4iarw2NeSu5sWXm6wdMH59n-e0Qe06g@mail.gmail.com>
Subject: Re: [PATCH 1/2] signal: don't allow sending any signals to
 PF_IO_WORKER threads
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Stefan Metzmacher <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Mar 20, 2021 at 9:19 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> The creds should be reasonably in-sync with the rest of the threads.

It's not about credentials (despite the -EPERM).

It's about the fact that kernel threads cannot handle signals, and
then get caught in endless loops of "if (sigpending()) return
-EAGAIN".

For a normal user thread, that "return -EAGAIN" (or whatever) will end
up returning an error to user space - and before it does that, it will
go through the "oh, returning to user space, so handle signal" path.
Which will clear sigpending etc.

A thread that never returns to user space fundamentally cannot handle
this. The sigpending() stays on forever, the signal never gets
handled, the thread can't do anything.

So delivering a signal to a kernel thread fundamentally cannot work
(although we do have some threads that explicitly see "oh, if I was
killed, I will exit" - think things like in-kernel nfsd etc).

          Linus
