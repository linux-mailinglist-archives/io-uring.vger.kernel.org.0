Return-Path: <io-uring+bounces-396-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E5B5D82C1D8
	for <lists+io-uring@lfdr.de>; Fri, 12 Jan 2024 15:30:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5251928772E
	for <lists+io-uring@lfdr.de>; Fri, 12 Jan 2024 14:30:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DD7B57322;
	Fri, 12 Jan 2024 14:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="w9kIaiRg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oQWXn9Bl";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="w9kIaiRg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oQWXn9Bl"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909C86DD09;
	Fri, 12 Jan 2024 14:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D05B121E03;
	Fri, 12 Jan 2024 14:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1705069824; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jyt2TEgZsDix4CX79kAquNlGHroGirqSF3vUH3D39Ig=;
	b=w9kIaiRgFGLBFILRYnlkETpGNRAzpjJplkw71SgIjwAiSPkxvZ3yxa3Xeb0YWDum8GmOHK
	AAgdbPlhdR7oR1hNnoNNLCmKZ7KeG1Vhy4woeEfnepl18rhHgn/fK0aY98lib9RFdRV0XH
	/tWY8eGOUpafEIo6ZNlD0aAdqrEPRo8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1705069824;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jyt2TEgZsDix4CX79kAquNlGHroGirqSF3vUH3D39Ig=;
	b=oQWXn9BlPf5SmtbIIH7h34Cjwafq1gTZQdgqxCVeIxfeaEtynilNis2QtoYM3o8V/HwHh3
	74R9NMUMxOMMJzCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1705069824; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jyt2TEgZsDix4CX79kAquNlGHroGirqSF3vUH3D39Ig=;
	b=w9kIaiRgFGLBFILRYnlkETpGNRAzpjJplkw71SgIjwAiSPkxvZ3yxa3Xeb0YWDum8GmOHK
	AAgdbPlhdR7oR1hNnoNNLCmKZ7KeG1Vhy4woeEfnepl18rhHgn/fK0aY98lib9RFdRV0XH
	/tWY8eGOUpafEIo6ZNlD0aAdqrEPRo8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1705069824;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jyt2TEgZsDix4CX79kAquNlGHroGirqSF3vUH3D39Ig=;
	b=oQWXn9BlPf5SmtbIIH7h34Cjwafq1gTZQdgqxCVeIxfeaEtynilNis2QtoYM3o8V/HwHh3
	74R9NMUMxOMMJzCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B2DB13782;
	Fri, 12 Jan 2024 14:30:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Lj0ZOP9MoWVkCAAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 12 Jan 2024 14:30:23 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: io-uring@vger.kernel.org,  kernel-janitors@vger.kernel.org,  Jens Axboe
 <axboe@kernel.dk>,  Pavel Begunkov <asml.silence@gmail.com>,  LKML
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] io_uring: Improve exception handling in
 io_ring_ctx_alloc()
In-Reply-To: <49ecda98-770d-455e-acd7-12d810280fdd@web.de> (Markus Elfring's
	message of "Wed, 10 Jan 2024 21:50:15 +0100")
References: <6cbcf640-55e5-2f11-4a09-716fe681c0d2@web.de>
	<aa867594-e79d-6d08-a08e-8c9e952b4724@web.de>
	<878r4xnn52.fsf@mailhost.krisman.be>
	<b9c9ba9f-459e-40b5-ae4b-703dcc03871d@web.de>
	<49ecda98-770d-455e-acd7-12d810280fdd@web.de>
Date: Fri, 12 Jan 2024 11:30:21 -0300
Message-ID: <87frz2k4jm.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: 0.24
X-Spamd-Result: default: False [0.24 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com,web.de];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCPT_COUNT_FIVE(0.00)[6];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.16)[-0.783];
	 FREEMAIL_TO(0.00)[web.de];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 FREEMAIL_CC(0.00)[vger.kernel.org,kernel.dk,gmail.com];
	 RCVD_TLS_ALL(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[]
X-Spam-Flag: NO

Markus Elfring <Markus.Elfring@web.de> writes:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 10 Jan 2024 21:15:48 +0100
>
> The label =E2=80=9Cerr=E2=80=9D was used to jump to a kfree() call despit=
e of
> the detail in the implementation of the function =E2=80=9Cio_ring_ctx_all=
oc=E2=80=9D
> that it was determined already that a corresponding variable contained
> a null pointer because of a failed memory allocation.
>
> 1. Thus use more appropriate labels instead.
>
> 2. Reorder jump targets at the end.
>

As I mentioned on v1, this doesn't do us any good, as kfree can handle
NULL pointers just fine, and changes like this becomes churn later when
backporting or modifying the code.

--=20
Gabriel Krisman Bertazi

