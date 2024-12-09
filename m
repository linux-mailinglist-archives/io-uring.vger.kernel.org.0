Return-Path: <io-uring+bounces-5301-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5403A9E8D4F
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 09:25:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F9F01884D46
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 08:25:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABFC11C2DA2;
	Mon,  9 Dec 2024 08:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PPt/YYW6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZQaSd4DY";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PPt/YYW6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZQaSd4DY"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C45A374EA;
	Mon,  9 Dec 2024 08:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733732732; cv=none; b=ko8diDmv2h5ipjABkfqVCzo2eKxeS0Jc3B7T4kXCs5zd/kVD0FQBpCzv+V159H8m3+y95gJXLabk2umIDwaBscF70mcuq1n0I2zBrL+sG1AtHBac5rYCqL5yvZa/hbNlAhWuxgVhBQ9aM/X866Dqd9Tloo/5zeOCdEfRdZQndh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733732732; c=relaxed/simple;
	bh=Gc4Rh3D9q34FmCY2at365wlpFJc6YyasNwMnOQ8NpmU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mKp2PDR3vFS5NIT7nFW8uDCjqWG4AVFtUKzp5xic6RDERNLOqKDXEJtmR8NHoce7xnZ2oS8Ag85RjNvfLyS+IW6LasknBlOy53A/1+qJfqFOY7KIXxZdsUXxvGqLYsU+yIHE/h6LnMTuP5e38VLQA8GEz+rd/nPBXr6X+uXjMJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PPt/YYW6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZQaSd4DY; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PPt/YYW6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZQaSd4DY; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 91C261F456;
	Mon,  9 Dec 2024 08:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733732728; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TFKE+E+UxKw2oElTi0jyOzJrNq1G2O/kUZF/FASzs/4=;
	b=PPt/YYW6hQ+KPRM5Vqjx1HZMUOdlSkHiwT9np59y/Z6sWLo1T9KQE+P4JUmMIIWyfwqikJ
	QZZhr9JmvjjqeopUiefTzDYhuYX4I9ylx0vnJrIVq/wnChPX5CoabKa3GSmSkZ8E5J9RCh
	FbSjyufw5LtnI7R7uU4Ad8k9oTKwLTk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733732728;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TFKE+E+UxKw2oElTi0jyOzJrNq1G2O/kUZF/FASzs/4=;
	b=ZQaSd4DYkezjVVNDCv/PRdfaeARmoC5+sz7xjnkzTM+5RhITlGMVnKtY2Fu9/yA1PGeiTt
	UQClv5NfMcVEeGAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="PPt/YYW6";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZQaSd4DY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733732728; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TFKE+E+UxKw2oElTi0jyOzJrNq1G2O/kUZF/FASzs/4=;
	b=PPt/YYW6hQ+KPRM5Vqjx1HZMUOdlSkHiwT9np59y/Z6sWLo1T9KQE+P4JUmMIIWyfwqikJ
	QZZhr9JmvjjqeopUiefTzDYhuYX4I9ylx0vnJrIVq/wnChPX5CoabKa3GSmSkZ8E5J9RCh
	FbSjyufw5LtnI7R7uU4Ad8k9oTKwLTk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733732728;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TFKE+E+UxKw2oElTi0jyOzJrNq1G2O/kUZF/FASzs/4=;
	b=ZQaSd4DYkezjVVNDCv/PRdfaeARmoC5+sz7xjnkzTM+5RhITlGMVnKtY2Fu9/yA1PGeiTt
	UQClv5NfMcVEeGAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2345A138D2;
	Mon,  9 Dec 2024 08:25:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fN3BBnipVmdrDAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Dec 2024 08:25:28 +0000
Message-ID: <cbfe5293-6315-4724-996d-507457b92b20@suse.de>
Date: Mon, 9 Dec 2024 09:25:27 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv12 01/12] fs: add write stream information to statx
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
 joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241206221801.790690-1-kbusch@meta.com>
 <20241206221801.790690-2-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241206221801.790690-2-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 91C261F456
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[grimberg.me,gmail.com,samsung.com,kernel.org];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 12/6/24 23:17, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Add new statx field to report the maximum number of write streams
> supported and the granularity for them.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> [hch: rename hint to stream, add granularity]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   fs/stat.c                 | 2 ++
>   include/linux/stat.h      | 2 ++
>   include/uapi/linux/stat.h | 7 +++++--
>   3 files changed, 9 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

