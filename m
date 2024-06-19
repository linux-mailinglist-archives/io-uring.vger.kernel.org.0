Return-Path: <io-uring+bounces-2276-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BB6FC90F166
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 16:55:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65C981F21562
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 14:55:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 417F839AEC;
	Wed, 19 Jun 2024 14:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QP6qPFBl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="z0mHM3Wk";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QP6qPFBl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="z0mHM3Wk"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0CC25569
	for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 14:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718808950; cv=none; b=b+o5Wg2k4FpeBg+gfUwOPMIs2TGk4Dk9pONw3uEADE4IqoTA/bc7N66u7qeFD5HYoT+SiCDK6AhOwNA/HwUkkr1ZU3kk1MxPhkxUD/WFYzwg0BtQq02FhTYZVAXvFMwoAhvb559kByDkENfTXlVw36dywWxrTMznzjifSzGkCyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718808950; c=relaxed/simple;
	bh=n7w4a7tY/nP+7coxtlI2b0nYXrMWc0TrWUoadFuEC50=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hAm2wafcCSjDf24OsYW3bBGwPMglgTCt6917CixdQePPlwyDLTrL2IjfYOSDdhtbApCNJa2UaH0DC5nhdRXdarpjzS31xaWuu7sDDIUt0YW1yhGTV/bxl1hUQYxRoxBMT2fEmdK+VlP/EF1vYBcIFTCgYIqcgdBQEjc+InEQl7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QP6qPFBl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=z0mHM3Wk; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QP6qPFBl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=z0mHM3Wk; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0560321A21;
	Wed, 19 Jun 2024 14:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718808941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YKd3OlQmbRQDeTAJnnN2Yb2LGwCpJPiOe222s9AYLK4=;
	b=QP6qPFBlVWkwGQyQkXn36xu9chFjePHmQARb+OSaJD+XvwSYkrrdO8CbnG8vGtN8N9Y0FL
	CkRLRSn1sRFeNMo+uXPvPfUIlzn7tptNyY0a/uGmOPgda0V52On5NXeNFBz9ITeZVdUg8R
	uu3w2gAWgFszn9z61PRl2+g7+vvi/A8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718808941;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YKd3OlQmbRQDeTAJnnN2Yb2LGwCpJPiOe222s9AYLK4=;
	b=z0mHM3Wkhi4aTZmrWdpcjq7Y3chhsOGwAxI6edvSLvHDpDuE2YgkCUlMHVv4s47217OpbN
	Mk45MxhnI/5CLXDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718808941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YKd3OlQmbRQDeTAJnnN2Yb2LGwCpJPiOe222s9AYLK4=;
	b=QP6qPFBlVWkwGQyQkXn36xu9chFjePHmQARb+OSaJD+XvwSYkrrdO8CbnG8vGtN8N9Y0FL
	CkRLRSn1sRFeNMo+uXPvPfUIlzn7tptNyY0a/uGmOPgda0V52On5NXeNFBz9ITeZVdUg8R
	uu3w2gAWgFszn9z61PRl2+g7+vvi/A8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718808941;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YKd3OlQmbRQDeTAJnnN2Yb2LGwCpJPiOe222s9AYLK4=;
	b=z0mHM3Wkhi4aTZmrWdpcjq7Y3chhsOGwAxI6edvSLvHDpDuE2YgkCUlMHVv4s47217OpbN
	Mk45MxhnI/5CLXDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BB49713668;
	Wed, 19 Jun 2024 14:55:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HDz8JmzxcmaaGQAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 19 Jun 2024 14:55:40 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 3/3] io_uring: Don't read userspace data in io_probe
In-Reply-To: <007e7816-64dc-4f3a-b35a-5fed4625c697@kernel.dk> (Jens Axboe's
	message of "Wed, 19 Jun 2024 07:44:26 -0600")
Organization: SUSE
References: <20240619020620.5301-1-krisman@suse.de>
	<20240619020620.5301-4-krisman@suse.de>
	<007e7816-64dc-4f3a-b35a-5fed4625c697@kernel.dk>
Date: Wed, 19 Jun 2024 10:55:39 -0400
Message-ID: <87plsdhthw.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.994];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]

Jens Axboe <axboe@kernel.dk> writes:

> On 6/18/24 8:06 PM, Gabriel Krisman Bertazi wrote:
>> We don't need to read the userspace buffer, and the kernel side is
>> expected to write over it anyway.  Perhaps this was meant to allow
>> expansion of the interface for future parameters?  If we ever need to do
>> it, perhaps it should be done as a new io_uring opcode.
>
> Right, it's checked so that we could use it for input values in the
> future. By ensuring that userspace must zero it, then we could add input
> values and flags in the future.
>
> Is there a good reason to make this separate change? If not, I'd say
> drop it and we can always discuss when there's an actual need to do so.
> At least we have the option of passing in some information with the
> current code, in a backwards compatible fashion.

There is no reason other than it is unused.  I'm fine with dropping it.

I'll wait for feedback on the other patches and, if we need a new
iteration, I'll skip this one.

Thanks!

-- 
Gabriel Krisman Bertazi

