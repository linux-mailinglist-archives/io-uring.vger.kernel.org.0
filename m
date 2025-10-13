Return-Path: <io-uring+bounces-9975-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8331BD31E5
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 14:59:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 489373C059A
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 12:59:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A63326AA94;
	Mon, 13 Oct 2025 12:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="B9UyH05f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37132269D06
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 12:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760360349; cv=none; b=hTsNoKphkGfHY4rHZubZVBJOJYnf/N2/Fu1/HJiWSE4ADSEYgwibPFJwCZK0BuLZro+NXwssmRZVOTVpzlkGrJV7eB7JzhH4MWnHFV6W5UmIi8wsxPygH7HLkAzDWoDRuzjcT2AtnAfwc8OnLc8ZU+4jKB6WxA9NENzzKpL8d/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760360349; c=relaxed/simple;
	bh=D6V3XPkrc+t2idQmAkRSOk7iDPs7p8w0xsyna0/EAms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Edl5M/ZveY0bNR6czCsLtXDTShk5U4QhWoRwmUoLEWC0NqG9d/s8qcBZp0gKv9ntcYbG+9MhZaq3x6Hgq+XXWcI42frlGY8mUnS0dytfOba6f1DQ64b95Nq7E0gcqn6p/J3tmxe1CuzJFvUmT2p8kcH8Q1teldnRJzZf7+k/DII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=B9UyH05f; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-330d1565844so2567384fac.1
        for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 05:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1760360345; x=1760965145; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Wmypoq4JusPQtINuz1Vuv55d8t7TPWrzMFDko8wjps=;
        b=B9UyH05foBQyFo3GAqVmomH33i32hZfsbauxq2TxSOZXmKGJfh08jxhtDuYctqirTi
         +znbj5YMDykLDsosYTPWEgW+T2R4d6Kpu26CrxcrpHuyKc5hlq7p7XABUmzfVxyE3HYo
         YjQqvWGD9A3KL6wQKE9NuFhi9ZCiLWGbmax+NtRk0Tm7h66+iNefKK/1pCYfUljJl+yQ
         nzCT1p1+4OVJLh+B1DSyY9lOk948JiO4EpJ5btrqqtrgc+zcetIN0DjA5BT0I8BaF99r
         atybbxItM8SPjnbn8hiNTQVdD39QA2GOdN/PCu/Bt0M9eOZ7f0xTDW16UaqhNBGmwEdC
         z/qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760360345; x=1760965145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Wmypoq4JusPQtINuz1Vuv55d8t7TPWrzMFDko8wjps=;
        b=wTwxgE4SpFjIGG5duSJMDbBh4eY3NGL+6RGdMzCv0ty3szx3TII55Lib37RD1YyuhA
         BWF7YlaqRemPs4w3B7Z8fncz1wvDYNovk3FJWXu2pJir5pfddIch3q4FCNNXFJ0ODy36
         ajFQwnFy+4iuf/D6m6mUt710bX9B0gsi2juR2nu2Pj8S+778y18CHr50XQQioHxTj7Pr
         7MD2VY6md6WXn4P8K5latz8L+C0meRjK9Dcj9xU16UnKXtHfuZ3PWQa/Z7ICv6aaND2t
         2hIPUvslTQyYr2v3YqQE8tLZkq1njD/UHA61rg6ibMJsWmg7sXMt8CMM3AByeaBlF2wv
         fehw==
X-Forwarded-Encrypted: i=1; AJvYcCUJHK7Pla8zbTXEBdIreiT+FMqNkHUh7ZxrSjsNGZTRfhWQELFnZlQ+/apgbYQntv/yYNPPaQ+irA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzXyDvJL/Jne4KUT/ToGdFz4uBNO15Ix08fSuSQGouXaw+lAcdV
	UD/fy8uLTPCCCQ9m9jljDQzIQZUJ6xk2wqtQFU6r/pNgjjY946I3MRAUJPpaiTYwgSje2pKh69O
	jR7RYKH6sdsbLfYTr2BPKMNPijnPWLGAUSzIAz/uv4w==
X-Gm-Gg: ASbGncsKSchlbKgfahAa0oTyPJXpRSlhkHMrnCq0lduguIKEe5F0L4Va6WD3mjvuJGS
	DR88xBVKiz/fJk0odpCHz1J550yKUREKse6hd52C6IejASuEPSjSFJqKSbedEJeBGH0W/Ux9fr4
	mbvuDGjAr569X2o3Bo6i08ASl6FU2rpiHmnfI7FWGbhCwREPgrULKGyqQvb3VjS+uHEHxmzLLVB
	Bklr65F4TcbuGi7NBlreD9cdnLR86buWE5IEc9VNaIJ7w==
