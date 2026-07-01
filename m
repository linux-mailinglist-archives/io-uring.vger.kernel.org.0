Return-Path: <io-uring+bounces-13870-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id xVtYLuQmRWqR7woAu9opvQ
	(envelope-from <io-uring+bounces-13870-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Jul 2026 16:40:36 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 62BE36EEDFD
	for <lists+io-uring@lfdr.de>; Wed, 01 Jul 2026 16:40:36 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T1tNx+yE;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13870-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13870-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 818083039A53
	for <lists+io-uring@lfdr.de>; Wed,  1 Jul 2026 14:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B8B4349CFC;
	Wed,  1 Jul 2026 14:34:17 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E97349CF3
	for <io-uring@vger.kernel.org>; Wed,  1 Jul 2026 14:34:14 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782916457; cv=pass; b=RXy3WWIK2T95breyVYVhd/uzywIgk5on3iOnZPAogXMI7fLUALmV12+glzUNX6creWe97qy6OMqr3o/s+NL4AvxQOy/7aWtlZ9Fy62KiITzWxEthO9v6MLrFEG/rPlvF+ulIfa7kUNS5xYM6gmy/2VZT0/6zgXKVffYia3udA64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782916457; c=relaxed/simple;
	bh=nScH6XgHWG5/YH6hVP52IOK9IGeYY63RZu3Ttrlpw3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qhjnm+VdlCewKvOiaPnDlyw37Nf53Q8dl6Sg6426OAcsg0WU8+2ugAhbZ5DComKX9nxM1o3fNre0LfZkzOR9i/dLzSootAxvBc9ckAIdx1ITIHoHZMFp1htUzgyaKwNxWJ9uJPuv3LYzuPszSrDVK6HppswuPTbHHYGnxWfaerE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T1tNx+yE; arc=pass smtp.client-ip=74.125.82.42
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-13986d61b4fso853783c88.0
        for <io-uring@vger.kernel.org>; Wed, 01 Jul 2026 07:34:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782916454; cv=none;
        d=google.com; s=arc-20260327;
        b=BRnQQf89+WoKxXPrTMUf0CYAwY257rbbIk50iyzInZ04APmYv1KZJQQGk3ScsRGiTn
         TZKzmVm/GpDmVjrF3BF80DDTtdxMcxVjX+LntK963V6CCOQuyPVtzkXI/Ag1o3+V9mwt
         yoqKmZ0AYw9GH/OGFjCJHcyTxyvkH6s8JbJKK9no1jy4AKdAJhzky2MUPQRdgNu2b+09
         dDK10NKy9GR4kJBDjTkrFOA5ydJ6SVBnisBrECNoPT5rp/AgSjJTzsl847olvc/zwCON
         wSl/B1/Xevnbitfji5G0DkIhEUspbiagFmY6c5KU9UhszH/3YaDvNh8ITGQCmtfKefLr
         27+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iwVYZrdp3pBufrtH9uIwN+HSbNCrXKXub0G6eGVamA4=;
        fh=XHx2WTmJbLKAI3bQHoXYOZfPN0Olc+0yJ/JTHas+Lbo=;
        b=noOCssJH0PUFFl0dB60c3g6HTXmxPnPnKZOT1PxtPwoUyCab8Awg0GyypXog3banQq
         Ha3PmPER5YjUfXoWBAzivE2yLaRsG313VoKyF2kwRcu8hUPNkUoY74anmyzv32seqpWZ
         ShsgZpZnf5a8kLtNB30/oTD4FRUvnx0aTr0tIYbp+YB7NkcKAfC+ZyJQkaAxGOb026Dk
         XPPCYcxDWzI88KCa9H9es5xQ5WWqC/z6wgoIqvTnPKvI87lTW/5eYoOJi3k+Wnu89V9I
         8s7qQKpuU7WLEl/rKL41kkJpzZ55M79wDEyDncfy2/Bpf+M2Plu7kxEvzAivympHaLe1
         HDGw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782916454; x=1783521254; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iwVYZrdp3pBufrtH9uIwN+HSbNCrXKXub0G6eGVamA4=;
        b=T1tNx+yENEh3x37rJHzN8+Vmv/LwdAZ9cw6neYGvMByiftZi33PpK+HDp8N6vNxyGr
         bEKxaASGPW3jQ9QtjKBL+uHJtXd5NOTldBEHOXmlItohKI0lu00pELB3aybaP8IctN+6
         0/IPPmmyKJuNzOwp5k0YxrhBiIYVD/SeVGmQnqq9DnZ+XNvtc0wdvZc/ct1X9n52Xw3v
         2jDMtq7FNuxAXexbCG3oMDeuaUxyqZme7W8HWoFjw7IM939mOMDYaMBwx5cNcYOPRpFB
         XH/zwDdy+HPRHNJgBv7vdDvXAbzPMl0gBMneNicJu5enj2ehV6YvK21uQgG1CgIcA5Nu
         m2Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782916454; x=1783521254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iwVYZrdp3pBufrtH9uIwN+HSbNCrXKXub0G6eGVamA4=;
        b=DMZKpGPWy5XHDud8HpH+Ou5WGb9X9XMzPmoO9Ssb8aBFfGhFba0B83Ik9PYswBjf9z
         kqKs0VKjCBdrSY8cCEfRNbLY8hLiwKJRyonzG12E5ka5FfMGjWUA9zFFHmleeOKKGpBu
         upsMuFZrq6Bu1eQRXyjRQj/YuDCI+TVlLBHy1zojBZP+l+a7I46a4aZWXF6rzvgnMMY+
         uLqTRv3GOxqBR0x1XkiQCG0lSP8NVlddTQ7bZ0bdDxudxMgTOFqCzlsWNxglyUDxKQdS
         gL0ceThWGg1eChomNTlRSFpCksefWBERD3lcjICg+49jS+1nmqnf/wuIvSeU8MiuKIh8
         TnHg==
X-Forwarded-Encrypted: i=1; AFNElJ9yYJR0PCIYvWJ/WTry/OZKfji8qJE2dg6X9wae4xwVYjA75JWDUK/vkaQfVyuryA6yx0w+6XSCrA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWWeytT5aW1xihH2SSALIoWryzpmCNtUa03wkm96q4WpVljqpa
	oii2TnMxSAZHtMzS5e1Z5meiqJ3CvNe5fFKLYpKG42pKvf9GPM56BVc3s5jdiHGJaTwHKaYxmwx
	FmhCNxDq2jcuiq21y2h79Tjnh7RJ2LoA=
X-Gm-Gg: AfdE7cneCp5uotL7/+6ZfV75NlCO9Mhu6oeyFigOjQ8bZCrbCXwqUxC/GSuLjC67E5M
	X4D2UKuLnrx5+Muo7p/bvsmFM1qW3RS2iEBc2zYdO+fFiQMow/RsYD7YYcBTFJPBt++PP7Lqcop
	QvXZRdUgFN1Vx/XEXxruMr88H6TBN5tpQ92Cy5SK7AfuMqveyOUGF1BGhmkiaeeA2DjdMpLEyvE
	fir6r0sycvCuCrjw1JmIbIKX4z1Z3I7A8RaaN7UzMDpqyMIs2YdxBeEMl53g0Mfb5IUKRMle47L
	RCo9CmsRjAQ7xpmzLqOwfN2w9Ud5
X-Received: by 2002:a05:7022:41a3:b0:139:f42b:312a with SMTP id
 a92af1059eb24-13b36e15beemr1742401c88.47.1782916453970; Wed, 01 Jul 2026
 07:34:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624073921.11037-1-harshal24.chavan@gmail.com>
 <20260624124019.4521-1-harshal24.chavan@gmail.com> <87fr2auzq3.fsf@mailhost.krisman.be>
In-Reply-To: <87fr2auzq3.fsf@mailhost.krisman.be>
From: Harshal Chavan <harshal24.chavan@gmail.com>
Date: Wed, 1 Jul 2026 20:04:01 +0530
X-Gm-Features: AVVi8Cd54HdvfcZK3ijCUjZXZJ4rdeAEo9_ckhBzjXUfbmwuFveHh4ESAyr6KSM
Message-ID: <CADCAkb6wuR7vT3chfFtBL0qma+gx-2mJM7v+JJLS00W3oyb5dg@mail.gmail.com>
Subject: Re: [PATCH v6] io_uring/register: add IORING_REGISTER_CLONE_FILES opcode
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: axboe@kernel.dk, gregkh@linuxfoundation.org, gustavoars@kernel.org, 
	io-uring@vger.kernel.org, kees@kernel.org, linux-hardening@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-13870-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:krisman@suse.de,m:axboe@kernel.dk,m:gregkh@linuxfoundation.org,m:gustavoars@kernel.org,m:io-uring@vger.kernel.org,m:kees@kernel.org,m:linux-hardening@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,suse.de:email,mail.gmail.com:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 62BE36EEDFD

>> +     file =3D io_slot_file(src_node);
>> +     get_file(file);
>> +     io_fixed_file_set(dst_node, file);

> don't you need to copy the src_node->tag here as well?

Yes, sorry for the silly mistakes, thanks for catching this!

> I didn't get a chance to run it yet, sorry.  I'd suggest you wait for
> Jens feedback before pushing the v7 too, so you don't need to keep
> iterating drop by drop :)

