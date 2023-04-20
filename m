Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7016E966F
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 15:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbjDTN6G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Apr 2023 09:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbjDTN6D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Apr 2023 09:58:03 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40198558E;
        Thu, 20 Apr 2023 06:58:01 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id m39-20020a05600c3b2700b003f170e75bd3so3482250wms.1;
        Thu, 20 Apr 2023 06:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681999079; x=1684591079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oEmb+1bwuYnnNU5r4quSTraRp3g5AOWVk+rl/hJBlk8=;
        b=BnxS83v9fLmQmx2NeV6rGv+8NbAQfyda+oSLfNV+sRgnQaNRUr24+dwvGImmpimdmN
         NcchPObPAIQtXFE8RJmtBQ1x1VE0OgZVYPg+847d2Rl7HVEhqxb2UlVJU1hb3iSm6+36
         6wqHmiedOJiTkilo9GF7wxFz776sv/SE2eCD9VhyJgo1dWvrSM0PcTAB1rzw7dIO9FVG
         HNDpKpzdIShyAXHx4toc7S6LUHsc1gY2c8alIO/ESIFbSQKLno0Q4D2ABkP/3MPEwT4K
         U4X5R23aA8JU3Ajkmbj7segCEpfPzom0ThjYOWQlzWVpc7a+IYfEohAlVeo+8a5LsPDQ
         CLmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681999079; x=1684591079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEmb+1bwuYnnNU5r4quSTraRp3g5AOWVk+rl/hJBlk8=;
        b=i9msxFtFPWaBXuccaXzYXFe1xfBpoYBmIfOwa2rn6LiV4SAMBZw3mW6k/hjr6waI58
         IBfTg/YF9eh3BQhAcz/7s7yxllssy+SuGM8CoNCwv4JOK7TZRovC5D1PkoL/QNAawhAd
         UhX1Q6vRUH/BEq2PJGvD8hQRPfUHKBufc6YI8+CLn5R7UB3JlP0Xj1LV0eN8gDBI0Yt3
         3EcVRFKxe9yaLXGAkcj2znxDbaiWssOYNQ8tplzlufW2S0agwFOMkSgaoPsLIm+fX+Nh
         FhxrDAOpYT3HjYl34zLsICW02qGvqIOrAdC8Er0vL0TVRDJvUqKHj8+MSMvKeZH4ENPT
         LQKQ==
X-Gm-Message-State: AAQBX9fN9eA2ytfUjzvdkZNG0O2J07pjrRJDHRqRYhLIFshHB4a+kJY1
        /GM3y29jD/y0WUV2gqdPHUE=
X-Google-Smtp-Source: AKy350be+T3njI9C+iVjqfH2dZsecnvHqaLzbCqm2MFL62XeCONJvIni1XXzLmfMDsWfS4VDtcyP6Q==
X-Received: by 2002:a05:600c:2101:b0:3f1:7c38:719b with SMTP id u1-20020a05600c210100b003f17c38719bmr1528648wml.3.1681999079211;
        Thu, 20 Apr 2023 06:57:59 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id m6-20020adfdc46000000b002d45575643esm2047200wrj.43.2023.04.20.06.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 06:57:58 -0700 (PDT)
Date:   Thu, 20 Apr 2023 14:57:57 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Message-ID: <5ead8d8c-6f47-4db1-b1da-ffaaee4be255@lucifer.local>
References: <f82b9025-a586-44c7-9941-8140c04a4ccc@lucifer.local>
 <69f48cc6-8fc6-0c49-5a79-6c7d248e4ad5@kernel.dk>
 <bec03e0f-a0f9-43c3-870b-be406ca848b9@lucifer.local>
 <8af483d2-0d3d-5ece-fb1d-a3654411752b@kernel.dk>
 <d601ca0c-d9b8-4e5d-a047-98f2d1c65eb9@lucifer.local>
 <ZEAxhHx/4Ql6AMt2@casper.infradead.org>
 <ZEAx90C2lDMJIux1@nvidia.com>
 <ZEA0dbV+qIBSD0mG@casper.infradead.org>
 <8bf0df41-27ef-4305-b424-e43045a6d68d@lucifer.local>
 <ZEB3y0V2GSDcUMc2@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEB3y0V2GSDcUMc2@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 19, 2023 at 08:22:51PM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 19, 2023 at 07:45:06PM +0100, Lorenzo Stoakes wrote:
>
> > For example, imagine if a user (yes it'd be weird) mlock'd some pages in a
> > buffer and not others, then we'd break their use case. Also (perhaps?) more
> > feasibly, a user might mix hugetlb and anon pages. So I think that'd be too
> > restrictive here.
>
> Yeah, I agree we should not add a broad single-vma restriction to
> GUP. It turns any split of a VMA into a potentially uABI breaking
> change and we just don't need that headache in the mm..
>
> > I do like the idea of a FOLL_SINGLE_VMA for other use cases though, the
> > majority of which want one and one page only. Perhaps worth taking the
> > helper added in this series (get_user_page_vma_remote() from [1]) and
> > replacing it with an a full GUP function which has an interface explicitly
> > for this common single page/vma case.
>
> Like I showed in another thread a function signature that can only do
> one page and also returns the VMA would force it to be used properly
> and we don't need a FOLL flag.
>

Indeed the latest spin of the series uses this. The point is by doing so we
can use per-VMA locks for a common case, I was thinking perhaps as a
separate function call (or perhaps just reusing the wrapper).

This would be entirely separate to all the other work.

> Jason
