Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353434CB04B
	for <lists+io-uring@lfdr.de>; Wed,  2 Mar 2022 21:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237277AbiCBUwl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Mar 2022 15:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbiCBUwk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Mar 2022 15:52:40 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B536005E;
        Wed,  2 Mar 2022 12:51:56 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id g7-20020a17090a708700b001bb78857ccdso5871373pjk.1;
        Wed, 02 Mar 2022 12:51:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dPwpOA3dlf+QjLGZg4hJmQgB+HaIen/E3co4VabBIO0=;
        b=0cJ93QzI+mxJq7HD74Tmvm0MtzGHWh4rWBJcf7JyDmnqxGh2YISXTHLN0ZJfSwWnzc
         hAJVtssSyYA9PEtIj6nM0SXnx56jQVe0n0lK8gcyEXVC9xBvFaaUVX4xkNrI2/eyBq5T
         ZRqFMeieluevNJqZTbBlzOI0thWw9rSgltxPnbE+uBChl2vyRVkxv4mbhc+7Z6QeNjSH
         fL2AhW4yMjglUtyqSFVMxJVloEKQpVsTV7JBzvj0Dw9N0rIooxlwjH3T69W42azfDFAd
         tLPWMUmlPSR66ynD/8iR19Xm3cvqGMAvYFfWWiiNYiAj1OzBFNi5bdWiKdkHVTZ21c6E
         j2pA==
X-Gm-Message-State: AOAM530dnmxti3+tvm5MwomXXIHsUc/qAnsslDIo6xzQeHHorNf292XT
        BTPsZjlm+MRuIsGhtl1bFEM=
X-Google-Smtp-Source: ABdhPJwzgpXKdWzWCPNEiMTVvwvSfu+YBTWnIewxSzHltR/uF+7LfUo5oePNVku1wMQwhNQb/c88KQ==
X-Received: by 2002:a17:90a:2e0a:b0:1be:d5a0:cc5a with SMTP id q10-20020a17090a2e0a00b001bed5a0cc5amr1688125pjd.120.1646254315591;
        Wed, 02 Mar 2022 12:51:55 -0800 (PST)
Received: from garbanzo (136-24-173-63.cab.webpass.net. [136.24.173.63])
        by smtp.gmail.com with ESMTPSA id w17-20020a056a0014d100b004f1063290basm77192pfu.15.2022.03.02.12.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 12:51:54 -0800 (PST)
Date:   Wed, 2 Mar 2022 12:51:51 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "hch@infradead.org" <hch@infradead.org>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Kanchan Joshi <joshiiitr@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        Matthew Wilcox <willy@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        "Remzi H. Arpaci-Dusseau" <remzi@cs.wisc.edu>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
Message-ID: <20220302205151.76f6wfqb2t3llnvf@garbanzo>
References: <e871eef2-8a93-fdbc-b762-2923526a2db4@gmail.com>
 <80d27717-080a-1ced-50d5-a3a06cf06cd3@kernel.dk>
 <da4baa8c-76b0-7255-365c-d8b58e322fd0@gmail.com>
 <65a7e9a6-aede-31ce-705c-b7f94f079112@kernel.dk>
 <d4f9a5d3-1df2-1060-94fa-f77441a89299@gmail.com>
 <CA+1E3rJ3SoLU9aYcugAQgJnSPnJtcCwjZdMREXS3FTmXgy3yow@mail.gmail.com>
 <f030a338-cd52-2e83-e1da-bdbca910d49e@kernel.dk>
 <CA+1E3rKxZk2CatTuPcQq5d14vXL9_9LVb2_+AfR2m9xn2WTZdg@mail.gmail.com>
 <MWHPR04MB3758DC08EA17780E498E9EC0E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731064526.GA25674@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731064526.GA25674@infradead.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 31, 2020 at 07:45:26AM +0100, hch@infradead.org wrote:
> On Fri, Jul 31, 2020 at 06:42:10AM +0000, Damien Le Moal wrote:
> > > - We may not be able to use RWF_APPEND, and need exposing a new
> > > type/flag (RWF_INDIRECT_OFFSET etc.) user-space. Not sure if this
> > > sounds outrageous, but is it OK to have uring-only flag which can be
> > > combined with RWF_APPEND?
> > 
> > Why ? Where is the problem ? O_APPEND/RWF_APPEND is currently meaningless for
> > raw block device accesses. We could certainly define a meaning for these in the
> > context of zoned block devices.
> 
> We can't just add a meaning for O_APPEND on block devices now,

Make sense.

Is a new call system call for nameless writes called for instead then?
Then there is no baggage. Or is this completely stupid?

> as it was previously silently ignored.  I also really don't think any
> of these semantics even fit the block device to start with.  If you
> want to work on raw zones use zonefs, that's what is exists for.

Using zonefs adds a slight VFS overhead. Fine if we want to live with
that, but I have a feeling if we want to do something like just testing
hot paths alone to compare apples to apples we'd want something more
fine grained.

  Luis
