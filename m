Return-Path: <io-uring+bounces-8328-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A5BCAD7DA4
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 23:35:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C120D7A7796
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 21:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 231C422DF9A;
	Thu, 12 Jun 2025 21:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G0WbpsjB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D7E225771;
	Thu, 12 Jun 2025 21:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749764142; cv=none; b=CUvT/4TdYIPBeVtDCYax8ZEmNT6f4t7NnOj2ISkPWXTcNOXqpFx7CWR+sMf1oj3gAZyhYHFGd6zXc5RwmCxs6exf08pIUV58WTNOHaHUpQcqkHyS/DbsD9vqplGrbFsvW/NNQcaXOLxvIfXULSv3Q3lYyry4tMHVQACPPD/DjMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749764142; c=relaxed/simple;
	bh=m/f792o1+gwITJiN/b4NuH+Z+VMjxgBNWS8iiCez7f0=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=gEr2GnnUbuPIaZc9nnKWHyWZG+KkXz3gdGocPEkeOpEvt4GSrjvW8ZqA+gUXvH/m4Hr5c6BaUr7pJgRGU3eYp3d4goRp7MhzVqp9ijyhkp+TPMGEfcDmUIXbPhck337KD1Z22qRF2n2S1Vv39VwQEtud/ldfjrbkBmsrxhNIPNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G0WbpsjB; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-70e2b601a6bso15597457b3.0;
        Thu, 12 Jun 2025 14:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749764139; x=1750368939; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LeJb5j45UZxgtwrPizVfMAEk+w47eaEUE6Iu/ZXt7H4=;
        b=G0WbpsjBIIz1YPeDa1Wi3zSzKTIeCl73kxs9kWgvLpOD35GGj1vEv7zvyX3CS0ZlqK
         g+Y4xq63gMW1zLwWYfNPd2sdI8HthhbsorxHAD5iZwkBgBZuWkleeBehfzg5LYJ2fBJG
         1t29pplBjHk+uqBdsuEbRfa1TsZVguUdGDyCdK2gTgJlZPMJATzXMQp4CWrf6FL2UkvP
         GrPSZIaTjQD+6GVr6elrZd1Qb1vbm4aj9VsmT8DCHfD7GG4u1ZK6xCNBB2etkCmLhDTO
         5fZlk57XXsUAmORW60Bp5NoEB65sZnU1TRkSkitf6B74rrsBxhqKwwPaJtjHWi9TUdMq
         EK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749764139; x=1750368939;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LeJb5j45UZxgtwrPizVfMAEk+w47eaEUE6Iu/ZXt7H4=;
        b=dN+EgJn9FM7Wp+qyPAnQXJR/XDWHAezDsabaR0Rtr6pCe9Uw5SeeijiATOHhXdevQA
         03z+yOeMIN7rL6iK/IXQlDHzDfLvEaJF55qasKHWhURW8yVwWkwO1ZrWPkDXtTuQ38gx
         RMDHwUCWRi6M/8WsWuSSKyJ+l3twWopSJgVkzFarkFuWfO29QfLsB8nKMoMJvs6sQs43
         ynebnhs9UCoVEdXuUp79G+D0tO7fmcT/I5L7o5WHNb/nC0SVhEa7Hp4CYwVeWgBh5gv3
         pczc1OzqDPJVeFhwsj0sWUjgTzFVXti3zWkzy+trHFn8wXXT69ZuxkCDviPyrEY08VVR
         FFug==
X-Forwarded-Encrypted: i=1; AJvYcCVebHXjwgdBcMPpTcWvJTozVhXeMKgfsZmcG0OgeLZD8s0nu5d18vjWkAASVNiClQdmSFYZQD3l@vger.kernel.org, AJvYcCWdlgykdLcG2/mZcHalyGpXeDkfAfCYPfbi54nuDDWg34yNVh5pYxTK0rjgo+tDwrPJNAZGiHLtZQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwNtF8SZvqAxkLWvdViy+qAjkgXDgOL6fmUOL6d3V48j6hpxjrd
	Tsv55BNpasB9vcQ9USn5tbutx5LgrIJBlOkEu2G4xMIozyxA03rprkwFtxEQ1Q==
