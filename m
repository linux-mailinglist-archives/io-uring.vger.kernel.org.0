Return-Path: <io-uring+bounces-7328-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E11A0A76E9F
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 22:14:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79E1F7A4293
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 20:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7034121B8F5;
	Mon, 31 Mar 2025 20:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="HaMLT+pu"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B5021ADA7;
	Mon, 31 Mar 2025 20:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743451952; cv=none; b=SC+MEMHMyWrKJ6moW/ycq8jIEU92a+J5iQ7xe7RuYGi2+L7x6HxBoL2B4Peq8Jz4bPdJewJsOusi7ohrD/42ZIyDtggF/G6+Z5tgCYDbjLuIpjJUljGq8iQ5EGN0/FNs9QN/XjG8F7Op5miaIcfNINzOS+RAb5/fnb+qwtxHRS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743451952; c=relaxed/simple;
	bh=iPpSVkPLCqTR2FyjxqGiQmNQFigqWYQjZN94TFT+FdI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EDT7TiULtQQyUaSUA3YQVb9fx+MmeiyuA0/tJC/anN2eOZtm1P1OZA75+Km2Yn+x/3Q8QcF9sVQjQS+9u4DTSEij/Rt0ssqcx5cFWMV8GDL+AurZ/Av+8Pva5xjX4QJQ071a7eKb+nvWIZKIFa0F7/B1RYclQ48Pk3HjpSPjzns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=HaMLT+pu; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=corXYKtJ23LaPpSvYrVPsGmSDY+XSF/X9wsRycS5+lc=; b=HaMLT+pumF/qmIZ13QXemGXEwX
	sYHRpFvy0hXU5/Dn5vxkEodSQLsOeCRPc3TY5LAkZ2TdMmATbkbxe0yXJyuER/Cha98NqygrSrBEc
	UTDnkILhhkbDs926rZydbqnlyJ+O1w9XG5dP8SzzIosjC4mcyFNlCj5ToWLt33gvNnEA+Msoe2+8S
	ET3vtpbehK0NwuPq3HnYSIEEi16uObgQ6tx8gZ7n77xjfIznVtAVrwstvnBYYjyte9bvL0Bu8ZSjF
	RJ0lyuqUmcRhxKq+m+lb9KLrxYL6Dhv1fIH6hIZLBeZ/vV5o54ADhLEB7/dPFXCdlMVfHy6fpQipM
	vFqlxP//PbHP2KzSYDUsE9CbqW6kVosi3e3hk3ud8UdyVgTZ8ZpG9+Tv5yVL16TMkOdOWQuKRycFo
	xAYxn91c6Ukt52iQtqkDiqNoLV3FNumCnB917CBatfogcmbL0FZROEBDVgt058ezGrtYythRtgmLU
	PiKHg4O/1I5bdsqycnyN9bDM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tzLUc-007Y7K-13;
	Mon, 31 Mar 2025 20:12:22 +0000
From: Stefan Metzmacher <metze@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>
Cc: Stefan Metzmacher <metze@samba.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Karsten Keil <isdn@linux-pingi.de>,
	Ayush Sawal <ayush.sawal@chelsio.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Neal Cardwell <ncardwell@google.com>,
	Joerg Reuter <jreuter@yaina.de>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Robin van der Gracht <robin@protonic.nl>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	kernel@pengutronix.de,
	Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Thorsten Winkler <twinkler@linux.ibm.com>,
	James Chapman <jchapman@katalix.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Matt Johnston <matt@codeconstruct.com.au>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Remi Denis-Courmont <courmisch@gmail.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Jan Karcher <jaka@linux.ibm.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Martin Schiller <ms@dev.tdt.de>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	linux-hams@vger.kernel.org,
	linux-bluetooth@vger.kernel.org,
	linux-can@vger.kernel.org,
	dccp@vger.kernel.org,
	linux-wpan@vger.kernel.org,
	linux-s390@vger.kernel.org,
	mptcp@lists.linux.dev,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-afs@lists.infradead.org,
	tipc-discussion@lists.sourceforge.net,
	virtualization@lists.linux.dev,
	linux-x25@vger.kernel.org,
	bpf@vger.kernel.org,
	isdn4linux@listserv.isdn4linux.de,
	io-uring@vger.kernel.org
Subject: [RFC PATCH 2/4] net: pass 'optlen_t' to proto[ops].getsockopt() hooks
Date: Mon, 31 Mar 2025 22:10:54 +0200
Message-Id: <76db80040bdeeb4a0221b5b6583fda4988afa64e.1743449872.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1743449872.git.metze@samba.org>
References: <cover.1743449872.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The motivation for this is to remove the SOL_SOCKET limitation
from io_uring_cmd_getsockopt().

The reason for this limitation is that io_uring_cmd_getsockopt()
passes a kernel pointer.

The first idea would be to change the optval and optlen arguments
to the protocol specific hooks also to sockptr_t, as that
is already used for setsockopt() and also by do_sock_getsockopt()
sk_getsockopt() and BPF_CGROUP_RUN_PROG_GETSOCKOPT().

But as Linus don't like 'sockptr_t' I used a different approach.

This step only introduces 'optlen_t' as a trivial wrapper of
the 'int __user *', it makes sure that the optlen argument
is only ever used by get_optval(), put_optval.
For some corner cases OPTLEN_SOCKPTR().

We still expect a __user pointer, so this should be easy to
review and don't change the logic.

Link: https://lore.kernel.org/io-uring/86b1dce5-4bb4-4a0b-9cff-e72f488bf57d@samba.org/T/#t
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: Ayush Sawal <ayush.sawal@chelsio.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Joerg Reuter <jreuter@yaina.de>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Robin van der Gracht <robin@protonic.nl>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: kernel@pengutronix.de
Cc: Alexander Aring <alex.aring@gmail.com>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Alexandra Winter <wintera@linux.ibm.com>
Cc: Thorsten Winkler <twinkler@linux.ibm.com>
Cc: James Chapman <jchapman@katalix.com>
Cc: Jeremy Kerr <jk@codeconstruct.com.au>
Cc: Matt Johnston <matt@codeconstruct.com.au>
Cc: Matthieu Baerts <matttbe@kernel.org>
Cc: Mat Martineau <martineau@kernel.org>
Cc: Geliang Tang <geliang@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Remi Denis-Courmont <courmisch@gmail.com>
Cc: Allison Henderson <allison.henderson@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: Wenjia Zhang <wenjia@linux.ibm.com>
Cc: Jan Karcher <jaka@linux.ibm.com>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: Tony Lu <tonylu@linux.alibaba.com>
Cc: Wen Gu <guwen@linux.alibaba.com>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Boris Pismenny <borisp@nvidia.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Cc: "Björn Töpel" <bjorn@kernel.org>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
CC: Stefan Metzmacher <metze@samba.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-sctp@vger.kernel.org
Cc: linux-hams@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org
Cc: linux-can@vger.kernel.org
Cc: dccp@vger.kernel.org
Cc: linux-wpan@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: mptcp@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
Cc: rds-devel@oss.oracle.com
Cc: linux-afs@lists.infradead.org
Cc: tipc-discussion@lists.sourceforge.net
Cc: virtualization@lists.linux.dev
Cc: linux-x25@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: isdn4linux@listserv.isdn4linux.de
Cc: io-uring@vger.kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 drivers/isdn/mISDN/socket.c                   |   2 +-
 .../chelsio/inline_crypto/chtls/chtls_main.c  |   4 +-
 include/linux/net.h                           |   2 +-
 include/linux/sockptr.h                       |  17 ++-
 include/net/inet_connection_sock.h            |   2 +-
 include/net/ip.h                              |   2 +-
 include/net/ipv6.h                            |   2 +-
 include/net/sctp/structs.h                    |   2 +-
 include/net/sock.h                            |   4 +-
 include/net/tcp.h                             |   2 +-
 include/net/udp.h                             |   2 +-
 net/atm/common.c                              |   2 +-
 net/atm/common.h                              |   2 +-
 net/atm/pvc.c                                 |   2 +-
 net/atm/svc.c                                 |   2 +-
 net/ax25/af_ax25.c                            |   2 +-
 net/bluetooth/hci_sock.c                      |   4 +-
 net/bluetooth/iso.c                           |   2 +-
 net/bluetooth/l2cap_sock.c                    |   4 +-
 net/bluetooth/rfcomm/sock.c                   |   4 +-
 net/bluetooth/sco.c                           |   4 +-
 net/can/isotp.c                               |   2 +-
 net/can/j1939/socket.c                        |   2 +-
 net/can/raw.c                                 |   2 +-
 net/core/sock.c                               |   2 +-
 net/dccp/ccid.c                               |   2 +-
 net/dccp/ccid.h                               |  10 +-
 net/dccp/ccids/ccid3.c                        |   4 +-
 net/dccp/dccp.h                               |   2 +-
 net/dccp/proto.c                              |   6 +-
 net/ieee802154/socket.c                       |   4 +-
 net/ipv4/ip_sockglue.c                        |   4 +-
 net/ipv4/raw.c                                |   6 +-
 net/ipv4/tcp.c                                |   4 +-
 net/ipv4/udp.c                                |   4 +-
 net/ipv4/udp_impl.h                           |   2 +-
 net/ipv6/ipv6_sockglue.c                      |   4 +-
 net/ipv6/raw.c                                |   6 +-
 net/ipv6/udp.c                                |   2 +-
 net/ipv6/udp_impl.h                           |   2 +-
 net/iucv/af_iucv.c                            |   2 +-
 net/kcm/kcmsock.c                             |   2 +-
 net/l2tp/l2tp_ppp.c                           |   2 +-
 net/llc/af_llc.c                              |   2 +-
 net/mctp/af_mctp.c                            |   2 +-
 net/mptcp/protocol.h                          |   2 +-
 net/mptcp/sockopt.c                           |  30 ++---
 net/netlink/af_netlink.c                      |   2 +-
 net/netrom/af_netrom.c                        |   2 +-
 net/nfc/llcp_sock.c                           |   2 +-
 net/packet/af_packet.c                        |   2 +-
 net/phonet/pep.c                              |   2 +-
 net/rds/af_rds.c                              |   2 +-
 net/rds/info.c                                |   2 +-
 net/rds/info.h                                |   2 +-
 net/rose/af_rose.c                            |   2 +-
 net/rxrpc/af_rxrpc.c                          |   2 +-
 net/sctp/socket.c                             | 112 +++++++++---------
 net/smc/af_smc.c                              |   4 +-
 net/smc/smc.h                                 |   2 +-
 net/socket.c                                  |   7 +-
 net/tipc/socket.c                             |   2 +-
 net/tls/tls_main.c                            |  10 +-
 net/vmw_vsock/af_vsock.c                      |   2 +-
 net/x25/af_x25.c                              |   2 +-
 net/xdp/xsk.c                                 |   2 +-
 66 files changed, 178 insertions(+), 166 deletions(-)

diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index b750cc0dfa4a..233426f24ab6 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -433,7 +433,7 @@ static int data_sock_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int data_sock_getsockopt(struct socket *sock, int level, int optname,
-				char __user *optval, int __user *optlen)
+				char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	int len, opt;
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
index daa1ebaef511..ac73ed4fc5d4 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
@@ -466,7 +466,7 @@ static int chtls_uld_rx_handler(void *handle, const __be64 *rsp,
 }
 
 static int do_chtls_getsockopt(struct sock *sk, char __user *optval,
-			       int __user *optlen)
+			       optlen_t optlen)
 {
 	struct tls_crypto_info crypto_info = { 0 };
 
@@ -477,7 +477,7 @@ static int do_chtls_getsockopt(struct sock *sk, char __user *optval,
 }
 
 static int chtls_getsockopt(struct sock *sk, int level, int optname,
-			    char __user *optval, int __user *optlen)
+			    char __user *optval, optlen_t optlen)
 {
 	struct tls_context *ctx = tls_get_ctx(sk);
 
diff --git a/include/linux/net.h b/include/linux/net.h
index 0ff950eecc6b..f8b2728f993c 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -193,7 +193,7 @@ struct proto_ops {
 				      int optname, sockptr_t optval,
 				      unsigned int optlen);
 	int		(*getsockopt)(struct socket *sock, int level,
-				      int optname, char __user *optval, int __user *optlen);
+				      int optname, char __user *optval, optlen_t optlen);
 	void		(*show_fdinfo)(struct seq_file *m, struct socket *sock);
 	int		(*sendmsg)   (struct socket *sock, struct msghdr *m,
 				      size_t total_len);
diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
index 28dbc3e27374..1baf66f26f4f 100644
--- a/include/linux/sockptr.h
+++ b/include/linux/sockptr.h
@@ -169,17 +169,21 @@ static inline int check_zeroed_sockptr(sockptr_t src, size_t offset,
 	return memchr_inv(src.kernel + offset, 0, size) == NULL;
 }
 
+typedef struct {
+	int __user *up;
+} optlen_t;
+
 #define __check_optlen_t(__optlen)				\
 ({								\
-	int __user *__ptr __maybe_unused = __optlen; 		\
-	BUILD_BUG_ON(sizeof(*(__ptr)) != sizeof(int));		\
+	optlen_t *__ptr __maybe_unused = &__optlen; \
+	BUILD_BUG_ON(sizeof(*((__ptr)->up)) != sizeof(int));	\
 })
 
 #define get_optlen(__val, __optlen)				\
 ({								\
 	long __err;						\
 	__check_optlen_t(__optlen);				\
-	__err = get_user(__val, __optlen);			\
+	__err = get_user(__val, __optlen.up);			\
 	__err;							\
 })
 
@@ -187,8 +191,13 @@ static inline int check_zeroed_sockptr(sockptr_t src, size_t offset,
 ({								\
 	long __err;						\
 	__check_optlen_t(__optlen);				\
-	__err = put_user(__val, __optlen);			\
+	__err = put_user(__val, __optlen.up);			\
 	__err;							\
 })
 
+static inline sockptr_t OPTLEN_SOCKPTR(optlen_t optlen)
+{
+	return (sockptr_t) { .user = optlen.up, };
+}
+
 #endif /* _LINUX_SOCKPTR_H */
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 1735db332aab..3a3d03308611 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -47,7 +47,7 @@ struct inet_connection_sock_af_ops {
 	int	    (*setsockopt)(struct sock *sk, int level, int optname,
 				  sockptr_t optval, unsigned int optlen);
 	int	    (*getsockopt)(struct sock *sk, int level, int optname,
-				  char __user *optval, int __user *optlen);
+				  char __user *optval, optlen_t optlen);
 	void	    (*mtu_reduced)(struct sock *sk);
 };
 
diff --git a/include/net/ip.h b/include/net/ip.h
index 8a48ade24620..9f725642a42e 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -802,7 +802,7 @@ int ip_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 int do_ip_getsockopt(struct sock *sk, int level, int optname,
 		     sockptr_t optval, sockptr_t optlen);
 int ip_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
-		  int __user *optlen);
+		  optlen_t optlen);
 int ip_ra_control(struct sock *sk, unsigned char on,
 		  void (*destructor)(struct sock *));
 
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 2ccdf85f34f1..99e655db1dde 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1186,7 +1186,7 @@ int ipv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 int do_ipv6_getsockopt(struct sock *sk, int level, int optname,
 		       sockptr_t optval, sockptr_t optlen);
 int ipv6_getsockopt(struct sock *sk, int level, int optname,
-		    char __user *optval, int __user *optlen);
+		    char __user *optval, optlen_t optlen);
 
 int __ip6_datagram_connect(struct sock *sk, struct sockaddr *addr,
 			   int addr_len);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 31248cfdfb23..15f9b9ece3ea 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -441,7 +441,7 @@ struct sctp_af {
 					 int level,
 					 int optname,
 					 char __user *optval,
-					 int __user *optlen);
+					 optlen_t optlen);
 	void		(*get_dst)	(struct sctp_transport *t,
 					 union sctp_addr *saddr,
 					 struct flowi *fl,
diff --git a/include/net/sock.h b/include/net/sock.h
index 8daf1b3b12c6..94c0e90d8901 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1248,7 +1248,7 @@ struct proto {
 					unsigned int optlen);
 	int			(*getsockopt)(struct sock *sk, int level,
 					int optname, char __user *optval,
-					int __user *option);
+					optlen_t optlen);
 	void			(*keepalive)(struct sock *sk, int valbool);
 #ifdef CONFIG_COMPAT
 	int			(*compat_ioctl)(struct sock *sk,
@@ -1856,7 +1856,7 @@ int sock_no_mmap(struct file *file, struct socket *sock,
  * uses the inet style.
  */
 int sock_common_getsockopt(struct socket *sock, int level, int optname,
-				  char __user *optval, int __user *optlen);
+				  char __user *optval, optlen_t optlen);
 int sock_common_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			int flags);
 int sock_common_setsockopt(struct socket *sock, int level, int optname,
diff --git a/include/net/tcp.h b/include/net/tcp.h
index df04dc09c519..75e6bcd6eac4 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -449,7 +449,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock,
 int do_tcp_getsockopt(struct sock *sk, int level,
 		      int optname, sockptr_t optval, sockptr_t optlen);
 int tcp_getsockopt(struct sock *sk, int level, int optname,
-		   char __user *optval, int __user *optlen);
+		   char __user *optval, optlen_t optlen);
 bool tcp_bpf_bypass_getsockopt(int level, int optname);
 int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 		      sockptr_t optval, unsigned int optlen);
diff --git a/include/net/udp.h b/include/net/udp.h
index 6e89520e100d..a846681ae497 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -418,7 +418,7 @@ struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
 				       netdev_features_t features,
 				       bool is_ipv6);
 int udp_lib_getsockopt(struct sock *sk, int level, int optname,
-		       char __user *optval, int __user *optlen);
+		       char __user *optval, optlen_t optlen);
 int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 		       sockptr_t optval, unsigned int optlen,
 		       int (*push_pending_frames)(struct sock *));
diff --git a/net/atm/common.c b/net/atm/common.c
index e95371abd705..55844a930ccf 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -787,7 +787,7 @@ int vcc_setsockopt(struct socket *sock, int level, int optname,
 }
 
 int vcc_getsockopt(struct socket *sock, int level, int optname,
-		   char __user *optval, int __user *optlen)
+		   char __user *optval, optlen_t optlen)
 {
 	struct atm_vcc *vcc;
 	int len;
diff --git a/net/atm/common.h b/net/atm/common.h
index a1e56e8de698..67a25f92a929 100644
--- a/net/atm/common.h
+++ b/net/atm/common.h
@@ -23,7 +23,7 @@ int vcc_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg);
 int vcc_setsockopt(struct socket *sock, int level, int optname,
 		   sockptr_t optval, unsigned int optlen);
 int vcc_getsockopt(struct socket *sock, int level, int optname,
-		   char __user *optval, int __user *optlen);
+		   char __user *optval, optlen_t optlen);
 void vcc_process_recv_queue(struct atm_vcc *vcc);
 
 int atmpvc_init(void);
