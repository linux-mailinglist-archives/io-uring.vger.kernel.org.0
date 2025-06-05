Return-Path: <io-uring+bounces-8240-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33591ACFA32
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 01:55:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B6243B05A1
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 23:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6625927A918;
	Thu,  5 Jun 2025 23:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HYNJxz9i"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A641D3C465;
	Thu,  5 Jun 2025 23:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749167697; cv=none; b=Nbw/BMaw2aI1VEv7TJXaffxO3XJf39odrNn4YDHUeGJ0Lesh+1QxnniyPseHFXVovOCAThGJqHNViqkByG9pAGWpkZkSpsE+/G1vD8LRyh6X9RaCTUAeU9CstR4NoGiTMtlHjRWlckpvtZm76QICqBNK1cuFuiDriLsJZGpNOh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749167697; c=relaxed/simple;
	bh=fMJLk1vmi6Y1L8AnixvTgmipNok7iEzAlVtshR6ONuU=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=i9m+OrE8yC1A8q/HVlYaxv8NhdoSQAGRlAOlGZezUQW86xnSQ0vNdoz8RvAh9mNFT06xJ3IygS8RbViY86Craf7887a/ZuGQHxCQK/LiCiGS7zgiDrU4V/lJxFFceFzS+e21HaFqA2W19tua8reW+heYZnZmXuD0Sd9e0b26K6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HYNJxz9i; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-70e6bddc30aso14614097b3.0;
        Thu, 05 Jun 2025 16:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749167694; x=1749772494; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=um74k1V8rb4C6ANvYsbYt3XsD9R17bdA/biDuQe5L2c=;
        b=HYNJxz9i88nqOoiGaxSyks2qaMP9NgtgicRLsaMWja69ELnikz7HGPFQocZDPiPyxO
         xYqPp7W3dHmkKXrHefzloCBroBwucF6LbfPk8EMNU0w3OIj6qqbuRUCTnT8WhQX4o4l7
         jqjwcMF2EBJ1QrnKyLqAfvHdqdgTZjDhrKssfsE4H9FUzIv6qwkWvLrZZDtuN+y1xFAi
         fMsM/kGx4cPmFoMChuDiKbNKNxyAlQEm+mKpjmojbt+gu1yGkqr7d/hpsFnpWgK4Raa5
         tRZluVgKaPluig7ZhphkRJZJl+hnHUyQEUU0aGgfP6aoSxvRZmZUJ/BfYeD5cA18J+mB
         zC9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749167694; x=1749772494;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=um74k1V8rb4C6ANvYsbYt3XsD9R17bdA/biDuQe5L2c=;
        b=vYSqUWpnL+bfJDb8Flc7mF8lHDxm9HET5XtIH3EUmfS7pO8TQ6Tc0ZEuagkK0KRpS3
         wSMn9ylRBZSFNORBalyJFvdNcxVpanWUVKY+UujTZmA9Lq8QAW6dFCDXixK4HIi5VQoe
         ey627JCJA5DvswoW30wNGXNL9bARaPVOuPtJq9hO9+hkGuSCbrrZ5ReWh3KWqIjSNXE0
         fer64UQwu5V81JUO+6spevB1Gu1SuQ48QPFoE1HLZfpS2ziyvX5UfNAKGcs7sq5SJ+Hi
         vGrwfa/1kPt3zK7jMAJkhIDPpzwB8vxE/F/OolQDDR6YthbPXMSzEVf6HfS/0L+sxcjB
         hNIw==
X-Forwarded-Encrypted: i=1; AJvYcCVAdSZEjyX4T1IRanlrt5FW7qQRlmO6TysByvDl/9cuuzIFM70ci9rn1K/Ox5tTfLsQKU2JNlxe9g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwaSbaMzfCJpjWDpJ1Rn7VPN4F5747btHzKqCwSug0OG5R8xjdQ
	+Qvgv1dMPqcRuqarLFEzBmPk+NhprFJrz5KHroR7g00Ah+7bZekS6GTh
