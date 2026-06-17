Return-Path: <io-uring+bounces-13773-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id mpxzMmLvMmpv7wUAu9opvQ
	(envelope-from <io-uring+bounces-13773-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 21:02:58 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 59F9C69C11E
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 21:02:58 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=wIHXv1rS;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13773-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13773-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B23F9300D1C5
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 19:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABE2E35B639;
	Wed, 17 Jun 2026 19:02:56 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0C837BE93;
	Wed, 17 Jun 2026 19:02:55 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781722976; cv=none; b=p6FAdqgn4pUImPyNMjX4TMcHv80l2wEbjwIGDzJTCGG1/g3qDGC5eHhOQatYnrHoZzjzjtWfkLXKBzkkcyi0OCVDHB5f3Dt+zYdB//9loNF5/y7YM8VX2m2oZuAyg4JvDqiI5RvaLwwH7v4x5H5MPT2NIusu4NWWxun5IzUiWps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781722976; c=relaxed/simple;
	bh=/wU5DQXpqHxvOenD2SD6jlh0NX13Wn2zUOQ+LjzMwGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RtPMKSOw0v7tI9nzF7jTzAQdbuhBYMrLjimJT8jbe2VBs7N1UkbEBKKei5PK2CfaTtkd47M33eDdXJhbV8P2RAf2eylsNfJuFWEU4m2k0gwyWTaoP5rroTMVw1mJnNsRLwPEaX0n1e4sW6bz7HxpR5GaYX7nVb/6xQ1A7dirkDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIHXv1rS; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB821F000E9;
	Wed, 17 Jun 2026 19:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781722975;
	bh=Afx/cykbmlbE5XWCc3SxBMqXdQ9McMu+8eFUZSxPIgY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=wIHXv1rSOoI6ytGxTSr5Wy/M1JPdod1Mhcn92UzLL5wAp3HDLZDFPg1GGBRzyFY00
	 xm+ovQ75e0E+tSWYEjngJVm6Ivx9+9g3VECamEXbTnIttW/L4+AqgQ7F1wlR3VQbvH
	 adSM/Pyhk9Cl/Z6Prgu/kaGDSgdc4yfAftY+Py1I=
Date: Thu, 18 Jun 2026 00:31:39 +0530
From: Greg KH <gregkh@linuxfoundation.org>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: stable@vger.kernel.org, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable-6.18.y] io_uring/net: Avoid msghdr on
 op_connect/op_bind async data
Message-ID: <2026061804-slab-agent-a134@gregkh>
References: <20260617175102.2976716-1-krisman@suse.de>
 <2026061727-thirsty-sculptor-1e6f@gregkh>
 <87zf0tdn7r.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zf0tdn7r.fsf@mailhost.krisman.be>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13773-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,suse.de:email,linuxfoundation.org:dkim,linuxfoundation.org:email,linuxfoundation.org:from_mime,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,msgid.link:url,kernel.dk:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 59F9C69C11E

On Wed, Jun 17, 2026 at 02:40:56PM -0400, Gabriel Krisman Bertazi wrote:
> Greg KH <gregkh@linuxfoundation.org> writes:
> 
> > On Wed, Jun 17, 2026 at 01:51:02PM -0400, Gabriel Krisman Bertazi wrote:
> >> [ Upstream commit 3979840cd858f30f43ea9f4e7f7f1f56de82d698 ]
> >> This fixes a memory leak due to the lack of the cleanup hook for the
> >> iovec.  The stable backport differs from upstream by dropping the
> >> io_connect_bpf_populate hunk, which didn't exist at the time and by
> >> fixing the merge conflict due to the introduction of
> >> io_bind_file_create.
> >> 
> >> Both IORING_OP_CONNECT and IORING_OP_BIND reuse the msghdr object just
> >> to store the sockaddr. Beyond allocating a much larger object than
> >> needed, msghdr can also wrap an iovec, which will be recycled
> >> unnecessarily. This uses the sockaddr directly.
> >> 
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
> >> Link: https://patch.msgid.link/20260602215327.1885109-2-krisman@suse.de
> >> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
> >> ---
> >>  io_uring/net.c   | 36 ++++++++++++++++++------------------
> >>  io_uring/opdef.c |  4 ++--
> >>  2 files changed, 20 insertions(+), 20 deletions(-)
> >
> > This isn't in any release yet?
> 
> It is queued in Linus tree during the current merge window for 7.2

Ah, so it's not even in a released -rc yet.

> >  why just 6.18?
> 
> The backports are slightly different, so they were sent separately. The bug
> exists since 6.12.

I missed seeing a backport for 7.0, shouldn't it also go there?

thanks,

greg k-h

