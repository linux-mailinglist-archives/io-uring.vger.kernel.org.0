Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3308A339921
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 22:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235258AbhCLVe2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 16:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235186AbhCLVeW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 16:34:22 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FEAC061574
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 13:34:20 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id f26so9092425ljp.8
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 13:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XifN/itEDg7LzwjfFtkmbuMe5vlwdjgDoMo87vRb1hg=;
        b=O1cHMWcld4qmaSbKYcMun33NWVQqbIkgMXuza3w2kQuFbv82Rhmkz2Cm+ztnSNlbf7
         8EqJUmMBYoC6YF/b41ha1K+Yn0sUbcVyaOELgQQ1E6oOSqH1mbErpuGngeJpeKZX0P5K
         cuU8xjp+iWjvWeAyymnaYnlRW40ugGdtieWKs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XifN/itEDg7LzwjfFtkmbuMe5vlwdjgDoMo87vRb1hg=;
        b=YeNGI+sJOfu06B76TjmtSWkinqxnWWmQp/JGx3+xUQvk4hekGXrlTUHMK0aV/rlETk
         /ov59vKd33Uw4/WJI299tTmlbGv8e9WiI9hBhZ3+tZrrwOtjLkK5p133mB4AzcahYL0i
         nrozmPptpqdSJECBkJHy7FnYnYg/SyvXmW6i3Nbzt332ZirTzUHfk6J3loM9Sg//sBQE
         Y2V0ueKXH2rR45lwct0ggkwulExDk4IcuLqrT+VcLmaK/sZEAeo6leXxB/eU5wDDoR+I
         Pz6EySCtLfkuwL2mDRNtAJLR/3IUd05iXf1Gth0s4IzTcSmZ/OvvXGT2nANP9WZsYbNW
         ec6w==
X-Gm-Message-State: AOAM5336awhziymOt3QSpwpt0U5a46QJNinNjOHMBHwSDvMdqFslvRz3
        ktimMCFBJFJrxcpMQd5z0Zc5qHNJgGF3vQ==
X-Google-Smtp-Source: ABdhPJyf4BPZkytDRPYnrqQ4rHq+vWu5VgifDYfKRrfYpNzIwfAETQNqgecvPtYS1fS1Tc07yq7mrQ==
X-Received: by 2002:a2e:bc1e:: with SMTP id b30mr3759298ljf.18.1615584859074;
        Fri, 12 Mar 2021 13:34:19 -0800 (PST)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id f3sm2113344ljm.5.2021.03.12.13.34.18
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 13:34:18 -0800 (PST)
Received: by mail-lf1-f44.google.com with SMTP id v2so34477165lft.9
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 13:34:18 -0800 (PST)
X-Received: by 2002:ac2:58fc:: with SMTP id v28mr643415lfo.201.1615584858189;
 Fri, 12 Mar 2021 13:34:18 -0800 (PST)
MIME-Version: 1.0
References: <a5447498-4a4c-20b3-ed1a-68b61df8b26b@kernel.dk>
 <CAHk-=wjpS-kwozJQFNBestco=q5j3bcfXpVXc6uz=9_mmQ7oYg@mail.gmail.com>
 <CAHk-=wj3gu-1djZ-YPGeUNwpsQzbCYGO2j1k_Hf1zO+z5VjSpA@mail.gmail.com> <CAHk-=wgzegccwzCv77fU5migNKv0GqG6fU9z8oq5GOXOS8w_Dg@mail.gmail.com>
In-Reply-To: <CAHk-=wgzegccwzCv77fU5migNKv0GqG6fU9z8oq5GOXOS8w_Dg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Mar 2021 13:34:02 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiNcvKE8QbP1x08F_SfjnnehehUyak8bZryxJt=EcL7Mw@mail.gmail.com>
Message-ID: <CAHk-=wiNcvKE8QbP1x08F_SfjnnehehUyak8bZryxJt=EcL7Mw@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc3
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 12, 2021 at 1:25 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Note: I've pulled your tree, I just want you to dig deeper, verify,
> and check this for perhaps re-instating freezability.

Also note that I don't think it's _just_ that freeze_task() thing that
is needed for the fix.

I think the io_uring threads then need to do the whole
"try_to_freeze()" dance in the main loop or something, so that it does
actually freeze.

           Linus
