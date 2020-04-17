Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126B71AE3CA
	for <lists+io-uring@lfdr.de>; Fri, 17 Apr 2020 19:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgDQR1x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Apr 2020 13:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728509AbgDQR1x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Apr 2020 13:27:53 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2637C061A0C
        for <io-uring@vger.kernel.org>; Fri, 17 Apr 2020 10:27:52 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id u15so2876092ljd.3
        for <io-uring@vger.kernel.org>; Fri, 17 Apr 2020 10:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C5NQST1nyAnu8ptbe8LACwEwOXn5hUjgwJZB1HluWEM=;
        b=BSDsQEQvITDO8FLYNfEM0Jy04yGRqu4vT5WnT4ovVsI9MQ2hNBwuBUKS2lm53hq5Bv
         WHnmjmziBdosh0dRodafXf1uMEqQeME9vosQjgwmwclZP9dIODWxm8GmEinVVsDSTl7o
         MNme38G/piidMQHqHQGf3MIdQ0/f7fGAcyfdU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C5NQST1nyAnu8ptbe8LACwEwOXn5hUjgwJZB1HluWEM=;
        b=hug9OUeVx5rYb97Ju48sl0mhcPUds+sGIs/hhUeMdHLwdhxqUrm7S4W2Ynt2rDXsQP
         3xg39iSU5NAgA/xSRa4kMQDcoVBXsvYj1D+ScbGqP0/HB8W/RO0g4oy34HQEiTEtTl/4
         xKsAuGzf1v1Ms2gbz/S4+a4JMU5MGU9j6DtmH86DWmQFhyXKzoA3jedj+ro/3CW7Lz/c
         Kbq5wkKYfpbS4JwO7rGYqHtAijabMKswuNLOkjkYVlr5fdqOND0cqTS0XT+cCeaG1JyY
         VnIjN7gzcF6dLv4WN6J+ILWFMxpPABieIwsbRPx5oCuFaMlclY9dV01KAUqOjcPM3dUh
         4FZg==
X-Gm-Message-State: AGi0PuZj61u3O50+yIZEuZv9s5km0ZPik/1OiQsgtuu+N6BsMGhRthey
        xn3NgGx9aZDzn7ysaTk7x1yyl0UTOMY=
X-Google-Smtp-Source: APiQypKiRv4Pg5Ihsz9KhhwzXsmzngJgazbDGiPcQ48tZEGUEwBYGwrFVsRmDqvi1FeD27PGNma80A==
X-Received: by 2002:a2e:8688:: with SMTP id l8mr2810776lji.233.1587144471167;
        Fri, 17 Apr 2020 10:27:51 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id i3sm4435807ljg.82.2020.04.17.10.27.50
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 10:27:50 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id q19so2831563ljp.9
        for <io-uring@vger.kernel.org>; Fri, 17 Apr 2020 10:27:50 -0700 (PDT)
X-Received: by 2002:a2e:870f:: with SMTP id m15mr2800184lji.16.1587144470102;
 Fri, 17 Apr 2020 10:27:50 -0700 (PDT)
MIME-Version: 1.0
References: <2750fd4f-8edc-18c2-1991-c1dc794a431f@kernel.dk> <CAHk-=wiWP0M=ZAim7VVuoR+5ri+Ug+KZDE-TZskma4HV91ACxA@mail.gmail.com>
In-Reply-To: <CAHk-=wiWP0M=ZAim7VVuoR+5ri+Ug+KZDE-TZskma4HV91ACxA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 17 Apr 2020 10:27:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=whhvP+UQ=A3SHFgT7DUFJ-M7pFPrUusJSFo8p0x8wQUhw@mail.gmail.com>
Message-ID: <CAHk-=whhvP+UQ=A3SHFgT7DUFJ-M7pFPrUusJSFo8p0x8wQUhw@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 5.7-rc
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 17, 2020 at 10:26 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I cannot convince myself it is right. How do you convince yourself?

.. and equally importantly: even if it were to be now correct - how do
you make sure it keeps working when it's so odd and subtle and crazy?

               Linus
