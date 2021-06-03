Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B6339AC63
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 23:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhFCVNX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 17:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhFCVNW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 17:13:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E3FC06174A;
        Thu,  3 Jun 2021 14:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hASCP7pHqQqG24knh1Q6TwkoGipOWGOlEtraDIcDlxw=; b=SagGSlPLKjwrJvb8ARgvCI2j2K
        vPfqJl2bG8KJ+57doGN3bnQ26kMdnBMCqa5iZYGIW2i8C76HBzivKKZ7xzlADrf5Xpz1yy/y30JfW
        Wz1Bdt03VWe8T19Bq9LKsUmlg3zM8IeM5R2YUS+fVMDo0wEjkRxq8sf6r8qeqTL8UIQFXfDzCCngP
        64Qnnfs/8SVv1cIP50FN4GwQEiWbuTf3xCQQC9do8rcOKXownancib17qfyd1lEdYWof+CrafvrLd
        LpCFIxi9k/h4/YHaSBOTA+INlfpMl5sOZZRuCP2VYNUZZF5/IMmuNbB3Y6tjwL+5O9zK5j4cQQxCy
        p9Xf9epw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1loubV-00CYoK-PX; Thu, 03 Jun 2021 21:10:39 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id C64A0986EEC; Thu,  3 Jun 2021 23:10:12 +0200 (CEST)
Date:   Thu, 3 Jun 2021 23:10:12 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andres Freund <andres@anarazel.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/4] io_uring: implement futex wait
Message-ID: <20210603211012.GA68208@worktop.programming.kicks-ass.net>
References: <cover.1622558659.git.asml.silence@gmail.com>
 <e91af9d8f8d6e376635005fd111e9fe7a1c50fea.1622558659.git.asml.silence@gmail.com>
 <bd824ec8-48af-b554-67a1-7ce20fcf608c@kernel.dk>
 <409a624c-de75-0ee5-b65f-ee09fff34809@gmail.com>
 <bdc55fcd-b172-def4-4788-8bf808ccf6d6@kernel.dk>
 <5ab4c8bd-3e82-e87b-1ae8-3b32ced72009@gmail.com>
 <87sg211ccj.ffs@nanos.tec.linutronix.de>
 <20210603190338.gfykgkc7ac2akvdt@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603190338.gfykgkc7ac2akvdt@alap3.anarazel.de>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 03, 2021 at 12:03:38PM -0700, Andres Freund wrote:
> On 2021-06-01 23:53:00 +0200, Thomas Gleixner wrote:
> > You surely made your point that this is well thought out.
> 
> Really impressed with your effort to generously interpret the first
> version of a proof of concept patch that explicitly was aimed at getting
> feedback on the basic design and the different use cases.

You *completely* failed to describe any. I'm with tglx; I see no reason
to even look at the patches. If you don't have a problem, you don't need
a solution.
