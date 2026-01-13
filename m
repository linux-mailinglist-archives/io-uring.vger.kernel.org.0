Return-Path: <io-uring+bounces-11612-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 97461D1A9BE
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 18:27:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9831D300A345
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 17:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8583502A5;
	Tue, 13 Jan 2026 17:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Lmx6LW+e";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4aqn/czM";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Lmx6LW+e";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4aqn/czM"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8921B2E764C
	for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 17:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768325241; cv=none; b=AhQAP/AX8vRAAhS4gzrE5m3XhBcox87KsKdzT1ArP9+giy2oQL2OizrxvsLXQ9jHLXWGONnRNYOA2pF6hUow0j5gAuin5aW9fnGtTFv1x2otZO2fc//A5oF9YxnuJCIOpy+u2lKx7+isIWRHHRblZU659zeLT/ape9+VT9dKah8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768325241; c=relaxed/simple;
	bh=T74WqNdhPsU8irP3LIyjbPXSGY6BREMdW6B7tI2JJlI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OpqedM/huwKz1hXykufDM5cQxW75eGhliyOEdRTjEAWmiDfzV5HPVeU8cb/GaFJOyzKTAEVyEA/Aj7yXM3izOwX9Pq+qcLqUkqR8lyzQ3Rif0HNqWX/nTtLdvno4iADZOTr6TjmNw93nYXdnzrsacKYDOIQtu3AAqO2EcleG8nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Lmx6LW+e; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4aqn/czM; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Lmx6LW+e; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4aqn/czM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 904C75BCCA;
	Tue, 13 Jan 2026 17:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768325236; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2OcrpZYe9PiOS1Iu1Dog7Pn/+NymNnX6HuserR98sCw=;
	b=Lmx6LW+ejIF3D7iHL4EnVOHkskx4jis5Q0PTedfDinaad0FhDnid+qH+2gUHuKnZJp2AZM
	0cRPKrfQi+GPadnrjKPVJv/ZFf3twNlGWgkFObjnokqmTl6Y8b562xi1ebxR/7t/8PUzDD
	tdovgAhN9AtkflZOFwohXizt6cYrxUM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768325236;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2OcrpZYe9PiOS1Iu1Dog7Pn/+NymNnX6HuserR98sCw=;
	b=4aqn/czM2MYy6op77006qe03KPSAPvdh3AggkfeSjO7b6n0KpitMHxbmkbysFd3G6kvcqR
	7VHmcPryM7DXMQCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768325236; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2OcrpZYe9PiOS1Iu1Dog7Pn/+NymNnX6HuserR98sCw=;
	b=Lmx6LW+ejIF3D7iHL4EnVOHkskx4jis5Q0PTedfDinaad0FhDnid+qH+2gUHuKnZJp2AZM
	0cRPKrfQi+GPadnrjKPVJv/ZFf3twNlGWgkFObjnokqmTl6Y8b562xi1ebxR/7t/8PUzDD
	tdovgAhN9AtkflZOFwohXizt6cYrxUM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768325236;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2OcrpZYe9PiOS1Iu1Dog7Pn/+NymNnX6HuserR98sCw=;
	b=4aqn/czM2MYy6op77006qe03KPSAPvdh3AggkfeSjO7b6n0KpitMHxbmkbysFd3G6kvcqR
	7VHmcPryM7DXMQCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 515ED3EA63;
	Tue, 13 Jan 2026 17:27:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nvIMDXSAZmkrfwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 13 Jan 2026 17:27:16 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCHSET 0/5] io_uring restrictions cleanups and improvements
In-Reply-To: <20260112151905.200261-1-axboe@kernel.dk> (Jens Axboe's message
	of "Mon, 12 Jan 2026 08:14:40 -0700")
References: <20260112151905.200261-1-axboe@kernel.dk>
Date: Tue, 13 Jan 2026 12:27:06 -0500
Message-ID: <87v7h52zkl.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,mailhost.krisman.be:mid,kernel.dk:email,suse.de:email];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO

Jens Axboe <axboe@kernel.dk> writes:

> Hi,
>
> In doing the task based restriction sets, I found myself doing a few
> cleanups and improvements along the way. These really had nothing to
> do with the added feature, hence I'm splitting them out into a
> separate patchset.
>
> This series is really 4 patches doing cleanup and preparation for
> making it easier to add the task based restrictions, and patch 5 is
> an improvement for how restrictions are checked. I ran some overhead
> numbers and it's honestly surprisingly low for microbenchmarks. For
> example, running a pure NOP workload at 13-15M op/sec, checking
> restrictions is only about 1.5% of the CPU time. Never the less, I
> suspect the most common restrictions applied is to limit the register
> operations that can be done. Hence it makes sense to track whether
> we have IORING_OP* or IORING_REGISTER* restrictions separately, so
> it can be avoided to check ones op based restrictions if only register
> based ones have been set.

Looks good to me.

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>


-- 
Gabriel Krisman Bertazi

