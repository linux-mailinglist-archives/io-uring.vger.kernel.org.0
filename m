Return-Path: <io-uring+bounces-4870-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 159CE9D3F49
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 16:44:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99D8F1F24F28
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 15:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FDC024B28;
	Wed, 20 Nov 2024 15:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xa6Arkab";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="enWBw5RZ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xa6Arkab";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="enWBw5RZ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CF5137930;
	Wed, 20 Nov 2024 15:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732117484; cv=none; b=KO7KI3So39CnZkRuzyWjSEwPsfYTGRfPR3oBn14nzGpckaaTtDWrx83fYs/k7XTvXolaBKOA4FncDopnH7QAs71DnDb6iOa6OgTM3UI+/Y51UbnqL3dWKxcZqHLQlSIQrPRDi8T8GI9cFwKJFqf7Y3YeINEe7sMPBj/rJKU2FKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732117484; c=relaxed/simple;
	bh=WD3Vz3+6jviVi/pnb3OLUOIADFH0vz74/wboEyB07kk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NoEykfO9zmTyOLpeWS8ESnbltyPNULkLUDJqDQA8NRNfIaq/2RFngIPyKclbclhUSEfS2EQeioMQdEC2GmyAQQk+6nSCyxYCsEO3lUSxnROTLD2X18Cr5BxvxThYf07pgrut35/WnPn8xckuPf1675fiQOTHrgwMfvPmvzX+vjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xa6Arkab; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=enWBw5RZ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xa6Arkab; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=enWBw5RZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 201421F79B;
	Wed, 20 Nov 2024 15:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1732117475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p8lfovQ7AQAk1URdQYmWQ2GSXANbIm7uJrpxkk50GQQ=;
	b=xa6ArkabR8Eo+PDHwlszdEOEScxd+PGcRf1Cug9wCuJ/YEBxmM8ZHWuJuwe6E7JfGQaXHI
	OnuKlIC6yuk70zrYMrOTpMHwpXNQz9UJh+NDNPNxooMR2KvPAFIf6S7iFYBWkCH7nRP+O4
	5dP6Tcwt+NCLw4++ti1z+Dvx4TDhLvw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1732117475;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p8lfovQ7AQAk1URdQYmWQ2GSXANbIm7uJrpxkk50GQQ=;
	b=enWBw5RZfWlTCBwzbwKyG84rNc1SnFRWcxXfaaKMGKPp6k4t01N4A3ze43GizaT74DjL3W
	Ct1ioLeeD/q1nlAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xa6Arkab;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=enWBw5RZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1732117475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p8lfovQ7AQAk1URdQYmWQ2GSXANbIm7uJrpxkk50GQQ=;
	b=xa6ArkabR8Eo+PDHwlszdEOEScxd+PGcRf1Cug9wCuJ/YEBxmM8ZHWuJuwe6E7JfGQaXHI
	OnuKlIC6yuk70zrYMrOTpMHwpXNQz9UJh+NDNPNxooMR2KvPAFIf6S7iFYBWkCH7nRP+O4
	5dP6Tcwt+NCLw4++ti1z+Dvx4TDhLvw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1732117475;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p8lfovQ7AQAk1URdQYmWQ2GSXANbIm7uJrpxkk50GQQ=;
	b=enWBw5RZfWlTCBwzbwKyG84rNc1SnFRWcxXfaaKMGKPp6k4t01N4A3ze43GizaT74DjL3W
	Ct1ioLeeD/q1nlAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EBB8313297;
	Wed, 20 Nov 2024 15:44:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YPM6OeIDPmfESAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 20 Nov 2024 15:44:34 +0000
Message-ID: <921f264e-dd84-4b1c-92da-948f1cc8d12c@suse.cz>
Date: Wed, 20 Nov 2024 16:44:34 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
Content-Language: en-US
To: Guenter Roeck <linux@roeck-us.net>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, Mike Rapoport <rppt@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>,
 Jann Horn <jannh@google.com>
