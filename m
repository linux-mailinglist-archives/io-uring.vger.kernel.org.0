Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7590798B14
	for <lists+io-uring@lfdr.de>; Fri,  8 Sep 2023 18:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245274AbjIHQz6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Sep 2023 12:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjIHQz6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Sep 2023 12:55:58 -0400
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6514D2680;
        Fri,  8 Sep 2023 09:55:22 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-501bd6f7d11so3717994e87.1;
        Fri, 08 Sep 2023 09:55:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694192117; x=1694796917;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S7URpEOHyiyMnwkk7ulREI14OY8DCzbtRusyfBiWSJI=;
        b=JX9O/7ttTg/xcwDACP4i8TiPwkW72lCHbJBUpidhcG3J0uhcHeQ3YXmfHKiF27E+6D
         VgqenuePm878MxAAlnZOlzt7k1suf9K20AFk3mN9bpves/xorl7yCyMXUBmiWb8R28JW
         AkGd9A2cXnPoGrFHoYL5EM4H+x3XfHjEjozu1su5C2+5/69os4mV0HSdA+2wcfLqp+7H
         Su3aFYh0tAQ2h2cekOQRT/+MtDiVH8PQR4zKJodDq4xkkq9s4RQx+7mPOSChJOwc6Mhp
         SlC+FDuCi0wpEY+pxCK7BbGfYHPKKd+Ys63nfCOvc/eBSu34vh24ErcY6DE3TnIUclNo
         /hDg==
X-Gm-Message-State: AOJu0YxxLaZk5f/7H/iYU2WgVWgBscNQZA8QUZuYAKn8qfFqb1Wu6aR/
        S3VANbOEuIOcQSN7Dyw35QM=
X-Google-Smtp-Source: AGHT+IGHljrhvnrA7HLF8GAewGPNt9+isjVnu7yHq1p/pbkFl2qUisWBb7baIwcEX4XP0OE7pSgnyA==
X-Received: by 2002:a05:6512:3f15:b0:500:aa41:9d67 with SMTP id y21-20020a0565123f1500b00500aa419d67mr3016978lfa.8.1694192116925;
        Fri, 08 Sep 2023 09:55:16 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-118.fbsv.net. [2a03:2880:31ff:76::face:b00c])
        by smtp.gmail.com with ESMTPSA id z7-20020a1709060ac700b0099bc08862b6sm1276320ejf.171.2023.09.08.09.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Sep 2023 09:55:16 -0700 (PDT)
Date:   Fri, 8 Sep 2023 09:55:11 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        krisman@suse.de, bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v4 00/10] io_uring: Initial support for {s,g}etsockopt
 commands
Message-ID: <ZPtR7+8YOWmtZHuD@gmail.com>
References: <20230904162504.1356068-1-leitao@debian.org>
 <20230905154951.0d0d3962@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230905154951.0d0d3962@kernel.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 05, 2023 at 03:49:51PM -0700, Jakub Kicinski wrote:
> On Mon,  4 Sep 2023 09:24:53 -0700 Breno Leitao wrote:
> > Patches 1-2: Modify the BPF hooks to support sockptr_t, so, these functions
> > become flexible enough to accept user or kernel pointers for optval/optlen.
> 
> Have you seen:
> 
> https://lore.kernel.org/all/CAHk-=wgGV61xrG=gO0=dXH64o2TDWWrXn1mx-CX885JZ7h84Og@mail.gmail.com/

I haven't but I think it will not affect *much* this patchset.

> ? I wasn't aware that Linus felt this way, now I wonder if having
> sockptr_t spread will raise any red flags as this code flows back
> to him.

I can change the io_uring API in a way that we can avoid these
sockptr_t changes completely.

My plan is to mimic what getsockopt(2) is doing in io_uring cmd path, in
regard to optlen being an userpointer, instead of a value - which is
then translated to a KERNEL_SOCKPTR.

In this way, this change don't need to touch any sockptr field.

Thanks for the heads-up
