Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE30290B0E
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 20:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390346AbgJPSDH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 14:03:07 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46092 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387509AbgJPSDH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 14:03:07 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602871386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VjN47K1oRc9Uf/luZGiXWJiCGTO/s1PL6HhypKJDE2Q=;
        b=WprMmSjcUBCd+LqmcC2gB1CcFxwAHpvQBnJIdzVwBAT1qAekwpAU5Dbt25J8CJvIFGKYW7
        tZML5GsXmAY2qY/kKMJpGwDwbuHxWjLqu7grCPxoklSBWJKZ4sYINii6dkXmQUwfOkL/xZ
        /kDKUD1o82xkRdQKQwLqRzozdLk72IqJcao0K7Ky2cJj81yT49YlLk0k7uuxWE4nl6nb0B
        xOTfoSjlWjaiZZyKHiFH7yy2PyEVdviIdlD6qwNiEgcrEMyhEiWhGNMNo168YsMlyrH7nj
        iYGBo4csD2L8Z9W+CuHmiRiy6CVI9kGiXV2cy2748L7aqjwF7w1Toa2Aiu057Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602871386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VjN47K1oRc9Uf/luZGiXWJiCGTO/s1PL6HhypKJDE2Q=;
        b=/1McgWzP+vZ+PGht2uWGHFsQMF0oMXXCvUssNI8fYGSNvuRHLoTIe5OxfRpLEMd4AH74Mf
        Dl6lmorJ3AhoSnCw==
To:     Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, Roman Gershman <romger@amazon.com>
Subject: Re: [PATCH 5/5] task_work: use TIF_NOTIFY_SIGNAL if available
In-Reply-To: <1a89eacd-830e-7310-0e56-9b4b389cdc5d@kernel.dk>
References: <20201015131701.511523-1-axboe@kernel.dk> <20201015131701.511523-6-axboe@kernel.dk> <20201015154953.GM24156@redhat.com> <e17cd91e-97b2-1eae-964b-fc90f8f9ef31@kernel.dk> <87a6wmv93v.fsf@nanos.tec.linutronix.de> <871rhyv7a8.fsf@nanos.tec.linutronix.de> <fbaab94b-dd85-9756-7a99-06bf684b80a4@kernel.dk> <87a6wmtfvb.fsf@nanos.tec.linutronix.de> <20201016145138.GB21989@redhat.com> <1a89eacd-830e-7310-0e56-9b4b389cdc5d@kernel.dk>
Date:   Fri, 16 Oct 2020 20:03:04 +0200
Message-ID: <874kmuaw13.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 16 2020 at 08:53, Jens Axboe wrote:
> On 10/16/20 8:51 AM, Oleg Nesterov wrote:
>> On 10/16, Thomas Gleixner wrote:
>>>
>>> With moving the handling into get_signal() you don't need more changes
>>> to arch/* than adding the TIF bit, right?
>> 
>> we still need to do something like
>> 
>> 	-	if (thread_flags & _TIF_SIGPENDING)
>> 	+	if (thread_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
>> 			do_signal(...);
>> 
>> and add _TIF_NOTIFY_SIGNAL to the WORK-PENDING mask in arch/* code.
>
> Yes, but it becomes really minimal at that point, and just that. There's
> no touching any of the arch do_signal() code.
>
> Just finished the update of the branch to this model, and it does simplify
> things quite a bit! Most arch patches are now exactly just what you write
> above, no more.

Except for all the nasty ones which have these checks in ASM :)
