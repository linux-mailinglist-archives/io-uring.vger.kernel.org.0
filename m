Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0556A763206
	for <lists+io-uring@lfdr.de>; Wed, 26 Jul 2023 11:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjGZJ3E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Jul 2023 05:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbjGZJ2e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Jul 2023 05:28:34 -0400
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C6130F4;
        Wed, 26 Jul 2023 02:26:35 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-52256241c66so1675609a12.1;
        Wed, 26 Jul 2023 02:26:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690363594; x=1690968394;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3i0QbOeDmajmhvzhQ0MHR/DHrb4f2crGlJ6oBy8fycY=;
        b=aBC2GxV8krGiOmvnL7iCYCL42tUd1s8s73kdPl+WxGxI4hQxlhM6cDrKEQamxftXeM
         rZudOi6ykrwDzAiFLyJLLlygCXwpxYpGVQH3Et+eDWcOXE8jreiiylK61Dq0g8WuOhWJ
         xjQkkW72mk/pc+yAElo6EeUIB9hPUAskUqEKjvY0Y29Q0szZxWHeqGrI+UJKYQtBRD1O
         TGW0hCHUmqiDXi9cdYcxFh6I/1lQeNumT+ub8BNx2VKih+shGFzKOQEtQICTkWmsFMpU
         65ZuB/7qSlM+BOFgfwS8+x59TzDsugR3EKby71In9EymEryG340ZD02r2Wu6vybW7C+/
         z35g==
X-Gm-Message-State: ABy/qLYsRjRaHBOEzeZ4840OOZ3PMgkhsEOfYrb251bvVbgA2jeAyCWs
        PWuWadoVcbXxmW0+7NFhJKkL8Nx4FYc=
X-Google-Smtp-Source: APBJJlE6qT/NqcvaDVc5i63FlNpKEp8i80T0F5ej/emHMoykI5Ra0Sxw4Rw1wHel/mg8V4dGwOiT0w==
X-Received: by 2002:a05:6402:1391:b0:522:3a1d:c233 with SMTP id b17-20020a056402139100b005223a1dc233mr1862501edv.11.1690363593529;
        Wed, 26 Jul 2023 02:26:33 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-016.fbsv.net. [2a03:2880:31ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id l27-20020a056402345b00b0052279f773e3sm227327edc.32.2023.07.26.02.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 02:26:32 -0700 (PDT)
Date:   Wed, 26 Jul 2023 02:26:30 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Stanislav Fomichev <sdf@google.com>, asml.silence@gmail.com,
        axboe@kernel.dk, io-uring@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, linux-kernel@vger.kernel.org, leit@meta.com,
        bpf@vger.kernel.org, ast@kernel.org
Subject: Re: [PATCH 2/4] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
Message-ID: <ZMDmxkacOklM7Oi2@gmail.com>
References: <20230724142237.358769-1-leitao@debian.org>
 <20230724142237.358769-3-leitao@debian.org>
 <ZL61cIrQuo92Xzbu@google.com>
 <ZL+VfRiJQqrrLe/9@gmail.com>
 <ZMAAMKTaKSIKi1RW@google.com>
 <87fa06c9-d8a9-fda4-d069-6812605aa10b@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fa06c9-d8a9-fda4-d069-6812605aa10b@linux.dev>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FSL_HELO_FAKE,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 25, 2023 at 10:56:23AM -0700, Martin KaFai Lau wrote:
> On 7/25/23 10:02 AM, Stanislav Fomichev wrote:
> > On 07/25, Breno Leitao wrote:
> > > On Mon, Jul 24, 2023 at 10:31:28AM -0700, Stanislav Fomichev wrote:
> > > > On 07/24, Breno Leitao wrote:
> > > > > Add support for getsockopt command (SOCKET_URING_OP_GETSOCKOPT), where
> > > > > level is SOL_SOCKET. This is leveraging the sockptr_t infrastructure,
> > > > > where a sockptr_t is either userspace or kernel space, and handled as
> > > > > such.
> > > > > 
> > > > > Function io_uring_cmd_getsockopt() is inspired by __sys_getsockopt().
> > > > 
> > > > We probably need to also have bpf bits in the new
> > > > io_uring_cmd_getsockopt?
> 
> I also think this inconsistency behavior should be avoided.
> 
> > > 
> > > It might be interesting to have the BPF hook for this function as
> > > well, but I would like to do it in a following patch, so, I can
> > > experiment with it better, if that is OK.
> > 
> > We are not using io_uring, so fine with me. However, having a way to bypass
> > get/setsockopt bpf might be problematic for some other heavy io_uring
> > users.
> > 
> > Lemme CC a bunch of Meta folks explicitly. I'm not sure what that state
> > of bpf support in io_uring.
> 
> We have use cases on the "cgroup/{g,s}etsockopt". It will be a surprise when
> the user moves from the syscall {g,s}etsockopt to SOCKET_URING_OP_*SOCKOPT
> and figured that the bpf handling is skipped.

Ok, I will add the BPF bits in the next revision then. Thanks for
clarifying it.
