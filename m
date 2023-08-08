Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6867774419
	for <lists+io-uring@lfdr.de>; Tue,  8 Aug 2023 20:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbjHHSPO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Aug 2023 14:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235396AbjHHSOs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Aug 2023 14:14:48 -0400
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9A67729E;
        Tue,  8 Aug 2023 10:21:07 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-99c1d03e124so777002566b.2;
        Tue, 08 Aug 2023 10:21:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691515266; x=1692120066;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A3ZAh9r49fKwc1AKqTyWDxZoXY6qm0Fmdzt3lhk9VUs=;
        b=WR02V/T0UcnR5nLx2KNXnzhQEHmwbWN3zeepqTvW75xZnu3QDS2Igyku0LSLGOPiLY
         3/qdX+Ow07LVAPPCKKnutMHsrB7vKCdD10Grl9sXdUTmSPk0fXAsldmANZYdlwF7EYMH
         MO8djPXGMh//WrDgHVDxmqrmkDWVMQqatX/FUVnjoscbrQ32fdwg44uJTbJgDAHrws0M
         KX75zAG3tdW47N6yhAJbL61Nk+ZLYrpl+TlEHVm09kdxzxtnkIkIAookFNW3Ap8xZz3b
         nKRbtHNtT/FwoykaHMKTRGmo/mT+yUOQYdD1GnxoFxMmLZvWX5flxRrN6I256tfflbMW
         FbVg==
X-Gm-Message-State: AOJu0YyGa+qUyzItcIzltSth0txj711B7JhQv964UvbI3MLteYtO+MXn
        dupcj01Mf4FF4yXEruvAMHk=
X-Google-Smtp-Source: AGHT+IF2A/ocidBieGus/Vr73B1MNz6ycwBafdhHr/A40ZNyd3DmkgVoHbNBnNMPKEdk1otUqxKH3w==
X-Received: by 2002:a17:906:31d4:b0:99c:b46d:22d9 with SMTP id f20-20020a17090631d400b0099cb46d22d9mr205772ejf.48.1691515266017;
        Tue, 08 Aug 2023 10:21:06 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-005.fbsv.net. [2a03:2880:31ff:5::face:b00c])
        by smtp.gmail.com with ESMTPSA id pv10-20020a170907208a00b00977eec7b7e8sm6950262ejb.68.2023.08.08.10.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 10:21:05 -0700 (PDT)
Date:   Tue, 8 Aug 2023 10:21:03 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Hugo Villeneuve <hugo@hugovil.com>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v2 1/8] net: expose sock_use_custom_sol_socket
Message-ID: <ZNJ5f1hR3cre0IPd@gmail.com>
References: <20230808134049.1407498-1-leitao@debian.org>
 <20230808134049.1407498-2-leitao@debian.org>
 <20230808121323.bc144c719eba5979e161aac6@hugovil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808121323.bc144c719eba5979e161aac6@hugovil.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FSL_HELO_FAKE,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello  Hugo,

On Tue, Aug 08, 2023 at 12:13:23PM -0400, Hugo Villeneuve wrote:
> On Tue,  8 Aug 2023 06:40:41 -0700
> Breno Leitao <leitao@debian.org> wrote:
> 
> > Exposing function sock_use_custom_sol_socket(), so it could be used by
> > io_uring subsystem.
> > 
> > This function will be used in the function io_uring_cmd_setsockopt() in
> > the coming patch, so, let's move it to the socket.h header file.
> 
> Hi,
> this description doesn't seem to match the code change below...

I re-read the patch comment and it seems to match what the code does,
so, probably this description only makes sense to me (?).

That said, hat have you understood from reading the description above?

Thanks for the review,

> > ---
> >  include/linux/net.h | 5 +++++
> >  net/socket.c        | 5 -----
> >  2 files changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/net.h b/include/linux/net.h
> > index 41c608c1b02c..14a956e4530e 100644
> > --- a/include/linux/net.h
> > +++ b/include/linux/net.h
> > @@ -355,4 +355,9 @@ u32 kernel_sock_ip_overhead(struct sock *sk);
> >  #define MODULE_ALIAS_NET_PF_PROTO_NAME(pf, proto, name) \
> >  	MODULE_ALIAS("net-pf-" __stringify(pf) "-proto-" __stringify(proto) \
> >  		     name)
> > +
> > +static inline bool sock_use_custom_sol_socket(const struct socket *sock)
> > +{
> > +	return test_bit(SOCK_CUSTOM_SOCKOPT, &sock->flags);
> > +}
> >  #endif	/* _LINUX_NET_H */
> > diff --git a/net/socket.c b/net/socket.c
> > index 1dc23f5298ba..8df54352af83 100644
> > --- a/net/socket.c
> > +++ b/net/socket.c
> > @@ -2216,11 +2216,6 @@ SYSCALL_DEFINE4(recv, int, fd, void __user *, ubuf, size_t, size,
> >  	return __sys_recvfrom(fd, ubuf, size, flags, NULL, NULL);
> >  }
> >  
> > -static bool sock_use_custom_sol_socket(const struct socket *sock)
> > -{
> > -	return test_bit(SOCK_CUSTOM_SOCKOPT, &sock->flags);
> > -}
> > -
> >  /*
> >   *	Set a socket option. Because we don't know the option lengths we have
> >   *	to pass the user mode parameter for the protocols to sort out.
> > -- 
> > 2.34.1
> > 
