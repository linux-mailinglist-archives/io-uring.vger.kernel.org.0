Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42086492EF7
	for <lists+io-uring@lfdr.de>; Tue, 18 Jan 2022 21:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349075AbiARUGC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jan 2022 15:06:02 -0500
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:55399 "EHLO
        mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231417AbiARUGC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jan 2022 15:06:02 -0500
Received: from mx-rz-smart.rrze.uni-erlangen.de (mx-rz-smart.rrze.uni-erlangen.de [IPv6:2001:638:a000:1025::1e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mx-rz-2.rrze.uni-erlangen.de (Postfix) with ESMTPS id 4Jdfsj0D90zPkcD;
        Tue, 18 Jan 2022 21:06:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fau.de; s=fau-2021;
        t=1642536361; bh=MlYNUaNEdlw4iPxd4v4NqIQAvfwl0HtigJlDxjy6OTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From:To:CC:
         Subject;
        b=bHVJ/YpsSzKfNNZ6h9fpXXUeBR4svUi9Ay1YPilzZ9YZ6AggeOY0C5tk2OqZsx2Ag
         sfyxxDdlDKRW+G4ODqAT1NPaZLU1KTBUg9t+g4bQXeJ2n0ymUcuTq9OHaPAJIDKUWr
         +Oq56uWtxlf5WjWXCFkYn9beSCsYFtHSKygrUDDJS2mG13i19Wz+5/fQb/PTfOmuEU
         vFbKZDd3E8GlwTud7gbQJNTjCXcW/2fi3nQyJ74hqmaVDPJPTPU1imcu9IidGWmEew
         I3stzfGBCzVCoKLTb5zWi9l0H4+wKuWqp6C39U1US5Hpnr89EMQVKPl+m1FpjCjMSs
         B1/i8qA7jomcg==
X-Virus-Scanned: amavisd-new at boeck2.rrze.uni-erlangen.de (RRZE)
X-RRZE-Flag: Not-Spam
X-RRZE-Submit-IP: 2a02:8070:88c3:5000:7a2b:46ff:fe28:e01a
Received: from localhost (unknown [IPv6:2a02:8070:88c3:5000:7a2b:46ff:fe28:e01a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: U2FsdGVkX1+HPu9k1GHKe5M9TSogPgoSmB2Gl5aygbM=)
        by smtp-auth.uni-erlangen.de (Postfix) with ESMTPSA id 4Jdfsf3p0WzPlR6;
        Tue, 18 Jan 2022 21:05:58 +0100 (CET)
Date:   Tue, 18 Jan 2022 21:05:49 +0100
From:   Florian Fischer <florian.fl.fischer@fau.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, flow@cs.fau.de
Subject: Re: Canceled read requests never completed
Message-ID: <20220118200549.qybt7fgfqznscidx@pasture>
Mail-Followup-To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        flow@cs.fau.de
References: <20220118151337.fac6cthvbnu7icoc@pasture>
 <81656a38-3628-e32f-1092-bacf7468a6bf@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81656a38-3628-e32f-1092-bacf7468a6bf@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> > After reading the io_uring_enter(2) man page a IORING_OP_ASYNC_CANCEL's return value of -EALREADY apparently
> > may not cause the request to terminate. At least that is our interpretation of "…res field will contain -EALREADY.
> > In this case, the request may or may not terminate."
> 
> I took a look at this, and my theory is that the request cancelation
> ends up happening right in between when the work item is moved between
> the work list and to the worker itself. The way the async queue works,
> the work item is sitting in a list until it gets assigned by a worker.
> When that assignment happens, it's removed from the general work list
> and then assigned to the worker itself. There's a small gap there where
> the work cannot be found in the general list, and isn't yet findable in
> the worker itself either.
> 
> Do you always see -ENOENT from the cancel when you get the hang
> condition?

No we also and actually more commonly observe cancel returning -EALREADY and the
canceled read request never gets completed.

As shown in the log snippet I included below.

> > The far more common situation with the reproducer and adding 1 to the eventfds in each loop
> > is that a request is not canceled and the cancel attempt returned with -EALREADY.
> > There is no progress because the writer has already finished its loop and the cancel
> > apparently does not really cancel the request.
> > 
> >   1 Starting iteration 996
> >   1 Prepared read request (evfd: 1, tag: 1)
> >   1 Submitted 1 requests -> 1 inflight
> >   1 Prepared read request (evfd: 2, tag: 2)
> >   1 Submitted 1 requests -> 2 inflight
> >   1 Prepared write request (evfd: 0)
> >   1 Submitted 1 requests -> 3 inflight
> >   1 Collect write completion: 8
> >   1 Prepared cancel request for read 1
> >   1 Prepared cancel request for read 2
> >   1 Submitted 2 requests -> 4 inflight
> >   1 Collect read 1 completion: -125 - Operation canceled
> >   1 Collect cancel read 1 completion: 0
> >   1 Collect cancel read 2 completion: -114 - Operation already in progress

^- the cancel returned with -EALREADY but the cancelled read (the second
prepared read request) is never completed.

> 
> I'll play with this a bit and see if we can't close this hole so the
> work is always reliably discoverable (and hence can get canceled).

Thanks for your effort!
