Return-Path: <io-uring+bounces-9687-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8778DB504D7
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 20:07:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0BD25E4B6D
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 18:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C5FF35CEB0;
	Tue,  9 Sep 2025 18:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FiLdhniQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FFP/lEH2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FiLdhniQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FFP/lEH2"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615D334F465
	for <io-uring@vger.kernel.org>; Tue,  9 Sep 2025 18:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757441221; cv=none; b=Tz1ScHrYrlLrG2tEkEZrHqtLI2pnDBzB2xJva+2cwEMMdDqtSfdcI1oMiHZlQgOub+nW4qNj+bb+Jfc/WKAdJvsIyEqvwxHEarbxFXiKWQkdWmCRmbLak61Q0x96jb8Yv2aXOubagLhpNhPGB0do8lw8+gF+8xcttKPod9aMD0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757441221; c=relaxed/simple;
	bh=1PGprpfw/ha2Cq6RMLaVXkraMIMn0M/ii1ffuvUq1H0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r0C5Lot3aMB+9UDrMdG68HiFqmYlkbXYjmDbI3bT6oW8RsLqqVJXxNo5ekIK0Adrj/6z6/8S4NMXu9z9ktuMVmkj42wVM7ig6i6/3Zwga+Rur4cVJKiVVAa8PQmD9AEpIFEYIauvdSCUz9863KKaUPp9taMff9CEyDUblO2jpYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FiLdhniQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FFP/lEH2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FiLdhniQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FFP/lEH2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 26AD822836;
	Tue,  9 Sep 2025 18:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757441217; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Am4xHpo/hojedBhPG2np8vTsGSiJVEKAPLsh1JPU6oY=;
	b=FiLdhniQtrLIz53MsZl5csVCv5a2tf0V8r4Ll6fkCYQbk/+owb/xFe93EGdB2Yqi3ZD+kQ
	mPU2eUSSGPUCJzyCMWSQFKAJIMIwESXJSKzEjSCizKs2ZbjgZERFN3pUE0lzzPC77Gckt3
	3RkHI5AS1jo7JPWWQu1PU+Yqcg3SQ+c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757441217;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Am4xHpo/hojedBhPG2np8vTsGSiJVEKAPLsh1JPU6oY=;
	b=FFP/lEH2QrOiAX3hhEykprIiCeIQqB+kDG+a7451AKeAGzmNvJO4UlE/R+9eQQIIlvLrfk
	26UdF1hFwAVA4gAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757441217; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Am4xHpo/hojedBhPG2np8vTsGSiJVEKAPLsh1JPU6oY=;
	b=FiLdhniQtrLIz53MsZl5csVCv5a2tf0V8r4Ll6fkCYQbk/+owb/xFe93EGdB2Yqi3ZD+kQ
	mPU2eUSSGPUCJzyCMWSQFKAJIMIwESXJSKzEjSCizKs2ZbjgZERFN3pUE0lzzPC77Gckt3
	3RkHI5AS1jo7JPWWQu1PU+Yqcg3SQ+c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757441217;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Am4xHpo/hojedBhPG2np8vTsGSiJVEKAPLsh1JPU6oY=;
	b=FFP/lEH2QrOiAX3hhEykprIiCeIQqB+kDG+a7451AKeAGzmNvJO4UlE/R+9eQQIIlvLrfk
	26UdF1hFwAVA4gAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 053671365E;
	Tue,  9 Sep 2025 18:06:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uFuEO8BswGiZNQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 09 Sep 2025 18:06:56 +0000
Message-ID: <e09555bc-4b0f-4f3a-82a3-914f38c3cde5@suse.cz>
Date: Tue, 9 Sep 2025 20:06:56 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Jens Axboe <axboe@kernel.dk>
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
 Jakub Kicinski <kuba@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 dan.j.williams@intel.com, Caleb Sander Mateos <csander@purestorage.com>,
 io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
 <5922560.DvuYhMxLoT@rafael.j.wysocki> <20250909071818.15507ee6@kernel.org>
 <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk>
 <20250909-green-oriole-of-speed-85cd6d@lemur>
 <497c9c10-3309-49b9-8d4f-ff0bc34df4e5@suse.cz>
 <be98399d-3886-496e-9cf4-5ec909124418@kernel.dk>
 <CAHk-=whP2zoFm+-EmgQ69-00cxM5jgoEGWyAYVQ8bQYFbb2j=Q@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAHk-=whP2zoFm+-EmgQ69-00cxM5jgoEGWyAYVQ8bQYFbb2j=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[kernel.dk:email,imap1.dmz-prg2.suse.org:helo,msgid.link:url,suse.cz:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 9/9/25 18:40, Linus Torvalds wrote:
> On Tue, 9 Sept 2025 at 07:50, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> I think we all know the answer to that one - it would've been EXACTLY
>> the same outcome. Not to put words in Linus' mouth, but it's not the
>> name of the tag that he finds repulsive, it's the very fact that a link
>> is there and it isn't useful _to him_.
> 
> It's not that it isn't "useful to me". It's that it HURTS, and it's
> entirely redundant.
> 
> It literally wastes my time. Yes, I have the option to ignore them,
> but then I ignore potentially *good* links.
> 
> Rafael asked what the difference between "Fixes:" and "Cc: stable" is
> - it's exactly the fact that those do NOT waste human time, and they
> were NOT automated garbage.
> 
> The rules for those are that they have been added *thoughtfully*: you
> don't add 'stable' with automation without even thinking about it, do
> you?
> 
> And if you did, THAT WOULD BE WRONG TOO.
> 
> Wouldn't you agree?

I fully agree. Now the sad part of this example is that if one conciously
decides that the bug fixed is not critical enough according to the
documented stable rules, and doesn't add Cc: stable, there's a good chance
the AUTOSEL automation will pick it anyway, these days with a help of LLM.
> Dammit, is it really so hard to understand this issue? Automated noise
> is bad noise. And when it has a human cost, it needs to go away.
> 
> I'm not saying that you can't link to the original email. But you need
> to STOP THE MINDLESS AUTOMATION WHEN IT HURTS.
> 
> So add the link, by all means - but only add it when it is relevant
> and gives real information. And THINK about it, don't have it in some
> mindless script.

I'd hope that distinguishing the automated links from conscious one (i.e.
using the patch.msgid.link vs lore domains) would be enough to make everyone
happy without hurting. But fine.
> Because if it's in a mindless script, then dammit, the lore "search"
> function is objectively better after-the-fact. Really. Using the lore
> search gives the original email *and* more.
> 
> The same, btw, goes for my merge messages. No, I'm not going to add
> some idiotic "Link" to the original pull request email. Not only don't
> I fetch those from lore to begin with, you can literally search for
> them.
> 
> Look here, for the latest merge I did of your tree: e9eaca6bf69d.
Later in the thread patch-id is mentioned. I think it was mentioned in the
past threads that due to small context changes due to e.g. base that the
submitter used and the maintainer used to apply, and even diff algorithm not
being set in stone, they can't be made fully reliable?

