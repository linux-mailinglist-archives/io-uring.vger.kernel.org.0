Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840C04E24B4
	for <lists+io-uring@lfdr.de>; Mon, 21 Mar 2022 11:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343794AbiCUKyS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Mar 2022 06:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241110AbiCUKyR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Mar 2022 06:54:17 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8761342D9
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 03:52:52 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id v130-20020a1cac88000000b00389d0a5c511so10040148wme.5
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 03:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=6M9A0WIuuZ057gEzZKiFSzsLSlTpKDKfjD1GlgCB9CE=;
        b=piAbwEWCjL9ukjYtu0giFREnXQqItrQcYX3HfR0cni57nObUnfSY2htlHqjEx0rHKG
         /sZW4S28Q1MJtMRDLeUNl8TD+lGRTWiqU3A5q+hZPHew6Bvcz9+xxeAY0ag7s48zvWBa
         riK22HfJqquDk1BApTCXzjGVt/MLZKJ5ULzw3EUxyxE5Eax9pVdSdkRgTHU2P/yfDwkV
         7A84JbXMqMw1xQoitHCiXvDs7w6+qjairdrWBNrJGhoeh+R9IpCZJ15lsHGga5DMuFzZ
         Kpf3Bb4j1aNYOLkaVH5w/HDCLMHS/Scz4jB1MYADD/2XGk1Qe/P074HLiVVr+SodPwfm
         MPAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6M9A0WIuuZ057gEzZKiFSzsLSlTpKDKfjD1GlgCB9CE=;
        b=N0c2aZJSnEymzzzZ5VJt1zu8V/sYAawH9sGbtEGj8qypD+zFmPv5nL9CCBc41xxv5P
         oOooomRosLC4FJEMwD0pIVXyYKvnh7YQxjtTCrCZ8UxGbw9CqEzxiMnOoYzhv6eV4MfU
         EfF3Un/EtJTV77A7RcpungY6igdFDiMVCOMhH+Vzrubw/0LAvLZCosSahOgvKCwL9iSx
         tsjVnJxEwPoQncOg4UcLWxi7ByYedsfTxCrdUH8ALhCZG5HfSbFgWg9uAt6rJc3uEN5e
         8xvxUaeWJto+84C4nv3vrtKtcy6hxJon8SyiHr9NC/EsiJcYSbJG+n8NDCQeXRw8qzS1
         0kFA==
X-Gm-Message-State: AOAM530L9vjbC3yXu3WDCQr61WrKymK7EJn+uu7TDVBnVTdESRtlTl4r
        6w49nEXnDe7A8ma1dRHVj9IrNQ==
X-Google-Smtp-Source: ABdhPJz5PLYaRj2OEJA8Pa7MnAeeOBx0LXbwkPr+Usi0ePv4YYd70UOSmtYmcSeUsQ/fW93lSCjfWw==
X-Received: by 2002:a05:600c:3548:b0:389:f649:7c40 with SMTP id i8-20020a05600c354800b00389f6497c40mr26325552wmq.153.1647859970945;
        Mon, 21 Mar 2022 03:52:50 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id j16-20020a05600c191000b0038ca3500494sm6163327wmq.27.2022.03.21.03.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 03:52:50 -0700 (PDT)
Date:   Mon, 21 Mar 2022 10:52:48 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [syzbot] KASAN: stack-out-of-bounds Read in iov_iter_revert
Message-ID: <YjhZAPWeBy18zmT9@google.com>
References: <6f7d4c1d-f923-3ab1-c525-45316b973c72@gmail.com>
 <00000000000047f3b805c962affb@google.com>
 <YYLAYvFU+9cnu+4H@google.com>
 <0b4a5ff8-12e5-3cc7-8971-49e576444c9a@gmail.com>
 <dd122760-5f87-10b1-e50d-388c2631c01a@kernel.dk>
 <YYp4rC4M/oh8fgr7@google.com>
 <YbmiIpQKfrLClsKV@google.com>
 <c7131961-23de-8bf4-7773-efffe9b8d294@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c7131961-23de-8bf4-7773-efffe9b8d294@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 15 Dec 2021, Pavel Begunkov wrote:

