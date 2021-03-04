Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845C032D2B9
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 13:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhCDMQR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 07:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240502AbhCDMPp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 07:15:45 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB848C061760
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 04:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=JA4TLk0pY7gfINK4mw20tlxfQXm9YD4pHVNWTQdhy1s=; b=jvdfu80EbVvlMpR6MUFjn3ve4S
        Taw1QxBLSXIavXh1YldQ4D9iqj+ePwHXJVSHbCdnRNwRcbVvwIUZ/ut3DLlcf8meiZYQmg+tN1b+T
        utYWzHsBhUA902nhUEzPl2zQ4/gHg+m1prFo1CZCeWui0C3NuG5lci1wqPFwk5oVTmnIBi/2GBWgl
        /HItK3vGG0Wah6SBqFwWCCieP7wbU5vAbM4kb9NKMg2YEffbL7sWqTXTcI5Fu2XFh0+HZDCYs6N5k
        WJOEKk+sXC49F93sN1Hd27ziJtB7kcvDkx+hmHUyT89nYxfWWkoiC7HdMyQuCFwO6bybUQ5fIJCWr
        Aa34xk5ccMoz+NUgFbT/r75s47wTboCbRAJph6t1Ca0X4lSfAZXzfiogETT2qkvluHM9vBxhW3A8C
        eR35ciERomocmMlPc7EyppiGwUNPc58qSbeTVwTUgI/7JNUu2nYCqkAY3ZMtFj0AeGynDu+5+F18f
        K0frv3/6rw2BJX3x4QnXvYSv;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lHmsf-0005U5-2b; Thu, 04 Mar 2021 12:15:01 +0000
To:     Jens Axboe <axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
 <20210304002700.374417-13-axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 12/33] io_uring: signal worker thread unshare
Message-ID: <32ca12f8-0ca0-d247-aefc-01d82d4f47eb@samba.org>
Date:   Thu, 4 Mar 2021 13:15:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210304002700.374417-13-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi Jens,

> If the original task switches credentials or unshares any part of the
> task state, then we should notify the io_uring workers to they can
> re-fork as well. For credentials, this actually happens just fine for
> the io-wq workers, as we grab and pass that down. For SQPOLL, we're
> stuck with the original credentials, which means that it cannot be used
> if the task does eg seteuid().

I fear that this will be very problematic for Samba's use of io_uring.

We change credentials very often, switching between the impersonated users
and also root in order to run privileged sections.

Currently fd-based operations are not affected by the credential switches.

I guess any credential switch means that all pending io_uring requests
get canceled, correct?

It also means the usage of IORING_REGISTER_PERSONALITY isn't useful any longer,
as that requires a credential switch before (and most likely after) the
io_uring_register() syscall.

As seteuid(), unshare() and similar syscalls are per thread instead of process
in the kernel, the io_wq is also per userspace thread and not per io_ring_ctx, correct?

As I read the code any credential change in any userspace thread will
cause the sq_thread to be stopped and restarted by the next io_uring_enter(),
which means that the sq_thread may change its main credentials randomly overtime,
depending on which userspace thread calls io_uring_enter() first.
As unshare() applies only to the current task_struct I'm wondering if
we only want to refork the sq_thread if the current task is the parent of
the sq_thread.

I'm wondering if we better remove io_uring_unshare() from commit_creds()
and always handle the creds explicitly as req->work.creds.
io_init_req() then will req->work.creds from ctx->personality_idr
or from current->cred. At the same time we'd readd ctx->creds = get_current_cred();
in io_uring_setup() and use these ctx->creds in the io_sq_thread again
in order to make things sane again.

I'm also wondering if all this has an impact on IORING_SETUP_ATTACH_WQ,
in particular I'm thinking of the case where the fd was transfered via SCM_RIGHTS
or across fork(), when mm and files are not shared between the processes.

I think the IORING_FEAT_CUR_PERSONALITY section in io_uring_setup.2
should also talk about what credentials are used in the IORING_SETUP_SQPOLL case.

The IORING_SETUP_SQPOLL section should also be more detailed regarding
what state is used in particular in combination with IORING_SETUP_ATTACH_WQ.
Wasn't the idea up to 5.11 that the sq_thread would capture the whole
state at io_uring_setup()?

I think we need to maintain the overall behavior exposed to userspace...

metze
