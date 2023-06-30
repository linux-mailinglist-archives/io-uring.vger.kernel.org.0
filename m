Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E8A743E4F
	for <lists+io-uring@lfdr.de>; Fri, 30 Jun 2023 17:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbjF3PK6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Jun 2023 11:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbjF3PK5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Jun 2023 11:10:57 -0400
Received: from mail-ej1-x649.google.com (mail-ej1-x649.google.com [IPv6:2a00:1450:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44383A81
        for <io-uring@vger.kernel.org>; Fri, 30 Jun 2023 08:10:55 -0700 (PDT)
Received: by mail-ej1-x649.google.com with SMTP id a640c23a62f3a-94a34a0b75eso146777166b.1
        for <io-uring@vger.kernel.org>; Fri, 30 Jun 2023 08:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688137854; x=1690729854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t5yVCNzX7W1gRfvbajrTwlTVeQWrGAK4q/VSSd9dfqA=;
        b=wRD0T7EAigpqv2x6hJbLZj1kYlgIciGkbQCn3GQRJch3RlmIzNRilMGhZwheYiC8bO
         +5jxAhyIKtCTlfucML9q8/grI0N/T+DlgBnXMuM0NcfVktHdM16m2+1u3Pe9Ax3yM7P3
         4PbJqpryGhBtO6kP7U7xsbUeQPvKMQP5kuGXOwj2MAQlJvFJyiLyyxuYhuktA/w5wbZk
         KNgj9dEM/RXv+qy9UQRmxtfzW/a0l7Cs/BlEBRRJY0iRB0w5MV/iaLxhCs3veCa8HE0h
         8WpO1O9BN9n94/SFY1U5UXFvar5u3sTkWo1u3SJx+WRZ0v35+JwgSOlB7SsbcQxLoP3P
         ilDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688137854; x=1690729854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t5yVCNzX7W1gRfvbajrTwlTVeQWrGAK4q/VSSd9dfqA=;
        b=Rz/XO8GD1JlOAy59ad4ady8DQ9b664cYzp955b4UgZlj1uQonTKNjEkZXUiuUU2ieY
         a7Wl2FeVcuOsWSZg3IE5I5MPBp4i2GbGCGJUIpsJz3k8SZeB3NM7NYSz4l0jp/cPOiP9
         T9H++nVPsRtLLR4rDMPLQN5e+FVy3AbEyMuEfwT5MF940grVPuDQpXTiqudEprwj5Ad6
         GLeuxvjxfKI8iRsrpuKPOTXdaxhpWxiAudVNuog1dBKI3nOvGP1YPof5Lpf0/EaVcbo+
         beAVtwXS5AbcXxr8DypU5aNW1mBnWR/q34Y+viAkfNBkJTDvZSKxn1ZI9UFohSmaitKe
         NW3g==
X-Gm-Message-State: ABy/qLbJnu25z6AbW3ZF5Stw1Zr6DOhA4tMxDPzdzYZFTseQzVGX99xi
        mq0/4jV6W85aPPiLx1YdzrQFv6uoBLMAvs/Oaw==
X-Google-Smtp-Source: APBJJlHwSE7OK+c+fQ+eGFx7kZ+1YrrviqcQx9ITyGRJBG2Dk3t+Q6xw96scq3XLRhTRCFeLuZBnSWqRSlxC6xUbtg==
X-Received: from mr-cloudtop2.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:fb5])
 (user=matteorizzo job=sendgmr) by 2002:a17:906:9159:b0:98f:bdb9:4a37 with
 SMTP id y25-20020a170906915900b0098fbdb94a37mr5326ejw.3.1688137854020; Fri,
 30 Jun 2023 08:10:54 -0700 (PDT)
Date:   Fri, 30 Jun 2023 15:10:03 +0000
In-Reply-To: <20230630151003.3622786-1-matteorizzo@google.com>
Mime-Version: 1.0
References: <20230630151003.3622786-1-matteorizzo@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230630151003.3622786-2-matteorizzo@google.com>
Subject: [PATCH v3 1/1] io_uring: add a sysctl to disable io_uring system-wide
From:   Matteo Rizzo <matteorizzo@google.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com
Cc:     matteorizzo@google.com, corbet@lwn.net, akpm@linux-foundation.org,
        keescook@chromium.org, ribalda@chromium.org, rostedt@goodmis.org,
        jannh@google.com, chenhuacai@kernel.org, gpiccoli@igalia.com,
        ldufour@linux.ibm.com, evn@google.com, poprdi@google.com,
        jordyzomer@google.com, jmoyer@redhat.com, krisman@suse.de
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
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 Documentation/admin-guide/sysctl/kernel.rst | 19 +++++++++++++
 io_uring/io_uring.c                         | 31 +++++++++++++++++++++
 2 files changed, 50 insertions(+)

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
index e8096d502a7c..5410f5576980 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -152,6 +152,22 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx);
 
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
@@ -4015,9 +4031,19 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	return io_uring_create(entries, &p, params);
 }
 
+static inline bool io_uring_allowed(void)
+{
+	int disabled = READ_ONCE(sysctl_io_uring_disabled);
+
+	return disabled == 0 || (disabled == 1 && capable(CAP_SYS_ADMIN));
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
 
@@ -4592,6 +4618,11 @@ static int __init io_uring_init(void)
 
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
2.41.0.255.g8b1d071c50-goog

