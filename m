Return-Path: <io-uring+bounces-8224-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A501ACE7A9
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 03:00:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9C42176DD6
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 01:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51B832CCDE;
	Thu,  5 Jun 2025 00:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OAZADgUn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916C225634;
	Thu,  5 Jun 2025 00:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749085199; cv=none; b=K4B66tw+QHX9hOBKE656j4G81aJ64PejHTj1QmRlMa5/D7+v9LNn2L1keZgqV6LteduxtDKzB5bpGrZPup84uR7vnUQZfKZtmH7sqtb2GUJnyXBJEH1Qqzt+/8tpIPvGm6Wn4Ir+jBUefgPzzhb9rWF1UAK+qUFn9+z9G0nfhhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749085199; c=relaxed/simple;
	bh=OyYf/gZ3hxfQUz3KRWj0ILpvM85VO4utOhXs8/ZRwog=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=UG5VktfhXfLFYc/SRTYXbWfIUhfCeBmj5/og+MW/fvabvDiLJCNSAz5ah4qFbn2RcSqKmp1y/Gg3i8bEhYZt8DLvBEXplUcEFkA0aLT1NY+d6VbttsOAxjHBgnOWgk3zZ1E7SIrGgVN20ELpMFON0XltABzb1GaeZikNtX5E0zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OAZADgUn; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-70e447507a0so4485287b3.0;
        Wed, 04 Jun 2025 17:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749085196; x=1749689996; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OLH8V0tsvlkSew5mkiDRyEOeozBl7pDs+sHrjKBgI/o=;
        b=OAZADgUnu16iJQo20mauRd2LFNygxnxjy370YjYQcLaCIda/yUCGTAItb0dyKvqkr9
         XHUfvnvDteHcKu3QuB7niPEgnfb7tJanrbFerLs3QF7kFakh2be5i/RJq95RjnjB8+tD
         QXd1cyBwZYQxS+PH9zmNJKAC2OegHok7HVLbiQLY+vlXboD7z7/uKkJVIO7LwPy31gLq
         gmngXcEYFrnMaAuFEYXoEo6poKmpJqQTvZtAo8GRRVvmm+f4Ke9cbGcHhY/qRpeGdJjr
         5X8ItM2Ryct8a1XY0Yv2MJxCBeGMtXKttYktly5nJ0xXHClhCBgfaKV59mmwjPZMOjhe
         3Ghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749085196; x=1749689996;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OLH8V0tsvlkSew5mkiDRyEOeozBl7pDs+sHrjKBgI/o=;
        b=uNUG8AW7FXxk74jIaHSgodLp7xzL59qfiD9xfJdrb2cRFm9CcrYYtz7PtAK62/S0Dx
         Id/RO6szadmm9fr+feQfGiuySUu0BWaxqT4XVcMTfbc84He0L1E14Gs0luwrFaGFwgMB
         i1LVc3GXO8u51GcZ6K+m7CPJhyTogkwf/Yx+PPz7pWPKZD3F6GhJ8XXoEFjYZ37whecV
         6g8PUucVYkIcaqyhS009SysCzHex3hIp8VovsgKos0fIamSwOCVRv59J+/Zb4mR8JfQq
         oCLfu170/VkfYHmM0bdECm75wtx2/25ojcH5ErEG1Mgfspq6vZlIFLFgSj+uYzOjeadl
         yYew==
X-Forwarded-Encrypted: i=1; AJvYcCUct4cSOuVRbqACHZzl9jxS/VmadPCbZ6+vg33vRR6OFrSwZC6Kh5F8Pl73h345XbXT1tLYcqUPUA==@vger.kernel.org, AJvYcCV1l/tGGn/4hd4K/kCtn3tFYALZqusVbtdaD65N7bd3i97uvEfVJgQg/5d1OccVXr14dNp3y9zp@vger.kernel.org
X-Gm-Message-State: AOJu0YybzKD1VaTwpIVJYQbqUh6ahDuBEiaZhhBqquQ6xx7CVuhicx8I
	PyQeqthFsqdVkhpS5hi1gPrZZ2Ksxy3+EP23oQv7dDb4outDvGdwYxuq
