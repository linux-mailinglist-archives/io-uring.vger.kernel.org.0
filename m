Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5151AE007
	for <lists+io-uring@lfdr.de>; Fri, 17 Apr 2020 16:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgDQOh6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Apr 2020 10:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgDQOh5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Apr 2020 10:37:57 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A867C061A0C
        for <io-uring@vger.kernel.org>; Fri, 17 Apr 2020 07:37:57 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id t4so2352670ilp.1
        for <io-uring@vger.kernel.org>; Fri, 17 Apr 2020 07:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YNZGUuynba7bR8KGNPHc+YpXNMphMyuNtBAp/y2Pmhs=;
        b=u5Kd5xB9GxSnYsj4hM4QHI7oiWeIt3XtZdjrXMDlntiH17+wV1L/uh92JHFgjN8liN
         sjMRGttYx/2li51l+RlF4y/UAE8Nw9HPT+9t23DM3x6DUSt4YQs6lJZJV2Q6OvLvRP6H
         RYKReqrUH9jsGWW+hGGkyCJow7WyK1vd40CNWMKe/3qmr0QvHIkW5/LtrL1Ny7+7JHso
         Jmm5BjJ8mv8zK3LtgQiJ4XpbMvpi/zrJ80a7l0V9hHONFjFp8uug/SRvYQp3aW6wOzxB
         HDLCGFB381016Upn6yQBE6fBQCezBEPG2ehKwXrxJ4r8RIQLby7mcQq+lvHTUXZfb9rg
         DSbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YNZGUuynba7bR8KGNPHc+YpXNMphMyuNtBAp/y2Pmhs=;
        b=cEpLU0DAgLlMZ1bSs8pNu5L8A5+mqdU07iy8eXMzIH7a9iZa3E19HjW8j4Ky6pcnGR
         pp1ZFmJEQhU9owmFMBn/8zpM1KJwG3+G0oiGsTYOLpSfZRFtOdI3mKCE7KG5eF6tiO9x
         Vg+OGqEt5nVq0Ed5zF0JPTDgrk92xZWTZPNl1yapM4sQoFSUuZwILvhOmBNRe289GfOX
         WRzDqooEC6tEQHs9sC6StFXt+Z1YVuhB232DiADqBGBQ3nMhPP11MfdznVjoOcbc9aGA
         /qHoF3Nx+sCbtdzJGvAgjRBmBmBPuL+EBULp3sftcqkp5syS62k/VIQt800vGHqVTArd
         i8YQ==
X-Gm-Message-State: AGi0PubegupZCyC8NxydwAhzJTxq4V/mKGJjw8+MJWqxqWsa/suRaTnm
        3DgF2pMdehDaOxo3osOyZ40GbmbL1LCbJDzm5UI=
X-Google-Smtp-Source: APiQypLK5pIpE7wXU/QH5NRmc9WCIMK5AVBq4Iu1hnlRCPZ4E7leEKXDTngcpwDxurbIaQ5XOVU1FHiy0iEvWcisjW4=
X-Received: by 2002:a92:c649:: with SMTP id 9mr3318693ill.265.1587134276786;
 Fri, 17 Apr 2020 07:37:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAEsUgYgTSVydbQdjVn1QuqFSHZp_JfDZxRk7KwWVSZikxY+hYg@mail.gmail.com>
 <e146dd8a-f6b6-a101-a40e-ece22b7fe320@kernel.dk> <fe383a44-bcfb-d6fa-2afe-983b456e7112@gmail.com>
 <969e4361-aae9-f713-c3b6-c79107352871@kernel.dk> <22e7a41d-389d-a4a9-14ae-c443668232a6@gmail.com>
In-Reply-To: <22e7a41d-389d-a4a9-14ae-c443668232a6@gmail.com>
From:   Hrvoje Zeba <zeba.hrvoje@gmail.com>
Date:   Fri, 17 Apr 2020 10:37:45 -0400
Message-ID: <CAEsUgYiVhHo7W3abX6xgPBcja8qS5inCBwGUtjRtqDozUbu7Pg@mail.gmail.com>
Subject: Re: Odd timeout behavior
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        "zhangyi (F)" <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 17, 2020 at 4:40 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 12/04/2020 17:40, Jens Axboe wrote:
> >> On 4/12/2020 5:07 AM, Jens Axboe wrote:
> >>> Thinking about this, I think the mistake here is using the SQ side for
> >>> the timeouts. Let's say you queue up N requests that are waiting, like
> >>> the poll. Then you arm a timeout, it'll now be at N + count before it
> >>> fires. We really should be using the CQ side for the timeouts.
> ...
> > Reason I bring up the other part is that Hrvoje's test case had other
> > cases as well, and the SQ vs CQ trigger is worth looking into. For
> > example, if we do:
> >
> > enqueue N polls
> > enqueue timeout, count == 2, t = 10s
> > enqueue 2 nops
> >
> > I'd logically expect the timeout to trigger when nop #2 is completed.
> > But it won't be, because we still have N polls waiting. What the count
> > == 2 is really saying (right now) is "trigger timeout when CQ passes SQ
> > by 2", which seems a bit odd.
> >
>
> time for this:
>
> 1. do we really want to change current behaviour? As you said, there may be users.
>

I still see io_uring as early development. I've had several breakages
when I upgraded the kernel so far. I'm fine with it.

> 2. why a timeout can't be triggered by another timeout completion? There are
> bits adjusting req->sequence for enqueued timeouts up and down. I understand,
> that liburing hides timeouts from users, but handling them inconsistently in
> that sense from any other request is IMHO a bad idea. Can we kill it?
>
> 3. For your case, should it to fire exactly after those 2 nops? Or it can be
> triggered by previously completed requests (e.g. polls)?
>
> e.g. timeline as follows
> - enqueue polls
> - enqueue timeout
> - 2 polls completed
> - the timeout triggered by completion of polls
> - do nops
>

Timeout fires on any cqes is the behavior I expected. I can see the
reasoning behind only triggering for sqes that come after the timeout
(io_uring_submit_and_wait() being the use-case) tho.

-- 
I doubt, therefore I might be.
