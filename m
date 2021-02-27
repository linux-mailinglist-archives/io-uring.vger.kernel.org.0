Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50887326DEB
	for <lists+io-uring@lfdr.de>; Sat, 27 Feb 2021 17:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhB0QkU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Feb 2021 11:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbhB0QkB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Feb 2021 11:40:01 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4663FC06174A
        for <io-uring@vger.kernel.org>; Sat, 27 Feb 2021 08:39:18 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id e2so7084941ljo.7
        for <io-uring@vger.kernel.org>; Sat, 27 Feb 2021 08:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oV0RlkvCLhoG57VWIoeqvxEhNIrCut1XxrR9fr5/lvc=;
        b=HIofrqg6HGl6mp2yDqS205w3C1p6WKNlWRyRCxs9O4PyPMq0mHkDIPTHOv7nkLrUEW
         Tm9QDbaUKRxvoCuQrVlsQCk0UghfkespusqDGZrOpoCWyi+Q/Vl2TjK0Nse2AHAuAwTo
         XbYc8GBByi6n7s/Z9W+eXG8ZGwDveDzeqVQAo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oV0RlkvCLhoG57VWIoeqvxEhNIrCut1XxrR9fr5/lvc=;
        b=LZyRJIagkvd1UHnulCWGjlEDQZM8rSzBKyrXkMICCIqlPcQoSCqYPHi5nc264n2oci
         A6v63e0uGj0zrpyM/AcK0bF4djzsGd6lUfz233tF9vzVj75NNtXdM+L4UvBw27aSyiVZ
         5/P+PUrk2ObLzoE9PPzEURiV+6w8AL5+p+4DzHL1c+0FGxM3McgosPG81NImYnaSSsNH
         vBMieJ/H9OBbaV8lvTiE8KYrRIXXqLsiNh5iWxh84/o7qDKf8A9x1b/92jdWymnuBRot
         lk+3pt4K6KG2Rajlr4J6V/2Vbzr3ATOzYyF0Oj7wf8Vd5X1L0cfsPzMAkxx5KqZzgIbl
         gRKw==
X-Gm-Message-State: AOAM531rKvvOlqsJd0FLJA9UN9qZY3mC/0ufOCtv5+DghIQrk/nwGY2T
        QvTal8Kw94sY6msAEDCI0CZs/4MFgTrEbQ==
X-Google-Smtp-Source: ABdhPJwxWrjAwU9+vzk3kuz+CANDzXf07pe1EL8op8I8GO4VH6HMbfaR+XKjjP6PjMcJAv7SzOg6zg==
X-Received: by 2002:a2e:898a:: with SMTP id c10mr4524862lji.104.1614443956530;
        Sat, 27 Feb 2021 08:39:16 -0800 (PST)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id z64sm374376lfa.92.2021.02.27.08.39.15
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Feb 2021 08:39:15 -0800 (PST)
Received: by mail-lj1-f169.google.com with SMTP id p15so5343476ljc.13
        for <io-uring@vger.kernel.org>; Sat, 27 Feb 2021 08:39:15 -0800 (PST)
X-Received: by 2002:a2e:9659:: with SMTP id z25mr4551704ljh.411.1614443955394;
 Sat, 27 Feb 2021 08:39:15 -0800 (PST)
MIME-Version: 1.0
References: <0c142458-9473-9df3-535f-34c06957d464@kernel.dk>
In-Reply-To: <0c142458-9473-9df3-535f-34c06957d464@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 27 Feb 2021 08:38:59 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi6=LQ1MAJ3Z9jyT90mos_8GhYCEMQtDrJ7CZ_FxuK3Rg@mail.gmail.com>
Message-ID: <CAHk-=wi6=LQ1MAJ3Z9jyT90mos_8GhYCEMQtDrJ7CZ_FxuK3Rg@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring thread worker change
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 26, 2021 at 2:04 PM Jens Axboe <axboe@kernel.dk> wrote:
>
>   git://git.kernel.dk/linux-block.git tags/io_uring-worker.v3-2021-02-25

Ok, I've pulled it, because it's clearly the right thing to do. It
would have been nicer had it been ready earlier in the merge window,
but delaying it will only make things worse, I suspect.

             Linus