X-Gm-Gg: ASbGncs0qnwU8AmuSd+5mTeFtMqFn404lNeEK+rkBcFBKEozccehicBPcsPKuFUpDFp
	g53BlFPmtQA8mt8+5BJhFRYeeITQ7y5RLKhIy/04hssiStV7BmuhKxqSwgJsPyzwru40vJizaPz
	u43StBq3YOhE0+nXM55iAurT834pz1g0SR6aQxzdtcTqy+JLkM9oxha+7sFC6gXfMk8uBWAXfaG
	1G5msfEIb73lwSnIPfGd8gFwuWqQY+suVhjSjIW/xTp+evoat+YS/1XhIOYX9yevPCQPNCAezjo
	cX9ytZ2kRTfRqUVxTg/nSIly2B64BypA2QTBK+QJiHNPoNVWZ6QkPtHU4xiwsX+WKPosY5v5Opm
	cPOrAXf7uFfmxI3v2PkZigIKDJTxhYQo=
X-Google-Smtp-Source: AGHT+IF3AXFYsRgftEXVx96d3Nh1cMg+GW1Cf4GkLz6+2NcXkYBAl9pZUCzrUFD1Xk72KUTkNOa+lA==
X-Received: by 2002:a05:690c:360e:b0:70d:f3bb:a731 with SMTP id 00721157ae682-710f76949a7mr18144677b3.9.1749167694400;
        Thu, 05 Jun 2025 16:54:54 -0700 (PDT)
