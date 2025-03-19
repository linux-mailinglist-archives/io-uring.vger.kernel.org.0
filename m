Return-Path: <io-uring+bounces-7135-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B14E2A695E0
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 18:08:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBA743BAC4F
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 17:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 854691E5204;
	Wed, 19 Mar 2025 17:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xc8YmfTE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MR4mcUKd";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xc8YmfTE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MR4mcUKd"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7171D54D6
	for <io-uring@vger.kernel.org>; Wed, 19 Mar 2025 17:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742404039; cv=none; b=a3jGxp+Ng4CJVnVAJD5y8MmEA6qnXM+q6hfRPqKnjEEGI5F4V8DOnV1Mr1whZuYg+FAxqZXkK6+ALr1pWSqiY0i2IzQCPQpIEZDeOAPYsYOIpfB2tBuFdIx7C9Qy+NidTgQDHwMAAeeHrtcIv+nqVFnCye8eW0sGyIA0GQMw13A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742404039; c=relaxed/simple;
	bh=V3EXe5YM5pIJp1J0uwLE9NgVLI8KbcXJ9nKjpbfFdlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JiHMYRpXY2PdUJpL2kbr+0bYaVoFUFtIxnqm9WHYoKftHEQuJcaSn3HWEyVH9eX6233ulUDPnSH8lng++1V8Z7QqyqDXvl1rDeRaHDKyad3eB8njmqNrSfNHEV8KeSYo1/PejzjiL43+1Lioeicw+2N2WCuy5S3WCe4ixZJsUmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xc8YmfTE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MR4mcUKd; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xc8YmfTE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MR4mcUKd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 067411FD96;
	Wed, 19 Mar 2025 17:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1742404036;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7XDC4SfHDNBOwpQe1A7tca/PZWgtJvOp4dCJtUB3U50=;
	b=xc8YmfTElVaNE5jumisiUkuZ0Y3FjKYIdXFipM0gXOFtl7M/fwQAtF+X6uk33BrMqU2wHl
	/KzcNus4pPatYkAfbKs46w9lMrVui63XUDJ7K9aXHu2WOozx7lrYuV+IXsJu2VlhxS4XyU
	u4glZ6dWYbxZOJEu7CnWFfbA6D7Hd50=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1742404036;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7XDC4SfHDNBOwpQe1A7tca/PZWgtJvOp4dCJtUB3U50=;
	b=MR4mcUKdz4mwrlLwN42TP2CKa5xpxybAgZD3hl7BnF9ft0NbrVNzoFrHmuUd50i7+2k/l6
	SRZ7FW9DmCT4WhCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1742404036;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7XDC4SfHDNBOwpQe1A7tca/PZWgtJvOp4dCJtUB3U50=;
	b=xc8YmfTElVaNE5jumisiUkuZ0Y3FjKYIdXFipM0gXOFtl7M/fwQAtF+X6uk33BrMqU2wHl
	/KzcNus4pPatYkAfbKs46w9lMrVui63XUDJ7K9aXHu2WOozx7lrYuV+IXsJu2VlhxS4XyU
	u4glZ6dWYbxZOJEu7CnWFfbA6D7Hd50=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1742404036;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7XDC4SfHDNBOwpQe1A7tca/PZWgtJvOp4dCJtUB3U50=;
	b=MR4mcUKdz4mwrlLwN42TP2CKa5xpxybAgZD3hl7BnF9ft0NbrVNzoFrHmuUd50i7+2k/l6
	SRZ7FW9DmCT4WhCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D18B013A2C;
	Wed, 19 Mar 2025 17:07:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CbinMsP52mcQagAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 19 Mar 2025 17:07:15 +0000
Date: Wed, 19 Mar 2025 18:07:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Sidong Yang <sidong.yang@furiosa.ai>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: (subset) [RFC PATCH v5 0/5] introduce
 io_uring_cmd_import_fixed_vec
Message-ID: <20250319170710.GK32661@suse.cz>
Reply-To: dsterba@suse.cz
References: <20250319061251.21452-1-sidong.yang@furiosa.ai>
 <174239798984.85082.13872425373891225169.b4-ty@kernel.dk>
 <f78c156e-8712-4239-b17f-d917be03226a@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f78c156e-8712-4239-b17f-d917be03226a@kernel.dk>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -2.50
X-Spamd-Result: default: False [-2.50 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid,suse.cz:replyto];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[toxicpanda.com,suse.com,gmail.com,furiosa.ai,vger.kernel.org];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On Wed, Mar 19, 2025 at 09:27:37AM -0600, Jens Axboe wrote:
> On 3/19/25 9:26 AM, Jens Axboe wrote:
> > 
> > On Wed, 19 Mar 2025 06:12:46 +0000, Sidong Yang wrote:
> >> This patche series introduce io_uring_cmd_import_vec. With this function,
> >> Multiple fixed buffer could be used in uring cmd. It's vectored version
> >> for io_uring_cmd_import_fixed(). Also this patch series includes a usage
> >> for new api for encoded read/write in btrfs by using uring cmd.
> >>
> >> There was approximately 10 percent of performance improvements through benchmark.
> >> The benchmark code is in
> >> https://github.com/SidongYang/btrfs-encoded-io-test/blob/main/main.c
> >>
> >> [...]
> > 
> > Applied, thanks!
> > 
> > [1/5] io_uring: rename the data cmd cache
> >       commit: 575e7b0629d4bd485517c40ff20676180476f5f9
> > [2/5] io_uring/cmd: don't expose entire cmd async data
> >       commit: 5f14404bfa245a156915ee44c827edc56655b067
> > [3/5] io_uring/cmd: add iovec cache for commands
> >       commit: fe549edab6c3b7995b58450e31232566b383a249
> > [4/5] io_uring/cmd: introduce io_uring_cmd_import_fixed_vec
> >       commit: b24cb04c1e072ecd859a98b2e4258ca8fe8d2d4d
> 
> 1-4 look pretty straight forward to me - I'll be happy to queue the
> btrfs one as well if the btrfs people are happy with it, just didn't
> want to assume anything here.

For 6.15 is too late so it makes more sense to take it through the btrfs
patches targetting 6.16.

