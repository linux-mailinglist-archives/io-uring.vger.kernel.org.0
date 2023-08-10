Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19767772D9
	for <lists+io-uring@lfdr.de>; Thu, 10 Aug 2023 10:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjHJI0l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Aug 2023 04:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbjHJI0k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Aug 2023 04:26:40 -0400
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA93E56;
        Thu, 10 Aug 2023 01:26:39 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-9936b3d0286so100551466b.0;
        Thu, 10 Aug 2023 01:26:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691655998; x=1692260798;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U8rApuESa0pdY0AmwOH319MzG7nEB2DXH9x9ay8kvn0=;
        b=gBsowc9TUzW0DfzcTEX9VY4XVPunlWnRC9z0+2wedToyJBzOwR5ZsjhJu79eL9gqjK
         78X3rymT74ATMqsxyV3Xq0zVESLBtu1kPF1alftFugYAQgxWwc61vAREJkWjzGkahm6Z
         UnVM/DmHmWZeQlwJjxbCUcpPBX9/gSiYoqp8gKTEVfAwx9DEF86imfeAQorGo2AeZ8Rw
         1L1QkN4JpJbSoUEWOb+U3arkfTSVI6ISpBJk/I8WVpk//lHCfXbJi73JnDZYTIgyJFst
         tdi58WTHNkmfYSkfMAyh/Ob4fVTtJ3kWKAgh0beiU3UCsbQHh0qLel8MddDXonsjFNQi
         FozQ==
X-Gm-Message-State: AOJu0Ywu5uo/lBgjvfnvNCeb0EzmpomeGa4FYJyvoAEZOQTjfjCbtn3Z
        UZmGkkaL+oLZLoBCVTieRLI=
X-Google-Smtp-Source: AGHT+IFx4EFqf13z8URjVO5WQq9zhgRcOP4Nw82UvtV0Z8zilOx3N6RkaSnLYXCygnYj8r2Qf2LCSg==
X-Received: by 2002:a17:906:1da1:b0:98d:f062:8503 with SMTP id u1-20020a1709061da100b0098df0628503mr1360609ejh.77.1691655997855;
        Thu, 10 Aug 2023 01:26:37 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-020.fbsv.net. [2a03:2880:31ff:14::face:b00c])
        by smtp.gmail.com with ESMTPSA id a13-20020a17090682cd00b00992f81122e1sm597355ejy.21.2023.08.10.01.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 01:26:37 -0700 (PDT)
Date:   Thu, 10 Aug 2023 01:26:35 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v2 7/8] io_uring/cmd: BPF hook for getsockopt cmd
Message-ID: <ZNSfO2aaX5TsKKqz@gmail.com>
References: <20230808134049.1407498-1-leitao@debian.org>
 <20230808134049.1407498-8-leitao@debian.org>
 <87wmy46u58.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wmy46u58.fsf@suse.de>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FSL_HELO_FAKE,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Gabriel,

On Wed, Aug 09, 2023 at 12:46:27PM -0400, Gabriel Krisman Bertazi wrote:
> Breno Leitao <leitao@debian.org> writes:
> 
> > Add BPF hooks support for getsockopts io_uring command. So, bpf cgroups
> > programs can run when SOCKET_URING_OP_GETSOCKOPT command is called.
> >
> > This implementation follows a similar approach to what
> > __sys_getsockopt() does, but, using USER_SOCKPTR() for optval instead of
> > kernel pointer.
> >
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> >  io_uring/uring_cmd.c | 18 +++++++++++++-----
> >  1 file changed, 13 insertions(+), 5 deletions(-)
> >
> > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > index dbba005a7290..3693e5779229 100644
> > --- a/io_uring/uring_cmd.c
> > +++ b/io_uring/uring_cmd.c
> > @@ -5,6 +5,8 @@
> >  #include <linux/io_uring.h>
> >  #include <linux/security.h>
> >  #include <linux/nospec.h>
> > +#include <linux/compat.h>
> > +#include <linux/bpf-cgroup.h>
> >  
> >  #include <uapi/linux/io_uring.h>
> >  #include <uapi/asm-generic/ioctls.h>
> > @@ -179,17 +181,23 @@ static inline int io_uring_cmd_getsockopt(struct socket *sock,
> >  	if (err)
> >  		return err;
> >  
> > -	if (level == SOL_SOCKET) {
> > +	err = -EOPNOTSUPP;
> > +	if (level == SOL_SOCKET)
> >  		err = sk_getsockopt(sock->sk, level, optname,
> >  				    USER_SOCKPTR(optval),
> >  				    KERNEL_SOCKPTR(&optlen));
> > -		if (err)
> > -			return err;
> >  
> > +	if (!in_compat_syscall())
> > +		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level,
> > +						     optname,
> > +						     USER_SOCKPTR(optval),
> > +						     KERNEL_SOCKPTR(&optlen),
> > +						     optlen, err);
> 
> I'm not sure if it makes sense to use in_compat_syscall() here.  Can't
> this be invoked in a ring with ctx->compat set, but from outside a
> compat syscall context (i.e. from sqpoll or even a !compat
> io_uring_enter syscall)? I suspect you might need to check ctx->compact
> instead, but I'm not sure. Did you consider that?

I think that checking ctx->compat seems to be the right thing to do. I
will update.
