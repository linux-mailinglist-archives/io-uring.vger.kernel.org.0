Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C7C29020E
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 11:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405757AbgJPJjp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 05:39:45 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43452 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405486AbgJPJjp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 05:39:45 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602841183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IQSAq0DmcMCp8Il1c6ZBuGTyHZ8gpfRWlnpFLmWcST8=;
        b=axWfea24jcPVqd7XdMsnD60n55IHtNcbIBDwPGWKdVDMyPtkNbS9+pSReoCZVQXdIIE1KW
        W9seUIsKWQNaG5mp78Fi3tJfXHC3ZsCEOYOs7mHUiE9P2xw92kIl5E0s/3P1j3/hG2iO0r
        mDb87G+alYm2ooFjXtFUEGzmV1mqKnpxtf+pZGDWq9YpEYxHAV7mBmSUjgJe4z8d5dgEWb
        cRI8aJjCFp5TYud7cRlDcHCCN8WgHJtAy5S1bC6Jzcr5ml7ofgObhAhImvixXzDV9RSNKK
        DkgL1WYQzrolmNs+7TmOnx9vwGpC3F4iAlvfnlN7RfbJ7lJ+AYhYZiUtcttBIw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602841183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IQSAq0DmcMCp8Il1c6ZBuGTyHZ8gpfRWlnpFLmWcST8=;
        b=c3yXCUWPSkn+oH+vHxi4tK25AE8sUcYOc5AMFY4+3uAfbvQAZMObx/dg3TWPw5rXZZhQNQ
        5FKr74oQ0fuKSmCg==
To:     Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, Roman Gershman <romger@amazon.com>
Subject: Re: [PATCH 5/5] task_work: use TIF_NOTIFY_SIGNAL if available
In-Reply-To: <87a6wmv93v.fsf@nanos.tec.linutronix.de>
References: <20201015131701.511523-1-axboe@kernel.dk> <20201015131701.511523-6-axboe@kernel.dk> <20201015154953.GM24156@redhat.com> <e17cd91e-97b2-1eae-964b-fc90f8f9ef31@kernel.dk> <87a6wmv93v.fsf@nanos.tec.linutronix.de>
Date:   Fri, 16 Oct 2020 11:39:43 +0200
Message-ID: <871rhyv7a8.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 16 2020 at 11:00, Thomas Gleixner wrote:
> On Thu, Oct 15 2020 at 12:39, Jens Axboe wrote:
>> On 10/15/20 9:49 AM, Oleg Nesterov wrote:
> So if you change #2 to:
>
>    Drop the CONFIG_GENERIC_ENTRY dependency, make _all_ architectures
>    use TIF_NOTIFY_SIGNAL and clean up the jobctl and whatever related
>    mess.
>
> and actually act apon it, then I'm fine with that approach.

Which makes me rethink my view on Olegs suggestion:

>>> You can simply nack the patch which adds TIF_NOTIFY_SIGNAL to
>>> arch/xxx/include/asm/thread_info.h.

That's a truly great suggestion:

   X86 is going to have that TIF bit once the above is available.

I'm happy to help with the merge logistics of this.

Thanks,

        tglx

