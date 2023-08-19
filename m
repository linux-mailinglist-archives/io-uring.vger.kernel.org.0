Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E817781A27
	for <lists+io-uring@lfdr.de>; Sat, 19 Aug 2023 16:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbjHSOfl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Aug 2023 10:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjHSOfl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Aug 2023 10:35:41 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2461FD39;
        Sat, 19 Aug 2023 07:35:35 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id af79cd13be357-76d9a79e2fdso40392885a.1;
        Sat, 19 Aug 2023 07:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692455734; x=1693060534;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FuDrenDtPLv9suOFUYr8VZtzBqfanUGuWEDfBaaD+9s=;
        b=KorI84h9e6x/55Ewd65XgG4WaBgoBzHkVmxHXKImA14LLKP9VfaBDNG+SDJe4etsB5
         Ztbz1r4KetxZ8Q4N1J1gYf2gTXXlNVsPLqdG8YywaCrUrQcrtoGIPNcgTN1a7QgKH3Na
         OIv+kxE3ysav/goa23ceSCnMu1f1725ixXDtsqdw44qGEGnJak/GEEDfeScfQhIOBgOI
         86ca9Osxo09eCKYI5qqvxYy5y2raDLB9nXO+ZkQzucILF/ba/No2ntzGvyL/a0YJ5N8m
         4mpDcMdNGh0y9HiOHmKyWxJ/6iBLVaWcGG31+deVga0Y03rDIKFop063O+rr708+J3h5
         dmJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692455734; x=1693060534;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FuDrenDtPLv9suOFUYr8VZtzBqfanUGuWEDfBaaD+9s=;
        b=I0D9PdSPLlb5ud+gUd3I5POwcq39gD+gpuSkil9EFi8w7o25SQAJ89oXtEerKwSGn1
         kpEPHVsmq2A9cx4VVyHdiPywdy/ZR+TdhMen8C2s/C4ZDRyNzn/1u1KKw2152TPDPJ4A
         1knmqvAysLwGYv+AViMI7htpXMUXnTdjeMyQB5TtVSfDzgAmljTdWjjBRvQw9PVQ/WMV
         MD+mhhS8CY54X28SneWwZwWp+h5cNezbwxRO0Ks4DSWYxg9haWqz6Ym8CPq+QHZ/BYJS
         IbBl61Si5sR2XmCpSd3HpfTyXSJUhlWAVtZ41CnNk43DeAdO1BCJKhrEWVtpFyhloBYw
         wn9A==
X-Gm-Message-State: AOJu0Yz2CkYHIZsC/pwf/C/s9pUcG6l9uRe5JovZ4CSLSFpjX5P75h8M
        NB7c3IowbzQtcN3Ir+53j44=
X-Google-Smtp-Source: AGHT+IHUfCRk72PwjeVuBOWBcFXHgymftEe/Hdt5hXm5EXRD1gYwRSCuak1cCc7S+MkscDQB/OWxUg==
X-Received: by 2002:a05:620a:1999:b0:76d:25b5:6e9b with SMTP id bm25-20020a05620a199900b0076d25b56e9bmr2954283qkb.23.1692455734229;
        Sat, 19 Aug 2023 07:35:34 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id g16-20020a05620a109000b0076ceb5eb309sm1210424qkk.74.2023.08.19.07.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Aug 2023 07:35:33 -0700 (PDT)
Date:   Sat, 19 Aug 2023 10:35:33 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Breno Leitao <leitao@debian.org>, sdf@google.com, axboe@kernel.dk,
        asml.silence@gmail.com, willemdebruijn.kernel@gmail.com,
        martin.lau@linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, krisman@suse.de
Message-ID: <64e0d3359f90d_3119e32942c@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230817145554.892543-4-leitao@debian.org>
References: <20230817145554.892543-1-leitao@debian.org>
 <20230817145554.892543-4-leitao@debian.org>
Subject: Re: [PATCH v3 3/9] net/socket: Break down __sys_setsockopt
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Breno Leitao wrote:
> Split __sys_setsockopt() into two functions by removing the core
> logic into a sub-function (do_sock_setsockopt()). This will avoid
> code duplication when doing the same operation in other callers, for
> instance.
> 
> do_sock_setsockopt() will be called by io_uring setsockopt() command
> operation in the following patch.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Willem de Bruijn <willemb@google.com>
> ---
>  include/net/sock.h |  2 ++
>  net/socket.c       | 39 +++++++++++++++++++++++++--------------
>  2 files changed, 27 insertions(+), 14 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 2eb916d1ff64..2a0324275347 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1853,6 +1853,8 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
>  		  sockptr_t optval, unsigned int optlen);
>  int sock_setsockopt(struct socket *sock, int level, int op,
>  		    sockptr_t optval, unsigned int optlen);
> +int do_sock_setsockopt(struct socket *sock, bool compat, int level,
> +		       int optname, sockptr_t optval, int optlen);

Somewhat surprising that optlen type differs between __sys_setsockopt
and sock_setsockopt. But agreed that this code should follow
__sys_setsockopt.
