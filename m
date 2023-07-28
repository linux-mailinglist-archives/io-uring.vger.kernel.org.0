Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6E77672D3
	for <lists+io-uring@lfdr.de>; Fri, 28 Jul 2023 19:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbjG1REX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Jul 2023 13:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235717AbjG1REM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Jul 2023 13:04:12 -0400
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAAF49D7;
        Fri, 28 Jul 2023 10:03:47 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-99bd1d0cf2fso323879366b.3;
        Fri, 28 Jul 2023 10:03:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690563825; x=1691168625;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tzbpmy5CCesVeQWGWqphI5Ah11VcG7gal7MV1usl0UM=;
        b=CU+NOYFryuYxCKuQcP6HgylayRgiNsGKJE1HPz92I3v4wllzqoo5Ob8lLGz3MH5PHH
         hqi8iibkJVfrZaeT4DsCvAO+c4kO+HTPmGApD/+at9U2Bi9MdXpxhg094PJsZn+nBi8K
         ReMwjFSFOwwQrLGKUAO+qJrqs7ZnbC3ZSXYN2EbWvH+m2OI5zSPvMnZDlL9LCnsqL8yU
         J1aojVrGwWIRyBzd7rJ12wd+4Ns3cXQqe4aqrp7eWwJCJRb+ODnx9nheK3kZRTqNSzLO
         M60SabbEvtmaDnxLxeZXMqFHd59CmYIKHAd9krk0K8OlZe6jQl/DxFMwNHV1e1lvnnU3
         5UkA==
X-Gm-Message-State: ABy/qLagh3AnId8zMZWYgLFSY800oFd1g2s7Z2WZ3sSX2ncmIklRa7Yr
        SXn5R5TyvbP8GjaErlRz69Y=
X-Google-Smtp-Source: APBJJlFkFo8sLIpwvsf/6r+8p9st0JibovN+mnUD9/Akswil8Kxf7K9RUBjI3zU0vCR+30lPCARKQQ==
X-Received: by 2002:a17:906:6494:b0:994:9ed:300b with SMTP id e20-20020a170906649400b0099409ed300bmr2362960ejm.16.1690563825459;
        Fri, 28 Jul 2023 10:03:45 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-006.fbsv.net. [2a03:2880:31ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id y10-20020a17090668ca00b009934b1eb577sm2277769ejr.77.2023.07.28.10.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 10:03:44 -0700 (PDT)
Date:   Fri, 28 Jul 2023 10:03:40 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, leit@meta.com, bpf@vger.kernel.org,
        ast@kernel.org, martin.lau@linux.dev
Subject: Re: [PATCH 2/4] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
Message-ID: <ZMP07KtOeJ09ejAd@gmail.com>
References: <20230724142237.358769-1-leitao@debian.org>
 <20230724142237.358769-3-leitao@debian.org>
 <ZL61cIrQuo92Xzbu@google.com>
 <ZL+VfRiJQqrrLe/9@gmail.com>
 <ZMAAMKTaKSIKi1RW@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMAAMKTaKSIKi1RW@google.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FSL_HELO_FAKE,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Stanislav,

On Tue, Jul 25, 2023 at 10:02:40AM -0700, Stanislav Fomichev wrote:
> On 07/25, Breno Leitao wrote:
> > On Mon, Jul 24, 2023 at 10:31:28AM -0700, Stanislav Fomichev wrote:
> > > On 07/24, Breno Leitao wrote:
> > > > Add support for getsockopt command (SOCKET_URING_OP_GETSOCKOPT), where
> > > > level is SOL_SOCKET. This is leveraging the sockptr_t infrastructure,
> > > > where a sockptr_t is either userspace or kernel space, and handled as
> > > > such.
> > > > 
> > > > Function io_uring_cmd_getsockopt() is inspired by __sys_getsockopt().
> > > 
> > > We probably need to also have bpf bits in the new
> > > io_uring_cmd_getsockopt?
> > 
> > It might be interesting to have the BPF hook for this function as
> > well, but I would like to do it in a following patch, so, I can
> > experiment with it better, if that is OK.

I spent smoe time looking at the problem, and I understand we want to
call something as BPF_CGROUP_RUN_PROG_{G,S}ETSOCKOPT() into
io_uring_cmd_{g,s}etsockopt().

Per the previous conversation with Williem,
io_uring_cmd_{g,s}etsockopt() should use optval as a user pointer (void __user
*optval), and optlen as a kernel integer (it comes as from the io_uring
SQE), such as:

	void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
	int optlen = READ_ONCE(cmd->sqe->optlen);

Function BPF_CGROUP_RUN_PROG_GETSOCKOPT() calls
__cgroup_bpf_run_filter_getsockopt() which expects userpointer for
optlen and optval.

At the same time BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN() expects kernel
pointers for both optlen and optval.

In this current patchset, it has user pointer for optval and kernel value
for optlen. I.e., a third combination.  So, none of the functions would
work properly, and we probably do not want to create another function.

I am wondering if it is a good idea to move
__cgroup_bpf_run_filter_getsockopt() to use sockptr_t, so, it will be
able to adapt to any combination.

Any feedback is appreciate.
Thanks!
