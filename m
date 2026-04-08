Return-Path: <io-uring+bounces-12984-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2FjkHIMu1mkUBggAu9opvQ
	(envelope-from <io-uring+bounces-12984-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 12:31:31 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D1633BA8C5
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 12:31:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B9D993006D71
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 10:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FAE537F731;
	Wed,  8 Apr 2026 10:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="al6WyMBb"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA4037F8C1;
	Wed,  8 Apr 2026 10:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775644264; cv=none; b=BTC0SJn4lwEefuvJhDO00IrxzDvawL3mET+u1d52r+zuuUO6YmEeCtLYwr3mU2DGVZEuzp3/vOUd6pLA+lfeX7lnGMRFnLWtAXsNA6twsDNGdCaQfwkPLki0JIft7dyTkcRLhLc5ibjwkvKd+SWOgywe6aDaOjPCUvUfPvXHr5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775644264; c=relaxed/simple;
	bh=M6Z/Tdn7c7BqgfjwYfWVJYYwcQOst/cUM26rwVzEQLY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=KMWDKAWewNhiRdKnSXbkbvgjF46FfVAkPO1RldwPyssjHUr4nj/o+a81smfbxfzRx/y+LywwyrdaG3/Unc+2cSymligQrqQ3HkjPYIK4Xyb7k6H2sRF42N41UZc1TRtx2oUfdlMEUx0bid7u6rzIkRA/rhTBGfY2a1v2xOUZ1Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=al6WyMBb; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=2MF/al0VTf9Ca3kEu1gxRwO+cPEDevyh3csaP1pb6Q8=; b=al6WyMBbDmeCd4XwTRGacm29yD
	mBVjM2DbKZREB6PnxRcTD6Cv7NupnzhFdAx8ZNF+4SuBtmGIeQHsku+7+FshzIFQ1gOoYQ4p0pSZ9
	RBZwggtl+ooPM+IxBaw/sRxFfMm+GSV2EaBO2VQqkpPcprjF9TgsiqPpU8WaYT4YIZ9Mo8xIiyNNs
	Ze0Q2um90kXD3IO2SAimeLM6WgK2HXPsai+bIl7pkkkiPjWs5gtpxb8tsmruuJCn4rloxEIiADeVs
	1qboJQhSBoniHc5bQC+4LFEs2S/y1zNunvlUegAJJGbzFFYXWK7uYRwGIn0amLJM5HBIeYWHeSAYV
	muAfxaUg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wAQBH-008MD8-0b;
	Wed, 08 Apr 2026 10:30:44 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH net-next v3 0/4] net: move .getsockopt away from __user
 buffers
Date: Wed, 08 Apr 2026 03:30:28 -0700
Message-Id: <20260408-getsockopt-v3-0-061bb9cb355d@debian.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEQu1mkC/22NwQqDMBAFfyXs2ZQkakRP/Y/Sg8ZdTQuJJKlYx
 H8v2kMRen5vZlaIGCxGaNgKAWcbrXfQsDxjYMbWDchtDw0DJZQWMhd8wBS9efop8ZpyrVWJ2Js
 OMgZTQLLLIbuBw8QdLgnu3yW+ugeatLv272hj8uF9dGd5EP8Ss+SC17IsyBBpqstrj51t3cWH4
 TDP6scWQp5YxQXXUvakq0q2RCd227YP8znjUv0AAAA=
X-Change-ID: 20260130-getsockopt-9f36625eedcb
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Kuniyuki Iwashima <kuniyu@google.com>, 
 Willem de Bruijn <willemb@google.com>, metze@samba.org, axboe@kernel.dk, 
 Stanislav Fomichev <sdf@fomichev.me>