diff --git a/net/atm/pvc.c b/net/atm/pvc.c
index 66d9a9bd5896..2f01f862d0fb 100644
--- a/net/atm/pvc.c
+++ b/net/atm/pvc.c
@@ -75,7 +75,7 @@ static int pvc_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int pvc_getsockopt(struct socket *sock, int level, int optname,
-			  char __user *optval, int __user *optlen)
+			  char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	int error;
diff --git a/net/atm/svc.c b/net/atm/svc.c
index a706c5f77d8e..600f7d381348 100644
--- a/net/atm/svc.c
+++ b/net/atm/svc.c
@@ -501,7 +501,7 @@ static int svc_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int svc_getsockopt(struct socket *sock, int level, int optname,
-			  char __user *optval, int __user *optlen)
+			  char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	int error = 0, len;
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index b184e2cb4b50..0e069f2ceb12 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -715,7 +715,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int ax25_getsockopt(struct socket *sock, int level, int optname,
-	char __user *optval, int __user *optlen)
+	char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	ax25_cb *ax25;
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 4b4e476e4e7c..90949b8dad2e 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -2053,7 +2053,7 @@ static int hci_sock_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int hci_sock_getsockopt_old(struct socket *sock, int level, int optname,
-				   char __user *optval, int __user *optlen)
+				   char __user *optval, optlen_t optlen)
 {
 	struct hci_ufilter uf;
 	struct sock *sk = sock->sk;
@@ -2119,7 +2119,7 @@ static int hci_sock_getsockopt_old(struct socket *sock, int level, int optname,
 }
 
 static int hci_sock_getsockopt(struct socket *sock, int level, int optname,
-			       char __user *optval, int __user *optlen)
+			       char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	int err = 0;
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index f6624b6e5485..72369c912161 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1721,7 +1721,7 @@ static int iso_sock_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int iso_sock_getsockopt(struct socket *sock, int level, int optname,
-			       char __user *optval, int __user *optlen)
+			       char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	int len, err = 0;
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 8ae25a918fd3..ac36d0ec08d3 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -433,7 +433,7 @@ static int l2cap_get_mode(struct l2cap_chan *chan)
 }
 
 static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
-				     char __user *optval, int __user *optlen)
+				     char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
@@ -553,7 +553,7 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 }
 
 static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
-				 char __user *optval, int __user *optlen)
+				 char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 785894b79dd8..10ec25dc038d 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -722,7 +722,7 @@ static int rfcomm_sock_setsockopt(struct socket *sock, int level, int optname,
 	return err;
 }
 
-static int rfcomm_sock_getsockopt_old(struct socket *sock, int optname, char __user *optval, int __user *optlen)
+static int rfcomm_sock_getsockopt_old(struct socket *sock, int optname, char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	struct sock *l2cap_sk;
@@ -798,7 +798,7 @@ static int rfcomm_sock_getsockopt_old(struct socket *sock, int optname, char __u
 	return err;
 }
 
-static int rfcomm_sock_getsockopt(struct socket *sock, int level, int optname, char __user *optval, int __user *optlen)
+static int rfcomm_sock_getsockopt(struct socket *sock, int level, int optname, char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	struct bt_security sec;
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 25910eca759c..e95d924fe41d 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -1037,7 +1037,7 @@ static int sco_sock_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int sco_sock_getsockopt_old(struct socket *sock, int optname,
-				   char __user *optval, int __user *optlen)
+				   char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	struct sco_options opts;
@@ -1099,7 +1099,7 @@ static int sco_sock_getsockopt_old(struct socket *sock, int optname,
 }
 
 static int sco_sock_getsockopt(struct socket *sock, int level, int optname,
-			       char __user *optval, int __user *optlen)
+			       char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	int len, err = 0;
diff --git a/net/can/isotp.c b/net/can/isotp.c
index aa9ab87d5e14..2a321400a9f8 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1486,7 +1486,7 @@ static int isotp_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int isotp_getsockopt(struct socket *sock, int level, int optname,
-			    char __user *optval, int __user *optlen)
+			    char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index b2b538528c2e..606f8b3ac96f 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -754,7 +754,7 @@ static int j1939_sk_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int j1939_sk_getsockopt(struct socket *sock, int level, int optname,
-			       char __user *optval, int __user *optlen)
+			       char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	struct j1939_sock *jsk = j1939_sk(sk);
diff --git a/net/can/raw.c b/net/can/raw.c
index 8d1a1626d1a4..59c6d701db05 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -753,7 +753,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int raw_getsockopt(struct socket *sock, int level, int optname,
-			  char __user *optval, int __user *optlen)
+			  char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	struct raw_sock *ro = raw_sk(sk);
diff --git a/net/core/sock.c b/net/core/sock.c
index 323892066def..2cd7bd5b2a05 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3854,7 +3854,7 @@ EXPORT_SYMBOL(sock_recv_errqueue);
  *	this means if you specify SO_ERROR (otherwise what is the point of it).
  */
 int sock_common_getsockopt(struct socket *sock, int level, int optname,
-			   char __user *optval, int __user *optlen)
+			   char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 
diff --git a/net/dccp/ccid.c b/net/dccp/ccid.c
index 6f495ffb1d60..b5fad2a7e9a8 100644
--- a/net/dccp/ccid.c
+++ b/net/dccp/ccid.c
@@ -58,7 +58,7 @@ int ccid_get_builtin_ccids(u8 **ccid_array, u8 *array_len)
 }
 
 int ccid_getsockopt_builtin_ccids(struct sock *sk, int len,
-				  char __user *optval, int __user *optlen)
+				  char __user *optval, optlen_t optlen)
 {
 	u8 *ccid_array, array_len;
 	int err = 0;
diff --git a/net/dccp/ccid.h b/net/dccp/ccid.h
index 105f3734dadb..2758d760af36 100644
--- a/net/dccp/ccid.h
+++ b/net/dccp/ccid.h
@@ -78,11 +78,11 @@ struct ccid_operations {
 	int		(*ccid_hc_rx_getsockopt)(struct sock *sk,
 						 const int optname, int len,
 						 u32 __user *optval,
-						 int __user *optlen);
+						 optlen_t optlen);
 	int		(*ccid_hc_tx_getsockopt)(struct sock *sk,
 						 const int optname, int len,
 						 u32 __user *optval,
-						 int __user *optlen);
+						 optlen_t optlen);
 };
 
 extern struct ccid_operations ccid2_ops;
@@ -106,7 +106,7 @@ static inline void *ccid_priv(const struct ccid *ccid)
 bool ccid_support_check(u8 const *ccid_array, u8 array_len);
 int ccid_get_builtin_ccids(u8 **ccid_array, u8 *array_len);
 int ccid_getsockopt_builtin_ccids(struct sock *sk, int len,
-				  char __user *, int __user *);
+				  char __user *, optlen_t );
 
 struct ccid *ccid_new(const u8 id, struct sock *sk, bool rx);
 
