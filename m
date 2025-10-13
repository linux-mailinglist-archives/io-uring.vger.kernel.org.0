Return-Path: <io-uring+bounces-9970-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 68900BD17B0
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 07:43:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 08D964E23F6
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 05:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 622D82DC35A;
	Mon, 13 Oct 2025 05:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IWCG7q2p"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F4D232785
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 05:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760334181; cv=none; b=E7F4+R2RZtlMpk9aDH/47WgYNpkBX3yWpcEvCq6P68TUx1seeFpb98qcEYlP9kdNoDxD2gZOtQ+asD81SwpacoQ1lffqzQZP6nq0KW2Qpq3NGm3LBuW8X1u3X9eEW+9hIFO+gVFiKBPKMuLBraWCDhA7JT5OZTU+c2jEi8lkofs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760334181; c=relaxed/simple;
	bh=LkiHDxUpll20Mzzyjyp6GAradkAWV81/VhYmzsLwOLs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VZevzshsMu8vLuWNNNmXwIYtUhjQkCXA52GLByIQnYDLHyDABQ3Y8X9ShjxwykkwWfyhl6bdF+sFsO/B90yfAUIby8WIRgTAOaLPIEWvEKalF+FKoiT8QMwHl3zcCysPuu1eUPxmzGSBzRmXo5gg1rP/4JKkLSie218S+0ZqeiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IWCG7q2p; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-54a8f6a2d80so1209404e0c.3
        for <io-uring@vger.kernel.org>; Sun, 12 Oct 2025 22:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760334179; x=1760938979; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rFw8GX7he7wIYguaN9JzvQNXMrk3Z90u5aRFTT7c2yU=;
        b=IWCG7q2p7ncp3CeE2O5Slzpe2mNztlvZhmi9ntpDYMpxLGBvuzLRHSH+ncBuJYaKD+
         jzc6ucI6ohY6D/Iica3jWOpZd+lh0UGTNdAzv30lo68Fos9U3jAC+xcC2jHVIp/qaQH4
         EKmTWoWaxx1XGMIAKWpSuyQBq+FQggTp+T2YRLmhhPAC1WDFsCEaklEKKoc3gnGZXfyM
         VxHlzrORf8boipLV1lThncDGuIYq55L9vVWVlvLFid8Y81xCaMzjT7xFu169zTPqSlYy
         ot8bM/NL0/yxTgbiqrefFX17lVANYxojBoKcYczeWjOU2o26WB8fcrBiEP6ApN2kkmmZ
         L4Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760334179; x=1760938979;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rFw8GX7he7wIYguaN9JzvQNXMrk3Z90u5aRFTT7c2yU=;
        b=FvH7TFATBPm2w3HEl5ytcVQXxhV+DTxFpJqs2EwNAIvu/y0zIIkuKMD6PUtlXvNlZr
         pKP3qxdh5qhKIP7f1nJKdbxNU9EFxQZ5cqjrr7it8wuVVA4e+y6NQU7P/MZuH+7n6FxY
         +dWSvby/J3HrXe1uC4F664I1jkQwAciw74P5Axq+/SvIG2+Hbv2f4WThdTY0K8QH9pC5
         xXJqtBvar6DgsN1JJI/Kv625WxvyjGEmufoB/Dv54C4FwG+cWaEmoOhyMrvTQ96ke+Lb
         qOw7JfHVSsoUItnEIx/2ksZANtyYH8mpRmDNQyQaBLuYbvv6Lwhvdcr6pgCrl89usaDf
         2ocw==
X-Forwarded-Encrypted: i=1; AJvYcCXUW3e1pxrbLHwKP1PMoeVYO1CLREjc0A/8R2rdBWqpGb/wbTkxKbsbXkPV7SLQKHflkrCvYZ8qGA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyxzvBh0CD42wwM/WGyC2Jf/8WooeCZPVX9Du7mgPadsdiERfGU
	5MHK0tFRYs5jtW6AG1pyDXizndPT5iHiVDwYRD8RB/Sfh4Xj0qtMov9HW0EnEn2dmffAUvwO1Ee
	Nkc0ZM/RMeZE6MiVpOzpx7C1ZoKInmPI=
