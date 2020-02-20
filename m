Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 365B7166AD3
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 00:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgBTXMn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 18:12:43 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44354 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729027AbgBTXMm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 18:12:42 -0500
Received: by mail-ot1-f68.google.com with SMTP id h9so316637otj.11
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 15:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dp6EofqTBOS2L0ntvgbSbKGek0i+wp1TkBLQ7kObhrk=;
        b=b2adRCe3ssRc+efAoYDYBH5bQb2trdyFYdKiYUdXGkX2rQQCxqXf/+KZtzkQFqEWBU
         yqlpbzMjpKbdQlefP94guZMSelJ7TheuFZMvaINsrw4iGnwMJHmhPWJ588578sRArldY
         S6YyAbQdUVo0dpETLfW5MgWCF+FNa79XdC2Unmb23GlEs7QmwR/UZXa35oMwoRDFPHTW
         5EdW59MhTCheKi2NqhJjpqA1IxjCkBosLXh+hAjwU+lA5bAex0fpdRfxkskQFxVdctI5
         7/1eA0dN1mRKDdmENdDTVqU3qQ9t9bdIFbcfypve+kvm/y8gu/mB/v/fZ9IooQcxbDPS
         D0uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dp6EofqTBOS2L0ntvgbSbKGek0i+wp1TkBLQ7kObhrk=;
        b=Vgtg5u+oHUlQt0HJ0pXqOo6hyc9zJ3xT0W1tSMoxWgZU0i0O410g22o4PhC0M+VPxK
         X1cNTaTDjcky/xCm6On30TbjnAvDJqpMRai1fLGCYvuPux9Fgfo0glSz0VPuVA9Jtzs8
         pwgWXvRWHH5DSY3bY5DNMjws4hOSaX3I7InlCEzwCM87suwVVpzrdY9GwEeoqBBglBOc
         3PnwJVU+ioz8yoO6zb27Tz8oA6PY9erxsGXlXcZG75JhAtUUyN6MTss1Co+WFtfw2+Cr
         3cPsmhS/pZ8WA9knKZzggSe/fiY7wNSGi63DkQM4psBYlkYZUiay85BQ2AIHa0PVzKmb
         eOAQ==
X-Gm-Message-State: APjAAAVcymGYMbGZGPg40o1k9Y//g0GemazWBnIzykMNncng8FSCtrII
        OkKFnfeaDvFY1h/itCdBna+G+nW26p8CX1KTjOZIAQ==
X-Google-Smtp-Source: APXvYqzTbCBtncCgfBAq4dUSvjvpl0DQcXDjEUc9Z1H7jWRlbxc/8sn9JpOf9qZh3Oes1p712Tez3B8pCf6Gj1bBDx0=
X-Received: by 2002:a9d:5e8b:: with SMTP id f11mr12076111otl.110.1582240361907;
 Thu, 20 Feb 2020 15:12:41 -0800 (PST)
MIME-Version: 1.0
References: <20200220203151.18709-1-axboe@kernel.dk> <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
 <b78cd45a-9e6f-04ec-d096-d6e1f6cec8bd@kernel.dk> <CAG48ez37KerMukJ6zU=VQPtHsxo29S7TxqcqvU=Bs7Lfxtfdcg@mail.gmail.com>
 <4caec29c-469d-7448-f779-af3ba9c6c6a9@kernel.dk>
In-Reply-To: <4caec29c-469d-7448-f779-af3ba9c6c6a9@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 21 Feb 2020 00:12:15 +0100
Message-ID: <CAG48ez2vXYgW8WqBxeb=A=+_2WRL98b_Heoe8rPeXOMXuuf4oQ@mail.gmail.com>
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Glauber Costa <glauber@scylladb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 21, 2020 at 12:00 AM Jens Axboe <axboe@kernel.dk> wrote:
> On 2/20/20 3:23 PM, Jann Horn wrote:
> > On Thu, Feb 20, 2020 at 11:14 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 2/20/20 3:02 PM, Jann Horn wrote:
> >>> On Thu, Feb 20, 2020 at 9:32 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>> For poll requests, it's not uncommon to link a read (or write) after
> >>>> the poll to execute immediately after the file is marked as ready.
> >>>> Since the poll completion is called inside the waitqueue wake up handler,
> >>>> we have to punt that linked request to async context. This slows down
> >>>> the processing, and actually means it's faster to not use a link for this
> >>>> use case.
[...]
> >>>> -static void io_poll_trigger_evfd(struct io_wq_work **workptr)
> >>>> +static void io_poll_task_func(struct callback_head *cb)
> >>>>  {
> >>>> -       struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
> >>>> +       struct io_kiocb *req = container_of(cb, struct io_kiocb, sched_work);
> >>>> +       struct io_kiocb *nxt = NULL;
> >>>>
> >>> [...]
> >>>> +       io_poll_task_handler(req, &nxt);
> >>>> +       if (nxt)
> >>>> +               __io_queue_sqe(nxt, NULL);
> >>>
> >>> This can now get here from anywhere that calls schedule(), right?
> >>> Which means that this might almost double the required kernel stack
> >>> size, if one codepath exists that calls schedule() while near the
> >>> bottom of the stack and another codepath exists that goes from here
> >>> through the VFS and again uses a big amount of stack space? This is a
> >>> somewhat ugly suggestion, but I wonder whether it'd make sense to
> >>> check whether we've consumed over 25% of stack space, or something
> >>> like that, and if so, directly punt the request.
[...]
> >>> Also, can we recursively hit this point? Even if __io_queue_sqe()
> >>> doesn't *want* to block, the code it calls into might still block on a
> >>> mutex or something like that, at which point the mutex code would call
> >>> into schedule(), which would then again hit sched_out_update() and get
> >>> here, right? As far as I can tell, this could cause unbounded
> >>> recursion.
> >>
> >> The sched_work items are pruned before being run, so that can't happen.
> >
> > And is it impossible for new ones to be added in the meantime if a
> > second poll operation completes in the background just when we're
> > entering __io_queue_sqe()?
>
> True, that can happen.
>
> I wonder if we just prevent the recursion whether we can ignore most
> of it. Eg never process the sched_work list if we're not at the top
> level, so to speak.
>
> This should also prevent the deadlock that you mentioned with FUSE
> in the next email that just rolled in.

But there the first ->read_iter could be from outside io_uring. So you
don't just have to worry about nesting inside an already-running uring
work; you also have to worry about nesting inside more or less
anything else that might be holding mutexes. So I think you'd pretty
much have to whitelist known-safe schedule() callers, or something
like that.

Taking a step back: Do you know why this whole approach brings the
kind of performance benefit you mentioned in the cover letter? 4x is a
lot... Is it that expensive to take a trip through the scheduler?
I wonder whether the performance numbers for the echo test would
change if you commented out io_worker_spin_for_work()...
