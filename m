Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C12742A5B
	for <lists+io-uring@lfdr.de>; Thu, 29 Jun 2023 18:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjF2QM0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jun 2023 12:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjF2QMZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jun 2023 12:12:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852FB3595
        for <io-uring@vger.kernel.org>; Thu, 29 Jun 2023 09:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688055097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hXzn/T+eskwyoHAIYDRxcHdpwP2+My4amFKoi/35Pwg=;
        b=NfHnsDuY+2s4kzk9soFGpcBfZwELZ1aqvSagZu63oa2b7Y1WuZgtUPmCe+hc7xJrNM0XgY
        ZW3GWOdFB6W440BvSCkd7lCdstQPO9OtBuYF8yFWBYO4eOmIRqhRuwx77qvGVXT6UWjdkr
        5KXJn7a2nUB8A44MWGGsxhu8nuLOUm0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-Wpeqv30fOWmfcZrSHaZ9ug-1; Thu, 29 Jun 2023 12:11:32 -0400
X-MC-Unique: Wpeqv30fOWmfcZrSHaZ9ug-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF2C81C31C4B;
        Thu, 29 Jun 2023 16:11:30 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 05AF2492B02;
        Thu, 29 Jun 2023 16:11:29 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Matteo Rizzo <matteorizzo@google.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, jordyzomer@google.com, evn@google.com,
        poprdi@google.com, corbet@lwn.net, axboe@kernel.dk,
        asml.silence@gmail.com, akpm@linux-foundation.org,
        keescook@chromium.org, rostedt@goodmis.org,
        dave.hansen@linux.intel.com, ribalda@chromium.org,
        chenhuacai@kernel.org, steve@sk2.org, gpiccoli@igalia.com,
        ldufour@linux.ibm.com, bhe@redhat.com, oleksandr@natalenko.name
Subject: Re: [PATCH v2 1/1] Add a new sysctl to disable io_uring system-wide
References: <20230629132711.1712536-1-matteorizzo@google.com>
        <20230629132711.1712536-2-matteorizzo@google.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Thu, 29 Jun 2023 12:17:20 -0400
In-Reply-To: <20230629132711.1712536-2-matteorizzo@google.com> (Matteo Rizzo's
        message of "Thu, 29 Jun 2023 13:27:11 +0000")
Message-ID: <x49mt0i5jlb.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Matteo Rizzo <matteorizzo@google.com> writes:

> Introduce a new sysctl (io_uring_disabled) which can be either 0, 1,
> or 2. When 0 (the default), all processes are allowed to create io_uring
> instances, which is the current behavior. When 1, all calls to
> io_uring_setup fail with -EPERM unless the calling process has
> CAP_SYS_ADMIN. When 2, calls to io_uring_setup fail with -EPERM
> regardless of privilege.
>
> Signed-off-by: Matteo Rizzo <matteorizzo@google.com>

This looks good to me.  You may also consider updating the
io_uring_setup(2) man page (part of liburing) to reflect this new
meaning for -EPERM.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

> ---
>  Documentation/admin-guide/sysctl/kernel.rst | 19 +++++++++++++
>  io_uring/io_uring.c                         | 30 +++++++++++++++++++++
>  2 files changed, 49 insertions(+)
>
> diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
> index 3800fab1619b..ee65f7aeb0cf 100644
> --- a/Documentation/admin-guide/sysctl/kernel.rst
> +++ b/Documentation/admin-guide/sysctl/kernel.rst
> @@ -450,6 +450,25 @@ this allows system administrators to override the
>  ``IA64_THREAD_UAC_NOPRINT`` ``prctl`` and avoid logs being flooded.
>  
>  
> +io_uring_disabled
> +=================
> +
> +Prevents all processes from creating new io_uring instances. Enabling this
> +shrinks the kernel's attack surface.
> +
> += ==================================================================
> +0 All processes can create io_uring instances as normal. This is the
> +  default setting.
> +1 io_uring creation is disabled for unprivileged processes.
> +  io_uring_setup fails with -EPERM unless the calling process is
> +  privileged (CAP_SYS_ADMIN). Existing io_uring instances can
> +  still be used.
> +2 io_uring creation is disabled for all processes. io_uring_setup
> +  always fails with -EPERM. Existing io_uring instances can still be
> +  used.
> += ==================================================================
> +
> +
>  kexec_load_disabled
>  ===================
>  
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 1b53a2ab0a27..2343ae518546 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -153,6 +153,22 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx);
>  
>  struct kmem_cache *req_cachep;
>  
> +static int __read_mostly sysctl_io_uring_disabled;
> +#ifdef CONFIG_SYSCTL
> +static struct ctl_table kernel_io_uring_disabled_table[] = {
> +	{
> +		.procname	= "io_uring_disabled",
> +		.data		= &sysctl_io_uring_disabled,
> +		.maxlen		= sizeof(sysctl_io_uring_disabled),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= SYSCTL_ZERO,
> +		.extra2		= SYSCTL_TWO,
> +	},
> +	{},
> +};
> +#endif
> +
>  struct sock *io_uring_get_socket(struct file *file)
>  {
>  #if defined(CONFIG_UNIX)
> @@ -4000,9 +4016,18 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
>  	return io_uring_create(entries, &p, params);
>  }
>  
> +static inline bool io_uring_allowed(void)
> +{
> +	return sysctl_io_uring_disabled == 0 ||
> +		(sysctl_io_uring_disabled == 1 && capable(CAP_SYS_ADMIN));
> +}
> +
>  SYSCALL_DEFINE2(io_uring_setup, u32, entries,
>  		struct io_uring_params __user *, params)
>  {
> +	if (!io_uring_allowed())
> +		return -EPERM;
> +
>  	return io_uring_setup(entries, params);
>  }
>  
> @@ -4577,6 +4602,11 @@ static int __init io_uring_init(void)
>  
>  	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
>  				SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU);
> +
> +#ifdef CONFIG_SYSCTL
> +	register_sysctl_init("kernel", kernel_io_uring_disabled_table);
> +#endif
> +
>  	return 0;
>  };
>  __initcall(io_uring_init);

