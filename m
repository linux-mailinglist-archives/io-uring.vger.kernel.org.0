Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1994316190B
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2020 18:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbgBQRqT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Feb 2020 12:46:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41016 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729032AbgBQRqT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Feb 2020 12:46:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IoUyUGuPMRKcQY67FgUAUXF+p38/QKt+AX7I1Uk67Wg=; b=UOHkLORyG1oIDdD1Uf3+/an3GE
        jP3OEZ0D/4gBxsgyGuHT7UveCG+iM2cAYkz7ZBXvZ7moyO7qI/DpgHDDChj9T0y3esvrjj46QSoqJ
        My6ni0Hk/UXhx18RHlOpNbAz5vsRsVopko6Wpb7nVqSl70X+PaxVEm6i07azvSjzhc1xwINrZtN9D
        25YOR1hLNkoxSNpbekHrRLj/kw3T2we7y8wLPtPqVAzw4zIVL5Qn6XEerMIzJjfmpIn2y1F+yxvbP
        VCm3GT8EB+A304+ZKx+R5CXl43j559qoxMLfbWDmdxtcoI1z6kV4oLaEXJY4s9DjBZJM6qHu2yr5C
        QRP80/VA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3kTE-00020L-GI; Mon, 17 Feb 2020 17:46:12 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8947E304123;
        Mon, 17 Feb 2020 18:44:19 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C83B22B910501; Mon, 17 Feb 2020 18:46:10 +0100 (CET)
Date:   Mon, 17 Feb 2020 18:46:10 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
Message-ID: <20200217174610.GU14897@hirez.programming.kicks-ass.net>
References: <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
 <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 17, 2020 at 09:16:34AM -0800, Jens Axboe wrote:
> OK, did the conversion, and it turned out pretty trivial, and reduces my
> lines as well since I don't have to manage the list side. See here:
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-task-poll
> 
> Three small prep patches:
> 
> sched: move io-wq/workqueue worker sched in/out into helpers
> kernel: abstract out task work helpers
> sched: add a sched_work list

The __task_work_add() thing should loose the set_notify_resume() thing,
that is very much task_work specific. Task_work, works off of
TIF_NOTIFY_RESUME on return-to-user. We really don't want that set for
the sched_work stuff.

I've not looked too hard at the rest, I need to run to the Dojo, should
have some time laster tonight, otherwise tomorrow ;-)
