Return-Path: <io-uring+bounces-7329-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 315FAA76ED0
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 22:14:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADAC43A1973
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 20:14:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EFBE21CC7C;
	Mon, 31 Mar 2025 20:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="utyKiDRo"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926B421B9C3;
	Mon, 31 Mar 2025 20:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743451961; cv=none; b=IMUkv35zvHj4pOs059AbX1WVfSbpiAe74K50dkh+2qtUjmz3JqMaPCt7tz2/UNi7yAhsB1b7nS2DG2pttaB4wysYm3+USqBObq9dyBvG7ZPq9T5DaQpkaavx6B7i1i6SZQpq1ZbjaT15lIaO75lmxveVbWyKm8PYxCZHb44a9po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743451961; c=relaxed/simple;
	bh=M2Fp7exY4cxRbGe1lOl1dPG0xLZZ+A8jahAEIaGY12s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZcE40xwRimw/hriE9nG+OyccyA6q49fXI6ktdNi4z6CWUypjbiQrQMn9mRo0YrhIg4poKwp5JRXDLJN/SgDtm05GpJwEfc4c7YpUpUy1/euGCnn4hInYe75+Fjf84TueAmxBEzCykJckicgYorJVWi3OjrBoWU0nDuFIZYnuoIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=utyKiDRo; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=F2PVnOBJYHIqIOs+UI7Bgnf84OIiQjHeCtccLCUmP1A=; b=utyKiDRouLC30Mip7B0Rdp/0UF
	lX4zlJy9xyEqAZfMk5bmwlArknGpBTZCx9x+KtkujSyR4YIfAQBtD2oDZbzN9fpOwy3+eEgciLSTl
	hQv+KJriEUECzmzS/Ypj+2bXC7ykTD0oJHESqgonh2sUlmznRNURVlDrHv8CW9JomQ3gBU+3Tb3dO
	U+55Fxx3rWiqs2FRTHh+TZn5II+ahLpdwnLNH48FsaOGBq8VUDPbqQr83p3nsYTtvUpPUM62AQUpK
	6IKiNKDUG2h9yJjz6ZEDFfOlfZjLnrD0eFEB7DLTytNriY+ER0J4TZ8EfQJFkZ5ZQLEIJCLReN0hK
	tCaSqIl2WUM5pFmE2EUGm+M/48P9v6fxAeTSHmq4ws8RvrQ4ZELgOv2GOWpGJflYZFsK6NH/8xm/H
	iy2r+DC+YRP84swgbSb91M6IpBl9WO3gBdGmN3DdCDFx5lH6EbfXY4UThQ64yw1gzAxKMRX3azfYd
	Gob0TDZg6JCGblq1aQTLbCW+;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tzLUm-007Y8E-3A;
	Mon, 31 Mar 2025 20:12:33 +0000
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
Subject: [RFC PATCH 3/4] net: pass a kernel pointer via 'optlen_t' to proto[ops].getsockopt() hooks
Date: Mon, 31 Mar 2025 22:10:55 +0200
Message-Id: <d482e207223f434f0d306d3158b2142dceac4631.1743449872.git.metze@samba.org>
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

Instead of passing the optlen as user or kernel pointer,
we only ever pass a kernel pointer and do the
translation from/to userspace in do_sock_getsockopt().

The simple solution would be to just remove the
'__user' from the int *optlen argument, but it
seems the compiler doesn't complain about
'__user' vs. without it, so instead I used
a helper struct in order to make sure everything
compiles with a typesafe change.

That together with get_optlen() and put_optlen() helper
macros make it relatively easy to review and check the
behaviour is most likely unchanged.

In order to avoid uapi changes regarding different error
code orders regarding -EFAULT, the real -EFAULT handling
is deferred to get_optlen() and put_optlen().

This allows io_uring_cmd_getsockopt() to remove the
SOL_SOCKET limitation.

