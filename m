Return-Path: <io-uring+bounces-379-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C236829ED0
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 17:56:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 153C7289A04
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 16:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 102144CDF3;
	Wed, 10 Jan 2024 16:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="McKduXR5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SGEq7OYd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="McKduXR5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SGEq7OYd"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365C94C3A5;
	Wed, 10 Jan 2024 16:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D29FB1FD7C;
	Wed, 10 Jan 2024 16:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1704905741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XZ2nz3JBuGT1gBLqsXE8VgXk0KCKqzgbkm3ks4acA2c=;
	b=McKduXR5XJlHNDuXtSKc4Zkjj1j1siVD+uikzNtdzT0k/pDuikD34No2BtI0/Vp4VNTp+Q
	2Cnm4tTGFSCyJQEVbqJ+XY6I0KsuBIsjc5MU3A+vF+oQzoI+Zs3vVqC+ZN0/83800md8aH
	ZPdq9TukGnqxLlEhv4bhh0uFqybglgI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1704905741;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XZ2nz3JBuGT1gBLqsXE8VgXk0KCKqzgbkm3ks4acA2c=;
	b=SGEq7OYdjLs8b4CeO/imUlggK4/nQfOPpzfpoJBjAK3Tnnoj8V+PAr8v7DW/umSQ6+7nhw
	gYjczUMjdgDhgDBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1704905741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XZ2nz3JBuGT1gBLqsXE8VgXk0KCKqzgbkm3ks4acA2c=;
	b=McKduXR5XJlHNDuXtSKc4Zkjj1j1siVD+uikzNtdzT0k/pDuikD34No2BtI0/Vp4VNTp+Q
	2Cnm4tTGFSCyJQEVbqJ+XY6I0KsuBIsjc5MU3A+vF+oQzoI+Zs3vVqC+ZN0/83800md8aH
	ZPdq9TukGnqxLlEhv4bhh0uFqybglgI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1704905741;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XZ2nz3JBuGT1gBLqsXE8VgXk0KCKqzgbkm3ks4acA2c=;
	b=SGEq7OYdjLs8b4CeO/imUlggK4/nQfOPpzfpoJBjAK3Tnnoj8V+PAr8v7DW/umSQ6+7nhw
	gYjczUMjdgDhgDBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 158EC13CB3;
	Wed, 10 Jan 2024 16:54:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +R2jLsDLnmWJDAAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 10 Jan 2024 16:54:24 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: kernel-janitors@vger.kernel.org,  io-uring@vger.kernel.org,  Hao Xu
 <howeyxu@tencent.com>,  Jens Axboe <axboe@kernel.dk>,  Pavel Begunkov
 <asml.silence@gmail.com>,  cocci@inria.fr,  LKML
 <linux-kernel@vger.kernel.org>
Subject: Re: [cocci] [PATCH] io_uring: Fix exception handling in
 io_ring_ctx_alloc()
In-Reply-To: <aa867594-e79d-6d08-a08e-8c9e952b4724@web.de> (Markus Elfring's
	message of "Wed, 29 Mar 2023 17:46:03 +0200")
References: <6cbcf640-55e5-2f11-4a09-716fe681c0d2@web.de>
	<aa867594-e79d-6d08-a08e-8c9e952b4724@web.de>
Date: Wed, 10 Jan 2024 13:55:53 -0300
Message-ID: <878r4xnn52.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: 0.20
X-Spamd-Result: default: False [0.20 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com,web.de];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 FREEMAIL_TO(0.00)[web.de];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 FREEMAIL_CC(0.00)[vger.kernel.org,tencent.com,kernel.dk,gmail.com,inria.fr];
	 RCVD_TLS_ALL(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[]
X-Spam-Flag: NO

Markus Elfring <Markus.Elfring@web.de> writes:

> Date: Wed, 29 Mar 2023 17:35:16 +0200
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

FWIW, I don't think it makes sense to have the extra labels or re-sort
without a good reason. kfree works fine with the NULL pointers, so there
is no bug to be fixed and moving code around for no reason just makes
life painful for backporters.

Also, the patch no longer applies.

> 3. Omit the statement =E2=80=9Ckfree(ctx->io_bl);=E2=80=9D.

From a quick look, this might still make sense.  can you confirm and make
that change into a separate patch?

--=20
Gabriel Krisman Bertazi

