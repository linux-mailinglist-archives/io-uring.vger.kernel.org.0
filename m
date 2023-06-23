Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877AB73B6D3
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 13:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjFWLzU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 07:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjFWLzT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 07:55:19 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 23 Jun 2023 04:55:16 PDT
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF7FBA;
        Fri, 23 Jun 2023 04:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=6vQmPuTY7+r8oEGoWdR7QXjNWbWLdLq/qWIKBX65su4=; b=hUuItrjAtIysZde3kgHWlnwafr
        moYHXuqnRPgxEYFBCYrTLaHEKl/KxJXo1YqGg4cxOD1gw0Xa6fw7NOd5bhpKPMc1UedWHKm6yrykJ
        Fkl9vrxuPJq4tDpQPnoc6Ot25Nq5dGmSjATqJsliEnXOwg5clY/psKFYSkYox95ULsB7OJ71QB8xA
        rfpZk9upLEDGZdlD0d+MOhs0xdBCNtxKRykUd/+JEt9+NUcjFbXvWWQdasNYsRnPUGq2xCH0jOP0k
        kIxd9lSVVQ1JZ2dGPnR97mpY05PHCGCIRZ5PxrZgDUifrbqYRQDg53gv41AxIf94ZW3iJrNdC4Kuy
        Y+QvkgsA+piaOj4V2UBtfiWCZWFXBMs3DdmEWsCB78QxxTT1po0X2pAy7y0ZKx/+PM+2QVoojWt6B
        Ysag1oWZZbi5TYYjarcEjySnL8FwrjTuR2ZV/SfkG7MrFvJvvqDkcZu9s/jmRmHipleTM9OTRR+v1
        R03VUBIlMC5G7xCcO19jmgUA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qCdql-003wDq-29;
        Fri, 23 Jun 2023 10:17:07 +0000
Message-ID: <e72f4c43-02a7-936c-e755-1b23596fc312@samba.org>
Date:   Fri, 23 Jun 2023 12:17:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC PATCH v2 1/4] net: wire up support for
 file_operations->uring_cmd()
Content-Language: en-US, de-DE
To:     Breno Leitao <leitao@debian.org>, axboe@kernel.dk,
        dsahern@kernel.org, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <martineau@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>, leit@fb.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dccp@vger.kernel.org, mptcp@lists.linux.dev,
        linux-sctp@vger.kernel.org, ast@kernel.org, kuniyu@amazon.com,
        martin.lau@kernel.org, Jason Xing <kernelxing@tencent.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Willem de Bruijn <willemb@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        Andrea Righi <andrea.righi@canonical.com>
References: <20230614110757.3689731-1-leitao@debian.org>
 <20230614110757.3689731-2-leitao@debian.org>
 <6b5e5988-3dc7-f5d6-e447-397696c0d533@kernel.org>
 <ZJA6AwbRWtSiJ5pL@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <ZJA6AwbRWtSiJ5pL@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 19.06.23 um 13:20 schrieb Breno Leitao:
> On Wed, Jun 14, 2023 at 08:15:10AM -0700, David Ahern wrote:
>> On 6/14/23 5:07 AM, Breno Leitao wrote:
>> io_uring is just another in-kernel user of sockets. There is no reason
>> for io_uring references to be in core net code. It should be using
>> exposed in-kernel APIs and doing any translation of its op codes in
>> io_uring/  code.
> 
> Thanks for the feedback. If we want to keep the network subsystem
> untouched, then I we can do it using an approach similar to the
> following. Is this a better approach moving forward?

I'd like to keep it passed to socket layer, so that sockets could
implement some extra features in an async fashion.

What about having the function you posted below (and in v3)
as a default implementation if proto_ops->uring_cmd is NULL?

metze

> --
> 
> From: Breno Leitao <leitao@debian.org>
> Date: Mon, 19 Jun 2023 03:37:40 -0700
> Subject: [RFC PATCH v2] io_uring: add initial io_uring_cmd support for sockets
> 
> Enable io_uring command operations on sockets. Create two
> SOCKET_URING_OP commands that will operate on sockets.
> 
> For that, use the file_operations->uring_cmd callback, and map it to a
> uring socket callback, which handles the SOCKET_URING_OP accordingly.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>   include/linux/io_uring.h      |  6 ++++++
>   include/uapi/linux/io_uring.h |  8 ++++++++
>   io_uring/uring_cmd.c          | 27 +++++++++++++++++++++++++++
>   net/socket.c                  |  2 ++
>   4 files changed, 43 insertions(+)
> 
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 7fe31b2cd02f..d1b20e2a9fb0 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -71,6 +71,7 @@ static inline void io_uring_free(struct task_struct *tsk)
>   	if (tsk->io_uring)
>   		__io_uring_free(tsk);
>   }
> +int uring_sock_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
>   #else
>   static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>   			      struct iov_iter *iter, void *ioucmd)
> @@ -102,6 +103,11 @@ static inline const char *io_uring_get_opcode(u8 opcode)
>   {
>   	return "";
>   }
> +static inline int uring_sock_cmd(struct io_uring_cmd *cmd,
> +				 unsigned int issue_flags)
> +{
> +	return -EOPNOTSUPP;
> +}
>   #endif
>   
>   #endif
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 0716cb17e436..d93a5ee7d984 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -703,6 +703,14 @@ struct io_uring_recvmsg_out {
>   	__u32 flags;
>   };
>   
> +/*
> + * Argument for IORING_OP_URING_CMD when file is a socket
> + */
> +enum {
> +	SOCKET_URING_OP_SIOCINQ         = 0,
> +	SOCKET_URING_OP_SIOCOUTQ,
> +};
> +
>   #ifdef __cplusplus
>   }
>   #endif
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 5e32db48696d..dcbe6493b03f 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -7,6 +7,7 @@
>   #include <linux/nospec.h>
>   
>   #include <uapi/linux/io_uring.h>
> +#include <uapi/asm-generic/ioctls.h>
>   
>   #include "io_uring.h"
>   #include "rsrc.h"
> @@ -156,3 +157,29 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>   	return io_import_fixed(rw, iter, req->imu, ubuf, len);
>   }
>   EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
> +
> +int uring_sock_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
> +{
> +	struct socket *sock = cmd->file->private_data;
> +	struct sock *sk = sock->sk;
> +	int ret, arg = 0;
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
> +EXPORT_SYMBOL_GPL(uring_sock_cmd);
> diff --git a/net/socket.c b/net/socket.c
> index b778fc03c6e0..db11e94d2259 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -88,6 +88,7 @@
>   #include <linux/xattr.h>
>   #include <linux/nospec.h>
>   #include <linux/indirect_call_wrapper.h>
> +#include <linux/io_uring.h>
>   
>   #include <linux/uaccess.h>
>   #include <asm/unistd.h>
> @@ -159,6 +160,7 @@ static const struct file_operations socket_file_ops = {
>   #ifdef CONFIG_COMPAT
>   	.compat_ioctl = compat_sock_ioctl,
>   #endif
> +	.uring_cmd =    uring_sock_cmd,
>   	.mmap =		sock_mmap,
>   	.release =	sock_close,
>   	.fasync =	sock_fasync,