Cc: linux-mm@kvack.org, io-uring@vger.kernel.org, linux-m68k@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
 <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz>
 <f6a16e3c-98de-4a56-8dd1-ea2cbac1874a@roeck-us.net>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <f6a16e3c-98de-4a56-8dd1-ea2cbac1874a@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 201421F79B
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[roeck-us.net,linux-m68k.org,linux.com,kernel.org,google.com,lge.com,linux-foundation.org,linux.dev,gmail.com,kernel.dk,chromium.org];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[19];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:mid,linux-m68k.org:email];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO

On 11/20/24 16:14, Guenter Roeck wrote:
> On 11/20/24 07:03, Vlastimil Babka wrote:
>> On 11/20/24 13:49, Geert Uytterhoeven wrote:
>>> On m68k, where the minimum alignment of unsigned long is 2 bytes:
>>>
>>>      Kernel panic - not syncing: __kmem_cache_create_args: Failed to create slab 'io_kiocb'. Error -22
>>>      CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-atari-03776-g7eaa1f99261a #1783
>>>      Stack from 0102fe5c:
>>> 	    0102fe5c 00514a2b 00514a2b ffffff00 00000001 0051f5ed 00425e78 00514a2b
>>> 	    0041eb74 ffffffea 00000310 0051f5ed ffffffea ffffffea 00601f60 00000044
>>> 	    0102ff20 000e7a68 0051ab8e 004383b8 0051f5ed ffffffea 000000b8 00000007
>>> 	    01020c00 00000000 000e77f0 0041e5f0 005f67c0 0051f5ed 000000b6 0102fef4
>>> 	    00000310 0102fef4 00000000 00000016 005f676c 0060a34c 00000010 00000004
>>> 	    00000038 0000009a 01000000 000000b8 005f668e 0102e000 00001372 0102ff88
>>>      Call Trace: [<00425e78>] dump_stack+0xc/0x10
>>>       [<0041eb74>] panic+0xd8/0x26c
>>>       [<000e7a68>] __kmem_cache_create_args+0x278/0x2e8
>>>       [<000e77f0>] __kmem_cache_create_args+0x0/0x2e8
>>>       [<0041e5f0>] memset+0x0/0x8c
>>>       [<005f67c0>] io_uring_init+0x54/0xd2
>>>
>>> The minimal alignment of an integral type may differ from its size,
>>> hence is not safe to assume that an arbitrary freeptr_t (which is
>>> basically an unsigned long) is always aligned to 4 or 8 bytes.
>>>
>>> As nothing seems to require the additional alignment, it is safe to fix
>>> this by relaxing the check to the actual minimum alignment of freeptr_t.
>>>
>>> Fixes: aaa736b186239b7d ("io_uring: specify freeptr usage for SLAB_TYPESAFE_BY_RCU io_kiocb cache")
>>> Fixes: d345bd2e9834e2da ("mm: add kmem_cache_create_rcu()")
>>> Reported-by: Guenter Roeck <linux@roeck-us.net>
>>> Closes: https://lore.kernel.org/37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net
>>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> 
>> Thanks, will add it to slab pull for 6.13.
>> 
>>> ---
>>>   mm/slab_common.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>>> index 893d320599151845..f2f201d865c108bd 100644
>>> --- a/mm/slab_common.c
>>> +++ b/mm/slab_common.c
>>> @@ -230,7 +230,7 @@ static struct kmem_cache *create_cache(const char *name,
>>>   	if (args->use_freeptr_offset &&
>>>   	    (args->freeptr_offset >= object_size ||
>>>   	     !(flags & SLAB_TYPESAFE_BY_RCU) ||
>>> -	     !IS_ALIGNED(args->freeptr_offset, sizeof(freeptr_t))))
>>> +	     !IS_ALIGNED(args->freeptr_offset, __alignof(freeptr_t))))
>> 
>> Seems only bunch of places uses __alignof but many use __alignoff__ and this
>> also is what seems to be documented?
> 
> __alignoff__ -> __alignof__

Yeah I meant __alignof__
Will chage it locally then.

> Guenter
> 


