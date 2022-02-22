Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6C94BFF31
	for <lists+io-uring@lfdr.de>; Tue, 22 Feb 2022 17:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbiBVQtI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Feb 2022 11:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbiBVQtH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Feb 2022 11:49:07 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5920164D1E
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 08:48:40 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id j17so7834862wrc.0
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 08:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=x47Zw43229IZO4IO8goHSCFdx3yNKtus0NrHOFjE1i4=;
        b=siKTRbGEYKAGv3nSMyaeYDbvI3vy1v+gTqiMpFWShUmW5/unSndeekgRFD4gueNQ/x
         Lxltu44Fe9I7+PPBE95MTeL1YNl8nxYyffVXdh+nQRInZnZNze+bg2fzJt0Upbvz8d0c
         hQcqw+sWRL8j2Z4cLXKmKz4PbW86Xt8o5xNVgV1p9c2vg/efEHr+HeXp82MADzBM5v3K
         27nnKKP5HifcQ4jNeqokIFIxc5o4ibZrP+a3WR/+hXS4A/WP0CujfdDuMJ4PIDfPCYb+
         wxEGNVUlyzwJQbx4xQ1kOaDRVFBXv5TlkkVyJCu+ZKAhgoevb96g0A8k/own0+9pcqy3
         Nyvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=x47Zw43229IZO4IO8goHSCFdx3yNKtus0NrHOFjE1i4=;
        b=R4X02e5HJieWUhue7yCT/nQysGOutuFtwLztujJ8cfr3rBGtUDHrU7JRoh9QddCUJy
         8CCCWF/hllkUiJtlWUsSrfGWgWRfz4gzAUKRsvZfxzTKSrjMrygRDP7KIK+8eqIpUWmC
         cEMyuWW1p7zIDh582U7y8X7lnPJFC0NJYeMhb0tfVilA0EohL3wknQLT8EYn1omM58hr
         DeWSc5aEdT1s81iP8t/B+S5whe1HAuO0GcJTj5mwWL/1wlDuOAPsTlnbtT5/vFOjVILW
         Xnt6hlW7c1AQPzKubhJ/biNsPFUYZAMYeoSX7IcLcvXYBiL2Dpl2LlhIxhrp32vIcHl3
         Krvw==
X-Gm-Message-State: AOAM533dlYIMoto6Hq9AXH+ZE16YibURcsAfzJUG+1w1Vv5hdJ02qmCL
        loPStCCqZ6mtVzI6BC96q0M9EQ==
X-Google-Smtp-Source: ABdhPJz0izC0yXy6h3y3NtZOQtkMpe310Gmq26f4R4C4tYbJKqoTk5k23OB+G0d5icNv+gEv2Ct2PA==
X-Received: by 2002:a5d:6911:0:b0:1ea:9cad:7cf0 with SMTP id t17-20020a5d6911000000b001ea9cad7cf0mr1915455wru.503.1645548519234;
        Tue, 22 Feb 2022 08:48:39 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id n7sm2819274wmd.30.2022.02.22.08.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 08:48:38 -0800 (PST)
Date:   Tue, 22 Feb 2022 16:48:36 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [syzbot] KASAN: stack-out-of-bounds Read in iov_iter_revert
Message-ID: <YhUT5I/64oaOjfDA@google.com>
References: <6f7d4c1d-f923-3ab1-c525-45316b973c72@gmail.com>
 <00000000000047f3b805c962affb@google.com>
 <YYLAYvFU+9cnu+4H@google.com>
 <0b4a5ff8-12e5-3cc7-8971-49e576444c9a@gmail.com>
 <dd122760-5f87-10b1-e50d-388c2631c01a@kernel.dk>
 <YYp4rC4M/oh8fgr7@google.com>
 <YbmiIpQKfrLClsKV@google.com>
 <c7131961-23de-8bf4-7773-efffe9b8d294@gmail.com>
 <YbtxPB/ceMUVK7t7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YbtxPB/ceMUVK7t7@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 16 Dec 2021, Lee Jones wrote:

