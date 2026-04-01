Return-Path: <io-uring+bounces-12918-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +N0CE/hBzWkkbAYAu9opvQ
	(envelope-from <io-uring+bounces-12918-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 18:04:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5389737DA51
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 18:04:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0661A30086A8
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 15:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F2F83A9DB2;
	Wed,  1 Apr 2026 15:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="eHh2Fpxt"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9322821257B;
	Wed,  1 Apr 2026 15:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775058300; cv=none; b=CQredBvIxu0mBLH5+Miod5bJelKwY1qEsRYRJeDV6MQc7IdPKNcyB+cb3nFiFGpbDaHfr06aEhhaf5n6ENToHt+2lhyPG/crHmuR4Uwg2L1g5xzQsSt/4vvTuBMQs6TUqj26VtQTByKL/UkVIWScT2VDkBrxJf8theJH/ZOsUr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775058300; c=relaxed/simple;
	bh=A30oFn3i3XwkbKi5Z4CboB8jSWUWd5dBj/4qrotLwnM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=mymGARqSzFev28Q6y1KB74Uu4WVlaIMp6YqC0f22XS4Bh0PnPw99OGQtfWPUEI7jAh9JDTb1Kt65vqBoYsPYLT08tJV/BvOsCXlnkvXeaKHcCHdMnK+LISxV1pNeWyOxxrOg/ffR2R99uKouZVJDO00eX0PvJ3wzm+SPMJyWCiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=eHh2Fpxt; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=5QKW3/JXml+7tBXgZ6SvgOOOhlSastlScs8q9qXL1w0=; b=eHh2Fpxt4SMnhfAzFby4vBLBh7
	LXpSTC5vgOuUT42A1ISnoHyeNSB15COUsX9w90WkTg467kQQbQSR1EiXy1m3fFmuHG36T9Yqnb7e0
	gxDNe9X8CvJFkRi7V52XnnrGWqCURu/C01SYP4Jl7EplYaw99zMfABJHhvdoUOiWH5KcFVF0WJ6Gz
	5vw6JMaRy/kamz60gKx0wrZC4LSezlrBI66xegBFN4xJhl4/Swb/wizDRjnVWVeC1lXNH8sfSU5Yb
	eej6CCaUGtzteYEcKZTSG4Xq7FnMxbjVf0RGkybwel5E56uJ2L9XlTLK+bZRgBWAlKO8CojStpQSy
	rstcvzdQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7xkR-0035cG-0Y;
	Wed, 01 Apr 2026 15:44:50 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH net-next v2 0/4] net: move .getsockopt away from __user
 buffers
Date: Wed, 01 Apr 2026 08:44:25 -0700
Message-Id: <20260401-getsockopt-v2-0-611df6771aff@debian.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAFo9zWkC/22NwQ6DIBAFf4XsWRrASqKn/ofxILjotgkYoMbG+
 O+N9NrzmzdzQMJImKBjB0TcKFHw0DFVMbDL6GfkNEHHQAmlhawFnzGnYF9hzbx1tdaqQZysgYr
 BGtHRXmQ9eMzc455h+C3pbZ5o8+W62IVSDvFTupssj3+JTXLBW9ncnXVOu7Z5TGho9LcQZxjO8
 /wCmuVjNMEAAAA=
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5092; i=leitao@debian.org;
 h=from:subject:message-id; bh=A30oFn3i3XwkbKi5Z4CboB8jSWUWd5dBj/4qrotLwnM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpzT1sy5qPnN/bcUWwUiP6vHavgdHNrCVpO+Tht
 WLQaI4tNUuJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCac09bAAKCRA1o5Of/Hh3
 bXg2D/96PuNkqd5ke9E4OICZTdj+8OyhH0MWyE54+kLBsDsOj7W6Sn8D/A33N0KFjKNkc4+5uJf
 8DuEg+3ApbctxPzSDvCaKfk/NziGUniSJxCzAJQf9ZdURkMwRlDNMj7xSw+zJGBHSYjQzTNoGqE
 Dc8RODWKqsI0cr8OSgmq12DKWPFBPjTtPie/AsmcrU9ZfZJnA9Lh3Ff4UaTZC4bv46pQpRBCWS0
 2yjO1fwACpD3sE9tzrYS+x1e6Ww1nvNOUeaFago0RAej+jox1gBhtZmqqkfQFXhXnHSEof1FY8g
 oy3ztaPFrCwjeIq1x6KSNu3bW4HWindLWPrjcJHylz3tj8JkF09NFMGRmHMPNueTQihXDcKEssV
 vpz7YSkXIeRzFOf1EuLc47Nf78ZOKV6G/mJsPDdwUMJle6pjbnyl5+94iCbHBg0mBWEqZaA2ms1
 j6C9qdqtqJ6txR9c0nG5//dfdi3T+SnoxuDkERwWbr0i/07WjvCo6Zj09wH/SrbqBbWHsRGXCLV
 7p6JyS8eKPTt/zDRAawEChddkRVTShUiJhC5Z0MpZ2glWbOgZ+kWEK9LWT6WLzp6aDoJo6/qXhc
 03i0bIhspzKdNG+aLY9dlux44qwGMHxBv/Nh0iaaN5wDJW0+t99RbmN8oEZDRQSn70HFiEr75cs
 OcuypxXp+obxm3w==
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
	TAGGED_FROM(0.00)[bounces-12918-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leitao@debian.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[debian.org:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,msgid.link:url]
X-Rspamd-Queue-Id: 5389737DA51
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

Below are some questions raised during the RFC discussion:

1) Should optlen be an iov_iter as well?
  No. optlen can remain a plain kernel int since do_sock_getsockopt_iter() syncs
  it back to userspace on both success and failure. The existing callback
  patterns all work with this approach:

  a) Most callbacks (roughly 2/3) always write back optlen.

  b) Some callbacks read optlen but never update it. The original
     value is written back unchanged.

  c) CAN raw updates optlen even on error (-ERANGE) to report the
     required buffer size:

          err = -ERANGE;
          if (put_user(fsize, optlen))
                  err = -EFAULT;

     No regression, since opt.optlen is always written back to
     userspace by the wrapper.

  d) Bluetooth uses put_user() with mixed sizes (u32, u16, u8) but
     never updates optlen. Same as case (b).