X-Gm-Gg: ASbGncvD+7glDX+WmuW3ViYFrjTIRWo6VcJ2jwPDBgWUiAzZBeDSwwwwyQh1LbS/EFp
	fYgOZh9FXxdByJf0RUrouDjmSCipaa3SzC3RA7eO6SJt2iudInA2b3n5WYpPGmZJcQkf5mzZtjh
	2GlKenKmKst9XHHd09xfl6ESUPSMNSSTRqHsUAwl0/t/QCaBDkqKC+sw/NaQeVHsP8KvrF6La9h
	NyH16FHtnQsVK6xqc/nLmMBMul+wiekslT+kp2dAl378zrVgxAWQ9zETfyBPPNOVJ2ZL4491/D0
	pVZcpqmxQhauWuTTJZRwb2GPSmVfa6c7QHxzSAvG+iOH4GmBLxumz7dQpm46ILLe3PRz+lyVjG6
	45yVaBPIhdcqdVNJ6ntF1FVxAwP0TTCvmZUyf/OJ02Q==
X-Google-Smtp-Source: AGHT+IHMsrAEWd1Fjflb92GNkWpl+LQNd8ofdAOELdpok4saFJhvF1vF7nzW3gm2Sha7EomLZLFyJw==
X-Received: by 2002:a05:690c:f8d:b0:710:f1a9:1ba0 with SMTP id 00721157ae682-71163619b63mr15825047b3.3.1749764139027;
        Thu, 12 Jun 2025 14:35:39 -0700 (PDT)
