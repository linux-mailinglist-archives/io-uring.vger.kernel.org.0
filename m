Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E1F791B6C
	for <lists+io-uring@lfdr.de>; Mon,  4 Sep 2023 18:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238097AbjIDQZ2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Sep 2023 12:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237311AbjIDQZ1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Sep 2023 12:25:27 -0400
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5324A18B;
        Mon,  4 Sep 2023 09:25:24 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-52a4737a08fso2149587a12.3;
        Mon, 04 Sep 2023 09:25:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693844723; x=1694449523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IUL6OhPSlmc9b0ojpccZ5UMJYWzfKfwD3kXIKD6Vw5c=;
        b=Ip4ojanxIMbB1us7R3axNK4aY8r2jFrdH3KO1U2WrgTZEST0mBqE9/wL2fkE5VbEBc
         U4X5dB1B/ErVtAPMeNWcXdRDiTFMVY7npxlVYHlW76zyGfofdtQqhdO94L1cxfBBoI/D
         Hl5QXnNqg2ovQny1aJS8A1Ff0lJiOfM5/QOjCrAND42qWxjmRwGjDJrCK8THFaoWglvp
         kbo9c/8vYPRWZOnqmVML/F4Z+kkCQsmB+5fFOTXbl6SMMNGF1m+wjgTtPPvNkaBzb1hu
         YwXehJuhOGol70f50B16HWbYbo6Il+yXV15tyq/pThVsxeefqC9JptTm27lzbQ4F3Q1I
         35mQ==
X-Gm-Message-State: AOJu0YyN+m+J/AXwrxwUUn+BR7orhBwtirlX0aC8TTzJoyZL37bykg4p
        0h6hTr9rUyTyrCHGjHTGtfo=
X-Google-Smtp-Source: AGHT+IGbGNrDUERojvuHE3aYx8OauARPUDOpinBUn7+ySnAYjNNZQ1ONkGITStggwcvefZ2dq5hrcw==
X-Received: by 2002:a05:6402:2047:b0:523:95e:c2c0 with SMTP id bc7-20020a056402204700b00523095ec2c0mr7062520edb.42.1693844722624;
        Mon, 04 Sep 2023 09:25:22 -0700 (PDT)
Received: from localhost (fwdproxy-cln-006.fbsv.net. [2a03:2880:31ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id w11-20020aa7d28b000000b0052565298bedsm5987110edq.34.2023.09.04.09.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 09:25:22 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        krisman@suse.de, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>,
        Yonghong Song <yonghong.song@linux.dev>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v4 02/10] bpf: Leverage sockptr_t in BPF setsockopt hook
Date:   Mon,  4 Sep 2023 09:24:55 -0700
Message-Id: <20230904162504.1356068-3-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230904162504.1356068-1-leitao@debian.org>
References: <20230904162504.1356068-1-leitao@debian.org>
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

Change BPF setsockopt hook (__cgroup_bpf_run_filter_setsockopt()) to use
sockptr instead of user pointers. This brings flexibility to the
function, since it could be called with userspace or kernel pointers.

This change will allow the creation of a core sock_setsockopt, called
do_sock_setsockopt(), which will be called from both the system call path
and by io_uring command.

This also aligns with the getsockopt() counterpart, which is now using
sockptr_t universal pointer.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/bpf-cgroup.h | 2 +-
 kernel/bpf/cgroup.c        | 5 +++--
 net/socket.c               | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index f5b4fb6ed8c6..cecfe8c99f28 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -137,7 +137,7 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
 				   enum cgroup_bpf_attach_type atype);
 
 int __cgroup_bpf_run_filter_setsockopt(struct sock *sock, int *level,
-				       int *optname, char __user *optval,
+				       int *optname, sockptr_t optval,
 				       int *optlen, char **kernel_optval);
 
 int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index ebc8c58f7e46..f0dedd4f7f2e 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1785,7 +1785,7 @@ static bool sockopt_buf_allocated(struct bpf_sockopt_kern *ctx,
 }
 
 int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
-				       int *optname, char __user *optval,
+				       int *optname, sockptr_t optval,
 				       int *optlen, char **kernel_optval)
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
@@ -1808,7 +1808,8 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 
 	ctx.optlen = *optlen;
 
-	if (copy_from_user(ctx.optval, optval, min(*optlen, max_optlen)) != 0) {
+	if (copy_from_sockptr(ctx.optval, optval,
+			      min(*optlen, max_optlen))) {
 		ret = -EFAULT;
 		goto out;
 	}
diff --git a/net/socket.c b/net/socket.c
index 6fda5d011521..9ec9a8a07c0e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2287,7 +2287,7 @@ int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
 
 	if (!in_compat_syscall())
 		err = BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, &level, &optname,
-						     user_optval, &optlen,
+						     optval, &optlen,
 						     &kernel_optval);
 	if (err < 0)
 		goto out_put;
-- 
2.34.1

