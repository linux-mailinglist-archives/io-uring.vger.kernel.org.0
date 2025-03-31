Return-Path: <io-uring+bounces-7330-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCCEDA76EDF
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 22:15:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D65A3AB4C6
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 20:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ACDA21A928;
	Mon, 31 Mar 2025 20:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Xak0cnp3"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CA221A43B;
	Mon, 31 Mar 2025 20:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743451974; cv=none; b=nBAO4jZROEXUGTIc3sOsgmY22N6fhzOz4ceL9OK6LMOW6YMU6vsz52lg/qAba4JCzBLNR3SR3Xd23mN1qfEPCoUrvBc4Ep6zPWzUYZgpGMK9hR7k7s0FPhiT4DNbQw6M3jYTU+3tPHuqsyPq692yaA6QPdC2oSz/4v38WGgXdHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743451974; c=relaxed/simple;
	bh=lvZ73xzz3mMkJwAURa9e3ydTBqQTchnZWwnxcU8/e2g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hhfm8zsbolBQSWPKHcIBq0cWmcze9816XLKuQTyfyCwrG+tWwDTBpM/EE91HeOo5ULTyZSPyZIcLuQhhiDF7JHXmR3M6fkV0BlIiR4qJMzjdQjuk8yVKJRLKaGQRs393KH4TmV52a8SaXTqatKmG055HxfWzbttmc6dH9KSNxxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Xak0cnp3; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=+UPgsoYyuTHoMpsEKfJbS83mget/Pt2RmairKSJfS28=; b=Xak0cnp3eC8vOcjRAmxhSzY8or
	2ms51j9kwZ1j9gIgrhniOYdwKhaCSLkvMAzSsB13j5fW24Fn9N4r0G7o+JLiV4Jim2ehU9QMjLI/x
	MT1xKsKlR048ZocTScVzlgzGvLIn86CkVMKH+3vlZd8IVmXEl1AtfZJmysQ/w1i5/w1s1EDLVd2EU
	lmqtgGDBeVOMHtDw3AH38UOjan0N79BO8U3ne3Y6gpiRU9WwuNUpelZlVKnzxv4g0hnoLKJOV7yds
	VUQ3iGNNMyE1r1ujQccxBuvwnA6ubRqR+LTje4X0ZZjlBuJ4YQEmbPxfE2LAjlzZ+0T53syP9/Ds9
	w8gMyZ6VWeVNfn2lt+dc3VKBYUAl98jEsFqoe+OYds4YpSjRk9iNBvGnWXbNlmJDWcln+mLRk75WB
	FO0XUUIsIiNT/TqLX8q+GxomIf5bbiv/WLO3mQnFCgN74NWzI7vElK7sMVqnIlGxQCsxx1OksawWH
	wFYOTpCl6/Ns2jtL/6xPHTZv;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tzLUy-007Y96-2f;
	Mon, 31 Mar 2025 20:12:45 +0000
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
Subject: [RFC PATCH 4/4] io_uring: let io_uring_cmd_getsockopt() allow level other than SOL_SOCKET
Date: Mon, 31 Mar 2025 22:10:56 +0200
Message-Id: <330de91a48996e6dc5cdc844b74fb17fb933326c.1743449872.git.metze@samba.org>
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

do_sock_getsockopt() works with a kernel pointer for optlen now.

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
 io_uring/uring_cmd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index f2cfc371f3d0..8b0cc919a60c 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -312,9 +312,6 @@ static inline int io_uring_cmd_getsockopt(struct socket *sock,
 	void __user *optval;
 
 	level = READ_ONCE(cmd->sqe->level);
-	if (level != SOL_SOCKET)
-		return -EOPNOTSUPP;
-
 	optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
 	optname = READ_ONCE(cmd->sqe->optname);
 	optlen = READ_ONCE(cmd->sqe->optlen);
-- 
2.34.1


