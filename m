Return-Path: <io-uring+bounces-12171-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uNmDHG/9jGn4wgAAu9opvQ
	(envelope-from <io-uring+bounces-12171-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 23:06:39 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D237127F59
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 23:06:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F34D5301FC92
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 22:06:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 088AA308F1A;
	Wed, 11 Feb 2026 22:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dwj1kfAR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B81630F924
	for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 22:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770847592; cv=pass; b=sk43c/6aPDrMFCA9GFDuP+KiT/tJO1EYMElaoAdd6D6nbeP70KqIWjaCn2RkvxDUD7DYeSa3HR0NT9/OlT7w8nHNWVsuau7mjKjK8kqYwwrdstPOwxlGW5fKA+PJE7ZcNBntFMDCS35mAW65PuUxt6PvPbw0+wJhWQ2HToPRsAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770847592; c=relaxed/simple;
	bh=eFhbGXrgDS8QDy8Db4uVM4iMnLUYFWYh8SlI9xEdKjU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KwiYSLFOQTvca6ZPmE2At6bEE0dxnWrRyRFceWXrtl++hBcc158VVddIuwhqH7tOv+VgyiFkUTPTeyUHitajMGahnyMZRICQzn53dS5okqVHRBl9f8d6Pv1/Kg07cLxr43OgeFFkLA2vZlXfzGmIYg+MNWlJr5fcRuw7ud+oxo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dwj1kfAR; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-502acd495feso64277681cf.2
        for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 14:06:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770847589; cv=none;
        d=google.com; s=arc-20240605;
        b=eR3OPc2cPw9wTdx+SyRCnj6icZ17eHdchjCHK6FAVyNytqxd8WKBo8nK8Rb3uWmq7l
         +DzC2VBfzbRai3Hd6wg3UQfqMusok4Zrx1NCk7Fq1J7wDviQGxYDA118mkA2uiqPZupB
         rwPcK2PYqdKs4UoItyZXQP8SxNvAy0TXms6/4jaXIxuMdg2KZr70T0MHNk7bsF/G8o9p
         imW9vWlT26qRNitZTp/RdjhXaxkLrd4ZCU5IgvwWE6amXWcaRwhSEKG7ReEVU3cxQTiG
         dwg8GRY/xOi2LKkGnNOpGRRutH1j9myKTwVjZbaPATBMnaRnxr07jhrFdh6BwpuJcrTs
         i6og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v8zVS0j+ERe9ANo4F2P9rgRZMdkPw9iiMqRduQXdCYg=;
        fh=wfBadegfTucbcc5Zu9KgjTFm64yRF/YgUHjsk0g6AyM=;
        b=ABY3X5E15wjrJYJ7KiIEUgnGjZwtCOthVuR9vhRpuMij/YtoRsjmHcuPzjm+ievDJ+
         B9/R25sC8gyUqCUgj7XaorOhNEyGnb7R1IaZwO08ruPXpuabxprLfaocqNHaFO427LlG
         /6Th7iYamtk7x7Udsl2xYyVTqS4kila3VEEPeowtGjtiwwDlhz81F2ri4xa2TlDRe6PK
         qNT614SCZhCgKHdDLdbjA6gVrJCaGrRqiMoAxmdcHQmJ266XM5jddQ4RHCT3ZF/xw4yL
         c59zgkCmvPsKtPSXtoCpJnPS1QJMzxHyTEg7nB9l/rXZlY8TyFj1Awo1Rw53qFHdU8Vn
         3UVg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770847589; x=1771452389; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v8zVS0j+ERe9ANo4F2P9rgRZMdkPw9iiMqRduQXdCYg=;
        b=Dwj1kfAROEbIsSYJTc0UapNzYvkqnXpTVCPBfxXrt3cRER6zV0MUKowKq2oJmQkqyX
         lCQUuS2KaCgz5I28xjGHEiCA3ey6B/nGg9rJNHIzJ7k6JRZDp0EFAM+pjUDDTbanofTv
         Zb74EN1Dk3PoDsOtJFaz8Bdr4FRwjtfSe1++lTWynImiqa2koR7AeFSgwVNvs/8s9yVL
         VeRGGmlQCgP3DsR1N266/63XT7G2wIx0MwwXF1TvzK0K2YU0De8xmM9Aagc1Y5hjVcJy
         M4uaUOQQ9PPbK0C8MSbBX7lNAINPGO3ERbJ93vf6xe3StJvUFOthA3NGyENc7003Gxzs
         kWHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770847589; x=1771452389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v8zVS0j+ERe9ANo4F2P9rgRZMdkPw9iiMqRduQXdCYg=;
        b=fiBgKWGR/fbIGjx4e4tuLIhekivE0s5+lYfw2edl7X15ZCiyt9Fm8XBuBjsaGYoU9l
         N6+7K0GIx3PZiqBAr0JKaex+kjaH6T2GzIujLtfkjGYWFFEiyPkJgaYo85pdQBfQB0KO
         B5lIoc/PcP15jnTssAKvroy0bIgTbJdAPr/EO6tvjKCtgLTBxM2N/CRDvYqjkJa23qBG
         6kZNYNzQVSa53Z+hHMFt/fv8BcJP+UDz6fp1mSraXToGDJ8tepc+0p7HiXXKKR8jiZL0
         j8cGsLQ53b/zRSRbviw8oOm5LC6NFzgjt0Se+JQcLrySz5SHsE31oUF33ndZUgy+35jx
         uG7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVPvTNLfOQICLTiPevQY9OE1ucRJcKxpXLHTPCjO7/8WLskmYWaa8unrQ0rRFBO23UgqSMg3yVPbQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxFj8iyq9CUlJxIbvYQbCtr5m8HtQKETFUF4NNah0k+8rE6JXEO
	jR3yKRBZ5HGHirQGPj2WCHpgkX6V/8lz13ClFiZ5oXL36PXWzBtK6D/z+++MWPWnNcdit+Ns6ul
	KSCOnTTigQbN/Vynq5jSPJWvq7BmWYyg=
X-Gm-Gg: AZuq6aIRZrIqryMV7ddV7zGlV27ymyXmKW4txqj5as3W91JE2TzGFahBdjBCUpubuS0
	3/mW3C07PKDSjoWMLQHclZA6OCSogwk9Irj9Q29HgMGkBYRCisv43W9+m8xY0qITynIwyQ2Mhxa
	n8vuoT5H2QSru6PofKdI2nngWUGevTKu0XrZKHiT7yHBa3r/CShMYYlge2XLaixkBtchjNeGP/R
	eAItchVeFkHgS2YYQ2gsTTEFpGVhc/8pvoil527P51Fvx+zIUQpBrwg5GXo1rqRoZ2z6alDU7SA
	R4I0eUtZM6pm6YlY
X-Received: by 2002:a05:622a:1a89:b0:502:9f97:72c3 with SMTP id
 d75a77b69052e-50691ef8ce4mr14375291cf.43.1770847588832; Wed, 11 Feb 2026
 14:06:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com> <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <CAJnrk1ZZyYmwtzcHAnv2x8rt=ZVsz7CXCVV6jtgMMDZytyxp3A@mail.gmail.com> <1c657f67-0862-4e13-9c71-7217aeecef61@gmail.com>
In-Reply-To: <1c657f67-0862-4e13-9c71-7217aeecef61@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 11 Feb 2026 14:06:18 -0800
X-Gm-Features: AZwV_QjPgyCm0eAFeh7uwGSOqZkDBjFgaq7olGwzQXizo2TroZDfCBo5zqXJ1z4
Message-ID: <CAJnrk1YXmxqUnT561-J7seaicxFRJTyJ=F3_MX1rmtAROC6Ybg@mail.gmail.com>
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, csander@purestorage.com, 
	krisman@suse.de, bernd@bsbernd.com, hch@infradead.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12171-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 2D237127F59
X-Rspamd-Action: no action

On Wed, Feb 11, 2026 at 4:01=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 2/10/26 19:39, Joanne Koong wrote:
> > On Tue, Feb 10, 2026 at 8:34=E2=80=AFAM Pavel Begunkov <asml.silence@gm=
ail.com> wrote:
> ...
> >>> -/* argument for IORING_(UN)REGISTER_PBUF_RING */
> >>> +/* argument for IORING_(UN)REGISTER_PBUF_RING and
> >>> + * IORING_(UN)REGISTER_KMBUF_RING
> >>> + */
> >>>    struct io_uring_buf_reg {
> >>> -     __u64   ring_addr;
> >>> +     union {
> >>> +             /* used for pbuf rings */
> >>> +             __u64   ring_addr;
> >>> +             /* used for kmbuf rings */
> >>> +             __u32   buf_size;
> >>
> >> If you're creating a region, there should be no reason why it
> >> can't work with user passed memory. You're fencing yourself off
> >> optimisations that are already there like huge pages.
> >
> > Are there any optimizations with user-allocated buffers that wouldn't
> > be possible with kernel-allocated buffers? For huge pages, can't the
> > kernel do this as well (eg I see in io_mem_alloc_compound(), it calls
> > into alloc_pages() with order > 0)?
>
> Yes, there is handful of differences. To name one, 1MB allocation won't
> get you a PMD mappable huge page, while user space can allocate 2MB,
> register the first 1MB and reuse the rest for other purposes.
>
> >>> +     };
> >>>        __u32   ring_entries;
> >>>        __u16   bgid;
> >>>        __u16   flags;
> >>> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> >>> index aa9b70b72db4..9bc36451d083 100644
> >>> --- a/io_uring/kbuf.c
> >>> +++ b/io_uring/kbuf.c
> >> ...
> >>> +static int io_setup_kmbuf_ring(struct io_ring_ctx *ctx,
> >>> +                            struct io_buffer_list *bl,
> >>> +                            struct io_uring_buf_reg *reg)
> >>> +{
> >>> +     struct io_uring_buf_ring *ring;
> >>> +     unsigned long ring_size;
> >>> +     void *buf_region;
> >>> +     unsigned int i;
> >>> +     int ret;
> >>> +
> >>> +     /* allocate pages for the ring structure */
> >>> +     ring_size =3D flex_array_size(ring, bufs, bl->nr_entries);
> >>> +     ring =3D kzalloc(ring_size, GFP_KERNEL_ACCOUNT);
> >>> +     if (!ring)
> >>> +             return -ENOMEM;
> >>> +
> >>> +     ret =3D io_create_region_multi_buf(ctx, &bl->region, bl->nr_ent=
ries,
> >>> +                                      reg->buf_size);
> >>
> >> Please use io_create_region(), the new function does nothing new
> >> and only violates abstractions.
> >
> > There's separate checks needed between io_create_region() and
> > io_create_region_multi_buf() (eg IORING_MEM_REGION_TYPE_USER flag
>
> If io_create_region() is too strict, let's discuss that in
> examples if there are any, but it's likely not a good idea changing
> that. If it's too lax, filter arguments in the caller. IOW, don't
> pass IORING_MEM_REGION_TYPE_USER if it's not used.
>
> > checking) and different allocation calls (eg
> > io_region_allocate_pages() vs io_region_allocate_pages_multi_buf()).
>
> I saw that and saying that all memmap.c changes can get dropped.
> You're using it as one big virtually contig kernel memory range then
> chunked into buffers, and that's pretty much what you're getting with
> normal io_create_region(). I get that you only need it to be
> contiguous within a single buffer, but that's not what you're doing,
> and it'll be only worse than default io_create_region() e.g.
> effectively disabling any usefulness of io_mem_alloc_compound(),
> and ultimately you don't need to care.

When I originally implemented it, I had it use
io_region_allocate_pages() but this fails because it's allocating way
too much memory at once. For fuse's use case, each buffer is usually
at least 1 MB if not more. Allocating the memory one buffer a time in
io_region_allocate_pages_multi_buf() bypasses the allocation errors I
was seeing. That's the main reason I don't think this can just use
io_create_region().

>
> Regions shouldn't know anything about your buffers, how it's
> subdivided after, etc.
>
> > Maybe I'm misinterpreting your comment (or the code), but I'm not
> > seeing how this can just use io_create_region().
>
> struct io_uring_region_desc rd =3D {};
> total_size =3D nr_bufs * buf_size;
> rd.size =3D PAGE_ALIGN(total_size);
> io_create_region(&region, &rd);
>
> Add something like this for user provided memory:
>
> if (use_user_memory) {
>         rd.user_addr =3D uaddr;
>         rd.flags |=3D IORING_MEM_REGION_TYPE_USER;
> }
>
>
> >> Provided buffer rings with kernel addresses could be an interesting
> >> abstraction, but why is it also responsible for allocating buffers?
> >
> > Conceptually, I think it makes the interface and lifecycle management
> > simpler/cleaner. With registering it from userspace, imo there's
> > additional complications with no tangible benefits, eg it's not
> > guaranteed that the memory regions registered for the buffers are the
> > same size, with allocating it from the kernel-side we can guarantee
> > that the pages are allocated physically contiguously, userspace setup
> > with user-allocated buffers is less straightforward, etc. In general,
> > I'm just not really seeing what advantages there are in allocating the
> > buffers from userspace. Could you elaborate on that part more?
>
> I don't think I follow. I'm saying that it might be interesting
> to separate rings from how and with what they're populated on the
> kernel API level, but the fuse kernel module can do the population

Oh okay, from your first message I (and I think christoph too) thought
what you were saying is that the user should be responsible for
allocating the buffers with complete ownership over them, and then
just pass those allocated to the kernel to use. But what you're saying
is that just use a different way for getting the kernel to allocate
the buffers (eg through the IORING_REGISTER_MEM_REGION interface). Am
I reading this correctly?

> and get exactly same layout as you currently have:
>
> int fuse_create_ring(size_t region_offset /* user space argument */) {
>         struct io_mapped_region *mr =3D get_mem_region(ctx);
>         // that can take full control of the ring
>         ring =3D grab_empty_ring(io_uring_ctx);
>
>         size =3D nr_bufs * buf_size;
>         if (region_offset + size > get_size(mr)) // + other validation
>                 return error;
>
>         buf =3D mr_get_ptr(mr) + offset;
>         for (i =3D 0; i < nr_bufs; i++) {
>                 ring_push_buffer(ring, buf, buf_size);
>                 buf +=3D buf_size;
>         }
> }
>
> fuse might not care, but with empty rings other users will get a
> channel they can use to do IO (e.g. read requests) using their
> kernel addresses in the future.
>
> >> What I'd do:
> >>
> >> 1. Strip buffer allocation from IORING_REGISTER_KMBUF_RING.
> >> 2. Replace *_REGISTER_KMBUF_RING with *_REGISTER_PBUF_RING + a new fla=
g.
> >>      Or maybe don't expose it to the user at all and create it from
> >>      fuse via internal API.
> >
> > If kmbuf rings are squashed into pbuf rings, then pbuf rings will need
> > to support pinning. In fuse, there are some contexts where you can't
>
> It'd change uapi but not internals, you already piggy back it
> on pbuf implementation and differentiate with a flag.
>
> It could basically be:
>
> if (flags & IOU_PBUF_RING_KM)
>         bl->flags |=3D IOBL_KERNEL_MANAGED;
>
> Pinning can be gated on that flag as well. Pretty likely uapi
> and internals will be a bit cleaner, but that's not a huge deal,
> just don't see why would you roll out a separate set of uapi
> ([un]register, offsets, etc.) when essentially it can be treated
> as the same thing.

imo, it looked cleaner as a separate api because it has different
expectations and behaviors and squashing kmbuf into the pbuf api makes
the pbuf api needlessly more complex. Though I guess from the
userspace pov, liburing could have a wrapper that takes care of
setting up the pbuf details for kernel-managed pbufs. But in my head,
having pbufs vs. kmbufs makes it clearer what each one does vs regular
pbufs vs. pbufs that are kernel-managed.

Especially with now having kmbufs go through the ioring mem region
interface, it makes things more confusing imo if they're combined, eg
pbufs that are kernel-managed are created empty and then populated
from the kernel side by whatever subsystem is using them. Right now
there's only one mem region supported per ring, but in the future if
there's the possibility that multiple mem regions can be registered
(eg if userspace doesn't know upfront what mem region length they'll
need), then we should also probably add in a region id param for the
registration arg, which if kmbuf rings go through the pbuf ring
registration api, is not possible to do.

But I'm happy to combine the interfaces and go with your suggestion.
I'll make this change for v2 unless someone else objects.

>
> > grab the uring mutex because you're running in atomic context and this
> > can be encountered while recycling the buffer. I originally had a
> > patch adding pinning to pbuf rings (to mitigate the overhead of
> > registered buffers lookups)
>
> IIRC, you was pinning the registered buffer table and not provided

Yeah, you're right I misremembered and the objections / patch I
dropped was pinning the registered buffer table, not the pbuf ring

> buffer rings? Which would indeed be a bad idea. Thinking about it,
> fwiw, instead of creating multiple registered buffers and trying to
> lock the entire table, you could've kept all memory in one larger
> registered buffer and pinned only it. It's already refcounted, so
> shouldn't have been much of a problem.

Hmm, I'm not sure this idea would work for sparse buffers populated by
the kernel, unless those are automatically pinned too but then from
the user POV for unregistration they'd need to unregister buffers
individually instead of just calling IORING_UNREGISTER_BUFFERS but it
might be annoying for them to now need to know which buffers are
pinned vs not. When i benchmarked the fuse code with vs without pinned
registered buffers, it didn't seem to make much of a difference
performance-wise thankfully, so I just dropped it.

>
> > but dropped it when Jens and Caleb didn't
> > like the idea. But for kmbuf rings, pinning will be necessary for
> > fuse.
> >
> >> 3. Require the user to register a memory region of appropriate size,
> >>      see IORING_REGISTER_MEM_REGION, ctx->param_region. Make fuse
> >>      populating the buffer ring using the memory region.
>
> To explain why, I don't think that creating many small regions
> is a good direction going forward. In case of kernel allocation,
> it's extra mmap()s, extra user space management, and wasted space.

To clarify, is this in reply to why the individual buffers shouldn't
be allocated separately by the kernel?
I added a comment about this above in the discussion about
io_region_allocate_pages_multi_buf(), and if the memory allocation
issue I was seeing is bypassable and the region can be allocated all
at once, I'm happy to make that change. With having the allocation be
separate buffers though, I'm not sure I agree that there are extra
mmaps / userspace management. All the pages across the buffers are
vmapped together and the userspace just needs to do 1 mmap call for
them. On the userspace side, I don't think there's more management
since the mmapped address represents the range across all the buffers.
I'm not seeing how there's wasted space either since the only
requirement is that the buffer size is page aligned. I think also
there's a higher chance of the entire buffer region being physically
contiguous if each buffer is allocated separately vs. all the buffers
are allocated as 1 region. I don't feel strongly about this either way
and I'm happy to allocate the entire region at once if that's
possible.

> For user provided memory it's over-accounting and extra memory
> footprint. It'll also give you better lifecycle guarantees, i.e.

Just out of curiosity, could you elaborate on the over-accounting and
extra memory footprint? I was under the impression it would be the
same since the accounting gets adjusted by the total bytes allocated?
For the extra memory footprint, is the extra footprint from the
metadata to describe each buffer region, or are you referring to
something else?

> you won't be able to free buffers while there are requests for the
> context. I'm not so sure about ring bound memory, let's say I have
> my suspicions, and you'd need to be extra careful about buffer
> lifetimes even after a fuse instance dies.
>
> >> I wanted to make regions shareable anyway (need it for other purposes)=
,
> >> I can toss patches for that tomorrow.
> >>
> >> A separate question is whether extending buffer rings is the right
> >> approach as it seems like you're only using it for fuse requests and
> >> not for passing buffers to normal requests, but I don't see the
> >
> > What are 'normal requests'? For fuse's use case, there are only fuse re=
quests.
>
> Any kind of read/recv/etc. that can use provided buffers. It's
> where kernel memory filled rings would shine, as you'd be able
> to use them together without changing any opcode specific code.
> I.e. not changes in read request implementation, only kbuf.c
>

Thanks for your input on the series. To iterate / sum up, these are
changes for v2 I'll be making:
- api-wise from userspace/liburing: get rid of KMBUF_RING api
interface and have users go through PBUF_RING api instead with a flag
indicating the ring is kernel-managed
- have kernel buffer allocation go through IORING_REGISTER_MEM_REGION
instead, which means when the pbuf ring is created and the
kernel-managed flag is set, the ring will be empty. The memory region
will need to be registered before the mmap call to the ring fd.
- add apis for subsystems to populate a kernel-managed buffer ring
with addresses from the registered mem region

Does this align with your understanding of the conversation as well or
is there anything I'm missing?

And Christoph, do these changes for v2 work for your use case as well?

Thanks,
Joanne
> --
> Pavel Begunkov
>

