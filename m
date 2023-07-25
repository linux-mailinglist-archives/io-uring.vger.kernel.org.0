Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B523761D43
	for <lists+io-uring@lfdr.de>; Tue, 25 Jul 2023 17:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbjGYPXe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Jul 2023 11:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbjGYPX0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Jul 2023 11:23:26 -0400
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F331BF8;
        Tue, 25 Jul 2023 08:23:16 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-98377c5d53eso903252266b.0;
        Tue, 25 Jul 2023 08:23:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690298595; x=1690903395;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SeFJod4z1e6v+MZcwp0xRr3/xc+96eNeLZWd9BPm8GM=;
        b=Y48ro5mOAnRZdYCzPUJUcOfSZHvNDTZ5bzKZzDPFsQscddX7UdYataaXvlwHv5Xk6K
         /mCUMnNLKJnmeycAZl+JubmoNkiXsripZf8kE0Uykps6I21OP8MD74vd0BQb04btmR11
         eEIiVBFh7m2pzlxpYTfOGo8gqLBTt6voeVKJa9mE0yzPwEmIVJWp43GjYDMhUNq7mBE/
         eMrjxL8nTnM2oWTBhG3S6qxlmsBSm7m91J1MxAzt+ixtcn5bhHOUbM7MzgMDNY75pU7r
         iFyuv6AGIYsUIWfayLTceYanZFidbyuSd7vXROr7OvafTi8FHs+busJV3/jzbZ/tAkUz
         iF7Q==
X-Gm-Message-State: ABy/qLYNBHpSl6PB4ilvbEzrfpA6f6h9zaZjuYxBbI+3dozxciu/8xwb
        Id/5f5hBDfe2Z6r+Y+Q9ALykXIVp1t4=
X-Google-Smtp-Source: APBJJlHpEcy/PxED+lupa2reCZ6KWMtcu5BAYXx0P8DdQJU4mBuEdGV8s4+IXF1rqWS4XfWtRwlsew==
X-Received: by 2002:a17:906:1c5:b0:988:fb2f:274e with SMTP id 5-20020a17090601c500b00988fb2f274emr12250726ejj.27.1690298594980;
        Tue, 25 Jul 2023 08:23:14 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-022.fbsv.net. [2a03:2880:31ff:16::face:b00c])
        by smtp.gmail.com with ESMTPSA id d6-20020a1709067f0600b009925cbafeaasm8331926ejr.100.2023.07.25.08.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 08:23:14 -0700 (PDT)
Date:   Tue, 25 Jul 2023 08:23:12 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, leit@meta.com
Subject: Re: [PATCH 2/4] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
Message-ID: <ZL/o4M2segCBZSm/@gmail.com>
References: <20230724142237.358769-1-leitao@debian.org>
 <20230724142237.358769-3-leitao@debian.org>
 <64bf01fc80d67_3b637629452@willemb.c.googlers.com.notmuch>
 <ZL+bLoZxIdqmh5m5@gmail.com>
 <64bfd4a27a1fe_3dc9bb2944e@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bfd4a27a1fe_3dc9bb2944e@willemb.c.googlers.com.notmuch>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FSL_HELO_FAKE,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 25, 2023 at 09:56:50AM -0400, Willem de Bruijn wrote:
