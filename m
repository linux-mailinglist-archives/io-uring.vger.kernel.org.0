Return-Path: <io-uring+bounces-2222-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 272C9909438
	for <lists+io-uring@lfdr.de>; Sat, 15 Jun 2024 00:47:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D19B1F22182
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 22:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E41AD1836E1;
	Fri, 14 Jun 2024 22:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="taUckVY6"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF22C2F50;
	Fri, 14 Jun 2024 22:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718405220; cv=none; b=NjbjXLyY29G4uFrAXN9bywBCbJ7fjGIKYkRNcUAzLAA2K3IAmGBCpmKiGHuHn0i7+0QWLkjZcApEjVL7b4RK5iTqaTQKVCd0I/0S6iZF2QPgcf864jvrlgdQ5xMPv3OiNqdvSyrrxhLEnOGRy/EGPSqsM02mq+/4NPUX+Wu0pPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718405220; c=relaxed/simple;
	bh=HWlbewA4hydtcQCRdUsjlTiEV+RHfYFKlFQGQhWV8lA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hfk/jKXbhFXu2ao0wp5JS2SaHtmmrLAwT2ih6ww8bEyNZ50FECmJefQbGhRdUqchovf6zjoP5pht1LZs6/8gmB9OCLmoJksrF+9mQma7iWAGFNHzZ0+2SvBA9fgWH8uogRzjS5b8Tx/yodvkmdF45E0OGevaGLkrr+UBexhWjQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=taUckVY6; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1718405219; x=1749941219;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NHNS0L8Psnke3c21PKb1PEPVjFN4REnVGQ5ZTqSNQII=;
  b=taUckVY6VpM2ZrPkSZujaC3kwkbDMxvsKFGaW8sfYJJ8dfGSmMeFHHhx
   290q8FgxODtRlPPl2E0WKuQQsgyOp0A3HYrkly8QTrHQmTw+I/pqHZK0s
   KbxmebdNJOnSddd3kBdw80zs247FavL3igufUDk5sBhpLub4//t0bAZo9
   o=;
X-IronPort-AV: E=Sophos;i="6.08,239,1712620800"; 
   d="scan'208";a="639498337"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 22:46:54 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.38.20:2135]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.60.144:2525] with esmtp (Farcaster)
 id f6398825-ab3d-4355-bd1d-91155fc3f29c; Fri, 14 Jun 2024 22:46:53 +0000 (UTC)
X-Farcaster-Flow-ID: f6398825-ab3d-4355-bd1d-91155fc3f29c
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 14 Jun 2024 22:46:52 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.100.24) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 14 Jun 2024 22:46:51 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <krisman@suse.de>
CC: <axboe@kernel.dk>, <io-uring@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] io_uring: Introduce IORING_OP_BIND
Date: Fri, 14 Jun 2024 15:46:43 -0700
Message-ID: <20240614224643.21456-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240614163047.31581-3-krisman@suse.de>
References: <20240614163047.31581-3-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D032UWA004.ant.amazon.com (10.13.139.56) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

From: Gabriel Krisman Bertazi <krisman@suse.de>
Date: Fri, 14 Jun 2024 12:30:46 -0400
> IORING_OP_BIND provides the semantic of bind(2) via io_uring.  While
> this is an essentially synchronous system call, the main point is to
> enable a network path to execute fully with io_uring registered and
> descriptorless files.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
> 
> ---
> changes since v1:
> - drop explocit error handling for move_addr_to_kernel (jens)
> - Remove empty line ahead of return;
> ---
>  include/uapi/linux/io_uring.h |  1 +
>  io_uring/net.c                | 36 +++++++++++++++++++++++++++++++++++
>  io_uring/net.h                |  3 +++
>  io_uring/opdef.c              | 13 +++++++++++++
>  4 files changed, 53 insertions(+)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 994bf7af0efe..4ef153d95c87 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -257,6 +257,7 @@ enum io_uring_op {
>  	IORING_OP_FUTEX_WAITV,
>  	IORING_OP_FIXED_FD_INSTALL,
>  	IORING_OP_FTRUNCATE,
> +	IORING_OP_BIND,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 0a48596429d9..8cbc29aff15c 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -51,6 +51,11 @@ struct io_connect {
>  	bool				seen_econnaborted;
>  };
>  
> +struct io_bind {
> +	struct file			*file;
> +	int				addr_len;
> +};
> +
>  struct io_sr_msg {
>  	struct file			*file;
>  	union {
> @@ -1715,6 +1720,37 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
>  	return IOU_OK;
>  }
>  
> +int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
> +	struct sockaddr __user *uaddr;
> +	struct io_async_msghdr *io;
> +
> +	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
> +		return -EINVAL;
> +
> +	uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	bind->addr_len =  READ_ONCE(sqe->addr2);
                        ^^
nit: double space


> +
> +	io = io_msg_alloc_async(req);
> +	if (unlikely(!io))
> +		return -ENOMEM;
> +	return move_addr_to_kernel(uaddr, bind->addr_len, &io->addr);
> +}
> +
> +int io_bind(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
> +	struct io_async_msghdr *io = req->async_data;
> +	int ret;
> +
> +	ret = __sys_bind_socket(sock_from_file(req->file),  &io->addr, bind->addr_len);
                                                          ^^
ditto


> +	if (ret < 0)
> +		req_set_fail(req);
> +	io_req_set_res(req, ret, 0);
> +	return 0;
> +}
> +
>  void io_netmsg_cache_free(const void *entry)
>  {
>  	struct io_async_msghdr *kmsg = (struct io_async_msghdr *) entry;
> diff --git a/io_uring/net.h b/io_uring/net.h
> index 0eb1c1920fc9..49f9a7bc1113 100644
> --- a/io_uring/net.h
> +++ b/io_uring/net.h
> @@ -49,6 +49,9 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags);
>  int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
>  void io_send_zc_cleanup(struct io_kiocb *req);
>  
> +int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
> +int io_bind(struct io_kiocb *req, unsigned int issue_flags);
> +
>  void io_netmsg_cache_free(const void *entry);
>  #else
>  static inline void io_netmsg_cache_free(const void *entry)
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index 2de5cca9504e..19ee9445f024 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -495,6 +495,16 @@ const struct io_issue_def io_issue_defs[] = {
>  		.prep			= io_ftruncate_prep,
>  		.issue			= io_ftruncate,
>  	},
> +	[IORING_OP_BIND] = {
> +#if defined(CONFIG_NET)
> +		.needs_file		= 1,
> +		.prep			= io_bind_prep,
> +		.issue			= io_bind,
> +		.async_size		= sizeof(struct io_async_msghdr),
> +#else
> +		.prep			= io_eopnotsupp_prep,
> +#endif
> +	},
>  };
>  
>  const struct io_cold_def io_cold_defs[] = {
> @@ -711,6 +721,9 @@ const struct io_cold_def io_cold_defs[] = {
>  	[IORING_OP_FTRUNCATE] = {
>  		.name			= "FTRUNCATE",
>  	},
> +	[IORING_OP_BIND] = {
> +		.name			= "BIND",
> +	},
>  };
>  
>  const char *io_uring_get_opcode(u8 opcode)
> -- 
> 2.45.2