X-Google-Smtp-Source: AGHT+IFcgfB7Wf1FZ1oK1mDKCUiDJpUURtVox8EHig27s8X9dUwwKIMVBBoJvN74OlkrVqbewuUEWyvLA9j7WIpDFWo=
X-Received: by 2002:a05:6870:5490:b0:395:11a1:2a5 with SMTP id
 586e51a60fabf-3c0f68f3ed7mr8576313fac.19.1760360344992; Mon, 13 Oct 2025
 05:59:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251011013312.20698-1-changfengnan@bytedance.com>
 <aOxxBS8075_gMXgy@infradead.org> <CALWNXx8pDOvDdNvw+v0rEyi33W8TL+OZW1YiFbF6Gns3PeWOLA@mail.gmail.com>
 <aOyb-NyCopUKridK@infradead.org>
In-Reply-To: <aOyb-NyCopUKridK@infradead.org>
From: Fengnan Chang <changfengnan@bytedance.com>
Date: Mon, 13 Oct 2025 20:58:54 +0800
X-Gm-Features: AS18NWDyQf8Y1FBCeSc2-tQU2iORMO74jotl63VadojDvfzhepmbn3llIRtG9jI
Message-ID: <CAPFOzZumoCERUj+VuegQNoAwFCoGxiaASD6R_4bE+p1TVbspUA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] block: enable per-cpu bio cache by default
To: Christoph Hellwig <hch@infradead.org>
Cc: fengnan chang <fengnanchang@gmail.com>, axboe@kernel.dk, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, jack@suse.cz, asml.silence@gmail.com, willy@infradead.org, 
	djwong@kernel.org, ritesh.list@gmail.com, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig <hch@infradead.org> =E4=BA=8E2025=E5=B9=B410=E6=9C=8813=
=E6=97=A5=E5=91=A8=E4=B8=80 14:28=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Oct 13, 2025 at 01:42:47PM +0800, fengnan chang wrote:
> > > Just set the req flag in the branch instead of unconditionally settin=
g
> > > it and then clearing it.
> >
> > clearing this flag is necessary, because bio_alloc_clone will call this=
 in
> > boot stage, maybe the bs->cache of the new bio is not initialized yet.
>
> Given that we're using the flag by default and setting it here,
> bio_alloc_clone should not inherit it.  In fact we should probably
> figure out a way to remove it entirely, but if that is not possible
> it should only be set when the cache was actually used.

For now bio_alloc_clone will inherit all flag of source bio, IMO if only no=
t
inherit REQ_ALLOC_CACHE, it's a little strange.
The REQ_ALLOC_CACHE flag can not remove entirely.  maybe we can
modify like this:

if (bs->cache && nr_vecs <=3D BIO_INLINE_VECS) {
    opf |=3D REQ_ALLOC_CACHE;
    bio =3D bio_alloc_percpu_cache(bdev, nr_vecs, opf,
    gfp_mask, bs);
    if (bio)
        return bio;
    /*
     * No cached bio available, bio returned below marked with
     * REQ_ALLOC_CACHE to participate in per-cpu alloc cache.
    */
} else
        opf &=3D ~REQ_ALLOC_CACHE;

>
> > > > +     /*
> > > > +      * Even REQ_ALLOC_CACHE is enabled by default, we still need =
this to
> > > > +      * mark bio is allocated by bio_alloc_bioset.
> > > > +      */
> > > >       if (rq->cmd_flags & REQ_ALLOC_CACHE && (nr_vecs <=3D BIO_INLI=
NE_VECS)) {
> > >
> > > I can't really parse the comment, can you explain what you mean?
> >
> > This is to tell others that REQ_ALLOC_CACHE can't be deleted here, and
> > that this flag
> > serves other purposes here.
>
> So what can't it be deleted?

blk_rq_map_bio_alloc use REQ_ALLOC_CACHE to tell whether to use
bio_alloc_bioset or bio_kmalloc, I considered removing the flag in
blk_rq_map_bio_alloc, but then there would have to be the introduction
of a new flag like  REQ_xx. So I keep this and comment.

>

