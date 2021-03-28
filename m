Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D19F34BE6B
	for <lists+io-uring@lfdr.de>; Sun, 28 Mar 2021 21:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbhC1TDB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Mar 2021 15:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbhC1TDB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Mar 2021 15:03:01 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D9CC061756
        for <io-uring@vger.kernel.org>; Sun, 28 Mar 2021 12:03:00 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 184so13465008ljf.9
        for <io-uring@vger.kernel.org>; Sun, 28 Mar 2021 12:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6meSVu06EdgIS3E4eUl13iSC0bIq0UJenzavQYq9iXg=;
        b=OngmHF9rdYA8WU4BMTKXK69WdSo7C/so4S7/5c7zW35JW+agmsvv+NvUROsbESjFNa
         Bf25+5xRyduknGBhjv9BbhAA4XI1K2TGo8s+7LQrFIP/GIv6M0Wcsbp+biiLdC8ZEzjV
         IKQS/rxW8s9Y6EaPKBvWryLiycp5J8Yk/ecXA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6meSVu06EdgIS3E4eUl13iSC0bIq0UJenzavQYq9iXg=;
        b=LjXS7ZAUaAIzMngpa7jbQJb/pQ5cgPs6kHZg8piAKPeE2vMRcKQ7u3gIj73uGiatVz
         K4mdSluVpE0s9562N0VNMkiWR5qYMkFPWex/aP9q+nsg7FQ2vUXuxnSDoYYnqoIcaQER
         vwj1vlq9/A9bNkOW4Ls+kk5mapk4CG3E49Jri1Dt123AIlC3+n7AVKA/hiEFw4fKUtrt
         u+n/QeKuMVYrSBDOOyDE8M8VlY64hbNAVGnhFwOLI5JbbnOa4b0Gmyek4HMbdpEmdpq8
         CJ6J3DWvpumPfZMMcOoivWUWZ4MPXwJRkBlwAb92Mn0iF/3g4mywowVQGHbY+60m374s
         F8zA==
X-Gm-Message-State: AOAM530OiM3LCa55rU56hK3QYIL/WFuxVCzjC62q9slcAXVWhSwNcQ7O
        Hzr/xVjN6xiQ8t7kX3GPA8DYGTa4pWLGtQ==
X-Google-Smtp-Source: ABdhPJw3nLhKEfA86ffz/lX+7k2wAYUVMlSZb2CeKGMaYdZChIukwZ81YBg/309FSp6/ujlFrU7xKw==
X-Received: by 2002:a2e:3c06:: with SMTP id j6mr16365289lja.496.1616958178821;
        Sun, 28 Mar 2021 12:02:58 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id e18sm2150454ljl.92.2021.03.28.12.02.58
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Mar 2021 12:02:58 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id o126so15208277lfa.0
        for <io-uring@vger.kernel.org>; Sun, 28 Mar 2021 12:02:58 -0700 (PDT)
X-Received: by 2002:a05:6512:3ba9:: with SMTP id g41mr13819817lfv.421.1616958177852;
 Sun, 28 Mar 2021 12:02:57 -0700 (PDT)
MIME-Version: 1.0
References: <aa67d57a-ba51-f443-c0f2-43d455bff25c@kernel.dk>
In-Reply-To: <aa67d57a-ba51-f443-c0f2-43d455bff25c@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 28 Mar 2021 12:02:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiHof59ZbJai7M7Xw7RYfm8KszApXztnoTHePke5mZBsA@mail.gmail.com>
Message-ID: <CAHk-=wiHof59ZbJai7M7Xw7RYfm8KszApXztnoTHePke5mZBsA@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc5
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Colin Ian King <colin.king@canonical.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Mar 27, 2021 at 6:02 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> - Fix sign extension issue for IORING_OP_PROVIDE_BUFFERS

I don't think this fixes anything.

It may change the sign bit, but as far as I can tell, doesn't actually
fix anything at all. You're multiplying a 16-bit value with a signed
32-bit one. The cast to "unsigned long" makes sure it's done as an
unsigned multiply, but doesn't change anything funcamental.

 - "p->len" is an explictly signed type (__s32). Don't ask me why.

 - the size calculation takes that signed value, turns it into an
"unsigned long" (which sign-extends it), and then does an unsigned
multiply of that nonsensical value

 - that can overflow both in 64-bit and 32-bit (since the 32-bit
signed value has been made an extremely large "unsigned long"

So there is absolutely nothing "right" about the typing there. Not
before, and not after. The whole cast is entirely meaningless, and
doesn't seem to fix anything. It is basically a random change.

If you want that calculation to make sense, you need to

 (a) disallow the insane case of signed "len". Most certainly not
sign-extend it to a large unsigned value.

 (b) actually make sure there is no overflow

because adding a random cast does neither of those things.

              Linus
