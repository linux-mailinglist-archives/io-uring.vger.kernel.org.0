Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D67977476E
	for <lists+io-uring@lfdr.de>; Tue,  8 Aug 2023 21:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbjHHTOt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Aug 2023 15:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235529AbjHHTOP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Aug 2023 15:14:15 -0400
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E266537C90;
        Tue,  8 Aug 2023 09:37:20 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-4fe44955decso28257e87.1;
        Tue, 08 Aug 2023 09:37:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691512594; x=1692117394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WLStaBoTlMXtsHG0LLCYkbddKzfAcQ5BShqSRpjotqI=;
        b=cAsypFqqvS+Y1at9eJ3zijNrYf0ExbU767ArQWvaTpHunW+EjPLYRZ68jJ9Fq6bmlQ
         iKE9VwwR9tXTPRipPom8syovBPjxiwW02P0SMW1DGE4J1AQZhSbX0O0OTWYLg4DuWCj8
         KXKZZCaf0uczTvDIkX8wAXkAPhVBoaLQ5WPQTNcGvnNY1yuJhbaNoba+ev0wxXSCYbfP
         KycSjnQmfGq0kiXgIJIpn86msevJGZ63S61ckWBcLijETXUO9zgVophEF/pDr2J8WZDg
         FwmXajkv+yXcLCq2LbOAud0c9V7h8aIormKQf+aSmxP2NQR+sWRuNZvl2pCuWzvBHc3j
         fuhQ==
X-Gm-Message-State: AOJu0YxVEv+LATBsrqAmNCgTsgVDZKzg17PzZdKp9ameNPyhiKujq3D8
        aET8o3K9vk8NRXEj6wAIclRAehcTsLpAVw==
X-Google-Smtp-Source: AGHT+IF4pL/BbT9L+kSVOMCx71cAwnol6Gbk2yOMizfp6UByrTTgxHgBZXsIOIp5AcahLoyQBhIXHQ==
X-Received: by 2002:a17:906:8a66:b0:99b:4210:cc76 with SMTP id hy6-20020a1709068a6600b0099b4210cc76mr10279182ejc.28.1691502069666;
        Tue, 08 Aug 2023 06:41:09 -0700 (PDT)
Received: from localhost (fwdproxy-cln-002.fbsv.net. [2a03:2880:31ff:2::face:b00c])
        by smtp.gmail.com with ESMTPSA id o17-20020a17090611d100b0099bd0b5a2bcsm6750611eja.101.2023.08.08.06.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 06:41:09 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v2 5/8] bpf: Leverage sockptr_t in BPF getsockopt hook
Date:   Tue,  8 Aug 2023 06:40:45 -0700
Message-Id: <20230808134049.1407498-6-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230808134049.1407498-1-leitao@debian.org>
References: <20230808134049.1407498-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Leverage sockptr_t structure to have an argument that is either an
userspace pointer, or, a kernel pointer.

This makes this function flexible, so, we can mix and match user and
kernel space pointers. The main motivation for this change is to use it
in the io_uring {g,s}etsockopt(), which will use a userspace pointer for
*optval, but, a kernel value for optlen.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/bpf-cgroup.h |  5 +++--
 kernel/bpf/cgroup.c        | 20 +++++++++++---------
 net/socket.c               |  5 +++--
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 57e9e109257e..d16cb99fd4f1 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -139,9 +139,10 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
 int __cgroup_bpf_run_filter_setsockopt(struct sock *sock, int *level,
 				       int *optname, char __user *optval,
 				       int *optlen, char **kernel_optval);
+
 int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
-				       int optname, char __user *optval,
-				       int __user *optlen, int max_optlen,
+				       int optname, sockptr_t optval,
+				       sockptr_t optlen, int max_optlen,
 				       int retval);
 
 int __cgroup_bpf_run_filter_getsockopt_kern(struct sock *sk, int level,
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 5b2741aa0d9b..ebc8c58f7e46 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1875,8 +1875,8 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 }
 
 int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
-				       int optname, char __user *optval,
-				       int __user *optlen, int max_optlen,
+				       int optname, sockptr_t optval,
+				       sockptr_t optlen, int max_optlen,
 				       int retval)
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
@@ -1903,8 +1903,8 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 		 * one that kernel returned as well to let
 		 * BPF programs inspect the value.
 		 */
-
-		if (get_user(ctx.optlen, optlen)) {
+		if (copy_from_sockptr(&ctx.optlen, optlen,
+				      sizeof(ctx.optlen))) {
 			ret = -EFAULT;
 			goto out;
 		}
@@ -1915,8 +1915,8 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 		}
 		orig_optlen = ctx.optlen;
 
-		if (copy_from_user(ctx.optval, optval,
-				   min(ctx.optlen, max_optlen)) != 0) {
+		if (copy_from_sockptr(ctx.optval, optval,
+				      min(ctx.optlen, max_optlen))) {
 			ret = -EFAULT;
 			goto out;
 		}
@@ -1930,7 +1930,8 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	if (ret < 0)
 		goto out;
 
-	if (optval && (ctx.optlen > max_optlen || ctx.optlen < 0)) {
+	if (!sockptr_is_null(optval) &&
+	    (ctx.optlen > max_optlen || ctx.optlen < 0)) {
 		if (orig_optlen > PAGE_SIZE && ctx.optlen >= 0) {
 			pr_info_once("bpf getsockopt: ignoring program buffer with optlen=%d (max_optlen=%d)\n",
 				     ctx.optlen, max_optlen);
@@ -1942,11 +1943,12 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	}
 
 	if (ctx.optlen != 0) {
-		if (optval && copy_to_user(optval, ctx.optval, ctx.optlen)) {
+		if (!sockptr_is_null(optval) &&
+		    copy_to_sockptr(optval, ctx.optval, ctx.optlen)) {
 			ret = -EFAULT;
 			goto out;
 		}
-		if (put_user(ctx.optlen, optlen)) {
+		if (copy_to_sockptr(optlen, &ctx.optlen, sizeof(ctx.optlen))) {
 			ret = -EFAULT;
 			goto out;
 		}
diff --git a/net/socket.c b/net/socket.c
index 8df54352af83..c686c6e89441 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2306,8 +2306,9 @@ int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
 
 	if (!in_compat_syscall())
 		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, optname,
-						     optval, optlen, max_optlen,
-						     err);
+						     USER_SOCKPTR(optval),
+						     USER_SOCKPTR(optlen),
+						     max_optlen, err);
 out_put:
 	fput_light(sock->file, fput_needed);
 	return err;
-- 
2.34.1

