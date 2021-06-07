Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AFB39DBB5
	for <lists+io-uring@lfdr.de>; Mon,  7 Jun 2021 13:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhFGLup (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Jun 2021 07:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbhFGLuo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Jun 2021 07:50:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75A9C061766;
        Mon,  7 Jun 2021 04:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2PdD+uZkEIFyxVLFUWbMDdnRWGm9uGD+q1DCn4KEBK4=; b=XKFQnZaVgxCnah3Wz+h3maJZqX
        0LDGmKOJlx8eg9N4zZRzZXA77bXMfxzDuxZtVHDk3kXz9TlupQ8oIlMQ9A1AAO7DpTCCf6yQlVd6U
        xgCMD2PzA4RihWKDCwjKQQqDjWpl58WBDQnEvYa+60o+1sCZo6y4vC8uGFVHX7/sW6M9MIAJ4Bq1w
        rhHf9mMy8gZYoODWKFnmaJrRAkU5GHjltQsF3bwLMWVIIcjXvfgXAJ5NRc6K9ioRKXynxqJ8GQ7Wq
        lvJsLFGblWWUEpHhcTPYv57SXoUvOlMV1WH38fvlD0crItxycJyvW3p5JY8qBcH8krpdAllCjo4CM
        RAslP1Zg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lqDk4-00Fh8A-0r; Mon, 07 Jun 2021 11:48:30 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id EFA2230018A;
        Mon,  7 Jun 2021 13:48:26 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9B1162DBA4A0B; Mon,  7 Jun 2021 13:48:26 +0200 (CEST)
Date:   Mon, 7 Jun 2021 13:48:26 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Andres Freund <andres@anarazel.de>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/4] io_uring: implement futex wait
Message-ID: <YL4Hiq+2rMGYrQAH@hirez.programming.kicks-ass.net>
References: <cover.1622558659.git.asml.silence@gmail.com>
 <e91af9d8f8d6e376635005fd111e9fe7a1c50fea.1622558659.git.asml.silence@gmail.com>
 <bd824ec8-48af-b554-67a1-7ce20fcf608c@kernel.dk>
 <409a624c-de75-0ee5-b65f-ee09fff34809@gmail.com>
 <bdc55fcd-b172-def4-4788-8bf808ccf6d6@kernel.dk>
 <5ab4c8bd-3e82-e87b-1ae8-3b32ced72009@gmail.com>
 <87sg211ccj.ffs@nanos.tec.linutronix.de>
 <20210603190338.gfykgkc7ac2akvdt@alap3.anarazel.de>
 <87v96tywcb.ffs@nanos.tec.linutronix.de>
 <131a59af-a625-27b3-433e-ff8b7c36753e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <131a59af-a625-27b3-433e-ff8b7c36753e@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jun 07, 2021 at 12:31:48PM +0100, Pavel Begunkov wrote:
> On 6/5/21 1:43 AM, Thomas Gleixner wrote:
> > Andres,
> > 
> > On Thu, Jun 03 2021 at 12:03, Andres Freund wrote:
> >> On 2021-06-01 23:53:00 +0200, Thomas Gleixner wrote:
> >>> You surely made your point that this is well thought out.
> >>
> >> Really impressed with your effort to generously interpret the first
> >> version of a proof of concept patch that explicitly was aimed at getting
> >> feedback on the basic design and the different use cases.
> > 
> > feedback on what?
> > 
> > There is absolutely no description of design and obviously there is no
> > use case either. So what do you expect me to be generous about?
> 
> That's a complete fallacy, the very RFC is about clarifying a
> use case that I was hinted about, not mentioning those I described
> you in a reply. Obviously

Then consider this:

Nacked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

for anything touching futex.c, until such time that you can provide a
coherent description of what and why you're doing things.

