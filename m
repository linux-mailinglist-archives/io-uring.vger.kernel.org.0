Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E264775690
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 11:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjHIJlI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 05:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbjHIJlI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 05:41:08 -0400
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B788A1FDF;
        Wed,  9 Aug 2023 02:41:03 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-99c10ba30afso149166266b.1;
        Wed, 09 Aug 2023 02:41:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691574062; x=1692178862;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=POZx1Czjl+EpbVC1OkzexxsQSbMIz0qrEmbKh1sujrs=;
        b=B4a39S9KTbq8bLxQqLKVJXrN+p/wwuQ66aRgmEm5JgM5w4yyrmKMaUsByr7pdjkmOC
         M+L4ZWD9Sywag1fHuQanISDLGszoPoq/af39OPswTyG4a+jd233euOJrqK0LRmbqRSH4
         UWvuurdobJ901n0WZX8TeRI7eyiQWC+8oFpV4HVUQY41KMivkfwd6WZ+1WFijnK/XDwO
         L857iEvCGQkfYHfPWBi8Lo3jDEXCGB/1x4pBt5M0RObUOhL7KAlbRZK8T+O/eqc/JGYu
         0ggUUexnEXVPAVKLhcBLht4nswiDMln1W18Pt6PoEN3fT3ahaHiezSpKVyztIXYnmyhE
         3VLg==
X-Gm-Message-State: AOJu0YxZ94hLwN0z8xPQVc/u/rYBDotxoR1W4HU3EZeD0RYQ9oInKNPb
        UvAmv/g9zhQgIhrbnwv4o5Y=
X-Google-Smtp-Source: AGHT+IEMjS663ej8XAL1oDFmpG+FblomrzyFQBwSCqa4M2JYBvIf84H9BGmB0T1n+xQB6I9ZJpVg+w==
X-Received: by 2002:a17:906:3298:b0:99c:7300:94b8 with SMTP id 24-20020a170906329800b0099c730094b8mr2601281ejw.10.1691574061783;
        Wed, 09 Aug 2023 02:41:01 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-118.fbsv.net. [2a03:2880:31ff:76::face:b00c])
        by smtp.gmail.com with ESMTPSA id a1-20020a1709063a4100b0099275c59bc9sm7788999ejf.33.2023.08.09.02.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 02:41:01 -0700 (PDT)
Date:   Wed, 9 Aug 2023 02:40:59 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v2 0/8] io_uring: Initial support for {s,g}etsockopt
 commands
Message-ID: <ZNNfK5e+lc0tsjj/@gmail.com>
References: <20230808134049.1407498-1-leitao@debian.org>
 <ZNJ8zGcYClv/VCwG@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNJ8zGcYClv/VCwG@google.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FSL_HELO_FAKE,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 08, 2023 at 10:35:08AM -0700, Stanislav Fomichev wrote:
> On 08/08, Breno Leitao wrote:
> > This patchset adds support for getsockopt (SOCKET_URING_OP_GETSOCKOPT)
> > and setsockopt (SOCKET_URING_OP_SETSOCKOPT) in io_uring commands.
> > SOCKET_URING_OP_SETSOCKOPT implements generic case, covering all levels
> > nad optnames. On the other hand, SOCKET_URING_OP_GETSOCKOPT just
> > implements level SOL_SOCKET case, which seems to be the
> > most common level parameter for get/setsockopt(2).
> > 
> > struct proto_ops->setsockopt() uses sockptr instead of userspace
> > pointers, which makes it easy to bind to io_uring. Unfortunately
> > proto_ops->getsockopt() callback uses userspace pointers, except for
> > SOL_SOCKET, which is handled by sk_getsockopt(). Thus, this patchset
> > leverages sk_getsockopt() to imlpement the SOCKET_URING_OP_GETSOCKOPT
> > case.
> > 
> > In order to support BPF hooks, I modified the hooks to use  sockptr, so,
> > it is flexible enough to accept user or kernel pointers for
> > optval/optlen.
> > 
> > PS1: For getsockopt command, the optlen field is not a userspace
> > pointers, but an absolute value, so this is slightly different from
> > getsockopt(2) behaviour. The new optlen value is returned in cqe->res.
> > 
> > PS2: The userspace pointers need to be alive until the operation is
> > completed.
> > 
> > These changes were tested with a new test[1] in liburing. On the BPF
> > side, I tested that no regression was introduced by running "test_progs"
> > self test using "sockopt" test case.
> > 
> > [1] Link: https://github.com/leitao/liburing/blob/getsock/test/socket-getsetsock-cmd.c
> > 
> > RFC -> V1:
> > 	* Copy user memory at io_uring subsystem, and call proto_ops
> > 	  callbacks using kernel memory
> > 	* Implement all the cases for SOCKET_URING_OP_SETSOCKOPT
> 
> I did a quick pass, will take a close look later today. So far everything makes
> sense to me.
> 
> Should we properly test it as well?
> We have tools/testing/selftests/bpf/prog_tests/sockopt.c which does
> most of the sanity checks, but it uses regular socket/{g,s}etsockopt
> syscalls.

Right, that is what I've been using to test the changes.

> Seems like it should be pretty easy to extend this with
> io_uring path? tools/testing/selftests/net/io_uring_zerocopy_tx.c
> already implements minimal wrappers which we can most likely borrow.

Sure, I can definitely do it. Do you want to see the new tests in this
patchset, or, in a following patches?
