Return-Path: <io-uring+bounces-8226-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ABB76ACED8A
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 12:26:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5776B18985D8
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 10:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2782214818;
	Thu,  5 Jun 2025 10:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iAZCZFkT"
X-Original-To: io-uring@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBD7214A8B
	for <io-uring@vger.kernel.org>; Thu,  5 Jun 2025 10:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749119167; cv=none; b=Ov8emKb1Aw5tTSUJqcORXEQDvS7HgjcRGmiBSGOM5uXjBF/Ks7YK1p4ps0OleBZnyqX2AU9to5hMyeWrg+xvXQiyAw+6GdmpNQ7tgaABkLSrtzgi6ctf0N9tHtF561kvXCZup0NXy/NqHVQXS/QxyC3hmL8/MzpjYgEM86P6gRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749119167; c=relaxed/simple;
	bh=8FxoLj6LiBlq6MIoflJO6Wt9XFMOGnA1Ab7cJH+/6HY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YAMic0BGnlrlNs0nqpI0mI+OYLsCg+W7ICmqCPwjmLLMIoxjUCtJWFvFQxrhTrrp+mvx0BN4XQlu7GiNDoCXyojJ/a+UrpdBs9YtEvd37JJMKIH3C0zxMgNCIT/8GjydDYzsBhL7e4xfZ73LUNojE3jibK6xMwunS1/wq9eTIEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iAZCZFkT; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <584526c3-79f3-42f2-9c6e-4e55ad81b90c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749119151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KGvfcQK4SqoxUSANLaanDU9SMPl09zRLKA5RRmHvlfk=;
	b=iAZCZFkTGX1328h7yh0mXXRrEM7+l/JrWmWr0P2HFBSVvGm9KFw86TJbjQTXtwcw0dzKZM
	HuXOSaXQJB+T+x0mmpOxRMQLQynczV1Ps2tPjQ0/0UApzl9eVMwXuM1JxrGd1Ob44xA4cw
	axG/XgzE73XTNHt/cmNPCRx3lPU7mc4=
Date: Thu, 5 Jun 2025 11:25:48 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 5/5] io_uring/netcmd: add tx timestamping cmd support
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>
References: <cover.1749026421.git.asml.silence@gmail.com>
 <7b81bb73e639ecfadc1300264eb75e12c925ad76.1749026421.git.asml.silence@gmail.com>
 <6840ec0b351ee_1af4929492@willemb.c.googlers.com.notmuch>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <6840ec0b351ee_1af4929492@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 05/06/2025 01:59, Willem de Bruijn wrote:
