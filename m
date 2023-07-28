Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE03E767433
	for <lists+io-uring@lfdr.de>; Fri, 28 Jul 2023 20:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbjG1SH1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Jul 2023 14:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjG1SH0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Jul 2023 14:07:26 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACF319AF
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 11:07:22 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-268030e1be7so1361870a91.3
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 11:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690567642; x=1691172442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0j1xWKyarV49sAVolaI4AB1ZfYUgMNGUimAsLLV4Mug=;
        b=bthRLJgmCvjOnYvWo+2qon30TpingFUg2Fsc6mWV841J6V//QLFLhA/3pFUZ3RWjjp
         lvqPYA00NNy/7rUAp+SRbT6DXYQV9P2xYvt6Fw87chrCyM0dslS+R/6hc5wlsGx04nxH
         0m+HjUzgJ46oDMGQuIwdEtvGiOlhwqQO7dlBEa8W8NizZqJBs/5UmVIm7NdU+q4u2kwT
         Ig/XvZWu743pJjwIQVwK0TnKLi848DKrm8Rcsm7V8TXDR7pyX+R3tOBiI8YtrQRupbSq
         VYHkCSyOu+v4UnQfxGoiP/bFyUwxKmqJjciC1srz6+GGr7OHRgKVsqbjV3O/RlK8YIV7
         7yGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690567642; x=1691172442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0j1xWKyarV49sAVolaI4AB1ZfYUgMNGUimAsLLV4Mug=;
        b=lEcoWmH4IBFuCi9v44OtDUuou8IYDsUmMvzuLLRfQyjC+MzGl+BaXgZ6MxB2ktk7gL
         Lx2ZHElG52hcNhdyveFOwp8e2T5nH6vIsBhsb7f7t+gxyKH4TyugfYTYH5OyyWG9q86Z
         ++LQXMFcy961sP6Oiz6EtA/ESfrMAwu/DWyjZqEqbtk8Bhxovuy2gaIpLB4Nmu2nXoLe
         bh5gbb4VT4TiETM288XwLCtye6l2t03TJRRJLle7Xy/MOwZe/Im1zSXVKVGBPCQW+Qyu
         DjIfhc8kqj7kPUrR0yhr7H5JWDlHSYLVyYj1eGZNlmPf9/03TNzX/Kc/NlnVce+14Omz
         8DBw==
X-Gm-Message-State: ABy/qLbaX3kLBXTywn5kl+NDT0xg72FeWuGKo8+AVxtpaq7EfMJpVjfF
        pMAyXpC9PtuEyE8KSMfznfSSX+5lvJyGjabwmD23zw==
X-Google-Smtp-Source: APBJJlHgwJ3A+UmtsOH2HeGY6HcpJx29kymYLleOv2cjpggHGfecNjMbkiZLUi0kBVGPqDLYF511j6F7xC4+th4qRMQ=
X-Received: by 2002:a17:90b:8c4:b0:268:23d7:21c with SMTP id
 ds4-20020a17090b08c400b0026823d7021cmr2007489pjb.30.1690567641609; Fri, 28
 Jul 2023 11:07:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230724142237.358769-1-leitao@debian.org> <20230724142237.358769-3-leitao@debian.org>
 <ZL61cIrQuo92Xzbu@google.com> <ZL+VfRiJQqrrLe/9@gmail.com>
 <ZMAAMKTaKSIKi1RW@google.com> <ZMP07KtOeJ09ejAd@gmail.com>
In-Reply-To: <ZMP07KtOeJ09ejAd@gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 28 Jul 2023 11:07:10 -0700
Message-ID: <CAKH8qBsm7JGnO+SF7PELT7Ua+5=RA8sAWdnD0UBiG3TYh0djHA@mail.gmail.com>
Subject: Re: [PATCH 2/4] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
To:     Breno Leitao <leitao@debian.org>
Cc:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, leit@meta.com, bpf@vger.kernel.org,
        ast@kernel.org, martin.lau@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 28, 2023 at 10:03=E2=80=AFAM Breno Leitao <leitao@debian.org> w=
rote:
>
> Hello Stanislav,
>
> On Tue, Jul 25, 2023 at 10:02:40AM -0700, Stanislav Fomichev wrote:
> > On 07/25, Breno Leitao wrote:
> > > On Mon, Jul 24, 2023 at 10:31:28AM -0700, Stanislav Fomichev wrote:
> > > > On 07/24, Breno Leitao wrote:
> > > > > Add support for getsockopt command (SOCKET_URING_OP_GETSOCKOPT), =
where
> > > > > level is SOL_SOCKET. This is leveraging the sockptr_t infrastruct=
ure,
> > > > > where a sockptr_t is either userspace or kernel space, and handle=
d as
> > > > > such.
> > > > >
> > > > > Function io_uring_cmd_getsockopt() is inspired by __sys_getsockop=
t().
> > > >
> > > > We probably need to also have bpf bits in the new
> > > > io_uring_cmd_getsockopt?
> > >
> > > It might be interesting to have the BPF hook for this function as
> > > well, but I would like to do it in a following patch, so, I can
> > > experiment with it better, if that is OK.
>
> I spent smoe time looking at the problem, and I understand we want to
> call something as BPF_CGROUP_RUN_PROG_{G,S}ETSOCKOPT() into
> io_uring_cmd_{g,s}etsockopt().
>
> Per the previous conversation with Williem,
> io_uring_cmd_{g,s}etsockopt() should use optval as a user pointer (void _=
_user
> *optval), and optlen as a kernel integer (it comes as from the io_uring
> SQE), such as:
>
>         void __user *optval =3D u64_to_user_ptr(READ_ONCE(cmd->sqe->optva=
l));
>         int optlen =3D READ_ONCE(cmd->sqe->optlen);
>
> Function BPF_CGROUP_RUN_PROG_GETSOCKOPT() calls
> __cgroup_bpf_run_filter_getsockopt() which expects userpointer for
> optlen and optval.
>
> At the same time BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN() expects kernel
> pointers for both optlen and optval.
>
> In this current patchset, it has user pointer for optval and kernel value
> for optlen. I.e., a third combination.  So, none of the functions would
> work properly, and we probably do not want to create another function.
>
> I am wondering if it is a good idea to move
> __cgroup_bpf_run_filter_getsockopt() to use sockptr_t, so, it will be
> able to adapt to any combination.

Yeah, I think it makes sense. However, note that the intent of that
optlen being a __user pointer is to possibly write some (updated)
value back into the userspace.
Presumably, you'll pass that updated optlen into some io_uring
completion queue? (maybe a stupid question, not super familiar with
io_uring)

> Any feedback is appreciate.
> Thanks!
