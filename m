Return-Path: <io-uring+bounces-12393-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AIc9O9dBnWkMOAQAu9opvQ
	(envelope-from <io-uring+bounces-12393-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 07:14:47 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CAFF18254A
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 07:14:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 294C33006D53
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 06:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0AA02D1F40;
	Tue, 24 Feb 2026 06:14:42 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 529B527587D;
	Tue, 24 Feb 2026 06:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771913682; cv=none; b=Vrz15TlQOvJxW2J+AfuEBjtTn+/P8DUsIqw5PtUAFSBPLFSK+/6DZ1jJkaXos/2aYcT9m7783sImKCZ52+e4v1Fh8dGZoucI+yAnQUsje6wKO0zCFxNi1mm3XETTsNWCZ6rdsO40xNghO0OREXLsKumM2jclrO2y1AQw0xtn38Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771913682; c=relaxed/simple;
	bh=iRBQGoavdPO7NfzUVF9tnbhKVfLLFFRV2iUnQhqci/w=;
	h=From:To:Cc:Subject:Date:Message-Id; b=U+Q6XoKxw3YyJQB7zzXWkKnkSEQItyQr4noBBUffp36msV4USubMjzfAqBquRoCEkHjVMl9ixvIxGcKFCx4Kzw2UC3iy8H8YBsJdDehX2UbFaMlIatJYHp+sesDUyClXWUlYgX5+5TM1LghpU83cvPaVc7U4Oi9zBLe6KyEqHaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c2dff70000001609-f2-699d41ca80b2
From: Byungchul Park <byungchul@sk.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel_team@skhynix.com,
	harry.yoo@oracle.com,
	hawk@kernel.org,
	andrew+netdev@lunn.ch,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	ziy@nvidia.com,
	willy@infradead.org,
	toke@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	asml.silence@gmail.com,
	axboe@kernel.dk,
	ncardwell@google.com,
	kuniyu@google.com,
	dsahern@kernel.org,
	almasrymina@google.com,
	sdf@fomichev.me,
	dw@davidwei.uk,
	ap420073@gmail.com,
	dtatulea@nvidia.com,
	shivajikant@google.com,
	io-uring@vger.kernel.org
Subject: [RESEND PATCH net-next] netmem: remove the pp fields from net_iov
Date: Tue, 24 Feb 2026 15:14:24 +0900
Message-Id: <20260224061424.11219-1-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRX0hTYRyG/bazc47T5WlqO1kYLMIUUotZHxGhN3WoiKAu+oPpaKd2aE7d
	nGkZWCbmIjUvZG1LZg3TTSVW6Vw6l6akLTPF0Jz/mYIsl5qmTiiXdPfwPu/7u/nhbH4FEoEz
	8ixaIRfLhCgX4f4Ifn6gJ+kZE+9wJkDzag58OWHlwLW6WRbUmxoBNI+WolD/5QECZ9+uA9hg
	K2TBZtssgHOaehS6u6YwOF49g8CWoiY2nCr9iML5wl4E9jWWcGBvRy0Km/InMDhg06NwrO4P
	B3ZraxH40NWKwC7DDrjyyQPg4FMbC1a5UmB/xxQCdfdKAPStbvZ1nWNYYiT1pnaYRX3TPEGo
	IXsPi2rWjmKUwaKiXtfEUAOfVZTFVIxSlsVyjGq2LrGoxwXzKLXg/o5QXvsgSjkNHzBqyRJ5
	LuQy95iEljHZtCLueCpXqmmtxjIs4TlzHiYfmLarQSBOEiLS2efiqAH+j4e1e/0xSkSRQ0Nr
	bD+HERHkgrUJUwMuzibqOKS904v4RShxipwbeYH6GSH2kU57JfAzj0gga0Z+srfu7yHNrxxs
	/5gkujDSpJlBtsRO8n3NEFIGggwgwAT4jDw7TczIRLHSXDmTE3stPc0CNr9VfXfjihUs9p1v
	BwQOhMG81GQ9w+eIs5W5ae2AxNnCMJ7Pp2X4PIk49zatSE9RqGS0sh3swhGhgHdo5ZaET9wQ
	Z9E3aTqDVvy3LDwwIh+Yy41nk5N1ifHhLe5J6f6Rk6K4LOPheMEjvFera7QPo+7Kd1UpX83T
	sUpMVN8NJZmOvP6N07+jnetXJ7ddXFYNCipOBJk9y6Oa6CP3XWUBDQXLYyHjxrJf0z3qpKJC
	752jemPx9Usy4xk0Tl7kaRNcCPWl2vK807uj+tscmUJEKRUfjGErlOK/BedXSqkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAwGQAm/9CAMS/QMaCGludGVybmFsIgYKBApOO4MtykGdaTCQtyc4q/h4OKfg
	uAU4+aznAjicqrYBOKvdjwY4nM+EBDjntfoBOK66hQI4ubrnATjqmK0GOOXG4gc436bmBDi8
	h7cDOOKPyAY47oXOBDjDnckFONC2jgU4zsOpBji3gOAHONO6nAY43qz/BTjJmqkEOIjcvQQ4
	xqAWOPbL7AE41Zm6Ajih3F840sPiBDibgY4BOPv4nAY4m8XeB0AfSLSp2QJI1piRBEjYvsoC
	SLma3QdIoLJ1SLOoKkjTzXVIsqqJBkiy8pIHSLm48wJIjYPuBkjx5doESO++1QZIo+jwAkjM
	oMQHSPOyHlAQWgo8ZGVsaXZlci8+YApomL2mB3CyFXjq7GmAAaoRigEICBgQNBjZmiOKAQkI
	BhAnGNjY+QOKAQkIFBAaGPG4tweKAQoIAxCsBRi+xe8EigEJCBMQShjq26MGigEJCAQQJRjM
	vp4BigEJCA0QNRio2/ADigEJCBgQHxirsMADkAEIoAEAqgEUaW52bWFpbDUuc2toeW5peC5j
	b22yAQYKBKZ9/JG4AfTTR8IBEAgBIgwNYF2caRIFYXZzeW3CARgIAyIUDfv7mmkSDWRheXpl
	cm9fcnVsZXPCARsIBCIXDUpXZWASEGdhdGVrZWVwZXJfcnVsZXPCAQIICRqAAbwOFT//J0vr
	vprO+hwacpsB34bHxpDz38gSQjamvYcNuYWeT5BXN+0pZFKqQ7AYoLQ9DCr57x/IpXo52Sho
	raOYhVFqaSxUxx2n89T/g5q0kLL6YyObh8Jn084Fwp9MRGI/ufxuUiBZoZe5ZfU7nMXk3sUV
	WO5z8Sb+kJsWN6GZIgRzaGExKgNyc2E2fR+3kAIAAA==
X-CFilter-Loop: Reflected
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.54 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12393-lists,io-uring=lfdr.de];
	DMARC_NA(0.00)[sk.com];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,kvack.org,skhynix.com,oracle.com,kernel.org,lunn.ch,suse.cz,nvidia.com,infradead.org,redhat.com,davemloft.net,google.com,gmail.com,kernel.dk,fomichev.me,davidwei.uk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.970];
	FROM_NEQ_ENVFROM(0.00)[byungchul@sk.com,io-uring@vger.kernel.org];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[31];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6CAFF18254A
