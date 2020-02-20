Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98840166A6B
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 23:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbgBTWis (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 17:38:48 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35863 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729006AbgBTWir (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 17:38:47 -0500
Received: by mail-oi1-f194.google.com with SMTP id c16so75538oic.3
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 14:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K5efy4cTAe1W+0RHtVLFAXp5hLcQjz0drJQsLZA78Bc=;
        b=NCZWx6I/HkxTh/wDEgetZjGtsG2tlOTYTAOwHEW2Cq0zpEN15xZL9Bb0TRW4UXrAQG
         9vmtsW7y5u1gJ5gpBghY8rQTzizSzgej3ELvMJt02SRdcNA+ND6WJ3ATqv2ABabcPnEa
         MtSD0e0VIfAKOWBEWujFQf17WDQoLvxuNWshoSC3CmK1mlMxAFEYqhfCAmUTNEuLhN8s
         JHfVD7jSA92QsDeYP01DZ/WwqS8X+baWUXX/ekTXMu6ErJZBPokMo/prEqUBC0okZxhm
         /LZYLU3AVV5+uVf4ZNgfVN6g9SzK9MxpUSrYCaVCc2gcOOPupmzCYv9ILu4UcehwvQjo
         w0dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K5efy4cTAe1W+0RHtVLFAXp5hLcQjz0drJQsLZA78Bc=;
        b=hco6CtDZppY9RALNuLG4Fj6OysWVwt7Lb0Hl48F+vYGkYcaU0lvpy+u4Fd/maWMuk1
         jRLvMoxLyc2FMyZJG2mXocEJtkw+XMCrGdJCHEQ3gE19CUYw82QXIcO17RHKtwBFX77+
         JsiiESfc/niqYXxijxx2TTUoa9NOy5XtTwVjI1T1kPLp9ReLWgoENAPp5lH46orDDev+
         NZKFKM2B/49Q2XHTjHrBd0FvLqhZdXsD4OqYZ2M/DAmnU/EQls982Vqy1R2KDMIED1N5
         JutfXm9VjN2da+8Ypco5bnMBhiXsYsfmQ8IqecHyCSUiWvu+VDpdaEcTimpvv5Bh+6Pu
         AeOA==
X-Gm-Message-State: APjAAAUd/r4ftl55IGspRo8px7/ELjbeO3N+pzoXwzPh8FoacGu8NHkV
        LqW7OspASEDVlhGXFwp1Aeng9ZkFRqKuq1W9Fnp+8Q==
X-Google-Smtp-Source: APXvYqxOf8fcH1tqnwfHMNWAtfpowDla9UImsx/Tz4joQ2r6fff+97HNLBUbLhtqdmK6jedrRwvPLJEAepyY4y04cB0=
X-Received: by 2002:aca:484a:: with SMTP id v71mr3290070oia.39.1582238326991;
 Thu, 20 Feb 2020 14:38:46 -0800 (PST)
MIME-Version: 1.0
References: <20200220203151.18709-1-axboe@kernel.dk> <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
 <b78cd45a-9e6f-04ec-d096-d6e1f6cec8bd@kernel.dk> <67a62039-0cb0-b5b2-d7f8-fade901c59f4@kernel.dk>
In-Reply-To: <67a62039-0cb0-b5b2-d7f8-fade901c59f4@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 20 Feb 2020 23:38:20 +0100
Message-ID: <CAG48ez3R3DWLry_aRAt47BQ05Y4Mr9yVXq49yuiRGNoyRMr3Lg@mail.gmail.com>
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

On Thu, Feb 20, 2020 at 11:23 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 2/20/20 3:14 PM, Jens Axboe wrote:
> >>> @@ -3646,46 +3596,11 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
> >>>
> >>>         list_del_init(&poll->wait.entry);
> >>>
> >> [...]
> >>> +       tsk = req->task;
> >>> +       req->result = mask;
> >>> +       init_task_work(&req->sched_work, io_poll_task_func);
> >>> +       sched_work_add(tsk, &req->sched_work);
> >>
> >> Doesn't this have to check the return value?
> >
> > Trying to think if we can get here with TASK_EXITING, but probably safer
> > to just handle it in any case. I'll add that.
>
> Double checked this one, and I think it's good as-is, but needs a
> comment. If the sched_work_add() fails, then the work item is still in
> the poll hash on the ctx. That work is canceled on exit.

You mean via io_poll_remove_all()? That doesn't happen when a thread
dies, right?

As far as I can tell, the following might happen:

1. process with threads A and B set up uring
2. thread B submits chained requests poll->read
3. thread A waits for request completion
4. thread B dies
5. poll waitqueue is notified, data is ready

Even if there isn't a memory leak, you'd still want the read request
to execute at some point so that thread A can see the result, right?

And actually, in this scenario, wouldn't the req->task be a dangling
pointer, since you're not holding a reference? Or is there some magic
callback from do_exit() to io_uring that I missed? There is a comment
"/* task will wait for requests on exit, don't need a ref */", but I
don't see how that works...