X-Gm-Gg: ASbGncswgzmX6U6QBTlXm1G7eYYcogYitcEGybHdZaIBGzA3ELtqDwAPncN1RMWdut1
	lPMH/ZqeiL0pxa1kmkKsqEwd7DZTrLrnYimgmzRChCPDK+pPaRzw1oTEj536MznG6CIknR4m49o
	10oHPvOahQ3hXE5XBCvFsX2bqZtjz9obJw6RD64RuBUI1Z0ianZXdROMHw/ujCuCTLrku1ubt6K
	OPWmV2orVtfxZKON7SQNqgSi7qGeGMEpVwj5+jm1vIcveDKkKu3cziwjCtFOzKoEhQoTvDe/L7z
	nYcABMDTs/sRbdst2PGqcyQNSqhQLAY+TrdIiPG9NFboYce7jlYA/WrOO5zU3TZx84/zuUp9uDC
	Cus3WBpkPQol+NqmOMwFGZAg/iqaofnQ=
X-Google-Smtp-Source: AGHT+IGxl4w60nsvPNqgHObX3Fs49x0R/S8M/pyNz7kihM3q2PHmENTGpiYiuOM1JeuP+1EYlGODtg==
X-Received: by 2002:a05:690c:4b87:b0:70e:719e:75e with SMTP id 00721157ae682-710d9a965acmr67937907b3.9.1749085196246;
        Wed, 04 Jun 2025 17:59:56 -0700 (PDT)
Received: from localhost (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 00721157ae682-70f8acfd4b0sm32209657b3.97.2025.06.04.17.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 17:59:55 -0700 (PDT)
Date: Wed, 04 Jun 2025 20:59:55 -0400
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
 Richard Cochran <richardcochran@gmail.com>
Message-ID: <6840ec0b351ee_1af4929492@willemb.c.googlers.com.notmuch>
In-Reply-To: <7b81bb73e639ecfadc1300264eb75e12c925ad76.1749026421.git.asml.silence@gmail.com>
References: <cover.1749026421.git.asml.silence@gmail.com>
 <7b81bb73e639ecfadc1300264eb75e12c925ad76.1749026421.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 5/5] io_uring/netcmd: add tx timestamping cmd support
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
>  include/uapi/linux/io_uring.h |  6 +++
>  io_uring/cmd_net.c            | 77 +++++++++++++++++++++++++++++++++++
>  2 files changed, 83 insertions(+)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index cfd17e382082..0bc156eb96d4 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -960,6 +960,11 @@ struct io_uring_recvmsg_out {
>  	__u32 flags;
>  };
>  
> +struct io_timespec {
> +	__u64		tv_sec;
> +	__u64		tv_nsec;
> +};
> +
>  /*
>   * Argument for IORING_OP_URING_CMD when file is a socket
>   */
> @@ -968,6 +973,7 @@ enum io_uring_socket_op {
>  	SOCKET_URING_OP_SIOCOUTQ,
>  	SOCKET_URING_OP_GETSOCKOPT,
>  	SOCKET_URING_OP_SETSOCKOPT,
> +	SOCKET_URING_OP_TX_TIMESTAMP,
>  };
>  
>  /* Zero copy receive refill queue entry */
> diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
> index e99170c7d41a..dae59aea5847 100644
> --- a/io_uring/cmd_net.c
> +++ b/io_uring/cmd_net.c
> @@ -1,5 +1,6 @@
>  #include <asm/ioctls.h>
>  #include <linux/io_uring/net.h>
> +#include <linux/errqueue.h>
>  #include <net/sock.h>
>  
>  #include "uring_cmd.h"
> @@ -51,6 +52,80 @@ static inline int io_uring_cmd_setsockopt(struct socket *sock,
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
> +	u32 tskey;
> +
> +	BUILD_BUG_ON(sizeof(struct io_uring_cqe) != sizeof(struct io_timespec));
> +
> +	if (!skb_get_tx_timestamp(skb, sk, &ts))
> +		return false;
> +
> +	tskey = serr->ee.ee_data;
> +
> +	cqe->user_data = 0;
> +	cqe->res = tskey;
> +	cqe->flags = IORING_CQE_F_MORE;
> +	cqe->flags |= (u32)serr->ee.ee_info << IORING_CQE_BUFFER_SHIFT;
> +
> +	iots = (struct io_timespec *)&cqe[1];
> +	iots->tv_sec = ts.tv_sec;
> +	iots->tv_nsec = ts.tv_nsec;

skb_get_tx_timestamp loses the information whether this is a
software or a hardware timestamp. Is that loss problematic?

If a process only requests one type of timestamp, it will not be.

But when requesting both (SOF_TIMESTAMPING_OPT_TX_SWHW) this per cqe
annotation may be necessary.

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
> @@ -76,6 +151,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
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



