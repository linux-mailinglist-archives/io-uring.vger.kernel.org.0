Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4AC752075
	for <lists+io-uring@lfdr.de>; Thu, 13 Jul 2023 13:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbjGMLyW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Jul 2023 07:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbjGMLyW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Jul 2023 07:54:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C40B1BF8;
        Thu, 13 Jul 2023 04:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=F3pTCA7tlTfpj9gjnswLBOleJGD+Fse0a7G/2qDmNGo=; b=um4RNs0TyNXdbBJjFIQSqtvr9b
        jkpr3w2moIQwN8c2yhLQQh4Ct/pOJAbxFpPHRg+n9Mwtktcae73NNukbsZl+GGskelKOVRsbdSaHm
        3+DhIOKRuLTVXIYGmNa1jug0jiRNAJbNyyZPFx7kxohRxvJK2AkI8Ju1uet+6aEIZ8zmwtIxNAmun
        xHTvTI0/sG2mHAva8nAXInXRbaN/tCoZDCrPKQoNtloxKgMNKt4FPwyv52G28TFoLT9D84upnPBoI
        000F2L+BZgyH8g5Q+x+p+ml9Fb/dwtWpou5w3DQGCY0xx3yWPqx4EmeQoD0amZrfUMJ/WGe01aDpJ
        jbsj85zg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qJuth-0006k1-Ly; Thu, 13 Jul 2023 11:54:13 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 362FC3002CE;
        Thu, 13 Jul 2023 13:54:12 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1F7B02C4905B6; Thu, 13 Jul 2023 13:54:12 +0200 (CEST)
Date:   Thu, 13 Jul 2023 13:54:12 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, andres@anarazel.de
Subject: Re: [PATCH 8/8] io_uring: add support for vectored futex waits
Message-ID: <20230713115412.GI3138667@hirez.programming.kicks-ass.net>
References: <20230712162017.391843-1-axboe@kernel.dk>
 <20230712162017.391843-9-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712162017.391843-9-axboe@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 12, 2023 at 10:20:17AM -0600, Jens Axboe wrote:
>  int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
> +int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
>  int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags);
> +int io_futex_waitv(struct io_kiocb *req, unsigned int issue_flags);
>  int io_futex_wake(struct io_kiocb *req, unsigned int issue_flags);

That's an inconsistent naming convention.. I'll stare at the rest later.
