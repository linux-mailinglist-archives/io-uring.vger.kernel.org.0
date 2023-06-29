Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCBC742760
	for <lists+io-uring@lfdr.de>; Thu, 29 Jun 2023 15:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbjF2N1u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jun 2023 09:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbjF2N1s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jun 2023 09:27:48 -0400
Received: from mail-ed1-x549.google.com (mail-ed1-x549.google.com [IPv6:2a00:1450:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD9630EE
        for <io-uring@vger.kernel.org>; Thu, 29 Jun 2023 06:27:47 -0700 (PDT)
Received: by mail-ed1-x549.google.com with SMTP id 4fb4d7f45d1cf-51d91ca5635so502017a12.3
        for <io-uring@vger.kernel.org>; Thu, 29 Jun 2023 06:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688045266; x=1690637266;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kY7/aamj2EYJQ18ZqzDDw0qtsWDVxqm6PPibtWgkSrk=;
        b=JCTZZvCiBVSUwY/VlOx6zbqdMgQ8vDXSYLPyW51p0SzRVnKdolQReI6SJCJ5vCJQkI
         m6z3kLVUXRfoEy4ST9FRMGwRZ0LOUAsuQ3QUT2uZyIm+z20kRfnO0L/k2pEiKKfnhioe
         zlGZQQH5njPlya0jsgBopxygTxKMhnUaV/AxCKZdlfMEKO+IeFjrBuhi74rHneSf3IUx
         Rmu4B+vK7Ty0HmmhD4zU5q/ULFCW/yDPJIUGaztpIXYM35urnp5FMWLaYg9l9vu8jPkZ
         vwQVGrR+8gKRKvK4tywtkM1IsCxqrFmtJum9cyU+UAaiKCUirO9zfZfuSr04D6cXK4ke
         00aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688045266; x=1690637266;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kY7/aamj2EYJQ18ZqzDDw0qtsWDVxqm6PPibtWgkSrk=;
        b=lYdMdsm220LdONgxwkz8//7BPbQKLDPepqiB/wVvmbas3CGmJ4qgRc1Gl1oTRSEUPj
         kZtmt33KY2W8qKX23FYXAFXfLkU2NnEp0SB7a8MR0sbkckYt4qmBPs34+SeizVhKEr0l
         ayTBhIJlTGb733q87MO37ZGmATUlEDtc0eSnsXpuXEdnG0V4AHf3/5Uq9ErD8U02gimC
         XVag/UhzvI1G5RzzmM/TKiPRWnqHU9rjrSWLKRsfnT3UJMG0WiQ9wEV6piV2LPrm8UXt
         zk7ki7BOlwTsOSqdgHRuhAamiGtV17uXSeu/Sdg2OAm6ERFUhIq+6E6ddzQWhUCrPEqZ
         M77Q==
X-Gm-Message-State: AC+VfDy6/hMZlTHrPa7lfiSGjKKtWijyFiL7xNbKIsE2tMrw/Uhgm6JZ
        WR1HXoYxS/0clLbzs80mXYoC5I0f/eML4V4LUQ==
X-Google-Smtp-Source: ACHHUZ4Z1JPrtb+B8F/xAtxs24V0Tz1SdqWlwA36W8Imxf2YTr59tVZmNrQf6uEf1YGFSzBZ24dfMO6dorroRhl/Sg==
X-Received: from mr-cloudtop2.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:fb5])
 (user=matteorizzo job=sendgmr) by 2002:a50:9f8e:0:b0:51b:df2d:60c5 with SMTP
 id c14-20020a509f8e000000b0051bdf2d60c5mr3202943edf.5.1688045265970; Thu, 29
 Jun 2023 06:27:45 -0700 (PDT)
