Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B752C32DB73
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 21:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbhCDUwH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 15:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhCDUvt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 15:51:49 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85305C061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 12:51:08 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id r25so34085771ljk.11
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 12:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sp505Yl2bt/Ew89vOXo1rtmLKN3G30QxEpaQbI6G018=;
        b=IS6GAdCGY/TmRurymGp+N3Tf5/psU83V5ub25OtfXiQt91mxp9C14cpPssbcrMPcP6
         neKD9ykpGKr5BpFvp2G2+yw0c3mAH1Y2Tl7xlsihe0NoaHE9BhKr9c8CV5yUWfTd3NoN
         uXbYvoN7cy5u/RoaR1WDz+uaEbZJX7rbz6Ltg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sp505Yl2bt/Ew89vOXo1rtmLKN3G30QxEpaQbI6G018=;
        b=YyzNDFQMSbukr+mZC3/uzXQA/O4wZEP9yZDN2xwGgWVaZ1/AFFmd8wKmkboMkBnyll
         KKq4mZan7ShNzuOVVmOS8ZlUHSM68+jl9vJjjDy6u3OqJRtf2VPRs6r6EAtDcKQiLUbo
         YGo5Fj89EZIGr34jS0GzfszkPvzI+/NX/uHnu/Fc/KW3ma670BEaPFyyCoBgfq1Us/Yy
         +IqaEe1hF42I+iLi5IOVYQJV6HTr+mJZK/5SSV4kLC3zOGMOa7V0Iea/GN/nSplPLp9r
         Kz+AXWInTnWjx6Ket4LymHUkN3BHxTd9ONC2PSQe5qn1P4bDJ01cbSIp7GFpBb7nQxyv
         LKDA==
X-Gm-Message-State: AOAM532jVaMscgfh93uaGEhbz1lVO89juckZhg6OASoFUDQwGiDHITOB
        11JeKoozj/iebBaG8nxVIlscScHiHnXTVg==
X-Google-Smtp-Source: ABdhPJwVVyIcayGWARv67z9DgAfCawLRPkws2ag3s54oKh8okHKOnxx7xf6EzW+ODbkrqQRH9W8mTQ==
X-Received: by 2002:a2e:844e:: with SMTP id u14mr3246662ljh.171.1614891066630;
        Thu, 04 Mar 2021 12:51:06 -0800 (PST)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id o24sm53361lfg.64.2021.03.04.12.51.05
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 12:51:05 -0800 (PST)
Received: by mail-lj1-f178.google.com with SMTP id u4so35085161ljh.6
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 12:51:05 -0800 (PST)
X-Received: by 2002:a2e:5c84:: with SMTP id q126mr3178941ljb.61.1614891064771;
 Thu, 04 Mar 2021 12:51:04 -0800 (PST)
MIME-Version: 1.0
References: <20210219171010.281878-1-axboe@kernel.dk> <20210219171010.281878-10-axboe@kernel.dk>
 <85bc236d-94af-6878-928b-c69dbdcd46f9@samba.org> <d9704b9e-ae5e-0795-ba2e-029293f89616@kernel.dk>
 <a9f58269-b260-6281-4e83-43cb5e881d25@samba.org> <d3dfc422-8762-0078-bc80-989f1d71f006@samba.org>
 <32f1218b-49c3-eeb6-5866-3ec45acbc1c5@kernel.dk> <34857989-ff46-b2a7-9730-476636848acc@samba.org>
 <47c76a83-a449-3a65-5850-1d3dff4f3249@kernel.dk> <09579257-8d8e-8f25-6ceb-eea4f5596eb3@kernel.dk>
 <CAHk-=wgqJdq6GjydKoAb41K9QX5Q8XMLA2dPaM3a3xqQQa_ygg@mail.gmail.com>
 <f42dcb4e-5044-33ed-9563-c91b9f8b7e64@kernel.dk> <CAHk-=wj8BnbsSKWx=kUFPqpoohDdPchsW00c4L-x6ES8bOWLSg@mail.gmail.com>
 <bcab873a-eced-b906-217f-c52a113a95a9@kernel.dk>
In-Reply-To: <bcab873a-eced-b906-217f-c52a113a95a9@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 4 Mar 2021 12:50:48 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiDYfkuH1cAk_oZDZ8ZzZP1zuaXcQv34P5z_JJi038fZQ@mail.gmail.com>
Message-ID: <CAHk-=wiDYfkuH1cAk_oZDZ8ZzZP1zuaXcQv34P5z_JJi038fZQ@mail.gmail.com>
Subject: Re: [PATCH 09/18] io-wq: fork worker threads from original task
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 4, 2021 at 11:54 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> I agree, here are the two current patches. Just need to add the signal
> blocking, which I'd love to do in create_io_thread(), but seems to
> require either an allocation or provide a helper to do it in the thread
> itself (with an on-stack mask).

Hmm. Why do you set SIGCHLD in create_io_thread()? Do you actually use
it? Shouldn't IO thread exit be a silent thing?

And why do you have those task_thread_bound() and
task_thread_unbound() functions? As far as I can tell, you have those
two functions just to set the process worker flags.

Why don't you just do that now inside create_io_worker(), and the
whole task_thread_[un]bound() thing goes away, and you just always
start the IO thread in task_thread() itself?

              Linus