Cc: io-uring@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org, 
 Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=2592; i=leitao@debian.org;
 h=from:subject:message-id; bh=M6Z/Tdn7c7BqgfjwYfWVJYYwcQOst/cUM26rwVzEQLY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp1i5NB4KxGFOCospvSlH1oOL4casp2Cq1n2ERt
 zqcV7+ImDCJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCadYuTQAKCRA1o5Of/Hh3
 bfnREACMaTWL2KWmbRV8tUAqgEqg+U6UCZGINrli5yngBc0+ellIauUpYvegPq0cfPpPYVTBYp0
 bf4QDbSYXfuv9cJFWEAEMg9PR4QJ1ItTt8y+xbuVQdd9o7YpvCXd/MWMwnQC1ibaSHyfO50pbGM
 FpbZBJTEhVIm+I4bnRqR3HhHP7Rb1xecQqMkh9xVAI4RlRb9Km42nDeHeAjz1Pt1tANKH53CCat
 7KlYs2FGo+ynwze2rfue4m1agtkKf+Nmbr37I/elMiNgYnFTDp9AKwTtXPFVJuF1xYPiqNsoVuY
 m66iKnSDQMZ458ZtmT5zcGStuwJx3Gz0uVt3K0+6V6pjk4lRmmA5r8DV1DUhFhCiIY8x+9N8ZYX
 dwq1P9vMFtAA402121JI115gOVrQAezWwX24YxoSbWo4k8SmFxBSBRY6KbsIFTFEUKIlQ4AW7mQ
 Oa4Fisz84Ydxe68db0NPSC6C2GsP5rsOQYtAL8298Zb6ovZZAKJLdzLNvI0q/vhV0muUHxIk7VM
 sfjQMf2PigYiwoUc9BhiFh7OqlUxoaKcuXxQkdlmctq3ZioYijnF4t/QW+vDwNOF/N2bGok9Aud
 tmHoYLWVbNHNcmakgl3A6AD9juho0AlpfEAlOrcrj0pSRlHDxGCXG8aEGSD/UmtX/siU6gn5wDh
 S50PTlS6+NbUKaA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[debian.org:s=smtpauto.stravinsky];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[debian.org];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12984-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leitao@debian.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[debian.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[msgid.link:url,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8D1633BA8C5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Currently, the .getsockopt callback requires __user pointers:

  int (*getsockopt)(struct socket *sock, int level,
                    int optname, char __user *optval, int __user *optlen);

This prevents kernel callers (io_uring, BPF) from using getsockopt on
levels other than SOL_SOCKET, since they pass kernel pointers.

Following Linus' suggestion [0], this series introduces sockopt_t, a
type-safe wrapper around iov_iter, and a getsockopt_iter callback that
works with both user and kernel buffers. AF_PACKET and CAN raw are
converted as initial users, with selftests covering the trickiest
conversion patterns.

[0] https://lore.kernel.org/all/CAHk-=whmzrO-BMU=uSVXbuoLi-3tJsO=0kHj1BCPBE3F2kVhTA@mail.gmail.com/

Updates from v2 to v3:

* Use two iov in sockopt_t instead of a single one:
  a) .iter_in that is populated by the caller and will be read-only in
  the protocols callback.

  b) .iter_out will be populated by the protocol and it will be sent
  back to the caller.

  - This will avoid changing the protocol reset and changing the data
    source at the callback, making the driver callback implementation
    and converstion saner.

* created sockptr_to_sockopt() to convert sockptr to sockopt, making the
  call to getsockopt_iter straight-forward

Link: https://lore.kernel.org/all/CAHk-=whmzrO-BMU=uSVXbuoLi-3tJsO=0kHj1BCPBE3F2kVhTA@mail.gmail.com/ [0]
---
Changes in v3:
- Create Two iov in sockopt_t instead of a single one (Stanislav Fomichev)
- Implement the sockptr_to_sockopt() helper (Stanislav Fomichev)
- Link to v2: https://patch.msgid.link/20260401-getsockopt-v2-0-611df6771aff@debian.org

Changes in v2:
- Restore optlen even on error path (getsockopt_iter fails)
- Move af_packet.c and can instead of netlink (given these are the most
  complicate ones).
- Link to v1: https://patch.msgid.link/20260130-getsockopt-v1-0-9154fcff6f95@debian.org

---
Breno Leitao (4):
      net: add getsockopt_iter callback to proto_ops
      net: call getsockopt_iter if available
      af_packet: convert to getsockopt_iter
      can: raw: convert to getsockopt_iter

 include/linux/net.h    | 23 +++++++++++++++++++++
 net/can/raw.c          | 28 ++++++++++++--------------
 net/packet/af_packet.c | 15 +++++++-------
 net/socket.c           | 54 +++++++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 94 insertions(+), 26 deletions(-)
---
base-commit: 9c14d60a50c4b726a3613a02e8b74778e9964891
change-id: 20260130-getsockopt-9f36625eedcb

Best regards,
--  
Breno Leitao <leitao@debian.org>


