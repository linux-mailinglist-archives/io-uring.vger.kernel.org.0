Return-Path: <io-uring+bounces-7341-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7665FA77C45
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 15:37:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DA1116B605
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 13:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BBFA204697;
	Tue,  1 Apr 2025 13:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Xh/ZOv3N"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B362040B7;
	Tue,  1 Apr 2025 13:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743514660; cv=none; b=dsE8v5+IRGbyUd5AEuwrgguKGq6LGhKpz/7c07MIVhmyBPhV3doP8IFNlTJonvdD8wvhYyW9smlD3CPH/QkDu02ef8sqAysdmj8hk2AX89qZcGCEz3W11qwzhI2EvytrYeQCphwMKjcK4/KlZaEXJPzDnrtLhlFhFsDfARpu6SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743514660; c=relaxed/simple;
	bh=FAJCm/VeQwU4gW2ZECoYAXysn+hCxhzRB5G4RoGC32Y=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=q9sr1Tge/xHNcx31xFVi+AE+c26mNQm/0w/gzuwUFT/qTW3ThQSW3w6BRpmlR3Crm/RCsiPAGf49dxWa6ytLvnVLpWy0+DrQzyTUEBcViUFbGd4eaYt7e7gjFI64GImtKHfaa8u6d9A//bkPi6fdwNdVhpelgqe5T0FGMN7vErU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Xh/ZOv3N; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=LJ7vZl7N5N9To0ZH3g8NdOg346BzAJzw070zXIoFWHk=; b=Xh/ZOv3NRU80YcyCVJGR9T5HZd
	YL8ub0DI2A+DGk0DBzNk4u+tbFeIw4tYJ8tzm7PBzLTaHEsjSg1atcO3iVSaABCfRTWzf19mdSqyx
	70VIUbQ26KNdgrMYU1JymgGsReejCQbefpRBuCtmi2tWdT/7SHryfuHsCZsV2jUl0qYJKSj04IrrZ
	fsr2FSs6W1tYQrak9fBoDEbyoC0k2+r9dWV57mJbyW11AusTphw7o9mERS1Nem1VjPRyPv9glGAXK
	JaE2wOFZ4zEVzSFCF6DNE6ZyA/FzrZsCa7dAQPjgLw3PcIag2oCiw61HYlSbcQURDLWES5+RdZRcC
	vwjeB2mmtgCLOgPFo3cm6dhgeBnZYuQ2YvqdkLENSNOZo+1qZxcW9g7pLk4J8fI4spZ6vwNltbt0b
	iNvF3TbM55jMYDydAsDz/Z9wjckitPmpllFVkQje83z/HBf0t5iF5G1GA6JtBNtLgcgbbj4A1aHUI
	WYVBIt4vC/N5XrRa16Ju1ZwO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tzbo2-007fx6-0z;
	Tue, 01 Apr 2025 13:37:30 +0000
Message-ID: <407c1a05-24a7-430b-958c-0ca78c467c07@samba.org>
Date: Tue, 1 Apr 2025 15:37:28 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] net/io_uring: pass a kernel pointer via optlen_t
 to proto[_ops].getsockopt()
