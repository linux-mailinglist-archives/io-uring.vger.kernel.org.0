Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 281B51377F7
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2020 21:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgAJUeq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jan 2020 15:34:46 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37752 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgAJUeq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jan 2020 15:34:46 -0500
Received: by mail-lj1-f196.google.com with SMTP id o13so3454055ljg.4
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2020 12:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fLDkVYN7v5q8zfOQ9ASoVLFLDR94IOPdY6vM6f2CvbM=;
        b=gkvMcbdOMlNm+PD6WFxHHwHo7FSy1ndwE8OJL247IqEff0n/RWeFWl6qi+oumhXlxR
         VhaUMXguH6Qp3N73HoxExIJEguJJR20mesmH2hinj9Pu2uaxBUXgbBKKpnkxy0yGo1Y9
         CHvsDe6WHKFh/G4OWlqbeaa7Oxlugr5u7P3Mg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fLDkVYN7v5q8zfOQ9ASoVLFLDR94IOPdY6vM6f2CvbM=;
        b=Cyd7OttIgUnNF7B3WmE5JU5KoVS0huppp8jRC01OQhi1AwOZx1xkdTQM4euzgSkymA
         3CVeEqW+xFguwQtM3p+wEvSw1IDKNjmb3wK8uF7Ta7Ghl4yYqF7YusyexokXAYcFey+5
         ngdaPQfYWIqHNPwmCklomeVDhtudVfqZgoImZGHb1AV4fR/6ovMLMtBNtMZQh+znrPd4
         2DaUdomP1e1NPYSCM53VFcVok+Fh1/ycO7C4sqqJtIozmiDE+3HCyZi9msKL4v+OrtxP
         dmr75RBcIRHQ7yuUFkD/8BdhKNdEaOHcWtZa11Y1ugGJUTM2a08pJqKACgkL60QBvX+Q
         OCzg==
X-Gm-Message-State: APjAAAXyDdA/fDbRremWbdpw2FR2RONDFFkgN3VVaD5LVuUOxg4ujROt
        ox/msveeg4NMDZXtIiJhNqBufI87/7w=
X-Google-Smtp-Source: APXvYqxlXQ/Flf8IEZNyc9RpHpdjgJ62et0ZbECcK4xgMNHDHa16d6qfmYM3nn8ki1cQt9MZOgp+xw==
X-Received: by 2002:a2e:9243:: with SMTP id v3mr3818134ljg.73.1578688484602;
        Fri, 10 Jan 2020 12:34:44 -0800 (PST)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id l22sm1492039ljj.44.2020.01.10.12.34.43
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2020 12:34:43 -0800 (PST)
Received: by mail-lj1-f180.google.com with SMTP id z22so3478004ljg.1
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2020 12:34:43 -0800 (PST)
X-Received: by 2002:a2e:990e:: with SMTP id v14mr3667607lji.23.1578688483436;
 Fri, 10 Jan 2020 12:34:43 -0800 (PST)
MIME-Version: 1.0
References: <4f9e9ba4-4963-52d3-7598-b406b3a4ed35@kernel.dk>
 <CAHk-=wgLX0Axk+3Gd6YeRcXkW6GHOk0_CSpp3fJGgmmbN8_BMA@mail.gmail.com> <5b093882-16dd-0bcb-79b6-0f37be77a03c@kernel.dk>
In-Reply-To: <5b093882-16dd-0bcb-79b6-0f37be77a03c@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Jan 2020 12:34:27 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgFxvMZU01aT8eZaeKs07r__WM2fQZSBKPCyUJPJwsdQw@mail.gmail.com>
Message-ID: <CAHk-=wgFxvMZU01aT8eZaeKs07r__WM2fQZSBKPCyUJPJwsdQw@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fix for 5.5-rc
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 10, 2020 at 12:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> That's had a 100% success rate so far ;-)

I see that you like to live dangerously.

I _think_ I've been fairly good about not missing any pull requests,
and checking my spam folders etc, but ..

               Linus
