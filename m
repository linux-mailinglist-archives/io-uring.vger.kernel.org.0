Return-Path: <io-uring+bounces-10855-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CD40C945B9
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:33:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B2B924E2A87
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6718C30FF3B;
	Sat, 29 Nov 2025 17:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cBIQh5S2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F54E20F067
	for <io-uring@vger.kernel.org>; Sat, 29 Nov 2025 17:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764437618; cv=none; b=Xmc/NGMGNVN8lJ9NUN/r4x8aPooW2KgWlVPAWf5ZoPgQ9W/zKUBBPNx8dUtsUgmIzBoOGDShvk9EcXLtwrf2ce3oLJf2h8nlvFlryI++B0sWMX0+EN1LEwpexF34sxblefxU3zBQaDmoPqvVWr1OGIRXUXfrFtICZ/IiyjtYB2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764437618; c=relaxed/simple;
	bh=+lgN8J0IowAdNicv/d1NP7IzfMlJS8XCtDt0GRjHDXQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DQNCPbIu7AX/Oo8/NVOHfQJiOXMhYVPShu13+7FeICud0Cxjpp7nKTdRjX6FWJ/2qbqmGDeQP2qX3xKfke6beW9uH/sBDFcuyajy20+Svve2GU1iUlMRbgm1EvEP8BWYcRGrYDthvc9c4yOPX53dnNZMqnwRO6EUeHlfF2ef2o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cBIQh5S2; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b728a43e410so489527766b.1
        for <io-uring@vger.kernel.org>; Sat, 29 Nov 2025 09:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764437615; x=1765042415; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xqBHGbcsAsVVRiASRLwDbcSq7PIrgcMaytoi2qLw8ec=;
        b=cBIQh5S22M8W7nQha18KSIsIWPzTRaCbRI5sSO/+y2bwDuwhWZtyqruSKCsYmjmRLJ
         xfQKDzZZrOrZ6UsfwXxs29D5TS7Ob49q50+gUcBMVCuxirPP7vtZhSbOPjr8PdPchbAz
         zQaSH2gLKwAlYhO3VjKuZMCRydvPQlSKEOx+L+bQd9+8ZlYe02yuSvbBxcorQKHuh3ly
         HNHocYoXhoFSxsSSu8DsyggFt3SOTDCSkW5xsvzfiyu0GxIYIcBTKbu5o8gaVOvYUGFB
         cEfv7vGw2Yh2imYaTWPqLTBQiaOHXhPo0k7be8eRTExYYiMQgX3GcQUG//3gsJ8hGKtC
         3rTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764437615; x=1765042415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xqBHGbcsAsVVRiASRLwDbcSq7PIrgcMaytoi2qLw8ec=;
        b=W10TU/ImbwoWBJhyK6cw5zUtTSdnV9uttq8ntcwDyQdznrFhnZqgIZ6/R/5vWxRQyf
         wFJ8WqpB1frxgGOvFOJ3n6g/vJXbEmzKJETgIks9d8tXsUIMQVwUS6lAYexmHnrNhINc
         4/7NPiT9BY8JZaCzinZiDwBYIeb7FPPP/P9bci0NzqM3TAi7GOu7TDUr2cXk9xl08D25
         4VR9O+1ka+mITzMuIl+Y85zvFotHyFfKGTNJVUx3dyf8ixiyjOE4PTTkkabV5wMiHDSo
         T2c+ZBr4P4WuMcHxrrZSpN+KbcDahB26WtlJrvr2E72nNNArHLz5KfBOXI8o2/vkukXE
         OnWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUchnXs4bMU2cTAvyQm9fgpV3J4EFBtH6KmEqD6CHovnfHS4Ae4prozft6vtFCV4Y9djnzEQ0w2vw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+noxYLDAxIPfzkD9pbidE9c6u7b823zOfnhXXw1ooIz+Togoh
	q+1qIuk1Az/VeKDcaefT11vaxpcPGxSLaJR/stN7sj7dxJkO9RJ9LJnRdkK4yhSxiXtK2u1Zzw/
	fSdpdFVE0/UrJo6fYDNt2pewAGIVrH6b3eA==
