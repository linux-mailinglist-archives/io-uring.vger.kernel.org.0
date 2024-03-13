Return-Path: <io-uring+bounces-924-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E1CD87B2D7
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 21:25:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0DBC1F2296E
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 20:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BF4E4E1CE;
	Wed, 13 Mar 2024 20:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="V1r53fQl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171371A38C3
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 20:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710361547; cv=none; b=igfIVxwGb0QPkBZ71/le8IdBIMZjBr3WVW66+qsUNTbb8bpIFziOla72g+DctvGBYOIuoaddXu7vOzCJtczL6I/n23e23lIOPDXCNRqvNJXCamxI0+cltEc/D/K9G3ztlSQkAPFBSUcAXLZl+8FfJZQTUiQzbDelDVaO0oBtuqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710361547; c=relaxed/simple;
	bh=18UqDE8iEw7H0Rml5t9PCx9hHai9milRMrmBUKQ7CcY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MiR+w3A0ef44zI1/eeTPm4RsTiWQL57u3yeEBLgU4IFDlATXoM5JDHhVCI13ciaB0w/o8Tkn6Co4az8L3RNoOMepMeaDsaci74XCJx1m1pcix4CYDXFlVHGgYm6UC0e0gWrTUost9vaijXY0mEBGr4wX1bqLrqkPCCMvvzro9Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=V1r53fQl; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-366478a02baso565465ab.0
        for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 13:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710361544; x=1710966344; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=40C778T+ejGldiYJzfi31MQU9t5D58fRK5xoTPYIFco=;
        b=V1r53fQlUneX2ccgmY3xC/rA/mptJH9LgFMdNzag0IBOUSsGcyQYrqhiR0WTWl89fE
         JvgL8LY8T3tSkVhTKEvMfzhtxP7vlQIsPKJis5EmwiM2mFD/OzoK8ryY2IGHNT8NQTLC
         Smr+KYiqlXGEsU4vqNfEgBB0MUVnAmUOMN+gp5JnJtAuTTxcNCZrOePDV9UZgwpcmGRG
         GLb97AX30eOJXytNeHqPHMHsz82hviPty5P1li1JflTOjcJmYwlbsMeEpB1tD6OrUh1b
         //4H6MRRhVosEELx7Hc96F+VIJ4XwUv4dg+cucLnfwuxtysyIhw/JpCOLdAqFKPGDBXG
         7GtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710361544; x=1710966344;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=40C778T+ejGldiYJzfi31MQU9t5D58fRK5xoTPYIFco=;
        b=vm2MWF0/pcDhCeQwq+LDZXPCrsgZ0MBGquAnY7n1qSHnZpyIlEvtmKtpqdjBDx8haY
         YHA07n6tbU16u19XSwQdSIl6UEdA/fuwp2R4vE2Cxf9F3ePUtdf175bGByaU+fT8p3HZ
         cpHQa1ro7UVy6EnXbYUak75HczIpF6+Hz58cTSACIxJay+gXU7WzwqDCc5sfdKs5+AnJ
         znSbsNGS8w/vN0uQtF5KoIn9ZfGinW2YLOdIIfbMJoYxRIv/VWbfMY0ZyxrqQy/4pmUH
         sZfkRrNqA0dzmhKDinXhkXuO/egfEJfMxeZlLzTfq0UQ6qNJY115nMhUQkfzE/aHMS4S
         qxxA==
X-Forwarded-Encrypted: i=1; AJvYcCW/73UNI13DE0FxRezSJAjGSlUbwEuAzWS+HQAfLfaz5xXoYZhqqUH6+pfohIHAnZ6M7+0GcckQ4GbAiIPgR9EZpPPhUVS4avw=
X-Gm-Message-State: AOJu0Yzk68cgsejJLV20tgPqsqPJjerx7SG72esDFDGq9NNDa2hKUbew
	b4hZBR7h2GoNVN0daMxGP4Xiisa3eh5kSsghNhfYJk9B0Bhn+pLFgeMsa/8DAkA=
