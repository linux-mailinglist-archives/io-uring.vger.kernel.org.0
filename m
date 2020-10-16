Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757012906D9
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 16:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408617AbgJPOL3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 10:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408615AbgJPOL0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 10:11:26 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB88C061755;
        Fri, 16 Oct 2020 07:11:26 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602857484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CxpfhP4r+cT8NbbcIvpC4YffgKWMaBNfTxc0DHUwwGc=;
        b=eK9gJiFjXBg+fMXP9Y7aTpgCZUbZfPcb/xaC21Rps0Xho4oZ/FC2+ycLes1xlXrsR/Mjaq
        QdsLaDKiMnRUyK4CiR3Sr9ZSaatQ7Buwj+5tsUNjmOIQaWJ6slW3NANkz5KE+aR7aKq4JP
        JYYOP4beyqDKyqOnXzMvBF45A7HzQdIiU0ROKTgHlSXY5o9D7O62t5xJQtmQEYo2a7S5EU
        4EZ1D8WRM3OOu/qpDBupEM8YzNi3G7WbkUd7ONCO3O31sYK0m9RQAmcZSmJR2S5bxktFYa
        r3d+M/HEcSldz8CwHZIS1Knw6qM66UnHw6P8ZuOpNILUf/165wOSajIsp0jJAQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602857484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CxpfhP4r+cT8NbbcIvpC4YffgKWMaBNfTxc0DHUwwGc=;
        b=ki5PSY69rO5yxxsHT4i5xRJKsjbdxshMIh8c8fUbCOG1vmWZIaRYlOz0xSVPS7vnCjl+3S
        RCI2tUC5ODQOumAg==
To:     Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, Roman Gershman <romger@amazon.com>
Subject: Re: [PATCH 5/5] task_work: use TIF_NOTIFY_SIGNAL if available
In-Reply-To: <c7da5280-f283-2c89-f6f2-be7d84c3675a@kernel.dk>
References: <20201015131701.511523-1-axboe@kernel.dk> <20201015131701.511523-6-axboe@kernel.dk> <20201015154953.GM24156@redhat.com> <e17cd91e-97b2-1eae-964b-fc90f8f9ef31@kernel.dk> <87a6wmv93v.fsf@nanos.tec.linutronix.de> <c7da5280-f283-2c89-f6f2-be7d84c3675a@kernel.dk>
Date:   Fri, 16 Oct 2020 16:11:24 +0200
Message-ID: <87d01itg4z.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens,

On Fri, Oct 16 2020 at 07:33, Jens Axboe wrote:
> On 10/16/20 3:00 AM, Thomas Gleixner wrote:
> I totally agree, and we're on the same page. I think you'll find that in
> the past I always carry through, the task_work notification was somewhat
> of a rush due to a hang related to it. For this particular case, the
> cleanups and arch additions are pretty much ready to go.

As we seem to be on the same page with this, let me suggest how this
should go:

1) A cleanup for the task_work_add() mess. This is trivial enough and
   should go in before rc1.

2) The TIF_NOTIFY_RESUME change is a nice cleanup on it's own and can go
   before rc1 as well.

This gets stuff out of the way and reduces conflict surface.

3) Core infrastructure (patch 2 + 3 + 5) of this series

   Please make the changes I asked for in the generic entry code and
   moving the handling into get_signal() for everybody else.

   So get_signal() gains:

     if (!IS_ENABLED(CONFIG_GENERIC_ENTRY) {
	 (test_thread_flag(TIF_NOTIFY_SIGNAL))
		tracehook_notify_signal();

         if (!task_sigpending(current))
 		return 0;
     }

   And with that you don't have to touch do_signal() in any architecture
   except x86 which becomes:

   arch_do_signal_or_restart(bool sigpending)

4) Conversion of all architectures which means adding the TIF bit.

   If the architecture folks are happy, then this can be collected in
   tip, which would be preferred because then 

5) Cleanups

   can just go on top.

Hmm?

Thanks,

        tglx
