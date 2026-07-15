Return-Path: <io-uring+bounces-14020-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 3iHUG2NEV2puIQEAu9opvQ
	(envelope-from <io-uring+bounces-14020-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 10:27:15 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E00E175BDCD
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 10:27:14 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ePXnhlMz;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-14020-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-14020-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B6AB13011139
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 08:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 497862FFF9D;
	Wed, 15 Jul 2026 08:27:13 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430C23CA4B3
	for <io-uring@vger.kernel.org>; Wed, 15 Jul 2026 08:27:11 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784104033; cv=none; b=TRZe1AsO2dTxHYg+Fp9YdMh2MAxsDjxWoGRNMicuSOYN0GPF9s99K1FEfMSNMDhpX9Qj1c8lpfZJDR34eBD4o9jSCbALDGDLGx8KCOXx8VRaKoegyvwp4gJDzBMDGu7SnY73EaIPosrgnFRJk6PCpYIduPTKFeIajqlpYesbpN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784104033; c=relaxed/simple;
	bh=vgwSbkmHkM6CS2yHuD34EkZIBeihw0zhW+GbgGlexJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RkgwbdLs9XTn2cFQRGMnDnxYQ8gRFazJdUgiM8Ebtdiuvm+jvNnqChXgs11PLSiMsYxd19F2Gj74KKFoEE8dci5ZMeEp0ixq278gNi78VYFT5rZdaZJeigAOKUKx22SRwk4rQzMDkDyvhw1gQfL7Eh7AX9EbSsHgWrANtD4WX94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ePXnhlMz; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AD51F000E9;
	Wed, 15 Jul 2026 08:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784104031;
	bh=8Z5lqC7Ze+PYPWaeQZ9ppo8UGQPyAn8LpuVaXKz2/qc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ePXnhlMzuqYqrceaCJgZpu9nsG8ajtoyhkoAtsDctU3rmFgrSsKy60415P3rpmppr
	 10Peg16w2NKKbkn5ukc1G3BLrp5s4xhdU9QKIq8ufaPJ2cp2bn8E0hiueTHrmdxn7E
	 RIJs2nfVYgfZRD2W6t4s3v8ibpnF8akNPZ2eZiLzBuPht4ENPAGoYjf3oLpcnUgA2L
	 1XkWQuPs4sj1Y7k3Ko4YxKnNtv9d8a0XINvZK0xboiD7rvPR4mI6rCRDlLHMjC1Ku0
	 ZtSqzg5J+WPbpXVLyYtOqLfzejKcCW4uNAlSu79NH/8bNyh0nudQsgR36JtBfsZAVy
	 BNcWzq6X2bX5w==
Message-ID: <f4da4ec6-706a-4ede-a9bc-1b01719ebe2e@kernel.org>
Date: Wed, 15 Jul 2026 17:27:08 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] configure: shorten the message for the discard
 command
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
References: <20260715063947.2933606-1-hch@lst.de>
 <20260715063947.2933606-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260715063947.2933606-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-5.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14020-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:hch@lst.de,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[dlemoal@kernel.org,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	HAS_ORG_HEADER(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dlemoal@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,lst.de:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: E00E175BDCD

On 7/15/26 15:39, Christoph Hellwig wrote:
> The current message is pretty long, drop the redundant io_uring.
> This aligns it with the soon to be added zone_reset_all message.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

