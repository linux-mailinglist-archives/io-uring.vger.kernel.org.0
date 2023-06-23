Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5443873BEEC
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 21:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbjFWTgI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 15:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjFWTgI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 15:36:08 -0400
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6892701;
        Fri, 23 Jun 2023 12:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1687548966; x=1719084966;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dNuGXLt0we9p+hFppdMGSMyPfBu4liJLrmYKjCSYNz8=;
  b=cMe5GvGw7kk89ZjxYNC5nfJ0mIf65rdhw/f35LSzU4vPuId325tKY4W3
   u8+K+eXewNOZ3iR+fpWJIyWLXOZv+gl7HCeP8M4QXPDItKAbSt66luzap
   PEqf4cZjnITqOaDWq0PUWsiBeafvju2Fa954JVisl3z+EF56YkokNUuZr
   o=;
X-IronPort-AV: E=Sophos;i="6.01,152,1684800000"; 
   d="scan'208";a="138824582"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2023 19:36:05 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com (Postfix) with ESMTPS id B9F1240DB4;
        Fri, 23 Jun 2023 19:35:59 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 23 Jun 2023 19:35:44 +0000
Received: from 88665a182662.ant.amazon.com.com (10.187.171.23) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Fri, 23 Jun 2023 19:35:41 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <leitao@debian.org>
CC:     <asml.silence@gmail.com>, <axboe@kernel.dk>, <davem@davemloft.net>,
        <edumazet@google.com>, <gregkh@linuxfoundation.org>,
        <io-uring@vger.kernel.org>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <kuniyu@amazon.com>
Subject: [PATCH v3] io_uring: Add io_uring command support for sockets
Date:   Fri, 23 Jun 2023 12:35:32 -0700
Message-ID: <20230623193532.88760-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230622215915.2565207-1-leitao@debian.org>
References: <20230622215915.2565207-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.171.23]
X-ClientProxiedBy: EX19D045UWC003.ant.amazon.com (10.13.139.198) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Breno Leitao <leitao@debian.org>
Date: Thu, 22 Jun 2023 14:59:14 -0700
> Enable io_uring commands on network sockets. Create two new
> SOCKET_URING_OP commands that will operate on sockets.
> 
> In order to call ioctl on sockets, use the file_operations->io_uring_cmd
> callbacks, and map it to a uring socket function, which handles the
> SOCKET_URING_OP accordingly, and calls socket ioctls.
> 
> This patches was tested by creating a new test case in liburing.
> Link: https://github.com/leitao/liburing/tree/io_uring_cmd
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
> V1 -> V2:
> 	* Keep uring code outside of network core subsystem
> 	* Uses ioctl to define uring operation
> 	* Use a generic ioctl function, instead of copying it over
> V2 -> V3:
> 	* Do not use ioctl() helpers to create uring operations
> 	* Rename uring_sock_cmd to io_uring_cmd_sock
> ---
>  include/linux/io_uring.h      |  6 ++++++
>  include/uapi/linux/io_uring.h |  8 ++++++++
>  io_uring/uring_cmd.c          | 27 +++++++++++++++++++++++++++
>  net/socket.c                  |  2 ++
>  4 files changed, 43 insertions(+)
> 
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 7fe31b2cd02f..f00baf2929ff 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -71,6 +71,7 @@ static inline void io_uring_free(struct task_struct *tsk)
>  	if (tsk->io_uring)
>  		__io_uring_free(tsk);
>  }
> +int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
>  #else
>  static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>  			      struct iov_iter *iter, void *ioucmd)
> @@ -102,6 +103,11 @@ static inline const char *io_uring_get_opcode(u8 opcode)
>  {
>  	return "";
>  }
> +static inline int io_uring_cmd_sock(struct io_uring_cmd *cmd,
> +				    unsigned int issue_flags)
> +{
> +	return -EOPNOTSUPP;
> +}
>  #endif
>  
>  #endif
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 0716cb17e436..5c25f8c98aa8 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -703,6 +703,14 @@ struct io_uring_recvmsg_out {
>  	__u32 flags;
>  };
>  
> +/*
> + * Argument for IORING_OP_URING_CMD when file is a socket
> + */
> +enum {
> +	SOCKET_URING_OP_SIOCINQ		= 0,
> +	SOCKET_URING_OP_SIOCOUTQ,
> +};
> +
>  #ifdef __cplusplus
>  }
>  #endif
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 5e32db48696d..31ce59567295 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -7,6 +7,7 @@
>  #include <linux/nospec.h>
>  
>  #include <uapi/linux/io_uring.h>
> +#include <uapi/asm-generic/ioctls.h>
>  
>  #include "io_uring.h"
>  #include "rsrc.h"
> @@ -156,3 +157,29 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>  	return io_import_fixed(rw, iter, req->imu, ubuf, len);
>  }
>  EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
> +
> +int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
> +{
> +	struct socket *sock = cmd->file->private_data;
> +	struct sock *sk = sock->sk;
> +	int ret, arg = 0;

Please cache READ_ONCE(sk->sk_prot) here and reuse it.

Thanks.

> +
> +	if (!sk->sk_prot || !sk->sk_prot->ioctl)
> +		return -EOPNOTSUPP;
> +
> +	switch (cmd->sqe->cmd_op) {
> +	case SOCKET_URING_OP_SIOCINQ:
> +		ret = sk->sk_prot->ioctl(sk, SIOCINQ, &arg);
> +		if (ret)
> +			return ret;
> +		return arg;
> +	case SOCKET_URING_OP_SIOCOUTQ:
> +		ret = sk->sk_prot->ioctl(sk, SIOCOUTQ, &arg);
> +		if (ret)
> +			return ret;
> +		return arg;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(io_uring_cmd_sock);
> diff --git a/net/socket.c b/net/socket.c
> index b778fc03c6e0..09b105d00445 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -88,6 +88,7 @@
>  #include <linux/xattr.h>
>  #include <linux/nospec.h>
>  #include <linux/indirect_call_wrapper.h>
> +#include <linux/io_uring.h>
>  
>  #include <linux/uaccess.h>
>  #include <asm/unistd.h>
> @@ -159,6 +160,7 @@ static const struct file_operations socket_file_ops = {
>  #ifdef CONFIG_COMPAT
>  	.compat_ioctl = compat_sock_ioctl,
>  #endif
> +	.uring_cmd =    io_uring_cmd_sock,
>  	.mmap =		sock_mmap,
>  	.release =	sock_close,
>  	.fasync =	sock_fasync,
> -- 
> 2.34.1
