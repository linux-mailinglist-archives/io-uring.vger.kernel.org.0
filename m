Return-Path: <io-uring+bounces-7426-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D8C8A7E552
	for <lists+io-uring@lfdr.de>; Mon,  7 Apr 2025 17:56:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8E181647A1
	for <lists+io-uring@lfdr.de>; Mon,  7 Apr 2025 15:47:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 059CA2046A5;
	Mon,  7 Apr 2025 15:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AXRq69sg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zQaBbWwy";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AXRq69sg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zQaBbWwy"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033DB204694
	for <io-uring@vger.kernel.org>; Mon,  7 Apr 2025 15:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744040843; cv=none; b=qVM/cQXsx+u2U1U4/xPvFa0CA0jqC4R1w/TuRBPH7aqxlopqcAYXC9vMrsvgeTqEsDVS8U3ofxD3x1e3NMLcjPijpFV5+eBMHvqx/8hc6hkxjsM0q16iTJvnU9kNgRqyJqpsDpy/WGj/v+p6kJLGXJV5N4krp3Femz1TlWUQiog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744040843; c=relaxed/simple;
	bh=rT5jXoZiRcMb5i0/xzL6i+JDAqigTqjdHlcKFumKx10=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=CCrAUD+ubAeGcHcwBnTTMff3XnZIkLGcdxTjcYqc4Up8bLthkoN+28IPhHLM0MnRpyyMh3VheZnamdVmGFEzFEpPIKKsokmoF/cQUH8mw3FANnrcLhqXAqWnXDUtQd3NxIYh1yZ68Qctvysa1hZmlbg7Z3Z25C/LsHgG7W5CwOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AXRq69sg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zQaBbWwy; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AXRq69sg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zQaBbWwy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 09BAB1F395;
	Mon,  7 Apr 2025 15:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1744040839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7k9jp3hE/Zln2qHRDLqhNncrTwbN8U2DkKvJn5gNygU=;
	b=AXRq69sgRGbwATfro6Id3c9nHADYgfeA44QTUv9M5WWshQtQL22MRfl1kwj1mVYpX3DZok
	8hBBcBTz0ocD+gxyAvmEwPzJcrPr3wW7B+G4IiiLmqY6OrcRVkH2p9qsXXbOKTKpWHNbku
	cxDoY40KpsjMrj1FF6ePlkxOYh463KA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1744040839;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7k9jp3hE/Zln2qHRDLqhNncrTwbN8U2DkKvJn5gNygU=;
	b=zQaBbWwyry0LIHzGXI6dXp6DmZbtTPaZoDJxRrt+7D7LgbUFKyU15UmPrgc1CuCrspJAVA
	q54K2hnTryKg6XCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1744040839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7k9jp3hE/Zln2qHRDLqhNncrTwbN8U2DkKvJn5gNygU=;
	b=AXRq69sgRGbwATfro6Id3c9nHADYgfeA44QTUv9M5WWshQtQL22MRfl1kwj1mVYpX3DZok
	8hBBcBTz0ocD+gxyAvmEwPzJcrPr3wW7B+G4IiiLmqY6OrcRVkH2p9qsXXbOKTKpWHNbku
	cxDoY40KpsjMrj1FF6ePlkxOYh463KA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1744040839;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7k9jp3hE/Zln2qHRDLqhNncrTwbN8U2DkKvJn5gNygU=;
	b=zQaBbWwyry0LIHzGXI6dXp6DmZbtTPaZoDJxRrt+7D7LgbUFKyU15UmPrgc1CuCrspJAVA
	q54K2hnTryKg6XCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C69BA13A4B;
	Mon,  7 Apr 2025 15:47:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id o6pxKobz82fdQwAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 07 Apr 2025 15:47:18 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring/sqpoll: Increase task_work submission batch size
In-Reply-To: <87friod8rs.fsf@mailhost.krisman.be> (Gabriel Krisman Bertazi's
	message of "Thu, 03 Apr 2025 21:18:15 -0400")
Organization: SUSE
References: <20250403195605.1221203-1-krisman@suse.de>
	<94da2142-d7c1-46bb-bc35-05d0d1c28182@kernel.dk>
	<87friod8rs.fsf@mailhost.krisman.be>
Date: Mon, 07 Apr 2025 11:47:17 -0400
Message-ID: <87o6x8as8q.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.30
X-Spam-Flag: NO

Gabriel Krisman Bertazi <krisman@suse.de> writes:

> Jens Axboe <axboe@kernel.dk> writes:
>
>> On 4/3/25 1:56 PM, Gabriel Krisman Bertazi wrote:
>>> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
>>>  #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
>>> -#define IORING_TW_CAP_ENTRIES_VALUE	8
>>> +#define IORING_TW_CAP_ENTRIES_VALUE	1024
>>
>> That's a huge bump! This should not be a submission side thing, it's
>> purely running the task work. For this test case, I'm assuming you don't
>> see any io-wq activity, and hence everything is done purely inline from
>> the SQPOLL thread?
>> This confuses me a bit, as this should not be driving
>> the queue depth at all, as submissions would be done by
>> __io_sq_thread().
>
> Indeed, the submission happens fully inside __io_sq_thread, and I can
> confirm that from the profile.  What is interesting is that, once I lift
> the cap, we end up spending more time inside io_submit_sqes, which means
> it is able to drive more requests.