2) Can callbacks change iov_iter direction mid-flight?

  Yes. Some protocols read from and then write back to optval in the same
  getsockopt call. For example, PACKET_HDRLEN reads a tpacket version from optval
  and writes back the corresponding header size.

  The converted callback handles this by temporarily flipping the iter direction,
  reverting the position, and writing back:

          case PACKET_HDRLEN:
                  // opt->iter.data_source is ITER_SOURCE;
                  if (copy_from_iter(&val, len, &opt->iter) != len)
                          return -EFAULT;
		  // unroll the bytes
                  iov_iter_revert(&opt->iter, len);
                  opt->iter.data_source = ITER_DEST;
                  // ... update val ...
                  if (copy_to_iter(&val, len, &opt->iter) != len)
                          return -EFAULT;

  The callback needs to handle two things after reading from the iter:
  reset the position with iov_iter_revert(), and flip data_source back
  to ITER_DEST before writing.

  - ITER_DEST — the iter is a destination (kernel writes to it).
		copy_to_iter() works, copy_from_iter() refuses.
  - ITER_SOURCE — the iter is a source (kernel reads from it).
		copy_from_iter() works, copy_to_iter() refuses.

3) In which case iov_iter_revert() needs to be called?

  When a callback needs to read from and then write back to the same
  buffer in a single getsockopt call. The iter advances its position on
  copy_from_iter(), so you need iov_iter_revert() to reset the position
  back to the start before you can copy_to_iter() into the same location.

  Without the revert, copy_to_iter() would write past the end of the
  buffer since the iter already advanced during the read.

4) Do we have any selftest for this change?

  Yes, I've created a commit that I am using to test it, but, I am not
  sure how useful it is rigth now, so, not appending it here.

  You can find it at
  https://github.com/leitao/linux/commit/2d9311947061f1baa43858f597dd6c54d7ccc5d2

Note: The dance regarding changes to iov_iter_revert() (2) and
opt->iter.data_source (3) is a bit fragile. It will not be a bad idea to
creaet a helper (e.g., sockopt_read_val()) would be safer to prevent
others from getting it wrong.

I am not adding it now, so, it is easier to read the bare bones of the
change and helpers can come later.

Link: https://lore.kernel.org/all/CAHk-=whmzrO-BMU=uSVXbuoLi-3tJsO=0kHj1BCPBE3F2kVhTA@mail.gmail.com/ [0]
---
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

 include/linux/net.h    | 19 +++++++++++++++++++
 net/can/raw.c          | 28 +++++++++++++---------------
 net/packet/af_packet.c | 18 ++++++++++--------
 net/socket.c           | 48 +++++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 87 insertions(+), 26 deletions(-)
---
base-commit: 2d9311947061f1baa43858f597dd6c54d7ccc5d2
change-id: 20260130-getsockopt-9f36625eedcb

Best regards,
--  
Breno Leitao <leitao@debian.org>


