Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17A97B162B
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 10:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjI1IiE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 04:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjI1IiD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 04:38:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EA4AC;
        Thu, 28 Sep 2023 01:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=z8GzI+kpy3OQpRgGXC2447CS8SW2V4ydnhao9KzknII=; b=dv67282FkROq+rxj7+zjDGZRAe
        c22MFYLUqQdFaCICkn9c/JwsLXsziF0Aa20hcfdtVvZS5oBuvH3QP3jMmHtxf2fjgEJV73X36DTdQ
        6IzQ4OCBy66CT3a7cysZmfV+HA2C4in6oIQdQR3rCpNoSzy8YxY0zibLNv44OyQxHHDSIs+SyEErx
        TGvjE3zNZeg/3STOiQjol+U9rc9rJICOb7O+Q1RXUJMC+/aWSVPrH5LgRbMGDp50KuY7L3uG4S79Q
        2+Mlf7Y6gZPWtolavgWqnvLATMQN603fWGfdIjB624EavJCtWYuIKsCIGdF9F3N2W5SrBBELiW6Cj
        G8vY/z9A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qlmWh-001RzB-JE; Thu, 28 Sep 2023 08:37:39 +0000
Date:   Thu, 28 Sep 2023 09:37:39 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Xiaobing Li <xiaobing.li@samsung.com>, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
        mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com,
        axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, kun.dou@samsung.com,
        peiwei.li@samsung.com, joshi.k@samsung.com,
        kundan.kumar@samsung.com, wenwen.chen@samsung.com,
        ruyi.zhang@samsung.com
Subject: Re: [PATCH 3/3] IO_URING: Statistics of the true utilization of sq
 threads.
Message-ID: <ZRU7UzMlx6lpuEHG@casper.infradead.org>
References: <20230928022228.15770-1-xiaobing.li@samsung.com>
 <CGME20230928023015epcas5p273b3eaebf3759790c278b03c7f0341c8@epcas5p2.samsung.com>
 <20230928022228.15770-4-xiaobing.li@samsung.com>
 <20230928080114.GC9829@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230928080114.GC9829@noisy.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 28, 2023 at 10:01:14AM +0200, Peter Zijlstra wrote:
> Now, I see what you're trying to do, but who actually uses this data?

I ... don't.  There seems to be the notion that since we're polling, that
shouldn't count against the runtime of the thread.  But the thread has
chosen to poll!  It is doing something!  For one thing, it's preventing
the CPU from entering an idle state.  It seems absolutely fair to
accuont this poll time to the runtime of the thread.  Clearly i'm
missing something.