Received: from localhost (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 3f1490d57ef6-e81a4157e71sm133488276.35.2025.06.05.16.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 16:54:53 -0700 (PDT)
Date: Thu, 05 Jun 2025 19:54:53 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Vadim Fedorenko <vadim.fedorenko@linux.dev>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 Pavel Begunkov <asml.silence@gmail.com>, 
 io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org, 
 Eric Dumazet <edumazet@google.com>, 
 Kuniyuki Iwashima <kuniyu@amazon.com>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Willem de Bruijn <willemb@google.com>, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Richard Cochran <richardcochran@gmail.com>
Message-ID: <68422e4d1b8ef_208a5f2949@willemb.c.googlers.com.notmuch>
In-Reply-To: <584526c3-79f3-42f2-9c6e-4e55ad81b90c@linux.dev>
References: <cover.1749026421.git.asml.silence@gmail.com>
 <7b81bb73e639ecfadc1300264eb75e12c925ad76.1749026421.git.asml.silence@gmail.com>
 <6840ec0b351ee_1af4929492@willemb.c.googlers.com.notmuch>
 <584526c3-79f3-42f2-9c6e-4e55ad81b90c@linux.dev>
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

Vadim Fedorenko wrote:
> On 05/06/2025 01:59, Willem de Bruijn wrote:
> > Pavel Begunkov wrote:
> >> Add a new socket command which returns tx time stamps to the user. It
> >> provide an alternative to the existing error queue recvmsg interface.
> >> The command works in a polled multishot mode, which means io_uring will
> >> poll the socket and keep posting timestamps until the request is
> >> cancelled or fails in any other way (e.g. with no space in the CQ). It
> >> reuses the net infra and grabs timestamps from the socket's error queue.
> >>
> >> The command requires IORING_SETUP_CQE32. All non-final CQEs (marked with
> >> IORING_CQE_F_MORE) have cqe->res set to the tskey, and the upper 16 bits
> >> of cqe->flags keep tstype (i.e. offset by IORING_CQE_BUFFER_SHIFT). The
> >> timevalue is store in the upper part of the extended CQE. The final
> >> completion won't have IORING_CQR_F_MORE and will have cqe->res storing
> >> 0/error.
> >>
> >> Suggested-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
> >> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> >> ---
> >>   include/uapi/linux/io_uring.h |  6 +++
> >>   io_uring/cmd_net.c            | 77 +++++++++++++++++++++++++++++++++++
> >>   2 files changed, 83 insertions(+)
> >>
> >> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> >> index cfd17e382082..0bc156eb96d4 100644
> >> --- a/include/uapi/linux/io_uring.h
> >> +++ b/include/uapi/linux/io_uring.h
> >> @@ -960,6 +960,11 @@ struct io_uring_recvmsg_out {
> >>   	__u32 flags;
> >>   };
> >>   
> >> +struct io_timespec {
> >> +	__u64		tv_sec;
> >> +	__u64		tv_nsec;
> >> +};
> >> +
> >>   /*
> >>    * Argument for IORING_OP_URING_CMD when file is a socket
> >>    */
> >> @@ -968,6 +973,7 @@ enum io_uring_socket_op {
> >>   	SOCKET_URING_OP_SIOCOUTQ,
> >>   	SOCKET_URING_OP_GETSOCKOPT,
> >>   	SOCKET_URING_OP_SETSOCKOPT,
> >> +	SOCKET_URING_OP_TX_TIMESTAMP,
> >>   };
> >>   
> >>   /* Zero copy receive refill queue entry */
> >> diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
> >> index e99170c7d41a..dae59aea5847 100644
> >> --- a/io_uring/cmd_net.c
> >> +++ b/io_uring/cmd_net.c
> >> @@ -1,5 +1,6 @@
> >>   #include <asm/ioctls.h>
> >>   #include <linux/io_uring/net.h>
> >> +#include <linux/errqueue.h>
> >>   #include <net/sock.h>
> >>   
> >>   #include "uring_cmd.h"
> >> @@ -51,6 +52,80 @@ static inline int io_uring_cmd_setsockopt(struct socket *sock,
> >>   				  optlen);
> >>   }
> >>   
> >> +static bool io_process_timestamp_skb(struct io_uring_cmd *cmd, struct sock *sk,
> >> +				     struct sk_buff *skb, unsigned issue_flags)
> >> +{
> >> +	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
> >> +	struct io_uring_cqe cqe[2];
> >> +	struct io_timespec *iots;
> >> +	struct timespec64 ts;
> >> +	u32 tskey;
> >> +
> >> +	BUILD_BUG_ON(sizeof(struct io_uring_cqe) != sizeof(struct io_timespec));
> >> +
> >> +	if (!skb_get_tx_timestamp(skb, sk, &ts))
> >> +		return false;
> >> +
> >> +	tskey = serr->ee.ee_data;
> >> +
> >> +	cqe->user_data = 0;
> >> +	cqe->res = tskey;
> >> +	cqe->flags = IORING_CQE_F_MORE;
> >> +	cqe->flags |= (u32)serr->ee.ee_info << IORING_CQE_BUFFER_SHIFT;
> >> +
> >> +	iots = (struct io_timespec *)&cqe[1];
> >> +	iots->tv_sec = ts.tv_sec;
> >> +	iots->tv_nsec = ts.tv_nsec;
> > 
> > skb_get_tx_timestamp loses the information whether this is a
> > software or a hardware timestamp. Is that loss problematic?
> > 
> > If a process only requests one type of timestamp, it will not be.
> > 
> > But when requesting both (SOF_TIMESTAMPING_OPT_TX_SWHW) this per cqe
> > annotation may be necessary.
> 
> skb_has_tx_timestamp() helper has clear priority of software timestamp,
> if enabled for the socket. Looks like SOF_TIMESTAMPING_OPT_TX_SWHW case
> won't produce both timestamps with the current implementation. Am I
> missing something?

The point of that option is to request both SW and HW tx
timestamps. Before that option, the SW timestamp was suppressed if a
HW timestamp was pending.

The io_uring API as currently written will again return only one
timestamp, but this time the SW one.

If the user explicitly sets SOF_TIMESTAMPING_OPT_TX_SWHW, they will
want both, and want to be able to disambiguate them.

