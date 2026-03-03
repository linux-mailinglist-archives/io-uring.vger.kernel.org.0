Return-Path: <io-uring+bounces-12536-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EHOHGKIwpmkrLwAAu9opvQ
	(envelope-from <io-uring+bounces-12536-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Mar 2026 01:51:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E17401E7673
	for <lists+io-uring@lfdr.de>; Tue, 03 Mar 2026 01:51:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 043153062961
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2026 00:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D641F192E;
	Tue,  3 Mar 2026 00:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pBFc12q4"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02D0213E9C;
	Tue,  3 Mar 2026 00:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498898; cv=none; b=CnJwR6SVrq2aBOTFcDQndTR2pMCepkeS1RZz5evaMhycIHItRWZW5jVpBIovls8n9FVkfPceBM/AV6YbuEG3Dao1iBEKRYL0Jv1OGp9k87+jcbnl4FJuhEOWlpm6zOnidXP3Jbvsy3qKxUGlZ6ERLm9NLOA0CEFl7F6rp3WVsaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498898; c=relaxed/simple;
	bh=96R5by28DaCWdauJwfyFpraZOUhMzGu63yUSmJBQy50=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PbMlP9v+zT+wgBzTEauFULnhrdqb2oFAlN+K3V6AWGcofKPJ7ZiWt0I45DlKqhzMrZ0E6zNjYOW9oLwN9+huDRKOr65qcqJaCGEp29VJSmp6mfYKrvVxqeOSGW2olvzLNrqe4V435A9t0rugQSt2EnOWZbtEhpCJuJi5Yw60JVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pBFc12q4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5B9C19423;
	Tue,  3 Mar 2026 00:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498898;
	bh=96R5by28DaCWdauJwfyFpraZOUhMzGu63yUSmJBQy50=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pBFc12q4JcOdofudZ/axmRUR6UaMvHgjSuBbIPcnar5XwNYtu0v2YcV3O9Zy9KPIe
	 OHkEJCvvJEgOPfKZ9hX8Vo8XCc51igXamDrBUNff7o49qHoCOnnpmblwdN2pOulehO
	 DLHEBfCiUuNNr+FDR8R/6qDSiPKbJqYMYzAySMp/ULhnOaGhX6kTwFVkeLSVjPs9Rw
	 ivPQNZD3xydZAgtwUM2b303ghYxyO6MtxVSZ5hY9NUhkbATy383nvhHJM1ZP8Nw4tM
	 uO+oU6e3tGY8Jydlg3O1UtketpO7OoQXPCfLIB/Qj/MvqpVN/W6a1tzxJgWux77+3q
	 /50yHl8h3+D1w==
Date: Mon, 2 Mar 2026 16:48:16 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, andrew+netdev@lunn.ch, horms@kernel.org,
 jdamato@fastly.com, asml.silence@gmail.com, io-uring@vger.kernel.org,
 shuah@kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] selftests: drv-net: iou-zcrx: rework large
 chunks test to use common setup
Message-ID: <20260302164816.1df2e32c@kernel.org>
In-Reply-To: <90cfcf06-e987-4817-acba-2037a436a744@davidwei.uk>
References: <20260227171305.2848240-1-kuba@kernel.org>
	<20260227171305.2848240-3-kuba@kernel.org>
	<90cfcf06-e987-4817-acba-2037a436a744@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E17401E7673
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12536-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[davemloft.net,vger.kernel.org,google.com,redhat.com,lunn.ch,kernel.org,fastly.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kuba@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, 2 Mar 2026 07:54:28 -0800 David Wei wrote:
> Let's use ksft_variants() with both single() and rss()?

Woohai? I intentionally chose to only test one, buffer configuration
and flow steering are quite orthogonal. What extra coverage do you have
in mind by asking for both?

