Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E85D788D78
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 18:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbjHYQyJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 12:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbjHYQyF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 12:54:05 -0400
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47539E77;
        Fri, 25 Aug 2023 09:54:02 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-9a1de3417acso461118866b.0;
        Fri, 25 Aug 2023 09:54:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692982441; x=1693587241;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lP7cZ2Rz5OnDrr8sQ04GNTnuORrvKWdUu3qvHzVHGws=;
        b=R0nO/pLGP33FZhAWAdCUIb34pLwFWWMW3oo6kXRJF4ReZR+PjGbVOB5HFnkgKfJvF9
         BYujvycMpO4bsshZTyK9FQ97fvgBrOYCVj/gRRE3mICWHBbLGcHS97Gl9Bit6ut1kveq
         loOmJDL4Pnupla08sfGLtgUhwHKjpOXgBG9krfmLxPKVgnloiC75X0Fb5g7etfEdQu8Y
         wQEAsWmNVjGldghsx7TTeMQItASa/9/g6shC1YitQpsi8+gnZrZ6jk+XQwCbRolVlJdB
         SIBni7v+vA5aD69OR+sQG2uFNe1xaBZ4NqraIv4UWQCe1qc5iacphXnYWmT2FiGeAdQx
         H1Ew==
X-Gm-Message-State: AOJu0YwahpJJ/hqcor9XV2MVR33B33Fy1VN23e0C3mJDZ5tqxaDIHM0S
        gM9jDww9MhCWvVBpYAU8FhI=
X-Google-Smtp-Source: AGHT+IEuGVqHOFGyJFWQzjtY1yWk9pBKq0Vq4sKCayTDkfjAubGXdPAXCAi5P0CQCpGGZ9/kzOdKYw==
X-Received: by 2002:a17:906:c116:b0:993:f664:ce25 with SMTP id do22-20020a170906c11600b00993f664ce25mr19345106ejc.19.1692982440507;
        Fri, 25 Aug 2023 09:54:00 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-003.fbsv.net. [2a03:2880:31ff:3::face:b00c])
        by smtp.gmail.com with ESMTPSA id dk24-20020a170906f0d800b0099ddc81903asm1125265ejb.221.2023.08.25.09.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 09:53:59 -0700 (PDT)
Date:   Fri, 25 Aug 2023 09:53:58 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Gabriel Krisman Bertazi <krisman@suse.de>, sdf@google.com,
        axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v3 8/9] io_uring/cmd: BPF hook for getsockopt cmd
Message-ID: <ZOjcpmlukOuEmuZ9@gmail.com>
References: <20230817145554.892543-1-leitao@debian.org>
 <20230817145554.892543-9-leitao@debian.org>
 <87pm3l32rk.fsf@suse.de>
 <6ae89b3a-b53d-dd2c-ecc6-1094f9b95586@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ae89b3a-b53d-dd2c-ecc6-1094f9b95586@linux.dev>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 21, 2023 at 01:25:25PM -0700, Martin KaFai Lau wrote:
> On 8/17/23 12:08 PM, Gabriel Krisman Bertazi wrote:
> > Shouldn't you call sock->ops->getsockopt for level!=SOL_SOCKET prior to
> > running the hook?  Before this patch, it would bail out with EOPNOTSUPP,
> > but now the bpf hook gets called even for level!=SOL_SOCKET, which
> > doesn't fit __sys_getsockopt. Am I misreading the code?
> I agree it should not call into bpf if the io_uring cannot support non
> SOL_SOCKET optnames. Otherwise, the bpf prog will get different optval and
> optlen when running in _sys_getsockopt vs io_uring getsockopt (e.g. in
> regular _sys_getsockopt(SOL_TCP), bpf expects the optval returned from
> tcp_getsockopt).
> 
> I think __sys_getsockopt can also be refactored similar to __sys_setsockopt
> in patch 3. Yes, for non SOL_SOCKET it only supports __user *optval and
> __user *optlen but may be a WARN_ON_ONCE/BUG_ON(sockpt_is_kernel(optval))
> can be added before calling ops->getsockopt()? Then this details can be
> hidden away from the io_uring.


Right, I've spent some time thinking about it, and this could be done.
This is a draft I have. Is it what you had in mind?

