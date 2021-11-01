Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818E9441ECE
	for <lists+io-uring@lfdr.de>; Mon,  1 Nov 2021 17:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhKAQwU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Nov 2021 12:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbhKAQwS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Nov 2021 12:52:18 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BD4C061767
        for <io-uring@vger.kernel.org>; Mon,  1 Nov 2021 09:49:44 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id u5so30389081ljo.8
        for <io-uring@vger.kernel.org>; Mon, 01 Nov 2021 09:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5ivmZdCt/Df94zdkY7tgyWmt1jKeZKNsvpiH34F87cY=;
        b=hWTLlkEnP7XZSFBKNNO0A48UouP6SiUd+D5QtpcUGPG2a2/P4B2X7y+sogc63Ot+r9
         kgodm+V1Vc1YDqk+GP7aP3EKiSYHfj4+lgsOoRoi27POAvM3r9uhondQ+vRlWqthsjyv
         9cAQUQdfWxiV85iAUu0ygPu+AqVki1dUNwT4Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5ivmZdCt/Df94zdkY7tgyWmt1jKeZKNsvpiH34F87cY=;
        b=WkuoK5DiII3uwcjFGJ6OS1WSaqhuFMthEm7MyJBL2IAUkoe7Cpb6ma2BP7jLHpq2mj
         WLbFjE0O1J9MWf7u5MJuLL0axZoIKk2HV47T9QR8tgkdpjReDgfHilAF3Jczr3Z933Gv
         6dQHoQEYWl8B2pY4pEY8zA8cIqUBYGqNxHRBmn3dmJM9GHpRU+BsTGGSG09agLuFL0RF
         IM1luPxHdBJO37mJmm+j2bGeyTFroxPkimOhDOVHRDQd2QcQkM164ylFs7xzepp4eEZh
         tSOgZfj7Cb/Lj78UVYIpDBs4ML6GQM5MMD/ec0/dwXvNrRRnnPdUnK9PBDDtX0XYYu7L
         gdXA==
X-Gm-Message-State: AOAM533fpRIKf6bQgDdOpabZ0f3XbNEv62HwsGsDZYmMhE0gXhDNkevF
        h4WdwxwUR8zDRAHjqDMCC6v8tlqLXGNWS4aF
X-Google-Smtp-Source: ABdhPJxyF42WtNKflkY8+lpB6cfAhU85RP4tXwj3YZ1Y9RMRvkwcifJBHnu9PWebNsvnLEarS6zvMg==
X-Received: by 2002:a2e:90c7:: with SMTP id o7mr30776491ljg.115.1635785382448;
        Mon, 01 Nov 2021 09:49:42 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id s5sm221121lfr.9.2021.11.01.09.49.41
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 09:49:42 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id c28so37425830lfv.13
        for <io-uring@vger.kernel.org>; Mon, 01 Nov 2021 09:49:41 -0700 (PDT)
X-Received: by 2002:a05:6512:13a5:: with SMTP id p37mr27518202lfa.474.1635785381640;
 Mon, 01 Nov 2021 09:49:41 -0700 (PDT)
MIME-Version: 1.0
References: <c5054513-d496-e15e-91ef-dcdbf9dda2c4@kernel.dk>
In-Reply-To: <c5054513-d496-e15e-91ef-dcdbf9dda2c4@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 1 Nov 2021 09:49:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=whuMiJ3LdGZGPsKR+FuM4v4Qz6Xp-dnr7G3QN3Nr24NdA@mail.gmail.com>
Message-ID: <CAHk-=whuMiJ3LdGZGPsKR+FuM4v4Qz6Xp-dnr7G3QN3Nr24NdA@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring updates for 5.16-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Oct 31, 2021 at 12:41 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> This will throw two merge conflicts, see below for how I resolved it.
> There are two spots, one is trivial, and the other needs
> io_queue_linked_timeout() moved into io_queue_sqe_arm_apoll().

So I ended up resolving it the same way you did, because that was the
mindless direct thing.

But I don't much like it.

Basically, io_queue_sqe_arm_apoll() now ends up doing

        case IO_APOLL_READY:
                if (linked_timeout) {
                        io_queue_linked_timeout(linked_timeout);
                        linked_timeout = NULL;
                }
                io_req_task_queue(req);
                break;
    ...
        if (linked_timeout)
                io_queue_linked_timeout(linked_timeout);

and that really seems *completely* pointless. Notice how it does that

        if (linked_timeout)
                io_queue_linked_timeout()

basically twice, and sets linked_timeout to NULL just to avoid the second one...

Why isn't it just

        case IO_APOLL_READY:
                io_req_task_queue(req);
                break;
  ...
        if (linked_timeout)
                io_queue_linked_timeout(linked_timeout);

where the only difference would seem to be the order of operations
between io_req_task_queue() and io_queue_linked_timeout()?

Does the order of operations really matter here? As far as I can tell,
io_req_task_queue() really just queues up work for later, so it's not
really very ordered wrt that io_queue_linked_timeout(), and in the
_other_ case statement it's apparently fine to do that
io_queue_async_work() before the io_queue_linked_timeout()..

Again - I ended up resolving this the same way you had done, because I
don't know the exact rules here well enough to do anything else. But
it _looks_ a bit messy.

Hmm?

                 Linus
