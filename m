Return-Path: <io-uring+bounces-7326-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14E1FA76E03
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 22:12:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A7923AAEB9
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 20:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC58021ABDE;
	Mon, 31 Mar 2025 20:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="VGP/0nn0"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0618121A440;
	Mon, 31 Mar 2025 20:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743451920; cv=none; b=m6Ejhv54mUWB2pg4Z0nn+meOZ5I2R2gn2NV1UbeiJWNm+vTzrLK/1cdfWp7BV6129LPWqF8gS5gmYfjsTAbOVvknEfnB8hmpGB8zLanTnDGAiT2FBT5d0qK84s5kQq+NJkC8HAhYXYWcDCjwqW07ZrhfsynCC+F3suMbuL66naI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743451920; c=relaxed/simple;
	bh=RNzXqslmQzT7+IeMpXEothGKbg0DnGRbDCZvHNoZApM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=OyZ4Nk6sEjgOLsIDAirxICpeduYwrcLQ9kKVO2dRGgT79zntqE17szRlkL8BfxoTBtRkMWYA5qJcqW5jcWm8KCViI5DtisoErlUWOAowmAHp656KyFHE8h+HhNYNvAJCoWJ8TjV8hd00G1qiWp+rLpMD59w8fj4z0YSVhN8rlEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=VGP/0nn0; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=ISfSMCAgKp8z55PiQhU0z6kwdG7zxeB+WY0nWqLYJPA=; b=VGP/0nn0y1hq6UZZ2Xgtb/aRCs
	b5dAxvYVE0vpLGixgXlJlDtn2SYHFl5m6kw6cdmrGgWYnVoxi+Q+6LQlvu7ezsvwdUqe7nCreq7Rb
	65w9Ccui3mmYFh2hsx0NWTRw0bECxoj8ol1mr7dmQIe6lZfd2b9krDed7thG+VJl3/0QOj04fhid5
	IulmHBJ24fLweRBGqNH1CkehpVbY61FQx0Xf2QNMa1gyo4f206+f+wHSPNrdnUljwqo4cuSzD7sGl
	vqgvLVJ72lG6qWQ4FP54CfAVHBYWjkbvKKycUYcvJ/C/N56w86Kri7QVQmJlokcodtPI51IOEe7/S
	n4yXvakpmRTnYwvgnXgXuznjLeG/teaA/Ici/DZJi2yYqTXruujvSSluQd0AaYTZ3aNtDWAa+x1iy
	n40hAdCLrl6bFwMBodJKjr5uFXD1AgYkGcPvxiFCuYFpaHJpRHj/lkwDPo6VL1Vzzih1pWdiVVNj/
	yp6JlSH7/NlXybuT+tXxYkpk;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tzLTx-007Y5c-0g;
	Mon, 31 Mar 2025 20:11:41 +0000
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
Subject: [RFC PATCH 0/4] net/io_uring: pass a kernel pointer via optlen_t to proto[_ops].getsockopt()
Date: Mon, 31 Mar 2025 22:10:52 +0200
Message-Id: <cover.1743449872.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
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
passes a kernel pointer as optlen to do_sock_getsockopt()
and can't reach the ops->getsockopt() path.

The first idea would be to change the optval and optlen arguments
to the protocol specific hooks also to sockptr_t, as that
is already used for setsockopt() and also by do_sock_getsockopt()
sk_getsockopt() and BPF_CGROUP_RUN_PROG_GETSOCKOPT().

But as Linus don't like 'sockptr_t' I used a different approach.

@Linus, would that optlen_t approach fit better for you?

Instead of passing the optlen as user or kernel pointer,
we only ever pass a kernel pointer and do the
translation from/to userspace in do_sock_getsockopt().

The simple solution would be to just remove the
'__user' from the int *optlen argument, but it
seems the compiler doesn't complain about
'__user' vs. without it, so instead I used
a helper struct in order to make sure everything
compiles with a typesafe change.

The patchset does the transformation in 3
easy to review steps:

1/4: introduces get_optlen(len, optlen) and put_optlen(len, optlen) helpers
     on top of the existing get_user(len, optlen) and put_user(len, optlen)
     usages.

2/4: introduces a simple optlen_t that just contains 'int __user *up;'
     that makes sure get_optlen and put_optlen get a typesafe optlen argument
     and they are the only functions looking at optlen.
     (The existing sockptr_t optlen code gets OPTLEN_SOCKPTR(optlen) passed)

