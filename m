Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8975E28D71E
	for <lists+io-uring@lfdr.de>; Wed, 14 Oct 2020 01:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbgJMXqA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 19:46:00 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54864 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgJMXqA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 19:46:00 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602632758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+e66xsoyRozLaRCAcXIfJYNjgAnfbnKhdErjHmeL3PU=;
        b=an3F9PIJSLevLspGnv54vlp+dUJZ7Zw6EIBza8XHVbcBLtrwLcttbdm9YE2iq/Tf8K3JIy
        MWzSZkM/1Sqc0OJ2W9smC8s0WzkyBBirHxJhGmUjYkamY7lJFLu0wQVAYa1MUSCCOC8NKq
        pi0E32H962kEgwQX2r5c5uIMaA4GW9Ys42jOfTXqEfiOTBn50s+x7gziCHyU/EKRn/V6Aa
        ExU0ZEtp5IibdBfO/QUaE9n5ntnb2bGwT3zZQ9asV0v9MnmFICbKor0JehNzSmIgPYmfsg
        yw4N+vvoPYHxZMpp3rIj5XX+S2o7qmnPeELhZtYFZa+3Caqe4qpaFteD6RKypg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602632758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+e66xsoyRozLaRCAcXIfJYNjgAnfbnKhdErjHmeL3PU=;
        b=KHtZukJZ8mlNnW9MI7fKTelmgM9PP8xUsVXaSLBHbky3OE2S44zV5esk6jpyC3JDN/p3z0
        uMTOqANfa+7BSnBw==
To:     Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org
Subject: Re: [PATCH 3/4] kernel: add support for TIF_NOTIFY_SIGNAL
In-Reply-To: <e8319a4c-334a-e888-7d31-f43b4ae6822a@kernel.dk>
References: <20201008152752.218889-1-axboe@kernel.dk> <20201008152752.218889-4-axboe@kernel.dk> <20201009144328.GB14523@redhat.com> <e8319a4c-334a-e888-7d31-f43b4ae6822a@kernel.dk>
Date:   Wed, 14 Oct 2020 01:45:58 +0200
Message-ID: <875z7dd70p.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 09 2020 at 09:13, Jens Axboe wrote:
>> Hmm. I just noticed that only x86 uses arch_do_signal(), so perhaps you can
>> add this change to this patch right now? Up to you.
>
> Sure, we can do that. Incremental on top then looks like the below. I don't
> feel that strongly about it, but it is nice to avoid re-testing the
> flags.

Yes it makes sense. Can you please make the signature change of
arch_do_signal() in a preparatory patch and only make use of it when you
add the TIF bit to x86?

Thanks,

        tglx

