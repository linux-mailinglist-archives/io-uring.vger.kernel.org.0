Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4330A760FBD
	for <lists+io-uring@lfdr.de>; Tue, 25 Jul 2023 11:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbjGYJwD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Jul 2023 05:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbjGYJvv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Jul 2023 05:51:51 -0400
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787611B8;
        Tue, 25 Jul 2023 02:51:46 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-9922d6f003cso910117866b.0;
        Tue, 25 Jul 2023 02:51:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690278705; x=1690883505;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9iSEd/zlhQUpki7xyVHvNMs7mBkWGGLATKxWLhRRQxE=;
        b=OVhAdKVwzkni8PcT6iIyfK0K5CP6RIhNj6AQ2udIpgDhZ75ZPz9RYfkGIC7hV5nHIO
         qVsKeU9smVVcGE+rQA0QR3yof3F8dZXRfUdEmFl/niR44EiKfM5Si06peM8j25fzsaVj
         4s+W9PzCZWfuY8CCsiD4aZqdmZzUdxEfRNgBdrFO+StD0+ngHqoEazrMX4n2h+fB0Set
         5umiDAF+6Tz4hJU573Cc/IayONS/HcWCs3mgKGr31v0eT/UQYR/5a9cEi6qSG7ycs5IY
         BtWOq6BGAidktbY9VPmQ0zqpT5UujtphDaCRnXMMC5UemCZpUWooP8OJ57ZKm2ynkBcc
         QcnA==
X-Gm-Message-State: ABy/qLa+75qKMCiTckHEHMbrgZYypzuTVKgZS4K4OjQhPSV51Fr4skHg
        ubm6/2u++byM5746HvTFZ3U=
X-Google-Smtp-Source: APBJJlHQf1kTga4kg6x0/K5B/uVhbsmb0HNitIU9KTi8Yt7DDaCg5T3fj+Q1haDLh8Lilguvx8s60A==
X-Received: by 2002:a17:906:300e:b0:993:eef2:5d5f with SMTP id 14-20020a170906300e00b00993eef25d5fmr12739535ejz.27.1690278704489;
        Tue, 25 Jul 2023 02:51:44 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-015.fbsv.net. [2a03:2880:31ff:f::face:b00c])
        by smtp.gmail.com with ESMTPSA id k20-20020a1709065fd400b009934b1eb577sm8077781ejv.77.2023.07.25.02.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 02:51:43 -0700 (PDT)
Date:   Tue, 25 Jul 2023 02:51:42 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, leit@meta.com
Subject: Re: [PATCH 2/4] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
Message-ID: <ZL+bLoZxIdqmh5m5@gmail.com>
References: <20230724142237.358769-1-leitao@debian.org>
 <20230724142237.358769-3-leitao@debian.org>
 <64bf01fc80d67_3b637629452@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bf01fc80d67_3b637629452@willemb.c.googlers.com.notmuch>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FSL_HELO_FAKE,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 24, 2023 at 06:58:04PM -0400, Willem de Bruijn wrote:
