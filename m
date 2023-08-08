Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CCA7742F5
	for <lists+io-uring@lfdr.de>; Tue,  8 Aug 2023 19:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbjHHRx0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Aug 2023 13:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbjHHRxE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Aug 2023 13:53:04 -0400
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D780429B5D;
        Tue,  8 Aug 2023 09:23:36 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-31765aee31bso4407799f8f.1;
        Tue, 08 Aug 2023 09:23:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691511776; x=1692116576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Evi9zaaIocUJUljhUqjZf7aG4nW/p3HKqWc5e4qc1/c=;
        b=lD9mAXwki50v5R4shgAO1eWV6+duHpa3z72W63T7UURzzxtw3HoaFXmxhgceq6d7FT
         q7QMebiG8AHcS1p6i/B0zGbry6Gp/YEFrtKAUzPdclXOfk8h/tgW1VQ+8x4o7J0GHXve
         LXGmBh8JBE8yAkCwAQcIno4ShJJtcF26kmLq1bVkwv4vxQE368eYHIJywEd9IR3x0SdV
         AiJq2ikEthR2wECttUhEjMf1mX5dUuWOYpVXPzFfwE/iWv6amFPW9/XBVgzsYAHzEon4
         ZWW/+sWxUHHyxlOr7NwDHktMHE/brgKXLPb09e+epZo32UBm1yqYlHCa5o7AUyHW4OAG
         8zgQ==
X-Gm-Message-State: AOJu0Yx4BO3TxX9eF4R6aGXjrCgpMirBYdzlwbS2IyPskoPDLucjHL7f
        p4FLyEKCFx2cGKEhc3OpbJith4rK6nMObA==
X-Google-Smtp-Source: AGHT+IF+kwB5pVAkz6onSyAIl+T5+1+ttJMPZ4G+vAb/sWRvLXfUO1y6Zyhx90T3HXmclZ/857Yrnw==
X-Received: by 2002:a17:906:3046:b0:992:6064:f32b with SMTP id d6-20020a170906304600b009926064f32bmr11160819ejd.46.1691502071224;
        Tue, 08 Aug 2023 06:41:11 -0700 (PDT)
Received: from localhost (fwdproxy-cln-020.fbsv.net. [2a03:2880:31ff:14::face:b00c])
        by smtp.gmail.com with ESMTPSA id d11-20020a170906c20b00b00992d70f8078sm6731416ejz.106.2023.08.08.06.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 06:41:10 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v2 6/8] bpf: Leverage sockptr_t in BPF setsockopt hook
Date:   Tue,  8 Aug 2023 06:40:46 -0700
Message-Id: <20230808134049.1407498-7-leitao@debian.org>
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

Move BPF setsockopt hook (__cgroup_bpf_run_filter_setsockopt()) to use
sockptr instead of user pointers. This brings flexibility to the
function, since it could be called with userspace or kernel pointers.

This also aligns with the getsockopt() counterpart, which is now using
sockptr_t types.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/bpf-cgroup.h | 2 +-
 kernel/bpf/cgroup.c        | 5 +++--
 net/socket.c               | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index d16cb99fd4f1..5e3419eb267a 100644
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
index c686c6e89441..b7d22633995a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2241,7 +2241,7 @@ int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
 
 	if (!in_compat_syscall())
 		err = BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, &level, &optname,
-						     user_optval, &optlen,
+						     optval, &optlen,
 						     &kernel_optval);
 	if (err < 0)
 		goto out_put;
-- 
2.34.1

