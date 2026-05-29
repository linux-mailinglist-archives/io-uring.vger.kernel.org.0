Return-Path: <io-uring+bounces-13559-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cB39KbsvGWq9sQgAu9opvQ
	(envelope-from <io-uring+bounces-13559-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 08:18:35 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 254505FDD5D
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 08:18:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7BB6130C4309
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 06:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C55436B07C;
	Fri, 29 May 2026 06:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bkzkhmIP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TZYlZ58k";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bkzkhmIP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TZYlZ58k"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621DD3A4F26
	for <io-uring@vger.kernel.org>; Fri, 29 May 2026 06:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780035453; cv=none; b=aOjtpwsvuExUn8101f5MFyFglFqlM1HNeuCNGyXe5Hz9Szv/a2ePbDatqDyXXikU0N1hrt0GSSpMyUrfqqqeA8WUVeQ/6C45Y4hocvZTZLMvu4ZUQ/jITY43I3nMCLs1eQD+E71FG7gO8BhDkAfsJBR82RZPD+ulxaMujH67LCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780035453; c=relaxed/simple;
	bh=d3FthbysvdYGqF8sr0529bBGtAtX9C2m+qzX+bsOnkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dTsb5tc+o8sApGRZ0SgdcxvG07edvuHOB9oFCznz9FVCR8blVH6ATPweeSv0kZldG6q8/CJ2JfNZANyJoiwmfooxIEyOfsy99ZXkMibIOzUXAki1s3rSGvLHfy3njh31Zuk/Ir2UHC67vAF3NiCHL/YnQYms2R4hOnGs4EVqLOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bkzkhmIP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TZYlZ58k; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bkzkhmIP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TZYlZ58k; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D3F546ADFC;
	Fri, 29 May 2026 06:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780035443; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vx4YswAc1yVXQsKvAiXfezzli9FVMB1COPrkwMvq7mk=;
	b=bkzkhmIPM1k+uqvO/DWR4X7xY2psViNf1K6x+RYuE0JEAMkYqTRFzbrdr/tb5EkDHjvqB+
	hNFu7KEcAE4gm1p9r0DzoLHly45JBcg+alpe0MLpMg8L6ftQv7QAMElPgG9sHnRlBpE3Zk
	5fAjjZRzKrXK8DmV5hKllJ8iiBO8zk0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780035443;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vx4YswAc1yVXQsKvAiXfezzli9FVMB1COPrkwMvq7mk=;
	b=TZYlZ58k999uRr99rmYwif3aPsN6aYeks/D3M/sevnjYUb/Z7jUJN+zYJU3AmoyDjz+fpH
	YZa8vidu0Oav2sAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780035443; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vx4YswAc1yVXQsKvAiXfezzli9FVMB1COPrkwMvq7mk=;
	b=bkzkhmIPM1k+uqvO/DWR4X7xY2psViNf1K6x+RYuE0JEAMkYqTRFzbrdr/tb5EkDHjvqB+
	hNFu7KEcAE4gm1p9r0DzoLHly45JBcg+alpe0MLpMg8L6ftQv7QAMElPgG9sHnRlBpE3Zk
	5fAjjZRzKrXK8DmV5hKllJ8iiBO8zk0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780035443;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vx4YswAc1yVXQsKvAiXfezzli9FVMB1COPrkwMvq7mk=;
	b=TZYlZ58k999uRr99rmYwif3aPsN6aYeks/D3M/sevnjYUb/Z7jUJN+zYJU3AmoyDjz+fpH
	YZa8vidu0Oav2sAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8D2B05B1C5;
	Fri, 29 May 2026 06:17:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5dFCIXMvGWorFAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 29 May 2026 06:17:23 +0000
Message-ID: <4f02694e-1d99-473f-8ce4-2b263efe8138@suse.de>
Date: Fri, 29 May 2026 08:17:23 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] block: Include bvec.h kernel-doc in the htmldocs
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-mm@kvack.org,
 Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@infradead.org>
References: <20260528175905.1102280-1-willy@infradead.org>
 <20260528175905.1102280-3-willy@infradead.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260528175905.1102280-3-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13559-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hare@suse.de,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.de:dkim,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,infradead.org:email]
X-Rspamd-Queue-Id: 254505FDD5D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/28/26 19:59, Matthew Wilcox (Oracle) wrote:
> People have gone to the trouble of writing this kernel-doc; the
> least we can do is publish it.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   Documentation/core-api/kernel-api.rst | 1 +
>   include/linux/bvec.h                  | 2 ++
>   2 files changed, 3 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

