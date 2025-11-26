Return-Path: <io-uring+bounces-10811-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F64EC897A8
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 12:19:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 44A20354760
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 11:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A00002F12DF;
	Wed, 26 Nov 2025 11:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="WQIGuiAF"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1995C1A23B9;
	Wed, 26 Nov 2025 11:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764155991; cv=none; b=Bzi6NdLppUsU4ToIjWEmqWTeFCuJ1JSZfLUt+pmTxbx9fw5rMhBv8QDe8Pf6NT6kz4OzJhxkYiSr+EOsVTibvXmLQnp2y/euj+dLf8JSeKaEAwWNAZAbPfp9Zfx4MgFkqFa59CSwdNNyJOa+D8Ucm7d00tDoAZf/7AlfyS3FAwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764155991; c=relaxed/simple;
	bh=g3hn8AjbhMVAx+wCU06zKPVtYRw9XskdtyCrp63n4I4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xqapl84fCl/5H55UEELgdiE5G+rHospGMj9MG4RiG9PCXVix5Lf2LD2hUNSbuLkk/2MkhO91rjvyYedwmGxqjQKttKtt0w7N8z05GXvDbGwLyvf1F9UcXLbHwOKczTREcV4efxrJO0EYfk3FZ5tnfBSgOIdxhhHlcDwxmIFr3/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=WQIGuiAF; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=8Gw8eUmrcCieUahIupp42RD4TKbZ1gHNJBT+5hmtk8k=; b=WQIGuiAFdol8RQXtAa4GO+t2cb
	1ivw7FA3SmrTyxzaq6BkYUc78UK184SnZ4Zcld7Aar9vGoZ6I1aHYRPeWaoa2Rn3DvNLRN/tNEU6t
	wZMnfGt62MenU5XW8qgExaqNbthCGObMVFu9WcP9rmV3o3KwPcgl413PHSxihdt/fLkcZ9PRfn0+z
	wdZjq1u1Cbe8MuBYSB6eZlrQ5G0d1aSYrjsrcR2TkgHIX7/wwBG93p2EuBEpdz8yY7YOaHpl5bUpA
	aq99/BrfaI1XI0+QYNlw0NaGYsTi5zCCBzrQjj5dWq07hUBNNCi9eNGCSuRgO4Iyd5OL92wyCYLyJ
	vzu0jPSy0KvtlHsgffe7cfHmmcJUGN+ACMWtDHP/hz/lH2t+17c4RFF6LKCFBD0sBqLBrWvPDX0EK
	1nIZ9TbkORTxjaS28PHTmaPVdMRdg1mjtgHx6j6Kv68FYC3fjJwHzb+TY38+2IVu9cRMW+aFXVNBE
	gxbamThM8YgIyQHVf9jSxY40;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vODYn-00FpGv-10;
	Wed, 26 Nov 2025 11:19:45 +0000
From: Stefan Metzmacher <metze@samba.org>
To: io-uring@vger.kernel.org
Cc: metze@samba.org,
	Jens Axboe <axboe@kernel.dk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Willem de Bruijn <willemb@google.com>,
	netdev@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/net: wire up support for sk->sk_prot->uring_cmd() with SOCKET_URING_OP_PASSTHROUGH_FLAG
Date: Wed, 26 Nov 2025 12:19:31 +0100
Message-ID: <20251126111931.1788970-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will allow network protocols to implement async operations
instead of using ioctl() syscalls.

By using the high bit there's more than enough room for generic
calls to be added, but also more than enough for protocols to
implement their own specific opcodes.

The IPPROTO_SMBDIRECT socket layer [1] I'm currently working on,
will use this in future in order to let Samba use efficient RDMA offload.

[1]
https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/master-ipproto-smbdirect

Cc: Jens Axboe <axboe@kernel.dk>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>

---

This is based on for-6.19/io_uring + the 3
"Introduce getsockname io_uring_cmd" patches from
https://lore.kernel.org/io-uring/20251125211806.2673912-1-krisman@suse.de/
as the addition of SOCKET_URING_OP_GETSOCKNAME would
conflict with the addition of SOCKET_URING_OP_PASSTHROUGH_FLAG
---
 include/net/sock.h            | 4 ++++
 include/uapi/linux/io_uring.h | 7 +++++++
 io_uring/cmd_net.c            | 2 ++
 3 files changed, 13 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 60bcb13f045c..ffcee4792589 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -98,6 +98,7 @@ typedef struct {
 struct sock;
 struct proto;
 struct net;
+struct io_uring_cmd;
 
 typedef __u32 __bitwise __portpair;
 typedef __u64 __bitwise __addrpair;
@@ -1272,6 +1273,9 @@ struct proto {
 
 	int			(*ioctl)(struct sock *sk, int cmd,
 					 int *karg);
+	int			(*uring_cmd)(struct sock *sk,
+					struct io_uring_cmd *ioucmd,
+					unsigned int issue_flags);
 	int			(*init)(struct sock *sk);
 	void			(*destroy)(struct sock *sk);
 	void			(*shutdown)(struct sock *sk, int how);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b5b23c0d5283..62ce6cb7d145 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1010,6 +1010,13 @@ enum io_uring_socket_op {
 	SOCKET_URING_OP_SETSOCKOPT,
 	SOCKET_URING_OP_TX_TIMESTAMP,
 	SOCKET_URING_OP_GETSOCKNAME,
+
+	/*
+	 * This lets the sk->sk_prot->uring_cmd()
+	 * handle it, giving it enough space for
+	 * custom opcodes.
+	 */
+	SOCKET_URING_OP_PASSTHROUGH_FLAG = 0x80000000
 };
 
 /*
diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
index 5d11caf5509c..964f1764fa67 100644
--- a/io_uring/cmd_net.c
+++ b/io_uring/cmd_net.c
@@ -182,6 +182,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	case SOCKET_URING_OP_GETSOCKNAME:
 		return io_uring_cmd_getsockname(sock, cmd, issue_flags);
 	default:
+		if (cmd->cmd_op & SOCKET_URING_OP_PASSTHROUGH_FLAG && prot->uring_cmd)
+			return prot->uring_cmd(sk, cmd, issue_flags);
 		return -EOPNOTSUPP;
 	}
 }
-- 
2.43.0