> Breno Leitao wrote:
> > Add support for getsockopt command (SOCKET_URING_OP_GETSOCKOPT), where
> > level is SOL_SOCKET. This is leveraging the sockptr_t infrastructure,
> > where a sockptr_t is either userspace or kernel space, and handled as
> > such.
> > 
> > Function io_uring_cmd_getsockopt() is inspired by __sys_getsockopt().
> > 
> > Differently from the getsockopt(2), the optlen field is not a userspace
> > pointers. In getsockopt(2), userspace provides optlen pointer, which is
> > overwritten by the kernel.  In this implementation, userspace passes a
> > u32, and the new value is returned in cqe->res. I.e., optlen is not a
> > pointer.
> > 
> > Important to say that userspace needs to keep the pointer alive until
> > the CQE is completed.
> > 
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> >  include/uapi/linux/io_uring.h |  7 ++++++
> >  io_uring/uring_cmd.c          | 43 +++++++++++++++++++++++++++++++++++
> >  2 files changed, 50 insertions(+)
> > 
> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > index 9fc7195f25df..8152151080db 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -43,6 +43,10 @@ struct io_uring_sqe {
> >  	union {
> >  		__u64	addr;	/* pointer to buffer or iovecs */
> >  		__u64	splice_off_in;
> > +		struct {
> > +			__u32	level;
> > +			__u32	optname;
> > +		};
> >  	};
> >  	__u32	len;		/* buffer size or number of iovecs */
> >  	union {
> > @@ -79,6 +83,7 @@ struct io_uring_sqe {
> >  	union {
> >  		__s32	splice_fd_in;
> >  		__u32	file_index;
> > +		__u32	optlen;
> >  		struct {
> >  			__u16	addr_len;
> >  			__u16	__pad3[1];
> > @@ -89,6 +94,7 @@ struct io_uring_sqe {
> >  			__u64	addr3;
> >  			__u64	__pad2[1];
> >  		};
> > +		__u64	optval;
> >  		/*
> >  		 * If the ring is initialized with IORING_SETUP_SQE128, then
> >  		 * this field is used for 80 bytes of arbitrary command data
> > @@ -729,6 +735,7 @@ struct io_uring_recvmsg_out {
> >  enum {
> >  	SOCKET_URING_OP_SIOCINQ		= 0,
> >  	SOCKET_URING_OP_SIOCOUTQ,
> > +	SOCKET_URING_OP_GETSOCKOPT,
> >  };
> >  
> >  #ifdef __cplusplus
> > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > index 8e7a03c1b20e..16c857cbf3b0 100644
> > --- a/io_uring/uring_cmd.c
> > +++ b/io_uring/uring_cmd.c
> > @@ -166,6 +166,47 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> >  }
> >  EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
> >  
> > +static inline int io_uring_cmd_getsockopt(struct socket *sock,
> > +					  struct io_uring_cmd *cmd)
> > +{
> > +	void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
> > +	int optname = READ_ONCE(cmd->sqe->optname);
> > +	int optlen = READ_ONCE(cmd->sqe->optlen);
> > +	int level = READ_ONCE(cmd->sqe->level);
> > +	void *koptval;
> > +	int err;
> > +
> > +	err = security_socket_getsockopt(sock, level, optname);
> > +	if (err)
> > +		return err;
> > +
> > +	koptval = kmalloc(optlen, GFP_KERNEL);
> > +	if (!koptval)
> > +		return -ENOMEM;
> 
> This will try to kmalloc any length that userspace passes?

Yes, this value is coming directly from userspace.

> That is unnecessary ..
> > +
> > +	err = copy_from_user(koptval, optval, optlen);
> > +	if (err)
> > +		goto fail;
> > +
> > +	err = -EOPNOTSUPP;
> > +	if (level == SOL_SOCKET) {
> > +		err = sk_getsockopt(sock->sk, level, optname,
> > +				    KERNEL_SOCKPTR(koptval),
> > +				    KERNEL_SOCKPTR(&optlen));
> 
> .. sk_getsockopt defines a union of acceptable fields, which
> are all fairly small.

Right, and they are all I need for SOL_SOCKET level for now.

> I notice that BPF added BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN to
> work around the issue of pre-allocating for the worst case.

I am having a hard time how to understand how
BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN gets the MAX_OPTLEN. Reading this
function, it seems it is conditionally get_user().


	#define BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen)
	({
		int __ret = 0;
		if (cgroup_bpf_enabled(CGROUP_GETSOCKOPT))
			get_user(__ret, optlen);
		__ret;
	})

That said, how is BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN being used to
workaroundthe pre-allocating for the worst case?

> But that also needs to deal woth other getsockopt levels.

Right, and we also have a similar kmalloc() on the setsockopt path
(SOCKET_URING_OP_SETSOCKOPT).

What about if I pass the userspace sockptr (USER_SOCKPTR) to the
{g,s}etsockopt callback directly, instead of kmalloc() in io_uring(), as
I was doing int the RFC[1]? It avoids any extra kmalloc at all.

Something as:

	static inline int io_uring_cmd_getsockopt(struct socket *sock,
						  struct io_uring_cmd *cmd)
	{
		void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
		int optlen = READ_ONCE(cmd->sqe->optlen);
		int optname = READ_ONCE(cmd->sqe->optname);
		int level = READ_ONCE(cmd->sqe->level);
		int err;

		err = security_socket_getsockopt(sock, level, optname);
		if (err)
			return err;

		if (level == SOL_SOCKET) {
			err = sk_getsockopt(sock->sk, level, optname,
					    USER_SOCKPTR(optval),
					    KERNEL_SOCKPTR(&optlen));
			if (err < 0)
				return err;
			return optlen;
		}

		return -EOPNOTSUPP;

Thanks for the review!

[1] Link: https://lore.kernel.org/all/20230719102737.2513246-3-leitao@debian.org/
