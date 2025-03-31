Return-Path: <io-uring+bounces-7327-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12C1CA76E17
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 22:13:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D41D43AB1C9
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 20:12:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5743F21A95D;
	Mon, 31 Mar 2025 20:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="NQj/+Dfw"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E136219A86;
	Mon, 31 Mar 2025 20:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743451936; cv=none; b=pcHRRj32lgWtlCHjFHu99fgJqD/mpzVTxFy2Q/fjsgUpR5gyNbRiQdlSArrjQXGSgO0bQw77Ea0oJXRLZDnHLK2PdyZt18duCQuf2bpN/AXPK/nr6ru1S23fYvL17jghjuWQ2F+wHp11Oc58cqqL2ji4Ejy886uuxUyS+Db2n9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743451936; c=relaxed/simple;
	bh=dDnjsm5X53BOLJc3f5Jka16o9WCVtOzDP6mP3wIQvGY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GV9/OvEJdh867+wnc1SEAltWVFCNyt9DrwTMsKpwYCkAkQdvy1Ynn5PLI16JhXHaRq4wE/tPHDlN6FLsUpJSjErSRQU0vaQZPokzJ72j+4BRPSJUxG+DogVbvsBzHfXtm1O6wtj5HOqmBSxSFapGx0o1XozsYN47G1G6BSmJb0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=NQj/+Dfw; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=Td3FiJjrExi0Y1kYmHCq2ftd2Font3pOCCyP5A7L1Kk=; b=NQj/+DfwJWDFI9m4Oo6V0gmvoR
	elmI1xKYQ7A3NBaPKuMupZzx9ZxFRGItZlfiZXQc8fDshztC9QT73Y2P+aBkfeZveeS5VydwPXU7w
	J3V4c9GO8dqQ4yRUr+fr3Ax7zgmJf/QF9V9fNEfNunlWNhyZthBUUcs550JO9z3Bk3FMpfv5Aud5K
	sfPyh9RGNyruLMw1nMY/afPZ5RRtw/XB1SQF5GbqX4PK4ixX+LTafcYDqw35xNWXz72A11pnnAv2e
	y/dZY9f4BfAzzrvcTczxVSxUgwgnSvV6MKZQDhHHrwkLI3DezZaDqE8hDpN9L/vsC3FrEVO1twuo+
	oquIQ2ISl9MCrNFHdF6iH34IO5FsjMwxy8xaZwkppMBYhC4Cqc/jYmsj0I7ZbBUkN7sElQUDBhFr9
	qzSen9Jw5B0u38NtzBppiC8OU7gQ8vROPmcoR8crlNqzfE5SPYuVhEevOuUcQZCM5Yn9QmN0rBHLK
	hr8T+PCZfFdZUQblRUB6SOzg;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tzLUM-007Y6R-1T;
	Mon, 31 Mar 2025 20:12:06 +0000
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
Subject: [RFC PATCH 1/4] net: introduce get_optlen() and put_optlen() helpers
Date: Mon, 31 Mar 2025 22:10:53 +0200
Message-Id: <156e83128747b2cf7c755bffa68f2519bd255f78.1743449872.git.metze@samba.org>
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

As a first step this adds get_optlen() and put_optlen() helper
macros make it relatively easy to review and check the
behaviour is most likely unchanged, before the 'int __user *optlen'
of the low level .getsockopt() hooks will be changed into a kernel
pointer.

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
 drivers/isdn/mISDN/socket.c |   2 +-
 include/linux/sockptr.h     |  22 ++++++++
 net/atm/common.c            |   2 +-
 net/atm/svc.c               |   2 +-
 net/ax25/af_ax25.c          |   4 +-
 net/bluetooth/hci_sock.c    |   2 +-
 net/bluetooth/iso.c         |   4 +-
 net/bluetooth/l2cap_sock.c  |   4 +-
 net/bluetooth/rfcomm/sock.c |   4 +-
 net/bluetooth/sco.c         |   6 +-
 net/can/isotp.c             |   4 +-
 net/can/j1939/socket.c      |   4 +-
 net/can/raw.c               |  12 ++--
 net/dccp/ccid.c             |   2 +-
 net/dccp/ccids/ccid3.c      |   4 +-
 net/dccp/proto.c            |   6 +-
 net/ieee802154/socket.c     |   4 +-
 net/ipv4/ip_sockglue.c      |   4 +-
 net/ipv4/raw.c              |   4 +-
 net/ipv4/udp.c              |   4 +-
 net/ipv6/ipv6_sockglue.c    |   4 +-
 net/ipv6/raw.c              |   8 +--
 net/iucv/af_iucv.c          |   4 +-
 net/kcm/kcmsock.c           |   4 +-
 net/l2tp/l2tp_ppp.c         |   4 +-
 net/llc/af_llc.c            |   4 +-
 net/mctp/af_mctp.c          |   2 +-
 net/mptcp/sockopt.c         |  18 +++---
 net/netlink/af_netlink.c    |   6 +-
 net/netrom/af_netrom.c      |   4 +-
 net/nfc/llcp_sock.c         |   4 +-
 net/packet/af_packet.c      |   4 +-
 net/phonet/pep.c            |   4 +-
 net/rds/af_rds.c            |   6 +-
 net/rds/info.c              |   4 +-
 net/rose/af_rose.c          |   4 +-
 net/rxrpc/af_rxrpc.c        |   4 +-
 net/sctp/socket.c           | 108 ++++++++++++++++++------------------
 net/smc/af_smc.c            |   4 +-
 net/tipc/socket.c           |   6 +-
 net/tls/tls_main.c          |   8 +--
 net/vmw_vsock/af_vsock.c    |   4 +-
 net/x25/af_x25.c            |   4 +-
 net/xdp/xsk.c               |   8 +--
 44 files changed, 176 insertions(+), 154 deletions(-)

diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index b215b28cad7b..b750cc0dfa4a 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -438,7 +438,7 @@ static int data_sock_getsockopt(struct socket *sock, int level, int optname,
 	struct sock *sk = sock->sk;
 	int len, opt;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	if (len != sizeof(char))
diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
index 3e6c8e9d67ae..28dbc3e27374 100644
--- a/include/linux/sockptr.h
+++ b/include/linux/sockptr.h
@@ -169,4 +169,26 @@ static inline int check_zeroed_sockptr(sockptr_t src, size_t offset,
 	return memchr_inv(src.kernel + offset, 0, size) == NULL;
 }
 
+#define __check_optlen_t(__optlen)				\
+({								\
+	int __user *__ptr __maybe_unused = __optlen; 		\
+	BUILD_BUG_ON(sizeof(*(__ptr)) != sizeof(int));		\
+})
+
+#define get_optlen(__val, __optlen)				\
+({								\
+	long __err;						\
+	__check_optlen_t(__optlen);				\
+	__err = get_user(__val, __optlen);			\
+	__err;							\
+})
+
+#define put_optlen(__val, __optlen) 				\
+({								\
+	long __err;						\
+	__check_optlen_t(__optlen);				\
+	__err = put_user(__val, __optlen);			\
+	__err;							\
+})
+
 #endif /* _LINUX_SOCKPTR_H */
diff --git a/net/atm/common.c b/net/atm/common.c
index 9b75699992ff..e95371abd705 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -792,7 +792,7 @@ int vcc_getsockopt(struct socket *sock, int level, int optname,
 	struct atm_vcc *vcc;
 	int len;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 	if (__SO_LEVEL_MATCH(optname, level) && len != __SO_SIZE(optname))
 		return -EINVAL;
diff --git a/net/atm/svc.c b/net/atm/svc.c
index f8137ae693b0..a706c5f77d8e 100644
--- a/net/atm/svc.c
+++ b/net/atm/svc.c
@@ -511,7 +511,7 @@ static int svc_getsockopt(struct socket *sock, int level, int optname,
 		error = vcc_getsockopt(sock, level, optname, optval, optlen);
 		goto out;
 	}
-	if (get_user(len, optlen)) {
+	if (get_optlen(len, optlen)) {
 		error = -EFAULT;
 		goto out;
 	}
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 3ee7dba34310..b184e2cb4b50 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -728,7 +728,7 @@ static int ax25_getsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_AX25)
 		return -ENOPROTOOPT;
 
-	if (get_user(maxlen, optlen))
+	if (get_optlen(maxlen, optlen))
 		return -EFAULT;
 
 	if (maxlen < 1)
@@ -805,7 +805,7 @@ static int ax25_getsockopt(struct socket *sock, int level, int optname,
 	}
 	release_sock(sk);
 
-	if (put_user(length, optlen))
+	if (put_optlen(length, optlen))
 		return -EFAULT;
 
 	return copy_to_user(optval, valptr, length) ? -EFAULT : 0;
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 022b86797acd..4b4e476e4e7c 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -2061,7 +2061,7 @@ static int hci_sock_getsockopt_old(struct socket *sock, int level, int optname,
 
 	BT_DBG("sk %p, opt %d", sk, optname);
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	lock_sock(sk);
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 3501a991f1c6..f6624b6e5485 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1731,7 +1731,7 @@ static int iso_sock_getsockopt(struct socket *sock, int level, int optname,
 
 	BT_DBG("sk %p", sk);
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	lock_sock(sk);
@@ -1777,7 +1777,7 @@ static int iso_sock_getsockopt(struct socket *sock, int level, int optname,
 		len = min_t(unsigned int, len, base_len);
 		if (copy_to_user(optval, base, len))
 			err = -EFAULT;
-		if (put_user(len, optlen))
+		if (put_optlen(len, optlen))
 			err = -EFAULT;
 
 		break;
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 5aa55fa69594..8ae25a918fd3 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -445,7 +445,7 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 
 	BT_DBG("sk %p", sk);
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	lock_sock(sk);
@@ -570,7 +570,7 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_BLUETOOTH)
 		return -ENOPROTOOPT;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	lock_sock(sk);
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 913402806fa0..785894b79dd8 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -734,7 +734,7 @@ static int rfcomm_sock_getsockopt_old(struct socket *sock, int optname, char __u
 
 	BT_DBG("sk %p", sk);
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	lock_sock(sk);
@@ -813,7 +813,7 @@ static int rfcomm_sock_getsockopt(struct socket *sock, int level, int optname, c
 	if (level != SOL_BLUETOOTH)
 		return -ENOPROTOOPT;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	lock_sock(sk);
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 2945d27e75dc..25910eca759c 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -1047,7 +1047,7 @@ static int sco_sock_getsockopt_old(struct socket *sock, int optname,
 
 	BT_DBG("sk %p", sk);
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	lock_sock(sk);
@@ -1117,7 +1117,7 @@ static int sco_sock_getsockopt(struct socket *sock, int level, int optname,
 	if (level == SOL_SCO)
 		return sco_sock_getsockopt_old(sock, optname, optval, optlen);
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	lock_sock(sk);
@@ -1266,7 +1266,7 @@ static int sco_sock_getsockopt(struct socket *sock, int level, int optname,
 
 		lock_sock(sk);
 
-		if (!err && put_user(buf_len, optlen))
+		if (!err && put_optlen(buf_len, optlen))
 			err = -EFAULT;
 
 		break;
diff --git a/net/can/isotp.c b/net/can/isotp.c
index 1efa377f002e..aa9ab87d5e14 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1495,7 +1495,7 @@ static int isotp_getsockopt(struct socket *sock, int level, int optname,
 
 	if (level != SOL_CAN_ISOTP)
 		return -EINVAL;
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 	if (len < 0)
 		return -EINVAL;
@@ -1530,7 +1530,7 @@ static int isotp_getsockopt(struct socket *sock, int level, int optname,
 		return -ENOPROTOOPT;
 	}
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, val, len))
 		return -EFAULT;
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 17226b2341d0..b2b538528c2e 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -766,7 +766,7 @@ static int j1939_sk_getsockopt(struct socket *sock, int level, int optname,
 
 	if (level != SOL_CAN_J1939)
 		return -EINVAL;
-	if (get_user(ulen, optlen))
+	if (get_optlen(ulen, optlen))
 		return -EFAULT;
 	if (ulen < 0)
 		return -EINVAL;
@@ -793,7 +793,7 @@ static int j1939_sk_getsockopt(struct socket *sock, int level, int optname,
 	 */
 	if (len > ulen)
 		ret = -EFAULT;
-	else if (put_user(len, optlen))
+	else if (put_optlen(len, optlen))
 		ret = -EFAULT;
 	else if (copy_to_user(optval, val, len))
 		ret = -EFAULT;
diff --git a/net/can/raw.c b/net/can/raw.c
index 020f21430b1d..8d1a1626d1a4 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -762,7 +762,7 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 
 	if (level != SOL_CAN_RAW)
 		return -EINVAL;
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 	if (len < 0)
 		return -EINVAL;
@@ -779,7 +779,7 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 			if (len < fsize) {
 				/* return -ERANGE and needed space in optlen */
 				err = -ERANGE;
-				if (put_user(fsize, optlen))
+				if (put_optlen(fsize, optlen))
 					err = -EFAULT;
 			} else {
 				if (len > fsize)
@@ -793,7 +793,7 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 		release_sock(sk);
 
 		if (!err)
-			err = put_user(len, optlen);
+			err = put_optlen(len, optlen);
 		return err;
 	}
 	case CAN_RAW_ERR_FILTER:
@@ -833,7 +833,7 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 		if (len < sizeof(ro->raw_vcid_opts)) {
 			/* return -ERANGE and needed space in optlen */
 			err = -ERANGE;
-			if (put_user(sizeof(ro->raw_vcid_opts), optlen))
+			if (put_optlen(sizeof(ro->raw_vcid_opts), optlen))
 				err = -EFAULT;
 		} else {
 			if (len > sizeof(ro->raw_vcid_opts))
@@ -842,7 +842,7 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 				err = -EFAULT;
 		}
 		if (!err)
-			err = put_user(len, optlen);
+			err = put_optlen(len, optlen);
 		return err;
 	}
 	case CAN_RAW_JOIN_FILTERS:
@@ -855,7 +855,7 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 		return -ENOPROTOOPT;
 	}
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, val, len))
 		return -EFAULT;
diff --git a/net/dccp/ccid.c b/net/dccp/ccid.c
index 6beac5d348e2..6f495ffb1d60 100644
--- a/net/dccp/ccid.c
+++ b/net/dccp/ccid.c
@@ -66,7 +66,7 @@ int ccid_getsockopt_builtin_ccids(struct sock *sk, int len,
 	if (ccid_get_builtin_ccids(&ccid_array, &array_len))
 		return -ENOBUFS;
 
-	if (put_user(array_len, optlen))
+	if (put_optlen(array_len, optlen))
 		err = -EFAULT;
 	else if (len > 0 && copy_to_user(optval, ccid_array,
 					 len > array_len ? array_len : len))
diff --git a/net/dccp/ccids/ccid3.c b/net/dccp/ccids/ccid3.c
index f349d16dd8f6..648aa5270f37 100644
--- a/net/dccp/ccids/ccid3.c
+++ b/net/dccp/ccids/ccid3.c
@@ -543,7 +543,7 @@ static int ccid3_hc_tx_getsockopt(struct sock *sk, const int optname, int len,
 		return -ENOPROTOOPT;
 	}
 
-	if (put_user(len, optlen) || copy_to_user(optval, val, len))
+	if (put_optlen(len, optlen) || copy_to_user(optval, val, len))
 		return -EFAULT;
 
 	return 0;
@@ -833,7 +833,7 @@ static int ccid3_hc_rx_getsockopt(struct sock *sk, const int optname, int len,
 		return -ENOPROTOOPT;
 	}
 
-	if (put_user(len, optlen) || copy_to_user(optval, val, len))
+	if (put_optlen(len, optlen) || copy_to_user(optval, val, len))
 		return -EFAULT;
 
 	return 0;
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index fcc5c9d64f46..8d6461ef8b50 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -603,7 +603,7 @@ static int dccp_getsockopt_service(struct sock *sk, int len,
 		goto out;
 
 	err = 0;
-	if (put_user(total_len, optlen) ||
+	if (put_optlen(total_len, optlen) ||
 	    put_user(dp->dccps_service, optval) ||
 	    (sl != NULL && copy_to_user(optval + 1, sl->dccpsl_list, slen)))
 		err = -EFAULT;
@@ -618,7 +618,7 @@ static int do_dccp_getsockopt(struct sock *sk, int level, int optname,
 	struct dccp_sock *dp;
 	int val, len;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	if (len < (int)sizeof(int))
@@ -674,7 +674,7 @@ static int do_dccp_getsockopt(struct sock *sk, int level, int optname,
 	}
 
 	len = sizeof(val);
-	if (put_user(len, optlen) || copy_to_user(optval, &val, len))
+	if (put_optlen(len, optlen) || copy_to_user(optval, &val, len))
 		return -EFAULT;
 
 	return 0;
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index 18d267921bb5..cc1788853c08 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -841,7 +841,7 @@ static int dgram_getsockopt(struct sock *sk, int level, int optname,
 	if (level != SOL_IEEE802154)
 		return -EOPNOTSUPP;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	len = min_t(unsigned int, len, sizeof(int));
@@ -871,7 +871,7 @@ static int dgram_getsockopt(struct sock *sk, int level, int optname,
 		return -ENOPROTOOPT;
 	}
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &val, len))
 		return -EFAULT;
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 6d9c5c20b1c4..4d372f76b317 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1771,12 +1771,12 @@ int ip_getsockopt(struct sock *sk, int level,
 			!ip_mroute_opt(optname)) {
 		int len;
 
-		if (get_user(len, optlen))
+		if (get_optlen(len, optlen))
 			return -EFAULT;
 
 		err = nf_getsockopt(sk, PF_INET, optname, optval, &len);
 		if (err >= 0)
-			err = put_user(len, optlen);
+			err = put_optlen(len, optlen);
 		return err;
 	}
 #endif
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 6aace4d55733..89d70acdacdc 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -811,7 +811,7 @@ static int raw_geticmpfilter(struct sock *sk, char __user *optval, int __user *o
 {
 	int len, ret = -EFAULT;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		goto out;
 	ret = -EINVAL;
 	if (len < 0)
@@ -819,7 +819,7 @@ static int raw_geticmpfilter(struct sock *sk, char __user *optval, int __user *o
 	if (len > sizeof(struct icmp_filter))
 		len = sizeof(struct icmp_filter);
 	ret = -EFAULT;
-	if (put_user(len, optlen) ||
+	if (put_optlen(len, optlen) ||
 	    copy_to_user(optval, &raw_sk(sk)->filter, len))
 		goto out;
 	ret = 0;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index d0bffcfa56d8..17c3fb1acb30 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -3058,7 +3058,7 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 	struct udp_sock *up = udp_sk(sk);
 	int val, len;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	if (len < 0)
@@ -3105,7 +3105,7 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 		return -ENOPROTOOPT;
 	}
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &val, len))
 		return -EFAULT;
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 1e225e6489ea..9b1843288035 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -1487,12 +1487,12 @@ int ipv6_getsockopt(struct sock *sk, int level, int optname,
 	if (err == -ENOPROTOOPT && optname != IPV6_2292PKTOPTIONS) {
 		int len;
 
-		if (get_user(len, optlen))
+		if (get_optlen(len, optlen))
 			return -EFAULT;
 
 		err = nf_getsockopt(sk, PF_INET6, optname, optval, &len);
 		if (err >= 0)
-			err = put_user(len, optlen);
+			err = put_optlen(len, optlen);
 	}
 #endif
 	return err;
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index fda640ebd53f..90216d7e2af6 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -957,13 +957,13 @@ static int rawv6_geticmpfilter(struct sock *sk, int optname,
 
 	switch (optname) {
 	case ICMPV6_FILTER:
-		if (get_user(len, optlen))
+		if (get_optlen(len, optlen))
 			return -EFAULT;
 		if (len < 0)
 			return -EINVAL;
 		if (len > sizeof(struct icmp6_filter))
 			len = sizeof(struct icmp6_filter);
-		if (put_user(len, optlen))
+		if (put_optlen(len, optlen))
 			return -EFAULT;
 		if (copy_to_user(optval, &raw6_sk(sk)->filter, len))
 			return -EFAULT;
@@ -1055,7 +1055,7 @@ static int do_rawv6_getsockopt(struct sock *sk, int level, int optname,
 	struct raw6_sock *rp = raw6_sk(sk);
 	int val, len;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	switch (optname) {
@@ -1080,7 +1080,7 @@ static int do_rawv6_getsockopt(struct sock *sk, int level, int optname,
 
 	len = min_t(unsigned int, sizeof(int), len);
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &val, len))
 		return -EFAULT;
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index cc2b3c44bc05..ce0c68c9513c 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1543,7 +1543,7 @@ static int iucv_sock_getsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_IUCV)
 		return -ENOPROTOOPT;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	if (len < 0)
@@ -1572,7 +1572,7 @@ static int iucv_sock_getsockopt(struct socket *sock, int level, int optname,
 		return -ENOPROTOOPT;
 	}
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &val, len))
 		return -EFAULT;
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 24aec295a51c..68b6a8bd0cdb 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1153,7 +1153,7 @@ static int kcm_getsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_KCM)
 		return -ENOPROTOOPT;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	if (len < 0)
@@ -1169,7 +1169,7 @@ static int kcm_getsockopt(struct socket *sock, int level, int optname,
 		return -ENOPROTOOPT;
 	}
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &val, len))
 		return -EFAULT;
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index fc5c2fd8f34c..aa3e34ef6b5c 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1343,7 +1343,7 @@ static int pppol2tp_getsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_PPPOL2TP)
 		return -EINVAL;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	if (len < 0)
@@ -1374,7 +1374,7 @@ static int pppol2tp_getsockopt(struct socket *sock, int level, int optname,
 	}
 
 	err = -EFAULT;
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		goto end_put_sess;
 
 	if (copy_to_user((void __user *)optval, &val, len))
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 0259cde394ba..a8e5d6eb5ad1 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -1179,7 +1179,7 @@ static int llc_ui_getsockopt(struct socket *sock, int level, int optname,
 	lock_sock(sk);
 	if (unlikely(level != SOL_LLC))
 		goto out;
-	rc = get_user(len, optlen);
+	rc = get_optlen(len, optlen);
 	if (rc)
 		goto out;
 	rc = -EINVAL;
@@ -1210,7 +1210,7 @@ static int llc_ui_getsockopt(struct socket *sock, int level, int optname,
 		goto out;
 	}
 	rc = 0;
-	if (put_user(len, optlen) || copy_to_user(optval, &val, len))
+	if (put_optlen(len, optlen) || copy_to_user(optval, &val, len))
 		rc = -EFAULT;
 out:
 	release_sock(sk);
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index f6de136008f6..2cff81d47b76 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -335,7 +335,7 @@ static int mctp_getsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_MCTP)
 		return -EINVAL;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	if (optname == MCTP_OPT_ADDR_EXT) {
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 3caa0a9d3b38..25b780598888 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -996,7 +996,7 @@ static int mptcp_getsockopt_info(struct mptcp_sock *msk, char __user *optval, in
 	struct mptcp_info m_info;
 	int len;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	/* When used only to check if a fallback to TCP happened. */
@@ -1007,7 +1007,7 @@ static int mptcp_getsockopt_info(struct mptcp_sock *msk, char __user *optval, in
 
 	mptcp_diag_fill_info(msk, &m_info);
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 
 	if (copy_to_user(optval, &m_info, len))
@@ -1028,7 +1028,7 @@ static int mptcp_put_subflow_data(struct mptcp_subflow_data *sfd,
 	else
 		copied = copylen;
 
-	if (put_user(copied, optlen))
+	if (put_optlen(copied, optlen))
 		return -EFAULT;
 
 	if (copy_to_user(optval, sfd, copylen))
@@ -1043,7 +1043,7 @@ static int mptcp_get_subflow_data(struct mptcp_subflow_data *sfd,
 {
 	int len, copylen;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	/* if mptcp_subflow_data size is changed, need to adjust
@@ -1229,7 +1229,7 @@ static int mptcp_get_full_info(struct mptcp_full_info *mfi,
 	BUILD_BUG_ON(offsetof(struct mptcp_full_info, mptcp_info) !=
 		     MIN_FULL_INFO_OPTLEN_SIZE);
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	if (len < MIN_FULL_INFO_OPTLEN_SIZE)
@@ -1257,7 +1257,7 @@ static int mptcp_put_full_info(struct mptcp_full_info *mfi,
 			       int __user *optlen)
 {
 	copylen += MIN_FULL_INFO_OPTLEN_SIZE;
-	if (put_user(copylen, optlen))
+	if (put_optlen(copylen, optlen))
 		return -EFAULT;
 
 	if (copy_to_user(optval, mfi, copylen))
@@ -1344,7 +1344,7 @@ static int mptcp_put_int_option(struct mptcp_sock *msk, char __user *optval,
 {
 	int len;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 	if (len < 0)
 		return -EINVAL;
@@ -1353,13 +1353,13 @@ static int mptcp_put_int_option(struct mptcp_sock *msk, char __user *optval,
 		unsigned char ucval = (unsigned char)val;
 
 		len = 1;
-		if (put_user(len, optlen))
+		if (put_optlen(len, optlen))
 			return -EFAULT;
 		if (copy_to_user(optval, &ucval, 1))
 			return -EFAULT;
 	} else {
 		len = min_t(unsigned int, len, sizeof(int));
-		if (put_user(len, optlen))
+		if (put_optlen(len, optlen))
 			return -EFAULT;
 		if (copy_to_user(optval, &val, len))
 			return -EFAULT;
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index e8972a857e51..3cde0f15deed 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1715,7 +1715,7 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_NETLINK)
 		return -ENOPROTOOPT;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 	if (len < 0)
 		return -EINVAL;
@@ -1746,7 +1746,7 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
 				break;
 			}
 		}
-		if (put_user(ALIGN(BITS_TO_BYTES(nlk->ngroups), sizeof(u32)), optlen))
+		if (put_optlen(ALIGN(BITS_TO_BYTES(nlk->ngroups), sizeof(u32)), optlen))
 			err = -EFAULT;
 		netlink_unlock_table();
 		return err;
@@ -1773,7 +1773,7 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
 	len = sizeof(int);
 	val = test_bit(flag, &nlk->flags);
 
-	if (put_user(len, optlen) ||
+	if (put_optlen(len, optlen) ||
 	    copy_to_user(optval, &val, len))
 		return -EFAULT;
 
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 6ee148f0e6d0..6039b5219460 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -356,7 +356,7 @@ static int nr_getsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_NETROM)
 		return -ENOPROTOOPT;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	if (len < 0)
@@ -389,7 +389,7 @@ static int nr_getsockopt(struct socket *sock, int level, int optname,
 
 	len = min_t(unsigned int, len, sizeof(int));
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 
 	return copy_to_user(optval, &val, len) ? -EFAULT : 0;
diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 57a2f97004e1..5e588640c22f 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -316,7 +316,7 @@ static int nfc_llcp_getsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_NFC)
 		return -ENOPROTOOPT;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	local = llcp_sock->local;
@@ -372,7 +372,7 @@ static int nfc_llcp_getsockopt(struct socket *sock, int level, int optname,
 
 	release_sock(sk);
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 
 	return err;
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 3e9ddf72cd03..f35ab96fbcad 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4117,7 +4117,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_PACKET)
 		return -ENOPROTOOPT;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	if (len < 0)
@@ -4223,7 +4223,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 
 	if (len > lv)
 		len = lv;
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, data, len))
 		return -EFAULT;
diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index 53a858478e22..78b269ddf28b 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -1070,7 +1070,7 @@ static int pep_getsockopt(struct sock *sk, int level, int optname,
 
 	if (level != SOL_PNPIPE)
 		return -ENOPROTOOPT;
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	switch (optname) {
@@ -1097,7 +1097,7 @@ static int pep_getsockopt(struct sock *sk, int level, int optname,
 	}
 
 	len = min_t(unsigned int, sizeof(int), len);
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (put_user(val, (int __user *) optval))
 		return -EFAULT;
diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index 8435a20968ef..3395062245c5 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -490,7 +490,7 @@ static int rds_getsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_RDS)
 		goto out;
 
-	if (get_user(len, optlen)) {
+	if (get_optlen(len, optlen)) {
 		ret = -EFAULT;
 		goto out;
 	}
@@ -506,7 +506,7 @@ static int rds_getsockopt(struct socket *sock, int level, int optname,
 			ret = -EINVAL;
 		else
 		if (put_user(rs->rs_recverr, (int __user *) optval) ||
-		    put_user(sizeof(int), optlen))
+		    put_optlen(sizeof(int), optlen))
 			ret = -EFAULT;
 		else
 			ret = 0;
@@ -519,7 +519,7 @@ static int rds_getsockopt(struct socket *sock, int level, int optname,
 		trans = (rs->rs_transport ? rs->rs_transport->t_type :
 			 RDS_TRANS_NONE); /* unbound */
 		if (put_user(trans, (int __user *)optval) ||
-		    put_user(sizeof(int), optlen))
+		    put_optlen(sizeof(int), optlen))
 			ret = -EFAULT;
 		else
 			ret = 0;
diff --git a/net/rds/info.c b/net/rds/info.c
index b6b46a8214a0..1990d068f6ee 100644
--- a/net/rds/info.c
+++ b/net/rds/info.c
@@ -168,7 +168,7 @@ int rds_info_getsockopt(struct socket *sock, int optname, char __user *optval,
 	int len;
 	int total;
 
-	if (get_user(len, optlen)) {
+	if (get_optlen(len, optlen)) {
 		ret = -EFAULT;
 		goto out;
 	}
@@ -230,7 +230,7 @@ int rds_info_getsockopt(struct socket *sock, int optname, char __user *optval,
 		ret = lens.each;
 	}
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		ret = -EFAULT;
 
 out:
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index a4a668b88a8f..a1299e9dd3e6 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -463,7 +463,7 @@ static int rose_getsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_ROSE)
 		return -ENOPROTOOPT;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	if (len < 0)
@@ -504,7 +504,7 @@ static int rose_getsockopt(struct socket *sock, int level, int optname,
 
 	len = min_t(unsigned int, len, sizeof(int));
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 
 	return copy_to_user(optval, &val, len) ? -EFAULT : 0;
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 86873399f7d5..a88c635888fd 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -763,7 +763,7 @@ static int rxrpc_getsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_RXRPC)
 		return -EOPNOTSUPP;
 
-	if (get_user(optlen, _optlen))
+	if (get_optlen(optlen, _optlen))
 		return -EFAULT;
 
 	switch (optname) {
@@ -771,7 +771,7 @@ static int rxrpc_getsockopt(struct socket *sock, int level, int optname,
 		if (optlen < sizeof(int))
 			return -ETOOSMALL;
 		if (put_user(RXRPC__SUPPORTED - 1, (int __user *)optval) ||
-		    put_user(sizeof(int), _optlen))
+		    put_optlen(sizeof(int), _optlen))
 			return -EFAULT;
 		return 0;
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 36ee34f483d7..5120dc7728b7 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1423,7 +1423,7 @@ static int sctp_getsockopt_connectx3(struct sock *sk, int len,
 	if (err == 0 || err == -EINPROGRESS) {
 		if (copy_to_user(optval, &assoc_id, sizeof(assoc_id)))
 			return -EFAULT;
-		if (put_user(sizeof(assoc_id), optlen))
+		if (put_optlen(sizeof(assoc_id), optlen))
 			return -EFAULT;
 	}
 
@@ -5464,7 +5464,7 @@ static int sctp_getsockopt_sctp_status(struct sock *sk, int len,
 	if (status.sstat_primary.spinfo_state == SCTP_UNKNOWN)
 		status.sstat_primary.spinfo_state = SCTP_ACTIVE;
 
-	if (put_user(len, optlen)) {
+	if (put_optlen(len, optlen)) {
 		retval = -EFAULT;
 		goto out;
 	}
@@ -5532,7 +5532,7 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
 	if (pinfo.spinfo_state == SCTP_UNKNOWN)
 		pinfo.spinfo_state = SCTP_ACTIVE;
 
-	if (put_user(len, optlen)) {
+	if (put_optlen(len, optlen)) {
 		retval = -EFAULT;
 		goto out;
 	}
@@ -5563,7 +5563,7 @@ static int sctp_getsockopt_disable_fragments(struct sock *sk, int len,
 
 	len = sizeof(int);
 	val = (sctp_sk(sk)->disable_fragments == 1);
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &val, len))
 		return -EFAULT;
@@ -5586,7 +5586,7 @@ static int sctp_getsockopt_events(struct sock *sk, int len, char __user *optval,
 		return -EINVAL;
 	if (len > sizeof(struct sctp_event_subscribe))
 		len = sizeof(struct sctp_event_subscribe);
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 
 	for (i = 0; i < len; i++)
@@ -5618,7 +5618,7 @@ static int sctp_getsockopt_autoclose(struct sock *sk, int len, char __user *optv
 	if (len < sizeof(int))
 		return -EINVAL;
 	len = sizeof(int);
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (put_user(sctp_sk(sk)->autoclose, (int __user *)optval))
 		return -EFAULT;
@@ -5729,7 +5729,7 @@ static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *optval
 		goto out;
 
 	/* Return the fd mapped to the new socket.  */
-	if (put_user(len, optlen)) {
+	if (put_optlen(len, optlen)) {
 		fput(newfile);
 		put_unused_fd(retval);
 		return -EFAULT;
@@ -5764,7 +5764,7 @@ static int sctp_getsockopt_peeloff_flags(struct sock *sk, int len,
 		goto out;
 
 	/* Return the fd mapped to the new socket.  */
-	if (put_user(len, optlen)) {
+	if (put_optlen(len, optlen)) {
 		fput(newfile);
 		put_unused_fd(retval);
 		return -EFAULT;
@@ -6014,7 +6014,7 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
 	if (copy_to_user(optval, &params, len))
 		return -EFAULT;
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 
 	return 0;
@@ -6112,7 +6112,7 @@ static int sctp_getsockopt_delayed_ack(struct sock *sk, int len,
 	if (copy_to_user(optval, &params, len))
 		return -EFAULT;
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 
 	return 0;
@@ -6134,7 +6134,7 @@ static int sctp_getsockopt_initmsg(struct sock *sk, int len, char __user *optval
 	if (len < sizeof(struct sctp_initmsg))
 		return -EINVAL;
 	len = sizeof(struct sctp_initmsg);
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &sctp_sk(sk)->initmsg, len))
 		return -EFAULT;
@@ -6187,7 +6187,7 @@ static int sctp_getsockopt_peer_addrs(struct sock *sk, int len,
 	if (put_user(cnt, &((struct sctp_getaddrs __user *)optval)->addr_num))
 		return -EFAULT;
 	bytes_copied = ((char __user *)to) - optval;
-	if (put_user(bytes_copied, optlen))
+	if (put_optlen(bytes_copied, optlen))
 		return -EFAULT;
 
 	return 0;
@@ -6333,7 +6333,7 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 	/* XXX: We should have accounted for sizeof(struct sctp_getaddrs) too,
 	 * but we can't change it anymore.
 	 */
-	if (put_user(bytes_copied, optlen))
+	if (put_optlen(bytes_copied, optlen))
 		err = -EFAULT;
 out:
 	kfree(addrs);
@@ -6374,7 +6374,7 @@ static int sctp_getsockopt_primary_addr(struct sock *sk, int len,
 	sctp_get_pf_specific(sk->sk_family)->addr_to_user(sp,
 			(union sctp_addr *)&prim.ssp_addr);
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &prim, len))
 		return -EFAULT;
@@ -6400,7 +6400,7 @@ static int sctp_getsockopt_adaptation_layer(struct sock *sk, int len,
 
 	adaptation.ssb_adaptation_ind = sctp_sk(sk)->adaptation_ind;
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &adaptation, len))
 		return -EFAULT;
@@ -6462,7 +6462,7 @@ static int sctp_getsockopt_default_send_param(struct sock *sk,
 		info.sinfo_timetolive = sp->default_timetolive;
 	}
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &info, len))
 		return -EFAULT;
@@ -6506,7 +6506,7 @@ static int sctp_getsockopt_default_sndinfo(struct sock *sk, int len,
 		info.snd_context = sp->default_context;
 	}
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &info, len))
 		return -EFAULT;
@@ -6534,7 +6534,7 @@ static int sctp_getsockopt_nodelay(struct sock *sk, int len,
 
 	len = sizeof(int);
 	val = (sctp_sk(sk)->nodelay == 1);
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &val, len))
 		return -EFAULT;
@@ -6587,7 +6587,7 @@ static int sctp_getsockopt_rtoinfo(struct sock *sk, int len,
 		rtoinfo.srto_min = sp->rtoinfo.srto_min;
 	}
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 
 	if (copy_to_user(optval, &rtoinfo, len))
@@ -6657,7 +6657,7 @@ static int sctp_getsockopt_associnfo(struct sock *sk, int len,
 					sasoc_number_peer_destinations;
 	}
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 
 	if (copy_to_user(optval, &assocparams, len))
@@ -6687,7 +6687,7 @@ static int sctp_getsockopt_mappedv4(struct sock *sk, int len,
 
 	len = sizeof(int);
 	val = sp->v4mapped;
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &val, len))
 		return -EFAULT;
@@ -6721,7 +6721,7 @@ static int sctp_getsockopt_context(struct sock *sk, int len,
 	params.assoc_value = asoc ? asoc->default_rcv_context
 				  : sctp_sk(sk)->default_rcv_context;
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &params, len))
 		return -EFAULT;
@@ -6786,7 +6786,7 @@ static int sctp_getsockopt_maxseg(struct sock *sk, int len,
 	else
 		params.assoc_value = sctp_sk(sk)->user_frag;
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (len == sizeof(int)) {
 		if (copy_to_user(optval, &params.assoc_value, len))
@@ -6814,7 +6814,7 @@ static int sctp_getsockopt_fragment_interleave(struct sock *sk, int len,
 	len = sizeof(int);
 
 	val = sctp_sk(sk)->frag_interleave;
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &val, len))
 		return -EFAULT;
@@ -6838,7 +6838,7 @@ static int sctp_getsockopt_partial_delivery_point(struct sock *sk, int len,
 	len = sizeof(u32);
 
 	val = sctp_sk(sk)->pd_point;
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &val, len))
 		return -EFAULT;
@@ -6913,7 +6913,7 @@ static int sctp_getsockopt_hmac_ident(struct sock *sk, int len,
 	len = sizeof(struct sctp_hmacalgo) + data_len;
 	num_idents = data_len / sizeof(u16);
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (put_user(num_idents, &p->shmac_num_idents))
 		return -EFAULT;
@@ -6954,7 +6954,7 @@ static int sctp_getsockopt_active_key(struct sock *sk, int len,
 		val.scact_keynumber = ep->active_key_id;
 	}
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &val, len))
 		return -EFAULT;
@@ -6999,7 +6999,7 @@ static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
 		return -EFAULT;
 num:
 	len = sizeof(struct sctp_authchunks) + num_chunks;
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (put_user(num_chunks, &p->gauth_number_of_chunks))
 		return -EFAULT;
@@ -7049,7 +7049,7 @@ static int sctp_getsockopt_local_auth_chunks(struct sock *sk, int len,
 		return -EFAULT;
 num:
 	len = sizeof(struct sctp_authchunks) + num_chunks;
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (put_user(num_chunks, &p->gauth_number_of_chunks))
 		return -EFAULT;
@@ -7081,7 +7081,7 @@ static int sctp_getsockopt_assoc_number(struct sock *sk, int len,
 		val++;
 	}
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &val, len))
 		return -EFAULT;
@@ -7104,7 +7104,7 @@ static int sctp_getsockopt_auto_asconf(struct sock *sk, int len,
 	len = sizeof(int);
 	if (sctp_sk(sk)->do_auto_asconf && sctp_is_ep_boundall(sk))
 		val = 1;
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &val, len))
 		return -EFAULT;
@@ -7152,7 +7152,7 @@ static int sctp_getsockopt_assoc_ids(struct sock *sk, int len,
 		ids->gaids_assoc_id[num++] = asoc->assoc_id;
 	}
 
-	if (put_user(len, optlen) || copy_to_user(optval, ids, len)) {
+	if (put_optlen(len, optlen) || copy_to_user(optval, ids, len)) {
 		kfree(ids);
 		return -EFAULT;
 	}
@@ -7215,7 +7215,7 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 	}
 
 out:
-	if (put_user(len, optlen) || copy_to_user(optval, &val, len))
+	if (put_optlen(len, optlen) || copy_to_user(optval, &val, len))
 		return -EFAULT;
 
 	return 0;
@@ -7274,7 +7274,7 @@ static int sctp_getsockopt_assoc_stats(struct sock *sk, int len,
 	/* Mark beginning of a new observation period */
 	asoc->stats.max_obs_rto = asoc->rto_min;
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 
 	pr_debug("%s: len:%d, assoc_id:%d\n", __func__, len, sas.sas_assoc_id);
@@ -7297,7 +7297,7 @@ static int sctp_getsockopt_recvrcvinfo(struct sock *sk,	int len,
 	len = sizeof(int);
 	if (sctp_sk(sk)->recvrcvinfo)
 		val = 1;
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &val, len))
 		return -EFAULT;
@@ -7317,7 +7317,7 @@ static int sctp_getsockopt_recvnxtinfo(struct sock *sk,	int len,
 	len = sizeof(int);
 	if (sctp_sk(sk)->recvnxtinfo)
 		val = 1;
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &val, len))
 		return -EFAULT;
@@ -7352,7 +7352,7 @@ static int sctp_getsockopt_pr_supported(struct sock *sk, int len,
 	params.assoc_value = asoc ? asoc->peer.prsctp_capable
 				  : sctp_sk(sk)->ep->prsctp_enable;
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		goto out;
 
 	if (copy_to_user(optval, &params, len))
@@ -7398,7 +7398,7 @@ static int sctp_getsockopt_default_prinfo(struct sock *sk, int len,
 		info.pr_value = sp->default_timetolive;
 	}
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		goto out;
 
 	if (copy_to_user(optval, &info, len))
@@ -7453,7 +7453,7 @@ static int sctp_getsockopt_pr_assocstatus(struct sock *sk, int len,
 			asoc->abandoned_sent[__SCTP_PR_INDEX(policy)];
 	}
 
-	if (put_user(len, optlen)) {
+	if (put_optlen(len, optlen)) {
 		retval = -EFAULT;
 		goto out;
 	}
@@ -7522,7 +7522,7 @@ static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
 			streamoute->abandoned_sent[__SCTP_PR_INDEX(policy)];
 	}
 
-	if (put_user(len, optlen) || copy_to_user(optval, &params, len)) {
+	if (put_optlen(len, optlen) || copy_to_user(optval, &params, len)) {
 		retval = -EFAULT;
 		goto out;
 	}
@@ -7560,7 +7560,7 @@ static int sctp_getsockopt_reconfig_supported(struct sock *sk, int len,
 	params.assoc_value = asoc ? asoc->peer.reconf_capable
 				  : sctp_sk(sk)->ep->reconf_enable;
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		goto out;
 
 	if (copy_to_user(optval, &params, len))
@@ -7599,7 +7599,7 @@ static int sctp_getsockopt_enable_strreset(struct sock *sk, int len,
 	params.assoc_value = asoc ? asoc->strreset_enable
 				  : sctp_sk(sk)->ep->strreset_enable;
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		goto out;
 
 	if (copy_to_user(optval, &params, len))
@@ -7638,7 +7638,7 @@ static int sctp_getsockopt_scheduler(struct sock *sk, int len,
 	params.assoc_value = asoc ? sctp_sched_get_sched(asoc)
 				  : sctp_sk(sk)->default_ss;
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		goto out;
 
 	if (copy_to_user(optval, &params, len))
@@ -7678,7 +7678,7 @@ static int sctp_getsockopt_scheduler_value(struct sock *sk, int len,
 	if (retval)
 		goto out;
 
-	if (put_user(len, optlen)) {
+	if (put_optlen(len, optlen)) {
 		retval = -EFAULT;
 		goto out;
 	}
@@ -7719,7 +7719,7 @@ static int sctp_getsockopt_interleaving_supported(struct sock *sk, int len,
 	params.assoc_value = asoc ? asoc->peer.intl_capable
 				  : sctp_sk(sk)->ep->intl_enable;
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		goto out;
 
 	if (copy_to_user(optval, &params, len))
@@ -7742,7 +7742,7 @@ static int sctp_getsockopt_reuse_port(struct sock *sk, int len,
 
 	len = sizeof(int);
 	val = sctp_sk(sk)->reuse;
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 
 	if (copy_to_user(optval, &val, len))
@@ -7777,7 +7777,7 @@ static int sctp_getsockopt_event(struct sock *sk, int len, char __user *optval,
 	subscribe = asoc ? asoc->subscribe : sctp_sk(sk)->subscribe;
 	param.se_on = sctp_ulpevent_type_enabled(subscribe, param.se_type);
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 
 	if (copy_to_user(optval, &param, len))
@@ -7813,7 +7813,7 @@ static int sctp_getsockopt_asconf_supported(struct sock *sk, int len,
 	params.assoc_value = asoc ? asoc->peer.asconf_capable
 				  : sctp_sk(sk)->ep->asconf_enable;
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		goto out;
 
 	if (copy_to_user(optval, &params, len))
@@ -7852,7 +7852,7 @@ static int sctp_getsockopt_auth_supported(struct sock *sk, int len,
 	params.assoc_value = asoc ? asoc->peer.auth_capable
 				  : sctp_sk(sk)->ep->auth_enable;
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		goto out;
 
 	if (copy_to_user(optval, &params, len))
@@ -7891,7 +7891,7 @@ static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
 	params.assoc_value = asoc ? asoc->peer.ecn_capable
 				  : sctp_sk(sk)->ep->ecn_enable;
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		goto out;
 
 	if (copy_to_user(optval, &params, len))
@@ -7930,7 +7930,7 @@ static int sctp_getsockopt_pf_expose(struct sock *sk, int len,
 	params.assoc_value = asoc ? asoc->pf_expose
 				  : sctp_sk(sk)->pf_expose;
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		goto out;
 
 	if (copy_to_user(optval, &params, len))
@@ -7995,7 +7995,7 @@ static int sctp_getsockopt_encap_port(struct sock *sk, int len,
 	if (copy_to_user(optval, &encap, len))
 		return -EFAULT;
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 
 	return 0;
@@ -8055,7 +8055,7 @@ static int sctp_getsockopt_probe_interval(struct sock *sk, int len,
 	if (copy_to_user(optval, &params, len))
 		return -EFAULT;
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 
 	return 0;
@@ -8082,7 +8082,7 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 		return retval;
 	}
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	if (len < 0)
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 3e6cb35baf25..405c0bff7121 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2996,7 +2996,7 @@ static int __smc_getsockopt(struct socket *sock, int level, int optname,
 
 	smc = smc_sk(sock->sk);
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	len = min_t(int, len, sizeof(int));
@@ -3012,7 +3012,7 @@ static int __smc_getsockopt(struct socket *sock, int level, int optname,
 		return -EOPNOTSUPP;
 	}
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &val, len))
 		return -EFAULT;
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 65dcbb54f55d..23822d9230e4 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -3239,10 +3239,10 @@ static int tipc_getsockopt(struct socket *sock, int lvl, int opt,
 	int res;
 
 	if ((lvl == IPPROTO_TCP) && (sock->type == SOCK_STREAM))
-		return put_user(0, ol);
+		return put_optlen(0, ol);
 	if (lvl != SOL_TIPC)
 		return -ENOPROTOOPT;
-	res = get_user(len, ol);
+	res = get_optlen(len, ol);
 	if (res)
 		return res;
 
@@ -3292,7 +3292,7 @@ static int tipc_getsockopt(struct socket *sock, int lvl, int opt,
 	if (copy_to_user(ov, &value, sizeof(value)))
 		return -EFAULT;
 
-	return put_user(sizeof(value), ol);
+	return put_optlen(sizeof(value), ol);
 }
 
 static int tipc_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index cb86b0bf9a53..f4e87b4295b4 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -445,7 +445,7 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 	struct cipher_context *cctx;
 	int len;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	if (!optval || (len < sizeof(*crypto_info))) {
@@ -503,7 +503,7 @@ static int do_tls_getsockopt_tx_zc(struct sock *sk, char __user *optval,
 	unsigned int value;
 	int len;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	if (len != sizeof(value))
@@ -525,7 +525,7 @@ static int do_tls_getsockopt_no_pad(struct sock *sk, char __user *optval,
 	if (ctx->prot_info.version != TLS_1_3_VERSION)
 		return -EINVAL;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 	if (len < sizeof(value))
 		return -EINVAL;
@@ -536,7 +536,7 @@ static int do_tls_getsockopt_no_pad(struct sock *sk, char __user *optval,
 	if (value < 0)
 		return value;
 
-	if (put_user(sizeof(value), optlen))
+	if (put_optlen(sizeof(value), optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &value, sizeof(value)))
 		return -EFAULT;
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 7e3db87ae433..c21a3bfcdd75 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1884,7 +1884,7 @@ static int vsock_connectible_getsockopt(struct socket *sock,
 	if (level != AF_VSOCK)
 		return -ENOPROTOOPT;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 
 	memset(&v, 0, sizeof(v));
@@ -1919,7 +1919,7 @@ static int vsock_connectible_getsockopt(struct socket *sock,
 	if (copy_to_user(optval, &v, len))
 		return -EFAULT;
 
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		return -EFAULT;
 
 	return 0;
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 8dda4178497c..4eb65c05b3b9 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -457,7 +457,7 @@ static int x25_getsockopt(struct socket *sock, int level, int optname,
 		goto out;
 
 	rc = -EFAULT;
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		goto out;
 
 	rc = -EINVAL;
@@ -467,7 +467,7 @@ static int x25_getsockopt(struct socket *sock, int level, int optname,
 	len = min_t(unsigned int, len, sizeof(int));
 
 	rc = -EFAULT;
-	if (put_user(len, optlen))
+	if (put_optlen(len, optlen))
 		goto out;
 
 	val = test_bit(X25_Q_BIT_FLAG, &x25_sk(sk)->flags);
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index e5d104ce7b82..7cae6f4114b5 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -1470,7 +1470,7 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_XDP)
 		return -ENOPROTOOPT;
 
-	if (get_user(len, optlen))
+	if (get_optlen(len, optlen))
 		return -EFAULT;
 	if (len < 0)
 		return -EINVAL;
@@ -1507,7 +1507,7 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
 
 		if (copy_to_user(optval, &stats, stats_size))
 			return -EFAULT;
-		if (put_user(stats_size, optlen))
+		if (put_optlen(stats_size, optlen))
 			return -EFAULT;
 
 		return 0;
@@ -1559,7 +1559,7 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
 
 		if (copy_to_user(optval, to_copy, len))
 			return -EFAULT;
-		if (put_user(len, optlen))
+		if (put_optlen(len, optlen))
 			return -EFAULT;
 
 		return 0;
@@ -1579,7 +1579,7 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
 		len = sizeof(opts);
 		if (copy_to_user(optval, &opts, len))
 			return -EFAULT;
-		if (put_user(len, optlen))
+		if (put_optlen(len, optlen))
 			return -EFAULT;
 
 		return 0;
-- 
2.34.1


