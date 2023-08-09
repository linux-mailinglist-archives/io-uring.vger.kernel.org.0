Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D82776BEC
	for <lists+io-uring@lfdr.de>; Thu, 10 Aug 2023 00:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjHIWIS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 18:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjHIWIS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 18:08:18 -0400
X-Greylist: delayed 330 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Aug 2023 15:08:17 PDT
Received: from out-110.mta1.migadu.com (out-110.mta1.migadu.com [95.215.58.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F33D10C0
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 15:08:17 -0700 (PDT)
Message-ID: <afd0c815-e32f-6b57-a72b-4bcd46b78136@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691618564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qMJv6ufpqtknR1yGk38bAZzuEUJ6prfve1gllA06oPM=;
        b=T2KggH/EwPTITIwBwhHFSVHu4zjoW1l0wILdp1Zu6fK4jEvQccACra3z4KxIbDv3+Ow2Dh
        IMKV7G5YVbJvmBBCsVFiIRdzD/qGLH8oB/+x/i2fVsfKZ4fMzFbR2BJM7b2vU0Tb/iDjZM
        dyAfTOoZhxSCpuHuipwPY+XSm1MKepk=
Date:   Wed, 9 Aug 2023 15:02:31 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2 8/8] io_uring/cmd: BPF hook for setsockopt cmd
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, sdf@google.com, axboe@kernel.dk,
        asml.silence@gmail.com, willemdebruijn.kernel@gmail.com
References: <20230808134049.1407498-1-leitao@debian.org>
 <20230808134049.1407498-9-leitao@debian.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230808134049.1407498-9-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/8/23 6:40 AM, Breno Leitao wrote:
> Add support for BPF hooks for io_uring setsockopts command.
> 
> This implementation follows a similar approach to what
> __sys_setsockopt() does, but, operates only on kernel memory instead of
> user memory (which is also possible, but not preferred since the kernel
> memory is already available)
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>   io_uring/uring_cmd.c | 23 +++++++++++++++++++++--
>   1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 3693e5779229..b7b27e4dbddd 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -205,23 +205,42 @@ static inline int io_uring_cmd_setsockopt(struct socket *sock,
>   {
>   	void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
>   	int optname = READ_ONCE(cmd->sqe->optname);
> +	sockptr_t optval_s = USER_SOCKPTR(optval);
>   	int optlen = READ_ONCE(cmd->sqe->optlen);
>   	int level = READ_ONCE(cmd->sqe->level);
> +	char *kernel_optval = NULL;
>   	int err;
>   
>   	err = security_socket_setsockopt(sock, level, optname);
>   	if (err)
>   		return err;
>   
> +	if (!in_compat_syscall()) {
> +		err = BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, &level,
> +						     &optname,
> +						     USER_SOCKPTR(optval),
> +						     &optlen,
> +						     &kernel_optval);
> +		if (err < 0)
> +			return err;
> +		if (err > 0)
> +			return 0;
> +
> +		/* Replace optval by the one returned by BPF */
> +		if (kernel_optval)
> +			optval_s = KERNEL_SOCKPTR(kernel_optval);
> +	}
> +
>   	if (level == SOL_SOCKET && !sock_use_custom_sol_socket(sock))
>   		err = sock_setsockopt(sock, level, optname,
> -				      USER_SOCKPTR(optval), optlen);
> +				      optval_s, optlen);
>   	else if (unlikely(!sock->ops->setsockopt))
>   		err = -EOPNOTSUPP;
>   	else
>   		err = sock->ops->setsockopt(sock, level, optname,
> -					    USER_SOCKPTR(koptval), optlen);
> +					    optval_s, optlen);

The bpf side changes make sense. Thanks.

With all the bpf pieces in place, __sys_{get,set}sockopt() is looking very 
similar to io_uring_cmd_{get,set}sockopt(). There are small differences like one 
takes fd and another already has a sock ptr, and io_uring_cmd_getsockopt() is 
SOL_SOCKET only. In general, can they be refactored somehow such that future 
changes don't have to be made in multiple places?

