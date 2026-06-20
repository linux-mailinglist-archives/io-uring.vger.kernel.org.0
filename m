Return-Path: <io-uring+bounces-13798-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id k9qMJrQvNmqz8QYAu9opvQ
	(envelope-from <io-uring+bounces-13798-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 20 Jun 2026 08:14:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D07526A8658
	for <lists+io-uring@lfdr.de>; Sat, 20 Jun 2026 08:14:11 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=proton.me header.s=protonmail header.b=huSlxRdn;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13798-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13798-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=proton.me;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 42CCF302D099
	for <lists+io-uring@lfdr.de>; Sat, 20 Jun 2026 06:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2121371D08;
	Sat, 20 Jun 2026 06:14:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-24429.protonmail.ch (mail-24429.protonmail.ch [109.224.244.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EBB2BDC32
	for <io-uring@vger.kernel.org>; Sat, 20 Jun 2026 06:14:03 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781936048; cv=none; b=iUZxk5bf+m6v/vFXS7XtSxSAvxH98YfPIZj/00hgUXohNSXiCAXeoCQvYVCGoYJPsU0UPSVln4I4q17gCiZMBivgox2S0a457aECcp0q0eLHis8c3fqze++QUbFyuTyW0Be77t5wGjbLrwNf6Okx5nyd0deFYoo5goUN0zuWhDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781936048; c=relaxed/simple;
	bh=yUiQwt/pxdNTjCrzt4OD0KcA0Oib1tCa907x9vaNgy0=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=mSA4gL+cp/Muxff+t2st3GHFvOp9eelToCBKgZ429tcVwKSwJU+dtx1643jnqDY8y5XeBf5vupzNq2em6Ndo3H1wU+cc3+61bcHMeX8Nq4t7+PceaIZFZEFB+bOAWIQtA54R1M1qJWnReGMuLok3sd5JrDwxr9zMK/TFu9Ait0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=huSlxRdn; arc=none smtp.client-ip=109.224.244.29
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1781936036; x=1782195236;
	bh=yUiQwt/pxdNTjCrzt4OD0KcA0Oib1tCa907x9vaNgy0=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=huSlxRdnkqD8nHeGkA66cUMWiowQnOerqJRbMeMy+6Yp8w3jdu/tYMHhdLVhSL+BW
	 G36hmsZi6LK/mGpuT7qUzgaSLJxOJnAGiRa42+RYXK33OxeweHl6pWvkuBBeqoT1NI
	 /+mR6XnJKQiU+nDwaNOCf6uq/ejg+FjlH3nVevcmPSNpeUnXI7FsznVl/Xc4e76tUN
	 Tmw+rSm4sbOph20hXLgTsFw23b3aB0qCXlD4PmE0t9klp6RpA00+v9LInIpNCjwiFE
	 GmTXSRveJJC1G2R0URDp2QkuQjcRm7EOmUdbOXV9jOaZcUYfvQdaop9MNDoIvK7fDK
	 o0sE83NwzjHIw==
Date: Sat, 20 Jun 2026 06:13:50 +0000
To: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
From: Cyber_black <Cyberblackk@proton.me>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "gabriel@krisman.be" <gabriel@krisman.be>
Subject: [BUG] io_uring: possible CQE32 overflow flush inconsistency in __io_cqring_overflow_flush()
Message-ID: <Zurr63tEcYPbtU0ltI3-1KdtzFeys4ybMi-njjblykGD6LnMs7gYFwRzZNw3AbjYglMSO8LESxjUPHLnV2-AXHNa_17pDLHe9eCKTXBozLE=@proton.me>
Feedback-ID: 117998405:user:proton
X-Pm-Message-ID: 590ac41afe365612470efc6e1cb4b6b859dc335a
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[proton.me,quarantine];
	R_DKIM_ALLOW(-0.20)[proton.me:s=protonmail];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13798-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:axboe@kernel.dk,m:stable@vger.kernel.org,m:gregkh@linuxfoundation.org,m:gabriel@krisman.be,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER(0.00)[Cyberblackk@proton.me,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_ALL(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Cyberblackk@proton.me,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[proton.me:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D07526A8658



Hi Gabriel,

Thank you for your response.

I found this bug while doing independent research. I was reading the Linux =
kernel code from Linus Torvalds' main repository (git.kernel.org) and the i=
o_uring subsystem caught my attention. In particular, the use of shared mem=
ory for optimization purposes stood out =E2=80=93 especially since this ver=
y feature has been exploited in the past to develop rootkits targeting io_u=
ring.

So I first studied its architecture and then read the code in depth. The bu=
g emerged during that review.

Regarding a trigger scenario (PoC =E2=80=93 Proof of Concept): unfortunatel=
y, I don't have one. My system does not support io_uring (it returns ENOSYS=
, likely due to enterprise compatibility settings), so I couldn't run the l=
iburing test suite. However, the fix itself is straightforward and the logi=
c is clear.

As for the target version: this issue exists in the mainline kernel. It is =
not in a stable release yet, as I found it directly in Linus' main tree.

Regarding the patch format =E2=80=93 I just generated a clean patch using g=
it format-patch and sent it separately


