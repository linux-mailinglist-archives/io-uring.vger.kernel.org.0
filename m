Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80F63D7485
	for <lists+io-uring@lfdr.de>; Tue, 27 Jul 2021 13:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbhG0Loq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Jul 2021 07:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236108AbhG0Loq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Jul 2021 07:44:46 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF6AC061757;
        Tue, 27 Jul 2021 04:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vgz6xZbu8ydympU3buBA+LPDyvScpUJKEV3iVNsITUA=; b=lTb4KXEdt+PWAKwbmpEy/LxOgE
        kjKGE02xWknIhEzpTW7J6xZAeO/7na6bEZtsTQC4b9GFBayqWkVHQ4aE/psQ7eUYArbE62lAJeVyb
        TvPpefUNjwkrag7BlAb+Ax3tdyiwmh1u8dHBZ1SLpBTUk55KvTZx2s8+ZZ7XSFvWagKgQ8f8QTZ4X
        UOcrRDhjixAHq7yjiCH8tywADA55uQRK8SyF6x/iJbA+/3zVpS19DYP86BQDs1t1f0bZFkSpvtwwo
        3Ku/3ZWBTokqTszv4rwFFMA3YNF1tKOSJOs1DWVowDPue4anz0bRQZGkJfQh4iU4aQGaEk8iCQehd
        bQK1AAtA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m8LVQ-003Qmb-Ck; Tue, 27 Jul 2021 11:44:16 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2EF64300215;
        Tue, 27 Jul 2021 13:44:15 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id F06C12023C23F; Tue, 27 Jul 2021 13:44:14 +0200 (CEST)
Date:   Tue, 27 Jul 2021 13:44:14 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>, paulmck <paulmck@kernel.org>
Subject: Re: [PATCH] tracepoints: Update static_call before tp_funcs when
 adding a tracepoint
Message-ID: <YP/xjnGx+CRYr5RR@hirez.programming.kicks-ass.net>
References: <20210722223320.53900ddc@rorschach.local.home>
 <715282075.6481.1627314401745.JavaMail.zimbra@efficios.com>
 <20210726125604.55bb6655@oasis.local.home>
 <682927571.6760.1627321158652.JavaMail.zimbra@efficios.com>
 <20210726144903.7736b9ad@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726144903.7736b9ad@oasis.local.home>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 26, 2021 at 02:49:03PM -0400, Steven Rostedt wrote:
> OK. I see the issue you are saying. And this came from my assumption
> that the tracepoint code did a synchronization when unregistering the
> last callback. But of course it wont because that would make a lot of
> back to back synchronizations of a large number of tracepoints being
> unregistered at once.
> 
> And doing it for all 0->1 or 1->0 or even a 1->0->1 can be costly.
> 
> One way to handle this is when going from 1->0, set off a worker that
> will do the synchronization asynchronously, and if a 0->1 comes in,
> have that block until the synchronization is complete. This should
> work, and not have too much of an overhead.
> 
> If one 1->0 starts the synchronization, and one or more 1->0
> transitions happen, it will be recorded where the worker will do
> another synchronization, to make sure all 1->0 have went through a full
> synchronization before a 0->1 can happen.
> 
> If a 0->1 comes in while a synchronization is happening, it will note
> the current "number" for the synchronizations (if another one is
> queued, it will wait for one more), before it can begin. As locks will
> be held while waiting for synchronizations to finish, we don't need to
> worry about another 1->0 coming in while a 0->1 is waiting.

Wouldn't get_state_synchronize_rcu() and cond_synchronize_rcu() get you
what you need?
