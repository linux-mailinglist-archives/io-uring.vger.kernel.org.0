Return-Path: <io-uring+bounces-8714-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 80A0CB0A96D
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 19:27:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BE771C8195A
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 17:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 140DC2E716C;
	Fri, 18 Jul 2025 17:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZiVaWKET";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bG9w9uKn";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BzV3xg3S";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="H6WsJs2U"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E9A2E717C
	for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 17:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752859614; cv=none; b=hrqFnQIFggdFQl9C4CbzouOQl/ypJrg/PTCxpW2jvEywXI33F1y2NHBt9SMTB/iw4UunNkfLsKfZ74Dakz5Qn+MYEHHnoaRqHWbiLXzcgMZdaXLS3pb1NJsu+0Dl2ii0xFKpLtcPdQxRe5Xi3VCvm4vr5oTAyaFIoUYTSq6g1k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752859614; c=relaxed/simple;
	bh=hE8vJO+kjcT7VrvWxjAz/+xfMBAO56zr+5czrMYvgJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AQputpSQHgIpnR80G4lPtyQivm6Zby2+eoCnzyaioABsfa1doTh3FP93nXbkK6RsPcMG96XH5k1u+18ixQIioBR/Plwk4wLdpHl5voCaE0wcNskvLRjDCnBRzFJBOFN3cbCXU79A8EhWVZ73DwmtFXnw8b4kY3/RVr/+5TQ4lAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZiVaWKET; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bG9w9uKn; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BzV3xg3S; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=H6WsJs2U; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E1C7C1F390;
	Fri, 18 Jul 2025 17:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1752859610;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zlgtbzk13L3Idr2RClrMQx901TWYJ6RTF5c/w6eJUus=;
	b=ZiVaWKETHDi5dYiPDiIEHqIzIuWdVQfe2OVrKkcS9IfhCtJqBd5yqAmLFM18zTwGHHkhgR
	yAsVkPfG9yaG3o1UJ//8UDgYoZtkVtr04oIxcxuva+Qh1NS23pxhTGUkFPO75NzLxyDkZ/
	vToOZASbbo+a8cr2tz2m1od8g2NH3mM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1752859610;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zlgtbzk13L3Idr2RClrMQx901TWYJ6RTF5c/w6eJUus=;
	b=bG9w9uKnTq0cInykWKl5+RISv9x7urki8NdJZTI3wSYigfxZDU0wTPgLUFwTEN9bVxA5bZ
	oGnqM/H+cHydZhCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1752859609;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zlgtbzk13L3Idr2RClrMQx901TWYJ6RTF5c/w6eJUus=;
	b=BzV3xg3S7Lry5XT2rbQge9/HPuPBt0Yt2gNMm6u1I0Oo3DawK0KdZF/vOYFOASNwTOfxac
	htggMaBDLCnN3p925PL7PbKW4FH+sDEVjHuQi6o2rt60N2eaCulzvifHiKRf7HsJ26T00k
	qe1cL7N2bI50Tvaty+JOsQdT+ovpmt0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1752859609;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zlgtbzk13L3Idr2RClrMQx901TWYJ6RTF5c/w6eJUus=;
	b=H6WsJs2UUapQa0pQz1fL5XoRu1p8gqXtLtuCLQdD3i7nIw/nEqwQ0/+R+X0MrNQJkFDuvU
	/0nq1S/jiPGcouDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C5B6C138D2;
	Fri, 18 Jul 2025 17:26:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5tQcMNmDemjlYgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 18 Jul 2025 17:26:49 +0000
Date: Fri, 18 Jul 2025 19:26:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] io_uring/btrfs: remove struct io_uring_cmd_data
Message-ID: <20250718172648.GA6704@suse.cz>
Reply-To: dsterba@suse.cz
References: <20250708202212.2851548-1-csander@purestorage.com>
 <CADUfDZr6d_EV6sek0K1ULpg2T862PsnnFT08PhoX9WjHGBA=0w@mail.gmail.com>
 <bb01752a-0a36-4e30-bf26-273c9017ffc0@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb01752a-0a36-4e30-bf26-273c9017ffc0@kernel.dk>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -4.00

On Fri, Jul 18, 2025 at 10:58:07AM -0600, Jens Axboe wrote:
> On 7/17/25 2:04 PM, Caleb Sander Mateos wrote:
> > Hi Jens,
> > Are you satisfied with the updated version of this series? Let me know
> > if there's anything else you'd like to see.
> 
> I'm fine with it, was hoping some of the CC'ed btrfs folks would ack or
> review the btrfs bits. OOO until late sunday, if I hear nothing else by
> then, I'll just tentatively stage it in a separate branch for 6.17.

I've taken the first patch to btrfs' for-next but if you want to add it
to your queue then git will deal with that too. For the btrfs changes

Acked-by: David Sterba <dsterba@suse.com>