X-Google-Smtp-Source: AGHT+IHcpDZpTJECPXSKCB67XCzRSPHuGU0xoJfmPpiUOTXqTCEbIuRvUX3y0L5h+VcnUxcPdDC+Rg==
X-Received: by 2002:a5d:9253:0:b0:7c8:bd77:b321 with SMTP id e19-20020a5d9253000000b007c8bd77b321mr22985iol.2.1710361544177;
        Wed, 13 Mar 2024 13:25:44 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d73-20020a0285cf000000b00476eb3ec820sm1906691jai.51.2024.03.13.13.25.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Mar 2024 13:25:43 -0700 (PDT)
Message-ID: <7752a08c-f55c-48d5-87f2-70f248381e48@kernel.dk>
Date: Wed, 13 Mar 2024 14:25:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 13/16] io_uring: add io_recvzc request
Content-Language: en-US
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20240312214430.2923019-1-dw@davidwei.uk>
 <20240312214430.2923019-14-dw@davidwei.uk>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240312214430.2923019-14-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/12/24 3:44 PM, David Wei wrote:
> Add an io_uring opcode OP_RECV_ZC for doing ZC reads from a socket that
> is set up for ZC Rx. The request reads skbs from a socket. Completions
> are posted into the main CQ for each page frag read.
> 
> Big CQEs (CQE32) is required as the OP_RECV_ZC specific metadata (ZC
> region, offset, len) are stored in the extended 16 bytes as a
> struct io_uring_rbuf_cqe.
> 
> For now there is no limit as to how much work each OP_RECV_ZC request
> does. It will attempt to drain a socket of all available data.
> 
> Multishot requests are also supported. The first time an io_recvzc
> request completes, EAGAIN is returned which arms an async poll. Then, in
> subsequent runs in task work, IOU_ISSUE_SKIP_COMPLETE is returned to
> continue async polling.

I'd probably drop that last paragraph, this is how all multishot
requests work and is implementation detail that need not go in the
commit message. Probably suffices just to say it supports multishot.

> @@ -695,7 +701,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>  	unsigned int cflags;
>  
>  	cflags = io_put_kbuf(req, issue_flags);
> -	if (msg->msg_inq && msg->msg_inq != -1)
> +	if (msg && msg->msg_inq && msg->msg_inq != -1)
>  		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
>  
>  	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
> @@ -723,7 +729,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>  			goto enobufs;
>  
>  		/* Known not-empty or unknown state, retry */
> -		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq == -1) {
> +		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || (msg && msg->msg_inq == -1)) {
>  			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
>  				return false;
>  			/* mshot retries exceeded, force a requeue */

Maybe refactor this a bit so that you don't need to add these NULL
checks? That seems pretty fragile, hard to read, and should be doable
without extra checks.

> @@ -1053,6 +1058,85 @@ struct io_zc_rx_ifq *io_zc_verify_sock(struct io_kiocb *req,
>  	return ifq;
>  }
>  
> +int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
> +
> +	/* non-iopoll defer_taskrun only */
> +	if (!req->ctx->task_complete)
> +		return -EINVAL;

What's the reasoning behind this?

> +	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
> +	struct io_zc_rx_ifq *ifq;
> +	struct socket *sock;
> +	int ret;
> +
> +	/*
> +	 * We're posting CQEs deeper in the stack, and to avoid taking CQ locks
> +	 * we serialise by having only the master thread modifying the CQ with
> +	 * DEFER_TASkRUN checked earlier and forbidding executing it from io-wq.
> +	 * That's similar to io_check_multishot() for multishot CQEs.
> +	 */
> +	if (issue_flags & IO_URING_F_IOWQ)
> +		return -EAGAIN;
> +	if (WARN_ON_ONCE(!(issue_flags & IO_URING_F_NONBLOCK)))
> +		return -EAGAIN;

If rebased on the current tree, does this go away?

-- 
Jens Axboe