> Pavel Begunkov wrote:
>> Add a new socket command which returns tx time stamps to the user. It
>> provide an alternative to the existing error queue recvmsg interface.
>> The command works in a polled multishot mode, which means io_uring will
>> poll the socket and keep posting timestamps until the request is
>> cancelled or fails in any other way (e.g. with no space in the CQ). It
>> reuses the net infra and grabs timestamps from the socket's error queue.
>>
>> The command requires IORING_SETUP_CQE32. All non-final CQEs (marked with
>> IORING_CQE_F_MORE) have cqe->res set to the tskey, and the upper 16 bits
>> of cqe->flags keep tstype (i.e. offset by IORING_CQE_BUFFER_SHIFT). The
>> timevalue is store in the upper part of the extended CQE. The final
>> completion won't have IORING_CQR_F_MORE and will have cqe->res storing
>> 0/error.
>>
>> Suggested-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   include/uapi/linux/io_uring.h |  6 +++
>>   io_uring/cmd_net.c            | 77 +++++++++++++++++++++++++++++++++++
>>   2 files changed, 83 insertions(+)
>>
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index cfd17e382082..0bc156eb96d4 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -960,6 +960,11 @@ struct io_uring_recvmsg_out {
>>   	__u32 flags;
>>   };
>>   
>> +struct io_timespec {
>> +	__u64		tv_sec;
>> +	__u64		tv_nsec;
>> +};
>> +
>>   /*
>>    * Argument for IORING_OP_URING_CMD when file is a socket
>>    */
>> @@ -968,6 +973,7 @@ enum io_uring_socket_op {
>>   	SOCKET_URING_OP_SIOCOUTQ,
>>   	SOCKET_URING_OP_GETSOCKOPT,
>>   	SOCKET_URING_OP_SETSOCKOPT,
>> +	SOCKET_URING_OP_TX_TIMESTAMP,
>>   };
>>   
>>   /* Zero copy receive refill queue entry */
>> diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
>> index e99170c7d41a..dae59aea5847 100644
>> --- a/io_uring/cmd_net.c
>> +++ b/io_uring/cmd_net.c
>> @@ -1,5 +1,6 @@
>>   #include <asm/ioctls.h>
>>   #include <linux/io_uring/net.h>
>> +#include <linux/errqueue.h>
>>   #include <net/sock.h>
>>   
>>   #include "uring_cmd.h"
>> @@ -51,6 +52,80 @@ static inline int io_uring_cmd_setsockopt(struct socket *sock,
>>   				  optlen);
>>   }
>>   
>> +static bool io_process_timestamp_skb(struct io_uring_cmd *cmd, struct sock *sk,
>> +				     struct sk_buff *skb, unsigned issue_flags)
>> +{
>> +	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
>> +	struct io_uring_cqe cqe[2];
>> +	struct io_timespec *iots;
>> +	struct timespec64 ts;
>> +	u32 tskey;
>> +
>> +	BUILD_BUG_ON(sizeof(struct io_uring_cqe) != sizeof(struct io_timespec));
>> +
>> +	if (!skb_get_tx_timestamp(skb, sk, &ts))
>> +		return false;
>> +
>> +	tskey = serr->ee.ee_data;
>> +
>> +	cqe->user_data = 0;
>> +	cqe->res = tskey;
>> +	cqe->flags = IORING_CQE_F_MORE;
>> +	cqe->flags |= (u32)serr->ee.ee_info << IORING_CQE_BUFFER_SHIFT;
>> +
>> +	iots = (struct io_timespec *)&cqe[1];
>> +	iots->tv_sec = ts.tv_sec;
>> +	iots->tv_nsec = ts.tv_nsec;
> 
> skb_get_tx_timestamp loses the information whether this is a
> software or a hardware timestamp. Is that loss problematic?
> 
> If a process only requests one type of timestamp, it will not be.
> 
> But when requesting both (SOF_TIMESTAMPING_OPT_TX_SWHW) this per cqe
> annotation may be necessary.

skb_has_tx_timestamp() helper has clear priority of software timestamp,
if enabled for the socket. Looks like SOF_TIMESTAMPING_OPT_TX_SWHW case
won't produce both timestamps with the current implementation. Am I
missing something?

> 
>> +	return io_uring_cmd_post_mshot_cqe32(cmd, issue_flags, cqe);
>> +}
>> +
>> +static int io_uring_cmd_timestamp(struct socket *sock,
>> +				  struct io_uring_cmd *cmd,
>> +				  unsigned int issue_flags)
>> +{
>> +	struct sock *sk = sock->sk;
>> +	struct sk_buff_head *q = &sk->sk_error_queue;
>> +	struct sk_buff *skb, *tmp;
>> +	struct sk_buff_head list;
>> +	int ret;
>> +
>> +	if (!(issue_flags & IO_URING_F_CQE32))
>> +		return -EINVAL;
>> +	ret = io_cmd_poll_multishot(cmd, issue_flags, EPOLLERR);
>> +	if (unlikely(ret))
>> +		return ret;
>> +
>> +	if (skb_queue_empty_lockless(q))
>> +		return -EAGAIN;
>> +	__skb_queue_head_init(&list);
>> +
>> +	scoped_guard(spinlock_irq, &q->lock) {
>> +		skb_queue_walk_safe(q, skb, tmp) {
>> +			/* don't support skbs with payload */
>> +			if (!skb_has_tx_timestamp(skb, sk) || skb->len)
>> +				continue;
>> +			__skb_unlink(skb, q);
>> +			__skb_queue_tail(&list, skb);
>> +		}
>> +	}
>> +
>> +	while (1) {
>> +		skb = skb_peek(&list);
>> +		if (!skb)
>> +			break;
>> +		if (!io_process_timestamp_skb(cmd, sk, skb, issue_flags))
>> +			break;
>> +		__skb_dequeue(&list);
>> +		consume_skb(skb);
>> +	}
>> +
>> +	if (!unlikely(skb_queue_empty(&list))) {
>> +		scoped_guard(spinlock_irqsave, &q->lock)
>> +			skb_queue_splice(q, &list);
>> +	}
>> +	return -EAGAIN;
>> +}
>> +
>>   int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
>>   {
>>   	struct socket *sock = cmd->file->private_data;
>> @@ -76,6 +151,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
>>   		return io_uring_cmd_getsockopt(sock, cmd, issue_flags);
>>   	case SOCKET_URING_OP_SETSOCKOPT:
>>   		return io_uring_cmd_setsockopt(sock, cmd, issue_flags);
>> +	case SOCKET_URING_OP_TX_TIMESTAMP:
>> +		return io_uring_cmd_timestamp(sock, cmd, issue_flags);
>>   	default:
>>   		return -EOPNOTSUPP;
>>   	}
>> -- 
>> 2.49.0
>>
> 
> 


