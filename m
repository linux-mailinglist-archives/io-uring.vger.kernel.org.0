Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B70761AED
	for <lists+io-uring@lfdr.de>; Tue, 25 Jul 2023 16:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjGYOG1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Jul 2023 10:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbjGYOG0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Jul 2023 10:06:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDBB1BD6;
        Tue, 25 Jul 2023 07:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BPtKOmxez51uKAQ5bimFSFsRk3Pz5ZRLzvPzUPZ9CYg=; b=HuT/B5bV60wd9SZEDcouz3w1w9
        xT6Fs7fYyH374GTkEhAWHYNgH44jtsnhgFScRE8ezoNmpO7Bg2nbQKv1Yt/ojpDWkavNKwgKuRJ3V
        oE6xhB2s8tp07ufZtaLX/VHhG1dl3GhRFHwXnAko5UWCrwzAfIzlyfa17Xd8YFa+obLLMBOqr6oTl
        QeEckAkcMbFlKcpXXgs2BjUPHz89tLBBkReiVy7r8054DV0tIV9CF7AyvtWnzCFG37oTbz9rPBvyM
        lUErzAHihzRxzET3obp0FMe+8Lu25W9+85lfMudlzXDTtR2IbNbgz9/VXy+UZsomBEI6gYBzazlxf
        bAXlaUnw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qOIg9-005WxA-6B; Tue, 25 Jul 2023 14:06:21 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 280AD300155;
        Tue, 25 Jul 2023 16:06:20 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D86242B20499D; Tue, 25 Jul 2023 16:06:20 +0200 (CEST)
Date:   Tue, 25 Jul 2023 16:06:20 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        andres@anarazel.de
Subject: Re: [PATCH 06/10] io_uring: add support for futex wake and wait
Message-ID: <20230725140620.GO3765278@hirez.programming.kicks-ass.net>
References: <20230720221858.135240-1-axboe@kernel.dk>
 <20230720221858.135240-7-axboe@kernel.dk>
 <20230721113031.GG3630545@hirez.programming.kicks-ass.net>
 <20230721113718.GA3638458@hirez.programming.kicks-ass.net>
 <d95bfb98-8d76-f0fd-6283-efc01d0cc015@kernel.dk>
 <94b8fcc4-12b5-8d8c-3eb3-fe1e73a25456@kernel.dk>
 <20230725130015.GI3765278@hirez.programming.kicks-ass.net>
 <28a42d23-6d70-bc4c-5abc-0b3cc5d7338d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28a42d23-6d70-bc4c-5abc-0b3cc5d7338d@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 25, 2023 at 07:48:30AM -0600, Jens Axboe wrote:

> I think I'll just have prep and prepv totally separate. It only makes
> sense to share parts of them if one is a subset of the other. That'll
> get rid of the odd conditionals and sectioning of it.

Ah, yes. Fair enough.
