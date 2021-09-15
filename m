Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F8A40CC98
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 20:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhIOSdt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 14:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhIOSdt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 14:33:49 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023A9C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 11:32:30 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id h16so8003843lfk.10
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 11:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aWp4thBEdYZ99D5nCeA+V8YsS07M5e6rGbv4Aq7Iet8=;
        b=HalyG+FVMw3visRGX1bmrefSnjLCZhBbehZI0kg00cDKwjuz2c8l1jrB3yTLdN6HzM
         wLSwqjmTaCJhS/qifbhRMBvYnBUxJmE+i4EbFCIwNnSDDScCJNo2zGH4PpYHO+5VlCM7
         FEkGaA3KDrddjkhQfGEfbtXf0UlRkAKctoNLE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aWp4thBEdYZ99D5nCeA+V8YsS07M5e6rGbv4Aq7Iet8=;
        b=uqeJrTgpzjLmYXzGvuA5hkGbHnTeXLsYzld5IMkRb9ESG1pR3F+zo9qqsfYW9DY9za
         rigj8BfHRofDe/ZdsLIYpIpwICYE0HOwQohHx0JRWe3znLYlEpRxvzJcvBCLf3WdU1HY
         F2l2hDdL61T3l2zhFZPvBF24r3R852URDnhHst+kmKe/1fwyViYLz/669WcYBp8sIhoE
         8oD/9L77PynSryuijXRM0Pmp6EDzbc6lJ1bE3JPv1f5hqwSLhYdeHW2NvbE0QqrpBUpQ
         lvC01YI+rNrAtCpLT0LfK5SfXgNbeOiR5pkbLh56iWEmMInf+kaulFhxkTckohfseC0G
         ybEQ==
X-Gm-Message-State: AOAM533e5BZIyDF16lH9yC8Jc5clUjv7wlFDdEXp8ofhf6HOcC0CQhhp
        3n8vLS8qJri7NXgVVFKRpn6vDNQ3OutIRjji14U=
X-Google-Smtp-Source: ABdhPJy9sCzvXkMWSdBneZ+hyvkLyREdoclHVQgdvmC4aed0VcN2CotOPNx8MkgquXuyIO3nd8xfPA==
X-Received: by 2002:ac2:4db6:: with SMTP id h22mr975404lfe.251.1631730747991;
        Wed, 15 Sep 2021 11:32:27 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id u12sm51210lff.280.2021.09.15.11.32.27
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 11:32:27 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id t10so2428613lfd.8
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 11:32:27 -0700 (PDT)
X-Received: by 2002:a05:6512:94e:: with SMTP id u14mr981143lft.173.1631730746978;
 Wed, 15 Sep 2021 11:32:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210915162937.777002-1-axboe@kernel.dk>
In-Reply-To: <20210915162937.777002-1-axboe@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 15 Sep 2021 11:32:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgtROzcks4cozeEYG33UU1Q3T4RM-k3kv-GqrdLKFMoLw@mail.gmail.com>
Message-ID: <CAHk-=wgtROzcks4cozeEYG33UU1Q3T4RM-k3kv-GqrdLKFMoLw@mail.gmail.com>
Subject: Re: [PATCHSET v3 0/3] Add ability to save/restore iov_iter state
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Sep 15, 2021 at 9:29 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> I've run this through vectored read/write with io_uring on the commonly
> problematic cases (dm and low depth SCSI device) which trigger these
> conditions often, and it seems to pass muster. I've also hacked in
> faked randomly short reads and that helped find on issue with double
> accounting. But it did validate the state handling otherwise.

Ok, so I can't see anything obviously wrong with this, or anything I
can object to. It's still fairly complicated, and I don't love how
hard it is to follow some of it, but I do believe it's better.

IOW, I don't have any objections. Al was saying he was looking at the
io_uring code, so maybe he'll find something.

Do you have these test-cases as some kind of test-suite so that this
all stays correct?

            Linus
