Return-Path: <io-uring+bounces-5304-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E59259E8D5B
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 09:27:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FB0C282645
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 08:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 335EA215191;
	Mon,  9 Dec 2024 08:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UiK7P4nS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UsRaztyf";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UiK7P4nS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UsRaztyf"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8101C374EA;
	Mon,  9 Dec 2024 08:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733732867; cv=none; b=bylCg5T6Bm5suUid7l8RMEXLEbR6ujay1lxL+PTU7eJaZgnDom0Zj6UXTGGS5cjflnSsgeYO6H+mjkmxgUGEKPLaUjwQy1tzMnK/r+OwA/ygwiMJ1o9jcsLzQJndpLTVVNTv0vmCLh1na8chBok8lgva1mztNFOROv+UZzqNv1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733732867; c=relaxed/simple;
	bh=L1Kle1p8gw3b4xRLAnJprHGjpqHEOAP8LLmQuZtMSNk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xx43swmAw1Fyz+NQ4DFoIYpVLuOllmUgZv7Opg7utx/41G7pJHo5S65pf495qiRstVHdGi20TEcYybBFIhFB5sVjhELmpSzfgwCP2JOlKbhZqztI//cEeLH1dpDpx8jb0ux6jhE9zKPnbsSytzwquRf+TwF4EBB6SvIeY2aHrmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UiK7P4nS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UsRaztyf; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UiK7P4nS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UsRaztyf; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0015A21160;
	Mon,  9 Dec 2024 08:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733732864; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mERKmteGMVMhlEcxx4GuYhnsdA7nWRdbAD9zSTOjz/o=;
	b=UiK7P4nSoX6587tH70cGOP7kiSyI/jLorzPyzeqpJwzTFA6J5ncB4kt5FO/poE6CVCe3kB
	OwU1STMkzWREdX7l0L4U8HEBq42EEqzUmy+LeDD5QzQEkV6pBTyr30816jikRr7fEG5+N7
	aKjjugdgO1oCgfFcBe6mhTsOKYv6p3Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733732864;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mERKmteGMVMhlEcxx4GuYhnsdA7nWRdbAD9zSTOjz/o=;
	b=UsRaztyf3SnX1F2OOl3OB/1G7MEs2mDZzZEavVQeyR1zd8Kuv6ZYW9wOj/qeRIf0v3RYKq
	C9NQgAdFdRDehpAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733732864; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mERKmteGMVMhlEcxx4GuYhnsdA7nWRdbAD9zSTOjz/o=;
	b=UiK7P4nSoX6587tH70cGOP7kiSyI/jLorzPyzeqpJwzTFA6J5ncB4kt5FO/poE6CVCe3kB
	OwU1STMkzWREdX7l0L4U8HEBq42EEqzUmy+LeDD5QzQEkV6pBTyr30816jikRr7fEG5+N7
	aKjjugdgO1oCgfFcBe6mhTsOKYv6p3Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733732864;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mERKmteGMVMhlEcxx4GuYhnsdA7nWRdbAD9zSTOjz/o=;
	b=UsRaztyf3SnX1F2OOl3OB/1G7MEs2mDZzZEavVQeyR1zd8Kuv6ZYW9wOj/qeRIf0v3RYKq
	C9NQgAdFdRDehpAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9414C138D2;
	Mon,  9 Dec 2024 08:27:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 46FIIv+pVmc9DQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Dec 2024 08:27:43 +0000
Message-ID: <76facd58-e1a6-41bd-b4df-45c19683c05b@suse.de>
Date: Mon, 9 Dec 2024 09:27:43 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv12 04/12] block: introduce max_write_streams queue limit
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
 joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241206221801.790690-1-kbusch@meta.com>
 <20241206221801.790690-5-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241206221801.790690-5-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[grimberg.me,gmail.com,samsung.com,kernel.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid,lst.de:email]
X-Spam-Score: -2.80
X-Spam-Flag: NO

On 12/6/24 23:17, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Drivers with hardware that support write streams need a way to export how
> many are available so applications can generically query this.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> [hch: renamed hints to streams, removed stacking]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   Documentation/ABI/stable/sysfs-block | 7 +++++++
>   block/blk-sysfs.c                    | 3 +++
>   include/linux/blkdev.h               | 9 +++++++++
>   3 files changed, 19 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

