Return-Path: <io-uring+bounces-13488-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EKI/O569EWq2pQYAu9opvQ
	(envelope-from <io-uring+bounces-13488-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 16:45:50 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A2A55BF76B
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 16:45:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 08AB33013D4D
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 14:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 799794A33;
	Sat, 23 May 2026 14:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Av/FM2N4"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677AD184;
	Sat, 23 May 2026 14:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779547548; cv=none; b=bsCnzJ35dX+iup28WCk88G3eai/jzuK02t6RfyOAqzdtGhjZ8aHZ0+/U+lWUIcwInAAFqwHtrGRU1tOGlx/eA4DkILCm7Eq9n6ZfbW8uzz7FW3DyqvQ30uAqktUxtRrEVDbfRaA7XfVS0sWx1uKfnVnf3jYQJ/S2fHCHleyjwzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779547548; c=relaxed/simple;
	bh=3KapAMEhFbW5iLotfVFfoK5rgjJsRu0/xq6ZpIlmZqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ag4/YgPz5Ls3jDTCbiPWub4IQDqbwicU8BmZDl6yUBLgjp1pM+nJV3MgcrWlnAAoRnf3gCD8NxmB4v6riWpSMt1Ermr0WcirDdtEwpV2/p+PXyQUnELLL/6i/LBT2rC9lvTQpdTPmOgVNuQZx49jtI4Zp1gZE0eswhLV6iUzPKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Av/FM2N4; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87FA1F000E9;
	Sat, 23 May 2026 14:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779547547;
	bh=ugrIX6lHrkiGVRyINmdCm7JBkpTewfM03MXVkmbj1XI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Av/FM2N4AsXd0kq/E2I3mhcFi0q49y3XDqsqFiaaK5r45vAYS5KaOtYDRhK3a7E8J
	 yFaGzFyJQH4XdiZReOzhS4gE3mq9PkXnJoduY5jauXy2ak2Ud3Yngv87RXsQy1xW4H
	 4kH+ABpK8lx6SwLNjjlak1J4b7nDM1hK98ufV8N1sdFdnGDjMiQ3C2GUuKrcTrfW5q
	 3DDgpYAvKcWuTiBjB+XgWY9PQaOgOFKtLaj8zcO8moUWf/efM4QbAE8djSJW1aFdUl
	 qqKHjIFRtvGQAnXAm9I6z5zx/NEu8AgYhFf/U3cQ4wZlz8zX0iKWBevpv5CRurhq8s
	 js5E0ZtA+K/Dg==
Date: Sat, 23 May 2026 10:45:45 -0400
From: Sasha Levin <sashal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 7.0] io_uring/wait: honour caller's time
 namespace for IORING_ENTER_ABS_TIMER
Message-ID: <ahG9meYUQ-YLDwHN@laps>
References: <20260520111944.3424570-1-sashal@kernel.org>
 <20260520111944.3424570-26-sashal@kernel.org>
 <5a50c3f5-a5ef-4b2b-821c-5858d8b1ac13@kernel.dk>
 <8e853555-604e-46e5-8e25-a5f80b88e51c@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8e853555-604e-46e5-8e25-a5f80b88e51c@kernel.dk>
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13488-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[lists.linux.dev,vger.kernel.org,gmail.com,ntu.edu.sg];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 4A2A55BF76B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sat, May 23, 2026 at 08:23:13AM -0600, Jens Axboe wrote:
>On 5/20/26 5:40 AM, Jens Axboe wrote:
>> On 5/20/26 5:18 AM, Sasha Levin wrote:
>>> From: Maoyi Xie <maoyixie.tju@gmail.com>
>>>
>>> [ Upstream commit 45d2b37a37ab98484693533496395c610a2cab96 ]
>>>
>>> io_uring_enter() with IORING_ENTER_ABS_TIMER takes an absolute
>>> timespec from the caller via ext_arg->ts. It arms an ABS mode
>>> hrtimer in __io_cqring_wait_schedule(). The conversion path in
>>> io_uring/wait.c parses ext_arg->ts inline rather than going
>>> through io_parse_user_time(). It therefore does not pick up the
>>> time namespace conversion added by the previous patch.
>>
>> Once again - If you auto-pick this one, please also do the other one in
>> the series, 9cc6bac1bebf8310d2950d1411a91479e86d69a1. Makes no sense to
>> do just one of them.
>
>And once again, no reply. What is going on with stable these days?

Jens, as I've mentioned in the previous mail, I handle the AUTOSEL mails weeks
after I originally sent them out for reviews.

The volume of mails and patches makes it really difficult to give prompt
answers here. I have no idea if 9cc6bac1bebf8310d2950d1411a91479e86d69a1
applies cleanly, whether I need to ask for a backport, or whether I should just
drop 45d2b37a37ab9848 until I sit down and get to this batch of AUTOSEL
commits.

If this process doesn't work well for you, I'm happy top skip all
non-stable-tagged commits for io_uring. This is supposed to be only a best
effort attempt to catch commits that slipped through the cracks.

-- 
Thanks,
Sasha

