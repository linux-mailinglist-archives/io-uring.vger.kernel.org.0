Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 949481567B9
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 21:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgBHUnw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 15:43:52 -0500
Received: from mail-lf1-f54.google.com ([209.85.167.54]:43563 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgBHUnw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 15:43:52 -0500
Received: by mail-lf1-f54.google.com with SMTP id 9so1554972lfq.10
        for <io-uring@vger.kernel.org>; Sat, 08 Feb 2020 12:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aPEhtSCbtY8BZtoIZW5xjEM12+SwZtmNjXeBcPgnX/0=;
        b=d2+WG0L3Ua+ZfkRRRmwWgYDO7uAAiTyxoz0a+ellD2qwRqLxPp66qLB2Zm3ROcA64F
         ESWa8GGxIEGcehCQfk5xW5Cd11fGq3vz2xho1Pn0na/HWq39G+zUPuzn+m/1E2fmMzL+
         fgi9hN1M0mEajFczagZWlLlhGLUwK7UbNH/6o1KXnGvuGoQ5vwaskRaPqP9ggSY2LZET
         l1XzJmH9SsJ2HYCCQ7hhfFVh+SBvNuQVSML3V48qEj8hxH/qlxCcunD/3bd6Sf0AAdKH
         weyOwSk7Khue+SEU5T/hwdhrvvZ73EFqb/dbe+z2UEdhnMowQHAOKYALkZQ036XMZXe3
         GH6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aPEhtSCbtY8BZtoIZW5xjEM12+SwZtmNjXeBcPgnX/0=;
        b=NteCTtDd60N9fH6ZLhaYemoCkzV5iH6xZ4R/U/JzPzfKPUanT4r4PqqE63fbsPqe/s
         UH9AEYd14h/PZkeahhVeeT9WgvoWvat48ENHk0F64rWD43X7J8YIUleVc7pg5+JskkXJ
         D4bkncGYh8ie5TBjkrP5wgUnfFCGlzvGwOoZr3ynVx6TCa92qbGAnKxby7l87U1iKXUQ
         DJRAx6UjMAJHgW1XA+B2nF8+04VJuLVG2Hi8ZbT14m1NcoBcaVkdg28cG6qQCjOqAzbl
         94fbq74xhv3YY49JnQ9xMyfTe96CF9O8KNXVtR7aDn98hRC6tw3kPuZhh9HANvcTd6/t
         Yqhg==
X-Gm-Message-State: APjAAAUQZdljpeHLw4DtCb2w45kdB4cIPq55pfTTUGY5A7kmsvWYHnZ1
        9vCCJA/0Fkb1KWkUXryCfJ2QTpWzLLQ2TLHA7LlsFg==
X-Google-Smtp-Source: APXvYqymJTXzHHgkiFj2Rob/16SUtbMNyhcxK9X5v8F+ZfDUII4odBxjObTLB0xO4vEyd8wcjALQL0gCDrAgrZEiziQ=
X-Received: by 2002:a19:9d5:: with SMTP id 204mr2594298lfj.120.1581194628336;
 Sat, 08 Feb 2020 12:43:48 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zaQ2hCBKYCgsK8ehhzF4WgB0=1uMgG=p1BQ1V1YsN37_A@mail.gmail.com>
 <cfc6191b-9db3-9ba7-9776-09b66fa56e76@gmail.com> <CAD-J=zbMcPx1Q5PTOK2VTBNVA+PQX1DrYhXvVRa2tPRXd_2RYQ@mail.gmail.com>
 <9ec6cbf7-0f0b-f777-8507-199e8837df94@scylladb.com> <CAD-J=zZm2B8-EXiX8j2AT5Q0zTCi5rB1gQzzOaYi3JoO1jcqOw@mail.gmail.com>
 <CAD-J=zZwH7ceTaAS=ck5_5thGN_ne1kVXOJzZfBK-gorzwNLxg@mail.gmail.com> <d651f706-68eb-0f15-6e5d-3919eb90f3da@scylladb.com>
In-Reply-To: <d651f706-68eb-0f15-6e5d-3919eb90f3da@scylladb.com>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Sat, 8 Feb 2020 15:43:37 -0500
Message-ID: <CAD-J=zbxqDD_=Q-Y6T5DPycdKY=aDmvrjP08QSiuWao851UGUA@mail.gmail.com>
Subject: Re: shutdown not affecting connection?
To:     Avi Kivity <avi@scylladb.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Feb 8, 2020 at 3:29 PM Avi Kivity <avi@scylladb.com> wrote:
>
> On 2/8/20 10:20 PM, Glauber Costa wrote:
> >>
> >>> Perhaps you can reduce the
> >>> problem to a small C reproducer?
> >>>
> >> That was my intended next step, yes
> > s***, I didn't resist and I had to explain to my wife that no, I don't
> > like io_uring more than I like her.
> >
> > But here it is.
> >
> > This is a modification of test/connect.c.
> > I added a pthread comparison example that should achieve the same
> > sequence of events:
> > - try to sync connect
> > - wait a bit
> > - shutdown
> >
> > I added a fixed wait for pthread to make sure that shutdown is not
> > called before connect.
> >
> > For io_uring, the shutdown is configurable with the program argument.
> > This works just fine if I sleep before shutdown (as I would expect from a race).
> > This hangs every time if I don't.
> >
> > Unless I am missing something I don't think this is the expected behavior
>
>
> I think it is understandable. Since the socket is blocking uring moves
> the work to a workqueue, and the shutdown() happens before the workqueue
> has had a chance to process the connection attempt. So we'll have to
> cancel the sqe.

It does seem to me that this implies that every shutdown must imply a cancel
to a connection.

From the user's perspective, this still feels like a bug to me:
the fact that we had to move this to a work queue is an implementation detail:
1) we asked the kernel to do something
2) the kernel returned
3) we called shutdown() to expecting that cancel to go away and never returned.

If cancel-after-connect to avoid these races is the intended behavior,
it would be nice to
get this documented somehow in the io_uring fantastic documentation.

In hindsight, cancel-on-shutdown is quite obvious and natural.
But I just spent two days to make this obvious and natural.

>
>
> Jens, does the blocking connect doesn't consume a kernel thread while
> it's waiting for a connection? Or does it just set things up and move on?
>