--

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 5e3419eb267a..e39743f4ce5e 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -378,7 +378,7 @@ static inline bool cgroup_bpf_sock_enabled(struct sock *sk,
 ({									       \
 	int __ret = 0;							       \
 	if (cgroup_bpf_enabled(CGROUP_GETSOCKOPT))			       \
-		get_user(__ret, optlen);				       \
+		copy_from_sockptr(&__ret, optlen, sizeof(int));		       \
 	__ret;								       \
 })
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 2a0324275347..24ea1719fd02 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1855,6 +1855,8 @@ int sock_setsockopt(struct socket *sock, int level, int op,
 		    sockptr_t optval, unsigned int optlen);
 int do_sock_setsockopt(struct socket *sock, bool compat, int level,
 		       int optname, sockptr_t optval, int optlen);
+int do_sock_getsockopt(struct socket *sock, bool compat, int level,
+		       int optname, sockptr_t optval, sockptr_t optlen);
 
 int sk_getsockopt(struct sock *sk, int level, int optname,
 		  sockptr_t optval, sockptr_t optlen);
diff --git a/net/core/sock.c b/net/core/sock.c
index 9370fd50aa2c..2a5f30f14f5c 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1997,14 +1997,6 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 	return 0;
 }
 
-int sock_getsockopt(struct socket *sock, int level, int optname,
-		    char __user *optval, int __user *optlen)
-{
-	return sk_getsockopt(sock->sk, level, optname,
-			     USER_SOCKPTR(optval),
-			     USER_SOCKPTR(optlen));
-}
-
 /*
  * Initialize an sk_lock.
  *
diff --git a/net/socket.c b/net/socket.c
index b5e4398a6b4d..f0d6b6b1f75e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2290,6 +2290,40 @@ SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
 INDIRECT_CALLABLE_DECLARE(bool tcp_bpf_bypass_getsockopt(int level,
 							 int optname));
 
+int do_sock_getsockopt(struct socket *sock, bool compat, int level,
+		       int optname, sockptr_t optval, sockptr_t optlen)
+{
+	int max_optlen __maybe_unused;
+	int err;
+
+	err = security_socket_getsockopt(sock, level, optname);
+	if (err)
+		return err;
+
+	if (level == SOL_SOCKET) {
+		err = sk_getsockopt(sock->sk, level, optname, optval, optlen);
+	} else if (unlikely(!sock->ops->getsockopt)) {
+		err = -EOPNOTSUPP;
+	} else {
+		if (WARN_ONCE(optval.is_kernel || optlen.is_kernel,
+			      "Invalid argument type"))
+			return -EOPNOTSUPP;
+
+		err = sock->ops->getsockopt(sock, level, optname, optval.user,
+					    optlen.user);
+	}
+
+	if (!compat) {
+		max_optlen = BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);
+		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, optname,
+						     optval, optlen, max_optlen,
+						     err);
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(do_sock_getsockopt);
+
 /*
  *	Get a socket option. Because we don't know the option lengths we have
  *	to pass a user mode parameter for the protocols to sort out.
@@ -2297,35 +2331,17 @@ INDIRECT_CALLABLE_DECLARE(bool tcp_bpf_bypass_getsockopt(int level,
 int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
 		int __user *optlen)
 {
-	int max_optlen __maybe_unused;
 	int err, fput_needed;
+	bool compat = in_compat_syscall();
 	struct socket *sock;
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		return err;
 
-	err = security_socket_getsockopt(sock, level, optname);
-	if (err)
-		goto out_put;
-
-	if (!in_compat_syscall())
-		max_optlen = BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);
-
-	if (level == SOL_SOCKET)
-		err = sock_getsockopt(sock, level, optname, optval, optlen);
-	else if (unlikely(!sock->ops->getsockopt))
-		err = -EOPNOTSUPP;
-	else
-		err = sock->ops->getsockopt(sock, level, optname, optval,
-					    optlen);
+	err = do_sock_getsockopt(sock, compat, level, optname,
+				 USER_SOCKPTR(optval), USER_SOCKPTR(optlen));
 
-	if (!in_compat_syscall())
-		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, optname,
-						     USER_SOCKPTR(optval),
-						     USER_SOCKPTR(optlen),
-						     max_optlen, err);
-out_put:
 	fput_light(sock->file, fput_needed);
 	return err;
 }
