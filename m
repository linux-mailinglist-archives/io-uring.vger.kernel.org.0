Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852216929D7
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 23:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbjBJWI7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 17:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbjBJWI5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 17:08:57 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FF36C7C8
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:08:56 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id p26so19265109ejx.13
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=abSFB59ri4FOl7mUi8eUgUBhSEYjEYSp3hrpjZkmJ0U=;
        b=NcU1uFZdoJAjGPI44x/T/oJNFFkClW4PcLYk/vV5Feaov42tAJqpKYVo9/YlqDXw24
         MP1ObyJcJdHSRWORQxht+uP0G/aT/dcYZ9VhAyTSNq5BQ9jK4YMDeinqtABv+BxW+AIh
         cxBZ6zXZfc4dJfwH59qtqzuo+YrVtdjQpLas8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=abSFB59ri4FOl7mUi8eUgUBhSEYjEYSp3hrpjZkmJ0U=;
        b=zNTNRi9xUD/5/pGECUxlEH0DhIRWcgjxAYWH7IoIdnQerMl9zOpLJhfj7uQLbikfpS
         fQcFQ0ehARqYKwuoR3afaWIn7zsqUVKFNW2sJRV4dIf1SYeC8XWrqllsbqB6homJKgrU
         lrwg+KKlQN7DErURiKR3wbMdHPJucbKeUXxDDlNojyV3n0v0AvJuoM86kDTU+X62Zqsh
         RgD+4w28Wttwu6hfj+bfLtyQhENm6ITJIIOZldu/f/rT+xIMdLFo655AGMzefpudtOBo
         VtzABCEKEB7Zq1kfOBQylPQIXrpYJh8oJ8eEpIyFcFzKTLabFXBKBjllwjw0yafQbZ6S
         GT6Q==
X-Gm-Message-State: AO0yUKWJNqPYHEw6Jm+v0/1cqv8VIEzzyaK3fMuCq4ebJ+qFShrcCMoZ
        wxBrdqW8tkngQ6RuSKHy20vrPHhxeGGZXXZfVFs=
X-Google-Smtp-Source: AK7set+i5MiUQQrsLlb9zHXyYJh5r6F0XOM6/EPC6XrrOAxcUbohKux+1uEqHMI5pN9J0M0n3Za4Kg==
X-Received: by 2002:a17:907:3f91:b0:8ae:bb1d:45e4 with SMTP id hr17-20020a1709073f9100b008aebb1d45e4mr11821431ejc.26.1676066934412;
        Fri, 10 Feb 2023 14:08:54 -0800 (PST)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id f6-20020a1709067f8600b0088f92a2639fsm2966855ejr.17.2023.02.10.14.08.52
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 14:08:53 -0800 (PST)
Received: by mail-ed1-f52.google.com with SMTP id r3so5996993edq.13
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:08:52 -0800 (PST)
X-Received: by 2002:a50:c353:0:b0:4ac:b616:4ba9 with SMTP id
 q19-20020a50c353000000b004acb6164ba9mr189716edb.5.1676066932381; Fri, 10 Feb
 2023 14:08:52 -0800 (PST)
MIME-Version: 1.0
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj66F6CdJUAAjqigXMBy7gHquFMzPNAwKCgkrb2mF6U7w@mail.gmail.com>
 <CALCETrU-9Wcb_zCsVWr24V=uCA0+c6x359UkJBOBgkbq+UHAMA@mail.gmail.com>
 <CAHk-=wjQZWMeQ9OgXDNepf+TLijqj0Lm0dXWwWzDcbz6o7yy_g@mail.gmail.com>
 <CALCETrWuRHWh5XFn8M8qx5z0FXAGHH=ysb+c6J+cqbYyTAHvhw@mail.gmail.com>
 <CAHk-=wjuXvF1cA=gJod=-6k4ypbEmOczFFDKriUpOVKy9dTJWQ@mail.gmail.com>
 <CALCETrUXYts5BRZKb25MVaWPk2mz34fKSqCR++SM382kSYLnJw@mail.gmail.com>
 <CAHk-=wgA=rB=7M_Fe3n9UkoW_7dqdUT2D=yb94=6GiGXEuAHDA@mail.gmail.com>
 <1dd85095-c18c-ed3e-38b7-02f4d13d9bd6@kernel.dk> <CAHk-=wiszt6btMPeT5UFcS=0=EVr=0injTR75KsvN8WetwQwkA@mail.gmail.com>
 <fe8252bd-17bd-850d-dcd0-d799443681e9@kernel.dk> <CAHk-=wiJ0QKKiORkVr8n345sPp=aHbrLTLu6CQ-S0XqWJ-kJ1A@mail.gmail.com>
 <7a2e5b7f-c213-09ff-ef35-d6c2967b31a7@kernel.dk> <CALCETrVx4cj7KrhaevtFN19rf=A6kauFTr7UPzQVage0MsBLrg@mail.gmail.com>
 <b44783e6-3da2-85dd-a482-5d9aeb018e9c@kernel.dk> <2bb12591-9d24-6b26-178f-05e939bf3251@kernel.dk>
In-Reply-To: <2bb12591-9d24-6b26-178f-05e939bf3251@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Feb 2023 14:08:35 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjzqrD5wrfeaU390bXEEBY2JF-oKmFN4fREzgyXsbQRTQ@mail.gmail.com>
Message-ID: <CAHk-=wjzqrD5wrfeaU390bXEEBY2JF-oKmFN4fREzgyXsbQRTQ@mail.gmail.com>
Subject: Re: copy on write for splice() from file to pipe?
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
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

On Fri, Feb 10, 2023 at 1:51 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> Speaking of splice/io_uring, Ming posted this today:
>
> https://lore.kernel.org/io-uring/20230210153212.733006-1-ming.lei@redhat.com/

Ugh. Some of that is really ugly. Both 'ignore_sig' and
'ack_page_consuming' just look wrong. Pure random special cases.

And that 'ignore_sig' is particularly ugly, since the only thing that
sets it also sets SPLICE_F_NONBLOCK.

And the *only* thing that actually then checks that field is
'splice_from_pipe_next()', where there are exactly two
signal_pending() checks that it adds to, and

 (a) the first one is to protect from endless loops

 (b) the second one is irrelevant when  SPLICE_F_NONBLOCK is set

So honestly, just NAK on that series.

I think that instead of 'ignore_sig' (which shouldn't exist), that
first 'signal_pending()' check in splice_from_pipe_next() should just
be changed into a 'fatal_signal_pending()'.

But that 'ack_page_consuming' thing looks even more disgusting, and
since I'm not sure why it even exists, I don't know what it's doing
wrong.

Let's agree not to make splice() worse, while people are talking about
how bad it already is, ok?

                Linus