Received: from localhost (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 00721157ae682-7115208a300sm4156537b3.34.2025.06.12.14.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 14:35:38 -0700 (PDT)
Date: Thu, 12 Jun 2025 17:35:38 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 io-uring@vger.kernel.org, 
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: asml.silence@gmail.com, 
 netdev@vger.kernel.org, 
 Eric Dumazet <edumazet@google.com>, 
 Kuniyuki Iwashima <kuniyu@amazon.com>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Willem de Bruijn <willemb@google.com>, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Richard Cochran <richardcochran@gmail.com>, 
 Stanislav Fomichev <sdf@fomichev.me>, 
 Jason Xing <kerneljasonxing@gmail.com>
Message-ID: <684b482a1a03f_cb2792944c@willemb.c.googlers.com.notmuch>
In-Reply-To: <1e9c0e393d6d207ba438da3ad5bf7e4125b28cb7.1749657325.git.asml.silence@gmail.com>
References: <cover.1749657325.git.asml.silence@gmail.com>
 <1e9c0e393d6d207ba438da3ad5bf7e4125b28cb7.1749657325.git.asml.silence@gmail.com>
Subject: Re: [PATCH v3 5/5] io_uring/netcmd: add tx timestamping cmd support
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Pavel Begunkov wrote:
> Add a new socket command which returns tx time stamps to the user. It
> provide an alternative to the existing error queue recvmsg interface.
> The command works in a polled multishot mode, which means io_uring will
> poll the socket and keep posting timestamps until the request is
> cancelled or fails in any other way (e.g. with no space in the CQ). It
> reuses the net infra and grabs timestamps from the socket's error queue.
> 
> The command requires IORING_SETUP_CQE32. All non-final CQEs (marked with
> IORING_CQE_F_MORE) have cqe->res set to the tskey, and the upper 16 bits
> of cqe->flags keep tstype (i.e. offset by IORING_CQE_BUFFER_SHIFT). The
> timevalue is store in the upper part of the extended CQE. The final
> completion won't have IORING_CQR_F_MORE and will have cqe->res storing
> 0/error.
> 
> Suggested-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/uapi/linux/io_uring.h |  9 ++++
>  io_uring/cmd_net.c            | 82 +++++++++++++++++++++++++++++++++++
>  2 files changed, 91 insertions(+)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index cfd17e382082..5c89e6f6d624 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -968,6 +968,15 @@ enum io_uring_socket_op {
>  	SOCKET_URING_OP_SIOCOUTQ,
>  	SOCKET_URING_OP_GETSOCKOPT,
>  	SOCKET_URING_OP_SETSOCKOPT,
> +	SOCKET_URING_OP_TX_TIMESTAMP,
> +};
> +
> +#define IORING_CQE_F_TIMESTAMP_HW	((__u32)1 << IORING_CQE_BUFFER_SHIFT)
> +#define IORING_TIMESTAMP_TSTYPE_SHIFT	(IORING_CQE_BUFFER_SHIFT + 1)
> +

Perhaps instead of these shifts define an actual struct, e.g.,
io_uring_cqe_tstamp.

One question is the number of bits to reserve for the tstype.
Currently only 2 are needed. But that can grow. The current
approach conveniently leaves that open.

Alternatively, perhaps make the dependency between the shifts more
obvious:

+#define IORING_TIMESTAMP_HW_SHIFT	IORING_CQE_BUFFER_SHIFT
+#define IORING_TIMESTAMP_TYPE_SHIFT	(IORING_CQE_BUFFER_SHIFT + 1)

+#define IORING_CQE_F_TSTAMP_HW		((__u32)1 << IORING_TIMESTAMP_HW_SHIFT);

> +struct io_timespec {
> +	__u64		tv_sec;
> +	__u64		tv_nsec;
>  };
>  
>  /* Zero copy receive refill queue entry */
> diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
> index e99170c7d41a..bc2d33ea2db3 100644
> --- a/io_uring/cmd_net.c
> +++ b/io_uring/cmd_net.c
> @@ -1,5 +1,6 @@
>  #include <asm/ioctls.h>
>  #include <linux/io_uring/net.h>
> +#include <linux/errqueue.h>
>  #include <net/sock.h>
>  
>  #include "uring_cmd.h"
> @@ -51,6 +52,85 @@ static inline int io_uring_cmd_setsockopt(struct socket *sock,
>  				  optlen);
>  }
>  
> +static bool io_process_timestamp_skb(struct io_uring_cmd *cmd, struct sock *sk,
> +				     struct sk_buff *skb, unsigned issue_flags)
> +{
> +	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
> +	struct io_uring_cqe cqe[2];
> +	struct io_timespec *iots;
> +	struct timespec64 ts;
> +	u32 tstype, tskey;
> +	int ret;
> +
> +	BUILD_BUG_ON(sizeof(struct io_uring_cqe) != sizeof(struct io_timespec));
> +
> +	ret = skb_get_tx_timestamp(skb, sk, &ts);
> +	if (ret < 0)
> +		return false;
> +
> +	tskey = serr->ee.ee_data;
> +	tstype = serr->ee.ee_info;
> +
> +	cqe->user_data = 0;
> +	cqe->res = tskey;
> +	cqe->flags = IORING_CQE_F_MORE;
> +	cqe->flags |= tstype << IORING_TIMESTAMP_TSTYPE_SHIFT;
> +	if (ret == NET_TIMESTAMP_ORIGIN_HW)
> +		cqe->flags |= IORING_CQE_F_TIMESTAMP_HW;
> +
> +	iots = (struct io_timespec *)&cqe[1];
> +	iots->tv_sec = ts.tv_sec;
> +	iots->tv_nsec = ts.tv_nsec;
> +	return io_uring_cmd_post_mshot_cqe32(cmd, issue_flags, cqe);
> +}
> +
> +static int io_uring_cmd_timestamp(struct socket *sock,
> +				  struct io_uring_cmd *cmd,
> +				  unsigned int issue_flags)
> +{
> +	struct sock *sk = sock->sk;
> +	struct sk_buff_head *q = &sk->sk_error_queue;
> +	struct sk_buff *skb, *tmp;
> +	struct sk_buff_head list;
> +	int ret;
> +
> +	if (!(issue_flags & IO_URING_F_CQE32))
> +		return -EINVAL;
> +	ret = io_cmd_poll_multishot(cmd, issue_flags, EPOLLERR);
> +	if (unlikely(ret))
> +		return ret;
> +
> +	if (skb_queue_empty_lockless(q))
> +		return -EAGAIN;
> +	__skb_queue_head_init(&list);
> +
> +	scoped_guard(spinlock_irq, &q->lock) {
> +		skb_queue_walk_safe(q, skb, tmp) {
> +			/* don't support skbs with payload */
> +			if (!skb_has_tx_timestamp(skb, sk) || skb->len)
> +				continue;
> +			__skb_unlink(skb, q);
> +			__skb_queue_tail(&list, skb);
> +		}
> +	}
> +
> +	while (1) {
> +		skb = skb_peek(&list);
> +		if (!skb)
> +			break;
> +		if (!io_process_timestamp_skb(cmd, sk, skb, issue_flags))
> +			break;
> +		__skb_dequeue(&list);
> +		consume_skb(skb);
> +	}
> +
> +	if (!unlikely(skb_queue_empty(&list))) {
> +		scoped_guard(spinlock_irqsave, &q->lock)
> +			skb_queue_splice(q, &list);
> +	}
> +	return -EAGAIN;
> +}
> +
>  int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
>  {
>  	struct socket *sock = cmd->file->private_data;
> @@ -76,6 +156,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
>  		return io_uring_cmd_getsockopt(sock, cmd, issue_flags);
>  	case SOCKET_URING_OP_SETSOCKOPT:
>  		return io_uring_cmd_setsockopt(sock, cmd, issue_flags);
> +	case SOCKET_URING_OP_TX_TIMESTAMP:
> +		return io_uring_cmd_timestamp(sock, cmd, issue_flags);
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> -- 
> 2.49.0
> 