> On 12/15/21 08:06, Lee Jones wrote:
> > On Tue, 09 Nov 2021, Lee Jones wrote:
> > 
> > > On Mon, 08 Nov 2021, Jens Axboe wrote:
> > > > On 11/8/21 8:29 AM, Pavel Begunkov wrote:
> > > > > On 11/3/21 17:01, Lee Jones wrote:
> > > > > > Good afternoon Pavel,
> > > > > > 
> > > > > > > syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> > > > > > > 
> > > > > > > Reported-and-tested-by: syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com
> > > > > > > 
> > > > > > > Tested on:
> > > > > > > 
> > > > > > > commit:         bff2c168 io_uring: don't retry with truncated iter
> > > > > > > git tree:       https://github.com/isilence/linux.git truncate
> > > > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=730106bfb5bf8ace
> > > > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=9671693590ef5aad8953
> > > > > > > compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
> > > > > > > 
> > > > > > > Note: testing is done by a robot and is best-effort only.
> > > > > > 
> > > > > > As you can see in the 'dashboard link' above this bug also affects
> > > > > > android-5-10 which is currently based on v5.10.75.
> > > > > > 
> > > > > > I see that the back-port of this patch failed in v5.10.y:
> > > > > > 
> > > > > >     https://lore.kernel.org/stable/163152589512611@kroah.com/
> > > > > > 
> > > > > > And after solving the build-error by back-porting both:
> > > > > > 
> > > > > >     2112ff5ce0c11 iov_iter: track truncated size
> > > > > >     89c2b3b749182 io_uring: reexpand under-reexpanded iters
> > > > > > 
> > > > > > I now see execution tripping the WARN() in iov_iter_revert():
> > > > > > 
> > > > > >     if (WARN_ON(unroll > MAX_RW_COUNT))
> > > > > >         return
> > > > > > 
> > > > > > Am I missing any additional patches required to fix stable/v5.10.y?
> > > > > 
> > > > > Is it the same syz test? There was a couple more patches for
> > > > > IORING_SETUP_IOPOLL, but strange if that's not the case.
> > > > > 
> > > > > 
> > > > > fwiw, Jens decided to replace it with another mechanism shortly
> > > > > after, so it may be a better idea to backport those. Jens,
> > > > > what do you think?
> > > > > 
> > > > > 
> > > > > commit 8fb0f47a9d7acf620d0fd97831b69da9bc5e22ed
> > > > > Author: Jens Axboe <axboe@kernel.dk>
> > > > > Date:   Fri Sep 10 11:18:36 2021 -0600
> > > > > 
> > > > >       iov_iter: add helper to save iov_iter state
> > > > > 
> > > > > commit cd65869512ab5668a5d16f789bc4da1319c435c4
> > > > > Author: Jens Axboe <axboe@kernel.dk>
> > > > > Date:   Fri Sep 10 11:19:14 2021 -0600
> > > > > 
> > > > >       io_uring: use iov_iter state save/restore helpers
> > > > 
> > > > Yes, I think backporting based on the save/restore setup is the
> > > > sanest way by far.
> > > 
> > > Would you be kind enough to attempt to send these patches to Stable?
> > > 
> > > When I tried to back-port them, the second one gave me trouble.  And
> > > without the in depth knowledge of the driver/subsystem that you guys
> > > have, I found it almost impossible to resolve all of the conflicts:
> > 
> > Any movement on this chaps?
> > 
> > Not sure I am able to do this back-port without your help.
> 
> Apologies, slipped from my attention, we'll backport it,
> and thanks for the reminder

Looks as though these are still missing from Stable.

Is this still your plan?

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
