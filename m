Return-Path: <io-uring+bounces-4857-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CFDE9D35CE
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 09:47:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CA09283333
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 08:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C2521482F2;
	Wed, 20 Nov 2024 08:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mEE0vrHw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kJF8jYbC";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mEE0vrHw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kJF8jYbC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF3F15CD46;
	Wed, 20 Nov 2024 08:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732092471; cv=none; b=ZmIM0LvDZeOMOplENiYB+o4NBmbYRH9MBGw+RU/PxbX8wUrjzgQfS6m/UJkYHVFImJTfYXQo7zhGd9Jt+yYuRb8DJ4b4ncFtBaBaFZjai62huGB9Y6MpCuDrTSfGa3V8JFAoejH9ahW11lf0qmOuS9IOoenK3wGi5nJNmY6yuvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732092471; c=relaxed/simple;
	bh=eIYNZD+4YBnI5d6eh24IwwUZypZR7H6gDCFnWTKcn4o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=st8RbIEZ55pV0ssQtehIBvcL0OVQzHaiUQzlZmnSSErOk1AWmGjBqKQJWGz/DNNpiq4wz+fJzVqEXPgjbmTNksybygKsl2kyC+crQtkfGaDxtRP8u5naVrOkmuE8DZZHTKhYRCRj9MlMHOwq3jbFUijXAQlISDA1jxqSsZOEpBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mEE0vrHw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kJF8jYbC; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mEE0vrHw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kJF8jYbC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 452CB1F79F;
	Wed, 20 Nov 2024 08:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1732092466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Jy1O0yJ3D8WTshb1f6WV0r9uDZiv6CSIGkxCIJ9YnGI=;
	b=mEE0vrHw87yfdit4Y858T9eJYEuBU79A7u/77H1JvC97xo8kp/SgvX6SMDgcniLBIM19CG
	Owl3g1Y70wBmetXPviAEnvJcYbs9VI+m2rPmm9vTqQSVg3cbAYFX9Yim6fBnCYYi6JWY8G
	COIIvyCAXRS4oRkGU5HQEU0QFRv3RBM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1732092466;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Jy1O0yJ3D8WTshb1f6WV0r9uDZiv6CSIGkxCIJ9YnGI=;
	b=kJF8jYbC4QkXoHTWX/ce5C4XnsvJSSLow1FkZBbQJoqvMhBYIcEUuU55BMMgY66cF8UXwY
	wuhX9JYVa8oDbpAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1732092466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Jy1O0yJ3D8WTshb1f6WV0r9uDZiv6CSIGkxCIJ9YnGI=;
	b=mEE0vrHw87yfdit4Y858T9eJYEuBU79A7u/77H1JvC97xo8kp/SgvX6SMDgcniLBIM19CG
	Owl3g1Y70wBmetXPviAEnvJcYbs9VI+m2rPmm9vTqQSVg3cbAYFX9Yim6fBnCYYi6JWY8G
	COIIvyCAXRS4oRkGU5HQEU0QFRv3RBM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1732092466;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Jy1O0yJ3D8WTshb1f6WV0r9uDZiv6CSIGkxCIJ9YnGI=;
	b=kJF8jYbC4QkXoHTWX/ce5C4XnsvJSSLow1FkZBbQJoqvMhBYIcEUuU55BMMgY66cF8UXwY
	wuhX9JYVa8oDbpAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2DB2D13297;
	Wed, 20 Nov 2024 08:47:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xW+2CjKiPWcfRAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 20 Nov 2024 08:47:46 +0000
Message-ID: <8b95a694-ecd4-4b6d-8032-049894dec2c1@suse.cz>
Date: Wed, 20 Nov 2024 09:47:45 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/14] io_uring: specify freeptr usage for
 SLAB_TYPESAFE_BY_RCU io_kiocb cache
To: Geert Uytterhoeven <geert@linux-m68k.org>, Jens Axboe <axboe@kernel.dk>,
 Jann Horn <jannh@google.com>