From: Stefan Metzmacher <metze@samba.org>
To: Stanislav Fomichev <stfomichev@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Breno Leitao <leitao@debian.org>, Jakub Kicinski <kuba@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Karsten Keil <isdn@linux-pingi.de>,
 Ayush Sawal <ayush.sawal@chelsio.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn
 <willemb@google.com>, David Ahern <dsahern@kernel.org>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, Neal Cardwell <ncardwell@google.com>,
 Joerg Reuter <jreuter@yaina.de>, Marcel Holtmann <marcel@holtmann.org>,
 Johan Hedberg <johan.hedberg@gmail.com>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 Oliver Hartkopp <socketcan@hartkopp.net>,
 Marc Kleine-Budde <mkl@pengutronix.de>,
 Robin van der Gracht <robin@protonic.nl>,
 Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
 Alexander Aring <alex.aring@gmail.com>,
 Stefan Schmidt <stefan@datenfreihafen.org>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Alexandra Winter <wintera@linux.ibm.com>,
 Thorsten Winkler <twinkler@linux.ibm.com>,
 James Chapman <jchapman@katalix.com>, Jeremy Kerr <jk@codeconstruct.com.au>,
 Matt Johnston <matt@codeconstruct.com.au>,
 Matthieu Baerts <matttbe@kernel.org>, Mat Martineau <martineau@kernel.org>,
 Geliang Tang <geliang@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>,
 Remi Denis-Courmont <courmisch@gmail.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Wenjia Zhang <wenjia@linux.ibm.com>, Jan Karcher <jaka@linux.ibm.com>,
 "D. Wythe" <alibuda@linux.alibaba.com>, Tony Lu <tonylu@linux.alibaba.com>,
 Wen Gu <guwen@linux.alibaba.com>, Jon Maloy <jmaloy@redhat.com>,
 Boris Pismenny <borisp@nvidia.com>, John Fastabend
 <john.fastabend@gmail.com>, Stefano Garzarella <sgarzare@redhat.com>,
 Martin Schiller <ms@dev.tdt.de>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@kernel.org>, Magnus Karlsson <magnus.karlsson@intel.com>,
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
 Jonathan Lemon <jonathan.lemon@gmail.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
 linux-hams@vger.kernel.org, linux-bluetooth@vger.kernel.org,
 linux-can@vger.kernel.org, dccp@vger.kernel.org, linux-wpan@vger.kernel.org,
 linux-s390@vger.kernel.org, mptcp@lists.linux.dev,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-afs@lists.infradead.org, tipc-discussion@lists.sourceforge.net,
 virtualization@lists.linux.dev, linux-x25@vger.kernel.org,
 bpf@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
 io-uring@vger.kernel.org
References: <cover.1743449872.git.metze@samba.org>
 <Z-sDc-0qyfPZz9lv@mini-arch> <39515c76-310d-41af-a8b4-a814841449e3@samba.org>
Content-Language: en-US, de-DE
In-Reply-To: <39515c76-310d-41af-a8b4-a814841449e3@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 01.04.25 um 10:19 schrieb Stefan Metzmacher:
> Am 31.03.25 um 23:04 schrieb Stanislav Fomichev:
>> On 03/31, Stefan Metzmacher wrote:
>>> The motivation for this is to remove the SOL_SOCKET limitation
>>> from io_uring_cmd_getsockopt().
>>>
>>> The reason for this limitation is that io_uring_cmd_getsockopt()
>>> passes a kernel pointer as optlen to do_sock_getsockopt()
>>> and can't reach the ops->getsockopt() path.
>>>
>>> The first idea would be to change the optval and optlen arguments
>>> to the protocol specific hooks also to sockptr_t, as that
>>> is already used for setsockopt() and also by do_sock_getsockopt()
>>> sk_getsockopt() and BPF_CGROUP_RUN_PROG_GETSOCKOPT().
>>>
>>> But as Linus don't like 'sockptr_t' I used a different approach.
>>>
>>> @Linus, would that optlen_t approach fit better for you?
>>
>> [..]
>>
>>> Instead of passing the optlen as user or kernel pointer,
>>> we only ever pass a kernel pointer and do the
>>> translation from/to userspace in do_sock_getsockopt().
>>
>> At this point why not just fully embrace iov_iter? You have the size
>> now + the user (or kernel) pointer. Might as well do
>> s/sockptr_t/iov_iter/ conversion?
> 
> I think that would only be possible if we introduce
> proto[_ops].getsockopt_iter() and then convert the implementations
> step by step. Doing it all in one go has a lot of potential to break
> the uapi. I could try to convert things like socket, ip and tcp myself, but
> the rest needs to be converted by the maintainer of the specific protocol,
> as it needs to be tested. As there are crazy things happening in the existing
> implementations, e.g. some getsockopt() implementations use optval as in and out
> buffer.
> 
> I first tried to convert both optval and optlen of getsockopt to sockptr_t,
> and that showed that touching the optval part starts to get complex very soon,
> see https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=141912166473bf8843ec6ace76dc9c6945adafd1
> (note it didn't converted everything, I gave up after hitting
> sctp_getsockopt_peer_addrs and sctp_getsockopt_local_addrs.
> sctp_getsockopt_context, sctp_getsockopt_maxseg, sctp_getsockopt_associnfo and maybe
> more are the ones also doing both copy_from_user and copy_to_user on optval)
> 
> I come also across one implementation that returned -ERANGE because *optlen was
> too short and put the required length into *optlen, which means the returned
> *optlen is larger than the optval buffer given from userspace.
> 
> Because of all these strange things I tried to do a minimal change
> in order to get rid of the io_uring limitation and only converted
> optlen and leave optval as is.
> 
> In order to have a patchset that has a low risk to cause regressions.
> 
> But as alternative introducing a prototype like this:
> 
>          int (*getsockopt_iter)(struct socket *sock, int level, int optname,
>                                 struct iov_iter *optval_iter);
> 
> That returns a non-negative value which can be placed into *optlen
> or negative value as error and *optlen will not be changed on error.
> optval_iter will get direction ITER_DEST, so it can only be written to.
> 
> Implementations could then opt in for the new interface and
> allow do_sock_getsockopt() work also for the io_uring case,
> while all others would still get -EOPNOTSUPP.
> 
> So what should be the way to go?

