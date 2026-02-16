Return-Path: <io-uring+bounces-12244-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +JRfCQcqk2kI2AEAu9opvQ
	(envelope-from <io-uring+bounces-12244-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 15:30:31 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B1C2D144B08
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 15:30:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 957123005AAE
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 14:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5037029D26D;
	Mon, 16 Feb 2026 14:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Qa9uZkRU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nCgMZuW4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Qa9uZkRU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nCgMZuW4"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F4B25D1E9
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 14:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771252228; cv=none; b=TSwt751GlhxIIjQTez0HkTUfg7e5JqBbwqmvu/lM6EdLKPKmTjMoPLWtYyzBmLVgwTRQ2jUuxqjmSYRC/eEwDbdyOhSx/Wl4C8PPXxg2dZhsCWgl3YVha5UzUbv/MoNf7jfz8AcoFKSL2aXBbI+5NuNXjUQmgJKwH9WvEcCBZ1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771252228; c=relaxed/simple;
	bh=LfwF1Ustxl521oNcCGBnS2/rkhLjIvrZKg86LKR75jw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YpAD4ymoqGsYHmpBrKmK5kzRvc+XPMr5bh3O9LEdnlaAwQM50rXdgpDTpAO58KcEUworeTCxP1+AoQ19fPz17tUwb0C49BjIx8UIz5nGuiOcbit5VEll35EOCgfChL6md2YKygcdncyxFe4gihPvyJEezs8hEHLNpraMk9ldfRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Qa9uZkRU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nCgMZuW4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Qa9uZkRU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nCgMZuW4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2AC795BF3B;
	Mon, 16 Feb 2026 14:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771252225; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LfwF1Ustxl521oNcCGBnS2/rkhLjIvrZKg86LKR75jw=;
	b=Qa9uZkRUTz6ZorLfxbjcgYamN4xfaH7Qj8e6TkkNl/FNlw4H56QG1K/+xNtuvQHzGcuo0f
	ibAUXC6N9uvgEIrCBe5kL7Z1AuKpJ3F7S7aH7+z+m9jIGv6KMVDPDZQxt3B93VeQ26TazC
	QAEYS+45Ga3GNorBqxoZQeuNqhDG3Tc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771252225;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LfwF1Ustxl521oNcCGBnS2/rkhLjIvrZKg86LKR75jw=;
	b=nCgMZuW4/ekQW1Ai1XGtUYtqnpU5bmhWmI56rGyNRA350iXQ9+GQHPxZVbP5NyiTo+urt0
	v0sKanocVL4i2bCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Qa9uZkRU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nCgMZuW4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771252225; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LfwF1Ustxl521oNcCGBnS2/rkhLjIvrZKg86LKR75jw=;
	b=Qa9uZkRUTz6ZorLfxbjcgYamN4xfaH7Qj8e6TkkNl/FNlw4H56QG1K/+xNtuvQHzGcuo0f
	ibAUXC6N9uvgEIrCBe5kL7Z1AuKpJ3F7S7aH7+z+m9jIGv6KMVDPDZQxt3B93VeQ26TazC
	QAEYS+45Ga3GNorBqxoZQeuNqhDG3Tc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771252225;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LfwF1Ustxl521oNcCGBnS2/rkhLjIvrZKg86LKR75jw=;
	b=nCgMZuW4/ekQW1Ai1XGtUYtqnpU5bmhWmI56rGyNRA350iXQ9+GQHPxZVbP5NyiTo+urt0
	v0sKanocVL4i2bCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CDA123EA62;
	Mon, 16 Feb 2026 14:30:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ft5RMgAqk2mWLQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 16 Feb 2026 14:30:24 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: =?utf-8?Q?Asbj=C3=B8rn?= Sloth =?utf-8?Q?T=C3=B8nnesen?=
 <ast@fiberby.net>
Cc: Jens Axboe <axboe@kernel.dk>,  Breno Leitao <leitao@debian.org>,
  io-uring@vger.kernel.org,  linux-kernel@vger.kernel.org,
  stable@vger.kernel.org
Subject: Re: [PATCH] io_uring/cmd_net: fix too strict requirement on ioctl
In-Reply-To: <20260216-io-uring-fix@fiberby.net> (=?utf-8?Q?=22Asbj=C3=B8r?=
 =?utf-8?Q?n?= Sloth =?utf-8?Q?T=C3=B8nnesen=22's?=
	message of "Mon, 16 Feb 2026 10:27:18 +0000")
Organization: SUSE
References: <20260216-io-uring-fix@fiberby.net>
Date: Mon, 16 Feb 2026 09:30:12 -0500
Message-ID: <87ikbw92x7.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12244-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mailhost.krisman.be:mid]
X-Rspamd-Queue-Id: B1C2D144B08
X-Rspamd-Action: no action

Asbj=C3=B8rn Sloth T=C3=B8nnesen <ast@fiberby.net> writes:

> Attempting SOCKET_URING_OP_SETSOCKOPT on an AF_NETLINK socket resulted
> in an -EOPNOTSUPP, as AF_NETLINK doesn't have an ioctl in its struct
> proto, but only in struct proto_ops.
>
> Prior to the blamed commit, io_uring_cmd_sock() only had two cmd_op
> operations, both requiring ioctl, thus the check was warranted.
>
> Since then, 4 new cmd_op operations have been added, none of which
> depend on ioctl. This patch moves the ioctl check, so it only applies
> to the original operations.
>
> AFAICT, the ioctl requirement was unintentional, and it wasn't
> visible in the blamed patch within 3 lines of context.
>
> Cc: stable@vger.kernel.org
> Fixes: a5d2f99aff6b ("io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT")
> Signed-off-by: Asbj=C3=B8rn Sloth T=C3=B8nnesen <ast@fiberby.net>

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>


--=20
Gabriel Krisman Bertazi

