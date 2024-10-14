Return-Path: <io-uring+bounces-3647-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 825E999C125
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 09:23:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38DAE28172B
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 07:23:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7873E1482E7;
	Mon, 14 Oct 2024 07:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="H52ysEnd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u7ZeLjm8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="H52ysEnd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u7ZeLjm8"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6952147C79;
	Mon, 14 Oct 2024 07:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728890598; cv=none; b=r4jO8ITB3rQZb1yKhgCmVglMq3NqV3sJ6MHW5IAze5M7baWEnIHJnD10B9vvKHDNZILAuGgU3T+2oJ9QGvo1/NFjvQxUevG0uX5/5/7wEw/zhFvdmHkDe6rA5vufdbY6BnNnAUI6hgZGHz/w/kWgMoef5F1jDW3owQmgjgYmd0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728890598; c=relaxed/simple;
	bh=nUptIs5JX0n5QlfYndHLd2APG2v84RKY+QebMe1xhrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ps6bbOYz/snSnhNz99RtAoWo/ZTz+coAgFCWxkUa2J/NZ8GeY6xYh6hLWnQpud+Ue3sbw+7RdCzlgW6EzWzP4GmWaaAP+CF7g3/bGZUzrCR/RVEQ4HiSqkrEkEL2rHMNpGkUQJtiX8yiiWevpAq+Yd2I++cy9QMDnCCeOCHq6Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=H52ysEnd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u7ZeLjm8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=H52ysEnd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u7ZeLjm8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 084FB21E38;
	Mon, 14 Oct 2024 07:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1728890595; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=duGxDXXdZAawpa7Nko+oty9RNyuPyJvZapFJEqETSOg=;
	b=H52ysEndLGIFPwpFNewgvUeCtgBorw4715nluU3dSU5jdx8Rb8LvxYrE3V7GL0I/+hGuqe
	NIRvI3VZ/DDxw/ifozCil4lbElXFFwWnDXPIrk4KcW8y6gxUzRkSsXkhjE0/76Gu5kWauV
	eDt3MaszL4CJ0Vi5fN00wcefOg2XG+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1728890595;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=duGxDXXdZAawpa7Nko+oty9RNyuPyJvZapFJEqETSOg=;
	b=u7ZeLjm89eHdB9Ki4R6rmHu3ERra/IcUGowoXny5IK6dUyhTKECDeZkP1cl4D9yu9V4LJ5
	/NMOiIy+OM2cp/BA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=H52ysEnd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=u7ZeLjm8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1728890595; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=duGxDXXdZAawpa7Nko+oty9RNyuPyJvZapFJEqETSOg=;
	b=H52ysEndLGIFPwpFNewgvUeCtgBorw4715nluU3dSU5jdx8Rb8LvxYrE3V7GL0I/+hGuqe
	NIRvI3VZ/DDxw/ifozCil4lbElXFFwWnDXPIrk4KcW8y6gxUzRkSsXkhjE0/76Gu5kWauV
	eDt3MaszL4CJ0Vi5fN00wcefOg2XG+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1728890595;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=duGxDXXdZAawpa7Nko+oty9RNyuPyJvZapFJEqETSOg=;
	b=u7ZeLjm89eHdB9Ki4R6rmHu3ERra/IcUGowoXny5IK6dUyhTKECDeZkP1cl4D9yu9V4LJ5
	/NMOiIy+OM2cp/BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A1EFE13A51;
	Mon, 14 Oct 2024 07:23:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SF7sJeLGDGdeXAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 14 Oct 2024 07:23:14 +0000
Message-ID: <426b5600-7489-43a7-8007-ac4d9dbc9aca@suse.de>
Date: Mon, 14 Oct 2024 09:23:14 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Report] annoyed dma debug warning "cacheline tracking EEXIST,
 overlapping mappings aren't supported"
To: Ming Lei <ming.lei@redhat.com>,
 Hamza Mahfooz <someguy@effective-light.com>, Christoph Hellwig <hch@lst.de>,
 Dan Williams <dan.j.williams@intel.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org,
 linux-raid@vger.kernel.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <ZwxzdWmYcBK27mUs@fedora>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <ZwxzdWmYcBK27mUs@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 084FB21E38
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 10/14/24 03:27, Ming Lei wrote:
> Hello Guys,
> 
> I got more and more reports on DMA debug warning "cacheline tracking EEXIST,
> overlapping mappings aren't supported" in storage related tests:
> 
> 1) liburing
> - test/iopoll-overflow.t
> - test/sq-poll-dup.t
> 
> Same buffer is used in more than 1 IO.
> 
> 2) raid1 driver
> 
> - same buffer is used in more than 1 bio
> 
> 3) some storage utilities
> - dm thin provisioning utility of thin_check
> - `dt`(https://github.com/RobinTMiller/dt)
> 
> I looks like same user buffer is used in more than 1 dio.
> 
> 4) some self cooked test code which does same thing with 1)
> 
> In storage stack, the buffer provider is far away from the actual DMA
> controller operating code, which doesn't have the knowledge if
> DMA_ATTR_SKIP_CPU_SYNC should be set.
> 
> And suggestions for avoiding this noise?
> 
Can you check if this is the NULL page? Operations like 'discard' will 
create bios with several bvecs all pointing to the same NULL page.
That would be the most obvious culprit.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


