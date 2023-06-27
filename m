Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9666C73FB98
	for <lists+io-uring@lfdr.de>; Tue, 27 Jun 2023 14:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbjF0MB0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Jun 2023 08:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbjF0MBY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Jun 2023 08:01:24 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CF310FC
        for <io-uring@vger.kernel.org>; Tue, 27 Jun 2023 05:01:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bb2fae9b286so5694023276.3
        for <io-uring@vger.kernel.org>; Tue, 27 Jun 2023 05:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687867282; x=1690459282;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aaVuD3HLMj8uVbz/Ei0maxQ5eITeDBVSdg3CAcaaAvU=;
        b=kWkGxNzo2pBixoyXLjeBlNREEZXwBCBrQkkxw3LBQXZslL74w4595Y1T8H6Y4fGF37
         gVj6eV1QM9Tn6NBp7lOUTVtHB7hG9Qo1AOEF6cHubSiBN+m6nle/C/NpMU7L2WiOSoqg
         pWI+6xnRg8sdTTKj9fM6ZlbSF1HCKydnWC/jhgE1zPYNNc6FgIm3WxVzV77BtATuPm4+
         yP/TxIi67DxgjMQPgFgpu71sc1Ag2dfOQudP+leqG4SUeoyvWjmY6sa/1wzI+9/hMqZq
         MoY5c3XlfgYdc9wpFxPE256L2duZl/qgFHKjdzBxVP+BWAJW7T5zzS8fl7iSxmBDuOvV
         9XbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687867282; x=1690459282;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aaVuD3HLMj8uVbz/Ei0maxQ5eITeDBVSdg3CAcaaAvU=;
        b=f9pNuzY/suNidQR4GREteg68xhUGqwgLUjv0QB6KIXsNVttqm8EAvWUyyUA7Ks4WcW
         hAts0iPWe3EvcNmWxzmWi+TVGxQTxm2B3uxHQi/9tQZeWkeX7uGUOueiDrqWEX0SeGSv
         xHp60NulOZfAYBMAuaShnC+wxzZhqFi+P8nkMxXbIsMF3dLC8yg5grNsnEMcKTfNr+fR
         toLxlXVd2uHdY5WlVummlCVrnlxIe2MqKbDcy+GfibM+aUV9I3vTpDC4Wm8XHB7bNR1r
         oB7h8U2OhOKbipVmayP6p8MDNf0phR7ENAFLnWaXTACYGSvBDpRZJpAghjRMwduJ8vl/
         NcNg==
X-Gm-Message-State: AC+VfDxgblDeSPaGKrxm+EYuFB+cZj9wBFvxVkJmRDH15T4oFarwLnUh
        7+6c5v6nFTXmcTBOEtNGguwjkJAMA0Z5nxf5DA==
X-Google-Smtp-Source: ACHHUZ65QqiqGazk/uIR4xUfnSeMbaVtHXrDciJN6Rf4o768ey3Qm+Gwm3vfwudGVR+45MdhS2x22Oqf2oMizUPbpA==
X-Received: from mr-cloudtop2.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:fb5])
 (user=matteorizzo job=sendgmr) by 2002:a25:e0d1:0:b0:c2a:e79a:fc11 with SMTP
 id x200-20020a25e0d1000000b00c2ae79afc11mr1049539ybg.9.1687867282457; Tue, 27
 Jun 2023 05:01:22 -0700 (PDT)
Date:   Tue, 27 Jun 2023 12:00:58 +0000
In-Reply-To: <20230627120058.2214509-1-matteorizzo@google.com>
Mime-Version: 1.0
References: <20230627120058.2214509-1-matteorizzo@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230627120058.2214509-2-matteorizzo@google.com>
Subject: [PATCH 1/1] Add a new sysctl to disable io_uring system-wide
From:   Matteo Rizzo <matteorizzo@google.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     matteorizzo@google.com, jordyzomer@google.com, evn@google.com,
        poprdi@google.com, corbet@lwn.net, axboe@kernel.dk,
        asml.silence@gmail.com, akpm@linux-foundation.org,
        keescook@chromium.org, rostedt@goodmis.org,
        dave.hansen@linux.intel.com, ribalda@chromium.org,
        chenhuacai@kernel.org, steve@sk2.org, gpiccoli@igalia.com,
        ldufour@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce a new sysctl (io_uring_disabled) which can be either 0 or 1.
When 0 (the default), all processes are allowed to create io_uring
instances, which is the current behavior. When 1, all calls to
io_uring_setup fail with -EPERM.

Signed-off-by: Matteo Rizzo <matteorizzo@google.com>
---
 Documentation/admin-guide/sysctl/kernel.rst | 14 ++++++++++++
 io_uring/io_uring.c                         | 24 +++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index d85d90f5d000..3c53a238332a 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -450,6 +450,20 @@ this allows system administrators to override the
 ``IA64_THREAD_UAC_NOPRINT`` ``prctl`` and avoid logs being flooded.
 
 
+io_uring_disabled
+=========================
+
+Prevents all processes from creating new io_uring instances. Enabling this
+shrinks the kernel's attack surface.
+
+= =============================================================
+0 All processes can create io_uring instances as normal. This is the default
+  setting.
+1 io_uring is disabled. io_uring_setup always fails with -EPERM. Existing
+  io_uring instances can still be used.
+= =============================================================
+
+
 kexec_load_disabled
 ===================
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1b53a2ab0a27..0496ae7017f7 100644
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
+		.extra2		= SYSCTL_ONE,
+	},
+	{},
+};
+#endif
+
 struct sock *io_uring_get_socket(struct file *file)
 {
 #if defined(CONFIG_UNIX)
@@ -4003,6 +4019,9 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 SYSCALL_DEFINE2(io_uring_setup, u32, entries,
 		struct io_uring_params __user *, params)
 {
+	if (sysctl_io_uring_disabled)
+		return -EPERM;
+
 	return io_uring_setup(entries, params);
 }
 
@@ -4577,6 +4596,11 @@ static int __init io_uring_init(void)
 
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

