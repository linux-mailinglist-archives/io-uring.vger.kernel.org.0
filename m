Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4B1692655
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 20:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbjBJT3x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 14:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbjBJT3w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 14:29:52 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28727D899
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 11:29:51 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id qw12so18574165ejc.2
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 11:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r61/0h5NTTq+Qoz9OXQLKuxfQJmXqVpaixbdP55tAzc=;
        b=IAdLRQRIm/NXW+WeR+UYR2ZTsvGw0tN2PBRMeoFQUWHyntbQJr49WmKYDyvef9iYCp
         lUUb1ydt4R7bdgKIQp1NsqwNFy5yaD5bZK5PWeSLfJdZfj2Cqzk/kag9hbbtNtbhJf4N
         zm6LxZ2ObZ/VLq+NbgF57dtNvJBp8k5O0X+1A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r61/0h5NTTq+Qoz9OXQLKuxfQJmXqVpaixbdP55tAzc=;
        b=LSjh878r2GGa33JRzrud20pw9JvpWGVjOI50Wft1pyWxVbkywzLywYr2FEyFCjCLMM
         xXMTKvMTsyrL/hPUz2MGidt06iAUf2RCVJHGSPyIGF+/MI8ODVJRiy4OuGQj5RNNIGQa
         ptt7ASZaWAoi8lsfSuaoe1tZwEtmuGVB1B/WOoZ61YlC3kv++98Op/v+TXxloCN20X8C
         jPJTNkOq/mtViA6LpPnxa8TIUYfM3Jb2GDTWD5oKv0CCR5Ktwm0syvTv3UXQMXxH1LtT
         oVwL+zYI4SuV2daLe0RL9KLpd5e12/Yt3HEQsKBP8zeKkuH6ziT7lHRhTcYXnPkR3D3P
         G6fQ==
X-Gm-Message-State: AO0yUKVCm0jnAAYWYxQIiY/XD6YR1y7c7a473jQaurofXKI9zZYqNKEK
        cm+rH5rSGLtLokbVHk2uCCJ0lvak6FeWmubsaG8=
X-Google-Smtp-Source: AK7set+yDhWiQqRK8KRLe+5D3GFc3KY5FwBPk/4fGn/I7HyVWb41Eu0ja6N1yXA5dxNO2Ekb9ND3Nw==
X-Received: by 2002:a17:906:179b:b0:87b:3d29:2990 with SMTP id t27-20020a170906179b00b0087b3d292990mr16322629eje.9.1676057389775;
        Fri, 10 Feb 2023 11:29:49 -0800 (PST)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id u8-20020a1709060b0800b0088550a1ce6esm2755947ejg.222.2023.02.10.11.29.48
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 11:29:49 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id q19so5638416edd.2
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 11:29:48 -0800 (PST)
X-Received: by 2002:a50:aad4:0:b0:4ab:4d34:9762 with SMTP id
 r20-20020a50aad4000000b004ab4d349762mr582230edc.5.1676057388706; Fri, 10 Feb
 2023 11:29:48 -0800 (PST)
MIME-Version: 1.0
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
 <20230210021603.GA2825702@dread.disaster.area> <20230210040626.GB2825702@dread.disaster.area>
 <Y+XLuYh+kC+4wTRi@casper.infradead.org> <20230210065747.GD2825702@dread.disaster.area>
 <CALCETrWjJisipSJA7tPu+h6B2gs3m+g0yPhZ4z+Atod+WOMkZg@mail.gmail.com>
 <CAHk-=wj66F6CdJUAAjqigXMBy7gHquFMzPNAwKCgkrb2mF6U7w@mail.gmail.com>
 <CALCETrU-9Wcb_zCsVWr24V=uCA0+c6x359UkJBOBgkbq+UHAMA@mail.gmail.com>
 <CAHk-=wjQZWMeQ9OgXDNepf+TLijqj0Lm0dXWwWzDcbz6o7yy_g@mail.gmail.com>
 <CALCETrWuRHWh5XFn8M8qx5z0FXAGHH=ysb+c6J+cqbYyTAHvhw@mail.gmail.com> <CAHk-=wjuXvF1cA=gJod=-6k4ypbEmOczFFDKriUpOVKy9dTJWQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjuXvF1cA=gJod=-6k4ypbEmOczFFDKriUpOVKy9dTJWQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Feb 2023 11:29:31 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg2Mb4ZgRuBthw6O0KLhZNksGBQNs73386Gdg4gHny=XA@mail.gmail.com>
Message-ID: <CAHk-=wg2Mb4ZgRuBthw6O0KLhZNksGBQNs73386Gdg4gHny=XA@mail.gmail.com>
Subject: Re: copy on write for splice() from file to pipe?
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jens Axboe <axboe@kernel.dk>,
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

On Fri, Feb 10, 2023 at 11:18 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>  - and finally, I do think it might make sense for the networking
> people to look at how the networking side works with 'sendpage()'.

Put another way: I do not believe that it is at all fundamental that
you can't send data from an changing source over the network. That's
likely _particularly_ true of the people who care the most, and who
already have network cards that do a lot of the heavy lifting for you.

So why spend a lot of effort to stabilize the data, if it's not
needed, when the primary users of it would likely not want that
performance hit and extra work in the first place?

Then making that "strict mode" be the only mode going forward and just
disallowing people from doing the simple thing sounds particularly
wrong.

For example, it may *literally* be that the IPV4 TCP case could be
fixed with something trivial like this

  --- a/net/ipv4/tcp.c
  +++ b/net/ipv4/tcp.c
  @@ -1134,7 +1134,8 @@ EXPORT_SYMBOL_GPL(do_tcp_sendpages);
   int tcp_sendpage_locked(struct sock *sk, struct page *page, int offset,
                        size_t size, int flags)
   {
  -     if (!(sk->sk_route_caps & NETIF_F_SG))
  +     if (!(sk->sk_route_caps & NETIF_F_SG) ||
  +         !(sk->sk_route_caps & (NETIF_F_HW_CSUM | NETIF_F_IP_CSUM)))
                return sock_no_sendpage_locked(sk, page, offset, size, flags);

        tcp_rate_check_app_limited(sk);  /* is sending application-limited? */

which would basically make hardware that can't deal with the data
changing under it just fall back to the "safe and slow" model on its
own.

But then hardware that doesn't care would "just work".

See what I'm saying? The above patch may be garbage because I don't
understand the network driver rules fully, so don't take the above as
some kind of "last word" on this AT ALL. But I'm just saying that
requiring stable sources doesn't necessarily make any sense at all.

              Linus