Okay, Yes I will wait for feedback from Jens and send the changes together
Thanks for the review.

Regards,
Harshal Chavan

On Fri, Jun 26, 2026 at 2:03=E2=80=AFAM Gabriel Krisman Bertazi <krisman@su=
se.de> wrote:
>
> Harshal Chavan <harshal24.chavan@gmail.com> writes:
>
> > Currently, if an application wants to duplicate registered file
> > descriptors from one io_uring instance to another, it must manually
> > unregister and re-register them, incurring unnecessary overhead.
> >
> > Add IORING_REGISTER_CLONE_FILES to allow direct cloning of the file
> > table from a source ring to a destination ring. This implementation
> > strictly mirrors the io_clone_buffers UAPI, supporting partial offsets
> > and the IORING_REGISTER_DST_REPLACE flag.
> >
> > To ensure lock synchronization safety, destination nodes are strictly
> > allocated as new, private io_rsrc_nodes rather than sharing references
> > across rings.
> >
> > Signed-off-by: Harshal Chavan <harshal24.chavan@gmail.com>
> >
> > ---
> > Sorry for the noise on the previous email! I accidentally sent the patc=
h
> > before running checkpatch and missed a whitespace error. This v6 correc=
ts it.
> >
> > v6:
> >   - Fixed trailing whitespace checkpatch error.
> > v5:
> >   - Added missing spacing in comment (Gabriel).
> >   - Removed ctx->user and mm_account checks (Gabriel).
> >   - Used !! for boolean conversion (Gabriel).
> >   - Moved mutex_unlock unconditionally above the out label (Gabriel).
> >   - liburing implementation and tests: https://github.com/axboe/liburin=
g/pull/1606
> > v4:
> >   - Updated Signed-off-by to use real name and moved above the scissors=
 line (Greg KH).
