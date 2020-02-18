Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF4516298F
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 16:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgBRPie (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 10:38:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34106 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgBRPie (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 10:38:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FYAnTqjyE2aohE1YeQs+8BYtNmXOUP/FP1qplxxsc2w=; b=Rk6k2Qf7/F+D1iKL06+3X4y/Wr
        ziwpX7R3rTgHqLe2CMWoF2LOvq1i5iMyykoPMSQMuxd6YBTzEoT9d8R7uw5AdHp5RLuEVqcu/x50Z
        fRnyX7VhprLwjzWJwCXkppPPSQKwoGbG+S4l3ErwztNqSdQaftrg5xXu796fbda7cIDbG4IEau5VR
        RHElEgf1QoiuCCsNzWWFOM0bYCIb1aBO+G+HTWw/8u+0WOYAkjHCJWh8PncekkpXZ1kURwCHxaCWL
        z8ycmyYma43pQAZzmdgwfaiRW9ztbijh8ZmYzLbUeB4Za/KQc/hpB2HQ5IQ2I5tATvHfYJAmqK1Cp
        KMLW51Sg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j44xA-0007HN-3t; Tue, 18 Feb 2020 15:38:28 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D805C3008A9;
        Tue, 18 Feb 2020 16:36:32 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 06B4020206D85; Tue, 18 Feb 2020 16:38:24 +0100 (CET)
Date:   Tue, 18 Feb 2020 16:38:23 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
Message-ID: <20200218153823.GF14914@hirez.programming.kicks-ass.net>
References: <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
 <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
 <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
 <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
 <20200218145645.GB3466@redhat.com>
 <20200218150745.GC3466@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218150745.GC3466@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Feb 18, 2020 at 04:07:45PM +0100, Oleg Nesterov wrote:
> On 02/18, Oleg Nesterov wrote:
> >
> > otherwise I think this is correct, but how about the patch below?
> > Then this code can be changed to use try_cmpxchg().
> 
> You have already sent the patch which adds the generic try_cmpxchg,
> so the patch below can be trivially adapted.
> 
> But I'd prefer another change, I think both task_work_add() and
> task_work_cancel() can use try_cmpxchg() too.

Yeah, I'll go change the lot, but maybe after Jens' patches, otherwise
we're just creating merge conflicts.
