Return-Path: <io-uring+bounces-399-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF25482C48D
	for <lists+io-uring@lfdr.de>; Fri, 12 Jan 2024 18:16:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F0FC2837FB
	for <lists+io-uring@lfdr.de>; Fri, 12 Jan 2024 17:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F024322609;
	Fri, 12 Jan 2024 17:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pOFakgN2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3U/xrbqH";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OdYJTRRS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="laykCk9x"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D73417540;
	Fri, 12 Jan 2024 17:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4ADF9222AA;
	Fri, 12 Jan 2024 17:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1705079752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QqUQhBDcgdZyOv8TeTdNa2X3hbRCyaNOdKOQw+rOND8=;
	b=pOFakgN2novJBoIe/iFQ8vjhNShphLRBKJPRuRWmpXUvhJyS7wGTgidEnH/XjqkKnFPAZY
	PJL0ixNtTqVZ2PJ3rvLNdRalnqrK17DQKMNtf1USpEpRZO9i3zovVA8oUiDmFKecMmIEeM
	uSll6hLWFsbVEpzPoKdf5yigxy0vSng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1705079752;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QqUQhBDcgdZyOv8TeTdNa2X3hbRCyaNOdKOQw+rOND8=;
	b=3U/xrbqHKRZ/InWwrjPbspD4/Kv+ArJ+w7Bxrg09mdVOv87XMbG4FU0RblQ4BeFKpHkG4F
	CUs0bHVjUAMGI/DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1705079751; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QqUQhBDcgdZyOv8TeTdNa2X3hbRCyaNOdKOQw+rOND8=;
	b=OdYJTRRSHv8ieZ9bVkUSRU9UeI6IyPu9kAAcjqybL46StLMMPPhRm1drR2by2W08gokJai
	eDZTeCLDKWei34xzeRb0XGk2Cessl837S9lHdhev5OfBBUCPc+Fp03tXDrz1FwnyqksKmk
	K4ZdszJ1Kri2TkT+/19Qs+NP6yWFoLM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1705079751;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QqUQhBDcgdZyOv8TeTdNa2X3hbRCyaNOdKOQw+rOND8=;
	b=laykCk9xJ778xF6jpevLLuNWry5nM60KF/wXJrROdTkDO6ZKSys4SLjV/hT1epiQkmfXuc
	xuZVFI8ZPPrM9uAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B64CF136A4;
	Fri, 12 Jan 2024 17:15:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KcWeHsZzoWWdNgAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 12 Jan 2024 17:15:50 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Markus Elfring <Markus.Elfring@web.de>,  io-uring@vger.kernel.org,
  kernel-janitors@vger.kernel.org,  Pavel Begunkov
 <asml.silence@gmail.com>,  LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] io_uring: Delete a redundant kfree() call in
 io_ring_ctx_alloc()
In-Reply-To: <c17648db-469c-4d3c-8c2e-774b88e79f07@kernel.dk> (Jens Axboe's
	message of "Fri, 12 Jan 2024 09:18:44 -0700")
Organization: SUSE
References: <6cbcf640-55e5-2f11-4a09-716fe681c0d2@web.de>
	<aa867594-e79d-6d08-a08e-8c9e952b4724@web.de>
	<878r4xnn52.fsf@mailhost.krisman.be>
	<b9c9ba9f-459e-40b5-ae4b-703dcc03871d@web.de>
	<edeafe29-2ab1-4e87-853c-912b4da06ad5@web.de>
	<87jzoek4r7.fsf@mailhost.krisman.be>
	<c17648db-469c-4d3c-8c2e-774b88e79f07@kernel.dk>
Date: Fri, 12 Jan 2024 14:15:47 -0300
Message-ID: <87bk9qjwvw.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OdYJTRRS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=laykCk9x
X-Spamd-Result: default: False [1.18 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com,web.de];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BAYES_HAM(-0.01)[45.66%];
	 RCPT_COUNT_FIVE(0.00)[6];
	 HAS_ORG_HEADER(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,kernel.dk:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 FREEMAIL_CC(0.00)[web.de,vger.kernel.org,gmail.com];
	 RCVD_TLS_ALL(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: 1.18
X-Rspamd-Queue-Id: 4ADF9222AA
X-Spam-Level: *
X-Spam-Flag: NO
X-Spamd-Bar: +

Jens Axboe <axboe@kernel.dk> writes:

> On 1/12/24 7:25 AM, Gabriel Krisman Bertazi wrote:
>> Markus Elfring <Markus.Elfring@web.de> writes:
>> 
>>> From: Markus Elfring <elfring@users.sourceforge.net>
>>> Date: Wed, 10 Jan 2024 20:54:43 +0100
>>>
>>> Another useful pointer was not reassigned to the data structure member
>>> ?io_bl? by this function implementation.
>>> Thus omit a redundant call of the function ?kfree? at the end.
>
> This is just nonsense...
>
> On top of that, this patch is pointless, and the 2nd patch is even worse
> in that it just makes a mess of cleanup. And for what reasoning?
> Absolutely none.

Ah, The description is non-sense, but the change in this patch seemed
correct to me, even if pointless, which is why I reviewed it.  patch 2
is just garbage.

> There's a reason why I filter emails from this particular author
> straight to the trash, there's a long history of this kind of thing and
> not understanding feedback.

Clearly there is background with this author that I wasn't aware, and
just based on his responses, I can see your point. So I apologize for
giving him space to continue the spamming.  My bad.

-- 
Gabriel Krisman Bertazi

