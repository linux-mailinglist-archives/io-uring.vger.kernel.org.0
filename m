Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6DE1F00E4
	for <lists+io-uring@lfdr.de>; Fri,  5 Jun 2020 22:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgFEUUc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Jun 2020 16:20:32 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39263 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727888AbgFEUUb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Jun 2020 16:20:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1AE195C0220;
        Fri,  5 Jun 2020 16:20:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 05 Jun 2020 16:20:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=8Sd1UA1Rns+FZI+rH9tZEZ2IbKv
        SUgm8eaWOiwmGMC8=; b=CYyUKr+cO6vvvvogBSjD7SEC+fPs3Xb1tiB713CUmOs
        sSAaerBO+ZIVw3+7W6PZnzHNsYokYVNpPWTL+/zej91AG2Zq8fhvX7J9KanCHMxe
        R94tl+3O84jhCrVWXgeb3mgEhV2lwo5y2L9ZF26AMOLND8nvo0QmgobuwANl+rOt
        VD7dKBSFqvhXQwiV646tJsRXMROxvXG+sRyHmOiWfW7rkvHjsQ++Urql77JiVBtx
        hCvQ8fQFO/mZOKQFR3g/RLGeCwk/1sR6HppJDATKuddJfz1sLg5btPuJ+7B0rl4f
        seAYzdRg1uBhfde6g8jzB4wOfF/3swDI+qfEnkQtwNA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8Sd1UA
        1Rns+FZI+rH9tZEZ2IbKvSUgm8eaWOiwmGMC8=; b=PUtcQybQ3jvq32TUdtaGAS
        RvYBKMPsTJvQSAIfdV5WVamdWY/ccUa86zTzaO+uBV43v5PfxsPotr0zdlhrZWIu
        js867QqmxU6BbRv7VVQv+B9rzQGewcNkJwKShQrpCyDX2Z4OzRDqEKzyerHN54FL
        iuFGKK/JT5PWOVARk9J356UOiNOE3IE4W8RpkWlD3hiMz1WGLqbAjxSO0SWqj33k
        1dAFCgn4VXOv/w1marpHVi3XQvAcrmQB4rVJ3LgYItDMd0fdreavXo0yqPwri3sq
        P4qN4kkeoX03CpRPt3scGazakPfJopdF1bThEPKi0CzK303dL63ea+Rog+L8FyTg
        ==
X-ME-Sender: <xms:DanaXht9nnHmxWnUt2tKRz69a0r4KA1CqZAOU-fnncRZvMjpjo9j-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudegfedgudefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughr
    vghsucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrf
    grthhtvghrnhepudekhfekleeugeevteehleffffejgeelueduleeffeeutdelffeujeff
    hfeuffdunecukfhppeeijedrudeitddrvddujedrvdehtdenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghl
    rdguvg
X-ME-Proxy: <xmx:DanaXqeiu8tQRsABRV8_lZbR07zTJMpDENVsamfmk7xk6GoyH1dgKw>
    <xmx:DanaXkyjWg6PZOo4CWKJVo_5qlTrODKvfeDZZZr-s-Ur9fZpJUnSHQ>
    <xmx:DanaXoM7QUID-BWRt8NG4YwtgammkbvYN9golX0bJli0ngvBCazEuw>
    <xmx:DqnaXjK_qwqjPyfEWkC1gGFB-m7mK9VAq6bHgABFniYw4JYE2G-16g>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6381530614FA;
        Fri,  5 Jun 2020 16:20:29 -0400 (EDT)
Date:   Fri, 5 Jun 2020 13:20:28 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
Message-ID: <20200605202028.d57nklzpeolukni7@alap3.anarazel.de>
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200604005916.niy2mejjcsx4sv6t@alap3.anarazel.de>
 <e3072371-1d6b-8ae5-d946-d83e60427cb0@kernel.dk>
 <6eeff14f-befc-a5cc-08da-cb77f811fbdf@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6eeff14f-befc-a5cc-08da-cb77f811fbdf@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-06-05 08:42:28 -0600, Jens Axboe wrote:
> Can you try with async-buffered.7? I've rebased it on a new mechanism,
> and doing something like what you describe above I haven't been able
> to trigger anything bad. I'd try your test case specifically, so do let
> know if it's something I can run.

I tried my test on async-buffered.7?, and I get hangs very quickly after
starting. Unfortunately, I don't seem to get an OOPSs, not sure yet why.

Let me know if my test triggers for you.

I'll go and try to figure out why I don't see an oops...

Regards,

Andres
