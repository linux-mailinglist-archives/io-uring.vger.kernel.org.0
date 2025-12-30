Return-Path: <io-uring+bounces-11329-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 731C3CEA5ED
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 18:55:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1D121301FC31
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 17:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C31732C306;
	Tue, 30 Dec 2025 17:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IWyGuGEG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XuMbiQwX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PxubYX5J";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VskxdT98"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8635C32B99C
	for <io-uring@vger.kernel.org>; Tue, 30 Dec 2025 17:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767117294; cv=none; b=qMw6z+MA2ySLnYCo2eXDGpaTONb441Fpt5GUeHukk1SIBRhfLInxIkMctHFHtDa8TsBL80foixwNxZHMBT5+BGa0oFkiLPQGRtF3rL3Qqeol3U2lm93JndivbOtk8LcXvYB74i90/I7mQvyCkxmTHjPRNfEW+gFh2DJnH07ie+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767117294; c=relaxed/simple;
	bh=mEi/RTuzg72R5XYPp/9qHuwjN9NcKqoeFhF88c5VEOw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=RPBAeax/TXacuiBubfcJg6TRP84TIcszbeOp+FmHVbk7IJ8bo/Tx0MOgMG6aFYNMtQ4fE/IObMTefuJgOa4FmrhHq4mxHm6m7qFuVI6hrQtcokMjgZJmPUz00tEJk3GmGY3wwjghSiyJsT7iWkHLgTLYjREoTI0t+4moqRvedXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IWyGuGEG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XuMbiQwX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PxubYX5J; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VskxdT98; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B69065BCD9;
	Tue, 30 Dec 2025 17:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767117290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KX59cQIEVrMHes/DZRVamAdtTcJ/NBK4iRJZxn/BTC0=;
	b=IWyGuGEG+923OGoGadnc/4SeiP1P8VOOe7bPz3v05KBL2iKPsmW+pPgwmwzX/h2CczcLp7
	shf709FE2MC50WwdNX2/C8/xOX+xYnvA7ZYLif/U/QT2hoVJ7mw/S962Shy/3GQXAGeCyQ
	5agEzaq45Yoo2aBL3UBemkGximQ3+H0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767117290;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KX59cQIEVrMHes/DZRVamAdtTcJ/NBK4iRJZxn/BTC0=;
	b=XuMbiQwXGgeWVw7qpWvIyL/GGlCapLZQu53YPLfdBTnYu3FGV6s7mApcoT6nzZgN+wqvRr
	oxA5wpgYH+GN1vDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767117289; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KX59cQIEVrMHes/DZRVamAdtTcJ/NBK4iRJZxn/BTC0=;
	b=PxubYX5J+HbmKHdGW6grNEEM5N6JfH8aJSw7XL8ENIkAWn+X52irVeb/Uq1O7qRQkxWsEg
	nO77cD6hTG1WqoAIh7lphH5Qe0gljIAMWjcZ/7uGFCThmEVqfc6MIRNGZolEZaopQXI3/l
	1K14iae/NXO4eeJP46eTtOLO2wMQtp4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767117289;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KX59cQIEVrMHes/DZRVamAdtTcJ/NBK4iRJZxn/BTC0=;
	b=VskxdT98aBVOmOMklY3GR08sWdBdaHGJc2pb4psFwc7CNBiEqE2mQtuKxV6N8rIG6Vb4eb
	y63LypMMBHAqbkAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 65B3213879;
	Tue, 30 Dec 2025 17:54:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id p2KiDOkRVGlBGwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 30 Dec 2025 17:54:49 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu,  axboe@kernel.dk,  bschubert@ddn.com,
  asml.silence@gmail.com,  io-uring@vger.kernel.org,
  csander@purestorage.com,  xiaobing.li@samsung.com,
  linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 06/25] io_uring/kbuf: add buffer ring pinning/unpinning
In-Reply-To: <CAJnrk1a_qDe22E5WYN+yxJ3SrPCLp=uFKYQ6NU2WPf-wCiZOtg@mail.gmail.com>
	(Joanne Koong's message of "Mon, 29 Dec 2025 17:27:19 -0800")
Organization: SUSE
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
	<20251223003522.3055912-7-joannelkoong@gmail.com>
	<87y0mlyp31.fsf@mailhost.krisman.be>
	<CAJnrk1a_qDe22E5WYN+yxJ3SrPCLp=uFKYQ6NU2WPf-wCiZOtg@mail.gmail.com>
Date: Tue, 30 Dec 2025 12:54:47 -0500
Message-ID: <87ikdnzwgo.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	HAS_ORG_HEADER(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[szeredi.hu,kernel.dk,ddn.com,gmail.com,vger.kernel.org,purestorage.com,samsung.com];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]

Joanne Koong <joannelkoong@gmail.com> writes:

> On Mon, Dec 29, 2025 at 1:07=E2=80=AFPM Gabriel Krisman Bertazi <krisman@=
suse.de> wrote:
>
>>
>> Joanne Koong <joannelkoong@gmail.com> writes:
>>
>> > +int io_kbuf_ring_pin(struct io_kiocb *req, unsigned buf_group,
>> > +                  unsigned issue_flags, struct io_buffer_list **bl)
>> > +{
>> > +     struct io_buffer_list *buffer_list;
>> > +     struct io_ring_ctx *ctx =3D req->ctx;
>> > +     int ret =3D -EINVAL;
>> > +
>> > +     io_ring_submit_lock(ctx, issue_flags);
>> > +
>> > +     buffer_list =3D io_buffer_get_list(ctx, buf_group);
>> > +     if (likely(buffer_list) && likely(buffer_list->flags & IOBL_BUF_=
RING)) {
>>
>> FWIW, the likely construct is unnecessary here. At least, it should
>> encompass the entire expression:
>>
>>     if (likely(buffer_list && buffer_list->flags & IOBL_BUF_RING))
>>
>> But you can just drop it.
>
> I see, thanks. Could you explain when likelys/unlikelys should be used
> vs not? It's unclear to me when they need to be included vs can be
> dropped. I see some other io-uring code use likely() for similar-ish
> logic, but is the idea that it's unnecessary because the compiler
> already infers it?

likely/unlikely help the compiler decide whether it should reverse the
jump to optimize branch prediction and code spacial locality for icache.
The compiler is usually great in figuring it out by itself and, in
general, these should only be used after profilings shows the specific
jump is problematic, or when you know the jump will or will not be taken
almost every time.  The compiler decision depends on heuristics (which I
guess considers the leg size and favors the if leg), but it usually gets
it right.

One obvious case where *unlikely* is useful is to handle error paths.
The logic behind it is that the error path is obviously not the
hot-path, so a branch misprediction or a cache miss in that path is
just fine.

The usage of likely is more rare, and some usages are just cargo-cult.
Here you could use it, as the hot path is definitely the if leg.  But
if you look at the generated code, it most likely doesn't make any
difference, because gcc is smart enough to handle it.

A problem arises when likely/unlikely are used improperly, or the code
changes and the frequency when each leg is taken changes.  Now the
likely/unlikely is introducing mispredictions the compiler could have
avoided and harming performance.

I wasn't gonna comment in the review, since the likely() seems harmless
in your patch.  But what got my attention was that each separate
expression was under a single likely() expression.  I don't think that
makes much sense, since the hint is useful for the placement of the
if/else legs, it should encompass the whole condition.  That's how it is
used almost anywhere else in the kernel (there are a few occurrences
drivers/scsi/ that also look a bit fishy, IMO).

--=20
Gabriel Krisman Bertazi

