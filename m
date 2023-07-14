Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53540753E6D
	for <lists+io-uring@lfdr.de>; Fri, 14 Jul 2023 17:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236206AbjGNPI7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Jul 2023 11:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235235AbjGNPI6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Jul 2023 11:08:58 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534A62700;
        Fri, 14 Jul 2023 08:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bk+FJ5y1FZ468j4zK+Q82PqwGRIC7IeBtGlwB2J1sZs=; b=fHeliTIg/93p/aGBuNLOKhpw0x
        iXwrkANZc+tyWcCQW/N4ZSJbiUz/RgbCWGFB2M08Fu15z/dAjUOST4IdJrMRTbS5iNkAeccse7aSe
        ++enCI5aLk+oyR2by2+xAWKkNYJ9yrjmxlXVKdxXJUXgmBpIR5hSzPPz3R+Xe9Z6WoDEwyM4FkGxz
        AGExAhgx9QmUQwWh+bQ1MW/0GTRkvIxv6adgXqw28E2k9/haA6o7Ok1mPQJC5ABXL+7Oge/P9/GhX
        +4ntawyskutGsajeaQsOhxrdmIJvYRTMEfauXYHrmpSdIG0IEGxVgjZFTy7g8d+8sldaiFfo1+mjQ
        JEm56Fag==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qKKPb-006JCe-1Y;
        Fri, 14 Jul 2023 15:08:51 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1DC733001E7;
        Fri, 14 Jul 2023 17:08:50 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CA10721372B62; Fri, 14 Jul 2023 17:08:50 +0200 (CEST)
Date:   Fri, 14 Jul 2023 17:08:50 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, andres@anarazel.de
Subject: Re: [PATCH 4/8] io_uring: add support for futex wake and wait
Message-ID: <20230714150850.GB3261758@hirez.programming.kicks-ass.net>
References: <20230712162017.391843-1-axboe@kernel.dk>
 <20230712162017.391843-5-axboe@kernel.dk>
 <20230713111513.GH3138667@hirez.programming.kicks-ass.net>
 <20230713172455.GA3191007@hirez.programming.kicks-ass.net>
 <bcf174d8-607b-e61a-2091-eccd3ffe0dfe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcf174d8-607b-e61a-2091-eccd3ffe0dfe@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 14, 2023 at 08:52:40AM -0600, Jens Axboe wrote:
> Saw your series - I'll take a look. In terms of staging when we get
> there, would it be possible to split your flags series into the bare
> minimum and trivial, and then have that as a dependency for this series
> and the rest of your series?

I think you only really need the first three patches, and I hope those
are the least controversial of the lot.

After those, I can implement the extra flags independently of the
io_uring thing and all interfaces should just have it work.

So yes :-)