> Breno Leitao wrote:
> > On Mon, Jul 24, 2023 at 06:58:04PM -0400, Willem de Bruijn wrote:
> > > Breno Leitao wrote:
> > > > Add support for getsockopt command (SOCKET_URING_OP_GETSOCKOPT), where
> > > > level is SOL_SOCKET. This is leveraging the sockptr_t infrastructure,
> > > > where a sockptr_t is either userspace or kernel space, and handled as
> > > > such.
> > > > 
> > > > Function io_uring_cmd_getsockopt() is inspired by __sys_getsockopt().
> > > > 
> > > > Differently from the getsockopt(2), the optlen field is not a userspace
> > > > pointers. In getsockopt(2), userspace provides optlen pointer, which is
> > > > overwritten by the kernel.  In this implementation, userspace passes a
> > > > u32, and the new value is returned in cqe->res. I.e., optlen is not a
> > > > pointer.
> > > > 
> > > > Important to say that userspace needs to keep the pointer alive until
> > > > the CQE is completed.
> > > > 
> > > > Signed-off-by: Breno Leitao <leitao@debian.org>
> > > > ---
> > > >  include/uapi/linux/io_uring.h |  7 ++++++
> > > >  io_uring/uring_cmd.c          | 43 +++++++++++++++++++++++++++++++++++
> > > >  2 files changed, 50 insertions(+)
> > > > 
> > > > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > > > index 9fc7195f25df..8152151080db 100644
> > > > --- a/include/uapi/linux/io_uring.h
> > > > +++ b/include/uapi/linux/io_uring.h
> > > > @@ -43,6 +43,10 @@ struct io_uring_sqe {
> > > >  	union {
> > > >  		__u64	addr;	/* pointer to buffer or iovecs */
> > > >  		__u64	splice_off_in;
> > > > +		struct {
> > > > +			__u32	level;
> > > > +			__u32	optname;
> > > > +		};
> > > >  	};
> > > >  	__u32	len;		/* buffer size or number of iovecs */
> > > >  	union {
> > > > @@ -79,6 +83,7 @@ struct io_uring_sqe {
> > > >  	union {
> > > >  		__s32	splice_fd_in;
> > > >  		__u32	file_index;
> > > > +		__u32	optlen;
> > > >  		struct {
> > > >  			__u16	addr_len;
> > > >  			__u16	__pad3[1];
> > > > @@ -89,6 +94,7 @@ struct io_uring_sqe {
> > > >  			__u64	addr3;
> > > >  			__u64	__pad2[1];
> > > >  		};
> > > > +		__u64	optval;
> > > >  		/*
> > > >  		 * If the ring is initialized with IORING_SETUP_SQE128, then
> > > >  		 * this field is used for 80 bytes of arbitrary command data
> > > > @@ -729,6 +735,7 @@ struct io_uring_recvmsg_out {
> > > >  enum {
> > > >  	SOCKET_URING_OP_SIOCINQ		= 0,
> > > >  	SOCKET_URING_OP_SIOCOUTQ,
> > > > +	SOCKET_URING_OP_GETSOCKOPT,
> > > >  };
> > > >  
> > > >  #ifdef __cplusplus
> > > > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > > > index 8e7a03c1b20e..16c857cbf3b0 100644
> > > > --- a/io_uring/uring_cmd.c
> > > > +++ b/io_uring/uring_cmd.c
> > > > @@ -166,6 +166,47 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
> > > >  
> > > > +static inline int io_uring_cmd_getsockopt(struct socket *sock,
> > > > +					  struct io_uring_cmd *cmd)
> > > > +{
> > > > +	void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
> > > > +	int optname = READ_ONCE(cmd->sqe->optname);
> > > > +	int optlen = READ_ONCE(cmd->sqe->optlen);
> > > > +	int level = READ_ONCE(cmd->sqe->level);
> > > > +	void *koptval;
> > > > +	int err;
> > > > +
> > > > +	err = security_socket_getsockopt(sock, level, optname);
> > > > +	if (err)
> > > > +		return err;
> > > > +
> > > > +	koptval = kmalloc(optlen, GFP_KERNEL);
> > > > +	if (!koptval)
> > > > +		return -ENOMEM;
> > > 
> > > This will try to kmalloc any length that userspace passes?
> > 
> > Yes, this value is coming directly from userspace.
> > 
> > > That is unnecessary ..
> > > > +
> > > > +	err = copy_from_user(koptval, optval, optlen);
> > > > +	if (err)
> > > > +		goto fail;
> > > > +
> > > > +	err = -EOPNOTSUPP;
> > > > +	if (level == SOL_SOCKET) {
> > > > +		err = sk_getsockopt(sock->sk, level, optname,
> > > > +				    KERNEL_SOCKPTR(koptval),
> > > > +				    KERNEL_SOCKPTR(&optlen));
> > > 
> > > .. sk_getsockopt defines a union of acceptable fields, which
> > > are all fairly small.
> > 
> > Right, and they are all I need for SOL_SOCKET level for now.
> > 
> > > I notice that BPF added BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN to
> > > work around the issue of pre-allocating for the worst case.
> > 
> > I am having a hard time how to understand how
> > BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN gets the MAX_OPTLEN. Reading this
> > function, it seems it is conditionally get_user().
> > 
> > 
> > 	#define BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen)
> > 	({
> > 		int __ret = 0;
> > 		if (cgroup_bpf_enabled(CGROUP_GETSOCKOPT))
> > 			get_user(__ret, optlen);
> > 		__ret;
> > 	})
> > 
> > That said, how is BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN being used to
> > workaroundthe pre-allocating for the worst case?
> > 
> > > But that also needs to deal woth other getsockopt levels.
> > 
> > Right, and we also have a similar kmalloc() on the setsockopt path
> > (SOCKET_URING_OP_SETSOCKOPT).
> > 
> > What about if I pass the userspace sockptr (USER_SOCKPTR) to the
> > {g,s}etsockopt callback directly, instead of kmalloc() in io_uring(), as
> > I was doing int the RFC[1]? It avoids any extra kmalloc at all.
> 
> That looks like a great solution to me.
> 
> Avoids the whole problem of kmalloc based on untrusted user input.
> 
> > Something as:
> > 
> > 	static inline int io_uring_cmd_getsockopt(struct socket *sock,
> > 						  struct io_uring_cmd *cmd)
> > 	{
> > 		void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
> > 		int optlen = READ_ONCE(cmd->sqe->optlen);
> > 		int optname = READ_ONCE(cmd->sqe->optname);
> > 		int level = READ_ONCE(cmd->sqe->level);
> > 		int err;
> > 
> > 		err = security_socket_getsockopt(sock, level, optname);
> > 		if (err)
> > 			return err;
> > 
> > 		if (level == SOL_SOCKET) {
> > 			err = sk_getsockopt(sock->sk, level, optname,
> > 					    USER_SOCKPTR(optval),
> > 					    KERNEL_SOCKPTR(&optlen));
> > 			if (err < 0)
> > 				return err;
> > 			return optlen;
> > 		}
> 
> Do you have a plan to extend this to other levels?
> 
> No need to implement immediately, but it would be good to know
> whether it is feasible to extend the current solution when the
> need (inevitably) shows up.

Yes, I plan to extend getsockopt() to all levels, but it means we need
to convert proto_ops->setsockopt to uset sockptr_t instead of
userpointers. This might require some intrusive changes, but totally
doable.
