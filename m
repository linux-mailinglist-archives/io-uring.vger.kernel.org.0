Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033137692CF
	for <lists+io-uring@lfdr.de>; Mon, 31 Jul 2023 12:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjGaKNj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Jul 2023 06:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbjGaKNi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Jul 2023 06:13:38 -0400
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEDAE3;
        Mon, 31 Jul 2023 03:13:36 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-99bfcf4c814so339718566b.0;
        Mon, 31 Jul 2023 03:13:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690798415; x=1691403215;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MCE5qRVpdCIKbrLA0MVnXkLR11xNVpzRW52JK1t8Hl4=;
        b=i+oPgCtmwd/oNMe+7K4iY0i4ukVkOFpwCzUYTWtivNJri0aNDT9McTMxZeNRpeQGEP
         SxKnJaAkJkqdFD9EnkffzwuA6e5fpYMo7dJXAoXpQYjuf8kBqnCJzr+eVHoigXh5a4up
         ii8Po7DexJq7zLoKWCpFRdeqlUa2Emb4cf6Hn5qShE+J04K5GO2lRkU7IXf7YFy0Dy9t
         QHnr/ywZEj3TKY4g/q9fsGTp3cyUgHlvkDz+TPrkx0rcLC/Hi2k65o5fb+QPLjIETbAa
         u1CiDJkeNkt/tRalP4RanFARDRpMTBfKdbvbFFPVMADajEJ9wFxvPmu2htXtr8HdWRkq
         dbiw==
X-Gm-Message-State: ABy/qLbu8SrqQ5avvNp/jkXPFFA2QEZvhj63hhdcypwcyEZ0qF0yLNVk
        fKjaPtdduizZtd0l3YTrj3Y=
X-Google-Smtp-Source: APBJJlFARErXv7L48dVMZakbBdzXoKvqyy2gZ2NRTNuT/zjcchJMAEgti0oj85PtPUcuAzWQdnFtBA==
X-Received: by 2002:a17:906:74c8:b0:992:9005:5ed5 with SMTP id z8-20020a17090674c800b0099290055ed5mr7480077ejl.32.1690798415227;
        Mon, 31 Jul 2023 03:13:35 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-007.fbsv.net. [2a03:2880:31ff:7::face:b00c])
        by smtp.gmail.com with ESMTPSA id q26-20020a1709060e5a00b00992b50fbbe9sm5927789eji.90.2023.07.31.03.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 03:13:34 -0700 (PDT)
Date:   Mon, 31 Jul 2023 03:13:33 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, leit@meta.com, bpf@vger.kernel.org,
        ast@kernel.org, martin.lau@linux.dev
Subject: Re: [PATCH 2/4] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
Message-ID: <ZMeJTRTEEcahEHLJ@gmail.com>
References: <20230724142237.358769-1-leitao@debian.org>
 <20230724142237.358769-3-leitao@debian.org>
 <ZL61cIrQuo92Xzbu@google.com>
 <ZL+VfRiJQqrrLe/9@gmail.com>
 <ZMAAMKTaKSIKi1RW@google.com>
 <ZMP07KtOeJ09ejAd@gmail.com>
 <CAKH8qBsm7JGnO+SF7PELT7Ua+5=RA8sAWdnD0UBiG3TYh0djHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKH8qBsm7JGnO+SF7PELT7Ua+5=RA8sAWdnD0UBiG3TYh0djHA@mail.gmail.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FSL_HELO_FAKE,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 28, 2023 at 11:07:10AM -0700, Stanislav Fomichev wrote:
> On Fri, Jul 28, 2023 at 10:03 AM Breno Leitao <leitao@debian.org> wrote:
> >
> > Hello Stanislav,
> >
> > On Tue, Jul 25, 2023 at 10:02:40AM -0700, Stanislav Fomichev wrote:
> > > On 07/25, Breno Leitao wrote:
> > > > On Mon, Jul 24, 2023 at 10:31:28AM -0700, Stanislav Fomichev wrote:
> > > > > On 07/24, Breno Leitao wrote:
> > > > > > Add support for getsockopt command (SOCKET_URING_OP_GETSOCKOPT), where
> > > > > > level is SOL_SOCKET. This is leveraging the sockptr_t infrastructure,
> > > > > > where a sockptr_t is either userspace or kernel space, and handled as
> > > > > > such.
> > > > > >
> > > > > > Function io_uring_cmd_getsockopt() is inspired by __sys_getsockopt().
> > > > >
> > > > > We probably need to also have bpf bits in the new
> > > > > io_uring_cmd_getsockopt?
> > > >
> > > > It might be interesting to have the BPF hook for this function as
> > > > well, but I would like to do it in a following patch, so, I can
> > > > experiment with it better, if that is OK.
> >
> > I spent smoe time looking at the problem, and I understand we want to
> > call something as BPF_CGROUP_RUN_PROG_{G,S}ETSOCKOPT() into
> > io_uring_cmd_{g,s}etsockopt().
> >
> > Per the previous conversation with Williem,
> > io_uring_cmd_{g,s}etsockopt() should use optval as a user pointer (void __user
> > *optval), and optlen as a kernel integer (it comes as from the io_uring
> > SQE), such as:
> >
> >         void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
> >         int optlen = READ_ONCE(cmd->sqe->optlen);
> >
> > Function BPF_CGROUP_RUN_PROG_GETSOCKOPT() calls
> > __cgroup_bpf_run_filter_getsockopt() which expects userpointer for
> > optlen and optval.
> >
> > At the same time BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN() expects kernel
> > pointers for both optlen and optval.
> >
> > In this current patchset, it has user pointer for optval and kernel value
> > for optlen. I.e., a third combination.  So, none of the functions would
> > work properly, and we probably do not want to create another function.
> >
> > I am wondering if it is a good idea to move
> > __cgroup_bpf_run_filter_getsockopt() to use sockptr_t, so, it will be
> > able to adapt to any combination.
> 
> Yeah, I think it makes sense. However, note that the intent of that
> optlen being a __user pointer is to possibly write some (updated)
> value back into the userspace.
> Presumably, you'll pass that updated optlen into some io_uring
> completion queue? (maybe a stupid question, not super familiar with
> io_uring)

On io_uring proposal, the optlen is part of the SQE for setsockopt().
You give a  userpointer (optval) and set the optlen in the SQE->optlen.

For getsockopt(), the optlen is returned as a result of the operation,
in the CQE->res.

If you need more detail about it, I documented this behaviour in the
cover-letter (PS1):

https://lore.kernel.org/all/20230724142237.358769-1-leitao@debian.org/

Thanks for the feedback!
