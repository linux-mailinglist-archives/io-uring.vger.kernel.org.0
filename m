Return-Path: <io-uring+bounces-12270-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eMiBFXtik2n74AEAu9opvQ
	(envelope-from <io-uring+bounces-12270-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 19:31:23 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BB0E5146FD7
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 19:31:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AB970301FC80
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 18:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40BA22BDC27;
	Mon, 16 Feb 2026 18:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fiberby.net header.i=@fiberby.net header.b="PeLAiIIu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail1.fiberby.net (mail1.fiberby.net [193.104.135.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61FB219A8A;
	Mon, 16 Feb 2026 18:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.104.135.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771266680; cv=none; b=DQllwxufVgxyfEeKpuIdaSKc0TLNW7n2FK2Oset7+OEKyqkw3Nud4iW6H0lDUAVi6pFpFb4KeiLwdm6Cj0+YeYBXpPklIMzC79iu+8ll+500tfLfQZXxiS2enA61C3aJnVOPfeZybXeYTg0wcKgzXrp7CXOjg49HzKXk1IV9Bek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771266680; c=relaxed/simple;
	bh=HIDHPlRtPRbYyevCOzRYnErusSYLI1Rh6VoOeJqPMTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uTlsTUUDj+i32D5u6jZj5DnT/BdCYx/tssdvj/8azui6pLCHJKl8jQHa2hg3SYhewJneO7nBXTE+vPkZqww1bTJdhwp8r2g0aj9rN0TszMlvqYHEqAGoZB/DuHA60QrAsOzv7x9ekh7gL8p3g3lGIkG1qC40TdkrLTwp9XNCkcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fiberby.net; spf=pass smtp.mailfrom=fiberby.net; dkim=pass (2048-bit key) header.d=fiberby.net header.i=@fiberby.net header.b=PeLAiIIu; arc=none smtp.client-ip=193.104.135.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fiberby.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fiberby.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fiberby.net;
	s=202008; t=1771266673;
	bh=HIDHPlRtPRbYyevCOzRYnErusSYLI1Rh6VoOeJqPMTQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PeLAiIIuOFTxr0KZt/FfDPIF1709HQNw4hcnBYWZZp6wtjzIbEzV/vHdookkAsiZs
	 U/9uZCVIEzV/ZtBDF9xWiuvpSNRhWqCVVVO6miawxYof7XiveWCsMbBCWSg808t/Se
	 wvyoqOTHWRyGAPRI8raAwslicsge8C1+yhF69kWgymI4kT0hJIN+aZNyo/qfl9v7oa
	 qy9Y0dp2NoS69Xr6EYsT1q27wrWfRK0mr8Ap8TgNAe/7U3EKkjPesR6ZT+B4Ahy/ue
	 g2Qj6hMF6rYZVrOrtpIUL6PE0c4RtM4PTxNZUbBm442AOolaywXCuRj3KZa4OA3cK8
	 Dx29Hm4Gr2K6w==
Received: from x201s (193-104-135-243.ip4.fiberby.net [193.104.135.243])
	by mail1.fiberby.net (Postfix) with ESMTPSA id D1BE460104;
	Mon, 16 Feb 2026 18:31:13 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by x201s (Postfix) with ESMTP id E5F6D2016A4;
	Mon, 16 Feb 2026 18:31:09 +0000 (UTC)
Message-ID: <4f0b080b-f5ea-48c3-a507-c350d3b9d2e0@fiberby.net>
Date: Mon, 16 Feb 2026 18:31:09 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/cmd_net: split ioctl code out of
 io_uring_cmd_sock()
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260216160354.73239-1-ast@fiberby.net>
 <5bdb3ec3-8b25-4021-9d99-f866c4fd588c@kernel.dk>
Content-Language: en-US
From: =?UTF-8?Q?Asbj=C3=B8rn_Sloth_T=C3=B8nnesen?= <ast@fiberby.net>
In-Reply-To: <5bdb3ec3-8b25-4021-9d99-f866c4fd588c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.45 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.71)[subject];
	DMARC_POLICY_ALLOW(-0.50)[fiberby.net,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[fiberby.net:s=202008];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12270-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[fiberby.net:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[ast@fiberby.net,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,fiberby.net:mid,fiberby.net:dkim,fiberby.net:email]
X-Rspamd-Queue-Id: BB0E5146FD7
X-Rspamd-Action: no action

On 2/16/26 5:46 PM, Jens Axboe wrote:
> On 2/16/26 9:03 AM, Asbjørn Sloth Tønnesen wrote:
>> io_uring_cmd_sock() originally supported two ioctl-based cmd_op
>> operations. Over time, additional operations were added with tail calls
>> to their helpers.
>>
>> This approach resulted in the new operations sharing an ioctl check
>> with the original operations.
>>
>> io_uring_cmd_sock() now supports 6 operations, so let's move the
>> implementation of the original two into their own helper, reducing
>> io_uring_cmd_sock() to a simple dispatcher.
>>
>> Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
>> ---
>>
>> Jens, I'm used to net -> net-next taking a week, as it only happens
>> through Linus' tree.
> 
> Looks good to me - since this is just a cleanup, let's defer to 7.1.
> I'll kick that off in a week or so, at which point I'll pick this one
> up too.

Thank you, and sorry for posting during the merge window, I always
intended this for 7.1. I just took it as an invite that you merged into
for-next right after committing my fix to io_uring-7.0, given what I
wrote earlier in the RFC: "I plan to submit v1 once that patch
propagates to for-next.". I wasn't expecting it to happen that quickly.

