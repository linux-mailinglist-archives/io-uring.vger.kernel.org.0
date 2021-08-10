Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF943E59DB
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 14:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240260AbhHJMZv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 08:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240254AbhHJMZv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 08:25:51 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358ABC0613D3;
        Tue, 10 Aug 2021 05:25:29 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id b11so9866615wrx.6;
        Tue, 10 Aug 2021 05:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=46uttd57qDgJ8zS4aFhGTeFL+aWcacM4jv424clAPHA=;
        b=OgFyryNO3QGEPzpa+iD6qV5DO+TCrT8yCea7HMnzfxLzMHyfEPvbhQm7B7j8KfvxQk
         rb7XwVsmEYcUmPEzB7XJ+wypcDqjOn3IuOxrHGwAWiT5Uv7VfMQDCUIxjjSTyMIaMj++
         EY3TvwSyP8Fs5ndErkSJeEMa2rN1fDTeJ9AO8ltol5DjCzUnzaFbqZRm822siXN8U4Jg
         VQcE1EcZZ2IKrxbD6BUqfpn4AEDAHMvQ0dPkwN6loPUtdbfAoSwJv4glIiFb5uIyVpcu
         oJGYGgTxgPo6s38c43BaMFAVh37TAogIt11hnYdIMlgb1zLsagf0Wkq+p1a/HbAWCztb
         5FPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=46uttd57qDgJ8zS4aFhGTeFL+aWcacM4jv424clAPHA=;
        b=DqGnAlZKrxYfCLh2rtehoQlYxZwHyAjq94jdMoE0qVjdjIcwZtl2Pg1By3KTfZae4F
         TTnxoYoRjjBdsrDMHIWIzuxlInFeyfelrxCM7udP6sv9WJ5/osQ7fyLOZOJMc5vGvXrS
         eyaWf3IFYJDuZcfSPYoJI+/R8jJpTi1ERFgGG3WAP+XOtYHNITFEQmL+6jcJsimQWxa4
         bvOVGm31uZWeFWbLEQ+mTrutIjB2gcedTIIUxGR4lTsW2ONDE27CuLAaa23n80NYvy8f
         wtRhejoMphuVQPIhWTOO+mbFW4rkYFddJLg3G9v2NNDU6a8B6Ubd2RhksIRzrlfKYiEo
         G0Lg==
X-Gm-Message-State: AOAM532G2bb1w0qQE2V0c5lc5J8t51Aqx2ljAToZUXyqlPsaDzHGwd+8
        DzR6zr5dR1jQBJkoaVlheLZGxhKnUG3Yn+fY9hw=
X-Google-Smtp-Source: ABdhPJzHIVBAAYsAzYMLpcSehzRUY+Ijs//WgCHhaZrG++zqurT7m/dNAxqR3IwqZkvVsFJbKCsIceEOoa1wL3MmUsw=
X-Received: by 2002:a5d:6146:: with SMTP id y6mr30068657wrt.278.1628598327648;
 Tue, 10 Aug 2021 05:25:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210809212401.19807-1-axboe@kernel.dk> <20210809212401.19807-4-axboe@kernel.dk>
In-Reply-To: <20210809212401.19807-4-axboe@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 10 Aug 2021 17:55:02 +0530
Message-ID: <CA+1E3rKB7m54VxD+RrdS06ZSSJ_gJtO_ZVVQvespo+Y+jOBiKg@mail.gmail.com>
Subject: Re: [PATCH 3/4] io_uring: wire up bio allocation cache
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 10, 2021 at 6:40 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> Initialize a bio allocation cache, and mark it as being used for
> IOPOLL. We could use it for non-polled IO as well, but it'd need some
> locking and probably would negate much of the win in that case.

For regular (non-polled) IO, will it make sense to tie a bio-cache to
each fixed-buffer slot (ctx->user_bufs array).
One bio cache (along with the lock) per slot. That may localize the
lock contention. And it will happen only when multiple IOs are spawned
from the same fixed-buffer concurrently?

> We start with IOPOLL, as completions are locked by the ctx lock anyway.
> So no further locking is needed there.
>
> This brings an IOPOLL gen2 Optane QD=128 workload from ~3.0M IOPS to
> ~3.25M IOPS.



-- 
Kanchan
