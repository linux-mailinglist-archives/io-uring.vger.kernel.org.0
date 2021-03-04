Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F006E32D2CB
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 13:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240457AbhCDMYt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 07:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240387AbhCDMYa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 07:24:30 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01FCC061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 04:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=MxZwN/tb66tkfJL+86hM8VhUR1PdccgzsgcnePZWwU4=; b=mfVf17SxOILfaAHarZNH1lPsE6
        iQ3IyvsdIRmR/wUd63JFPz8b50padYPSeZOH3xillGXE10+0KrZG2DMg2r/snwTZG8WCkzmkC4b5T
        2DQtEMFpg5LLe1EHFbtZ7p5XXsdnB2ydVC2zafdPJl6FqgzJWeHFFdssAvt5H13kaZEjv9ZEk0wA+
        2Lu2S6lb4X+xItdkuec+hLcUhbFsbYjk17bfN0OnGigNRSsVevEVIurBAM7+FnT+Jm4odV2DMxK4z
        WrIRbi0lAIoVVhr2FHtcj9Nv0vxvzj9ufC/ECHkds/UXDMDFnvIZ1dkfGYMH1/ewG9YRdL1jYYSSX
        pg46l0sI0xL3shkXTzkYzf7OdfQoeNDjiJcUhvN1KGu3PD6Ef7eyxv8QESPx1SmBbu8iCTArK4FK3
        zR+3ha/jkwDxX57bu5ZpbRBk79Lg1GRTulki0osQcXFg47d0CVVWkKQUCQyxVvB/KMDNzuw9zIEDi
        XbLwKD009mXkY6m36Elidvni;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lHn16-0005Xn-UT; Thu, 04 Mar 2021 12:23:45 +0000
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org
References: <20210219171010.281878-1-axboe@kernel.dk>
 <20210219171010.281878-10-axboe@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 09/18] io-wq: fork worker threads from original task
Message-ID: <85bc236d-94af-6878-928b-c69dbdcd46f9@samba.org>
Date:   Thu, 4 Mar 2021 13:23:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210219171010.281878-10-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi Jens,

> +static pid_t fork_thread(int (*fn)(void *), void *arg)
> +{
> +	unsigned long flags = CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|
> +				CLONE_IO|SIGCHLD;
> +	struct kernel_clone_args args = {
> +		.flags		= ((lower_32_bits(flags) | CLONE_VM |
> +				    CLONE_UNTRACED) & ~CSIGNAL),
> +		.exit_signal	= (lower_32_bits(flags) & CSIGNAL),
> +		.stack		= (unsigned long)fn,
> +		.stack_size	= (unsigned long)arg,
> +	};
> +
> +	return kernel_clone(&args);
> +}

Can you please explain why CLONE_SIGHAND is used here?

Will the userspace signal handlers executed from the kernel thread?

Will SIGCHLD be posted to the userspace signal handlers in a userspace
process? Will wait() from userspace see the exit of a thread?

Thanks!
metze
