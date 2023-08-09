Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03437764FB
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 18:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjHIQ1F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 12:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjHIQ1F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 12:27:05 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147F11999
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 09:27:04 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-2682b4ca7b7so3938215a91.3
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 09:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691598423; x=1692203223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D9slY7L6wCBcCqclWRszu0YEXVQ+ftiI5ObGkzjdqrg=;
        b=l34yiPQwzUm7bzfUSUWpEvPTpUP9ao2GfVObE0lvHLRnMzOppIkqBkNpnJpblmjnGC
         vjG/7MaN4Yms92toXNu0q7ix+6zAxmfeC3Fg9PUf+OzRfzyOgqqhqOikD/uTsyTD13E2
         jf0JX/D38w+dTWvwcaC5PG8f6UbX52AA86oUEB+EDmyk/3Bm+RpahVqSBArYe4Mzv7cW
         Be7GtLV9XN2CzAdV2wdD1I4ys45KmACwFFqlWyvIEeKuP3RP/m/zKoFOySJ9BRd8gEZF
         Mt/Lk3MM1cCB8gF65WVk+c5xZh6td/d5FNl+uFoHTHUDmLjaLHTbExP/RwL1RAgpMZRM
         alBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691598423; x=1692203223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D9slY7L6wCBcCqclWRszu0YEXVQ+ftiI5ObGkzjdqrg=;
        b=XZM3vlYp5IdFMiU5YSpa+GN07IFTOocwA5LTJd8EDdAFtVUKxTPcVFkQc13NKLZD9R
         QjNY3++FTMuLoIDTl4H9K/ZImpEYNad+zVA32wa3f8h2zcy/gIoRewrW0rBhWGFn0pvn
         lstirQIC+XFfW/vyZxmQmjOZIUPVWYMVAF4HK0NIn0jI9ZqdG+rtPEpFpreFxlz5DuVd
         TwvizcySZFr5xVdM7nj7iZibpZjmnNer31UIhecgXRIo70RELflMf5sRna+fewbuxWSr
         m6M1K3ajDE0QOHnVBTaZ25Bfnhplhyn51uHL/9uyjGagKBPxJNPX4voPGj8o8T5MZNpQ
         Lb9Q==
X-Gm-Message-State: AOJu0YymNbig8PSvvyhSokb63qE29xOliIIz2GSKYJjbXLOqTMHgK5zc
        B8ii9IWw7SDZDniuFp4twqY72uwcxS8ZRHfx+wHeOg==
X-Google-Smtp-Source: AGHT+IFhn6q6rlv/JEH6wuK9BVQM7oZHGK/5GQSfYw8PZ74oldKN7sB4zN6Y5yTefszsjtKU9QPNxhz96r77733HsVs=
X-Received: by 2002:a17:90a:1196:b0:267:f8a2:300a with SMTP id
 e22-20020a17090a119600b00267f8a2300amr2440659pja.7.1691598423307; Wed, 09 Aug
 2023 09:27:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230808134049.1407498-1-leitao@debian.org> <ZNJ8zGcYClv/VCwG@google.com>
 <ZNNfK5e+lc0tsjj/@gmail.com>
In-Reply-To: <ZNNfK5e+lc0tsjj/@gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 9 Aug 2023 09:26:52 -0700
Message-ID: <CAKH8qBvw86nb50h2ha77La9WVpBE3Ln7a00YTnQST0KyROmvqQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] io_uring: Initial support for {s,g}etsockopt commands
To:     Breno Leitao <leitao@debian.org>
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 9, 2023 at 2:41=E2=80=AFAM Breno Leitao <leitao@debian.org> wro=
te:
>
> On Tue, Aug 08, 2023 at 10:35:08AM -0700, Stanislav Fomichev wrote:
> > On 08/08, Breno Leitao wrote:
> > > This patchset adds support for getsockopt (SOCKET_URING_OP_GETSOCKOPT=
)
> > > and setsockopt (SOCKET_URING_OP_SETSOCKOPT) in io_uring commands.
> > > SOCKET_URING_OP_SETSOCKOPT implements generic case, covering all leve=
ls
> > > nad optnames. On the other hand, SOCKET_URING_OP_GETSOCKOPT just
> > > implements level SOL_SOCKET case, which seems to be the
> > > most common level parameter for get/setsockopt(2).
> > >
> > > struct proto_ops->setsockopt() uses sockptr instead of userspace
> > > pointers, which makes it easy to bind to io_uring. Unfortunately
> > > proto_ops->getsockopt() callback uses userspace pointers, except for
> > > SOL_SOCKET, which is handled by sk_getsockopt(). Thus, this patchset
> > > leverages sk_getsockopt() to imlpement the SOCKET_URING_OP_GETSOCKOPT
> > > case.
> > >
> > > In order to support BPF hooks, I modified the hooks to use  sockptr, =
so,
> > > it is flexible enough to accept user or kernel pointers for
> > > optval/optlen.
> > >
> > > PS1: For getsockopt command, the optlen field is not a userspace
> > > pointers, but an absolute value, so this is slightly different from
> > > getsockopt(2) behaviour. The new optlen value is returned in cqe->res=
.
> > >
> > > PS2: The userspace pointers need to be alive until the operation is
> > > completed.
> > >
> > > These changes were tested with a new test[1] in liburing. On the BPF
> > > side, I tested that no regression was introduced by running "test_pro=
gs"
> > > self test using "sockopt" test case.
> > >
> > > [1] Link: https://github.com/leitao/liburing/blob/getsock/test/socket=
-getsetsock-cmd.c
> > >
> > > RFC -> V1:
> > >     * Copy user memory at io_uring subsystem, and call proto_ops
> > >       callbacks using kernel memory
> > >     * Implement all the cases for SOCKET_URING_OP_SETSOCKOPT
> >
> > I did a quick pass, will take a close look later today. So far everythi=
ng makes
> > sense to me.
> >
> > Should we properly test it as well?
> > We have tools/testing/selftests/bpf/prog_tests/sockopt.c which does
> > most of the sanity checks, but it uses regular socket/{g,s}etsockopt
> > syscalls.
>
> Right, that is what I've been using to test the changes.
>
> > Seems like it should be pretty easy to extend this with
> > io_uring path? tools/testing/selftests/net/io_uring_zerocopy_tx.c
> > already implements minimal wrappers which we can most likely borrow.
>
> Sure, I can definitely do it. Do you want to see the new tests in this
> patchset, or, in a following patches?

Let's keep it in the same series if possible?
