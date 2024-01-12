Return-Path: <io-uring+bounces-395-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9C6282C1AF
	for <lists+io-uring@lfdr.de>; Fri, 12 Jan 2024 15:26:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BB061F21F28
	for <lists+io-uring@lfdr.de>; Fri, 12 Jan 2024 14:26:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C02E6DCF9;
	Fri, 12 Jan 2024 14:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DguTXLVb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dEepbHXU";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DguTXLVb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dEepbHXU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D306DCF2;
	Fri, 12 Jan 2024 14:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8C6EA21D66;
	Fri, 12 Jan 2024 14:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1705069551; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JbiL5Ao6ZLEFO0UlC/jQLuHCQ0ACyhnb434ykBjj5JQ=;
	b=DguTXLVb7lRacKEy2w1aTWVnnQ1/oOUFX4v2wFm/fcmCWIfK2JA91IDahr2yWgCBRUbz1R
	fSauMODACCzZ8WFgu24QYxQbZO5olFpZtIlJzcOk7U4nT9TEIjSyd8dl5pYTYnI/qTuC5f
	24qL6hMCOtTuRXIqL8i8mK3jxR9QOdQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1705069551;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JbiL5Ao6ZLEFO0UlC/jQLuHCQ0ACyhnb434ykBjj5JQ=;
	b=dEepbHXU+IuMX/l7RrPKvwXzM+GPP6I1s8SckuoYH3caBXrXu9wrFG7pWCLW4tmn7JM437
	IAZgN9lvGa6RgsBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1705069551; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JbiL5Ao6ZLEFO0UlC/jQLuHCQ0ACyhnb434ykBjj5JQ=;
	b=DguTXLVb7lRacKEy2w1aTWVnnQ1/oOUFX4v2wFm/fcmCWIfK2JA91IDahr2yWgCBRUbz1R
	fSauMODACCzZ8WFgu24QYxQbZO5olFpZtIlJzcOk7U4nT9TEIjSyd8dl5pYTYnI/qTuC5f
	24qL6hMCOtTuRXIqL8i8mK3jxR9QOdQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1705069551;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JbiL5Ao6ZLEFO0UlC/jQLuHCQ0ACyhnb434ykBjj5JQ=;
	b=dEepbHXU+IuMX/l7RrPKvwXzM+GPP6I1s8SckuoYH3caBXrXu9wrFG7pWCLW4tmn7JM437
	IAZgN9lvGa6RgsBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F035713782;
	Fri, 12 Jan 2024 14:25:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RkIVLe5LoWUWBwAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 12 Jan 2024 14:25:50 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: io-uring@vger.kernel.org,  kernel-janitors@vger.kernel.org,  Jens Axboe
 <axboe@kernel.dk>,  Pavel Begunkov <asml.silence@gmail.com>,  LKML
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] io_uring: Delete a redundant kfree() call in
 io_ring_ctx_alloc()
In-Reply-To: <edeafe29-2ab1-4e87-853c-912b4da06ad5@web.de> (Markus Elfring's
	message of "Wed, 10 Jan 2024 21:48:37 +0100")
References: <6cbcf640-55e5-2f11-4a09-716fe681c0d2@web.de>
	<aa867594-e79d-6d08-a08e-8c9e952b4724@web.de>
	<878r4xnn52.fsf@mailhost.krisman.be>
	<b9c9ba9f-459e-40b5-ae4b-703dcc03871d@web.de>
	<edeafe29-2ab1-4e87-853c-912b4da06ad5@web.de>
Date: Fri, 12 Jan 2024 11:25:48 -0300
Message-ID: <87jzoek4r7.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Level: 
X-Spamd-Bar: /
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DguTXLVb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dEepbHXU
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-0.95 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 BAYES_HAM(-0.94)[86.44%];
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
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	 FREEMAIL_TO(0.00)[web.de];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FREEMAIL_CC(0.00)[vger.kernel.org,kernel.dk,gmail.com];
	 RCVD_TLS_ALL(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[]
X-Spam-Score: -0.95
X-Rspamd-Queue-Id: 8C6EA21D66
X-Spam-Flag: NO

Markus Elfring <Markus.Elfring@web.de> writes:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 10 Jan 2024 20:54:43 +0100
>
> Another useful pointer was not reassigned to the data structure member
> =E2=80=9Cio_bl=E2=80=9D by this function implementation.
> Thus omit a redundant call of the function =E2=80=9Ckfree=E2=80=9D at the=
 end.

Perhaps rewrite this to:

ctx->io_bl is initialized later through IORING_OP_PROVIDE_BUFFERS or
IORING_REGISTER_PBUF_RING later on, so there is nothing to free in the
ctx allocation error path.

Other than that, and for this patch only:

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

thanks,

>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>
> v2:
> A change request by Gabriel Krisman Bertazi was applied here.
>
>
>  io_uring/io_uring.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 86761ec623f9..c9a63c39cdd0 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -344,7 +344,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(s=
truct io_uring_params *p)
>  err:
>  	kfree(ctx->cancel_table.hbs);
>  	kfree(ctx->cancel_table_locked.hbs);
> -	kfree(ctx->io_bl);
>  	xa_destroy(&ctx->io_bl_xa);
>  	kfree(ctx);
>  	return NULL;
> --
> 2.43.0
>

--=20
Gabriel Krisman Bertazi