Removing 'sockptr_t optlen' from existing code
is for patch for another day.

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
 include/linux/sockptr.h | 20 +++++++++++++++-----
 net/socket.c            | 31 +++++++++++++++++++++++++++++--
 2 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
index 1baf66f26f4f..06ec7fd73028 100644
--- a/include/linux/sockptr.h
+++ b/include/linux/sockptr.h
@@ -170,20 +170,25 @@ static inline int check_zeroed_sockptr(sockptr_t src, size_t offset,
 }
 
 typedef struct {
-	int __user *up;
+	int *kp;
 } optlen_t;
 
 #define __check_optlen_t(__optlen)				\
 ({								\
 	optlen_t *__ptr __maybe_unused = &__optlen; \
-	BUILD_BUG_ON(sizeof(*((__ptr)->up)) != sizeof(int));	\
+	BUILD_BUG_ON(sizeof(*((__ptr)->kp)) != sizeof(int));	\
 })
 
 #define get_optlen(__val, __optlen)				\
 ({								\
 	long __err;						\
 	__check_optlen_t(__optlen);				\
-	__err = get_user(__val, __optlen.up);			\
+	if ((__optlen).kp != NULL) {				\
+		(__val) = *((__optlen).kp);			\
+		__err = 0;					\
+	} else {						\
+		__err = -EFAULT;				\
+	}							\
 	__err;							\
 })
 
@@ -191,13 +196,18 @@ typedef struct {
 ({								\
 	long __err;						\
 	__check_optlen_t(__optlen);				\
-	__err = put_user(__val, __optlen.up);			\
+	if ((__optlen).kp != NULL) {				\
+		*((__optlen).kp) = (__val);			\
+		__err = 0;					\
+	} else {						\
+		__err = -EFAULT;				\
+	}							\
 	__err;							\
 })
 
 static inline sockptr_t OPTLEN_SOCKPTR(optlen_t optlen)
 {
-	return (sockptr_t) { .user = optlen.up, };
+	return (sockptr_t) { .kernel = optlen.kp, .is_kernel = true };
 }
 
 #endif /* _LINUX_SOCKPTR_H */
diff --git a/net/socket.c b/net/socket.c
index fa2de12c10e6..81e5c9767bbc 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2350,15 +2350,42 @@ int do_sock_getsockopt(struct socket *sock, bool compat, int level,
 	} else if (unlikely(!ops->getsockopt)) {
 		err = -EOPNOTSUPP;
 	} else {
-		optlen_t _optlen = { .up = NULL, };
+		optlen_t _optlen = { .kp = NULL, };
+		int koptlen;
 
 		if (WARN_ONCE(optval.is_kernel,
 			      "Invalid argument type"))
 			return -EOPNOTSUPP;
 
-		_optlen.up = optlen.user;
+		if (optlen.is_kernel) {
+			_optlen.kp = optlen.kernel;
+		} else if (optlen.user != NULL) {
+			/*
+			 * If optlen.user is NULL,
+			 * we pass _optlen.kp = NULL
+			 * in order to avoid breaking
+			 * any uapi for getsockopt()
+			 * implementations that ignore
+			 * the optlen pointer completely
+			 * or do any level and optname
+			 * checking before hitting a
+			 * potential -EFAULT condition.
+			 *
+			 * Also when optlen.user is not NULL,
+			 * but copy_from_sockptr() causes -EFAULT,
+			 * we'll pass optlen.kp = NULL in order
+			 * to defer a possible -EFAULT return
+			 * to the caller to get_optlen() and put_optlen().
+			 */
+			if (copy_from_sockptr(&koptlen, optlen, sizeof(koptlen)) == 0)
+				_optlen.kp = &koptlen;
+		}
 		err = ops->getsockopt(sock, level, optname, optval.user,
 				      _optlen);
+		if (err != -EFAULT && _optlen.kp == &koptlen) {
+			if (copy_to_sockptr(optlen, &koptlen, sizeof(koptlen)))
+				return -EFAULT;
+		}
 	}
 
 	if (!compat)
-- 
2.34.1


