Return-Path: <io-uring+bounces-14023-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id h0uhEd9FV2rKIQEAu9opvQ
	(envelope-from <io-uring+bounces-14023-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 10:33:35 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id F15A275BEC0
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 10:33:34 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ku3hZOoQ;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-14023-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-14023-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7E3DA3009891
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 08:33:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50F563A4F2C;
	Wed, 15 Jul 2026 08:33:32 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A199305047
	for <io-uring@vger.kernel.org>; Wed, 15 Jul 2026 08:33:31 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784104412; cv=none; b=di1orwsxTcT3jovVPvUMvWvW7cV0ojn/dQhD6l0AjM2qJuhp23yugmi7nqiv7X8+E3zSKEfHRlRORig5iRFHi50NVyIzfH0A3UR56iJxC3fbqTCPcr7+jOBoKVWvVV+21bqZFaqs3u5ZQhyHDdkOo6uBuZCcQkDjaPIH714WEug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784104412; c=relaxed/simple;
	bh=Z0XOFW0Iu/zQQk7RAQBKMYOquikboZGhieqY8WrHydw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fEvkE45uGIOoQL4I5eSvG7jS6FZ702YMDeqSkOwjXXf7NS2qOqBYqGaiXEx3DoSgeIz8lSVPlzvdnIu48yDiRcnl5OJ7z/a2Sa+s/7qKrJzW8E8kfCfjYSRFbut7q3cJvEH88zszNL9ygJZWtBwRasUgCWkE2rxUHX+IOW+rdSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ku3hZOoQ; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813521F00A3A;
	Wed, 15 Jul 2026 08:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784104410;
	bh=g6cYXSq5K2YWiMGDHhQPRB2oLP0ZaDSZ6AQEWr7Fjkk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ku3hZOoQEyIGdor6UgKqQUys9mGQls0F/JbuV+vNaUuFB2aq4/1EFfTkVmZHf/Vy3
	 TOazveG+BDiLvob3wzzVgJCZ2TL44X9cK0wmNjxYHnvJNrwyqyymfaHDE+gzEk3wfV
	 wn4PXD/YOmey2vQwFGCq+C2zje8kAtECgYR6W+VRMMCMDLFsvHyINpMRgSYP/zs1H1
	 /fFKYG2LrqR6ZMP0EjPLWDo/wR4yFdTx8U5XGDmDGxjMOXj90jHE2KvOGN6bjw++zl
	 O+pqa4F5sbSbbfEZniGLEWg4LwId/9olJ1YsrJCKlCuliQPi/xiXQDLP2jqezIYUA6
	 z1QrCQEkHhgFw==
Message-ID: <39f363af-e2ac-4f46-a005-531be02aea8b@kernel.org>
Date: Wed, 15 Jul 2026 17:33:19 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] man: add io_uring_prep_cmd_zone_reset_all.3 man page
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
References: <20260715063947.2933606-1-hch@lst.de>
 <20260715063947.2933606-5-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260715063947.2933606-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-5.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14023-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,vger.kernel.org:from_smtp,lst.de:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: F15A275BEC0

On 7/15/26 15:39, Christoph Hellwig wrote:
> Add doccumentation for the new zone reset all io_uring cmd.

s/doccumentation/documentation

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research

