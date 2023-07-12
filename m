Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75E4750321
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 11:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbjGLJcD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 05:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbjGLJb6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 05:31:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3525170E;
        Wed, 12 Jul 2023 02:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1NES0FBGbCJEuBDLLpuM1qLJflryX6djz/7RZ/xzrDM=; b=BlrY/whatP2X2PV+0WGmmBqDBf
        dxu95sAXYZQQFWopDgpYejmAN+hVRNDFPxjaIT30vS8iYjSkFLKp+amG4tChZyx1y2BbqpwL5sFVX
        kvuHpeqnzeKTk7WrEDaIhjqCQH34Wot5Yf9+oJLZEBlmRuyQ3ri/M4ROGnBC+y+B1/my6cvK5LE7O
        tU0oDoRsuZwL/ZzvGMZv+8CghkFgoVg1XRNfIFl6FLBtlmbZym5isY8019eo41bfl5m5+mxeGfu88
        +ui9fIn/0SRHUJNZyxIbRtR4c8u869tM2BESxy57ND+Les2UKgsLvXPxnt3dkJVnQbwBjXX1TWpkH
        TW+2uXNA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qJWCP-00GXcO-NZ; Wed, 12 Jul 2023 09:31:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DD15630036B;
        Wed, 12 Jul 2023 11:31:52 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C6A0A2440832A; Wed, 12 Jul 2023 11:31:52 +0200 (CEST)
Date:   Wed, 12 Jul 2023 11:31:52 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH 7/7] io_uring: add futex waitv
Message-ID: <20230712093152.GF3100107@hirez.programming.kicks-ass.net>
References: <20230712004705.316157-1-axboe@kernel.dk>
 <20230712004705.316157-8-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712004705.316157-8-axboe@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 11, 2023 at 06:47:05PM -0600, Jens Axboe wrote:
> Needs a bit of splitting and a few hunks should go further back (like
> the wake handler typedef).
> 
> WIP, adds IORING_OP_FUTEX_WAITV - pass in an array of futex addresses,
> and wait on all of them until one of them triggers.
> 

So I'm once again not following. FUTEX_WAITV is to wait on multiple
futexes and get a notification when any one of them wakes up with an
index to indicate which one.

How exactly is that different from multiple FUTEX_WAIT entries in the
io_uring thing itself? Admittedly I don't actually know much of anything
when it comes to io_uring, but isn't the idea that queue multiple
'syscall' like things and get individual completions back?

So how does WAITV make sense here?
