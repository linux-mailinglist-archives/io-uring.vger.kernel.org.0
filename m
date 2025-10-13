Return-Path: <io-uring+bounces-9974-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F1AF9BD20C9
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 10:26:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 43CF34EDCFD
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 08:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06D682F3C08;
	Mon, 13 Oct 2025 08:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="evINQi4I"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F9A2F2902
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 08:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760343987; cv=none; b=AFc6d72/S09Z6vM8C7Bx+JIErrEhsND8lqjGP09uS7o65/8/ByS8dpbP78jWlyBWVDgoZ0z8YADOBnBg4G6sCyTTwWzkK1g7/JpNPBxY2L8kqrr+HfTZwpAWky3Pr7XZNb+yEB3fLvs+O6U4Qu9ZEgwzz7BJ1ktT1C3H1dEg6Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760343987; c=relaxed/simple;
	bh=aeTrMwmyr4idjATE535SD4+VwHKBvnF3DmVfBmeSGIc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a2dx48oa1CkLdMqQrYZhh0vQ60sMLfzbKTVXrALEplSle899lXx22MChw2spEzq7ZgEufFXNEpJEmcR2eai7wi+V7Sot0fUNjhSAh8Qj3P/laYep6AJ2msNlc2qFdQPHVtjPei+BdI99IGOKSC//Cdn4WZSc7pvbtN8hecpxS1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=evINQi4I; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760343983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f9h2lc52spfsqI+nujAwhGun9J88DEF1peaurIn3jpI=;
	b=evINQi4IcyDz3fBL4CzS71mdZYAh+NCUSxAQqsqS2U54pk0Vh+LU+GKNVLNSfWA1ylDuv/
	bvU9xoSNZpiqkSQ/YgE5snas2lXwnSLSzPL3On1AQj/5uK49FuG1XDnNeccmqC+NObtHzh
	LffbIUZf+sThPVma1li24p9LC9MTTzQ=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-107-9GLkT6dsMNmqmrQZ7KSpYQ-1; Mon, 13 Oct 2025 04:26:22 -0400
X-MC-Unique: 9GLkT6dsMNmqmrQZ7KSpYQ-1
X-Mimecast-MFC-AGG-ID: 9GLkT6dsMNmqmrQZ7KSpYQ_1760343982
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-54a9f198468so2280059e0c.2
        for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 01:26:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760343982; x=1760948782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f9h2lc52spfsqI+nujAwhGun9J88DEF1peaurIn3jpI=;
        b=vEOwn7MymyrhsLwpluTjq1YQMWQgfuu9HHXTqiPaBL3zII2D6yd9PREhjsDXA5wvcU
         saFZUj7n1+FsqkyAyEDFDhQ739Ruz1fhMzNKelx54M5iq6skymuAISsjG8DaPi61JqDt
         Wg9JADgTOq+sWqfgb2qEXib1hzNVp1Drwkt6H//RrsU2n2t6j0ptP1VS5d0HN0o1Vwue
         cvYWM4O46cOcyIkalu2xs+BQknbpvlDL2OwrF6G8GPEu7/iDsxAO+wN4sDTBLcoWHSpM
         5iODEtWeKCQ0LdMIjzlQWBhRBOWERaAO6yNpbJeOhCXRH3kKFRIWG2yN2dPQ52UR0Hzj
         9KTA==
X-Forwarded-Encrypted: i=1; AJvYcCWtOOaI+R44kmIKaft9otVZdhrfn9cpwUXpOrsLrjfV2MRmu22V4bdy7dwUH2OIzmwYRLxox2mZGg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx9FdbKvKawlnci3LlUz6X1P34yJRG3ElReY6iiqmlFUQGpPQY
	KwWZcPkDw0Tr28LWwb/pfhyR4GcPijlipAzPJkHKxMHF/dBwSCvFWLajvehPSdWIdRvtI+Ca1Gm
	nR4jer5dhu7CAQjMa/FgGqgs+a7nHj6VtHEk+HIMnTWBhZ0sVVU2xv+rfp2PLWyqiHttwgD+Sam
	23GrJVqLVipqDtju91eByNJDv9KyF01ria99M=
X-Gm-Gg: ASbGncuxkOgCIfgM9Rc1s0wu+Lehoj6251hsGZbYtRPrv5pMa4zV7Eb/MtvxGiM8V3z
	iy3GH7g7ksH1Qy//ntiyS/aSK0QWO/ErQwRE98g4SdiMSwv1FLlPO1Nobj7SGE/yuei+ImcVBTq
	bi22n4G6fBcQaZsj4QwDnK9Q==
X-Received: by 2002:a05:6102:8399:10b0:5d6:bbe:fe00 with SMTP id ada2fe7eead31-5d60bbf01ccmr1298635137.10.1760343981912;
        Mon, 13 Oct 2025 01:26:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqxQ3r8mKG19gkUS7w6zdeOC2dbsppCKLD7LIyf0aaxI4o4mEw27yhWt4MDd3wyBHEFiKHvB7PUDNAXpEj720=
X-Received: by 2002:a05:6102:8399:10b0:5d6:bbe:fe00 with SMTP id
 ada2fe7eead31-5d60bbf01ccmr1298632137.10.1760343981594; Mon, 13 Oct 2025
 01:26:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250928132927.3672537-1-ming.lei@redhat.com> <20250928132927.3672537-7-ming.lei@redhat.com>
 <aN92BCY1GQZr9YB-@infradead.org> <aOPPpEPnClM-4CSy@fedora>
 <aOS0LdM6nMVcLPv_@infradead.org> <aOUESdhW-joMHvyW@fedora>
 <aOX88d7GrbhBkC51@infradead.org> <aOcPG2wHcc7Gfmt9@fedora> <aOybkCmOCsOJ4KqQ@infradead.org>
In-Reply-To: <aOybkCmOCsOJ4KqQ@infradead.org>
From: Ming Lei <ming.lei@redhat.com>
Date: Mon, 13 Oct 2025 16:26:08 +0800
X-Gm-Features: AS18NWCWxgbBN23g61iYzMfQYeFdjbQ0IHgI_c-2448u3QBnJ6IKRiHfJ5F8vfs
Message-ID: <CAFj5m9+6aXjWV6K4Y6ZU=X9NogD5Z4ia1=YDgrRRxxfg6yEv5w@mail.gmail.com>
Subject: Re: [PATCH V4 6/6] loop: add hint for handling aio via IOCB_NOWAIT
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, 
	Mikulas Patocka <mpatocka@redhat.com>, Zhaoyang Huang <zhaoyang.huang@unisoc.com>, 
	Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2025 at 2:28=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Thu, Oct 09, 2025 at 09:25:47AM +0800, Ming Lei wrote:
> > Firstly this FS flag isn't available, if it is added, we may take it in=
to
> > account, and it is just one check, which shouldn't be blocker for this
> > loop perf improvement.
> >
> > Secondly it isn't enough to replace nowait decision from user side, one
> > case is overwrite, which is a nice usecase for nowait.
>
> Yes.  But right now you are hardcoding heuristics which is overall a
> very minor user of RWF_NOWAIT instead of sorting this out properly.

Yes, that is why I call the hint as loop specific, it isn't perfect, just f=
or
avoiding potential regression by taking nowait.

Given the improvement is big, and the perf issue has been
reported several times, I'd suggest taking it this way first, and
document it can be improved in future.

Thanks,


