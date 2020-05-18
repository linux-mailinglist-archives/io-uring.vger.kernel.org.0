Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3661D7716
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2020 13:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgERLbc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 May 2020 07:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbgERLbc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 May 2020 07:31:32 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211D5C061A0C
        for <io-uring@vger.kernel.org>; Mon, 18 May 2020 04:31:32 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a5so5013065pjh.2
        for <io-uring@vger.kernel.org>; Mon, 18 May 2020 04:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i0UdwqHYKmLTRvJtkmDe2EJqN9SEHU5eHSkbWX17L3s=;
        b=RwfrNS7TKJ8zXAYNSrXYNdkTiDk5RGih/JmDsBhXyXhOtHEivJ2UvfX+1aZUXaguJ9
         CR1NRtaj/kLMHMv2TVpLWcIW/4Yh7rfPD6Gzy1DwIkwXW4pmj2LlM5z2BQw/KSlm7jrB
         Xyzu64zviV+ryfkhp48bWhIJCTw+NLboTUsCMkWPlXiybmDvzpXOYW0PdEh2gm1X24+7
         Rn7B8hofRjOzJrVrTXdg538xyp558SqXCi9f96x1HRbHh3kIhjqUQO6J/9pcDvQwEmjT
         dgcQlx0SJTmThbteO6a5A3XDPrJZ0SurIUdxuq8aWVPHcDWZKxBYM5zo/ZTAVnM2tzDJ
         GapQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i0UdwqHYKmLTRvJtkmDe2EJqN9SEHU5eHSkbWX17L3s=;
        b=o6jBcwa/RDUnkVldBqoGEspxbywoKoiBHx3nYnLTRFSMF+C2Ny7PamvTL5yym9JW/E
         WFYDU/6hQRXK0cMqlUGYpSjUhK+YTVRqY6aPNlY4BhQXxboTf0bhzR2Cq80O7X9pnPjS
         q1JfNfVlAQoljqafBp0zsI1lcYYA46tGAtWRyVWFNgTnm/s07HVG78S7jrL0WFVW+GYp
         GC/sl+risg7tNU359Xvvmrteze1/+oWrgctBXu2sFigBmRga/CiW1fFwU8F8Hq6I4G4U
         vAin5+ZQ/Y5xodEcpsF7iBppD1soMl42/B76feCayE9qC2Z7Mg6F/o5sCaMpS/O6Czkq
         WtKw==
X-Gm-Message-State: AOAM532eTaVKNSsPu10yR3/WtcTqUNJGhdu1TCVyOvMCPbYDB47gTduw
        /ctMGuSlq3eXVwGqDTqymAhQreh0eBJ40pQggUleiZg6
X-Google-Smtp-Source: ABdhPJwrG3dskfQvkLY0ij10PxTfa30q/5bb8bAxnC94WC4QqmkFKK50aV3RQMticOXzDI/mdd1LQIWtyqOUZ6poQO0=
X-Received: by 2002:a17:902:820b:: with SMTP id x11mr15272114pln.139.1589801491380;
 Mon, 18 May 2020 04:31:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAC40aqaSBwdBxQOn1T_ihtB=TnNLH91_xy05gFhvOG+3i3=ang@mail.gmail.com>
 <32cf6f07-c2df-76ed-5200-c39821cf6f61@gmail.com>
In-Reply-To: <32cf6f07-c2df-76ed-5200-c39821cf6f61@gmail.com>
From:   Lorenzo Gabriele <lorenzolespaul@gmail.com>
Date:   Mon, 18 May 2020 13:31:20 +0200
Message-ID: <CAC40aqYAxbXuXVd4iZ8SOAp2aENH30yupOiv8o8iw5W4WEVivA@mail.gmail.com>
Subject: Re: are volatile and memory barriers necessary for single threaded code?
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Thank you very much for the detailed answer!
So I think I will more safely build on top of liburing!

Lorenzo

Il giorno mer 6 mag 2020 alle ore 15:45 Pavel Begunkov
<asml.silence@gmail.com> ha scritto:
>
> On 04/05/2020 19:54, Lorenzo Gabriele wrote:
> > Hi everyone,
> > I'm a complete noob so sorry if I'm saying something stupid.
> > I want to have a liburing-like library for the Scala Native language.
> > I can't easily use liburing itself because of some limitations of the
> > language.. So I was rewriting the C code in liburing in Scala Native.
> > The language is single threaded and, sadly, doesn't support atomic,
> > nor volatile. I was thinking what are the implications of completely
> > removing the memory barriers.
> > Are they needed for something related with multithreading or they are
> > needed regardless to utilize io_uring?
>
> Long story short, even if your app is single-threaded, io_uring is _not_.
> I wouldn't recommend removing it. See the comment below picked from io_uring.h
>
> /*
>  * After the application reads the CQ ring tail, it must use an
>  * appropriate smp_rmb() to pair with the smp_wmb() the kernel uses
>  * before writing the tail (using smp_load_acquire to read the tail will
>  * do). It also needs a smp_mb() before updating CQ head (ordering the
>  * entry load(s) with the head store), pairing with an implicit barrier
>  * through a control-dependency in io_get_cqring (smp_store_release to
>  * store head will do). Failure to do so could lead to reading invalid
>  * CQ entries.
>  */
>
>
> More difficult to say, what will actually happen. E.g. if you don't use polling
> io_uring modes, and if you don't do speculative CQ reaping, there is a pairing
> smp_rmb() just before returning from a wait. But, again, the io_uring ABI
> doesn't guarantee correctness without them.
>
> --
> Pavel Begunkov
