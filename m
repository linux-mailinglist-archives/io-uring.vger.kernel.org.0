Return-Path: <io-uring+bounces-13774-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id HMg1CoDwMmqz7wUAu9opvQ
	(envelope-from <io-uring+bounces-13774-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 21:07:44 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DD6769C160
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 21:07:43 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="d/iijTYL";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13774-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13774-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F3AA33075C18
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 19:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6367C37DABD;
	Wed, 17 Jun 2026 19:03:25 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D68F35B639;
	Wed, 17 Jun 2026 19:03:24 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781723005; cv=none; b=oR3ycifwqf+k3wOz4h0hhspzVE8YVJvd9/sFlMJ6EAQ0tDC3igym3hUKybQEaipcMvWb6Ys5AFDFqR1+uf1SqoXyY3axAsItz0CxdLvKrvr8h9+jE9H34PuRczGFxuJ779XXXzgkPOgd4KC63ehorS+qRjnYxaaTcNRpkpKLRuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781723005; c=relaxed/simple;
	bh=sBJ7jjDXvl1oAZEGKkcUH7qdAwIcnwmsxQgLwbKW4PA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dSv+HJCDN0m22xsP0h6NjW7l3tg+gECChOVizquFh/k01FnPICwykg1i89YpjClORJ19jSrSQSL7Ug67gGg8EghhIBfa68F6U+Ys2SvHfWi4SjE/xSo/MEOfv0nJMJJTL60eeu/DWufnS3JblcoBDg+hdEtjuFNML/KDxQ7i+p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/iijTYL; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F1E1F000E9;
	Wed, 17 Jun 2026 19:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781723004;
	bh=TB9EmQCX2dVIP9wQgfhYd8c+piUytMXnrH0MqD5+yyk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d/iijTYLSjErNkS3iJtZi7w5Q0stuZEDIt8SkJ4fSdFu3z8jNUguGV0a5vLXog8Ar
	 UxAIkL3ClhtT6891xAJSqk2kBlyvd0T/HyhgnEArtQgGDGAtC5t1e3pQ5lBksqVIhJ
	 FXaKSOV+KVe1PIKBykHwJRkOUDtpuGfQSd3VTu3g=
Date: Thu, 18 Jun 2026 00:32:12 +0530
From: Greg KH <gregkh@linuxfoundation.org>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: stable@vger.kernel.org, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable-6.18.y] io_uring/net: Avoid msghdr on
 op_connect/op_bind async data
Message-ID: <2026061845-cycle-enviable-bb5e@gregkh>
References: <20260617175102.2976716-1-krisman@suse.de>
 <2026061727-thirsty-sculptor-1e6f@gregkh>
 <87zf0tdn7r.fsf@mailhost.krisman.be>
 <87v7bhdn04.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v7bhdn04.fsf@mailhost.krisman.be>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13774-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:krisman@suse.de,m:stable@vger.kernel.org,m:io-uring@vger.kernel.org,m:axboe@kernel.dk,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[gregkh@linuxfoundation.org,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,linuxfoundation.org:dkim,linuxfoundation.org:from_mime,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,gregkh:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8DD6769C160

On Wed, Jun 17, 2026 at 02:45:31PM -0400, Gabriel Krisman Bertazi wrote:
> Gabriel Krisman Bertazi <krisman@suse.de> writes:
> 
> > The backports are slightly different, so they were sent separately. The bug
> > exists since 6.12.
> 
> 6.12: https://lore.kernel.org/stable/20260617175158.2977825-1-krisman@suse.de/T/#u
> 7.1: https://lore.kernel.org/stable/20260617174947.2975419-1-krisman@suse.de/T/#u
> 
> Do you need 7.0 too?  I assumed 7.0 was EOL after the 7.1 release, if not LTS.

It will be EOL in a week or so, it's your call.  But I can't take a 6.18
or 6.12 version until that happens.

thanks,

greg k-h

