Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4787BDF43
	for <lists+io-uring@lfdr.de>; Mon,  9 Oct 2023 15:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376855AbjJIN2O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Oct 2023 09:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376859AbjJIN2N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Oct 2023 09:28:13 -0400
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BCFE0;
        Mon,  9 Oct 2023 06:28:11 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-99de884ad25so811721666b.3;
        Mon, 09 Oct 2023 06:28:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696858083; x=1697462883;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SvOpy4MMRVXFozGEKzx2uKL7AJqMO6msRg8vYHCWpik=;
        b=U3txsWeEP5cFMwMg7xnnIvD9FvSNjcYInn7xljNViaLy2Lhdxxy79ywOYsSvwpf7ZO
         qZNqcNLlm9RB10tAWLKFXZ22l+oPUn8LNY/UV3fmsgMi4+Hy78PPKN9jusSDKP+LAGv7
         6UUeVBdB0FusXKVFisPGWXoHMbsmWJG8ZvXmPFA8Bii2d7j+xGhv9EsD7UDRvtatpI9U
         ol3OUZydt+k7KlrzGAnK0lYxL9yuYMeIHmI52lAMy8nlfB7Hyw50cA8qtDFt2Qp4fWrs
         5ZNFGeejWe/Qi+dmqUu/jZdQ+lQyTIHIhyDRrP1/enTizww6Fvcx0SqVmPWyJurogXBm
         EsCw==
X-Gm-Message-State: AOJu0Yx8PXQwet65AL62PbR7aiQhWAPBz4Uk7tRAT7wNJM7CJOk2B44w
        WnkfDCiHuV6yO3Z/jcifdX26ghghq4w=
X-Google-Smtp-Source: AGHT+IHSl8Z0n50bbqSTqzgwk6CvvJJXLT64VDWnrIQthn51Xs+VGG7cTHvCJeni8WLsNTxhw728aQ==
X-Received: by 2002:a17:907:c205:b0:9a5:c54f:da1c with SMTP id ti5-20020a170907c20500b009a5c54fda1cmr14068351ejc.47.1696858082831;
        Mon, 09 Oct 2023 06:28:02 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-015.fbsv.net. [2a03:2880:31ff:f::face:b00c])
        by smtp.gmail.com with ESMTPSA id p6-20020a1709061b4600b0098e2969ed44sm6693523ejg.45.2023.10.09.06.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Oct 2023 06:28:02 -0700 (PDT)
Date:   Mon, 9 Oct 2023 06:28:00 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, sdf@google.com, axboe@kernel.dk,
        asml.silence@gmail.com, martin.lau@linux.dev, krisman@suse.de,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v4 00/10] io_uring: Initial support for {s,g}etsockopt
 commands
Message-ID: <ZSP/4GVaQiFuDizz@gmail.com>
References: <20230904162504.1356068-1-leitao@debian.org>
 <20230905154951.0d0d3962@kernel.org>
 <ZSArfLaaGcfd8LH8@gmail.com>
 <CAF=yD-Lr3238obe-_omnPBvgdv2NLvdK5be-5F7YyV3H7BkhSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF=yD-Lr3238obe-_omnPBvgdv2NLvdK5be-5F7YyV3H7BkhSg@mail.gmail.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Oct 09, 2023 at 03:11:05AM -0700, Willem de Bruijn wrote:
> On Fri, Oct 6, 2023 at 10:45 AM Breno Leitao <leitao@debian.org> wrote:
> > Let me first back up and state where we are, and what is the current
> > situation:
> >
> > 1) __sys_getsockopt() uses __user pointers for both optval and optlen
> > 2) For io_uring command, Jens[1] suggested we get optlen from the io_uring
> > sqe, which is a kernel pointer/value.
> >
> > Thus, we need to make the common code (callbacks) able to handle __user
> > and kernel pointers (for optlen, at least).
> >
> > From a proto_ops callback perspective, ->setsockopt() uses sockptr.
> >
> >           int             (*setsockopt)(struct socket *sock, int level,
> >                                         int optname, sockptr_t optval,
> >                                         unsigned int optlen);
> >
> > Getsockopt() uses sockptr() for level=SOL_SOCKET:
> >
> >         int sk_getsockopt(struct sock *sk, int level, int optname,
> >                     sockptr_t optval, sockptr_t optlen)
> >
> > But not for the other levels:
> >
> >         int             (*getsockopt)(struct socket *sock, int level,
> >                                       int optname, char __user *optval, int __user *optlen);
> >
> >
> > That said, if this patchset shouldn't use sockptr anymore, what is the
> > recommendation?
> >
> > If we move this patchset to use iov_iter instead of sockptr, then I
> > understand we want to move *all* these callbacks to use iov_vec. Is this
> > the right direction?
> >
> > Thanks for the guidance!
> >
> > [1] https://lore.kernel.org/all/efe602f1-8e72-466c-b796-0083fd1c6d82@kernel.dk/
> 
> Since sockptr_t is already used by __sys_setsockopt and
> __sys_setsockopt, patches 1 and 2 don't introduce any new sockptr code
> paths.
> 
> setsockopt callbacks also already use sockptr as of commit
> a7b75c5a8c41 ("net: pass a sockptr_t into ->setsockopt").
> 
> getsockopt callbacks do take user pointers, just not sockptr.
> 
> Is the only issue right now the optlen kernel pointer?

Correct. The current discussion is only related to optlen in the
getsockopt() callbacks (invoked when level != SOL_SOCKET). Everything
else (getsockopt(level=SOL_SOCKET..) and setsockopt) is using sockptr.

Is it bad if we review/merge this code as is (using sockptr), and start
the iov_iter/getsockopt() refactor in a follow-up thread?

Thanks!