@@ -240,7 +240,7 @@ static inline void ccid_hc_tx_get_info(struct ccid *ccid, struct sock *sk,
 
 static inline int ccid_hc_rx_getsockopt(struct ccid *ccid, struct sock *sk,
 					const int optname, int len,
-					u32 __user *optval, int __user *optlen)
+					u32 __user *optval, optlen_t optlen)
 {
 	int rc = -ENOPROTOOPT;
 	if (ccid != NULL && ccid->ccid_ops->ccid_hc_rx_getsockopt != NULL)
@@ -251,7 +251,7 @@ static inline int ccid_hc_rx_getsockopt(struct ccid *ccid, struct sock *sk,
 
 static inline int ccid_hc_tx_getsockopt(struct ccid *ccid, struct sock *sk,
 					const int optname, int len,
-					u32 __user *optval, int __user *optlen)
+					u32 __user *optval, optlen_t optlen)
 {
 	int rc = -ENOPROTOOPT;
 	if (ccid != NULL && ccid->ccid_ops->ccid_hc_tx_getsockopt != NULL)
diff --git a/net/dccp/ccids/ccid3.c b/net/dccp/ccids/ccid3.c
index 648aa5270f37..8e4f16ccba57 100644
--- a/net/dccp/ccids/ccid3.c
+++ b/net/dccp/ccids/ccid3.c
@@ -518,7 +518,7 @@ static void ccid3_hc_tx_get_info(struct sock *sk, struct tcp_info *info)
 }
 
 static int ccid3_hc_tx_getsockopt(struct sock *sk, const int optname, int len,
-				  u32 __user *optval, int __user *optlen)
+				  u32 __user *optval, optlen_t optlen)
 {
 	const struct ccid3_hc_tx_sock *hc = ccid3_hc_tx_sk(sk);
 	struct tfrc_tx_info tfrc;
@@ -813,7 +813,7 @@ static void ccid3_hc_rx_get_info(struct sock *sk, struct tcp_info *info)
 }
 
 static int ccid3_hc_rx_getsockopt(struct sock *sk, const int optname, int len,
-				  u32 __user *optval, int __user *optlen)
+				  u32 __user *optval, optlen_t optlen)
 {
 	const struct ccid3_hc_rx_sock *hc = ccid3_hc_rx_sk(sk);
 	struct tfrc_rx_info rx_info;
diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
index 1f748ed1279d..f6d99913e1ca 100644
--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -289,7 +289,7 @@ struct sk_buff *dccp_make_response(const struct sock *sk, struct dst_entry *dst,
 int dccp_connect(struct sock *sk);
 int dccp_disconnect(struct sock *sk, int flags);
 int dccp_getsockopt(struct sock *sk, int level, int optname,
-		    char __user *optval, int __user *optlen);
+		    char __user *optval, optlen_t optlen);
 int dccp_setsockopt(struct sock *sk, int level, int optname,
 		    sockptr_t optval, unsigned int optlen);
 int dccp_ioctl(struct sock *sk, int cmd, int *karg);
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 8d6461ef8b50..2255f359058d 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -586,7 +586,7 @@ EXPORT_SYMBOL_GPL(dccp_setsockopt);
 
 static int dccp_getsockopt_service(struct sock *sk, int len,
 				   __be32 __user *optval,
-				   int __user *optlen)
+				   optlen_t optlen)
 {
 	const struct dccp_sock *dp = dccp_sk(sk);
 	const struct dccp_service_list *sl;
@@ -613,7 +613,7 @@ static int dccp_getsockopt_service(struct sock *sk, int len,
 }
 
 static int do_dccp_getsockopt(struct sock *sk, int level, int optname,
-		    char __user *optval, int __user *optlen)
+		    char __user *optval, optlen_t optlen)
 {
 	struct dccp_sock *dp;
 	int val, len;
@@ -681,7 +681,7 @@ static int do_dccp_getsockopt(struct sock *sk, int level, int optname,
 }
 
 int dccp_getsockopt(struct sock *sk, int level, int optname,
-		    char __user *optval, int __user *optlen)
+		    char __user *optval, optlen_t optlen)
 {
 	if (level != SOL_DCCP)
 		return inet_csk(sk)->icsk_af_ops->getsockopt(sk, level,
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index cc1788853c08..7fb31054c0ad 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -380,7 +380,7 @@ static void ieee802154_raw_deliver(struct net_device *dev, struct sk_buff *skb)
 }
 
 static int raw_getsockopt(struct sock *sk, int level, int optname,
-			  char __user *optval, int __user *optlen)
+			  char __user *optval, optlen_t optlen)
 {
 	return -EOPNOTSUPP;
 }
@@ -832,7 +832,7 @@ static int ieee802154_dgram_deliver(struct net_device *dev, struct sk_buff *skb)
 }
 
 static int dgram_getsockopt(struct sock *sk, int level, int optname,
-			    char __user *optval, int __user *optlen)
+			    char __user *optval, optlen_t optlen)
 {
 	struct dgram_sock *ro = dgram_sk(sk);
 
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 4d372f76b317..6757c8d12778 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1758,12 +1758,12 @@ int do_ip_getsockopt(struct sock *sk, int level, int optname,
 }
 
 int ip_getsockopt(struct sock *sk, int level,
-		  int optname, char __user *optval, int __user *optlen)
+		  int optname, char __user *optval, optlen_t optlen)
 {
 	int err;
 
 	err = do_ip_getsockopt(sk, level, optname,
-			       USER_SOCKPTR(optval), USER_SOCKPTR(optlen));
+			       USER_SOCKPTR(optval), OPTLEN_SOCKPTR(optlen));
 
 #ifdef CONFIG_NETFILTER
 	/* we need to exclude all possible ENOPROTOOPTs except default case */
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 89d70acdacdc..de8c67c08c20 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -807,7 +807,7 @@ static int raw_seticmpfilter(struct sock *sk, sockptr_t optval, int optlen)
 	return 0;
 }
 
