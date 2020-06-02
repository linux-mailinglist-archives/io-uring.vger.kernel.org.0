Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEDB1EC569
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2020 01:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgFBXDW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Jun 2020 19:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728128AbgFBXDV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Jun 2020 19:03:21 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CA5C08C5C0
        for <io-uring@vger.kernel.org>; Tue,  2 Jun 2020 16:03:20 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id u16so81437lfl.8
        for <io-uring@vger.kernel.org>; Tue, 02 Jun 2020 16:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HuqADZlz/+ixMviXEQWbebgF++rl4PnbtyN63wR082U=;
        b=ciuG9bpzQMkWDQSS32g0Sqw8ILsZfGGanf0utolyh2ANFc5qoInQK+kbfJwaZfxGgE
         GwkzwW/qj3PCIcDNDPxrH8YH8NBu0BUg5bpaCawy2gYyFz9U9rT99tIsJn+O/fH1RPWK
         ICrq+w9hKSk2+OKzKMDcxzJJeWXsBmpyynYrI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HuqADZlz/+ixMviXEQWbebgF++rl4PnbtyN63wR082U=;
        b=Bxr6QLKoHxSx0LVFidHvkaoSHMxtTCG1unfpttiaM1J9/6ow/PTNUv/6+eYhntwbz3
         6DhnUSsyNKUMI6SjCcDzl42xqzFrzwK7iZBD3JFlOi69PTXjz5sG1KTWik+G7PRFsnX6
         ypfa6gxeZAcuRsL1I85JVuG7NCTN0LQr8+aDMvrC9fbjVTeMsjyEh/dBu53gbXQPmBEo
         Cm4X9Sj3lHWGJhfS9jWqImyEtOM7dJ+444beys5FJHlZI8tOHqROjmsipl+IMp8Yn4pu
         nGMNcVf6ncSntzyGTcO9Cmo93wDEnajVDDtc0v82rH9QrqYA2aHLy91D2O7NMaRspyVt
         dEdg==
X-Gm-Message-State: AOAM532Kw3zLCgdmolDWFo2JpaPWEyUBC79LFcbqOj+3dottzlE3wWQu
        VkBNxG9EPd5LRSnvSB5TL7cW8IRdd6Y=
X-Google-Smtp-Source: ABdhPJwO6ftG+u7m/RL35ryn7rBLWVbm2X5Oe1gLlepOPBctJB7MuOTDAAsTzheRa22LDg6Di/JvBA==
X-Received: by 2002:a19:f813:: with SMTP id a19mr828522lff.212.1591138998437;
        Tue, 02 Jun 2020 16:03:18 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id h26sm71645lja.0.2020.06.02.16.03.17
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 16:03:17 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id w15so73170lfe.11
        for <io-uring@vger.kernel.org>; Tue, 02 Jun 2020 16:03:17 -0700 (PDT)
X-Received: by 2002:a19:d52:: with SMTP id 79mr829373lfn.125.1591138997106;
 Tue, 02 Jun 2020 16:03:17 -0700 (PDT)
MIME-Version: 1.0
References: <dacd50ff-f674-956b-18cd-9d30e2221b09@kernel.dk>
In-Reply-To: <dacd50ff-f674-956b-18cd-9d30e2221b09@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 2 Jun 2020 16:03:01 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjuAN_vgUN_TiPtzSpz2NX9XQq7-nJ1u=gHG=EKdRdrkA@mail.gmail.com>
Message-ID: <CAHk-=wjuAN_vgUN_TiPtzSpz2NX9XQq7-nJ1u=gHG=EKdRdrkA@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring updates for 5.8-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jun 1, 2020 at 10:55 AM Jens Axboe <axboe@kernel.dk> wrote:
>
>   git://git.kernel.dk/linux-block.git for-5.8/io_uring-2020-06-01

I'm not sure why pr-tracker-bot didn't like your io_uring pull request.

It replied to your two other pull requests, but not to this one. I'm
not seeing any hugely fundamental differences between this and the two
others..

               Linus
