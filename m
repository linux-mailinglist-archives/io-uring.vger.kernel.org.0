Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64EA775C5F2
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 13:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjGULhX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 07:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjGULhW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 07:37:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6871FD7;
        Fri, 21 Jul 2023 04:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WbXBfPIkhbRXSx7JCY1YuxFoFBDWeDkqr+fiypH+7Gg=; b=kad7YUfCJCdkX0gVyWdYVA6gd7
        6LzofKqncU2csm62J4mWVYVisWb0H50dBjn+oz2gU8lJvQV6dgzUQDU1ISsoiGa2vkmdLtQoHIj/D
        ppNzsHujmT4lMdX1U6srx1pzIOpWEuZxzy9d3qNNUBs4h5WAXIIj+77EtY7+0asnE8p3KLm9bxehr
        eZz+98XcXhELd8U1+XQ+rwy3s53K7+AdGEvAyz0OdQR09IFJOJGsgx3J7lNlvgAzcTyLsl1t2YCxZ
        gdB7c6IHKWx88LIfwy6cKW78pqRadTSZI26uSIbokN2XUW8neJeVCrqjhhUquRFOTG4sDTZgAlgRR
        DPgsN7zA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qMoRi-0014Fe-A3; Fri, 21 Jul 2023 11:37:18 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 592BD300195;
        Fri, 21 Jul 2023 13:37:18 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3BBDD264557E3; Fri, 21 Jul 2023 13:37:18 +0200 (CEST)
Date:   Fri, 21 Jul 2023 13:37:18 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        andres@anarazel.de
Subject: Re: [PATCH 06/10] io_uring: add support for futex wake and wait
Message-ID: <20230721113718.GA3638458@hirez.programming.kicks-ass.net>
References: <20230720221858.135240-1-axboe@kernel.dk>
 <20230720221858.135240-7-axboe@kernel.dk>
 <20230721113031.GG3630545@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230721113031.GG3630545@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 21, 2023 at 01:30:31PM +0200, Peter Zijlstra wrote:

Sorry, I was too quick..

	iof->uaddr = sqe->addr;
	iof->val   = sqe->futex_val;
	iof->mask  = sqe->futex_mask;
	flags      = sqe->futex_flags;

	if (flags & ~FUTEX2_MASK)
		return -EINVAL;

	iof->flags = futex2_to_flags(flags);
	if (!futex_flags_valid(iof->flags))
		return -EINVAL;

	if (!futex_validate_input(iof->flags, iof->val) ||
	    !futex_validate_input(iof->flags, iof->mask))
		return -EINVAL