Cc: Guenter Roeck <linux@roeck-us.net>, io-uring@vger.kernel.org,
 linux-m68k <linux-m68k@lists.linux-m68k.org>,
 Christian Brauner <brauner@kernel.org>, Linux MM <linux-mm@kvack.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20241029152249.667290-1-axboe@kernel.dk>
 <20241029152249.667290-4-axboe@kernel.dk>
 <37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net>
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
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <CAMuHMdVpaxVPy3Tyx-kc0FRqqPGkcDwQPS4deO9SLdY7wCPthA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,imap1.dmz-prg2.suse.org:helo,bootlin.com:url]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On 11/20/24 09:19, Geert Uytterhoeven wrote:
> Hi Jens,
> 
> CC Christian (who added the check)
> CC Vlastimil (who suggested the check)
> 
> On Tue, Nov 19, 2024 at 11:30 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 11/19/24 2:46 PM, Guenter Roeck wrote:
>> > On 11/19/24 11:49, Jens Axboe wrote:
>> >> On 11/19/24 12:44 PM, Jens Axboe wrote:
>> >>>> On Tue, Nov 19, 2024 at 8:30?PM Jens Axboe <axboe@kernel.dk> wrote:
>> >>>>> On 11/19/24 12:25 PM, Geert Uytterhoeven wrote:
>> >>>>>> On Tue, Nov 19, 2024 at 8:10?PM Jens Axboe <axboe@kernel.dk> wrote:
>> >>>>>>> On 11/19/24 12:02 PM, Geert Uytterhoeven wrote:
>> >>>>>>>> On Tue, Nov 19, 2024 at 8:00?PM Jens Axboe <axboe@kernel.dk> wrote:
>> >>>>>>>>> On 11/19/24 10:49 AM, Geert Uytterhoeven wrote:
>> >>>>>>>>>> On Tue, Nov 19, 2024 at 5:21?PM Guenter Roeck <linux@roeck-us.net> wrote:
>> >>>>>>>>>>> On 11/19/24 08:02, Jens Axboe wrote:
>> >>>>>>>>>>>> On 11/19/24 8:36 AM, Guenter Roeck wrote:
>> >>>>>>>>>>>>> On Tue, Oct 29, 2024 at 09:16:32AM -0600, Jens Axboe wrote:
>> >>>>>>>>>>>>>> Doesn't matter right now as there's still some bytes left for it, but
>> >>>>>>>>>>>>>> let's prepare for the io_kiocb potentially growing and add a specific
>> >>>>>>>>>>>>>> freeptr offset for it.
>> >>>>>>>>>>>>>>
>> >>>>>>>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> >>>>>>>>>>>>>
>> >>>>>>>>>>>>> This patch triggers:
>> >>>>>>>>>>>>>
>> >>>>>>>>>>>>> Kernel panic - not syncing: __kmem_cache_create_args: Failed to create slab 'io_kiocb'. Error -22
>> >>>>>>>>>>>>> CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-mac-00971-g158f238aa69d #1
>> >>>>>>>>>>>>> Stack from 00c63e5c:
>> >>>>>>>>>>>>>           00c63e5c 00612c1c 00612c1c 00000300 00000001 005f3ce6 004b9044 00612c1c
>> >>>>>>>>>>>>>           004ae21e 00000310 000000b6 005f3ce6 005f3ce6 ffffffea ffffffea 00797244
>> >>>>>>>>>>>>>           00c63f20 000c6974 005ee588 004c9051 005f3ce6 ffffffea 000000a5 00c614a0
>> >>>>>>>>>>>>>           004a72c2 0002cb62 000c675e 004adb58 0076f28a 005f3ce6 000000b6 00c63ef4
>> >>>>>>>>>>>>>           00000310 00c63ef4 00000000 00000016 0076f23e 00c63f4c 00000010 00000004
>> >>>>>>>>>>>>>           00000038 0000009a 01000000 00000000 00000000 00000000 000020e0 0076f23e
>> >>>>>>>>>>>>> Call Trace: [<004b9044>] dump_stack+0xc/0x10
>> >>>>>>>>>>>>>    [<004ae21e>] panic+0xc4/0x252
>> >>>>>>>>>>>>>    [<000c6974>] __kmem_cache_create_args+0x216/0x26c
>> >>>>>>>>>>>>>    [<004a72c2>] strcpy+0x0/0x1c
>> >>>>>>>>>>>>>    [<0002cb62>] parse_args+0x0/0x1f2
>> >>>>>>>>>>>>>    [<000c675e>] __kmem_cache_create_args+0x0/0x26c
>> >>>>>>>>>>>>>    [<004adb58>] memset+0x0/0x8c
>> >>>>>>>>>>>>>    [<0076f28a>] io_uring_init+0x4c/0xca
>> >>>>>>>>>>>>>    [<0076f23e>] io_uring_init+0x0/0xca
>> >>>>>>>>>>>>>    [<000020e0>] do_one_initcall+0x32/0x192
>> >>>>>>>>>>>>>    [<0076f23e>] io_uring_init+0x0/0xca
>> >>>>>>>>>>>>>    [<0000211c>] do_one_initcall+0x6e/0x192
>> >>>>>>>>>>>>>    [<004a72c2>] strcpy+0x0/0x1c
>> >>>>>>>>>>>>>    [<0002cb62>] parse_args+0x0/0x1f2
>> >>>>>>>>>>>>>    [<000020ae>] do_one_initcall+0x0/0x192
>> >>>>>>>>>>>>>    [<0075c4e2>] kernel_init_freeable+0x1a0/0x1a4
>> >>>>>>>>>>>>>    [<0076f23e>] io_uring_init+0x0/0xca
>> >>>>>>>>>>>>>    [<004b911a>] kernel_init+0x0/0xec
>> >>>>>>>>>>>>>    [<004b912e>] kernel_init+0x14/0xec
>> >>>>>>>>>>>>>    [<004b911a>] kernel_init+0x0/0xec
>> >>>>>>>>>>>>>    [<0000252c>] ret_from_kernel_thread+0xc/0x14
>> >>>>>>>>>>>>>
>> >>>>>>>>>>>>> when trying to boot the m68k:q800 machine in qemu.
>> >>>>>>>>>>>>>
>> >>>>>>>>>>>>> An added debug message in create_cache() shows the reason:
>> >>>>>>>>>>>>>
>> >>>>>>>>>>>>> #### freeptr_offset=154 object_size=182 flags=0x310 aligned=0 sizeof(freeptr_t)=4
>> >>>>>>>>>>>>>
>> >>>>>>>>>>>>> freeptr_offset would need to be 4-byte aligned but that is not the
>> >>>>>>>>>>>>> case on m68k.
>> >>>>>>>>>>>>
>> >>>>>>>>>>>> Why is ->work 2-byte aligned to begin with on m68k?!
>> >>>>>>>>>>>
>> >>>>>>>>>>> My understanding is that m68k does not align pointers.
>> >>>>>>>>>>
>> >>>>>>>>>> The minimum alignment for multi-byte integral values on m68k is
>> >>>>>>>>>> 2 bytes.
>> >>>>>>>>>>
>> >>>>>>>>>> See also the comment at
>> >>>>>>>>>> https://elixir.bootlin.com/linux/v6.12/source/include/linux/maple_tree.h#L46
>> >>>>>>>>>
>> >>>>>>>>> Maybe it's time we put m68k to bed? :-)
>> >>>>>>>>>
>> >>>>>>>>> We can add a forced alignment ->work to be 4 bytes, won't change
>> >>>>>>>>> anything on anything remotely current. But does feel pretty hacky to
>> >>>>>>>>> need to align based on some ancient thing.
>> >>>>>>>>
>> >>>>>>>> Why does freeptr_offset need to be 4-byte aligned?
>> >>>>>>>
>> >>>>>>> Didn't check, but it's slab/slub complaining using a 2-byte aligned
>> >>>>>>> address for the free pointer offset. It's explicitly checking:
>> >>>>>>>
>> >>>>>>>          /* If a custom freelist pointer is requested make sure it's sane. */
>> >>>>>>>          err = -EINVAL;
>> >>>>>>>          if (args->use_freeptr_offset &&
>> >>>>>>>              (args->freeptr_offset >= object_size ||
>> >>>>>>>               !(flags & SLAB_TYPESAFE_BY_RCU) ||
>> >>>>>>>               !IS_ALIGNED(args->freeptr_offset, sizeof(freeptr_t))))
>                                                           ^^^^^^
> 
>> >>>>>>>                  goto out;
>> >>>>>>
>> >>>>>> It is not guaranteed that alignof(freeptr_t) >= sizeof(freeptr_t)
>> >>>>>> (free_ptr is sort of a long). If freeptr_offset must be a multiple of
>> >>>>>> 4 or 8 bytes,
>> >>>>>> the code that assigns it must make sure that is true.
>> >>>>>
>> >>>>> Right, this is what the email is about...
>> >>>>>
>> >>>>>> I guess this is the code in fs/file_table.c:
>> >>>>>>
>> >>>>>>      .freeptr_offset = offsetof(struct file, f_freeptr),
>> >>>>>>
>> >>>>>> which references:
>> >>>>>>
>> >>>>>>      include/linux/fs.h:           freeptr_t               f_freeptr;
>> >>>>>>
>> >>>>>> I guess the simplest solution is to add an __aligned(sizeof(freeptr_t))
>> >>>>>> (or __aligned(sizeof(long)) to the definition of freeptr_t:
>> >>>>>>
>> >>>>>>      include/linux/slab.h:typedef struct { unsigned long v; } freeptr_t;
>> >>>>>
>> >>>>> It's not, it's struct io_kiocb->work, as per the stack trace in this
>> >>>>> email.
>> >>>>
>> >>>> Sorry, I was falling out of thin air into this thread...
>> >>>>
>> >>>> linux-next/master:io_uring/io_uring.c:          .freeptr_offset =
>> >>>> offsetof(struct io_kiocb, work),
>> >>>> linux-next/master:io_uring/io_uring.c:          .use_freeptr_offset = true,
>> >>>>
>> >>>> Apparently io_kiocb.work is of type struct io_wq_work, not freeptr_t?
>> >>>> Isn't that a bit error-prone, as the slab core code expects a freeptr_t?
>> >>>
>> >>> It just needs the space, should not matter otherwise. But may as well
>> >>> just add the union and align the freeptr so it stop complaining on m68k.
>> >>
>> >> Ala the below, perhaps alignment takes care of itself then?
>> >
>> > No, that doesn't work (I tried), at least not on its own, because the pointer
>> > is still unaligned on m68k.
>>
>> Yeah we'll likely need to force it. The below should work, I pressume?
>> Feels pretty odd to have to align it to the size of it, when that should
>> naturally occur... Crusty legacy archs.
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 593c10a02144..8ed9c6923668 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -674,7 +674,11 @@ struct io_kiocb {
>>         struct io_kiocb                 *link;
>>         /* custom credentials, valid IFF REQ_F_CREDS is set */
>>         const struct cred               *creds;
>> -       struct io_wq_work               work;
>> +
>> +       union {
>> +               struct io_wq_work       work;
>> +               freeptr_t               freeptr __aligned(sizeof(freeptr_t));
> 
> I'd rather add the __aligned() to the definition of freeptr_t, so it
> applies to all (future) users.
> 
> But my main question stays: why is the slab code checking
> IS_ALIGNED(args->freeptr_offset, sizeof(freeptr_t)?

I believe it's to match how SLUB normally calculates the offset if no
explicit one is given, in calculate_sizes():

s->offset = ALIGN_DOWN(s->object_size / 2, sizeof(void *));

Yes there's a sizeof(void *) because freepointer used to be just that and we
forgot to update this place when freepointer_t was introduced (by Jann in
44f6a42d49350) for handling CONFIG_SLAB_FREELIST_HARDENED. In
get_freepointer() you can see how there's a cast to a pointer eventually.

Does m68k have different alignment for pointer and unsigned long or both are
2 bytes? Or any other arch, i.e. should get_freepointer be a union with
unsigned long and void * instead? (or it doesn't matter?)

> Perhaps that was just intended to be __alignof__ instead of sizeof()?

Would it do the right thing everywhere, given the explanation above?

Thanks,
Vlastimil

>> +       };
>>
>>         struct {
>>                 u64                     extra1;
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 73af59863300..86ac7df2a601 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -3812,7 +3812,7 @@ static int __init io_uring_init(void)
>>         struct kmem_cache_args kmem_args = {
>>                 .useroffset = offsetof(struct io_kiocb, cmd.data),
>>                 .usersize = sizeof_field(struct io_kiocb, cmd.data),
>> -               .freeptr_offset = offsetof(struct io_kiocb, work),
>> +               .freeptr_offset = offsetof(struct io_kiocb, freeptr),
>>                 .use_freeptr_offset = true,
>>         };
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 


