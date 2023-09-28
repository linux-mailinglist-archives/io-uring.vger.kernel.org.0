Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780257B1583
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 10:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbjI1IC3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 04:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbjI1IC2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 04:02:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410F59F;
        Thu, 28 Sep 2023 01:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eZZIRmbykj6lZJFrbafxkvsz7c/SMH/v8aop+Z7+jMI=; b=fgWGkPITWVxOArycgApDVciz+J
        K+kGiKtzVvqr13NT/4KeBp6eSnk+4zwrLXPlS8y8olVjeRz2tOVD/G8rXlg8u2jPaW3NKJmyNakAr
        dW6He/jfIr4d3LGIjOD93zUXrLgXjXlBpFmY2OF+QfbTotElEM9Bzj+5hRwVqM5xCQbjXoy9+/gla
        avFWxdcxkVV99b946W6m9D+YKh9/mZC4X2/OPIQVxqCMeLAlacaQ3b9lMiaVc+QW6ECI5wD/OtSJ2
        c0+ay2QBfHl/6fKxw5oP7AUWHlmvdIUdBKSIejgXWpnbArmNZRpsfaSEM64gbWaJzt68fDdG68DnP
        pwSpuWZQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qllyQ-001JlQ-2B; Thu, 28 Sep 2023 08:02:14 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id B8B433002E3; Thu, 28 Sep 2023 10:02:13 +0200 (CEST)
Date:   Thu, 28 Sep 2023 10:02:13 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Xiaobing Li <xiaobing.li@samsung.com>
Cc:     mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, vschneid@redhat.com, axboe@kernel.dk,
        asml.silence@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
        kundan.kumar@samsung.com, wenwen.chen@samsung.com,
        ruyi.zhang@samsung.com
Subject: Re: [PATCH 1/3] SCHEDULER: Add an interface for counting real
 utilization.
Message-ID: <20230928080213.GD9829@noisy.programming.kicks-ass.net>
References: <20230928022228.15770-1-xiaobing.li@samsung.com>
 <CGME20230928023007epcas5p276b6e029a67001a6ed8ab28c05b2be9c@epcas5p2.samsung.com>
 <20230928022228.15770-2-xiaobing.li@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230928022228.15770-2-xiaobing.li@samsung.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 28, 2023 at 10:22:26AM +0800, Xiaobing Li wrote:
> +	for (int i = 0; i < MAX_SQ_NUM; i++) {
> +		if (sqstat[i] && (task_cpu(sqstat[i]) != task_cpu(p)
> +		|| sqstat[i]->__state == TASK_DEAD))
> +			sqstat[i] = NULL;
> +	}

This coding style is horrific, please don't ever use that again.
