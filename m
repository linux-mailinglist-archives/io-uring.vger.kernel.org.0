Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C704676D0
	for <lists+io-uring@lfdr.de>; Fri,  3 Dec 2021 12:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhLCL4a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Dec 2021 06:56:30 -0500
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:55891 "EHLO
        mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231466AbhLCL43 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Dec 2021 06:56:29 -0500
Received: from mx-rz-smart.rrze.uni-erlangen.de (mx-rz-smart.rrze.uni-erlangen.de [IPv6:2001:638:a000:1025::1e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mx-rz-3.rrze.uni-erlangen.de (Postfix) with ESMTPS id 4J5B6761DGz1yQT;
        Fri,  3 Dec 2021 12:53:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fau.de; s=fau-2021;
        t=1638532383; bh=uOQ2lXF8j/VY/RqPLQPxwEEOWmBAZxRpKUUdawKY5u4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From:To:CC:
         Subject;
        b=MbEgggiJENwLXgVsrcFrn1s7GaqercU4QMKy4WTsq3OOThW9y15c3wtOQWasDfuf8
         m4QbOmpK8uCL1PO/f9HmMW2zIbwUdIb72el3tu6QSXs/wltsK4kVVAaE//9VqOQApF
         mvfFN/utkAgECS7S62VjFi5Mvd5PZkIXN4DUq0z56SzrnYNkYwzVhlUWrNve8CuxeL
         RPO8PEfwxUWERiZgw9UYNAbKn2RfSH/Vf2dlHNUGetd9OmPd1LIx0IxP5vfs1CT2Ph
         1dhOVg8FBUs/SMz1ZM5cc3o+6y4If/azBqCtXTrqg8nDyFDH/K9mXYVYkHzAf/knD5
         oOfmiBe/e43OA==
X-Virus-Scanned: amavisd-new at boeck2.rrze.uni-erlangen.de (RRZE)
X-RRZE-Flag: Not-Spam
X-RRZE-Submit-IP: 2003:eb:5724:4441:7a2b:46ff:fe28:e01a
Received: from localhost (p200300eb572444417a2b46fffe28e01a.dip0.t-ipconnect.de [IPv6:2003:eb:5724:4441:7a2b:46ff:fe28:e01a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: U2FsdGVkX1/284fAtmHJGlO8nU5ZLzRUc3tDUctkowQ=)
        by smtp-auth.uni-erlangen.de (Postfix) with ESMTPSA id 4J5B651r1Dz20Mt;
        Fri,  3 Dec 2021 12:53:01 +0100 (CET)
Date:   Fri, 3 Dec 2021 12:52:51 +0100
From:   Florian Fischer <florian.fl.fischer@fau.de>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     flow@cs.fau.de
Subject: Re: Tasks stuck on exit(2) with 5.15.6
Message-ID: <20211203115251.nbwzvwokyg4w3b34@pasture>
Mail-Followup-To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        flow@cs.fau.de
References: <20211202165606.mqryio4yzubl7ms5@pasture>
 <c4c47346-e499-2210-b511-8aa34677ff2e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4c47346-e499-2210-b511-8aa34677ff2e@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens, 

> Thanks for the bug report, and I really appreciate including a reproducer.
> Makes everything so much easier to debug.

Glad I could help :)

> Are you able to compile your own kernels? Would be great if you can try
> and apply this one on top of 5.15.6.
> 
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 8c6131565754..e8f77903d775 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -711,6 +711,13 @@ static bool io_wq_work_match_all(struct io_wq_work *work, void *data)
>  
>  static inline bool io_should_retry_thread(long err)
>  {
> +	/*
> +	 * Prevent perpetual task_work retry, if the task (or its group) is
> +	 * exiting.
> +	 */
> +	if (fatal_signal_pending(current))
> +		return false;
> +
>  	switch (err) {
>  	case -EAGAIN:
>  	case -ERESTARTSYS:

With your patch on top of 5.15.6 I can no longer reproduce stuck processes.
Neither with our software nor with the reproducer.
I ran both a hundred times and both terminated immediately without unexpected CPU usage.

Tested-by: Florian Fischer <florian.fl.fischer@fau.de>

Florian Fischer
