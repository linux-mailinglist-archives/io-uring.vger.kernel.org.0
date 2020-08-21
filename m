Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2627524CABB
	for <lists+io-uring@lfdr.de>; Fri, 21 Aug 2020 04:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgHUCYV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Aug 2020 22:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbgHUCYR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Aug 2020 22:24:17 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08029C061385
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 19:24:16 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id s195so246728ybc.8
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 19:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=datadoghq.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tZJPEE9z5ewrpM3v0GhIZxOOg01HQenUYONmoY4EPv4=;
        b=dHE4DTrizQ+Dt1y7Ta6n0HepkLWLrc1eDeePZRsWv+EOO5zkZow3eR9/YKCj8lSbgq
         hC8cbMLdq+M0ARCNr+oIHG0qjaXASfbbT1tBuMI/+UxVggpl4Fnz9bMUfDZzuPM9K8Gf
         GhcLbVK5K3G0ww+KxQc4+r7/3m0kRvWa0bH/0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tZJPEE9z5ewrpM3v0GhIZxOOg01HQenUYONmoY4EPv4=;
        b=NcYn3ERv9GlbgvpRNw8Dtb6uP7JAdUSC7iYuVdcKmf+4VTxjImCrscrWf48pGE6hi0
         MQMgQ/YqC2LrlVJ0CTs4R/B6ZjHUD4iKxbAciVIHWWQi8SwjDycixR6KhGESfpM7aXKy
         AQ8Bv5HfUWMq+4NIjvJ8hyvQLzePEkqNlfKc7DHpZNiF2XM0RPqHJfr0KfAPVPtLv2br
         qDxwSVEn/sNHhZmpjWwRJK+qTTAkkmULg52OiGo1YcGiez/Qw2LlnqID+1Bkapc510J4
         tg76hCsAgs/CCrbVbLOOeZ1JHGrlR9sZl7RxpvbwtW4cBnUVw8X3YkrWsL5THD6EkxTE
         Gzww==
X-Gm-Message-State: AOAM530AtTlVq5Ot8r+j960XvVTRK9V65fRV3b3n0c6sczJ0RsHWnEIR
        bikhCSqvJ4mDUDQHXrXNG5LAdevIvdrpqIB5n3U4Dtv3FTNt7A==
X-Google-Smtp-Source: ABdhPJxM43BcUJKFe2lDUmTM8l3BKTtNV1beFe0RcpQsq78nZLYRS8VCkR35yQ0/kraLmlvLFN23jgsE7AWpfFBVCn0=
X-Received: by 2002:a25:5887:: with SMTP id m129mr973533ybb.11.1597976656051;
 Thu, 20 Aug 2020 19:24:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAMdqtNXQbQazseOuyNC_p53QjstsVqUz_6BU2MkAWMMrxEuJ=A@mail.gmail.com>
 <8d8870de-909a-d05d-51a5-238f5c59764d@kernel.dk>
In-Reply-To: <8d8870de-909a-d05d-51a5-238f5c59764d@kernel.dk>
From:   Glauber Costa <glauber.costa@datadoghq.com>
Date:   Thu, 20 Aug 2020 22:24:05 -0400
Message-ID: <CAMdqtNWVRrej-57v+rXhStPzLBh7kuocPpzJ0R--A3AcG36YAQ@mail.gmail.com>
Subject: Re: Poll ring behavior broken by f0c5c54945ae92a00cdbb43bdf3abaeab6bd3a23
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, xiaoguang.wang@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 20, 2020 at 9:57 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/20/20 6:46 PM, Glauber Costa wrote:
> > I have just noticed that the commit in $subject broke the behavior I
> > introduced in
> > bf3aeb3dbbd7f41369ebcceb887cc081ffff7b75
> >
> > In this commit, I have explained why and when it does make sense to
> > enter the ring if there are no sqes to submit.
> >
> > I guess one could argue that in that case one could call the system
> > call directly, but it is nice that the application didn't have to
> > worry about that, had to take no conditionals, and could just rely on
> > io_uring_submit as an entry point.
> >
> > Since the author is the first to say in the patch that the patch may
> > not be needed, my opinion is that not only it is not needed but in
> > fact broke applications that relied on previous behavior on the poll
> > ring.
> >
> > Can we please revert?
>
> Yeah let's just revert it for now. Any chance you can turn this into
> a test case for liburing? Would help us not break this in the future.

would be my pleasure.

Biggest issue is that poll mode really only works with ext4 and xfs as
far as I know.
That may mean it won't get as much coverage, but maybe that's not relevant.

>
> --
> Jens Axboe
>
