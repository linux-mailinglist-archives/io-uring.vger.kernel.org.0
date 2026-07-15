Return-Path: <io-uring+bounces-14021-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Ll0+IPxEV2qLIQEAu9opvQ
	(envelope-from <io-uring+bounces-14021-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 10:29:48 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EDB0475BE24
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 10:29:47 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oOu7zJ34;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-14021-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-14021-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7472D301413B
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 08:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F00633CB918;
	Wed, 15 Jul 2026 08:28:28 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E841C3264E9
	for <io-uring@vger.kernel.org>; Wed, 15 Jul 2026 08:28:27 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784104108; cv=none; b=H+LKRatV9NSLWxKZDnfOwFRjI4nQhWVquPyhBuSuqr1SXm7k2NTvXEh90PCkvsyqUVldaZ6jmCTiEGjGqcpgJgFkuF+hOSN8Jj/zIQE15rF7oihHtssNyFzvAdCB2AUhqBn5Z0Cr0/+ZN/bbYNZ3alz8sPdaxxTbyTk0yXwZQts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784104108; c=relaxed/simple;
	bh=yinyw4kxm5JheX0sSNw/ZNKSx08MeaR8KbujV+bB7Bg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QslKJr7rlTJ4UDfESsVMbzAcUQuIMYPSvkjWo03bKYCMQ667+kqIJZSsLtN+kULx5qN0jrq53Vaxw5yqm0jdbyFm3L+lec9a8ofycWvPkoTVAElE24zH2BaOUfmggN3n4NbkBOLVjdppfnl9fIAjpGrdSa1TYF68o3SVmzTe2OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oOu7zJ34; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2981F000E9;
	Wed, 15 Jul 2026 08:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784104107;
	bh=ZjFUqxo9aGaKtBup7wkzfeJ8HgadtR5AOPk5izpi4NQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oOu7zJ34Cutt2v9Y+d5DFY7h7zrjKNlwuf+GLXcMVo6p4Savk0ZsdBN6aMt6stz2z
	 M7fh7o7m1xetdza9PgCFOdnbu9BwbbH3MIzpQB80RnDvzPZHxFRnbHpImein7s2n6M
	 00T1quIoj+VYvoHxMe8cSa1N+IZmps/f28/176zZ/r7aL7b3kGnm+NePaysAjKwBiC
	 QmXDFBsFQAqjjO5P2MdWmqcApuLOFRSeUZFB1WDx6bRSDgukFmgmHCwniWd24YLbYR
	 NsFp0B0hFMLKuZT5llh4EChXlNynG7pfYyvvOystgFoKTUHzgqR1CRjq+YHODiL7b9
	 BXP8UUetD1DeA==
Message-ID: <db555d67-964f-4565-bac0-660218c88216@kernel.org>
Date: Wed, 15 Jul 2026 17:28:16 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] man: fixups for io_uring_prep_cmd_discard.3
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
References: <20260715063947.2933606-1-hch@lst.de>
 <20260715063947.2933606-3-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260715063947.2933606-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-5.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14021-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[dlemoal@kernel.org,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:hch@lst.de,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,lst.de:email,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: EDB0475BE24

On 7/15/26 15:39, Christoph Hellwig wrote:
> Mention the ioctl this is modelled after instead of the io_uring
> cmd used to implement io_uring_prep_cmd_discard.3, and drop an
> incorrect plural for page cache.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research

