Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A077859B3
	for <lists+io-uring@lfdr.de>; Wed, 23 Aug 2023 15:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbjHWNtJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Aug 2023 09:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjHWNtI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Aug 2023 09:49:08 -0400
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EB519A;
        Wed, 23 Aug 2023 06:49:03 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-523b066d7ceso6980283a12.2;
        Wed, 23 Aug 2023 06:49:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692798542; x=1693403342;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8HVeMF2i6Eu6fNCP7qdp68KyRQC3Cd1eZ1vG5fM2PLY=;
        b=Pebi1r6Wjo1oGUHsZ+sUedx/YCVC2nX3BDach1wOr1Nw/L220u2Bjuu60XPSQ5uAHE
         lAiJReqfwztBwHhrcL9s2yufeNq4AxpbQzg6ZVwK25zOvNqV5huFiVwgbPe5kdrn2XHh
         bWJF2f31RV2b4+LCFaxfMcchMXdA79uG3K2tUqMGS94VHF/MXYP4V2l61W+eh2cfjuDv
         8cH0zGQ+Wq11euee3i8dZjMH/AykK1ysTZXtPXgWK+M3njS0mbAziWYAfvPGOFBZRQRa
         0tG6wQBXJ2ouERGlzNuuU3kEfeRhCdVysBZEsYWlwU34bjkYoxrbEH/fMi9wFmMiYYFB
         YasQ==
X-Gm-Message-State: AOJu0YxytPYgK5En0HFYaTGWJdpiSTwwU3qGsYcddkXimxBkKJu0Mbw2
        dcpneAWU/Sj03jlojKD250A=
X-Google-Smtp-Source: AGHT+IGpOg7sJlI/rEq2t0qmOj+PEzxbPvOFJibDR6ujnw/tubbxpv33784EHtRDeE4uTjaM2562xg==
X-Received: by 2002:a05:6402:1657:b0:529:fa63:ef80 with SMTP id s23-20020a056402165700b00529fa63ef80mr8682360edx.28.1692798541666;
        Wed, 23 Aug 2023 06:49:01 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-000.fbsv.net. [2a03:2880:31ff::face:b00c])
        by smtp.gmail.com with ESMTPSA id y2-20020aa7d502000000b00529fb5fd3b9sm7565236edq.80.2023.08.23.06.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Aug 2023 06:49:01 -0700 (PDT)
Date:   Wed, 23 Aug 2023 06:48:59 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH v3 8/9] io_uring/cmd: BPF hook for getsockopt cmd
Message-ID: <ZOYOS87mCmcYurkR@gmail.com>
References: <20230817145554.892543-1-leitao@debian.org>
 <20230817145554.892543-9-leitao@debian.org>
 <87pm3l32rk.fsf@suse.de>
 <ZOMrD1DHeys0nFwt@gmail.com>
 <875y58nx9v.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875y58nx9v.fsf@suse.de>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 21, 2023 at 01:03:08PM -0400, Gabriel Krisman Bertazi wrote:
> Breno Leitao <leitao@debian.org> writes:
> 
> > On Thu, Aug 17, 2023 at 03:08:47PM -0400, Gabriel Krisman Bertazi wrote:
> >> Breno Leitao <leitao@debian.org> writes:
> >> 
> >> > Add BPF hook support for getsockopts io_uring command. So, BPF cgroups
> >> > programs can run when SOCKET_URING_OP_GETSOCKOPT command is executed
> >> > through io_uring.
> >> >
> >> > This implementation follows a similar approach to what
> >> > __sys_getsockopt() does, but, using USER_SOCKPTR() for optval instead of
> >> > kernel pointer.
> >> >
> >> > Signed-off-by: Breno Leitao <leitao@debian.org>
> >> > ---
> >> >  io_uring/uring_cmd.c | 18 +++++++++++++-----
> >> >  1 file changed, 13 insertions(+), 5 deletions(-)
> >> >
> >> > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> >> > index a567dd32df00..9e08a14760c3 100644
> >> > --- a/io_uring/uring_cmd.c
> >> > +++ b/io_uring/uring_cmd.c
> >> > @@ -5,6 +5,8 @@
> >> >  #include <linux/io_uring.h>
> >> >  #include <linux/security.h>
> >> >  #include <linux/nospec.h>
> >> > +#include <linux/compat.h>
> >> > +#include <linux/bpf-cgroup.h>
> >> >  
> >> >  #include <uapi/linux/io_uring.h>
> >> >  #include <uapi/asm-generic/ioctls.h>
> >> > @@ -184,17 +186,23 @@ static inline int io_uring_cmd_getsockopt(struct socket *sock,
> >> >  	if (err)
> >> >  		return err;
> >> >  
> >> > -	if (level == SOL_SOCKET) {
> >> > +	err = -EOPNOTSUPP;
> >> > +	if (level == SOL_SOCKET)
> >> >  		err = sk_getsockopt(sock->sk, level, optname,
> >> >  				    USER_SOCKPTR(optval),
> >> >  				    KERNEL_SOCKPTR(&optlen));
> >> > -		if (err)
> >> > -			return err;
> >> >  
> >> > +	if (!(issue_flags & IO_URING_F_COMPAT))
> >> > +		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level,
> >> > +						     optname,
> >> > +						     USER_SOCKPTR(optval),
> >> > +						     KERNEL_SOCKPTR(&optlen),
> >> > +						     optlen, err);
> >> > +
> >> > +	if (!err)
> >> >  		return optlen;
> >> > -	}
> >> 
> >> Shouldn't you call sock->ops->getsockopt for level!=SOL_SOCKET prior to
> >> running the hook?
> >> Before this patch, it would bail out with EOPNOTSUPP,
> >> but now the bpf hook gets called even for level!=SOL_SOCKET, which
> >> doesn't fit __sys_getsockopt. Am I misreading the code?
> >
> > Not really, sock->ops->getsockopt() does not suport sockptr_t, but
> > __user addresses, differently from setsockopt()
> >
> >           int             (*setsockopt)(struct socket *sock, int level,
> >                                         int optname, sockptr_t optval,
> >                                         unsigned int optlen);
> >           int             (*getsockopt)(struct socket *sock, int level,
> >                                         int optname, char __user *optval, int __user *optlen);
> >
> > In order to be able to call sock->ops->getsockopt(), the callback
> > function will need to accepted sockptr.
> 
> So, it seems you won't support !SOL_SOCKETs here.  Then, I think you
> shouldn't call the hook for those sockets. My main concern is that we
> remain compatible to __sys_getsockopt when invoking the hook.
> 
> I think you should just have the following as the very first thing in
> the function (but after the security_ check).
> 
> if (level != SOL_SOCKET)
>    return -EOPNOTSUPP;

Gotcha. I will update. Thanks!
