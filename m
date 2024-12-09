Return-Path: <io-uring+bounces-5309-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6091F9E8D80
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 09:33:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57CAC1645C3
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 08:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BAEB2156E2;
	Mon,  9 Dec 2024 08:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WyUjnvON";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+qfgpRmB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WyUjnvON";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+qfgpRmB"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8B8215187;
	Mon,  9 Dec 2024 08:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733733183; cv=none; b=ep9yttiBD/K6X7Nilsdh2CileOJREVm0CaKDhJeDi9FCkVucG4y7nun5pAmmorNifF1LK+AMEKLearT/UsGAFPTD2f8HXrE971JD9T3gYlMGamsd1Q5RiH7PXiUxUaUBpDe7ELzWDfOvgEMkQSgNk7njYBa6GAR9uEUO34N0Nm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733733183; c=relaxed/simple;
	bh=Q7ZndJQteRu8qyCWXDPHm+WJ+MuDkYqnnvBcgwiJbL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q3z+Mjn70Pvk7o0S3shFQmWEdryWGwl1P1yDI1txWJWQuT1A1Jin6JAiTa2AP4gkbpH/+pcJ01mzMyWwHdENr0eFpMhHglz8KvyySlt+E6RwflpcN1qZMxnU3INebShmWazjeIWaodf8Txz4gLOGI/KFVy1s1Xw97NvaDzi8VqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WyUjnvON; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+qfgpRmB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WyUjnvON; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+qfgpRmB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A42651F74A;
	Mon,  9 Dec 2024 08:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733733179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lmw4QapUG6CeNyZ2P7aDTzQNFPNIr8DPd/TJXXNF19Q=;
	b=WyUjnvONMa0HZJE/5xzZT5KVIW79E7tZF+zfaMu8kzTBaqXuixxRFcAQqoUKqWcsbmx5bL
	T9KRmPAqGaUf8S+a5bsPyZ3aMYoUZy2vjLDH+y+ynmK8LrWumDJtE+Au0Xi0Wr4krnSxEw
	rc1TQMN9IzV1JqDMgZDNt7nx/vxOL2o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733733179;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lmw4QapUG6CeNyZ2P7aDTzQNFPNIr8DPd/TJXXNF19Q=;
	b=+qfgpRmBw8Mh4hooaxjXbPY/tF+oJ+EYRdE2X33oTAYB6T+JnqUL5wgj8WEMaZTeXjsLrY
	EPX7vgZqEnVs0MAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733733179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lmw4QapUG6CeNyZ2P7aDTzQNFPNIr8DPd/TJXXNF19Q=;
	b=WyUjnvONMa0HZJE/5xzZT5KVIW79E7tZF+zfaMu8kzTBaqXuixxRFcAQqoUKqWcsbmx5bL
	T9KRmPAqGaUf8S+a5bsPyZ3aMYoUZy2vjLDH+y+ynmK8LrWumDJtE+Au0Xi0Wr4krnSxEw
	rc1TQMN9IzV1JqDMgZDNt7nx/vxOL2o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733733179;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lmw4QapUG6CeNyZ2P7aDTzQNFPNIr8DPd/TJXXNF19Q=;
	b=+qfgpRmBw8Mh4hooaxjXbPY/tF+oJ+EYRdE2X33oTAYB6T+JnqUL5wgj8WEMaZTeXjsLrY
	EPX7vgZqEnVs0MAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3075713B2E;
	Mon,  9 Dec 2024 08:32:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uqDrCTurVmcQDwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Dec 2024 08:32:59 +0000
Message-ID: <2a4ff5b5-43ba-4ef0-b53e-6d8a44bf2252@suse.de>
Date: Mon, 9 Dec 2024 09:32:58 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv12 09/12] nvme: pass a void pointer to
 nvme_get/set_features for the result
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
 joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241206221801.790690-1-kbusch@meta.com>
 <20241206221801.790690-10-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241206221801.790690-10-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,lst.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On 12/6/24 23:17, Keith Busch wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> That allows passing in structures instead of the u32 result, and thus
> reduce the amount of bit shifting and masking required to parse the
> result.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   drivers/nvme/host/core.c | 4 ++--
>   drivers/nvme/host/nvme.h | 4 ++--
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

