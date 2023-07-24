Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292AA7602D8
	for <lists+io-uring@lfdr.de>; Tue, 25 Jul 2023 00:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjGXW6I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 18:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjGXW6H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 18:58:07 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0FB115;
        Mon, 24 Jul 2023 15:58:06 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-7679ea01e16so445362785a.2;
        Mon, 24 Jul 2023 15:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690239485; x=1690844285;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ECJiZB/WKKYiQG7/FbcoTT/A0gytpZCyT4RLBuHqHxk=;
        b=HyRd134PbYNKlL3xJYOBD6YW+yP1QTkMntDPjUaulcEN2bsRfmZOUf+ti7TiAH4ibz
         wv91TAe/bNU9oiWHZOtpW8k/omDikJ+IeIVZa4G7/g5XaqH33YhCvoiCOxx66S/DFCin
         2v5B82au89VayVLQpRBUh3rJV6qcyIfW/LxeS0B6nKUbEGioGfLFX2mLQM6RhiJ5Y3Q/
         RCILdvxVcP7eO1qHfxNEWfCebOXi2HT1rvtlKogtAxuUquYcfdqRfmNB1CirRB+/owaV
         j3kwFNlutl/E4ABpr6PGLCE1D5r05lp69XAl6jrM+F9JhbuBkj0A1/BDUaNy1Y7UUX+K
         73Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690239485; x=1690844285;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ECJiZB/WKKYiQG7/FbcoTT/A0gytpZCyT4RLBuHqHxk=;
        b=YpXkhHkzjle3t2NZ7NfxV58yVFBk8yjFOTEd5XvMoSJOxO0A/3GRtH7zQHKehcRew9
         qBvpU9IPb7OdMgYMai3M2w944dUq8IoSuE59sl44X+xsq7ZzPjEA0HsHM7RCHp3mljEW
         8Z2D13zGAVTjYyGDhWISJLCoOch8cXD4H6euxb5piz98Iyvyri6n6qZEmTFupyco9aqr
         jPqJjLRakkXI8z02ZkfXUYLbIfSydGSEK6BP6eiI65Q4gz05i8hFdmvei2zBQSHaTjcj
         ZmrqDrHGHBzkW5ANNc+89alN2tkakd5XuSUBRX5blbBFLrmXO7gFitC/HpJQZ5/b9VCG
         Pzzw==
X-Gm-Message-State: ABy/qLbzF/kdbwGF4/KiQwrGnOuiYHkCtkkTJhOvhkrV5MLrRBOArF06
        nrjc5TvHOk9z8TCXJcUt0ZM=
X-Google-Smtp-Source: APBJJlHMH2sxFb+Lk8KbHVDkRZ2DA/adfsYEMk87sKdnT+fcHDNvVmL9VlUs5QmtlpD88AzZZAXETQ==
X-Received: by 2002:a05:620a:4042:b0:767:ba3e:b3c4 with SMTP id i2-20020a05620a404200b00767ba3eb3c4mr1633617qko.7.1690239485267;
        Mon, 24 Jul 2023 15:58:05 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id oo22-20020a05620a531600b00762f37b206dsm3297776qkn.81.2023.07.24.15.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 15:58:04 -0700 (PDT)
Date:   Mon, 24 Jul 2023 18:58:04 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Breno Leitao <leitao@debian.org>, asml.silence@gmail.com,
        axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, linux-kernel@vger.kernel.org, leit@meta.com
Message-ID: <64bf01fc80d67_3b637629452@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230724142237.358769-3-leitao@debian.org>
References: <20230724142237.358769-1-leitao@debian.org>
 <20230724142237.358769-3-leitao@debian.org>
