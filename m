Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0A37396C3
	for <lists+io-uring@lfdr.de>; Thu, 22 Jun 2023 07:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjFVFUz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jun 2023 01:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjFVFUy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jun 2023 01:20:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E60E9;
        Wed, 21 Jun 2023 22:20:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 463ED61724;
        Thu, 22 Jun 2023 05:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27178C433C0;
        Thu, 22 Jun 2023 05:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1687411251;
        bh=eGLXi+uLksYHHBlslNR0JrkdmKSXNfPy+zdjEsn8oDk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lqd5vzo92XkWQozOq8THy9F79ZZK2SH1MUWBLiCUkEZ/AIYHqQJj72S6F5IJs/xGb
         cZBlbHIdi3KeL13Y9f02+PQ786Jog6Evg5Kc6nqVcpjRvf9E08ua9XAgFEs7erbeRO
         CK++HIJlGMruS9JaFkW0lycQeHg3+GILARbQb9eM=
Date:   Thu, 22 Jun 2023 07:20:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Breno Leitao <leitao@debian.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, leit@meta.com,
        Arnd Bergmann <arnd@arndb.de>,
        Steve French <stfrench@microsoft.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Simon Ser <contact@emersion.fr>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:IO_URING" <io-uring@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: [PATCH] io_uring: Add io_uring command support for sockets
Message-ID: <2023062231-tasting-stranger-8882@gregkh>
References: <20230621232129.3776944-1-leitao@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230621232129.3776944-1-leitao@debian.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 21, 2023 at 04:21:26PM -0700, Breno Leitao wrote:
> Enable io_uring commands on network sockets. Create two new
> SOCKET_URING_OP commands that will operate on sockets. Since these
> commands are similar to ioctl, uses the _IO{R,W} helpers to embedded the
> argument size and operation direction. Also allocates a unused ioctl
> chunk for uring command usage.
> 
> In order to call ioctl on sockets, use the file_operations->uring_cmd
> callbacks, and map it to a uring socket function, which handles the
> SOCKET_URING_OP accordingly, and calls socket ioctls.
> 
> This patches was tested by creating a new test case in liburing.
> Link: https://github.com/leitao/liburing/commit/3340908b742c6a26f662a0679c4ddf9df84ef431
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---

Isn't this a new version of an older patch?

>  .../userspace-api/ioctl/ioctl-number.rst      |  1 +
>  include/linux/io_uring.h                      |  6 +++++
>  include/uapi/linux/io_uring.h                 |  6 +++++
>  io_uring/uring_cmd.c                          | 27 +++++++++++++++++++
>  net/socket.c                                  |  2 ++
>  5 files changed, 42 insertions(+)
> 
> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> index 4f7b23faebb9..23348636f2ef 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -361,6 +361,7 @@ Code  Seq#    Include File                                           Comments
>  0xCB  00-1F                                                          CBM serial IEC bus in development:
>                                                                       <mailto:michael.klein@puffin.lb.shuttle.de>
>  0xCC  00-0F  drivers/misc/ibmvmc.h                                   pseries VMC driver
> +0xCC  A0-BF  uapi/linux/io_uring.h                                   io_uring cmd subsystem

This change is nice, but not totally related to this specific one,
shouldn't it be separate?


>  0xCD  01     linux/reiserfs_fs.h
>  0xCE  01-02  uapi/linux/cxl_mem.h                                    Compute Express Link Memory Devices
>  0xCF  02     fs/smb/client/cifs_ioctl.h
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 7fe31b2cd02f..d1b20e2a9fb0 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -71,6 +71,7 @@ static inline void io_uring_free(struct task_struct *tsk)
>  	if (tsk->io_uring)
>  		__io_uring_free(tsk);
>  }
> +int uring_sock_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
>  #else
>  static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>  			      struct iov_iter *iter, void *ioucmd)
> @@ -102,6 +103,11 @@ static inline const char *io_uring_get_opcode(u8 opcode)
>  {
>  	return "";
>  }
> +static inline int uring_sock_cmd(struct io_uring_cmd *cmd,
> +				 unsigned int issue_flags)
> +{
> +	return -EOPNOTSUPP;
> +}
>  #endif
>  
>  #endif
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 0716cb17e436..e20ba410859d 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -703,6 +703,12 @@ struct io_uring_recvmsg_out {
>  	__u32 flags;
>  };
>  
> +/*
> + * Argument for IORING_OP_URING_CMD when file is a socket
> + */
> +#define SOCKET_URING_OP_SIOCINQ _IOR(0xcc, 0xa0, int)
> +#define SOCKET_URING_OP_SIOCOUTQ _IOR(0xcc, 0xa1, int)
> +
>  #ifdef __cplusplus
>  }
>  #endif
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 5e32db48696d..dcbe6493b03f 100644
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

Did you forget the "io_" prefix?

thanks,

greg k-h
