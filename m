Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28AA7693323
	for <lists+io-uring@lfdr.de>; Sat, 11 Feb 2023 19:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjBKS6Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Feb 2023 13:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjBKS6P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Feb 2023 13:58:15 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8091199E1
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 10:58:14 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id d40so6924544eda.8
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 10:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v6OIGzvOpvoDs5k8U8ZXPR9Oe0WDhcfEQMGkRVj61LY=;
        b=EIXdLD2NKM3TRG47LtztKC0uokjWh9qOIVDhwX03oat6LH91fz1Bsf/lPs2NP2CG8X
         +DswqOlfYlGGKQggnB9PN5h6tY4I4kXpr4aX5smQFgvIZzwCwCuHFcRbAT4uyAPo4Q6z
         xKh6bsoMHKAriwGucZR6A+JhEX/u34NaffC2c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v6OIGzvOpvoDs5k8U8ZXPR9Oe0WDhcfEQMGkRVj61LY=;
        b=FlIsdQpKWmJirRK7LwGR1+HJ92yOcaiVF1kYwGm0o9a//dJj0wYHm2eDVgRp9h03bY
         0/I2TKYiJRjVPY0KEmN4+pl8GRpqSduvtAMe20w6PyZywumK7nHv0N9KC2lwysTLojdw
         JfshKB4Kw8dYbMI1nV1xCtgjkgC0MTf8lmziNRjyGDnwDSCcushUnKcE3IIVsupwFM6i
         XN7ORjavZstmYxnWnJYFkUwoYYsefy9A82Ar6OEcIjJbCruV6YnxeXoNajVSA8AQNnaO
         tZ/NoQWdS+cRw8u2P06Q9/l91IcuXfhFsz5PCCfOF7T1Re0LxJNV97iSAOnstyczOh+9
         eQOw==
X-Gm-Message-State: AO0yUKU3qM48SOv65PPHbcOsrz8G9Wpo8nlxqepTPyAyQr7Rjh4cQOtn
        AhLlfEdaEU6yvWP+wNUs9525kEMEZcGJlTShqsE=
X-Google-Smtp-Source: AK7set9mW5biiAeq6FNHEL1rxgkhu3vteaN/yfZL+Q4spVA+711jx/KV1w3yM/r9F629HwSetBwfmg==
X-Received: by 2002:a50:f605:0:b0:4ac:beba:dc89 with SMTP id c5-20020a50f605000000b004acbebadc89mr154406edn.38.1676141893151;
        Sat, 11 Feb 2023 10:58:13 -0800 (PST)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id q25-20020a50cc99000000b004a24b8b58cbsm4098022edi.16.2023.02.11.10.58.12
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Feb 2023 10:58:12 -0800 (PST)
Received: by mail-ej1-f45.google.com with SMTP id rp23so23115225ejb.7
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 10:58:12 -0800 (PST)
X-Received: by 2002:a17:906:658:b0:88f:a9ec:dfd7 with SMTP id
 t24-20020a170906065800b0088fa9ecdfd7mr2491955ejb.0.1676141891911; Sat, 11 Feb
 2023 10:58:11 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=wiszt6btMPeT5UFcS=0=EVr=0injTR75KsvN8WetwQwkA@mail.gmail.com>
 <fe8252bd-17bd-850d-dcd0-d799443681e9@kernel.dk> <CAHk-=wiJ0QKKiORkVr8n345sPp=aHbrLTLu6CQ-S0XqWJ-kJ1A@mail.gmail.com>
 <7a2e5b7f-c213-09ff-ef35-d6c2967b31a7@kernel.dk> <CALCETrVx4cj7KrhaevtFN19rf=A6kauFTr7UPzQVage0MsBLrg@mail.gmail.com>
 <b44783e6-3da2-85dd-a482-5d9aeb018e9c@kernel.dk> <2bb12591-9d24-6b26-178f-05e939bf3251@kernel.dk>
 <CAHk-=wjzqrD5wrfeaU390bXEEBY2JF-oKmFN4fREzgyXsbQRTQ@mail.gmail.com>
 <Y+cJDnnMuirSjO3E@T590> <55eaac9e-0d77-1fa2-df27-4d64e123177e@kernel.dk>
 <Y+euv+zR5ltTELqk@T590> <787c3b62-f5d8-694d-cd2f-24b40848e39f@kernel.dk>
In-Reply-To: <787c3b62-f5d8-694d-cd2f-24b40848e39f@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 11 Feb 2023 10:57:54 -0800
X-Gmail-Original-Message-ID: <CAHk-=whQ_V1ZE6jhQKHDk1MKvEkjpF2Pj-OcRQRXBTMsNpA1YA@mail.gmail.com>
Message-ID: <CAHk-=whQ_V1ZE6jhQKHDk1MKvEkjpF2Pj-OcRQRXBTMsNpA1YA@mail.gmail.com>
Subject: Re: copy on write for splice() from file to pipe?
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>
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

On Sat, Feb 11, 2023 at 7:33 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> OK, but then the ignore_sig change should not be needed at all, just
> changing that first bit to fatal_signal_pending() would do the trick?

Right. That was my point. The 'ignore_sig' flag just doesn't make
sense. It was a hack for a case that shouldn't exist.

              Linus