X-Gm-Gg: ASbGncvu4oNZY5TQGUCMEV0zdy2dn5BUyoCFEueVUpK8f0/iCcw5palu2+T99a2eMGM
	5VTUhmXWrgSvpbiD5f1xn5GoIfM8MZO93rlGMIVY9doZDpmJGomp6D+njoqV+WLrvA4de/AUgXO
	WSlvtuSZZwA8Odcu60CULdvBJ+LJEHFnEyMEQRswzDsr5oZqu4tBxuzCPSSsx5e/3s6992rjdc/
	BJdVc10jgBXriGx6qZxSc1iAPS2HvpRGmenVXVujJZAt/rJJOPwCKBRQVAIhI5qaO9xjQ3Cd1CS
	hyPlSfTLXCulEXbKCXPV5jjSbw==
X-Google-Smtp-Source: AGHT+IGCyw0hgpfwbdp3a3E31TdyZ9pXIJL/jdDuy8vbFKa1VPNcT6NEqn4DspaZQIjyW4rDdWr2eMhKOKbCgdYDBbM=
X-Received: by 2002:a17:906:c14b:b0:b73:398c:c595 with SMTP id
 a640c23a62f3a-b767156556amr3928338466b.19.1764437614344; Sat, 29 Nov 2025
 09:33:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251129170142.150639-1-viro@zeniv.linux.org.uk> <20251129170142.150639-16-viro@zeniv.linux.org.uk>
In-Reply-To: <20251129170142.150639-16-viro@zeniv.linux.org.uk>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sat, 29 Nov 2025 18:33:22 +0100
X-Gm-Features: AWmQ_blvi087-G2CtHlEiHh6F6ijMslc1kpUveo4D1zCzMmn1FqYhm25LkTHXDE
Message-ID: <CAGudoHFjycOW1ROqsm1_8j47AGawjXC3kVctvWURFvSDvhq2jg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 15/18] struct filename: saner handling of long names
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 29, 2025 at 6:01=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>  void __init filename_init(void)
>  {
> -       names_cachep =3D kmem_cache_create_usercopy("names_cache", PATH_M=
AX, 0,
> -                       SLAB_HWCACHE_ALIGN|SLAB_PANIC, 0, PATH_MAX, NULL)=
;
> +       names_cachep =3D kmem_cache_create_usercopy("names_cache", sizeof=
(struct filename), 0,
> +                       SLAB_HWCACHE_ALIGN|SLAB_PANIC, offsetof(struct fi=
lename, iname),
> +                                               EMBEDDED_NAME_MAX, NULL);
>  }
>
[snip]
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 59c5c67985ab..0b01adcfa425 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2833,11 +2833,13 @@ extern struct kobject *fs_kobj;
>
>  /* fs/open.c */
>  struct audit_names;
> +
> +#define EMBEDDED_NAME_MAX      128
>  struct filename {
>         const char              *name;  /* pointer to actual string */
>         atomic_t                refcnt;
>         struct audit_names      *aname;
> -       const char              iname[];
> +       const char              iname[EMBEDDED_NAME_MAX];
>  };
>  static_assert(offsetof(struct filename, iname) % sizeof(long) =3D=3D 0);
>

This makes sizeof struct filename 152 bytes. At the same time because
of the SLAB_HWCACHE_ALIGN flag, the obj is going to take 192 bytes.

I don't know what would be the nice way to handle this in Linux, but
as is this is just failing to take advantage of memory which is going
to get allocated anyway.

Perhaps the macro could be bumped to 168 and the size checked with a
static assert on 64 bit platforms? Or some magic based on reported
cache line size.

