Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACF54DB69A
	for <lists+io-uring@lfdr.de>; Wed, 16 Mar 2022 17:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243143AbiCPQsD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 12:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345914AbiCPQsC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 12:48:02 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2D02BB25
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 09:46:48 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id d7so3793126wrb.7
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 09:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Lb3XF/+CKjkSk9ky0qqTNoBuJPQ2QHPnILnwSH93Uoc=;
        b=KTtvcsxTjnb1IBEzgBVVePeYXWDSIlz2lru6iEimrm1wHtznvMW+DYfbMJpSLhvixR
         SYS/M4LWfd1Ear7pp+gpHXkPjM/PdYj43Sixp58O4SdBFxgv+GyeV+TVe/j7n/+h9IOQ
         +P7DZE52I0M7gZ2UZar57O5hCANeJiOVvU22rrM5LaqWX01ZVpsvxQRbY3kZ3q0qRAU7
         BMivQvds39emNbWZTUxiowSCpZ6YXVQZ23/5V/XcYqz5H6NLGkTFakRM7vDAbSpDfKvl
         68MKzDxYPNbex7Dr369ClW43eV7LzlHyqt8mxB1MmAi9v9hw0crDzANlL9UK140A7Wip
         7ThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Lb3XF/+CKjkSk9ky0qqTNoBuJPQ2QHPnILnwSH93Uoc=;
        b=Z0xuaKKh9i0szNyiQiTz6toBF4MLXjAzNMNLv8NkV+ljA1ZzCGJm1qsb5xBMDGsS+N
         IGZ+rp9iw+/Zt6XgJewuZEZkl787ffcV1hlUOLREz5jfTpxJUQQIgVJ3dt2x10NLV0AC
         cn8TJg+BhVfxaiSdigqwmOBitT9bTpmWaJISZmrIrrV2J7xSjZDX7QDg3DAwSakL3exu
         DPUNF+1fweMxZR7dp3VJgrYnba8NkI5bfHLNJ39pFJnK3Wm3fg9TWKyITBm+N6XuRoMI
         3xB/zUF77sosVFkqwOrFw471jop/tt6PSCf/VQOgJjBSggfC0/MWueei27hORId4TStD
         k3Wg==
X-Gm-Message-State: AOAM530ooLPUZKeQjyWsiFhPa+YOxDwg7WukTbhkLEvEfMJ53bjb99WJ
        b0G8nB2xtvJzVA5QTrfyu1Bs8w==
X-Google-Smtp-Source: ABdhPJxE08qzZW9bENd61uGLSf8BldCyY7wm6oYlLXCkB+OxQi7WuYhzpMFsPiyR3yfyaV8GJuIIoQ==
X-Received: by 2002:a05:6000:1acc:b0:203:7140:c38c with SMTP id i12-20020a0560001acc00b002037140c38cmr627592wry.590.1647449205490;
        Wed, 16 Mar 2022 09:46:45 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id n1-20020a5d5981000000b00203d8ea8c94sm2323854wri.84.2022.03.16.09.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 09:46:44 -0700 (PDT)
Date:   Wed, 16 Mar 2022 16:46:42 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: return back safer resurrect
Message-ID: <YjIUckYrxbp7Lew2@google.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
 <7a080c20f686d026efade810b116b72f88abaff9.1618101759.git.asml.silence@gmail.com>
 <YjINyFwcvPs+a8uq@google.com>
 <YjISer/xC0/ZEh/1@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YjISer/xC0/ZEh/1@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 16 Mar 2022, Greg KH wrote:

> On Wed, Mar 16, 2022 at 04:18:16PM +0000, Lee Jones wrote:
> > Stable Team,
> > 
> > > Revert of revert of "io_uring: wait potential ->release() on resurrect",
> > > which adds a helper for resurrect not racing completion reinit, as was
> > > removed because of a strange bug with no clear root or link to the
> > > patch.
> > > 
> > > Was improved, instead of rcu_synchronize(), just wait_for_completion()
> > > because we're at 0 refs and it will happen very shortly. Specifically
> > > use non-interruptible version to ignore all pending signals that may
> > > have ended prior interruptible wait.
> > > 
> > > This reverts commit cb5e1b81304e089ee3ca948db4d29f71902eb575.
> > > 
> > > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > > ---
> > >  fs/io_uring.c | 18 ++++++++++++++----
> > >  1 file changed, 14 insertions(+), 4 deletions(-)
> > 
> > Please back-port this as far as it will apply.
> > 
> > Definitely through v5.10.y.
> > 
> > It solves a critical bug.
> > 
> > Subject: "io_uring: return back safer resurrect"
> > 
> > Upstream commit:: f70865db5ff35f5ed0c7e9ef63e7cca3d4947f04
> 
> It only applies to 5.10.y.  It showed up in 5.12, so if you want it
> further back than 5.10.y, can you provide a working backport?

Works for me, thanks.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