I think have more input on what's happening:

Regarding the tw batch not driving the submission.  This is a typical
submission with IORING_TW_CAP_ENTRIES_VALUE = 8

254,0    1    49927     0.016024812  5977  Q   R 2061024 + 8 [iou-sqp-5976]
254,0    1    49928     0.016025044  5977  G   R 2061024 + 8 [iou-sqp-5976]
254,0    1    49929     0.016025116  5977  P   N [iou-sqp-5976]
254,0    1    49930     0.016025594  5977  Q   R 1132240 + 8 [iou-sqp-5976]
254,0    1    49931     0.016025713  5977  G   R 1132240 + 8 [iou-sqp-5976]
254,0    1    49932     0.016026205  5977  Q   R 1187696 + 8 [iou-sqp-5976]
254,0    1    49933     0.016026317  5977  G   R 1187696 + 8 [iou-sqp-5976]
254,0    1    49934     0.016026811  5977  Q   R 1716272 + 8 [iou-sqp-5976]
254,0    1    49935     0.016026927  5977  G   R 1716272 + 8 [iou-sqp-5976]
254,0    1    49936     0.016027447  5977  Q   R 276336 + 8 [iou-sqp-5976]
254,0    1    49937     0.016027565  5977  G   R 276336 + 8 [iou-sqp-5976]
254,0    1    49938     0.016028005  5977  Q   R 1672040 + 8 [iou-sqp-5976]
254,0    1    49939     0.016028116  5977  G   R 1672040 + 8 [iou-sqp-5976]
254,0    1    49940     0.016028551  5977  Q   R 1770880 + 8 [iou-sqp-5976]
254,0    1    49941     0.016028685  5977  G   R 1770880 + 8 [iou-sqp-5976]
254,0    1    49942     0.016028795  5977  U   N [iou-sqp-5976] 7

We plug 7 requests, flush them all together.   with
IORING_TW_CAP_ENTRIES_VALUE=1024, submissions look generally like this:

254,0    1     4931     0.001414021  3145  P   N [iou-sqp-3144]
254,0    1     4932     0.001414415  3145  Q   R 1268736 + 8 [iou-sqp-3144]
254,0    1     4933     0.001414584  3145  G   R 1268736 + 8 [iou-sqp-3144]
254,0    1     4934     0.001414990  3145  Q   R 1210304 + 8 [iou-sqp-3144]
254,0    1     4935     0.001415145  3145  G   R 1210304 + 8 [iou-sqp-3144]
254,0    1     4936     0.001415553  3145  Q   R 1476352 + 8 [iou-sqp-3144]
254,0    1     4937     0.001415722  3145  G   R 1476352 + 8 [iou-sqp-3144]
254,0    1     4938     0.001416130  3145  Q   R 1291752 + 8 [iou-sqp-3144]
254,0    1     4939     0.001416302  3145  G   R 1291752 + 8 [iou-sqp-3144]
254,0    1     4940     0.001416763  3145  Q   R 1171664 + 8 [iou-sqp-3144]
254,0    1     4941     0.001416928  3145  G   R 1171664 + 8 [iou-sqp-3144]
254,0    1     4942     0.001417444  3145  Q   R 197424 + 8 [iou-sqp-3144]
254,0    1     4943     0.001417602  3145  G   R 197424 + 8 [iou-sqp-3144]
[...]
[...]
254,0    1     4993     0.001432191  3145  G   R 371656 + 8 [iou-sqp-3144]
254,0    1     4994     0.001432601  3145  Q   R 1864408 + 8 [iou-sqp-3144]
254,0    1     4995     0.001432771  3145  G   R 1864408 + 8 [iou-sqp-3144]
254,0    1     4996     0.001432872  3145  U   N [iou-sqp-3144] 32

So I'm able to drive way more I/O per plug with my patch.

If I plot the histogram of the to_submit argument of io_submit_sqes,
which is exactly io_sqring_entries(ctx), since I have only one ctx, I
see that I get much less io to submit in the ring in the first place.

So, because sqpoll is spinning more (and going to sleep more often), it
completes less I/Os, causing us to submit less from fio, as suggested by
the smaller io_sqring_entries?  Does it make any sense?

To retest, I fully dropped the accounting code and I can reproduce the
same submission pattern.  It really seems to depend on whether we go to
sleep after completing a small tw batch.

This is what I got from existing logs.  I'm a bit limited with testing at the
moment, as I lost the machine where I could reproduce it (my other machine
yields the same io pattern, but no numerical regression).  But I thought
it might be worth sharing in case I'm being silly and you can call me
out immediately.  I'll reproduce it in the next days, once I get more
time on the shared machine.

-- 
Gabriel Krisman Bertazi

