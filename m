Return-Path: <io-uring+bounces-4860-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDCE49D3724
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 10:37:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C789281229
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 09:37:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDB8218C02E;
	Wed, 20 Nov 2024 09:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="c5ka4WPJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Hd9J21v3";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xdhMsyxC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="e+nSHZSM"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B660922318;
	Wed, 20 Nov 2024 09:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732095464; cv=none; b=Perff8paWwu9r4t3BDAsBYnYlEI/jrfC6OyPu9rKQ0sEMSdx5oNoQxvo0EBGt6ULXVvu/xEJiWtZqplzFd67bBMATMWmRCJrCx7Rs2xeS0A2yPuukldhGMKiW6DWnU80CWKYdMQuQd0qHn1ee4TVH2nLonQaI2y5ZxPg2LXZpmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732095464; c=relaxed/simple;
	bh=CSY/+H5vUl3kLg6f4yYIBNV8uxvkvdcv3S8rUnoud7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GMWgGNrEEr7YmEjnS3jKtOhrE1jzcSXCQoH+eQlx7xpk5woOIAEIRCNcMIM/ZbZh5a9lZlrjyGK6wWPIVV+h8rucW5U7wf7tXo60cw020QmMhzhlcoOaJ8AkIHteoCYzxtFFxHeIdEshyJqLUM2H9EnF80f0m75KzOJOpWYSuTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=c5ka4WPJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Hd9J21v3; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xdhMsyxC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=e+nSHZSM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D9607219E5;
	Wed, 20 Nov 2024 09:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1732095461; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SkiTqCEmV1Qwt5HMXO6+RKgh/MgDqVWS8XUrBALrZVs=;
	b=c5ka4WPJ6oDKocZ1lrZA3NKKJIHI5cRYzMbKx3slrnAmGDP3movWIjwCR+qEAvT9KMSQe7
	nqoYnjWf93jOR7SLq3Nc33RAvkxEJb62QLF307/wRVsL8NsgHNTlzmhrDs5Y7RuMHuN7zO
	4lBXgxVExiWmz5xX+OibFuNxi5KT5BE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1732095461;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SkiTqCEmV1Qwt5HMXO6+RKgh/MgDqVWS8XUrBALrZVs=;
	b=Hd9J21v3EVHmtUiIfG5v2s8tF7W+Hc4ePi2tywDh1Aeyxq8VdYxpU+hANS7tOL50zIOmI0
	EYFxxpR/csreXdCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xdhMsyxC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=e+nSHZSM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1732095460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SkiTqCEmV1Qwt5HMXO6+RKgh/MgDqVWS8XUrBALrZVs=;
	b=xdhMsyxCiye7E7LUVmiDp5RS+4ZN0576bI+W4NsDYH3xCkZGUaB1NP4kkENJv7J4LEN4XG
	/uSO7+9p/RNOPk3YqtjZOBR12tJDBJNCCWOkX2nEmZauQHKK127NzqU0msMRsplupil4FV
	vZWCYWXXIEsA1r9CXfLtqS0jN0acDxw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1732095460;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SkiTqCEmV1Qwt5HMXO6+RKgh/MgDqVWS8XUrBALrZVs=;
	b=e+nSHZSMtdhaxYZdkDCBR+cr0qgrDLBDjG39DI8fd5qrMODaSW+ADuu6Rb33b0PK9BDDyo
	CBC21HjvRHaKzyBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BC82013297;
	Wed, 20 Nov 2024 09:37:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 98lFLeStPWerVAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 20 Nov 2024 09:37:40 +0000
Message-ID: <a99c14c2-6351-4449-ac7c-b1cf9bb2c4ff@suse.cz>
Date: Wed, 20 Nov 2024 10:37:40 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/14] io_uring: specify freeptr usage for
 SLAB_TYPESAFE_BY_RCU io_kiocb cache