Date:   Thu, 29 Jun 2023 13:27:11 +0000
In-Reply-To: <20230629132711.1712536-1-matteorizzo@google.com>
Mime-Version: 1.0
References: <20230629132711.1712536-1-matteorizzo@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230629132711.1712536-2-matteorizzo@google.com>
Subject: [PATCH v2 1/1] Add a new sysctl to disable io_uring system-wide
From:   Matteo Rizzo <matteorizzo@google.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     matteorizzo@google.com, jordyzomer@google.com, evn@google.com,
        poprdi@google.com, corbet@lwn.net, axboe@kernel.dk,
        asml.silence@gmail.com, akpm@linux-foundation.org,
        keescook@chromium.org, rostedt@goodmis.org,
        dave.hansen@linux.intel.com, ribalda@chromium.org,
        chenhuacai@kernel.org, steve@sk2.org, gpiccoli@igalia.com,
        ldufour@linux.ibm.com, bhe@redhat.com, oleksandr@natalenko.name
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce a new sysctl (io_uring_disabled) which can be either 0, 1,
or 2. When 0 (the default), all processes are allowed to create io_uring
instances, which is the current behavior. When 1, all calls to
io_uring_setup fail with -EPERM unless the calling process has
CAP_SYS_ADMIN. When 2, calls to io_uring_setup fail with -EPERM
regardless of privilege.

Signed-off-by: Matteo Rizzo <matteorizzo@google.com>
---
 Documentation/admin-guide/sysctl/kernel.rst | 19 +++++++++++++
 io_uring/io_uring.c                         | 30 +++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index 3800fab1619b..ee65f7aeb0cf 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -450,6 +450,25 @@ this allows system administrators to override the
 ``IA64_THREAD_UAC_NOPRINT`` ``prctl`` and avoid logs being flooded.
 
 
+io_uring_disabled
+=================
+
+Prevents all processes from creating new io_uring instances. Enabling this
+shrinks the kernel's attack surface.
+
+= ==================================================================
+0 All processes can create io_uring instances as normal. This is the
+  default setting.
+1 io_uring creation is disabled for unprivileged processes.
+  io_uring_setup fails with -EPERM unless the calling process is
+  privileged (CAP_SYS_ADMIN). Existing io_uring instances can
+  still be used.
+2 io_uring creation is disabled for all processes. io_uring_setup
+  always fails with -EPERM. Existing io_uring instances can still be
+  used.
+= ==================================================================
+
+
 kexec_load_disabled
 ===================
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1b53a2ab0a27..2343ae518546 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -153,6 +153,22 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx);
 
 struct kmem_cache *req_cachep;
 
+static int __read_mostly sysctl_io_uring_disabled;
+#ifdef CONFIG_SYSCTL
+static struct ctl_table kernel_io_uring_disabled_table[] = {
+	{
+		.procname	= "io_uring_disabled",
+		.data		= &sysctl_io_uring_disabled,
+		.maxlen		= sizeof(sysctl_io_uring_disabled),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_TWO,
+	},
+	{},
+};
+#endif
+
 struct sock *io_uring_get_socket(struct file *file)
 {
 #if defined(CONFIG_UNIX)
@@ -4000,9 +4016,18 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	return io_uring_create(entries, &p, params);
 }
 
+static inline bool io_uring_allowed(void)
+{
+	return sysctl_io_uring_disabled == 0 ||
+		(sysctl_io_uring_disabled == 1 && capable(CAP_SYS_ADMIN));
+}
+
 SYSCALL_DEFINE2(io_uring_setup, u32, entries,
 		struct io_uring_params __user *, params)
 {
+	if (!io_uring_allowed())
+		return -EPERM;
+
 	return io_uring_setup(entries, params);
 }
 
@@ -4577,6 +4602,11 @@ static int __init io_uring_init(void)
 
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
 				SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU);
+
+#ifdef CONFIG_SYSCTL
+	register_sysctl_init("kernel", kernel_io_uring_disabled_table);
+#endif
+
 	return 0;
 };
 __initcall(io_uring_init);
-- 
2.41.0.162.gfafddb0af9-goog