> On Wed, 15 Dec 2021, Pavel Begunkov wrote:
> 
> > On 12/15/21 08:06, Lee Jones wrote:
> > > On Tue, 09 Nov 2021, Lee Jones wrote:
> > > 
> > > > On Mon, 08 Nov 2021, Jens Axboe wrote:
> > > > > On 11/8/21 8:29 AM, Pavel Begunkov wrote:
> > > > > > On 11/3/21 17:01, Lee Jones wrote:
> > > > > > > Good afternoon Pavel,
> > > > > > > 
> > > > > > > > syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> > > > > > > > 
> > > > > > > > Reported-and-tested-by: syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com
> > > > > > > > 
> > > > > > > > Tested on:
> > > > > > > > 
> > > > > > > > commit:         bff2c168 io_uring: don't retry with truncated iter
> > > > > > > > git tree:       https://github.com/isilence/linux.git truncate
> > > > > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=730106bfb5bf8ace
> > > > > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=9671693590ef5aad8953
> > > > > > > > compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
> > > > > > > > 
> > > > > > > > Note: testing is done by a robot and is best-effort only.
> > > > > > > 
> > > > > > > As you can see in the 'dashboard link' above this bug also affects
> > > > > > > android-5-10 which is currently based on v5.10.75.
> > > > > > > 
> > > > > > > I see that the back-port of this patch failed in v5.10.y:
> > > > > > > 
> > > > > > >     https://lore.kernel.org/stable/163152589512611@kroah.com/
> > > > > > > 
> > > > > > > And after solving the build-error by back-porting both:
> > > > > > > 
> > > > > > >     2112ff5ce0c11 iov_iter: track truncated size
> > > > > > >     89c2b3b749182 io_uring: reexpand under-reexpanded iters
> > > > > > > 
> > > > > > > I now see execution tripping the WARN() in iov_iter_revert():
> > > > > > > 
> > > > > > >     if (WARN_ON(unroll > MAX_RW_COUNT))
> > > > > > >         return
> > > > > > > 
> > > > > > > Am I missing any additional patches required to fix stable/v5.10.y?
> > > > > > 
> > > > > > Is it the same syz test? There was a couple more patches for
> > > > > > IORING_SETUP_IOPOLL, but strange if that's not the case.
> > > > > > 
> > > > > > 
> > > > > > fwiw, Jens decided to replace it with another mechanism shortly
> > > > > > after, so it may be a better idea to backport those. Jens,
> > > > > > what do you think?
> > > > > > 
> > > > > > 
> > > > > > commit 8fb0f47a9d7acf620d0fd97831b69da9bc5e22ed
> > > > > > Author: Jens Axboe <axboe@kernel.dk>
> > > > > > Date:   Fri Sep 10 11:18:36 2021 -0600
> > > > > > 
> > > > > >       iov_iter: add helper to save iov_iter state
> > > > > > 
> > > > > > commit cd65869512ab5668a5d16f789bc4da1319c435c4
> > > > > > Author: Jens Axboe <axboe@kernel.dk>
> > > > > > Date:   Fri Sep 10 11:19:14 2021 -0600
> > > > > > 
> > > > > >       io_uring: use iov_iter state save/restore helpers
> > > > > 
> > > > > Yes, I think backporting based on the save/restore setup is the
> > > > > sanest way by far.
> > > > 
> > > > Would you be kind enough to attempt to send these patches to Stable?
> > > > 
> > > > When I tried to back-port them, the second one gave me trouble.  And
> > > > without the in depth knowledge of the driver/subsystem that you guys
> > > > have, I found it almost impossible to resolve all of the conflicts:
> > > 
> > > Any movement on this chaps?
> > > 
> > > Not sure I am able to do this back-port without your help.
> > 
> > Apologies, slipped from my attention, we'll backport it,
> > and thanks for the reminder
> 
> Excellent.  Thanks Pavel.

Has this now been back-ported to Stable?

If so, would you be kind enough to provide the SHA1?

Thanks.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
