Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B999692895
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 21:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbjBJUp3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 15:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbjBJUpZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 15:45:25 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E087BFE5
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 12:45:17 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id dr8so18838066ejc.12
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 12:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3ouszKA6QqICt+YxGce9SY3oz4SsHUe9oFN+JOLlH88=;
        b=BtUoz55elLFqQDfXVT2fRepfHO1VRasY7bNzTcVJa3+3O5Djx3ghbK7G70ibZuu5vN
         3dc49Cy8mFHNkJ1Vv/oF3CA3dF13tG/Y81zRPTekzdHD6j5UHk4GfmpJ70LOUcP2NqZ2
         LylcoEZit07hjr9sxmipoBqLVL7wknoCGK6LE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3ouszKA6QqICt+YxGce9SY3oz4SsHUe9oFN+JOLlH88=;
        b=vW6WpqBB76vtFVF/PEs1z/LQPPWarW2Oeteq7A0WMCftZOYNxSWMQWn/AQUFq0LGvA
         QgwcB7/xUl3EuG4YsY0GgC4l/57A0RRVse0jCRy/3DKLJEDMtjCCi5W6jgv1dahZ4msn
         0OevLtSkWfritSjmz5K2Y2vyb2M9VHZCmnKwKNpgn2XTgZWONMrN0tazeiItV7MwaExB
         lJWyJKCz62d5Hfga8YqHDE6stGrxvWIby4WdQDB0aBzXGiiaJINHyKS+M1SsxcKa8J99
         0zrPWO1L4esAfRarqTig2ki9iZRptjqFBa4tLyVbNIASRR+JIo5jLNixj5Z8BGvRS2bK
         ATZA==
X-Gm-Message-State: AO0yUKXt0jJRgNJJ/tUogoAedpSaj1q+JVSM0D/oqmkI232uHfkwR7qe
        fJONgE0giJn0Jai6+Kohg6foqxLYy/HIDn5oGwg=
X-Google-Smtp-Source: AK7set94w8RwnifTrZ6m5dQFjqET+KPhkbuoVLExOu0bUXOSEQ4l6vo3N8TDOdOvUQjYS7RLxZq4hA==
X-Received: by 2002:a17:907:2104:b0:88d:697d:a3d2 with SMTP id qn4-20020a170907210400b0088d697da3d2mr15835132ejb.54.1676061915782;
        Fri, 10 Feb 2023 12:45:15 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id y22-20020a170906449600b0084d35ffbc20sm2850392ejo.68.2023.02.10.12.45.14
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 12:45:14 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id fj20so5881681edb.1
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 12:45:14 -0800 (PST)
X-Received: by 2002:a50:f603:0:b0:49d:ec5e:1e98 with SMTP id
 c3-20020a50f603000000b0049dec5e1e98mr3298664edn.5.1676061913926; Fri, 10 Feb
 2023 12:45:13 -0800 (PST)
MIME-Version: 1.0
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
 <20230210021603.GA2825702@dread.disaster.area> <20230210040626.GB2825702@dread.disaster.area>
 <Y+XLuYh+kC+4wTRi@casper.infradead.org> <20230210065747.GD2825702@dread.disaster.area>
 <CALCETrWjJisipSJA7tPu+h6B2gs3m+g0yPhZ4z+Atod+WOMkZg@mail.gmail.com>
 <CAHk-=wj66F6CdJUAAjqigXMBy7gHquFMzPNAwKCgkrb2mF6U7w@mail.gmail.com>
 <CALCETrU-9Wcb_zCsVWr24V=uCA0+c6x359UkJBOBgkbq+UHAMA@mail.gmail.com>
 <CAHk-=wjQZWMeQ9OgXDNepf+TLijqj0Lm0dXWwWzDcbz6o7yy_g@mail.gmail.com>
 <CALCETrWuRHWh5XFn8M8qx5z0FXAGHH=ysb+c6J+cqbYyTAHvhw@mail.gmail.com>
 <CAHk-=wjuXvF1cA=gJod=-6k4ypbEmOczFFDKriUpOVKy9dTJWQ@mail.gmail.com>
 <CALCETrUXYts5BRZKb25MVaWPk2mz34fKSqCR++SM382kSYLnJw@mail.gmail.com>
 <CAHk-=wgA=rB=7M_Fe3n9UkoW_7dqdUT2D=yb94=6GiGXEuAHDA@mail.gmail.com>
 <1dd85095-c18c-ed3e-38b7-02f4d13d9bd6@kernel.dk> <CAHk-=wiszt6btMPeT5UFcS=0=EVr=0injTR75KsvN8WetwQwkA@mail.gmail.com>
 <fe8252bd-17bd-850d-dcd0-d799443681e9@kernel.dk>
In-Reply-To: <fe8252bd-17bd-850d-dcd0-d799443681e9@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Feb 2023 12:44:56 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiJ0QKKiORkVr8n345sPp=aHbrLTLu6CQ-S0XqWJ-kJ1A@mail.gmail.com>
Message-ID: <CAHk-=wiJ0QKKiORkVr8n345sPp=aHbrLTLu6CQ-S0XqWJ-kJ1A@mail.gmail.com>
Subject: Re: copy on write for splice() from file to pipe?
To:     Jens Axboe <axboe@kernel.dk>
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

On Fri, Feb 10, 2023 at 12:39 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> Right, I'm referencing doing zerocopy data sends with io_uring, using
> IORING_OP_SEND_ZC. This isn't from a file, it's from a memory location,
> but the important bit here is the split notifications and how you
> could wire up a OP_SENDFILE similarly to what Andy described.

Sure, I think it's much more reasonable with io_uring than with splice itself.

So I was mainly just reacting to the "strict-splice" thing where Andy
was talking about tracking the page refcounts. I don't think anything
like that can be done at a splice() level, but higher levels that
actually know about the whole IO might be able to do something like
that.

Maybe we're just talking past each other.

             Linus