X-Gm-Gg: ASbGncvRxpg81QmLX+n3Pl7ccJ3avAb2aR6UFrq7L0bG6saPscwwDGvrS/BlP1BSyGZ
	Qz9pm95sAk57mvI5OB7CkHje+rMXFkyvfdqbYXtqkePjh5ZFh33gHuZkgdydnT8fVHRYMbnwkMG
	Cimmzdxz1McZuGl7vnwBgdI5ySZe4D7nI2dyPA/HYiOOpcIYwlHdccekacqJ6tfxtqlIcDcHs/E
	BPKI0fx6KiK+56VXzErrq9JG8BS4JZOhZMEHw==
X-Google-Smtp-Source: AGHT+IE2pzpIXFUlQnxpSAUJmDsWbuHYPNEdEfC1GOsG6qkn6Ggw30mR6TSMqPTmSaIF0L9e6DD5b5ldfGpQurArkk4=
X-Received: by 2002:a05:6122:91b:b0:545:ef3e:2f94 with SMTP id
 71dfb90a1353d-554b8aa8d4fmr6241006e0c.1.1760334178612; Sun, 12 Oct 2025
 22:42:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251011013312.20698-1-changfengnan@bytedance.com> <aOxxBS8075_gMXgy@infradead.org>
In-Reply-To: <aOxxBS8075_gMXgy@infradead.org>
From: fengnan chang <fengnanchang@gmail.com>
Date: Mon, 13 Oct 2025 13:42:47 +0800
X-Gm-Features: AS18NWBq65kKS67xgSwyGWf422mFA-TjXvUExYQYDBZ5JznD-_4en1JwPHXcFWo
Message-ID: <CALWNXx8pDOvDdNvw+v0rEyi33W8TL+OZW1YiFbF6Gns3PeWOLA@mail.gmail.com>
Subject: Re: [PATCH] block: enable per-cpu bio cache by default
To: Christoph Hellwig <hch@infradead.org>
Cc: Fengnan Chang <changfengnan@bytedance.com>, axboe@kernel.dk, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, jack@suse.cz, asml.silence@gmail.com, willy@infradead.org, 
	djwong@kernel.org, ritesh.list@gmail.com, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2025 at 11:25=E2=80=AFAM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> On Sat, Oct 11, 2025 at 09:33:12AM +0800, Fengnan Chang wrote:
> > +     opf |=3D REQ_ALLOC_CACHE;
> > +     if (bs->cache && nr_vecs <=3D BIO_INLINE_VECS) {
> > +             bio =3D bio_alloc_percpu_cache(bdev, nr_vecs, opf,
> > +                                          gfp_mask, bs);
> > +             if (bio)
> > +                     return bio;
> > +             /*
> > +              * No cached bio available, bio returned below marked wit=
h
> > +              * REQ_ALLOC_CACHE to participate in per-cpu alloc cache.
> > +              */
> > +     } else
>
> > +             opf &=3D ~REQ_ALLOC_CACHE;
>
> Just set the req flag in the branch instead of unconditionally setting
> it and then clearing it.

clearing this flag is necessary, because bio_alloc_clone will call this in
boot stage, maybe the bs->cache of the new bio is not initialized yet.

>
> > +     /*
> > +      * Even REQ_ALLOC_CACHE is enabled by default, we still need this=
 to
> > +      * mark bio is allocated by bio_alloc_bioset.
> > +      */
> >       if (rq->cmd_flags & REQ_ALLOC_CACHE && (nr_vecs <=3D BIO_INLINE_V=
ECS)) {
>
> I can't really parse the comment, can you explain what you mean?

This is to tell others that REQ_ALLOC_CACHE can't be deleted here, and
that this flag
serves other purposes here.

>
>

