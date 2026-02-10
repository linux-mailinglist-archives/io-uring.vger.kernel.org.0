Return-Path: <io-uring+bounces-12144-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SFYYHH6Ji2nYVgAAu9opvQ
	(envelope-from <io-uring+bounces-12144-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 20:39:42 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A55A511EB34
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 20:39:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E4D6B3024144
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 19:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D5EF2F9D98;
	Tue, 10 Feb 2026 19:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hmI1ZZ7p"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3D7265629
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 19:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770752378; cv=pass; b=cFSN7UxRUS73egdXPubvzdZ6DITAJFS5Uj39Gqw8J1W1tNXlY/dnLyAcjCCapNjvMhDsNdRnLL38QmSmt12vnUaZUOe3zizJwD2ikKWX2BZmUyToE5sF6msYuY5n5niwpLaMdNUQw4oKKlcAkkPlAe3kQ13Y0eAusFPpDwn4gUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770752378; c=relaxed/simple;
	bh=1eiMN9YED+bohc5f+jlBHezjbKp34B9MdQq7qe4YDbM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QW+CQn8udH4C1BbJBB8LQVT+EgtrUqON5rnAWXL9FdvBaPmUzwcKEMFSBoX0bwCpc251cuSHQ9cHXkuXFgq9U9fUhAfktkhtQEdMzXrxTZYWNg6d0XVmFQIUBIH35vpMQib8rpNZnLh9alMWL4PWTN9av4fShlL0LAamt5AEMYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hmI1ZZ7p; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5036d7d14easo54594181cf.1
        for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 11:39:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770752376; cv=none;
        d=google.com; s=arc-20240605;
        b=Ph1ETK/2cc2R2kAJl5sUGfCpKqqTQEI/29vYHpasU++8DQ/lcWUxmY4j/1PSIlSWgL
         fK+18TszMR/xho5hYyioNGVBQ+FEHgUJDiccK3fx/UOjsCys/9YY8XMcHI3LUHxJWC0p
         09pXXp8yj8Iyuk2JCrURABY8VpqM+UogHMz1Qcz4GloKQQSgtBtg0p9oJ5xNXj/QGU2O
         upGoo10/F5WylkDMU9gK95+EIt/qbQmQomaQ/N2sxD88vhIYge00bqfezEmOXY88unix
         ay0ZAXmymLCH+Fgt/p8mbN7f5NwU7XWsoCXgAm7q9Io9jAIWsVz6aVd6ARhRZ2Aqw2Sx
         ajnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=soCVu+PnjoqeOTg7buf7zgGuMZiUBaN37i4ynt8LPRI=;
        fh=9ySwWkYZ5cDVLO050OsSQo9FYKPKUoKtDdWi6o4Kx4E=;
        b=UTEiY3gCRRzjYtYyj7X56Gt+rIwAFUjGifTIA1FIYM20Fx8Iu36YeiHstVJvhPhDDY
         VjH7NPl7BQb3/tn11rg1GflfdVcXG3/Do1i3IAiz7E9fHMXkyaIfBIqalwBuqfLIq1z2
         lr9LVj67ndmPgcrGd6XwIBsn0qDTnVsK9d/4vt2Gnw9po0CAaJ9bwC1MUliZw24FO7Ca
         1BZROzpIMQrs7yaWc/l5mZrvOA/qqnP2d/ni7la9EMRAQXk/rPlA73HGARE+qK70GOLR
         /1NyzNQ4uy+SA5wuAkuXrTr9Qyxf24FTSBgobIwnV3JobRxbzXIt6Hlk7uOoRprunq1D
         z4bg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770752376; x=1771357176; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=soCVu+PnjoqeOTg7buf7zgGuMZiUBaN37i4ynt8LPRI=;
        b=hmI1ZZ7pqVUDMEQDiJ859jM7i0vGh+2+p9vF5U4ADPBfx/dafnRa/VAdCXSAshPfzd
         HdE6Hgko8UgP98MFiTe7veCwCBzMs1M7Oxq1+4QiZjyu9lFpO05qs9xNp/Ly2L6c1ve8
         Ff8QjsT+UIfJnSkingx4cY3mKvyetGNbyzWuW59MOCksdlL1+ausHjpBPyVO9HnfWsoS
         nJQnP/9qlUZ6JpekGua+P0Vpz2jq+E+L1qb1cY+lQhzwhSJq/Du+a0BoXbmrP5WWNfi6
         2PpF/SutFEZO6BTel4UUE+/P4L7EbK25esuZuzeZt7j0d1mw4ha/WPhJhHmjZAZauhnj
         iMMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770752376; x=1771357176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=soCVu+PnjoqeOTg7buf7zgGuMZiUBaN37i4ynt8LPRI=;
        b=LqJfpMdVDn0rVooc/eJENAGN7GQBqu1AL7wjJU2H9z2fxN/35rU1ga/LK4dwGWeJVo
         eNNJ+gcEXFoUgvKuNwGwFo7jwYQv+j6DBKqJ0Nb0Bl6em4Jq0hrHZ9YLmzafnDVHqGML
         0ANgXyqea9vv6W1sb6pCuxjlQZg5MImXYnlHzPFs7gMQF2MpJxfOmtZwJ1KOzg2wJp7C
         wiSwRc4+/NygfaBvjVPIFqOCwkUG8wqTZBaJLZhxHqxSz8R5T6o3exZMLShpv1v80hhw
         04eRvIYN7q6XUUeDiThFPa4/Yp0WOwn5k+M4oH30ocgdskvHc5uARVNvqaO853Fy1J5J
         mDCA==
X-Forwarded-Encrypted: i=1; AJvYcCUmuxqO95EF2ZKoYQ4PwH6T8NQxO3FhiyWGN31Gs5RRJO8NbuxgwEM0mNRyKyvkg+zlULYfupmyIA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwulX1K/tXFYYbf2Q/8/uj8AYymQsWqZc50X+EY+f3+yp0BXs4p
	xUCyXulsazhWPeC8McW0K2wCDNj/KEDEn0qUnmpEr+QQrmGUR4IOGyYHmae+4WIp2V1H69AsYPd
	ZqhfGPpG9+Pi+j/ySRyg9gC521rkw8Ls=
X-Gm-Gg: AZuq6aJDf/JQUypEZkQsTLV6SxaxPQk2uOcCM7+0BKRjt5r05RELeTaXSvsgTR/1FGo
	3hh36wMQIrFLsZmZwB4pS3+Y7vmSoAsy/G9S9npvVdWWylrHCB8ChOQYZUiwRCIzIwylBOSKxvy
	tQz3tk8q/uoT5KotSTnWie1XBHGF8jA2yoMRcnjiWN+g2a1fx/6Epide6080hVZoTJaAlIoDbEO
	IOowQEBcFnUltZ41aDs12kMTgc5DWxlYj74qla6oAsSKlD2KQssXtatM055VOuLjDBEI9IzbomK
	6GJFtGu2vxBeYmbNu5pnZB8=
X-Received: by 2002:a05:622a:f:b0:502:9a94:2f9c with SMTP id
 d75a77b69052e-50681222149mr4965371cf.44.1770752375936; Tue, 10 Feb 2026
 11:39:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com> <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
In-Reply-To: <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 10 Feb 2026 11:39:24 -0800
X-Gm-Features: AZwV_QhjafehVft-q3A-gCQ9GvCAADhAOZIAXNAQcWR24lAMH2Oc3NC01lOkf00
Message-ID: <CAJnrk1ZZyYmwtzcHAnv2x8rt=ZVsz7CXCVV6jtgMMDZytyxp3A@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12144-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A55A511EB34
X-Rspamd-Action: no action

On Tue, Feb 10, 2026 at 8:34=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 2/10/26 00:28, Joanne Koong wrote:
> > Add support for kernel-managed buffer rings (kmbuf rings), which allow
> > the kernel to allocate and manage the backing buffers for a buffer
> > ring, rather than requiring the application to provide and manage them.
> >
> > This introduces two new registration opcodes:
> > - IORING_REGISTER_KMBUF_RING: Register a kernel-managed buffer ring
> > - IORING_UNREGISTER_KMBUF_RING: Unregister a kernel-managed buffer ring
> >
> > The existing io_uring_buf_reg structure is extended with a union to
> > support both application-provided buffer rings (pbuf) and kernel-manage=
d
> > buffer rings (kmbuf):
> > - For pbuf rings: ring_addr specifies the user-provided ring address
> > - For kmbuf rings: buf_size specifies the size of each buffer. buf_size
> >    must be non-zero and page-aligned.
> >
> > The implementation follows the same pattern as pbuf ring registration,
> > reusing the validation and buffer list allocation helpers introduced in
> > earlier refactoring. The IOBL_KERNEL_MANAGED flag marks buffer lists as
> > kernel-managed for appropriate handling in the I/O path.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >   include/uapi/linux/io_uring.h |  15 ++++-
> >   io_uring/kbuf.c               |  81 ++++++++++++++++++++++++-
> >   io_uring/kbuf.h               |   7 ++-
> >   io_uring/memmap.c             | 111 +++++++++++++++++++++++++++++++++=
+
> >   io_uring/memmap.h             |   4 ++
> >   io_uring/register.c           |   7 +++
> >   6 files changed, 219 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_urin=
g.h
> > index fc473af6feb4..a0889c1744bd 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -715,6 +715,10 @@ enum io_uring_register_op {
> >       /* register bpf filtering programs */
> >       IORING_REGISTER_BPF_FILTER              =3D 37,
> >
> > +     /* register/unregister kernel-managed ring buffer group */
> > +     IORING_REGISTER_KMBUF_RING              =3D 38,
> > +     IORING_UNREGISTER_KMBUF_RING            =3D 39,
> > +
> >       /* this goes last */
> >       IORING_REGISTER_LAST,
> >
> > @@ -891,9 +895,16 @@ enum io_uring_register_pbuf_ring_flags {
> >       IOU_PBUF_RING_INC       =3D 2,
> >   };
> >
> > -/* argument for IORING_(UN)REGISTER_PBUF_RING */
> > +/* argument for IORING_(UN)REGISTER_PBUF_RING and
> > + * IORING_(UN)REGISTER_KMBUF_RING
> > + */
> >   struct io_uring_buf_reg {
> > -     __u64   ring_addr;
> > +     union {
> > +             /* used for pbuf rings */
> > +             __u64   ring_addr;
> > +             /* used for kmbuf rings */
> > +             __u32   buf_size;
>
> If you're creating a region, there should be no reason why it
> can't work with user passed memory. You're fencing yourself off
> optimisations that are already there like huge pages.

Are there any optimizations with user-allocated buffers that wouldn't
be possible with kernel-allocated buffers? For huge pages, can't the
kernel do this as well (eg I see in io_mem_alloc_compound(), it calls
into alloc_pages() with order > 0)?

>
> > +     };
> >       __u32   ring_entries;
> >       __u16   bgid;
> >       __u16   flags;
> > diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> > index aa9b70b72db4..9bc36451d083 100644
> > --- a/io_uring/kbuf.c
> > +++ b/io_uring/kbuf.c
> ...
> > +static int io_setup_kmbuf_ring(struct io_ring_ctx *ctx,
> > +                            struct io_buffer_list *bl,
> > +                            struct io_uring_buf_reg *reg)
> > +{
> > +     struct io_uring_buf_ring *ring;
> > +     unsigned long ring_size;
> > +     void *buf_region;
> > +     unsigned int i;
> > +     int ret;
> > +
> > +     /* allocate pages for the ring structure */
> > +     ring_size =3D flex_array_size(ring, bufs, bl->nr_entries);
> > +     ring =3D kzalloc(ring_size, GFP_KERNEL_ACCOUNT);
> > +     if (!ring)
> > +             return -ENOMEM;
> > +
> > +     ret =3D io_create_region_multi_buf(ctx, &bl->region, bl->nr_entri=
es,
> > +                                      reg->buf_size);
>
> Please use io_create_region(), the new function does nothing new
> and only violates abstractions.

There's separate checks needed between io_create_region() and
io_create_region_multi_buf() (eg IORING_MEM_REGION_TYPE_USER flag
checking) and different allocation calls (eg
io_region_allocate_pages() vs io_region_allocate_pages_multi_buf()).
Maybe I'm misinterpreting your comment (or the code), but I'm not
seeing how this can just use io_create_region().

>
> Provided buffer rings with kernel addresses could be an interesting
> abstraction, but why is it also responsible for allocating buffers?

Conceptually, I think it makes the interface and lifecycle management
simpler/cleaner. With registering it from userspace, imo there's
additional complications with no tangible benefits, eg it's not
guaranteed that the memory regions registered for the buffers are the
same size, with allocating it from the kernel-side we can guarantee
that the pages are allocated physically contiguously, userspace setup
with user-allocated buffers is less straightforward, etc. In general,
I'm just not really seeing what advantages there are in allocating the
buffers from userspace. Could you elaborate on that part more?

> What I'd do:
>
> 1. Strip buffer allocation from IORING_REGISTER_KMBUF_RING.
> 2. Replace *_REGISTER_KMBUF_RING with *_REGISTER_PBUF_RING + a new flag.
>     Or maybe don't expose it to the user at all and create it from
>     fuse via internal API.

If kmbuf rings are squashed into pbuf rings, then pbuf rings will need
to support pinning. In fuse, there are some contexts where you can't
grab the uring mutex because you're running in atomic context and this
can be encountered while recycling the buffer. I originally had a
patch adding pinning to pbuf rings (to mitigate the overhead of
registered buffers lookups) but dropped it when Jens and Caleb didn't
like the idea. But for kmbuf rings, pinning will be necessary for
fuse.

> 3. Require the user to register a memory region of appropriate size,
>     see IORING_REGISTER_MEM_REGION, ctx->param_region. Make fuse
>     populating the buffer ring using the memory region.
>
> I wanted to make regions shareable anyway (need it for other purposes),
> I can toss patches for that tomorrow.
>
> A separate question is whether extending buffer rings is the right
> approach as it seems like you're only using it for fuse requests and
> not for passing buffers to normal requests, but I don't see the

What are 'normal requests'? For fuse's use case, there are only fuse reques=
ts.

Thanks,
Joanne

> big picture here.
>
> > +     if (ret) {
> > +             kfree(ring);
> > +             return ret;
> > +     }
> > +
> > +     /* initialize ring buf entries to point to the buffers */
> > +     buf_region =3D bl->region.ptr;
>
> io_region_get_ptr()
>
> > +     for (i =3D 0; i < bl->nr_entries; i++) {
> > +             struct io_uring_buf *buf =3D &ring->bufs[i];
> > +
> > +             buf->addr =3D (u64)(uintptr_t)buf_region;
> > +             buf->len =3D reg->buf_size;
> > +             buf->bid =3D i;
> > +
> > +             buf_region +=3D reg->buf_size;
> > +     }
> > +     ring->tail =3D bl->nr_entries;
> > +
> > +     bl->buf_ring =3D ring;
> > +     bl->flags |=3D IOBL_KERNEL_MANAGED;
> > +
> > +     return 0;
> > +}
> > +
> > +int io_register_kmbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
> > +{
> > +     struct io_uring_buf_reg reg;
> > +     struct io_buffer_list *bl;
> > +     int ret;
> > +
> > +     lockdep_assert_held(&ctx->uring_lock);
> > +
> > +     ret =3D io_copy_and_validate_buf_reg(arg, &reg, 0);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (!reg.buf_size || !PAGE_ALIGNED(reg.buf_size))
>
> With io_create_region_multi_buf() gone, you shouldn't need
> to align every buffer, that could be a lot of wasted memory
> (thinking about 64KB pages).
>
> > +             return -EINVAL;
> > +
> > +     bl =3D io_alloc_new_buffer_list(ctx, &reg);
> > +     if (IS_ERR(bl))
> > +             return PTR_ERR(bl);
> > +
> > +     ret =3D io_setup_kmbuf_ring(ctx, bl, &reg);
> > +     if (ret) {
> > +             kfree(bl);
> > +             return ret;
> > +     }
> > +
> > +     ret =3D io_buffer_add_list(ctx, bl, reg.bgid);
> > +     if (ret)
> > +             io_put_bl(ctx, bl);
> > +
> > +     return ret;
>
> --
> Pavel Begunkov
>

