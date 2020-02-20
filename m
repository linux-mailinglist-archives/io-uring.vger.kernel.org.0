Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5BD3166A54
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 23:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbgBTW0G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 17:26:06 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:43594 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729150AbgBTW0F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 17:26:05 -0500
Received: by mail-oi1-f194.google.com with SMTP id p125so6775oif.10
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 14:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8mR86ena2GetBiKeGl88H98LmvsoZp1lBJfz1fc+9V0=;
        b=dMwJDPpifZADntvnfT09N3KMqYzat+O6iLdlwT8MJdJkJewQm52KG6NHxY49X+K00m
         qM6bLLxgrC0g9D3lDpRqGAM7Prh3+TZ0Yc706yrsqSjtojnBhYS+9eY60oC5AChycJt/
         ZnkDEvbsGF8wGWYPnzTh8gz/fV91/QYzSSo230r+1mvAUb/gWtla8HABE6KPStmgjcWF
         yacInU92NBA2AYrS9klLqxeTxXkVpH/CG/eX+1tJp24bK9WviscMzCV7zr6XcyyBunWL
         QwkTAhqIEcE4w7iGKNBhDa5VK7fie/EheOGcXYhKvF4Tj4UnurvPTn+OuW/jzUUdzaIm
         Z4nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8mR86ena2GetBiKeGl88H98LmvsoZp1lBJfz1fc+9V0=;
        b=neZBdiwYPdYPNAKMxzJ84LcQED3noc3+tvm1n+BQQo5FNcBOjHlkAH1cXpsEALdoZS
         /49rcX+irT6MMWv5+h5Hkptq06iR/AdOz1zJFS6DTaE/JYbxOJOtJG945Ro6KOhU152F
         kbDnxJX6M9e59nq5Z0CEDMOYYHW337/hWc2R6iOlCML7jz7ViK7dYKtk/P5uRj3dVuuN
         JFudg6Z2mbOSl0SRhPwfTgPkALFKHiCnIr38IovLJTxMsEAG85tPGWjLiYljWB2Gtb7a
         RmxXfYhFNMRCTJDmGQdZUe2VfxZCUOT3zti7zL9bMnZCHuTsAcViVbAFQScqEJsyNC+1
         2ZBA==
X-Gm-Message-State: APjAAAUfL/DogzA2/1t4jwdlQg7NJhSMFi/e/Wwjq6hYF1wvbBGN9F2C
        B6QXH8JYJ00wYvnyogHnR/wD6IO4z0/7xNw4ddkwrw==
X-Google-Smtp-Source: APXvYqyMm/a7gRWgOiNZ8kXDRdQ5UCnXzKXi138FvLqv6cP2XllLtHB6QKlB8a2WYpXLHR/9JOTYD5/rQDlLuBsfJGU=
X-Received: by 2002:aca:484a:: with SMTP id v71mr3256092oia.39.1582237563522;
 Thu, 20 Feb 2020 14:26:03 -0800 (PST)
MIME-Version: 1.0
References: <20200220203151.18709-1-axboe@kernel.dk> <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
 <b78cd45a-9e6f-04ec-d096-d6e1f6cec8bd@kernel.dk> <bb062108-4065-bd7c-f9bf-dfc433a6bd5d@kernel.dk>
In-Reply-To: <bb062108-4065-bd7c-f9bf-dfc433a6bd5d@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 20 Feb 2020 23:25:37 +0100
Message-ID: <CAG48ez0QjgyGamHeZEzr=DHZiPSd3o2qnk7ebK_080RoQPOcQQ@mail.gmail.com>
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

On Thu, Feb 20, 2020 at 11:18 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 2/20/20 3:14 PM, Jens Axboe wrote:
> >>> @@ -3733,6 +3648,9 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
> >>>
> >>>         events = READ_ONCE(sqe->poll_events);
> >>>         poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
> >>> +
> >>> +       /* task will wait for requests on exit, don't need a ref */
> >>> +       req->task = current;
> >>
> >> Can we get here in SQPOLL mode?
> >
> > We can, this and the async poll arm should just revert to the old
> > behavior for SQPOLL. I'll make that change.
>
> Actually, I think that should work fine, are you seeing a reason it
> should not?

Hm, no, I guess that might work.
