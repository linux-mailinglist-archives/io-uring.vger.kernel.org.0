Return-Path: <io-uring+bounces-4832-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E42E9D29A9
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 16:31:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12AA61F22979
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 15:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C5B1CF289;
	Tue, 19 Nov 2024 15:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qSOqgih9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wEkuTctc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qSOqgih9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wEkuTctc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55964199B9
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 15:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732030304; cv=none; b=CNvGjocKV/Cg6wiNflnS+JYN+b9L/jAyxmEb1gCZ5Ks0wh6C0vWy/UExIXdswxvjXPXnTl+l1ncFc25RH84P7XgFG/64dTzJaoTNZEM2RPwcWk2jAWEXtqfmQX30A0hnHK/WrTjFK2nj0DDDFZEqJuLbBBeHwL8sspC/+0oTIBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732030304; c=relaxed/simple;
	bh=dAPjbMPL1ddG2QbILwlEE76sqM5yvxwoZ/5dmuRmVaw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GwIgE+zvEP0JEt0K8SYZCvWyKlGBmi4Cbbw563PFp+LFkrzY1ereNgHkKQrXaeju7o9YIQ7rs5A0zLBxbI+IyW3BSkMBKhsEVQLBePClytPdjKwqm5oZp5Lc8jAsDR1gNm+eOw7Xhdc2NPTtSoGsffeCaH9p8ea6NQyoBFt2OkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qSOqgih9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wEkuTctc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qSOqgih9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wEkuTctc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7FC6F1F79C;
	Tue, 19 Nov 2024 15:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732030295; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XCV1MfAjizmHSps46DuMBh7IM/MfoaUYwtwuY7V9RrE=;
	b=qSOqgih9WNcraP6h9kd466U2w0fewYTVc5r+yuzS3ZsvgyNPUWUCfLQl4cLDoByIew6+Fy
	JRMh4IY1UZVl4/hFo01UAoJdnWJ/6FcvGgxK4fEtQCjPMdMilhKBF1Jl8jjLJojN+Pet8G
	EdDsAjkygEE964EB6SD6z+BuR9m/GbI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732030295;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XCV1MfAjizmHSps46DuMBh7IM/MfoaUYwtwuY7V9RrE=;
	b=wEkuTctcnwvmRgI2wqGESd53F2gCXcKhFABVQ9C3cujvh38H7OxMSpf21v0NOPwJ/CzPQk
	pHoCl5jiZcNdz1DQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732030295; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XCV1MfAjizmHSps46DuMBh7IM/MfoaUYwtwuY7V9RrE=;
	b=qSOqgih9WNcraP6h9kd466U2w0fewYTVc5r+yuzS3ZsvgyNPUWUCfLQl4cLDoByIew6+Fy
	JRMh4IY1UZVl4/hFo01UAoJdnWJ/6FcvGgxK4fEtQCjPMdMilhKBF1Jl8jjLJojN+Pet8G
	EdDsAjkygEE964EB6SD6z+BuR9m/GbI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732030295;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XCV1MfAjizmHSps46DuMBh7IM/MfoaUYwtwuY7V9RrE=;
	b=wEkuTctcnwvmRgI2wqGESd53F2gCXcKhFABVQ9C3cujvh38H7OxMSpf21v0NOPwJ/CzPQk
	pHoCl5jiZcNdz1DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 45CB213736;
	Tue, 19 Nov 2024 15:31:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MBi/ClevPGdvIwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 19 Nov 2024 15:31:35 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: asml.silence@gmail.com,  io-uring@vger.kernel.org
Subject: Re: [PATCH 0/9] Clean up alloc_cache allocations
In-Reply-To: <96b28c66-53c5-4c98-97e4-b2236fae69b5@kernel.dk> (Jens Axboe's
	message of "Mon, 18 Nov 2024 19:05:12 -0700")
Organization: SUSE
References: <20241119012224.1698238-1-krisman@suse.de>
	<96b28c66-53c5-4c98-97e4-b2236fae69b5@kernel.dk>
Date: Tue, 19 Nov 2024 10:31:29 -0500
Message-ID: <87plmrnstq.fsf@mailhost.krisman.be>
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
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	HAS_ORG_HEADER(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,kernel.dk:email]
X-Spam-Flag: NO
X-Spam-Level: 

Jens Axboe <axboe@kernel.dk> writes:

> On 11/18/24 6:22 PM, Gabriel Krisman Bertazi wrote:
>> Jens, Pavel,
>> 
>> The allocation paths that use alloc_cache duplicate the same code
>> pattern, sometimes in a quite convoluted way.  This series cleans up
>> that code by folding the allocation into the cache code itself, making
>> it just an allocator function, and keeping the cache policy invisible to
>> callers.  A bigger justification for doing this, beyond code simplicity,
>> is that it makes it trivial to test the impact of disabling the cache
>> and using slab directly, which I've used for slab improvement
>> experiments.  I think this is one step forward in the direction
>> eventually lifting the alloc_cache into a proper magazine layer in slab
>> out of io_uring.
>
> Nice!
>
> Patchset looks good, from a quick look, even from just a cleanup
> perspective. We're obviously inside the merge window right now, so it's
> a 6.14 target at this point. I'll take some timer to review it a bit
> closer later this week.
>
>> It survived liburing testsuite, and when microbenchmarking the
>> read-write path with mmtests and fio, I didn't observe any significant
>> performance variation (there was actually a 2% gain, but that was
>> within the variance of the test runs, making it not signficant and
>> surely test noise).
>> 
>> I'm specifically interested, and happy to do so, if there are specific
>> benchmarks you'd like me to run it against.
>
> In general, running the liburing test suite with various types of files
> and devices and with KASAN and LOCKDEP turned on is a good test of not
> having messed something up, in a big way at least. But maybe you already
> ran that too?

I was thinking more of extra performance benchmark, but I always forget to
enable KASAN.  I'll rerun to confirm it is fine. :)

thanks,



-- 
Gabriel Krisman Bertazi

