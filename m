Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F587CAAB8
	for <lists+io-uring@lfdr.de>; Mon, 16 Oct 2023 16:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbjJPOBn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Oct 2023 10:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbjJPOBj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Oct 2023 10:01:39 -0400
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9DFD9;
        Mon, 16 Oct 2023 07:01:36 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-99c3d3c3db9so728968366b.3;
        Mon, 16 Oct 2023 07:01:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697464895; x=1698069695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BGpYuQ/HvFRXAQLjvk1eNuhCfrp6z3QssX2Bjc4Qs8s=;
        b=YhQe2nRPqpsxLol/M3CzgBKcVPgQ7EJ2wSxdhO/e4WjSVaAmP8MbisMcE7w/OiAiug
         PIYEYbR7xvvr4odMwiDkZFRlCYUDeo1KJWqQ6FNx5/9vRsGOSDT8OC0UKUp0nvhj38kr
         DL9LNSfXnlHYoajob5x39//kM+c1qaexIRkWkpL7G6h/RZEDVANFiB1OIc/GiMPB/WsH
         OxoEIRinWXyD3+Q2kAytsUJsGWqY7wVs0zgjNdPoJOstXlzLLdgIslvYXb3N993NMqqf
         UY11rux/n4quVotVXymylU2X9MY5f0Gs2ftYVWg3ftTDQ7PLDsVTgeYSkLTXVmZ/BwCE
         lO4g==
X-Gm-Message-State: AOJu0YzXYz/YvpDpcGb5KY2xqyMzz3WzuSHRUo5z3L9pdNuhruaZCiEy
        Jrjvb9yUNeRjALWjuzYLTH9qDifw3BfCbA==
X-Google-Smtp-Source: AGHT+IENToe/pC3Zq3wZAuelAOKNiCnB7z+pnfbfOxPWte7jDbaNexD1RWad2EsnGhYmBqUe4EOzdA==
X-Received: by 2002:a17:907:7ea0:b0:9a5:9038:b1e7 with SMTP id qb32-20020a1709077ea000b009a59038b1e7mr37648574ejc.36.1697464894500;
        Mon, 16 Oct 2023 07:01:34 -0700 (PDT)
Received: from localhost (fwdproxy-cln-117.fbsv.net. [2a03:2880:31ff:75::face:b00c])
        by smtp.gmail.com with ESMTPSA id l16-20020a1709066b9000b009b65b2be80bsm4085535ejr.76.2023.10.16.07.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 07:01:34 -0700 (PDT)
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
Subject: [PATCH v7 01/11] bpf: Add sockptr support for getsockopt
Date:   Mon, 16 Oct 2023 06:47:39 -0700
Message-Id: <20231016134750.1381153-2-leitao@debian.org>
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
something more modern, let's use sockptr in getsockptr BPF hooks, so, it
could be used by other callers.

The main motivation for this change is to use it in the io_uring
{g,s}etsockopt(), which will use a userspace pointer for *optval, but, a
kernel value for optlen.

Link: https://lore.kernel.org/all/ZSArfLaaGcfd8LH8@gmail.com/

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/bpf-cgroup.h |  5 +++--
 kernel/bpf/cgroup.c        | 20 +++++++++++---------
 net/socket.c               |  5 +++--
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 98b8cea904fe..7b55844f6ba7 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -145,9 +145,10 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
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
index 74ad2215e1ba..97745f67ac15 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1890,8 +1890,8 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 }
 
 int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
-				       int optname, char __user *optval,
-				       int __user *optlen, int max_optlen,
+				       int optname, sockptr_t optval,
+				       sockptr_t optlen, int max_optlen,
 				       int retval)
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
@@ -1918,8 +1918,8 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
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
@@ -1930,8 +1930,8 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 		}
 		orig_optlen = ctx.optlen;
 
-		if (copy_from_user(ctx.optval, optval,
-				   min(ctx.optlen, max_optlen)) != 0) {
+		if (copy_from_sockptr(ctx.optval, optval,
+				      min(ctx.optlen, max_optlen))) {
 			ret = -EFAULT;
 			goto out;
 		}
@@ -1945,7 +1945,8 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	if (ret < 0)
 		goto out;
 
-	if (optval && (ctx.optlen > max_optlen || ctx.optlen < 0)) {
+	if (!sockptr_is_null(optval) &&
+	    (ctx.optlen > max_optlen || ctx.optlen < 0)) {
 		if (orig_optlen > PAGE_SIZE && ctx.optlen >= 0) {
 			pr_info_once("bpf getsockopt: ignoring program buffer with optlen=%d (max_optlen=%d)\n",
 				     ctx.optlen, max_optlen);
@@ -1957,11 +1958,12 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
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
index 5740475e084c..6b47dd499218 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2373,8 +2373,9 @@ int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
 
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

