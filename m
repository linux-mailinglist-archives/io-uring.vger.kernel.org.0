Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE200788B75
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 16:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbjHYOQt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 10:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343780AbjHYOQi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 10:16:38 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4768E26A6;
        Fri, 25 Aug 2023 07:16:13 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-99bdeae1d0aso122297966b.1;
        Fri, 25 Aug 2023 07:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692972910; x=1693577710;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BCh/SkT77T2Ffe7WtjbsHe67/BKAxXhiOOGhuLP94jw=;
        b=i7ddXGPylDzR0I6AGUY+4BbMsDkjQcZzLGkQxRODWnXGWBeTmbglt/ZcTYDGuC2yTm
         Jp2kxq75o2VzkJKXDzsHt4j0hYQWTTXIsarDASyqBW06BYXd5E3T5vN5AuKQwUrYkOJH
         EhYkFirUcRvH+VRlKaEmUUKi+147VPCGeMlh0xtrI4iaRggxWmn41WROVWnuIbreRwSm
         DlU9oqysXfrLbGY4Tl4QPK5aTVwmeQeMa4iMRxka3SH3ws5qgqNWnScRNUP1sgiMRfY7
         FbwglmSSmpHK4b8OKulXecmG1zIQFR7FgzFF+c8FuMaymdDSswspEBmqsBZPw125yYgw
         GxuA==
X-Gm-Message-State: AOJu0YwJyiVHsqRN/UAxfw6Xm/tuopsfMs4LvESyIds3hlv1DD1xKmzT
        eXHsfBwzDB/0hM03CrJMbYs=
X-Google-Smtp-Source: AGHT+IGQ+BS7r6qMCNwz4eVEEF8AR1o7mkAPgh8C4EePozWNU8E/0B3fxHTTLeScNXWoiZOk6sOFPQ==
X-Received: by 2002:a17:907:a06a:b0:9a1:f46c:ffc5 with SMTP id ia10-20020a170907a06a00b009a1f46cffc5mr4877449ejc.41.1692972910299;
        Fri, 25 Aug 2023 07:15:10 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-021.fbsv.net. [2a03:2880:31ff:15::face:b00c])
        by smtp.gmail.com with ESMTPSA id fx13-20020a170906b74d00b00982be08a9besm1014734ejb.172.2023.08.25.07.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 07:15:09 -0700 (PDT)
Date:   Fri, 25 Aug 2023 07:15:05 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        krisman@suse.de, Wang Yufen <wangyufen@huawei.com>,
        Daniel =?iso-8859-1?Q?M=FCller?= <deso@posteo.net>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, sdf@google.com, axboe@kernel.dk,
        asml.silence@gmail.com, willemdebruijn.kernel@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Song Liu <song@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v3 9/9] selftests/bpf/sockopt: Add io_uring support
Message-ID: <ZOi3aeq43hVb1Ner@gmail.com>
References: <20230817145554.892543-1-leitao@debian.org>
 <20230817145554.892543-10-leitao@debian.org>
 <59278e71-3a88-5da9-b46e-9992987d258d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59278e71-3a88-5da9-b46e-9992987d258d@linux.dev>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 21, 2023 at 01:59:12PM -0700, Martin KaFai Lau wrote:
> On 8/17/23 7:55 AM, Breno Leitao wrote:
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 538df8fb8c42..4da04242b848 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -362,6 +362,7 @@ CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
> >   $(OUTPUT)/test_l4lb_noinline.o: BPF_CFLAGS += -fno-inline
> >   $(OUTPUT)/test_xdp_noinline.o: BPF_CFLAGS += -fno-inline
> > +$(OUTPUT)/test_progs.o: CFLAGS += -I../../../include/
> 
> This is the tools/include? Is it really needed? iirc, some of the
> prog_tests/*.c has already been using files from tools/include.

You are right, we don't need it.

> >   $(OUTPUT)/flow_dissector_load.o: flow_dissector_load.h
> >   $(OUTPUT)/cgroup_getset_retval_hooks.o: cgroup_getset_retval_hooks.h
> > diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt.c b/tools/testing/selftests/bpf/prog_tests/sockopt.c
> > index 9e6a5e3ed4de..4693ad8bfe8f 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/sockopt.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/sockopt.c
> > @@ -1,5 +1,6 @@
> >   // SPDX-License-Identifier: GPL-2.0
> >   #include <test_progs.h>
> > +#include <io_uring/mini_liburing.h>
> >   #include "cgroup_helpers.h"
> >   static char bpf_log_buf[4096];
> > @@ -38,6 +39,7 @@ static struct sockopt_test {
> >   	socklen_t			get_optlen_ret;
> >   	enum sockopt_test_error		error;
> > +	bool				io_uring_support;
> >   } tests[] = {
> >   	/* ==================== getsockopt ====================  */
> > @@ -53,6 +55,7 @@ static struct sockopt_test {
> >   		.attach_type = BPF_CGROUP_GETSOCKOPT,
> >   		.expected_attach_type = 0,
> >   		.error = DENY_LOAD,
> > +		.io_uring_support = true,
> 
> DENY_LOAD probably won't be an intersting test. The set/getsockopt won't be called.

Yea, I will remove all the DENY_LOAD and DENY_ATTACH tests.

> The existing test does not seem to have SOL_SOCKET for getsockopt also.

I am planning to move two tests to use SOL_SOCKET so we can also
exercise the io_uring tests. This is what I have in mind right now:

 * getsockopt: read ctx->optlen
 * getsockopt: support smaller ctx->optlen

> > -static int run_test(int cgroup_fd, struct sockopt_test *test)
> > +/* Core function that handles io_uring ring initialization,
> > + * sending SQE with sockopt command and waiting for the CQE.
> > + */
> > +static int uring_sockopt(int op, int fd, int level, int optname,
> > +			 const void *optval, socklen_t optlen)
> > +{
> > +	struct io_uring_cqe *cqe;
> > +	struct io_uring_sqe *sqe;
> > +	struct io_uring ring;
> > +	int err;
> > +
> > +	err = io_uring_queue_init(1, &ring, 0);
> > +	if (err) {
> > +		log_err("Failed to initialize io_uring ring");
> > +		return err;
> > +	}
> > +
> > +	sqe = io_uring_get_sqe(&ring);
> > +	if (!sqe) {
> > +		log_err("Failed to get an SQE");
> > +		return -1;
> 
> No need to io_uring_queue_exit() on the error path?

Good idea. updating it.

> > +	}
> > +
> > +	io_uring_prep_cmd(sqe, op, fd, level, optname, optval, optlen);
> > +
> > +	err = io_uring_submit(&ring);
> > +	if (err != 1) {
> > +		log_err("Failed to submit SQE");
> 
> Use ASSERT_* instead.
> 
> Regarding how to land this set,
> it will be useful to have the selftest running in the bpf CI. While there is
> iouring changes, some of the changes is in bpf and/or netdev also. eg. Patch
> 3 already has a conflict with the net-next and bpf-next tree because of a
> recent commit in socket.c on Aug 9.
> 
> May be Alexi and Daniel can advise how was similar patch managed before ?
> 
> 