Ok, I've added the infrastructure for getsockopt_iter, see below,
but the first part I wanted to convert was
tcp_ao_copy_mkts_to_user() and that also reads from userspace before
writing.

So we could go with the optlen_t approach, or we need
logic for ITER_BOTH or pass two iov_iters one with ITER_SRC and one
with ITER_DEST...

So who wants to decide?

Thanks!
metze
---
  include/linux/net.h |  4 +++
  include/net/sock.h  | 64 +++++++++++++++++++++++++++++++++++++++++++++
  net/core/sock.c     | 12 +++++++--
  net/socket.c        | 12 +++++++--
  4 files changed, 88 insertions(+), 4 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index 0ff950eecc6b..ceb9f9ed84b9 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -194,6 +194,10 @@ struct proto_ops {
  				      unsigned int optlen);
  	int		(*getsockopt)(struct socket *sock, int level,
  				      int optname, char __user *optval, int __user *optlen);
+	int		(*getsockopt_iter)(struct socket *sock,
+					   int level,
+					   int optname,
+					   struct iov_iter *optval_iter);
  	void		(*show_fdinfo)(struct seq_file *m, struct socket *sock);
  	int		(*sendmsg)   (struct socket *sock, struct msghdr *m,
  				      size_t total_len);
diff --git a/include/net/sock.h b/include/net/sock.h
index 8daf1b3b12c6..e741b219056e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1249,6 +1249,11 @@ struct proto {
  	int			(*getsockopt)(struct sock *sk, int level,
  					int optname, char __user *optval,
  					int __user *option);
+	int			(*getsockopt_iter)(struct sock *sk,
+						   int level,
+						   int optname,
+						   struct iov_iter *optval_iter);
+
  	void			(*keepalive)(struct sock *sk, int valbool);
  #ifdef CONFIG_COMPAT
  	int			(*compat_ioctl)(struct sock *sk,
@@ -1781,6 +1786,65 @@ int do_sock_setsockopt(struct socket *sock, bool compat, int level,
  int do_sock_getsockopt(struct socket *sock, bool compat, int level,
  		       int optname, sockptr_t optval, sockptr_t optlen);

+#define __generic_wrap_getsockopt_iter(__s, __level,				\
+				       __optname, __optval, __optlen, 		\
+				       __getsockopt_iter) 			\
+do {										\
+	struct iov_iter optval_iter;						\
+	struct kvec optval_kvec;						\
+	int len;								\
+	int err;								\
+										\
+	if (unlikely(__getsockopt_iter == NULL))				\
+		return -EOPNOTSUPP;						\
+										\
+	if (copy_from_sockptr(&len, __optlen, sizeof(len)))			\
+		return -EFAULT;							\
+										\
+	if (len < 0)								\
+		return -EINVAL;							\
+										\
+	if (__optval.is_kernel) {						\
+		if (__optval.kernel == NULL && len != 0)			\
+			return -EFAULT;						\
+										\
+		optval_kvec = (struct kvec) {					\
+			.iov_base = __optval.kernel,				\
+			.iov_len = len,						\
+		};								\
+										\
+		iov_iter_kvec(&optval_iter, ITER_DEST,				\
+			      &optval_kvec, 1, optval_kvec.iov_len);		\
+	} else {								\
+		if (import_ubuf(ITER_DEST, __optval.user, len, &optval_iter))	\
+			return -EFAULT;						\
+	}									\
+										\
+	err = getsockopt_iter(__s, __level, __optname, &optval_iter);		\
+	if (unlikely(err < 0))							\
+		return err;							\
+										\
+	len = err;								\
+	if (copy_to_sockptr(__optlen, &len, sizeof(len)))			\
+		return -EFAULT;							\
+										\
+	return 0;								\
+} while (0)
+
+static __always_inline
+int sk_wrap_getsockopt_iter(struct sock *sk, int level, int optname, sockptr_t optval, sockptr_t optlen,
+	    int (*getsockopt_iter)(struct sock *sk, int level, int optname, struct iov_iter *optval_iter))
+{
+	__generic_wrap_getsockopt_iter(sk, level, optname, optval, optlen, getsockopt_iter);
+}
+
+static __always_inline
+int sock_wrap_getsockopt_iter(struct socket *sock, int level, int optname, sockptr_t optval, sockptr_t optlen,
+	    int (*getsockopt_iter)(struct socket *sock, int level, int optname, struct iov_iter *optval_iter))
+{
+	__generic_wrap_getsockopt_iter(sock, level, optname, optval, optlen, getsockopt_iter);
+}
+
  int sk_getsockopt(struct sock *sk, int level, int optname,
  		  sockptr_t optval, sockptr_t optlen);
  int sock_gettstamp(struct socket *sock, void __user *userstamp,
diff --git a/net/core/sock.c b/net/core/sock.c
index 323892066def..61625060e724 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3857,9 +3857,17 @@ int sock_common_getsockopt(struct socket *sock, int level, int optname,
  			   char __user *optval, int __user *optlen)
  {
  	struct sock *sk = sock->sk;
-
  	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
-	return READ_ONCE(sk->sk_prot)->getsockopt(sk, level, optname, optval, optlen);
+	struct proto *prot = READ_ONCE(sk->sk_prot);
+
+	if (prot->getsockopt_iter) {
+		return sk_wrap_getsockopt_iter(sk, level, optname,
+					       USER_SOCKPTR(optval),
+					       USER_SOCKPTR(optlen),
+					       prot->getsockopt_iter);
+	}
+
+	return prot->getsockopt(sk, level, optname, optval, optlen);
  }
  EXPORT_SYMBOL(sock_common_getsockopt);

diff --git a/net/socket.c b/net/socket.c
index 9a0e720f0859..792cfd272611 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2335,6 +2335,7 @@ int do_sock_getsockopt(struct socket *sock, bool compat, int level,
  {
  	int max_optlen __maybe_unused = 0;
  	const struct proto_ops *ops;
+	const struct proto *prot;
  	int err;

  	err = security_socket_getsockopt(sock, level, optname);
@@ -2345,12 +2346,19 @@ int do_sock_getsockopt(struct socket *sock, bool compat, int level,
  		copy_from_sockptr(&max_optlen, optlen, sizeof(int));

  	ops = READ_ONCE(sock->ops);
+	prot = READ_ONCE(sock->sk->sk_prot);
  	if (level == SOL_SOCKET) {
  		err = sk_getsockopt(sock->sk, level, optname, optval, optlen);
-	} else if (unlikely(!ops->getsockopt)) {
+	} else if (ops->getsockopt_iter) {
+		err = sock_wrap_getsockopt_iter(sock, level, optname, optval, optlen,
+					        ops->getsockopt_iter);
+	} else if (ops->getsockopt == sock_common_getsockopt && prot->getsockopt_iter) {
+		err = sk_wrap_getsockopt_iter(sock->sk, level, optname, optval, optlen,
+					      prot->getsockopt_iter);
+	} else if (unlikely(!ops->getsockopt || optlen.is_kernel)) {
  		err = -EOPNOTSUPP;
  	} else {
-		if (WARN_ONCE(optval.is_kernel || optlen.is_kernel,
+		if (WARN_ONCE(optval.is_kernel,
  			      "Invalid argument type"))
  			return -EOPNOTSUPP;

-- 
2.34.1





