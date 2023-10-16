Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0C87CAABA
	for <lists+io-uring@lfdr.de>; Mon, 16 Oct 2023 16:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbjJPOBp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Oct 2023 10:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbjJPOBm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Oct 2023 10:01:42 -0400
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52316EE;
        Mon, 16 Oct 2023 07:01:38 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-9be02fcf268so411182366b.3;
        Mon, 16 Oct 2023 07:01:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697464897; x=1698069697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WWPtWPFuY/M4SoBkCUSlFAjHNbqqRZMGeiXE9WRKkYQ=;
        b=P/DwvOQEQve6ZpxmuubzwgxbR245NuITfohSUZQePM7oqRKD+SMiIXg9/rix7rZZBE
         PkFkTEA2SoZWnj1R5Q66k2UB/to77Fpa4AjQdbx1kFJO+F+PExKwfcbBWcS2AQ6t/gan
         pPJDUCyViIDodjXCi7ELFTmlPr75NiP7lGYyzIA/yj9L96f+UCvt5FKhWEn3TejEJtM5
         MBV9lu19RFtcKMUWxt5Cn/FBW0dUC6iEnm9BAvs4PvmBxjnXsK6eDym9dzjnFCfaKTPw
         iJNtTCxP6164tfq0m5k+37hJTUJFgZK6T1Bs0EpKqGl7y2axFIyUtPnD/JSvg0yvHy1M
         o40Q==
X-Gm-Message-State: AOJu0YzB10EPkb1Z2XZTAOj7p1L72SihgK4nSigH/a928Rwkk4ac23Oh
        8SQ9Dyv8NjINEkbnXmzOvRsIn20Zwppxaw==
X-Google-Smtp-Source: AGHT+IFHwgMnqwu+7mLuJU+UPYetaVODLxb6FdjWiU8/9L+Gcywfc8TRnfR/y135aYRThNIO9vMR4w==
X-Received: by 2002:a17:907:3f93:b0:9be:84c1:447e with SMTP id hr19-20020a1709073f9300b009be84c1447emr7074691ejc.41.1697464896425;
        Mon, 16 Oct 2023 07:01:36 -0700 (PDT)
Received: from localhost (fwdproxy-cln-014.fbsv.net. [2a03:2880:31ff:e::face:b00c])
        by smtp.gmail.com with ESMTPSA id v2-20020a1709062f0200b009829d2e892csm4197386eji.15.2023.10.16.07.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 07:01:36 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, martin.lau@linux.dev, krisman@suse.de,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>,
        Yonghong Song <yonghong.song@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v7 02/11] bpf: Add sockptr support for setsockopt
Date:   Mon, 16 Oct 2023 06:47:40 -0700
Message-Id: <20231016134750.1381153-3-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231016134750.1381153-1-leitao@debian.org>
References: <20231016134750.1381153-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The whole network stack uses sockptr, and while it doesn't move to
something more modern, let's use sockptr in setsockptr BPF hooks, so, it
could be used by other callers.

The main motivation for this change is to use it in the io_uring
{g,s}etsockopt(), which will use a userspace pointer for *optval, but, a
kernel value for optlen.

Link: https://lore.kernel.org/all/ZSArfLaaGcfd8LH8@gmail.com/

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/bpf-cgroup.h | 2 +-
 kernel/bpf/cgroup.c        | 5 +++--
 net/socket.c               | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 7b55844f6ba7..2912dce9144e 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -143,7 +143,7 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
 				   enum cgroup_bpf_attach_type atype);
 
 int __cgroup_bpf_run_filter_setsockopt(struct sock *sock, int *level,
-				       int *optname, char __user *optval,
+				       int *optname, sockptr_t optval,
 				       int *optlen, char **kernel_optval);
 
 int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 97745f67ac15..491d20038cbe 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1800,7 +1800,7 @@ static bool sockopt_buf_allocated(struct bpf_sockopt_kern *ctx,
 }
 
 int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
-				       int *optname, char __user *optval,
+				       int *optname, sockptr_t optval,
 				       int *optlen, char **kernel_optval)
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
@@ -1823,7 +1823,8 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 
 	ctx.optlen = *optlen;
 
-	if (copy_from_user(ctx.optval, optval, min(*optlen, max_optlen)) != 0) {
+	if (copy_from_sockptr(ctx.optval, optval,
+			      min(*optlen, max_optlen))) {
 		ret = -EFAULT;
 		goto out;
 	}
diff --git a/net/socket.c b/net/socket.c
index 6b47dd499218..28d3eb339514 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2305,7 +2305,7 @@ int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
 
 	if (!in_compat_syscall())
 		err = BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, &level, &optname,
-						     user_optval, &optlen,
+						     optval, &optlen,
 						     &kernel_optval);
 	if (err < 0)
 		goto out_put;
-- 
2.34.1

