Return-Path: <io-uring+bounces-588-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 418CF84E9F6
	for <lists+io-uring@lfdr.de>; Thu,  8 Feb 2024 21:53:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 673B61C2211C
	for <lists+io-uring@lfdr.de>; Thu,  8 Feb 2024 20:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94A3B4C3BC;
	Thu,  8 Feb 2024 20:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="J35Nh4Uc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="COVowTak";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="J35Nh4Uc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="COVowTak"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94704C3D4
	for <io-uring@vger.kernel.org>; Thu,  8 Feb 2024 20:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707425552; cv=none; b=R2Fe5RAWMqksa9sHaMp43PGcgL72musZG9COjJyfqsjR7ERqLSuPEGsCCcBMYaqhuXV5WrixuVWirxlLiRcnn9ubLh9U8Z5N6Uj39aHEmCGUJZMk3l4RLmYuuPBfzQg9qgcfZQrO1hHpC5/4IZu4IYuJIadZpY3WHRm327VeYF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707425552; c=relaxed/simple;
	bh=wwRQdGGzRYExSRQ5UwFMENW4yHRcSzUxrQwwRv/P6yM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HIOA9Vl8uuJgooHue896yElEKQ2/klZ0PzjNRCruCWk3gfrdaxyKIM9y98ODwXSGDnLU5JlHb3SL+8L6bBPIL85FQTd/Sit31074C5SfwFTXyACZ1eCRXSkApwMW+HPPPRxTgSG+iyVmK+JCmt+vy3iwsMBrJs0+7q+OBF4BgU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=J35Nh4Uc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=COVowTak; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=J35Nh4Uc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=COVowTak; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 01B171FD0C;
	Thu,  8 Feb 2024 20:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707425549; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xTJo9YhHKIH1g2paG8EJ6d8Xw4+qUZ40QpXycYW50zM=;
	b=J35Nh4UcifPo4PwsNjELOkvCiX+8EVCWguJgVuTFLLrsDkrvA3uTgwj127bYZCt3fZZwaQ
	ridtaGuluNwoN8+o7wzVkt1uhnjWi/PedzSgtdk6bziyTlFCuJob6Z9OcFl3n7PYfLbqkf
	5UF8PHo0ZJCCe9JMpLlbu+xNAP4Kg0Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707425549;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xTJo9YhHKIH1g2paG8EJ6d8Xw4+qUZ40QpXycYW50zM=;
	b=COVowTakpS+2BC545tWdc1T0lCcFEgnMfw7An5aMa8lXyCrCPtU0UWWZcfWCfz7tCSVDcC
	DBnYedmkxJtcuGDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707425549; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xTJo9YhHKIH1g2paG8EJ6d8Xw4+qUZ40QpXycYW50zM=;
	b=J35Nh4UcifPo4PwsNjELOkvCiX+8EVCWguJgVuTFLLrsDkrvA3uTgwj127bYZCt3fZZwaQ
	ridtaGuluNwoN8+o7wzVkt1uhnjWi/PedzSgtdk6bziyTlFCuJob6Z9OcFl3n7PYfLbqkf
	5UF8PHo0ZJCCe9JMpLlbu+xNAP4Kg0Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707425549;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xTJo9YhHKIH1g2paG8EJ6d8Xw4+qUZ40QpXycYW50zM=;
	b=COVowTakpS+2BC545tWdc1T0lCcFEgnMfw7An5aMa8lXyCrCPtU0UWWZcfWCfz7tCSVDcC
	DBnYedmkxJtcuGDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B2C491326D;
	Thu,  8 Feb 2024 20:52:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WH2dJQw/xWXeUwAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 08 Feb 2024 20:52:28 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 1/6] io_uring: expand main struct io_kiocb flags to 64-bits
In-Reply-To: <098a9f8c-c5b7-402d-ac35-c48361a9d403@kernel.dk> (Jens Axboe's
	message of "Thu, 8 Feb 2024 13:22:35 -0700")
Organization: SUSE
References: <20240207171941.1091453-1-axboe@kernel.dk>
	<20240207171941.1091453-2-axboe@kernel.dk>
	<87cyt6vhvm.fsf@mailhost.krisman.be>
	<098a9f8c-c5b7-402d-ac35-c48361a9d403@kernel.dk>
Date: Thu, 08 Feb 2024 15:52:23 -0500
Message-ID: <87ttmiu1a0.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J35Nh4Uc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=COVowTak
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-8.01 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 DWL_DNSWL_HI(-3.50)[suse.de:dkim];
	 HAS_ORG_HEADER(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 RCPT_COUNT_TWO(0.00)[2];
	 MX_GOOD(-0.01)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]
X-Spam-Score: -8.01
X-Rspamd-Queue-Id: 01B171FD0C
X-Spam-Flag: NO

Jens Axboe <axboe@kernel.dk> writes:

> On 2/8/24 1:08 PM, Gabriel Krisman Bertazi wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>> 
>> 
>>> -	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s, flags 0x%x, %s queue, work %p",
>>> +	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s, flags 0x%lx, %s queue, work %p",
>>>  		__entry->ctx, __entry->req, __entry->user_data,
>>> -		__get_str(op_str),
>>> -		__entry->flags, __entry->rw ? "hashed" : "normal", __entry->work)
>>> +		__get_str(op_str), (long) __entry->flags,
>> 
>> Hi Jens,
>> 
>> Minor, but on 32-bit kernel the cast is wrong since
>> sizeof(long)==4. Afaik, io_uring still builds on 32-bit archs.
>> 
>> If you use (unsigned long long), it will be 64 bit anywhere.
>
> Ah thanks, I'll make that edit.
>
>>> @@ -2171,7 +2171,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>  	/* req is partially pre-initialised, see io_preinit_req() */
>>>  	req->opcode = opcode = READ_ONCE(sqe->opcode);
>>>  	/* same numerical values with corresponding REQ_F_*, safe to copy */
>>> -	req->flags = sqe_flags = READ_ONCE(sqe->flags);
>>> +	sqe_flags = READ_ONCE(sqe->flags);
>> 
>> Did you consider that READ_ONCE won't protect from load tearing the
>> userspace value in 32-bit architectures? It builds silently, though, and
>> I suspect it is mostly fine in the current code, but might become a bug
>> eventually.
>
> sqe->flags is just a byte, so no tearing is possible here. The only
> thing that changed type is req->flags.

You're right, of course. I confused the source of the read with struct
io_kiocb.

-- 
Gabriel Krisman Bertazi

