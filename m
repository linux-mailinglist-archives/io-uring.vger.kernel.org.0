Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7A37BBC05
	for <lists+io-uring@lfdr.de>; Fri,  6 Oct 2023 17:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbjJFPpH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Oct 2023 11:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjJFPpG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Oct 2023 11:45:06 -0400
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE7CAD;
        Fri,  6 Oct 2023 08:45:05 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-9936b3d0286so420992966b.0;
        Fri, 06 Oct 2023 08:45:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696607103; x=1697211903;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8aFYMnezX6QVt6CPqUMIG1km0ffIJ/7lCOUbibCVNYY=;
        b=cr27A3mZjcwN/2wRLR+iWgqsHOq9hJfamtEh/LuSr5A/xOgRWm8TP6XNjksmYUYaPe
         iSRDwHgcZNRezDU298WX/3B0TDH93SRW4Uag4RCAJSabwftxLSUdk8Dio4Dn+62XGjHi
         X+FNQYCY7SyUCTM9OYiln8SJOT9TBV0HdKoGPZCfuLuWXSJgV9LNsYOZa617a6nV7CD3
         fuuKHx5izEtDeyQfnlFXy0JUSojtQ/IH8AYGsh5hLp3wNtgmeOIzVhpyEmKWFdzsDm9P
         wr0TIfmZr27gf/E5vSdNzwQ/OLk2khzk4kw672nYksamgKDzMeXpVWcslwd/DPVS1ldP
         pYRg==
X-Gm-Message-State: AOJu0Yzc2U4YqMa1COiPHr6dbW+smLkYeJRHrB0LYI0DH+dEJHa9X/Fv
        drANEtfxm21zK8x/SrfvbJg=
X-Google-Smtp-Source: AGHT+IE9DXNEm/MJhfpSSluc6f57Rm80AeOvy49rpEIS7UOG3ALQ+Sr77GzdCmsCicO59TMC1q98SQ==
X-Received: by 2002:a17:906:9c1:b0:9ae:5aa4:9fa with SMTP id r1-20020a17090609c100b009ae5aa409famr7685330eje.42.1696607103107;
        Fri, 06 Oct 2023 08:45:03 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-117.fbsv.net. [2a03:2880:31ff:75::face:b00c])
        by smtp.gmail.com with ESMTPSA id jw26-20020a17090776ba00b009ae3d711fd9sm3040104ejc.69.2023.10.06.08.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 08:45:02 -0700 (PDT)
Date:   Fri, 6 Oct 2023 08:45:00 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        krisman@suse.de, bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v4 00/10] io_uring: Initial support for {s,g}etsockopt
 commands
Message-ID: <ZSArfLaaGcfd8LH8@gmail.com>
References: <20230904162504.1356068-1-leitao@debian.org>
 <20230905154951.0d0d3962@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230905154951.0d0d3962@kernel.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Jakub,

On Tue, Sep 05, 2023 at 03:49:51PM -0700, Jakub Kicinski wrote:
> On Mon,  4 Sep 2023 09:24:53 -0700 Breno Leitao wrote:
> > Patches 1-2: Modify the BPF hooks to support sockptr_t, so, these functions
> > become flexible enough to accept user or kernel pointers for optval/optlen.
> 
> Have you seen:
> 
> https://lore.kernel.org/all/CAHk-=wgGV61xrG=gO0=dXH64o2TDWWrXn1mx-CX885JZ7h84Og@mail.gmail.com/
> 
> ? I wasn't aware that Linus felt this way, now I wonder if having
> sockptr_t spread will raise any red flags as this code flows back
> to him.

Thanks for the heads-up. I've been thinking about it for a while and I'd
like to hear what are the next steps here.

Let me first back up and state where we are, and what is the current
situation:

1) __sys_getsockopt() uses __user pointers for both optval and optlen
2) For io_uring command, Jens[1] suggested we get optlen from the io_uring
sqe, which is a kernel pointer/value.

Thus, we need to make the common code (callbacks) able to handle __user
and kernel pointers (for optlen, at least).

From a proto_ops callback perspective, ->setsockopt() uses sockptr.

          int             (*setsockopt)(struct socket *sock, int level,
                                        int optname, sockptr_t optval,
                                        unsigned int optlen);

Getsockopt() uses sockptr() for level=SOL_SOCKET:

	int sk_getsockopt(struct sock *sk, int level, int optname,
                    sockptr_t optval, sockptr_t optlen)

But not for the other levels:

	int             (*getsockopt)(struct socket *sock, int level,
				      int optname, char __user *optval, int __user *optlen);


That said, if this patchset shouldn't use sockptr anymore, what is the
recommendation?

If we move this patchset to use iov_iter instead of sockptr, then I
understand we want to move *all* these callbacks to use iov_vec. Is this
the right direction?

Thanks for the guidance!

[1] https://lore.kernel.org/all/efe602f1-8e72-466c-b796-0083fd1c6d82@kernel.dk/
