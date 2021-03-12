Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949D233990E
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 22:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbhCLVZ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 16:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235196AbhCLVZa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 16:25:30 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA798C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 13:25:29 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id n16so47520082lfb.4
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 13:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p8mlp7bkS7akOyHV+atgG+wSa368HCcgtwOF7DVrsoA=;
        b=ZQ6tgaN2WDLrW9Fu7kSRF585HQGAQcwbukQKtXJHV+eAuqiNe5AO4FfWbllqmMGxpU
         /k5PRMI1pSDGAEnFPxbIrI5/HOtwnbBkgmZi32v0Xys3tG/7Q9F/7U1I8LZSYQyY0Ksj
         o+IxVpMHPzqjlAgt8v8Lc2FupbSZ/9NJdVSLM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p8mlp7bkS7akOyHV+atgG+wSa368HCcgtwOF7DVrsoA=;
        b=StgyHI/0dOBOY6Qoy/NDraK4CHwLKwCbKx8p1GXHTyhVf9Ff1/0g2s6rln2IRYFrcX
         dOQSHtFTtSqbX5gtreU+/1YeqL926ZpGmoQ66rc/eNec/H128MHpbkM/K9LeUuYgGaEI
         f5Tf8Xq+Hcy+YMbiRtF+AprGF4RbGuht3eTlRt6vByS6AvK4QksA6QZeTqIJc1SMR1GX
         mAJdDClF5yujlK5MCQci3nIRKmdgPKAzVWOKcAWx5taMsozOHqyW35em7Vu2KBzecX8/
         ml62KRUzl5dssnxHGBf22N/ksCWazkJOzKHtn1cQBPA9tEt9NPT/f4QuI9TT/EbkFIFi
         YHNw==
X-Gm-Message-State: AOAM531aeL50QMQ1KfhvhYwXXtRm8C8ODOEJNCgPUZ8+DXxSDyImIdVN
        Rfwo1IYxBLfxGEg+V8fFWS73SWBpZaifXg==
X-Google-Smtp-Source: ABdhPJwFm/U6IL7rYgsydMnBWyNyfEbXapQJePz5DcoskZkiRIItXZrrie4oey+HIbh0d7qsWUx08g==
X-Received: by 2002:ac2:455b:: with SMTP id j27mr672842lfm.72.1615584326573;
        Fri, 12 Mar 2021 13:25:26 -0800 (PST)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id d10sm2091628ljg.112.2021.03.12.13.25.26
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 13:25:26 -0800 (PST)
Received: by mail-lf1-f53.google.com with SMTP id u4so47520995lfs.0
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 13:25:26 -0800 (PST)
X-Received: by 2002:a05:6512:398d:: with SMTP id j13mr639261lfu.41.1615584325724;
 Fri, 12 Mar 2021 13:25:25 -0800 (PST)
MIME-Version: 1.0
References: <a5447498-4a4c-20b3-ed1a-68b61df8b26b@kernel.dk>
 <CAHk-=wjpS-kwozJQFNBestco=q5j3bcfXpVXc6uz=9_mmQ7oYg@mail.gmail.com> <CAHk-=wj3gu-1djZ-YPGeUNwpsQzbCYGO2j1k_Hf1zO+z5VjSpA@mail.gmail.com>
In-Reply-To: <CAHk-=wj3gu-1djZ-YPGeUNwpsQzbCYGO2j1k_Hf1zO+z5VjSpA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Mar 2021 13:25:09 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgzegccwzCv77fU5migNKv0GqG6fU9z8oq5GOXOS8w_Dg@mail.gmail.com>
Message-ID: <CAHk-=wgzegccwzCv77fU5migNKv0GqG6fU9z8oq5GOXOS8w_Dg@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc3
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 12, 2021 at 1:24 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I think the fix is to simply make freeze_task() not do that fake
> signal thing for IO-uring threads either.

Note: I've pulled your tree, I just want you to dig deeper, verify,
and check this for perhaps re-instating freezability.

              Linus