Content-Language: en-US
To: Geert Uytterhoeven <geert@linux-m68k.org>,
 Kees Cook <keescook@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>,
 Guenter Roeck <linux@roeck-us.net>, io-uring@vger.kernel.org,
 linux-m68k <linux-m68k@lists.linux-m68k.org>,
 Christian Brauner <brauner@kernel.org>, Linux MM <linux-mm@kvack.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20241029152249.667290-1-axboe@kernel.dk>
 <d4e5a858-1333-4427-a470-350c45b78733@kernel.dk>
 <ffc9d82d-fedf-4253-bbc1-c70c339c8b23@roeck-us.net>
 <CAMuHMdVAnJ8Tczm1=c=HOiWMZrNk0i_c1guUoqQbJRmdaXqPGw@mail.gmail.com>
 <5a7528c4-4391-4bd9-bbdb-a0247f3c76a9@kernel.dk>
 <CAMuHMdX9rHUQYn34_Hz=3TKjbFqzenoDCdwt-Mqk1qXJiG4=Zg@mail.gmail.com>
 <5851cd28-b369-4c09-876c-62c4a47c5982@kernel.dk>
 <CAMuHMdX3iOVLN-rJSqvKSjrjTTf++PJ4e-wPsEX-3QJR3=eWOA@mail.gmail.com>
 <358710e8-a826-46df-9846-5a9e0f7c6851@kernel.dk>
 <CAMuHMdUsj9FsX=_rHwYjiXT8RehP6HW5hUL9LMvE0pt7Z8kc8w@mail.gmail.com>
 <82b97543-ad01-4e42-b79c-12d97c1df194@kernel.dk>
 <4623f30c-a12e-4ba6-ad99-835764611c67@kernel.dk>
 <47a16a83-52c7-4779-9ed3-f16ea547b9f0@roeck-us.net>
 <6c3d73a5-b5ef-455f-92db-e6b96ef22fba@kernel.dk>
 <CAMuHMdVpaxVPy3Tyx-kc0FRqqPGkcDwQPS4deO9SLdY7wCPthA@mail.gmail.com>
 <8b95a694-ecd4-4b6d-8032-049894dec2c1@suse.cz>
 <CAMuHMdWU=69MtTxYXKGm2xZOyTvbUuxsqBWRSyMcp_H8VNEJ0g@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <CAMuHMdWU=69MtTxYXKGm2xZOyTvbUuxsqBWRSyMcp_H8VNEJ0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D9607219E5
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On 11/20/24 10:07, Geert Uytterhoeven wrote:
> Hi Vlastimil,
> 
>> >>
>> >> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> >> index 593c10a02144..8ed9c6923668 100644
>> >> --- a/include/linux/io_uring_types.h
>> >> +++ b/include/linux/io_uring_types.h
>> >> @@ -674,7 +674,11 @@ struct io_kiocb {
>> >>         struct io_kiocb                 *link;
>> >>         /* custom credentials, valid IFF REQ_F_CREDS is set */
>> >>         const struct cred               *creds;
>> >> -       struct io_wq_work               work;
>> >> +
>> >> +       union {
>> >> +               struct io_wq_work       work;
>> >> +               freeptr_t               freeptr __aligned(sizeof(freeptr_t));
>> >
>> > I'd rather add the __aligned() to the definition of freeptr_t, so it
>> > applies to all (future) users.
>> >
>> > But my main question stays: why is the slab code checking
>> > IS_ALIGNED(args->freeptr_offset, sizeof(freeptr_t)?
>>
>> I believe it's to match how SLUB normally calculates the offset if no
>> explicit one is given, in calculate_sizes():
>>
>> s->offset = ALIGN_DOWN(s->object_size / 2, sizeof(void *));
>>
>> Yes there's a sizeof(void *) because freepointer used to be just that and we
>> forgot to update this place when freepointer_t was introduced (by Jann in
>> 44f6a42d49350) for handling CONFIG_SLAB_FREELIST_HARDENED. In
>> get_freepointer() you can see how there's a cast to a pointer eventually.
>>
>> Does m68k have different alignment for pointer and unsigned long or both are
>> 2 bytes? Or any other arch, i.e. should get_freepointer be a union with
>> unsigned long and void * instead? (or it doesn't matter?)
> 
> The default alignment for int, long, and pointer is 2 on m68k.
> On CRIS (no longer supported by Linux), it was 1, IIRC.
> So the union won't make a difference.
> 
>> > Perhaps that was just intended to be __alignof__ instead of sizeof()?
>>
>> Would it do the right thing everywhere, given the explanation above?
> 
> It depends. Does anything rely on the offset being a multiple of (at
> least) 4?
> E.g. does anything counts in multiples of longs (hi BCPL! ;-), or are
> the 2 LSB used for a special purpose? (cfr. maple_tree, which uses
> bit 0 (https://elixir.bootlin.com/linux/v6.12/source/include/linux/maple_tree.h#L46)?

AFAIK no, the goal was just to prevent misaligned accesses. Kees added the:

s->offset = ALIGN_DOWN(s->object_size / 2, sizeof(void *));

so maybe he had something else in mind. But I suspect it was just because
the code already used it elsewhere.

So we might want something like this? But that would be safer for 6.14 so
I'd suggest the io_uring specific fix meanwhile. Or maybe just add the union
with freeptr_t but without __aligned plus the part below that changes
mm/slab_common.c only, as the 6.13 io_uring fix?

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 893d32059915..477fa471da18 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -230,7 +230,7 @@ static struct kmem_cache *create_cache(const char *name,
 	if (args->use_freeptr_offset &&
 	    (args->freeptr_offset >= object_size ||
 	     !(flags & SLAB_TYPESAFE_BY_RCU) ||
-	     !IS_ALIGNED(args->freeptr_offset, sizeof(freeptr_t))))
+	     !IS_ALIGNED(args->freeptr_offset, __alignof__(freeptr_t))))
 		goto out;
 
 	err = -ENOMEM;
diff --git a/mm/slub.c b/mm/slub.c
index 5b832512044e..6ad904be7700 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5287,11 +5287,7 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 	unsigned int size = s->object_size;
 	unsigned int order;
 
-	/*
-	 * Round up object size to the next word boundary. We can only
-	 * place the free pointer at word boundaries and this determines
-	 * the possible location of the free pointer.
-	 */
+	/* Round up object size to the next word boundary. */
 	size = ALIGN(size, sizeof(void *));
 
 #ifdef CONFIG_SLUB_DEBUG
@@ -5325,7 +5321,7 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 	if (((flags & SLAB_TYPESAFE_BY_RCU) && !args->use_freeptr_offset) ||
 	    (flags & SLAB_POISON) || s->ctor ||
 	    ((flags & SLAB_RED_ZONE) &&
-	     (s->object_size < sizeof(void *) || slub_debug_orig_size(s)))) {
+	     (s->object_size < sizeof(freeptr_t) || slub_debug_orig_size(s)))) {
 		/*
 		 * Relocate free pointer after the object if it is not
 		 * permitted to overwrite the first word of the object on
@@ -5343,7 +5339,7 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 		 * longer true, the function needs to be modified.
 		 */
 		s->offset = size;
-		size += sizeof(void *);
+		size += sizeof(freeptr_t);
 	} else if ((flags & SLAB_TYPESAFE_BY_RCU) && args->use_freeptr_offset) {
 		s->offset = args->freeptr_offset;
 	} else {
@@ -5352,7 +5348,7 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 		 * it away from the edges of the object to avoid small
 		 * sized over/underflows from neighboring allocations.
 		 */
-		s->offset = ALIGN_DOWN(s->object_size / 2, sizeof(void *));
+		s->offset = ALIGN_DOWN(s->object_size / 2, __alignof__(freeptr_t));
 	}
 
 #ifdef CONFIG_SLUB_DEBUG




