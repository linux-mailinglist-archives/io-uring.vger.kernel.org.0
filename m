Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDCA4204CF
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 03:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhJDBx3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 21:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbhJDBx3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 21:53:29 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8DAC0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 18:51:40 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id dj4so59610014edb.5
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 18:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gSrv1Z0MFc5uCyI5tToUqPeoVReKIWmP/OCrAs0woC8=;
        b=faH1RZuAfxUrj3xChxZa5L5ig7oYYC+AUYUydnPjXg8ZsAdaBFNOtN6T+r8OKs2FVa
         dtp2BjwJJdUUotL6ERYCGISh4Fh2ZlGQJpwXgqAN8La7EPLvum5n1uw3/xcnHWcpNVz8
         k0/JgZ/7Y1mAWBqdukwPIiyLul2Uhpk8HBueJivx3d5DSE9dDVZmKtro9mpTXWpF60P9
         NT6UWM8062vQfdhuTa/9Bi5zz4LtPlSW8zGTwCiN11FjyQ1WQT57CYZkCmS6fegqMPDg
         +AZWs1+nthf+x3g+sqQK4KRRBH9OeqIc8ZCxvGeEK1jPsRsyr8nXzA9UirswWIwrJgMV
         saXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gSrv1Z0MFc5uCyI5tToUqPeoVReKIWmP/OCrAs0woC8=;
        b=X2ksSLbGZZUlRWgLKqD1nlOmiXhdbWi6t+7rWXkL/JGaaqHZOf3LKQ+TXzQvPGt80H
         vGxiYKNiqV1mkA7zG8qvOCIOQixY/QYjnQg9VP+/TgnHHe569bbkBca6foevkKoX+TCo
         7kmu/92FZCYAGDWcb0Eu2SMjww3LXGxN9QCguiZWkMP0xT81BUJbRTRMbgnJaNkdU1Y4
         XMkBhtN3qjN/dkBkYxB5OVIFO3+2Yvy79xTdy2/tR6n0+KM/DGlNFXCksvmTcC3d5fhR
         vw4WtexyKsNlypXcOG8S6I4DBwplnyM1ZSLHEFn0l6No1cX8ig3D/xF1s42NfvMDi9k4
         uDHA==
X-Gm-Message-State: AOAM530mvz1JUFxnY6ZVfjPKpq3diI7JLretsLHbN3QTZkttONk1Tnld
        JETd+heRpRXPIUNolnscANYUuFPGzqVcvfeqgxUAKIvSgRFluhbwrPE=
X-Google-Smtp-Source: ABdhPJy7f0iDYRj7eUU742G2gkXDlA1L2bpWGmef0kNC4DCmxiSgEDnn57pDzCZc0Eyg+HdprjO+GTAMo5mMDI7eJbM=
X-Received: by 2002:a50:d98d:: with SMTP id w13mr15120477edj.51.1633312298747;
 Sun, 03 Oct 2021 18:51:38 -0700 (PDT)
MIME-Version: 1.0
References: <20211004013510.428077-1-ammar.faizi@students.amikom.ac.id> <e2d18015-510b-1570-3b23-eae2c6e45d1d@kernel.dk>
In-Reply-To: <e2d18015-510b-1570-3b23-eae2c6e45d1d@kernel.dk>
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Date:   Mon, 4 Oct 2021 08:51:26 +0700
Message-ID: <CAGzmLMXxtr58qHtoHXhgoOJG763L=FEAJ5QMD21kFgwZbuFQfw@mail.gmail.com>
Subject: Re: [PATCH liburing] src/syscall: Add `close` syscall wrapper
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Oct 4, 2021 at 8:37 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 10/3/21 7:35 PM, Ammar Faizi wrote:
> > In commit 0c210dbae26a80ee82dbc7430828ab6fd7012548 ("Wrap all syscalls
> > in a kernel style return value"), we forgot to add a syscall wrapper
> > for `close()`. Add it.
>
> Applied, thanks.
>
> --
> Jens Axboe
>

Oops, sorry Jens, I copied the wrong commit hash.
0c210dbae26a80ee82dbc7430828ab6fd7012548 is wrong (it's in my own tree).

The correct one is cccf0fa1762aac3f14323fbfc5cef2c99a03efe4.
Can you amend that?

-- 
Ammar Faizi