> > v3:
> >   - Rewrote the cloning loop to allocate private destination nodes via =
io_rsrc_node_alloc to fix non-atomic ref lock synchronization (Jens).
> >   - Maintained partial offset/copy support to mirror io_clone_buffers U=
API (Jens).
> >   - Gated the replacement free check on ctx->file_table.data.nr (Gabrie=
l).
> >   - Prevented self-cloning by checking ctx =3D=3D src_ctx (Gabriel).
> >   - Removed submitter_task check to allow cross-thread pooling setups (=
Gabriel).
> > v2:
> >   - Dropped unrelated whitespace formatting changes from v1
>
> > +static int io_clone_file_node(struct io_ring_ctx *ctx,
> > +                           struct io_rsrc_node *src_node,
> > +                           int dst_index,
> > +                           struct io_file_table *new_table)
> > +{
> > +     struct io_rsrc_node *dst_node;
> > +     struct file *file;
> > +
> > +     dst_node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
> > +     if (!dst_node)
> > +             return -ENOMEM;
> > +
> > +     file =3D io_slot_file(src_node);
> > +     get_file(file);
> > +     io_fixed_file_set(dst_node, file);
>
> don't you need to copy the src_node->tag here as well?
>
> I didn't get a chance to run it yet, sorry.  I'd suggest you wait for
> Jens feedback before pushing the v7 too, so you don't need to keep
> iterating drop by drop :)
>
> > +
> > +     new_table->data.nodes[dst_index] =3D dst_node;
> > +     io_file_bitmap_set(new_table, dst_index);
> > +
> > +     return 0;
> > +}
> > +
> > +static int io_clone_files(struct io_ring_ctx *ctx, struct io_ring_ctx =
*src_ctx,
> > +                       struct io_uring_clone_files *arg)
> > +{
> > +     struct io_file_table new_file_table;
> > +     unsigned int dst_nr =3D ctx->file_table.data.nr;
> > +     unsigned int src_nr =3D src_ctx->file_table.data.nr;
> > +     unsigned int new_nr, i;
> > +
> > +     lockdep_assert_held(&ctx->uring_lock);
> > +     lockdep_assert_held(&src_ctx->uring_lock);
> > +
> > +     if (dst_nr && !(arg->flags & IORING_REGISTER_DST_REPLACE))
> > +             return -EBUSY;
> > +
> > +     if (!src_nr)
> > +             return -ENXIO;
> > +
> > +     if (!arg->nr)
> > +             arg->nr =3D src_nr;
> > +     else if (arg->nr > src_nr)
> > +             return -EINVAL;
> > +
> > +     if (check_add_overflow(arg->src_off, arg->nr, &i) || i > src_nr)
> > +             return -EINVAL;
> > +     if (check_add_overflow(arg->dst_off, arg->nr, &i))
> > +             return -EINVAL;
> > +
> > +     new_nr =3D max(dst_nr, arg->dst_off + arg->nr);
> > +     if (new_nr > IORING_MAX_FIXED_FILES)
> > +             return -EINVAL;
> > +
> > +     memset(&new_file_table, 0, sizeof(new_file_table));
> > +     if (!io_alloc_file_tables(ctx, &new_file_table, new_nr))
> > +             return -ENOMEM;
> > +
> > +     /* Copy original nodes from before the cloned range */
> > +     for (i =3D 0; i < min(arg->dst_off, dst_nr); i++) {
> > +             struct io_rsrc_node *src_node =3D io_rsrc_node_lookup(&ct=
x->file_table.data, i);
> > +
> > +             if (!src_node)
> > +                     continue;
> > +             if (io_clone_file_node(ctx, src_node, i, &new_file_table)=
)
> > +                     goto out;
> > +     }
> > +
> > +     /* Copy the actual cloned range from the source ring */
> > +     for (i =3D 0; i < arg->nr; i++) {
> > +             struct io_rsrc_node *src_node =3D io_rsrc_node_lookup(&sr=
c_ctx->file_table.data,
> > +                             arg->src_off + i);
> > +
> > +             if (!src_node)
> > +                     continue;
> > +             if (io_clone_file_node(ctx, src_node, arg->dst_off + i, &=
new_file_table))
> > +                     goto out;
> > +     }
> > +
> > +     /* Copy original nodes from after the cloned range */
> > +     for (i =3D arg->dst_off + arg->nr; i < dst_nr; i++) {
> > +             struct io_rsrc_node *src_node =3D io_rsrc_node_lookup(&ct=
x->file_table.data, i);
> > +
> > +             if (!src_node)
> > +                     continue;
> > +             if (io_clone_file_node(ctx, src_node, i, &new_file_table)=
)
> > +                     goto out;
> > +     }
> > +
> > +     /* free the old file table if there is any data present */
> > +     if (dst_nr)
> > +             io_free_file_tables(ctx, &ctx->file_table);
> > +
> > +     WARN_ON_ONCE(ctx->file_table.data.nr);
> > +     ctx->file_table =3D new_file_table;
> > +     io_file_table_set_alloc_range(ctx, 0, ctx->file_table.data.nr);
> > +     return 0;
> > +
> > +out:
> > +     /* Error Path: Safely destroy whatever we partially built */
> > +     io_free_file_tables(ctx, &new_file_table);
> > +     return -ENOMEM;
> > +}
> > +
> > +int io_register_clone_files(struct io_ring_ctx *ctx, void __user *arg)
> > +{
> > +     struct io_uring_clone_files clone_arg;
> > +     struct io_ring_ctx *src_ctx;
> > +     bool registered_src;
> > +     struct file *file;
> > +     int ret;
> > +
> > +     if (copy_from_user(&clone_arg, arg, sizeof(clone_arg)))
> > +             return -EFAULT;
> > +     if (clone_arg.flags &
> > +         ~(IORING_REGISTER_SRC_REGISTERED | IORING_REGISTER_DST_REPLAC=
E))
> > +             return -EINVAL;
> > +
> > +     if (memchr_inv(clone_arg.pad, 0, sizeof(clone_arg.pad)))
> > +             return -EINVAL;
> > +
> > +     registered_src =3D !!(clone_arg.flags & IORING_REGISTER_SRC_REGIS=
TERED);
> > +     file =3D io_uring_ctx_get_file(clone_arg.src_fd, registered_src);
> > +     if (IS_ERR(file))
> > +             return PTR_ERR(file);
> > +
> > +     src_ctx =3D file->private_data;
> > +     /* Same ring clone is not allowed */
> > +     if (src_ctx =3D=3D ctx) {
> > +             ret =3D -EINVAL;
> > +             goto out;
> > +     }
> > +
> > +     mutex_unlock(&ctx->uring_lock);
> > +     lock_two_rings(ctx, src_ctx);
> > +
> > +     ret =3D io_clone_files(ctx, src_ctx, &clone_arg);
> > +
> > +     mutex_unlock(&src_ctx->uring_lock);
> > +
> > +out:
> > +     if (!registered_src)
> > +             fput(file);
> > +     return ret;
> > +}
> > +
> >  void io_vec_free(struct iou_vec *iv)
> >  {
> >       if (!iv->iovec)
> > diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> > index 44e3386f7c1c..32f5c47c46af 100644
> > --- a/io_uring/rsrc.h
> > +++ b/io_uring/rsrc.h
> > @@ -75,6 +75,7 @@ int io_prep_reg_iovec(struct io_kiocb *req, struct io=
u_vec *iv,
> >                       const struct iovec __user *uvec, size_t uvec_segs=
);
> >
> >  int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *ar=
g);
> > +int io_register_clone_files(struct io_ring_ctx *ctx, void __user *arg)=
;
> >  int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
> >  int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
> >                           unsigned int nr_args, u64 __user *tags);
> > --
> > 2.54.0
> >
>
> --
> Gabriel Krisman Bertazi

