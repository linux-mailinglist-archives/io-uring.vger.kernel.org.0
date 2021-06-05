Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB4F39C49A
	for <lists+io-uring@lfdr.de>; Sat,  5 Jun 2021 02:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhFEAph (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Jun 2021 20:45:37 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56540 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhFEAph (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Jun 2021 20:45:37 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622853829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7JK99x2aCiwHcKoHUwYLrlYiiXcsZf3XTECQ6JDeNtg=;
        b=2dFyG/SfB92H9PmpDRA7soX43NyiXJu1t6mOaoUOGo0g0VHQ/IOOojofkC2yqpX/00XBD6
        jzjlQEl/0v1ybdFTNz4DbGuWgRASZTpxu8tWzCFMf96E6+CjEreuKTSUvBeD9DEli2aony
        WwWO2/QqLyCJi8z68NoQ5mje4AYZjR09I94DNY/am7et2qYz8GMnpk4JIdKxqDoIKn+jOO
        LB9yrSeuiqxVNzjwOJXDoAHDZr9K0EiHFDFmG4MOZrvUgcvGDj/f+h91GkWO4oB4KMhHMH
        /U1i92y7qYJECjA38oaT9Gkpcs/UzFTy4MngINYpBOXEiVda3xwthcuBRngZCA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622853829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7JK99x2aCiwHcKoHUwYLrlYiiXcsZf3XTECQ6JDeNtg=;
        b=3GLJtO/fwiRXRqqM30wtOeGyzNH971QME09g79BySukpMaZ497oO0wX9kbhyAnbqE1v9bN
        WAPj0Z9sYg5l+qCA==
To:     Andres Freund <andres@anarazel.de>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/4] io_uring: implement futex wait
In-Reply-To: <20210603190338.gfykgkc7ac2akvdt@alap3.anarazel.de>
References: <cover.1622558659.git.asml.silence@gmail.com> <e91af9d8f8d6e376635005fd111e9fe7a1c50fea.1622558659.git.asml.silence@gmail.com> <bd824ec8-48af-b554-67a1-7ce20fcf608c@kernel.dk> <409a624c-de75-0ee5-b65f-ee09fff34809@gmail.com> <bdc55fcd-b172-def4-4788-8bf808ccf6d6@kernel.dk> <5ab4c8bd-3e82-e87b-1ae8-3b32ced72009@gmail.com> <87sg211ccj.ffs@nanos.tec.linutronix.de> <20210603190338.gfykgkc7ac2akvdt@alap3.anarazel.de>
Date:   Sat, 05 Jun 2021 02:43:48 +0200
Message-ID: <87v96tywcb.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Andres,

On Thu, Jun 03 2021 at 12:03, Andres Freund wrote:
> On 2021-06-01 23:53:00 +0200, Thomas Gleixner wrote:
>> You surely made your point that this is well thought out.
>
> Really impressed with your effort to generously interpret the first
> version of a proof of concept patch that explicitly was aimed at getting
> feedback on the basic design and the different use cases.

feedback on what?

There is absolutely no description of design and obviously there is no
use case either. So what do you expect me to be generous about?

Thanks,

        tglx