X-Rspamd-Action: no action

Now that the pp fields in net_iov have no users, remove them from
net_iov and clean up.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
The original post was:

  https://lore.kernel.org/all/20251121040047.71921-1-byungchul@sk.com/

1/3 was covered by Pavel's patch:

  commit f0243d2b86b97 ("io_uring/zcrx: convert to use netmem_desc").

2/3 was taken by Jakub and merged:

  commit df59bb5b9af3f ("netmem, devmem, tcp: access pp fields through
  @desc in net_iov")

Now that io-uring and net core changes converge in one tree, I'm
resending the 3/3, which is what Jakub asked:

  https://lore.kernel.org/all/20251124184729.7e365941@kernel.org/
---
 include/net/netmem.h | 38 +-------------------------------------
 1 file changed, 1 insertion(+), 37 deletions(-)

diff --git a/include/net/netmem.h b/include/net/netmem.h
index a96b3e5e5574..a6d65ced5231 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -93,23 +93,7 @@ enum net_iov_type {
  *		supported.
  */
 struct net_iov {
-	union {
-		struct netmem_desc desc;
-
-		/* XXX: The following part should be removed once all
-		 * the references to them are converted so as to be
-		 * accessed via netmem_desc e.g. niov->desc.pp instead
-		 * of niov->pp.
-		 */
-		struct {
-			unsigned long _flags;
-			unsigned long pp_magic;
-			struct page_pool *pp;
-			unsigned long _pp_mapping_pad;
-			unsigned long dma_addr;
-			atomic_long_t pp_ref_count;
-		};
-	};
+	struct netmem_desc desc;
 	struct net_iov_area *owner;
 	enum net_iov_type type;
 };
@@ -123,26 +107,6 @@ struct net_iov_area {
 	unsigned long base_virtual;
 };
 
-/* net_iov is union'ed with struct netmem_desc mirroring struct page, so
- * the page_pool can access these fields without worrying whether the
- * underlying fields are accessed via netmem_desc or directly via
- * net_iov, until all the references to them are converted so as to be
- * accessed via netmem_desc e.g. niov->desc.pp instead of niov->pp.
- *
- * The non-net stack fields of struct page are private to the mm stack
- * and must never be mirrored to net_iov.
- */
-#define NET_IOV_ASSERT_OFFSET(desc, iov)                    \
-	static_assert(offsetof(struct netmem_desc, desc) == \
-		      offsetof(struct net_iov, iov))
-NET_IOV_ASSERT_OFFSET(_flags, _flags);
-NET_IOV_ASSERT_OFFSET(pp_magic, pp_magic);
-NET_IOV_ASSERT_OFFSET(pp, pp);
-NET_IOV_ASSERT_OFFSET(_pp_mapping_pad, _pp_mapping_pad);
-NET_IOV_ASSERT_OFFSET(dma_addr, dma_addr);
-NET_IOV_ASSERT_OFFSET(pp_ref_count, pp_ref_count);
-#undef NET_IOV_ASSERT_OFFSET
-
 static inline struct net_iov_area *net_iov_owner(const struct net_iov *niov)
 {
 	return niov->owner;
-- 
2.17.1


