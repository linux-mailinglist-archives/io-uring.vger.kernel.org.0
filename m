Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDFA282037
	for <lists+io-uring@lfdr.de>; Sat,  3 Oct 2020 03:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbgJCBtD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Oct 2020 21:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgJCBtC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Oct 2020 21:49:02 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB93AC0613D0;
        Fri,  2 Oct 2020 18:49:02 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601689741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=71bkXOVLDwtVOfCToFQug21Guut6/gzkIwIbpUN54pU=;
        b=Stsdcz9+U/j6iA8iXss1yQDZNcosRTdUDPWRE2f5ZfXME3KPt7Sc/bygXerI4m9jr6H4qy
        PyxaWzybcRfck8t2dqtxw+Up1jMRIzAz19lSKnBBAgCyl94DnRuI5EiIytdtpMZfnL5Vc0
        qRZus32aUW0MAVF5XgsAXPHHwdlGSI7H1XPq5Wb4uvR1t9QxpCY4PjV15I8OA/pmm7xh3w
        S3cJyhvNn4jM+dYvLJzSx/cHAmDPL/ZyvOOkQMKnpjpoEMICA/F2W1G+7ZRm7J3yv2YlGR
        LpnjiLV+xqkxS56HG6lDWcfxk9WkBPNlrvNODteJ0+Au5Jhz2wr/Lfb03f7E6Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601689741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=71bkXOVLDwtVOfCToFQug21Guut6/gzkIwIbpUN54pU=;
        b=iV1y8z8rfRPNqmaatTN5Ch/TxyHSucga7L+TOVQRCIB2c9BSOcceWzJHhYdvEiDsDfW/ks
        G1qVZ+DNTTsxu0Dg==
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH 3/3] task_work: use TIF_TASKWORK if available
In-Reply-To: <20201002153849.GC29066@redhat.com>
References: <20201001194208.1153522-1-axboe@kernel.dk> <20201001194208.1153522-4-axboe@kernel.dk> <20201002151415.GA29066@redhat.com> <871rigejb8.fsf@nanos.tec.linutronix.de> <20201002153849.GC29066@redhat.com>
Date:   Sat, 03 Oct 2020 03:49:00 +0200
Message-ID: <87o8lkcc4z.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 02 2020 at 17:38, Oleg Nesterov wrote:
> On 10/02, Thomas Gleixner wrote:
>>
>> I think it's fundamentaly wrong that we have several places and several
>> flags which handle task_work_run() instead of having exactly one place
>> and one flag.
>
> Damn yes, agreed.

Actually there are TWO places, but they don't interfere:

   1) exit to user

   2) enter guest

From the kernel POV they are pretty much the same as both are leaving
the kernel domain. But they have a few subtle different requirements
what has to be done or not.

So any change to that logic needs to fixup both places,

Thanks,

        tglx