-static int raw_geticmpfilter(struct sock *sk, char __user *optval, int __user *optlen)
+static int raw_geticmpfilter(struct sock *sk, char __user *optval, optlen_t optlen)
 {
 	int len, ret = -EFAULT;
 
@@ -847,7 +847,7 @@ static int raw_setsockopt(struct sock *sk, int level, int optname,
 }
 
 static int do_raw_getsockopt(struct sock *sk, int optname,
-			     char __user *optval, int __user *optlen)
+			     char __user *optval, optlen_t optlen)
 {
 	if (optname == ICMP_FILTER) {
 		if (inet_sk(sk)->inet_num != IPPROTO_ICMP)
@@ -859,7 +859,7 @@ static int do_raw_getsockopt(struct sock *sk, int optname,
 }
 
 static int raw_getsockopt(struct sock *sk, int level, int optname,
-			  char __user *optval, int __user *optlen)
+			  char __user *optval, optlen_t optlen)
 {
 	if (level != SOL_RAW)
 		return ip_getsockopt(sk, level, optname, optval, optlen);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ea8de00f669d..89d7a5b0364e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4732,7 +4732,7 @@ bool tcp_bpf_bypass_getsockopt(int level, int optname)
 EXPORT_IPV6_MOD(tcp_bpf_bypass_getsockopt);
 
 int tcp_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
-		   int __user *optlen)
+		   optlen_t optlen)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
@@ -4741,7 +4741,7 @@ int tcp_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
 		return READ_ONCE(icsk->icsk_af_ops)->getsockopt(sk, level, optname,
 								optval, optlen);
 	return do_tcp_getsockopt(sk, level, optname, USER_SOCKPTR(optval),
-				 USER_SOCKPTR(optlen));
+				 OPTLEN_SOCKPTR(optlen));
 }
 EXPORT_IPV6_MOD(tcp_getsockopt);
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 17c3fb1acb30..b27954698f5e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -3053,7 +3053,7 @@ int udp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 }
 
 int udp_lib_getsockopt(struct sock *sk, int level, int optname,
-		       char __user *optval, int __user *optlen)
+		       char __user *optval, optlen_t optlen)
 {
 	struct udp_sock *up = udp_sk(sk);
 	int val, len;
@@ -3114,7 +3114,7 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 EXPORT_IPV6_MOD(udp_lib_getsockopt);
 
 int udp_getsockopt(struct sock *sk, int level, int optname,
-		   char __user *optval, int __user *optlen)
+		   char __user *optval, optlen_t optlen)
 {
 	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
 		return udp_lib_getsockopt(sk, level, optname, optval, optlen);
diff --git a/net/ipv4/udp_impl.h b/net/ipv4/udp_impl.h
index e1ff3a375996..67a01fd5154f 100644
--- a/net/ipv4/udp_impl.h
+++ b/net/ipv4/udp_impl.h
@@ -15,7 +15,7 @@ void udp_v4_rehash(struct sock *sk);
 int udp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 		   unsigned int optlen);
 int udp_getsockopt(struct sock *sk, int level, int optname,
-		   char __user *optval, int __user *optlen);
+		   char __user *optval, optlen_t optlen);
 
 int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 		int *addr_len);
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 9b1843288035..253e420802ca 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -1470,7 +1470,7 @@ int do_ipv6_getsockopt(struct sock *sk, int level, int optname,
 }
 
 int ipv6_getsockopt(struct sock *sk, int level, int optname,
-		    char __user *optval, int __user *optlen)
+		    char __user *optval, optlen_t optlen)
 {
 	int err;
 
@@ -1481,7 +1481,7 @@ int ipv6_getsockopt(struct sock *sk, int level, int optname,
 		return -ENOPROTOOPT;
 
 	err = do_ipv6_getsockopt(sk, level, optname,
-				 USER_SOCKPTR(optval), USER_SOCKPTR(optlen));
+				 USER_SOCKPTR(optval), OPTLEN_SOCKPTR(optlen));
 #ifdef CONFIG_NETFILTER
 	/* we need to exclude all possible ENOPROTOOPTs except default case */
 	if (err == -ENOPROTOOPT && optname != IPV6_2292PKTOPTIONS) {
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 90216d7e2af6..679ba4799c79 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -951,7 +951,7 @@ static int rawv6_seticmpfilter(struct sock *sk, int optname,
 }
 
 static int rawv6_geticmpfilter(struct sock *sk, int optname,
-			       char __user *optval, int __user *optlen)
+			       char __user *optval, optlen_t optlen)
 {
 	int len;
 
@@ -1050,7 +1050,7 @@ static int rawv6_setsockopt(struct sock *sk, int level, int optname,
 }
 
 static int do_rawv6_getsockopt(struct sock *sk, int level, int optname,
-			    char __user *optval, int __user *optlen)
+			    char __user *optval, optlen_t optlen)
 {
 	struct raw6_sock *rp = raw6_sk(sk);
 	int val, len;
@@ -1088,7 +1088,7 @@ static int do_rawv6_getsockopt(struct sock *sk, int level, int optname,
 }
 
 static int rawv6_getsockopt(struct sock *sk, int level, int optname,
-			  char __user *optval, int __user *optlen)
+			  char __user *optval, optlen_t optlen)
 {
 	switch (level) {
 	case SOL_RAW:
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 024458ef163c..861691ba88cd 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1843,7 +1843,7 @@ int udpv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 }
 
 int udpv6_getsockopt(struct sock *sk, int level, int optname,
-		     char __user *optval, int __user *optlen)
+		     char __user *optval, optlen_t optlen)
 {
 	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
 		return udp_lib_getsockopt(sk, level, optname, optval, optlen);
diff --git a/net/ipv6/udp_impl.h b/net/ipv6/udp_impl.h
index 0590f566379d..a23db3c3ca9a 100644
--- a/net/ipv6/udp_impl.h
+++ b/net/ipv6/udp_impl.h
@@ -17,7 +17,7 @@ int udp_v6_get_port(struct sock *sk, unsigned short snum);
 void udp_v6_rehash(struct sock *sk);
 
 int udpv6_getsockopt(struct sock *sk, int level, int optname,
-		     char __user *optval, int __user *optlen);
+		     char __user *optval, optlen_t optlen);
 int udpv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 		     unsigned int optlen);
 int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len);
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index ce0c68c9513c..00b6ba3f23ff 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1533,7 +1533,7 @@ static int iucv_sock_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int iucv_sock_getsockopt(struct socket *sock, int level, int optname,
-				char __user *optval, int __user *optlen)
+				char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	struct iucv_sock *iucv = iucv_sk(sk);
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 68b6a8bd0cdb..ddc46864643e 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1145,7 +1145,7 @@ static int kcm_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int kcm_getsockopt(struct socket *sock, int level, int optname,
-			  char __user *optval, int __user *optlen)
+			  char __user *optval, optlen_t optlen)
 {
 	struct kcm_sock *kcm = kcm_sk(sock->sk);
 	int val, len;
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index aa3e34ef6b5c..c9effe687625 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1332,7 +1332,7 @@ static int pppol2tp_session_getsockopt(struct sock *sk,
  * or the special tunnel type.
  */
 static int pppol2tp_getsockopt(struct socket *sock, int level, int optname,
-			       char __user *optval, int __user *optlen)
+			       char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	struct l2tp_session *session;
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index a8e5d6eb5ad1..08ac78fb2b5d 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -1170,7 +1170,7 @@ static int llc_ui_setsockopt(struct socket *sock, int level, int optname,
  *	Get connection specific socket information.
  */
 static int llc_ui_getsockopt(struct socket *sock, int level, int optname,
-			     char __user *optval, int __user *optlen)
+			     char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	struct llc_sock *llc = llc_sk(sk);
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 2cff81d47b76..ec34e4dc0642 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -327,7 +327,7 @@ static int mctp_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int mctp_getsockopt(struct socket *sock, int level, int optname,
-			   char __user *optval, int __user *optlen)
+			   char __user *optval, optlen_t optlen)
 {
 	struct mctp_sock *msk = container_of(sock->sk, struct mctp_sock, sk);
 	int len, val;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index d409586b5977..7187d7583e7c 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -862,7 +862,7 @@ bool mptcp_schedule_work(struct sock *sk);
 int mptcp_setsockopt(struct sock *sk, int level, int optname,
 		     sockptr_t optval, unsigned int optlen);
 int mptcp_getsockopt(struct sock *sk, int level, int optname,
-		     char __user *optval, int __user *option);
+		     char __user *optval, optlen_t option);
 
 u64 __mptcp_expand_seq(u64 old_seq, u64 cur_seq);
 static inline u64 mptcp_expand_seq(u64 old_seq, u64 cur_seq, bool use_64bit)
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 25b780598888..88480bbcfd39 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -906,7 +906,7 @@ int mptcp_setsockopt(struct sock *sk, int level, int optname,
 }
 
 static int mptcp_getsockopt_first_sf_only(struct mptcp_sock *msk, int level, int optname,
-					  char __user *optval, int __user *optlen)
+					  char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = (struct sock *)msk;
 	struct sock *ssk;
@@ -991,7 +991,7 @@ void mptcp_diag_fill_info(struct mptcp_sock *msk, struct mptcp_info *info)
 }
 EXPORT_SYMBOL_GPL(mptcp_diag_fill_info);
 
-static int mptcp_getsockopt_info(struct mptcp_sock *msk, char __user *optval, int __user *optlen)
+static int mptcp_getsockopt_info(struct mptcp_sock *msk, char __user *optval, optlen_t optlen)
 {
 	struct mptcp_info m_info;
 	int len;
@@ -1019,7 +1019,7 @@ static int mptcp_getsockopt_info(struct mptcp_sock *msk, char __user *optval, in
 static int mptcp_put_subflow_data(struct mptcp_subflow_data *sfd,
 				  char __user *optval,
 				  u32 copied,
-				  int __user *optlen)
+				  optlen_t optlen)
 {
 	u32 copylen = min_t(u32, sfd->size_subflow_data, sizeof(*sfd));
 
@@ -1039,7 +1039,7 @@ static int mptcp_put_subflow_data(struct mptcp_subflow_data *sfd,
 
 static int mptcp_get_subflow_data(struct mptcp_subflow_data *sfd,
 				  char __user *optval,
-				  int __user *optlen)
+				  optlen_t optlen)
 {
 	int len, copylen;
 
@@ -1076,7 +1076,7 @@ static int mptcp_get_subflow_data(struct mptcp_subflow_data *sfd,
 }
 
 static int mptcp_getsockopt_tcpinfo(struct mptcp_sock *msk, char __user *optval,
-				    int __user *optlen)
+				    optlen_t optlen)
 {
 	struct mptcp_subflow_context *subflow;
 	struct sock *sk = (struct sock *)msk;
@@ -1168,7 +1168,7 @@ static void mptcp_get_sub_addrs(const struct sock *sk, struct mptcp_subflow_addr
 }
 
 static int mptcp_getsockopt_subflow_addrs(struct mptcp_sock *msk, char __user *optval,
-					  int __user *optlen)
+					  optlen_t optlen)
 {
 	struct mptcp_subflow_context *subflow;
 	struct sock *sk = (struct sock *)msk;
@@ -1222,7 +1222,7 @@ static int mptcp_getsockopt_subflow_addrs(struct mptcp_sock *msk, char __user *o
 
 static int mptcp_get_full_info(struct mptcp_full_info *mfi,
 			       char __user *optval,
-			       int __user *optlen)
+			       optlen_t optlen)
 {
 	int len;
 
@@ -1254,7 +1254,7 @@ static int mptcp_get_full_info(struct mptcp_full_info *mfi,
 static int mptcp_put_full_info(struct mptcp_full_info *mfi,
 			       char __user *optval,
 			       u32 copylen,
-			       int __user *optlen)
+			       optlen_t optlen)
 {
 	copylen += MIN_FULL_INFO_OPTLEN_SIZE;
 	if (put_optlen(copylen, optlen))
@@ -1266,7 +1266,7 @@ static int mptcp_put_full_info(struct mptcp_full_info *mfi,
 }
 
 static int mptcp_getsockopt_full_info(struct mptcp_sock *msk, char __user *optval,
-				      int __user *optlen)
+				      optlen_t optlen)
 {
 	unsigned int sfcount = 0, copylen = 0;
 	struct mptcp_subflow_context *subflow;
@@ -1340,7 +1340,7 @@ static int mptcp_getsockopt_full_info(struct mptcp_sock *msk, char __user *optva
 }
 
 static int mptcp_put_int_option(struct mptcp_sock *msk, char __user *optval,
-				int __user *optlen, int val)
+				optlen_t optlen, int val)
 {
 	int len;
 
@@ -1369,7 +1369,7 @@ static int mptcp_put_int_option(struct mptcp_sock *msk, char __user *optval,
 }
 
 static int mptcp_getsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
-				    char __user *optval, int __user *optlen)
+				    char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = (void *)msk;
 
@@ -1412,7 +1412,7 @@ static int mptcp_getsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 }
 
 static int mptcp_getsockopt_v4(struct mptcp_sock *msk, int optname,
-			       char __user *optval, int __user *optlen)
+			       char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = (void *)msk;
 
@@ -1437,7 +1437,7 @@ static int mptcp_getsockopt_v4(struct mptcp_sock *msk, int optname,
 }
 
 static int mptcp_getsockopt_v6(struct mptcp_sock *msk, int optname,
-			       char __user *optval, int __user *optlen)
+			       char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = (void *)msk;
 
@@ -1457,7 +1457,7 @@ static int mptcp_getsockopt_v6(struct mptcp_sock *msk, int optname,
 }
 
 static int mptcp_getsockopt_sol_mptcp(struct mptcp_sock *msk, int optname,
-				      char __user *optval, int __user *optlen)
+				      char __user *optval, optlen_t optlen)
 {
 	switch (optname) {
 	case MPTCP_INFO:
@@ -1474,7 +1474,7 @@ static int mptcp_getsockopt_sol_mptcp(struct mptcp_sock *msk, int optname,
 }
 
 int mptcp_getsockopt(struct sock *sk, int level, int optname,
-		     char __user *optval, int __user *option)
+		     char __user *optval, optlen_t option)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct sock *ssk;
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 3cde0f15deed..ffb6ff92abc9 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1705,7 +1705,7 @@ static int netlink_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int netlink_getsockopt(struct socket *sock, int level, int optname,
-			      char __user *optval, int __user *optlen)
+			      char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	struct netlink_sock *nlk = nlk_sk(sk);
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 6039b5219460..21335e970f4c 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -346,7 +346,7 @@ static int nr_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int nr_getsockopt(struct socket *sock, int level, int optname,
-	char __user *optval, int __user *optlen)
+	char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	struct nr_sock *nr = nr_sk(sk);
diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 5e588640c22f..a19bd39a0329 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -302,7 +302,7 @@ static int nfc_llcp_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int nfc_llcp_getsockopt(struct socket *sock, int level, int optname,
-			       char __user *optval, int __user *optlen)
+			       char __user *optval, optlen_t optlen)
 {
 	struct nfc_llcp_local *local;
 	struct sock *sk = sock->sk;
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index f35ab96fbcad..6afa989386e4 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4103,7 +4103,7 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 }
 
 static int packet_getsockopt(struct socket *sock, int level, int optname,
-			     char __user *optval, int __user *optlen)
+			     char __user *optval, optlen_t optlen)
 {
 	int len;
 	int val, lv = sizeof(val);
diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index 78b269ddf28b..d66776ed765e 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -1063,7 +1063,7 @@ static int pep_setsockopt(struct sock *sk, int level, int optname,
 }
 
 static int pep_getsockopt(struct sock *sk, int level, int optname,
-				char __user *optval, int __user *optlen)
+				char __user *optval, optlen_t optlen)
 {
 	struct pep_sock *pn = pep_sk(sk);
 	int len, val;
diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index 3395062245c5..12bc0352ba6e 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -481,7 +481,7 @@ static int rds_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int rds_getsockopt(struct socket *sock, int level, int optname,
-			  char __user *optval, int __user *optlen)
+			  char __user *optval, optlen_t optlen)
 {
 	struct rds_sock *rs = rds_sk_to_rs(sock->sk);
 	int ret = -ENOPROTOOPT, len;
diff --git a/net/rds/info.c b/net/rds/info.c
index 1990d068f6ee..b0d594026a48 100644
--- a/net/rds/info.c
+++ b/net/rds/info.c
@@ -156,7 +156,7 @@ EXPORT_SYMBOL_GPL(rds_info_copy);
  * in the snapshot.
  */
 int rds_info_getsockopt(struct socket *sock, int optname, char __user *optval,
-			int __user *optlen)
+			optlen_t optlen)
 {
 	struct rds_info_iterator iter;
 	struct rds_info_lengths lens;
diff --git a/net/rds/info.h b/net/rds/info.h
index a069b51c4679..aa25aaeb154f 100644
--- a/net/rds/info.h
+++ b/net/rds/info.h
@@ -22,7 +22,7 @@ typedef void (*rds_info_func)(struct socket *sock, unsigned int len,
 void rds_info_register_func(int optname, rds_info_func func);
 void rds_info_deregister_func(int optname, rds_info_func func);
 int rds_info_getsockopt(struct socket *sock, int optname, char __user *optval,
-			int __user *optlen);
+			optlen_t optlen);
 void rds_info_copy(struct rds_info_iterator *iter, void *data,
 		   unsigned long bytes);
 void rds_info_iter_unmap(struct rds_info_iterator *iter);
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index a1299e9dd3e6..481279525981 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -453,7 +453,7 @@ static int rose_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int rose_getsockopt(struct socket *sock, int level, int optname,
-	char __user *optval, int __user *optlen)
+	char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	struct rose_sock *rose = rose_sk(sk);
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index a88c635888fd..0373aa629885 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -756,7 +756,7 @@ static int rxrpc_setsockopt(struct socket *sock, int level, int optname,
  * Get socket options.
  */
 static int rxrpc_getsockopt(struct socket *sock, int level, int optname,
-			    char __user *optval, int __user *_optlen)
+			    char __user *optval, optlen_t _optlen)
 {
 	int optlen;
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 5120dc7728b7..2f2f6f0058b0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1386,7 +1386,7 @@ struct compat_sctp_getaddrs_old {
 
 static int sctp_getsockopt_connectx3(struct sock *sk, int len,
 				     char __user *optval,
-				     int __user *optlen)
+				     optlen_t optlen)
 {
 	struct sctp_getaddrs_old param;
 	sctp_assoc_t assoc_id = 0;
@@ -4557,7 +4557,7 @@ static int sctp_setsockopt_probe_interval(struct sock *sk,
  * The syntax is:
  *
  *   ret = getsockopt(int sd, int level, int optname, void __user *optval,
- *                    int __user *optlen);
+ *                    optlen_t optlen);
  *   ret = setsockopt(int sd, int level, int optname, const void __user *optval,
  *                    int optlen);
  *
@@ -5412,7 +5412,7 @@ EXPORT_SYMBOL_GPL(sctp_transport_traverse_process);
  */
 static int sctp_getsockopt_sctp_status(struct sock *sk, int len,
 				       char __user *optval,
-				       int __user *optlen)
+				       optlen_t optlen)
 {
 	struct sctp_status status;
 	struct sctp_association *asoc = NULL;
@@ -5492,7 +5492,7 @@ static int sctp_getsockopt_sctp_status(struct sock *sk, int len,
  */
 static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
 					  char __user *optval,
-					  int __user *optlen)
+					  optlen_t optlen)
 {
 	struct sctp_paddrinfo pinfo;
 	struct sctp_transport *transport;
@@ -5554,7 +5554,7 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
  * instead a error will be indicated to the user.
  */
 static int sctp_getsockopt_disable_fragments(struct sock *sk, int len,
-					char __user *optval, int __user *optlen)
+					char __user *optval, optlen_t optlen)
 {
 	int val;
 
@@ -5576,7 +5576,7 @@ static int sctp_getsockopt_disable_fragments(struct sock *sk, int len,
  * ancillary data the user wishes to receive.
  */
 static int sctp_getsockopt_events(struct sock *sk, int len, char __user *optval,
-				  int __user *optlen)
+				  optlen_t optlen)
 {
 	struct sctp_event_subscribe subscribe;
 	__u8 *sn_type = (__u8 *)&subscribe;
@@ -5610,7 +5610,7 @@ static int sctp_getsockopt_events(struct sock *sk, int len, char __user *optval,
  * integer defining the number of seconds of idle time before an
  * association is closed.
  */
-static int sctp_getsockopt_autoclose(struct sock *sk, int len, char __user *optval, int __user *optlen)
+static int sctp_getsockopt_autoclose(struct sock *sk, int len, char __user *optval, optlen_t optlen)
 {
 	/* Applicable to UDP-style socket only */
 	if (sctp_style(sk, TCP))
@@ -5712,7 +5712,7 @@ static int sctp_getsockopt_peeloff_common(struct sock *sk, sctp_peeloff_arg_t *p
 	return retval;
 }
 
-static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *optval, int __user *optlen)
+static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *optval, optlen_t optlen)
 {
 	sctp_peeloff_arg_t peeloff;
 	struct file *newfile = NULL;
@@ -5746,7 +5746,7 @@ static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *optval
 }
 
 static int sctp_getsockopt_peeloff_flags(struct sock *sk, int len,
-					 char __user *optval, int __user *optlen)
+					 char __user *optval, optlen_t optlen)
 {
 	sctp_peeloff_flags_arg_t peeloff;
 	struct file *newfile = NULL;
@@ -5913,7 +5913,7 @@ static int sctp_getsockopt_peeloff_flags(struct sock *sk, int len,
  *                     IPv4- or IPv6- layer setting.
  */
 static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
-					    char __user *optval, int __user *optlen)
+					    char __user *optval, optlen_t optlen)
 {
 	struct sctp_paddrparams  params;
 	struct sctp_transport   *trans = NULL;
@@ -6057,7 +6057,7 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
  */
 static int sctp_getsockopt_delayed_ack(struct sock *sk, int len,
 					    char __user *optval,
-					    int __user *optlen)
+					    optlen_t optlen)
 {
 	struct sctp_sack_info    params;
 	struct sctp_association *asoc = NULL;
@@ -6129,7 +6129,7 @@ static int sctp_getsockopt_delayed_ack(struct sock *sk, int len,
  * by the change).  With TCP-style sockets, this option is inherited by
  * sockets derived from a listener socket.
  */
-static int sctp_getsockopt_initmsg(struct sock *sk, int len, char __user *optval, int __user *optlen)
+static int sctp_getsockopt_initmsg(struct sock *sk, int len, char __user *optval, optlen_t optlen)
 {
 	if (len < sizeof(struct sctp_initmsg))
 		return -EINVAL;
@@ -6143,7 +6143,7 @@ static int sctp_getsockopt_initmsg(struct sock *sk, int len, char __user *optval
 
 
 static int sctp_getsockopt_peer_addrs(struct sock *sk, int len,
-				      char __user *optval, int __user *optlen)
+				      char __user *optval, optlen_t optlen)
 {
 	struct sctp_association *asoc;
 	int cnt = 0;
@@ -6239,7 +6239,7 @@ static int sctp_copy_laddrs(struct sock *sk, __u16 port, void *to,
 
 
 static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
-				       char __user *optval, int __user *optlen)
+				       char __user *optval, optlen_t optlen)
 {
 	struct sctp_bind_addr *bp;
 	struct sctp_association *asoc;
@@ -6347,7 +6347,7 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
  * association peer's addresses.
  */
 static int sctp_getsockopt_primary_addr(struct sock *sk, int len,
-					char __user *optval, int __user *optlen)
+					char __user *optval, optlen_t optlen)
 {
 	struct sctp_prim prim;
 	struct sctp_association *asoc;
@@ -6389,7 +6389,7 @@ static int sctp_getsockopt_primary_addr(struct sock *sk, int len,
  * Indication parameter for all future INIT and INIT-ACK exchanges.
  */
 static int sctp_getsockopt_adaptation_layer(struct sock *sk, int len,
-				  char __user *optval, int __user *optlen)
+				  char __user *optval, optlen_t optlen)
 {
 	struct sctp_setadaptation adaptation;
 
@@ -6429,7 +6429,7 @@ static int sctp_getsockopt_adaptation_layer(struct sock *sk, int len,
  */
 static int sctp_getsockopt_default_send_param(struct sock *sk,
 					int len, char __user *optval,
-					int __user *optlen)
+					optlen_t optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
@@ -6475,7 +6475,7 @@ static int sctp_getsockopt_default_send_param(struct sock *sk,
  */
 static int sctp_getsockopt_default_sndinfo(struct sock *sk, int len,
 					   char __user *optval,
-					   int __user *optlen)
+					   optlen_t optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
@@ -6525,7 +6525,7 @@ static int sctp_getsockopt_default_sndinfo(struct sock *sk, int len,
  */
 
 static int sctp_getsockopt_nodelay(struct sock *sk, int len,
-				   char __user *optval, int __user *optlen)
+				   char __user *optval, optlen_t optlen)
 {
 	int val;
 
@@ -6555,7 +6555,7 @@ static int sctp_getsockopt_nodelay(struct sock *sk, int len,
  */
 static int sctp_getsockopt_rtoinfo(struct sock *sk, int len,
 				char __user *optval,
-				int __user *optlen) {
+				optlen_t optlen) {
 	struct sctp_rtoinfo rtoinfo;
 	struct sctp_association *asoc;
 
@@ -6609,7 +6609,7 @@ static int sctp_getsockopt_rtoinfo(struct sock *sk, int len,
  */
 static int sctp_getsockopt_associnfo(struct sock *sk, int len,
 				     char __user *optval,
-				     int __user *optlen)
+				     optlen_t optlen)
 {
 
 	struct sctp_assocparams assocparams;
@@ -6677,7 +6677,7 @@ static int sctp_getsockopt_associnfo(struct sock *sk, int len,
  * addresses on the socket.
  */
 static int sctp_getsockopt_mappedv4(struct sock *sk, int len,
-				    char __user *optval, int __user *optlen)
+				    char __user *optval, optlen_t optlen)
 {
 	int val;
 	struct sctp_sock *sp = sctp_sk(sk);
@@ -6700,7 +6700,7 @@ static int sctp_getsockopt_mappedv4(struct sock *sk, int len,
  * (chapter and verse is quoted at sctp_setsockopt_context())
  */
 static int sctp_getsockopt_context(struct sock *sk, int len,
-				   char __user *optval, int __user *optlen)
+				   char __user *optval, optlen_t optlen)
 {
 	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
@@ -6757,7 +6757,7 @@ static int sctp_getsockopt_context(struct sock *sk, int len,
  * assoc_value:  This parameter specifies the maximum size in bytes.
  */
 static int sctp_getsockopt_maxseg(struct sock *sk, int len,
-				  char __user *optval, int __user *optlen)
+				  char __user *optval, optlen_t optlen)
 {
 	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
@@ -6804,7 +6804,7 @@ static int sctp_getsockopt_maxseg(struct sock *sk, int len,
  * (chapter and verse is quoted at sctp_setsockopt_fragment_interleave())
  */
 static int sctp_getsockopt_fragment_interleave(struct sock *sk, int len,
-					       char __user *optval, int __user *optlen)
+					       char __user *optval, optlen_t optlen)
 {
 	int val;
 
@@ -6828,7 +6828,7 @@ static int sctp_getsockopt_fragment_interleave(struct sock *sk, int len,
  */
 static int sctp_getsockopt_partial_delivery_point(struct sock *sk, int len,
 						  char __user *optval,
-						  int __user *optlen)
+						  optlen_t optlen)
 {
 	u32 val;
 
@@ -6852,7 +6852,7 @@ static int sctp_getsockopt_partial_delivery_point(struct sock *sk, int len,
  */
 static int sctp_getsockopt_maxburst(struct sock *sk, int len,
 				    char __user *optval,
-				    int __user *optlen)
+				    optlen_t optlen)
 {
 	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
@@ -6891,7 +6891,7 @@ static int sctp_getsockopt_maxburst(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_hmac_ident(struct sock *sk, int len,
-				    char __user *optval, int __user *optlen)
+				    char __user *optval, optlen_t optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_hmacalgo  __user *p = (void __user *)optval;
@@ -6927,7 +6927,7 @@ static int sctp_getsockopt_hmac_ident(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_active_key(struct sock *sk, int len,
-				    char __user *optval, int __user *optlen)
+				    char __user *optval, optlen_t optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_authkeyid val;
@@ -6963,7 +6963,7 @@ static int sctp_getsockopt_active_key(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
-				    char __user *optval, int __user *optlen)
+				    char __user *optval, optlen_t optlen)
 {
 	struct sctp_authchunks __user *p = (void __user *)optval;
 	struct sctp_authchunks val;
@@ -7007,7 +7007,7 @@ static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_local_auth_chunks(struct sock *sk, int len,
-				    char __user *optval, int __user *optlen)
+				    char __user *optval, optlen_t optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_authchunks __user *p = (void __user *)optval;
@@ -7063,7 +7063,7 @@ static int sctp_getsockopt_local_auth_chunks(struct sock *sk, int len,
  * to a one-to-many style socket.  The option value is an uint32_t.
  */
 static int sctp_getsockopt_assoc_number(struct sock *sk, int len,
-				    char __user *optval, int __user *optlen)
+				    char __user *optval, optlen_t optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
@@ -7094,7 +7094,7 @@ static int sctp_getsockopt_assoc_number(struct sock *sk, int len,
  * See the corresponding setsockopt entry as description
  */
 static int sctp_getsockopt_auto_asconf(struct sock *sk, int len,
-				   char __user *optval, int __user *optlen)
+				   char __user *optval, optlen_t optlen)
 {
 	int val = 0;
 
@@ -7119,7 +7119,7 @@ static int sctp_getsockopt_auto_asconf(struct sock *sk, int len,
  * the SCTP associations handled by a one-to-many style socket.
  */
 static int sctp_getsockopt_assoc_ids(struct sock *sk, int len,
-				    char __user *optval, int __user *optlen)
+				    char __user *optval, optlen_t optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
@@ -7170,7 +7170,7 @@ static int sctp_getsockopt_assoc_ids(struct sock *sk, int len,
  */
 static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 					    char __user *optval, int len,
-					    int __user *optlen, bool v2)
+					    optlen_t optlen, bool v2)
 {
 	struct sctp_paddrthlds_v2 val;
 	struct sctp_transport *trans;
@@ -7229,7 +7229,7 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
  */
 static int sctp_getsockopt_assoc_stats(struct sock *sk, int len,
 				       char __user *optval,
-				       int __user *optlen)
+				       optlen_t optlen)
 {
 	struct sctp_assoc_stats sas;
 	struct sctp_association *asoc = NULL;
@@ -7287,7 +7287,7 @@ static int sctp_getsockopt_assoc_stats(struct sock *sk, int len,
 
 static int sctp_getsockopt_recvrcvinfo(struct sock *sk,	int len,
 				       char __user *optval,
-				       int __user *optlen)
+				       optlen_t optlen)
 {
 	int val = 0;
 
@@ -7307,7 +7307,7 @@ static int sctp_getsockopt_recvrcvinfo(struct sock *sk,	int len,
 
 static int sctp_getsockopt_recvnxtinfo(struct sock *sk,	int len,
 				       char __user *optval,
-				       int __user *optlen)
+				       optlen_t optlen)
 {
 	int val = 0;
 
@@ -7327,7 +7327,7 @@ static int sctp_getsockopt_recvnxtinfo(struct sock *sk,	int len,
 
 static int sctp_getsockopt_pr_supported(struct sock *sk, int len,
 					char __user *optval,
-					int __user *optlen)
+					optlen_t optlen)
 {
 	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
@@ -7366,7 +7366,7 @@ static int sctp_getsockopt_pr_supported(struct sock *sk, int len,
 
 static int sctp_getsockopt_default_prinfo(struct sock *sk, int len,
 					  char __user *optval,
-					  int __user *optlen)
+					  optlen_t optlen)
 {
 	struct sctp_default_prinfo info;
 	struct sctp_association *asoc;
@@ -7412,7 +7412,7 @@ static int sctp_getsockopt_default_prinfo(struct sock *sk, int len,
 
 static int sctp_getsockopt_pr_assocstatus(struct sock *sk, int len,
 					  char __user *optval,
-					  int __user *optlen)
+					  optlen_t optlen)
 {
 	struct sctp_prstatus params;
 	struct sctp_association *asoc;
@@ -7471,7 +7471,7 @@ static int sctp_getsockopt_pr_assocstatus(struct sock *sk, int len,
 
 static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
 					   char __user *optval,
-					   int __user *optlen)
+					   optlen_t optlen)
 {
 	struct sctp_stream_out_ext *streamoute;
 	struct sctp_association *asoc;
@@ -7535,7 +7535,7 @@ static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
 
 static int sctp_getsockopt_reconfig_supported(struct sock *sk, int len,
 					      char __user *optval,
-					      int __user *optlen)
+					      optlen_t optlen)
 {
 	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
@@ -7574,7 +7574,7 @@ static int sctp_getsockopt_reconfig_supported(struct sock *sk, int len,
 
 static int sctp_getsockopt_enable_strreset(struct sock *sk, int len,
 					   char __user *optval,
-					   int __user *optlen)
+					   optlen_t optlen)
 {
 	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
@@ -7613,7 +7613,7 @@ static int sctp_getsockopt_enable_strreset(struct sock *sk, int len,
 
 static int sctp_getsockopt_scheduler(struct sock *sk, int len,
 				     char __user *optval,
-				     int __user *optlen)
+				     optlen_t optlen)
 {
 	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
@@ -7652,7 +7652,7 @@ static int sctp_getsockopt_scheduler(struct sock *sk, int len,
 
 static int sctp_getsockopt_scheduler_value(struct sock *sk, int len,
 					   char __user *optval,
-					   int __user *optlen)
+					   optlen_t optlen)
 {
 	struct sctp_stream_value params;
 	struct sctp_association *asoc;
@@ -7694,7 +7694,7 @@ static int sctp_getsockopt_scheduler_value(struct sock *sk, int len,
 
 static int sctp_getsockopt_interleaving_supported(struct sock *sk, int len,
 						  char __user *optval,
-						  int __user *optlen)
+						  optlen_t optlen)
 {
 	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
@@ -7733,7 +7733,7 @@ static int sctp_getsockopt_interleaving_supported(struct sock *sk, int len,
 
 static int sctp_getsockopt_reuse_port(struct sock *sk, int len,
 				      char __user *optval,
-				      int __user *optlen)
+				      optlen_t optlen)
 {
 	int val;
 
@@ -7752,7 +7752,7 @@ static int sctp_getsockopt_reuse_port(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_event(struct sock *sk, int len, char __user *optval,
-				 int __user *optlen)
+				 optlen_t optlen)
 {
 	struct sctp_association *asoc;
 	struct sctp_event param;
@@ -7788,7 +7788,7 @@ static int sctp_getsockopt_event(struct sock *sk, int len, char __user *optval,
 
 static int sctp_getsockopt_asconf_supported(struct sock *sk, int len,
 					    char __user *optval,
-					    int __user *optlen)
+					    optlen_t optlen)
 {
 	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
@@ -7827,7 +7827,7 @@ static int sctp_getsockopt_asconf_supported(struct sock *sk, int len,
 
 static int sctp_getsockopt_auth_supported(struct sock *sk, int len,
 					  char __user *optval,
-					  int __user *optlen)
+					  optlen_t optlen)
 {
 	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
@@ -7866,7 +7866,7 @@ static int sctp_getsockopt_auth_supported(struct sock *sk, int len,
 
 static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
 					 char __user *optval,
-					 int __user *optlen)
+					 optlen_t optlen)
 {
 	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
@@ -7905,7 +7905,7 @@ static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
 
 static int sctp_getsockopt_pf_expose(struct sock *sk, int len,
 				     char __user *optval,
-				     int __user *optlen)
+				     optlen_t optlen)
 {
 	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
@@ -7943,7 +7943,7 @@ static int sctp_getsockopt_pf_expose(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_encap_port(struct sock *sk, int len,
-				      char __user *optval, int __user *optlen)
+				      char __user *optval, optlen_t optlen)
 {
 	struct sctp_association *asoc;
 	struct sctp_udpencaps encap;
@@ -8003,7 +8003,7 @@ static int sctp_getsockopt_encap_port(struct sock *sk, int len,
 
 static int sctp_getsockopt_probe_interval(struct sock *sk, int len,
 					  char __user *optval,
-					  int __user *optlen)
+					  optlen_t optlen)
 {
 	struct sctp_probeinterval params;
 	struct sctp_association *asoc;
@@ -8062,7 +8062,7 @@ static int sctp_getsockopt_probe_interval(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt(struct sock *sk, int level, int optname,
-			   char __user *optval, int __user *optlen)
+			   char __user *optval, optlen_t optlen)
 {
 	int retval = 0;
 	int len;
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 405c0bff7121..da20193e2925 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2989,7 +2989,7 @@ int smc_shutdown(struct socket *sock, int how)
 }
 
 static int __smc_getsockopt(struct socket *sock, int level, int optname,
-			    char __user *optval, int __user *optlen)
+			    char __user *optval, optlen_t optlen)
 {
 	struct smc_sock *smc;
 	int val, len;
@@ -3141,7 +3141,7 @@ int smc_setsockopt(struct socket *sock, int level, int optname,
 }
 
 int smc_getsockopt(struct socket *sock, int level, int optname,
-		   char __user *optval, int __user *optlen)
+		   char __user *optval, optlen_t optlen)
 {
 	struct smc_sock *smc;
 	int rc;
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 78ae10d06ed2..abcf01824fa8 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -59,7 +59,7 @@ int smc_shutdown(struct socket *sock, int how);
 int smc_setsockopt(struct socket *sock, int level, int optname,
 		   sockptr_t optval, unsigned int optlen);
 int smc_getsockopt(struct socket *sock, int level, int optname,
-		   char __user *optval, int __user *optlen);
+		   char __user *optval, optlen_t optlen);
 int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len);
 int smc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		int flags);
diff --git a/net/socket.c b/net/socket.c
index 9a0e720f0859..fa2de12c10e6 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2350,12 +2350,15 @@ int do_sock_getsockopt(struct socket *sock, bool compat, int level,
 	} else if (unlikely(!ops->getsockopt)) {
 		err = -EOPNOTSUPP;
 	} else {
-		if (WARN_ONCE(optval.is_kernel || optlen.is_kernel,
+		optlen_t _optlen = { .up = NULL, };
+
+		if (WARN_ONCE(optval.is_kernel,
 			      "Invalid argument type"))
 			return -EOPNOTSUPP;
 
+		_optlen.up = optlen.user;
 		err = ops->getsockopt(sock, level, optname, optval.user,
-				      optlen.user);
+				      _optlen);
 	}
 
 	if (!compat)
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 23822d9230e4..24db67f7f21a 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -3229,7 +3229,7 @@ static int tipc_setsockopt(struct socket *sock, int lvl, int opt,
  * Return: 0 on success, errno otherwise
  */
 static int tipc_getsockopt(struct socket *sock, int lvl, int opt,
-			   char __user *ov, int __user *ol)
+			   char __user *ov, optlen_t ol)
 {
 	struct sock *sk = sock->sk;
 	struct tipc_sock *tsk = tipc_sk(sk);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index f4e87b4295b4..1069c8ca5aad 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -436,7 +436,7 @@ static __poll_t tls_sk_poll(struct file *file, struct socket *sock,
 }
 
 static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
-				  int __user *optlen, int tx)
+				  optlen_t optlen, int tx)
 {
 	int rc = 0;
 	const struct tls_cipher_desc *cipher_desc;
@@ -497,7 +497,7 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 }
 
 static int do_tls_getsockopt_tx_zc(struct sock *sk, char __user *optval,
-				   int __user *optlen)
+				   optlen_t optlen)
 {
 	struct tls_context *ctx = tls_get_ctx(sk);
 	unsigned int value;
@@ -517,7 +517,7 @@ static int do_tls_getsockopt_tx_zc(struct sock *sk, char __user *optval,
 }
 
 static int do_tls_getsockopt_no_pad(struct sock *sk, char __user *optval,
-				    int __user *optlen)
+				    optlen_t optlen)
 {
 	struct tls_context *ctx = tls_get_ctx(sk);
 	int value, len;
@@ -545,7 +545,7 @@ static int do_tls_getsockopt_no_pad(struct sock *sk, char __user *optval,
 }
 
 static int do_tls_getsockopt(struct sock *sk, int optname,
-			     char __user *optval, int __user *optlen)
+			     char __user *optval, optlen_t optlen)
 {
 	int rc = 0;
 
@@ -574,7 +574,7 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 }
 
 static int tls_getsockopt(struct sock *sk, int level, int optname,
-			  char __user *optval, int __user *optlen)
+			  char __user *optval, optlen_t optlen)
 {
 	struct tls_context *ctx = tls_get_ctx(sk);
 
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index c21a3bfcdd75..5f4ff266cf5e 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1866,7 +1866,7 @@ static int vsock_connectible_setsockopt(struct socket *sock,
 static int vsock_connectible_getsockopt(struct socket *sock,
 					int level, int optname,
 					char __user *optval,
-					int __user *optlen)
+					optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	struct vsock_sock *vsk = vsock_sk(sk);
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 4eb65c05b3b9..863819103621 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -448,7 +448,7 @@ static int x25_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int x25_getsockopt(struct socket *sock, int level, int optname,
-			  char __user *optval, int __user *optlen)
+			  char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	int val, len, rc = -ENOPROTOOPT;
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 7cae6f4114b5..7b75b6217ba1 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -1461,7 +1461,7 @@ struct xdp_statistics_v1 {
 };
 
 static int xsk_getsockopt(struct socket *sock, int level, int optname,
-			  char __user *optval, int __user *optlen)
+			  char __user *optval, optlen_t optlen)
 {
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
-- 
2.34.1


