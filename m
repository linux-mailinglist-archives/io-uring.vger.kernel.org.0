Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C5B32D407
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 14:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhCDNUv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 08:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241212AbhCDNUc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 08:20:32 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C5BC061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 05:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=G5ZYZdsmz4gWAk0kCK0XI/OSjbxrqyYPQT+C3oD7KE0=; b=a2Be2fgdJ9RvwlCtdm3zn33KDg
        K6qkVMLwL+9fNdiERcdFrvo4zAuB2TpWEDoP9TyqQdgE+saGZScPBqUXO6JraEcs5dk7m9ePHEcV0
        6E6XmlGEh8AMZbLSwKubEZ/74IpER1y1Kg9eyalw6Z2igSCwHRCKlsCoLcgpZAao70ZtrxY1m7cNB
        xkBmuePzU17fOu5dqnil/OwV5cDcRYNpWaZ2gbqcWyO5OGSXac/D7mgMqiRhR85a6FQf1kzijsHEi
        Rj2hi4KaYPkHXDHrIIaEk64e+YXxbZPg/WWmbrbN5N7OLjlMGQOUj1BDnaJfioCUdeC7FmxFX1Yta
        sVrW1yQjLZu8m9GgdUZaA3nwG3LvzQmhgMkMpngnsTnynIE7cjU9ELj4/eGXpD4bANqSwwzGaunwi
        LV6ocC8KpMqHwfNUv+N3FXd62afKuq3xPYzrzlpf9JEMiSW5TwIy7Zj5mQzM5OB7+BRIOqAiqXfsj
        kJ9rtBnUGA/FlqHi+0e3acp+;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lHntN-0005vQ-1k; Thu, 04 Mar 2021 13:19:49 +0000
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org
References: <20210219171010.281878-1-axboe@kernel.dk>
 <20210219171010.281878-10-axboe@kernel.dk>
 <85bc236d-94af-6878-928b-c69dbdcd46f9@samba.org>
 <d9704b9e-ae5e-0795-ba2e-029293f89616@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 09/18] io-wq: fork worker threads from original task
Message-ID: <a9f58269-b260-6281-4e83-43cb5e881d25@samba.org>
Date:   Thu, 4 Mar 2021 14:19:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <d9704b9e-ae5e-0795-ba2e-029293f89616@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

>> Can you please explain why CLONE_SIGHAND is used here?
> 
> We can't have CLONE_THREAD without CLONE_SIGHAND... The io-wq workers
> don't really care about signals, we don't use them internally.

I'm 100% sure, but I heard rumors that in some situations signals get
randomly delivered to any thread of a userspace process.

My fear was that the related logic may select a kernel thread if they
share the same signal handlers.

>> Will the userspace signal handlers executed from the kernel thread?
> 
> No

Good.

Are these threads immutable against signals from userspace?

>> Will SIGCHLD be posted to the userspace signal handlers in a userspace
>> process? Will wait() from userspace see the exit of a thread?
> 
> Currently actually it does, but I think that's just an oversight. As far
> as I can tell, we want to add something like the below. Untested... I'll
> give this a spin in a bit.
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index ba4d1ef39a9e..e5db1d8f18e5 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1912,6 +1912,10 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
>  	bool autoreap = false;
>  	u64 utime, stime;
>  
> +	/* Don't notify a parent task if an io_uring worker exits */
> +	if (tsk->flags & PF_IO_WORKER)
> +		return true;
> +
>  	BUG_ON(sig == -1);
>  
>   	/* do_notify_parent_cldstop should have been called instead.  */
> 

Ok, thanks!

metze
