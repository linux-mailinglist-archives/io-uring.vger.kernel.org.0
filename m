Return-Path: <io-uring+bounces-13766-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id moLuDTTEMmr85AUAu9opvQ
	(envelope-from <io-uring+bounces-13766-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 17:58:44 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DDFB69B2FA
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 17:58:43 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fs+TVfGL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dQZHZbVf;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fW5moRPV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lvwf5XOj;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13766-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13766-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=suse.de;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7048A3301FCE
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 15:43:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 072CB480350;
	Wed, 17 Jun 2026 15:42:16 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A6F4A3414
	for <io-uring@vger.kernel.org>; Wed, 17 Jun 2026 15:42:03 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781710935; cv=none; b=jTh0n8yIuyWPXXD20YVWUkwuJrtlu3Q/n1RZOSn+768QSBPkmhzqKgmUIR5mQ38iIjIIUnZu8pvCRwsP5Y+GqXtY1q7p59AR5ptHL5cqm4CfvnKnq6o/qphdHQotwc1aOLelMRppRhleAJ01/blyUXRGMTvLQzWRfKzXrkl7/Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781710935; c=relaxed/simple;
	bh=lZcNAoP08lGkD9cDTqavCunAxgdyt7NKehVIprEev0Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=P5D3gUPWCSVXYgVqp+HG8vDUdE6QHy2gaHFa5VyLJKYRC/U0rcGS+eRJgedRznBQe5DyG7SKjUn1d5lm4MAVV/HMyThGRT1oQEKOiSMc1EoNGgHFrv9VQbgfsxDCRQ1xQ7z+Wa5dqOgoMBikHp1mJ85rRqQUiT8XsKRNkxYIsZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fs+TVfGL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dQZHZbVf; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fW5moRPV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lvwf5XOj; arc=none smtp.client-ip=195.135.223.131
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5103E75CFB;
	Wed, 17 Jun 2026 15:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781710921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9sN9Ok6hqDHaIQIEI6sGwocwIe7vR3RqH3aUMo5cNfM=;
	b=fs+TVfGLtySDUp/pwogDOJVl4/A73br+D/+bur8MQViXYDIvDsYY/vVoq2jTXA3TIJWEBE
	KuHaeJZSC5sz4fvlfsH9fYoWin9AuQwkl6//rZ0gULrwOLRpIbOhS/GVNR4aZtDdL3fvTv
	X6VXaIjFMXn3w/ojbt/2rI6Xrj68FAQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781710921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9sN9Ok6hqDHaIQIEI6sGwocwIe7vR3RqH3aUMo5cNfM=;
	b=dQZHZbVfSOWhQiRg5HyapsqguL1sQWKnZofW7YK2JOPNZzQ/m5BVTyBHhLjDSfXoO9yfmA
	ZXkMXenj64kwH4CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781710917; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9sN9Ok6hqDHaIQIEI6sGwocwIe7vR3RqH3aUMo5cNfM=;
	b=fW5moRPV/BLMgbfNRCyQeoOTrdbvApWoCpTplGsDZoFDSURUVMEqPFIDZuQTKtqlCLenW4
	/r+p4XElBh54X1MLj3iLUr5pcGBUmbXZ69eosqVcjRiy7fo7W0BhGxu2gt0+OMAMtsO9bv
	IhuFQv17oDEbr9ViP29Lf8N2J5XuAgw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781710917;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9sN9Ok6hqDHaIQIEI6sGwocwIe7vR3RqH3aUMo5cNfM=;
	b=lvwf5XOjM6fgyvps4P5yttxHJPkIpFyJbLVIuO3hJ5rumMkiEen45Y74i4+4ZPMnsmqV4Q
	h6zLVsQGqsCVDsAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 012A9779A8;
	Wed, 17 Jun 2026 15:41:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WAa8L0TAMmoeagAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 17 Jun 2026 15:41:56 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>, Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring/net: fix netmsg_cache iovec leak on BIND and
 CONNECT
In-Reply-To: <870ac7c0-a521-45b0-ab0b-fed5f97a319f@kernel.dk>
References: <20260617025348.1301777-1-yangxiuwei@kylinos.cn>
 <20260617033035.1373691-1-yangxiuwei@kylinos.cn>
 <870ac7c0-a521-45b0-ab0b-fed5f97a319f@kernel.dk>
Date: Wed, 17 Jun 2026 11:41:55 -0400
Message-ID: <877bnxfa2k.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:yangxiuwei@kylinos.cn,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13766-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_THREE(0.00)[3];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:from_mime,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8DDFB69B2FA

Jens Axboe <axboe@kernel.dk> writes:

> On 6/16/26 9:30 PM, Yang Xiuwei wrote:
>> Hi Jens,
>> 
>> Please drop this patch.
>
> Haven't picked it up, nothing to drop.
>
>> After rebasing on the latest io_uring tree, I noticed that this issue
>> has already been fixed upstream by:
>> 
>>   3979840cd858 ("io_uring/net: Avoid msghdr on op_connect/op_bind async data")
>> 
>> BIND and CONNECT no longer allocate async data from netmsg_cache via
>> io_msg_alloc_async(). They now use struct sockaddr_storage directly, so
>> the iovec leak path described in my patch no longer exists. My fix is
>> also incorrect on the current code base.
>
> But then we should probably mark 3979840cd858 for stable, then? Gabriel,
> can you take a look? Currently traveling...

ack. will do.

-- 
Gabriel Krisman Bertazi

