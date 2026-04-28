Return-Path: <io-uring+bounces-13169-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +FBkEZ8F8WnhbwEAu9opvQ
	(envelope-from <io-uring+bounces-13169-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 21:08:15 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 29B1B48B062
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 21:08:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 676B0301DD6E
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 19:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 278BA24501D;
	Tue, 28 Apr 2026 19:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bz8Ohetp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dRrYb6BQ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bz8Ohetp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dRrYb6BQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDA7254AFF
	for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 19:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777403292; cv=none; b=JOFdZYBUa4Ij1Ia4m+qGZEyLt0kzJkhRuW3Si5jPIGkkc+Xtm+sdKnGMKAdnUebR8qPsLEVW1mcT0355DTFFtIvanhjhDahQKVbxcCgzc89FI801lDPkXreGW/ngEMPkc4VIvbq3V3nf1+YEBPTT/v9+b1Di0BiH03dpmgaWp50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777403292; c=relaxed/simple;
	bh=vDYbisShlZu3xsHr9SJL/eEMPFxKthreJm7dw8zCnvE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GX25kkPn1ZCVxUBjNv57jhPn3/VPmgMUYqmMwoODHgOZNamO4W/Fg2vMQs/OUFHPyeJPBueaoBgCnazD46GOFJ4mcsAFDSuIdaZ9YZhizI1ckGhtNl3bMKGmCXhl2UOdG8WtuK6Tr42Pq+wRDfq1EhfZxyHLFOqY2kFM7r6YHyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bz8Ohetp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dRrYb6BQ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bz8Ohetp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dRrYb6BQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 630EF6A852;
	Tue, 28 Apr 2026 19:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777403283; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1kmdWqRhdkfCXWo+kNwp1GaHefjzoG8oGsnr/hJcXbA=;
	b=bz8OhetpRpDIMdi/8tD1OdVp7mhKn1jtfx+jQNyqLDRhJFxqduVOxGuZfpMt4lmSD6jO8B
	1yjFBR73YDgQgKNG/q65gg933ph1dPKooLGgdNmiNKiHq0t0Lt4s5QXpRU510ECVMK4ZtQ
	iXbfm6D59HyjoIlHmERTRQZGK6Zlp1Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777403283;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1kmdWqRhdkfCXWo+kNwp1GaHefjzoG8oGsnr/hJcXbA=;
	b=dRrYb6BQuYqH75RJLnfstG/H9O3INPP1psiEuV59qU2Fqbky0CKpZ3lSVaXu2ATJTb2k1J
	kfrvailCKCFlKBDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bz8Ohetp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dRrYb6BQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777403283; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1kmdWqRhdkfCXWo+kNwp1GaHefjzoG8oGsnr/hJcXbA=;
	b=bz8OhetpRpDIMdi/8tD1OdVp7mhKn1jtfx+jQNyqLDRhJFxqduVOxGuZfpMt4lmSD6jO8B
	1yjFBR73YDgQgKNG/q65gg933ph1dPKooLGgdNmiNKiHq0t0Lt4s5QXpRU510ECVMK4ZtQ
	iXbfm6D59HyjoIlHmERTRQZGK6Zlp1Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777403283;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1kmdWqRhdkfCXWo+kNwp1GaHefjzoG8oGsnr/hJcXbA=;
	b=dRrYb6BQuYqH75RJLnfstG/H9O3INPP1psiEuV59qU2Fqbky0CKpZ3lSVaXu2ATJTb2k1J
	kfrvailCKCFlKBDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E39C593B0;
	Tue, 28 Apr 2026 19:08:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wNbRMZIF8WkGQAAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 28 Apr 2026 19:08:02 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,  Martin Michaelis <code@mgjm.de>,
  stable@vger.kernel.org
Subject: Re: [PATCH 2/2] io_uring/kbuf: support min length left for
 incremental buffers
In-Reply-To: <7645db80-8a8a-4ed6-9a3a-f2406cf93322@kernel.dk> (Jens Axboe's
	message of "Tue, 28 Apr 2026 12:02:34 -0600")
References: <20260428154557.2150818-1-axboe@kernel.dk>
	<20260428154557.2150818-3-axboe@kernel.dk>
	<87ik9bj7jt.fsf@mailhost.krisman.be>
	<7645db80-8a8a-4ed6-9a3a-f2406cf93322@kernel.dk>
Date: Tue, 28 Apr 2026 15:08:01 -0400
Message-ID: <877bpqkini.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 29B1B48B062
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13169-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[6];
	DKIM_TRACE(0.00)[suse.de:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.de:dkim,suse.de:email]

Jens Axboe <axboe@kernel.dk> writes:

>> Honest question, isn't this a property of the specific operation and/or
>> fd being operated, instead of the buffer_reg?
>
> It kind of is, in that some users may not care. But it's not currently
> possible to pass this in on a per-op basis, and while I did hack that
> up initially, it's almost impossible as you end up with layering
> violations. In practice, this is really mostly a recvmsg multishot
> issue, because we need to store the headers. Hence the solution to
> stuff it in the io_uring_buf_reg instead, and make it a fixed property
> of the buffer group. In practice, you may even want a larger min_left
> than what the recvmsg requires, as you don't want a tiny truncated
> transfer at the end, regardless of what type of recv or read operation
> this is. Hence it works generically as well.
>
> Also see the linked GH issue, that's where most of the discussion
> around this have happened already.
>
>>> -		if (buf_len || !this_len) {
>>> +		if (buf_len > bl->min_left_sub_one || !this_len) {
>> 
>> Cosmetic, but perhaps store min_left_sub_one instead of min_left itself? the
>> buf_len must be >= min_left, and that is easier to read.  (buf_len &&
>> buf_len >= min_left || !this_len)
>
> Also see GH issue.

Ack. Thanks.  Feel free to add:

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>


-- 
Gabriel Krisman Bertazi

