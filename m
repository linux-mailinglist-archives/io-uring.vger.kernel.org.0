Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4732347E9AD
	for <lists+io-uring@lfdr.de>; Fri, 24 Dec 2021 00:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241085AbhLWXnY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 18:43:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhLWXnX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 18:43:23 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F53C061401
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 15:43:23 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id bm14so27029898edb.5
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 15:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ssyz0ha5YeJIv12/NklQV6MUZg+AZRm+IOWJC7s2bAc=;
        b=VMFGw1xkbivzXYfQsYpRVguCEK+dm3r2N+D/2P++CBBBPaCmNm8Cw4blfs9anj/s2c
         +IAquoEHZoHJ70sHSikQzR8rY66wvA33KwO0dj05jv7YQxkCX+JTJyn9fRF4xd6qGBH7
         nwpet7+GWY0nP8seMvdK5LYLdndHCDjOtgfYg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ssyz0ha5YeJIv12/NklQV6MUZg+AZRm+IOWJC7s2bAc=;
        b=ED104T6h2v10qIe+Cx7TdgsMU9WzHUVm1AkmzqhF9tePYbfC83QForopLe0+vOfeAP
         fPnJfuQn1UNV/Rk9rWP0ctZLzYhNajYX54lPL0krxUsBBa/zcOQ0n1zpw8qcONQ0agdr
         4bnW4Npu5Gu8OOMc7MzsAGIKJQo2y0Eh5qWBuNwEH5Z0RGYYmMmOFHQ4/bW+cuD70vfG
         PkeEtScoUPrE8urZHlr45dIF7pC1C8ePU22Urbse/F2EHI2wJCUUcLVt6Pe2ZRtTj/Al
         3XEHGm46TvC6wEz3YYlYMQUu7UAAMIt/Rjg0K2qvDApsAmDkxvmDY+1AtuLQwWcatznC
         dpUw==
X-Gm-Message-State: AOAM532dy5VlS3VayAtoH6h/W925u7CrCZZTOGzYb1SfGWXzkibWMbcB
        Jop7mudQneQTwotM0qr4upm1NS36/cn7yreEuk8=
X-Google-Smtp-Source: ABdhPJzdnC0MOubeuyDmvTjSFqfEFw+Jnti9j9zyCf5D9mfbma/ihlNG0/XhMgKo/D7IUjjMbos8bw==
X-Received: by 2002:a17:906:c305:: with SMTP id s5mr3498468ejz.42.1640303001814;
        Thu, 23 Dec 2021 15:43:21 -0800 (PST)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com. [209.85.221.50])
        by smtp.gmail.com with ESMTPSA id z7sm2496802edb.59.2021.12.23.15.43.21
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Dec 2021 15:43:21 -0800 (PST)
Received: by mail-wr1-f50.google.com with SMTP id j18so14319996wrd.2
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 15:43:21 -0800 (PST)
X-Received: by 2002:adf:f54e:: with SMTP id j14mr3037778wrp.442.1640303001298;
 Thu, 23 Dec 2021 15:43:21 -0800 (PST)
MIME-Version: 1.0
References: <b004710b-1c16-3d90-b990-7a1faf1e5fd0@kernel.dk> <CAHk-=wj-fA6Sp+dNaSkadCg0sgB2fKW7Wi=f8DoG+GmiM2_shA@mail.gmail.com>
In-Reply-To: <CAHk-=wj-fA6Sp+dNaSkadCg0sgB2fKW7Wi=f8DoG+GmiM2_shA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 23 Dec 2021 15:43:05 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgDGpBVOEH+JJS-byQE3adrZEpC9Sn8VCLr7ZhzDQv01w@mail.gmail.com>
Message-ID: <CAHk-=wgDGpBVOEH+JJS-byQE3adrZEpC9Sn8VCLr7ZhzDQv01w@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fix for 5.16-rc7
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 23, 2021 at 3:39 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I don't think any of this is right.
>
> You can't use f_pos without using fdget_pos() to actually get the lock to it.
>
> Which you don't do in io_uring.

I've pulled it because it's still an improvement on what it used to
be, but f_pos use in io_uring does seem very broken.

            Linus
