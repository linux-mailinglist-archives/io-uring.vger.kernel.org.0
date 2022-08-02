Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDA9588332
	for <lists+io-uring@lfdr.de>; Tue,  2 Aug 2022 22:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiHBUpz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Aug 2022 16:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiHBUpv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Aug 2022 16:45:51 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5371147C
        for <io-uring@vger.kernel.org>; Tue,  2 Aug 2022 13:45:50 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id b16so11608502edd.4
        for <io-uring@vger.kernel.org>; Tue, 02 Aug 2022 13:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=jMQM6VWyA3CuAQPGaHRQWygks7/MUcQQvwWnradQtgg=;
        b=MpVRqwCozKZeTI7BkLJqljkb4Luwlll5StDqkKg9RV97NFRcNXlqusJpPcXBk3PcVM
         0oziPeObokr9ZY5vlam9TORe8RlxIVu/QfF0rmLQ6IH4+Ql3ntLZMzg39oO+VDFZF3IT
         hTOzOxjR8SEjng6sRcTB0qS0TMPL2M+futjG4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=jMQM6VWyA3CuAQPGaHRQWygks7/MUcQQvwWnradQtgg=;
        b=CVcnvB8qCK5KiBij2N1HWpJifoXkXrUCNqgZfoQbOD8691EL0xsy+kvbXnSueGlhWx
         RoB5QDtOr68r/2gTSS0fhWOOiW3GZYOQ4/aed7Vd3rvISm+iR+PK/lHjZgU/5J7IEKJ0
         8FBdnWalP4hTjGdXbNYOM49XRVkavGQrdSUMHsgmyEWDC5Ve2Y8rLEu0wdSfXFy6S387
         I9nPZrf9DDC2zqN+uKV5KS76y5vN6tB9VAqOSLAzDTOaEWAAU66tWdw6cABTXun4YEbW
         Ft0ZNEnLkcPiu2zShC8qY6KXszu/C3dEjfI2XipMjz1sRnWXMJCBCPrIM8Z5wpiSV7hs
         PVPQ==
X-Gm-Message-State: ACgBeo3QwAS+WIHNZFmsvIeMSLbZKb56yePHc6S9fHLQwdGt6oiJ9B7r
        7+a0rXo4da3Zk9Z/MLgeSaLyp2JYo0bdJ3VA
X-Google-Smtp-Source: AA6agR5OjO4b59dZRUNdEZU6g8556A3e4SPN7km2V5sCWG6m28XS3I5MOv9OoCXqzjuPMwLFkQHdFg==
X-Received: by 2002:a05:6402:138f:b0:43d:8ed5:c841 with SMTP id b15-20020a056402138f00b0043d8ed5c841mr13203091edv.27.1659473148513;
        Tue, 02 Aug 2022 13:45:48 -0700 (PDT)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com. [209.85.128.44])
        by smtp.gmail.com with ESMTPSA id p26-20020a05640210da00b0043e32c73778sm192743edu.67.2022.08.02.13.45.47
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Aug 2022 13:45:47 -0700 (PDT)
Received: by mail-wm1-f44.google.com with SMTP id n20-20020a05600c3b9400b003a4f2261a7eso417574wms.2
        for <io-uring@vger.kernel.org>; Tue, 02 Aug 2022 13:45:47 -0700 (PDT)
X-Received: by 2002:a05:600c:2211:b0:3a3:2149:88e1 with SMTP id
 z17-20020a05600c221100b003a3214988e1mr716886wml.8.1659473147217; Tue, 02 Aug
 2022 13:45:47 -0700 (PDT)
MIME-Version: 1.0
References: <d5568318-39ea-0c39-c765-852411409b68@kernel.dk>
In-Reply-To: <d5568318-39ea-0c39-c765-852411409b68@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 2 Aug 2022 13:45:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjh91hcEix55tH7ydTLHbcg3hZ6SaqgeyVscbYz57crfQ@mail.gmail.com>
Message-ID: <CAHk-=wjh91hcEix55tH7ydTLHbcg3hZ6SaqgeyVscbYz57crfQ@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring support for zerocopy send
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Jul 31, 2022 at 8:03 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On top of the core io_uring changes, this pull request adds support for
> efficient support for zerocopy sends through io_uring. Both ipv4 and
> ipv6 is supported, as well as both TCP and UDP.

I've pulled this, but I would *really* have wanted to see real
performance numbers from real loads.

Zero-copy networking has decades of history (and very much not just in
Linux) of absolutely _wonderful_ benchmark numbers, but less-than
impressive take-up on real loads.

A lot of the wonderful benchmark numbers are based on loads that
carefully don't touch the data on either the sender or receiver side,
and that get perfect behavior from a performance standpoint as a
result, but don't actually do anything remotely realistic in the
process.

Having data that never resides in the CPU caches, or having mappings
that are never written to and thus never take page faults are classic
examples of "look, benchmark numbers!".

Please?

           Linus