Subject: RE: [PATCH 2/4] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Breno Leitao wrote:
> Add support for getsockopt command (SOCKET_URING_OP_GETSOCKOPT), where
> level is SOL_SOCKET. This is leveraging the sockptr_t infrastructure,
> where a sockptr_t is either userspace or kernel space, and handled as
> such.
> 
> Function io_uring_cmd_getsockopt() is inspired by __sys_getsockopt().
> 
> Differently from the getsockopt(2), the optlen field is not a userspace
> pointers. In getsockopt(2), userspace provides optlen pointer, which is
> overwritten by the kernel.  In this implementation, userspace passes a
> u32, and the new value is returned in cqe->res. I.e., optlen is not a
> pointer.
> 
> Important to say that userspace needs to keep the pointer alive until
> the CQE is completed.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  include/uapi/linux/io_uring.h |  7 ++++++
>  io_uring/uring_cmd.c          | 43 +++++++++++++++++++++++++++++++++++
>  2 files changed, 50 insertions(+)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 9fc7195f25df..8152151080db 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -43,6 +43,10 @@ struct io_uring_sqe {
>  	union {
>  		__u64	addr;	/* pointer to buffer or iovecs */
>  		__u64	splice_off_in;
> +		struct {
> +			__u32	level;
> +			__u32	optname;
> +		};
>  	};
>  	__u32	len;		/* buffer size or number of iovecs */
>  	union {
> @@ -79,6 +83,7 @@ struct io_uring_sqe {
>  	union {
>  		__s32	splice_fd_in;
>  		__u32	file_index;
> +		__u32	optlen;
>  		struct {
>  			__u16	addr_len;
>  			__u16	__pad3[1];
> @@ -89,6 +94,7 @@ struct io_uring_sqe {
>  			__u64	addr3;
>  			__u64	__pad2[1];
>  		};
> +		__u64	optval;
>  		/*
>  		 * If the ring is initialized with IORING_SETUP_SQE128, then
>  		 * this field is used for 80 bytes of arbitrary command data
> @@ -729,6 +735,7 @@ struct io_uring_recvmsg_out {
>  enum {
>  	SOCKET_URING_OP_SIOCINQ		= 0,
>  	SOCKET_URING_OP_SIOCOUTQ,
> +	SOCKET_URING_OP_GETSOCKOPT,
>  };
>  
>  #ifdef __cplusplus
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 8e7a03c1b20e..16c857cbf3b0 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -166,6 +166,47 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>  }
>  EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
>  
> +static inline int io_uring_cmd_getsockopt(struct socket *sock,
> +					  struct io_uring_cmd *cmd)
> +{
> +	void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
> +	int optname = READ_ONCE(cmd->sqe->optname);
> +	int optlen = READ_ONCE(cmd->sqe->optlen);
> +	int level = READ_ONCE(cmd->sqe->level);
> +	void *koptval;
> +	int err;
> +
> +	err = security_socket_getsockopt(sock, level, optname);
> +	if (err)
> +		return err;
> +
> +	koptval = kmalloc(optlen, GFP_KERNEL);
> +	if (!koptval)
> +		return -ENOMEM;

This will try to kmalloc any length that userspace passes?

That is unnecessary ..

> +
> +	err = copy_from_user(koptval, optval, optlen);
> +	if (err)
> +		goto fail;
> +
> +	err = -EOPNOTSUPP;
> +	if (level == SOL_SOCKET) {
> +		err = sk_getsockopt(sock->sk, level, optname,
> +				    KERNEL_SOCKPTR(koptval),
> +				    KERNEL_SOCKPTR(&optlen));

.. sk_getsockopt defines a union of acceptable fields, which
are all fairly small.

I notice that BPF added BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN to
work around the issue of pre-allocating for the worst case.

But that also needs to deal woth other getsockopt levels.


> +		if (err)
> +			goto fail;
> +	}
> +
> +	err = copy_to_user(optval, koptval, optlen);
> +
> +fail:
> +	kfree(koptval);
> +	if (err)
> +		return err;
> +	else
> +		return optlen;
> +}
> +
>  int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
>  {
>  	struct socket *sock = cmd->file->private_data;
> @@ -187,6 +228,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
>  		if (ret)
>  			return ret;
>  		return arg;
> +	case SOCKET_URING_OP_GETSOCKOPT:
> +		return io_uring_cmd_getsockopt(sock, cmd);
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> -- 
> 2.34.1
> 