3/4: The changes do_sock_getsockopt() to pass a kernel pointer instead
     of a __user pointer via optlen_t. This is a bit tricky as
     directly failing the copy_from_sockptr(&koptlen, optlen, sizeof(koptlen)
     with -EFAULT might change the uapi, as some getsockopt() hooks
     doesn't even touch optlen at all. And userspace could do something
     like this:

        feature_x_supported = true;
        ret = getsockopt(fd, level, optname, NULL, NULL);
        if (ret == -1 && errno == ENOTSUPP) {
            feature_x_supported = false;
        }

     And this should not give -EFAULT after the changes,
     so optlen.kp is passed down as NULL, so that -EFAULT is
     deferred to get_optlen() and put_optlen().

4/4: Removes the SOL_SOCKET restriction for io-uring.

This patchset doesn't touch any existing getsockopt() that
was already converted to sockptr_t optlen, that's something
for a later cleanup.

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

Stefan Metzmacher (4):
  net: introduce get_optlen() and put_optlen() helpers
  net: pass 'optlen_t' to proto[ops].getsockopt() hooks
  net: pass a kernel pointer via 'optlen_t' to proto[ops].getsockopt()
    hooks
  io_uring: let io_uring_cmd_getsockopt() allow level other than
    SOL_SOCKET

 drivers/isdn/mISDN/socket.c                   |   4 +-
 .../chelsio/inline_crypto/chtls/chtls_main.c  |   4 +-
 include/linux/net.h                           |   2 +-
 include/linux/sockptr.h                       |  41 ++++
 include/net/inet_connection_sock.h            |   2 +-
 include/net/ip.h                              |   2 +-
 include/net/ipv6.h                            |   2 +-
 include/net/sctp/structs.h                    |   2 +-
 include/net/sock.h                            |   4 +-
 include/net/tcp.h                             |   2 +-
 include/net/udp.h                             |   2 +-
 io_uring/uring_cmd.c                          |   3 -
 net/atm/common.c                              |   4 +-
 net/atm/common.h                              |   2 +-
 net/atm/pvc.c                                 |   2 +-
 net/atm/svc.c                                 |   4 +-
 net/ax25/af_ax25.c                            |   6 +-
 net/bluetooth/hci_sock.c                      |   6 +-
 net/bluetooth/iso.c                           |   6 +-
 net/bluetooth/l2cap_sock.c                    |   8 +-
 net/bluetooth/rfcomm/sock.c                   |   8 +-
 net/bluetooth/sco.c                           |  10 +-
 net/can/isotp.c                               |   6 +-
 net/can/j1939/socket.c                        |   6 +-
 net/can/raw.c                                 |  14 +-
 net/core/sock.c                               |   2 +-
 net/dccp/ccid.c                               |   4 +-
 net/dccp/ccid.h                               |  10 +-
 net/dccp/ccids/ccid3.c                        |   8 +-
 net/dccp/dccp.h                               |   2 +-
 net/dccp/proto.c                              |  12 +-
 net/ieee802154/socket.c                       |   8 +-
 net/ipv4/ip_sockglue.c                        |   8 +-
 net/ipv4/raw.c                                |  10 +-
 net/ipv4/tcp.c                                |   4 +-
 net/ipv4/udp.c                                |   8 +-
 net/ipv4/udp_impl.h                           |   2 +-
 net/ipv6/ipv6_sockglue.c                      |   8 +-
 net/ipv6/raw.c                                |  14 +-
 net/ipv6/udp.c                                |   2 +-
 net/ipv6/udp_impl.h                           |   2 +-
 net/iucv/af_iucv.c                            |   6 +-
 net/kcm/kcmsock.c                             |   6 +-
 net/l2tp/l2tp_ppp.c                           |   6 +-
 net/llc/af_llc.c                              |   6 +-
 net/mctp/af_mctp.c                            |   4 +-
 net/mptcp/protocol.h                          |   2 +-
 net/mptcp/sockopt.c                           |  48 ++--
 net/netlink/af_netlink.c                      |   8 +-
 net/netrom/af_netrom.c                        |   6 +-
 net/nfc/llcp_sock.c                           |   6 +-
 net/packet/af_packet.c                        |   6 +-
 net/phonet/pep.c                              |   6 +-
 net/rds/af_rds.c                              |   8 +-
 net/rds/info.c                                |   6 +-
 net/rds/info.h                                |   2 +-
 net/rose/af_rose.c                            |   6 +-
 net/rxrpc/af_rxrpc.c                          |   6 +-
 net/sctp/socket.c                             | 220 +++++++++---------
 net/smc/af_smc.c                              |   8 +-
 net/smc/smc.h                                 |   2 +-
 net/socket.c                                  |  34 ++-
 net/tipc/socket.c                             |   8 +-
 net/tls/tls_main.c                            |  18 +-
 net/vmw_vsock/af_vsock.c                      |   6 +-
 net/x25/af_x25.c                              |   6 +-
 net/xdp/xsk.c                                 |  10 +-
 67 files changed, 387 insertions(+), 319 deletions(-)

-- 
2.34.1


