Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F968693320
	for <lists+io-uring@lfdr.de>; Sat, 11 Feb 2023 19:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjBKS5a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Feb 2023 13:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjBKS53 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Feb 2023 13:57:29 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A222199E1
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 10:57:28 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id gr7so23138771ejb.5
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 10:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3PcKjkZEscdfAV5ya0phdN14wwNaXoRb40kNT9Dczeo=;
        b=YHVu5kUXNJwub6fL2bFRhFub6fqpPJshyUtgnUVxZxBIopwouTR/KgSkKN4JSR5uve
         Wkfn8LbbiLtb+QLkrXegG9Ji77YU2cy+xueHjxfB9bGAjhzAGT4k9x0ToEiwbgOMILfW
         LyuiuxNGORWZQC9nxgiaZUsmJDUDBv4eCG8b8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3PcKjkZEscdfAV5ya0phdN14wwNaXoRb40kNT9Dczeo=;
        b=TsJeX/ejSN/Zgbp1McHRy+HrXNScB7gDvb0Q/rC9hQKn6IOFTb3ZN5dZJ6bzePjCsv
         RsCMx3QRSlg48WCQT3p3b7Pjn8vUu6a1rR78AGG9h/2Kl1rDFAz9jql0l2JIjmVwG/+c
         4cR6tAYHkSd8CRXs49h2DYSe7WCMHl028kCRWx9sVwfOKrlSq5MeJGkGt+GvohHmT557
         ZrJ0vYbB+v4U/AJN/ju1wnmu9K2wTETXrJkCO040ufZO+5CQDf+7197RkpC0dGyVWnqb
         x9LrFwZyWZsl+hi3mg41WnCItDluLVSygVDWlZUo0gyc6WDD59m93zhTIHkFJNozW0wN
         E/Bw==
X-Gm-Message-State: AO0yUKXDc3SzS+Ke3Ku8/MF5sH54ixyerpNIYmmLGnn73OUZVkVMFfSr
        2bSi7shydyVgNSVnkRObK1Ae7LTgHGUrwqofxhQ=
X-Google-Smtp-Source: AK7set+CI9acTTwtWXy9/I+gMyn/5DwMHXL2nvE4uKEfenod4AlxKQldUopBQewP0DKHl3YLRpYEow==
X-Received: by 2002:a17:906:33cf:b0:884:930:b014 with SMTP id w15-20020a17090633cf00b008840930b014mr18517725eja.6.1676141846015;
        Sat, 11 Feb 2023 10:57:26 -0800 (PST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id lu19-20020a170906fad300b007a9c3831409sm4151395ejb.137.2023.02.11.10.57.24
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Feb 2023 10:57:25 -0800 (PST)
Received: by mail-ed1-f46.google.com with SMTP id r3so8111638edq.13
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 10:57:24 -0800 (PST)
X-Received: by 2002:a50:c353:0:b0:4ac:b616:4ba9 with SMTP id
 q19-20020a50c353000000b004acb6164ba9mr1152399edb.5.1676141844693; Sat, 11 Feb
 2023 10:57:24 -0800 (PST)
MIME-Version: 1.0
References: <20230210153212.733006-1-ming.lei@redhat.com> <20230210153212.733006-2-ming.lei@redhat.com>
 <Y+e3b+Myg/30hlYk@T590>
In-Reply-To: <Y+e3b+Myg/30hlYk@T590>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 11 Feb 2023 10:57:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgTzLjvhzx-XGkgEQmXH6t=8OTFdQyhDgafGdC2n5gOfg@mail.gmail.com>
Message-ID: <CAHk-=wgTzLjvhzx-XGkgEQmXH6t=8OTFdQyhDgafGdC2n5gOfg@mail.gmail.com>
Subject: Re: [PATCH 1/4] fs/splice: enhance direct pipe & splice for moving
 pages in kernel
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
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

On Sat, Feb 11, 2023 at 7:42 AM Ming Lei <ming.lei@redhat.com> wrote:
>
> +/*
> + * Used by source/sink end only, don't touch them in generic
> + * splice/pipe code. Set in source side, and check in sink
> + * side
> + */
> +#define PIPE_BUF_PRIV_FLAG_MAY_READ    0x1000 /* sink can read from page */
> +#define PIPE_BUF_PRIV_FLAG_MAY_WRITE   0x2000 /* sink can write to page */
> +

So this sounds much more sane and understandable, but I have two worries:

 (a) what's the point of MAY_READ? A non-readable page sounds insane
and wrong. All sinks expect to be able to read.

 (b) what about 'tee()' which duplicates a pipe buffer that has
MAY_WRITE? Particularly one that may already have been *partially*
given to something that thinks it can write to it?

So at a minimum I think the tee code then needs to clear that flag.
And I think MAY_READ is nonsense.

          Linus
