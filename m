Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54AF728D711
	for <lists+io-uring@lfdr.de>; Wed, 14 Oct 2020 01:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbgJMXgQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 19:36:16 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54808 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729788AbgJMXgQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 19:36:16 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602632174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t3YI3mVHJJmTeQFeJREmA2DsZjQR6ChvJdkFt2RtQDI=;
        b=4Fy6miBhLaf7b1hpK3ppcZWZRVFduFkHSfb9iquFp6rDjbxBQz3lSuI8AIpKLx5O6YEG6Z
        Nfb/Wk+Xy69oqqayEc6/ICGgg9ORaA9ejAS8+4cIz1W5QX7v9EIXvYugFT3EMyjTWOEKkI
        gxOTq8b7XCIEkPq6DAwMfJRLP4eFuuijUcCEX6jumFif+LYaMvHIHHney2BWvyiKvx4hGx
        6X1TLrsA3/CbYhOY7cv/hRZK7X5psl112sPz3CpUcFNdPrmuVSTuNgoDVLr1nxHyrKu7NK
        U5weTfX6b2Mf690s+uXjex2bqmBNoQwAK5lDzyGm0wGlu97ovnY+RryrdCQ5xA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602632174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t3YI3mVHJJmTeQFeJREmA2DsZjQR6ChvJdkFt2RtQDI=;
        b=jlm9Cfse18CjedL0b3XpSicgZXTKJApyB2XpDUoFIZBJ5MzJFr1bScV2TeFA1nQidLocZf
        EuWqORs1mLXVVRCw==
To:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/4] kernel: add task_sigpending() helper
In-Reply-To: <20201008152752.218889-3-axboe@kernel.dk>
References: <20201008152752.218889-1-axboe@kernel.dk> <20201008152752.218889-3-axboe@kernel.dk>
Date:   Wed, 14 Oct 2020 01:36:14 +0200
Message-ID: <87blh5d7gx.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 08 2020 at 09:27, Jens Axboe wrote:
> This is in preparation for maintaining signal_pending() as the decider
> of whether or not a schedule() loop should be broken, or continue
> sleeping. This is different than the core signal use cases, where we
> really want to know if an actual signal is pending or not.
> task_sigpending() returns non-zero if TIF_SIGPENDING is set.
>
> Only core kernel use cases should care about the distinction between
> the two, make sure those use the task_sigpending() helper.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
