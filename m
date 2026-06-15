Return-Path: <io-uring+bounces-13737-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id IFF/LP1ZMGoPSAUAu9opvQ
	(envelope-from <io-uring+bounces-13737-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 22:01:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 491B5689A4A
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 22:01:01 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YPoeqkFz;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13737-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13737-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AB810301067F
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 20:01:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47F5A38229A;
	Mon, 15 Jun 2026 20:00:59 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE121F09A5;
	Mon, 15 Jun 2026 20:00:58 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781553659; cv=none; b=XUasv5p6UNFJ03sN+uxTjTN74Qib/LFNTXCK8hCcWWysYPq870kvO3VocAFZWZ4aggrEQFHHoKR1fRgrr4oWVuhMby1PZg/ACVt7GHg1RPOZFsNmW22Zociy9Y2tZrhdgtpC82KnHNo5la7eWJHyaixPe5IBVNLICnHWB1GpEG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781553659; c=relaxed/simple;
	bh=SjppnqlhpDI03qRsh2Nei1Rj9w6bJbdgHEPZwT1LQmk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bdNZltjKDE5aEHDhkfFZus+9C+ukN0bYu3UgOdzCYkGNu19svN8AOEvM4YS4hkFSkYVGGnsSdz8Z4Blw6PgT/TlMnqQP8QYYEHgpEMFabKu6Ea+1ct98kqFtAhZHb5l6WUv5URPgdTMN7+stxhLd5XzTCgPDP9wRrHGLh95v+jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YPoeqkFz; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4580A1F000E9;
	Mon, 15 Jun 2026 20:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781553657;
	bh=uBmhK5GRzfQc88RjWt4z4d5+i8/Z9kF0dewVd4Uu3tY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YPoeqkFzrQozZwHoi9UukFeLmDhdVMF7G6poMoFhkdC2xNuEGEKGlA7UYAD1IwlCl
	 QBnvL9U6mBkkKpEpiThJ9Hwp1n69HPFhc2Hn5+6ViJugk2Sln4yErQZgGU5EI22GYB
	 ufkq5viuO2p5cAOaD+k6lOP4eftoSELRzPMghoZxdCk2dJHI41qxtCC4zhaFrdECYi
	 U4qaXuHClDFnlp/2uHtMARZgpN9rz+0DUSDGkoSWBwdmuhJQ5aEf8YrRxd+bMurNZm
	 gzAp9mB9Kv1ySsjo67dC5VMqo1dE248PonMZmC9lIitG9KrdW27lIv2zcqj5NRc2hP
	 Feg52namxe3hQ==
Date: Mon, 15 Jun 2026 13:00:56 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Dragos Tatulea <dtatulea@nvidia.com>, Donald Hunter
 <donald.hunter@gmail.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>, Jens Axboe
 <axboe@kernel.dk>, Yael Chemla <ychemla@nvidia.com>, Tariq Toukan
 <tariqt@nvidia.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] netdev: expose io_uring rx_page_order
 order via netlink
Message-ID: <20260615130056.028c5ed4@kernel.org>
In-Reply-To: <a773d177-82f3-4046-866d-852d0d83e08b@gmail.com>
References: <20260612211709.1456966-2-dtatulea@nvidia.com>
	<20260612211709.1456966-3-dtatulea@nvidia.com>
	<d0401fab-61c5-43e7-93ae-d4757433eb7a@gmail.com>
	<b581d253-135b-4c75-a50d-2049c6d6e249@nvidia.com>
	<20260613170232.6f9e72ba@kernel.org>
	<a773d177-82f3-4046-866d-852d0d83e08b@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-13737-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[14];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:asml.silence@gmail.com,m:dtatulea@nvidia.com,m:donald.hunter@gmail.com,m:davem@davemloft.net,m:edumazet@google.com,m:pabeni@redhat.com,m:horms@kernel.org,m:andrew+netdev@lunn.ch,m:axboe@kernel.dk,m:ychemla@nvidia.com,m:tariqt@nvidia.com,m:netdev@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,m:asmlsilence@gmail.com,m:donaldhunter@gmail.com,m:andrew@lunn.ch,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[kuba@kernel.org,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kuba@kernel.org,io-uring@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	FREEMAIL_CC(0.00)[nvidia.com,gmail.com,davemloft.net,google.com,redhat.com,kernel.org,lunn.ch,kernel.dk,vger.kernel.org];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 491B5689A4A

On Mon, 15 Jun 2026 12:16:47 +0100 Pavel Begunkov wrote:
> On 6/14/26 01:02, Jakub Kicinski wrote:
> > On Sat, 13 Jun 2026 16:09:03 +0200 Dragos Tatulea wrote:  
> >> In io_pp_nl_fill() or in page_pool_nl_fill() as it was done in v1 for order?  
> > 
> > It's fine. We decided to make the "page size" a memory provider
> > property, now we're going back to making it a queue level param?
> > Like my RFC had that everyone hated so much? Sigh.  
> 
> TBH, I never cared much how nl would show it, so not opposing either
> version. My idea is that even without plumbing in per-queue non-mp size
> configuration, it'd be nice to have a common way to check it b/w
> providers.
> 
>  From the semantics and observability perspective, zcrx is probably not
> that interesting as the parameter is basically just a hint with no affect
> on uapi, and I'd assume people would rather see the page pool size or even
> the NIC's page size. But I guess it depends on what Dragos is really after
> with this patch.

Not sure what Dragos's use case is but IMO it's useful as system admin
/ vendor to be able to peek at the important params when user reports
bad perf. The netlink MP info is meant for system observability.

