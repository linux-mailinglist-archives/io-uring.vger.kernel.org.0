Return-Path: <io-uring+bounces-5486-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49E329F1470
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 18:55:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 008CF280DAE
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 17:55:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E38401E8836;
	Fri, 13 Dec 2024 17:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k12EJZfa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715FB1E5713;
	Fri, 13 Dec 2024 17:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734112535; cv=none; b=aoLiaCGqLShSvG7tuvNsXJmeGLDe7gKCvpD+cF+2VzDM0c4d9iolLmt2v0i0/Y80dZNL+E9lMoKlfq19TNBDPViRRa1NuoHlAjGkljpGf7oOIWXGzlV4ikoxcV29y4/i7r6cMM0Rg79y7uxF2QvT6PPJSX6j/SOYxs4Cgt/TIGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734112535; c=relaxed/simple;
	bh=X0A9zXrkB8ndBKO3B1/8vCoeKklNyOkao1ANMos884Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tWfIuhVht02S/frC6+t1QSKeRQRKMyxsmrSgyjh1wNFXVc/NdOmThN2pxBE/tA2ztNXR99ZQ7Z6oBQ9SkRmszyHKuFkHTK57jTZudJ2r/KEhZYmAQrRdDcxtIlLK/bD4CHCaecCyn1rESuRDZdNDIligSC5kXGRUX0xBq8X+YL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k12EJZfa; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e3c8f39cab1so1666737276.0;
        Fri, 13 Dec 2024 09:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734112533; x=1734717333; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X0A9zXrkB8ndBKO3B1/8vCoeKklNyOkao1ANMos884Y=;
        b=k12EJZfaKMHz3JRgix/E93grEoxEdpj/wzti4FvwPOUU250Rcs7A6omxA6QXf5whGW
         xT0oQDlpZ68pwp7Zkj5kb3KRvSqZWHLEYXgpnJng7Or8fpLDsUcwxBJCSM8STkFYZNJZ
         81Ad726BrR+q/AJ4qzz7OZ/i1cTWwExeOBl7cWDtuidMTgAz+Yt+GqClyuVn6JdXMCUT
         UVMWlA5hjk8f85cBuqI4dNK5QKHtSwna8JUB6ytKb0M5uK0T4smAK2oIidBisMJZPzwf
         QlY7TEDM1aiJg/mEfTCcQOFH6oJMhhc4VJzPsjiYwle15cP4Br6r62Y6gXBfdLrckIXW
         GAhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734112533; x=1734717333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X0A9zXrkB8ndBKO3B1/8vCoeKklNyOkao1ANMos884Y=;
        b=XudJMX3Z+ooIZIjDLQ6tbSuhwjC//UkuRUVMDl7ElmXWWXxRwQcJvM1IJ/IQwqPp+z
         gRxw2RWDZcsFmCPS3oqMlfCOfMdomUDSuWne79WByYmDCG3f7i5vRmaDWekDoU+yoyfM
         wKjS/f9KbWpvgh6iZjc1Jd+Vsl9SPS6OTBXetSYlhhyHtnhxsFi0CRQgrHlye4vS67lw
         HDJM31VjMn/0ovXQMXRF87L774SqvfD97v4npUYrx4uq7Ds1bu/37G156IZdj+x+huCR
         7jPE7NuaymW07n0fRZsnyc70FcPJJNQkg/JVuHmw7lg5dpjcvHmTBHBIyY5fou01cXF1
         7Jng==
X-Forwarded-Encrypted: i=1; AJvYcCVg637KQQfVOn6EfFfhPtKEH4L8ta0PrxuRcT0g2n4nfZnA3WReEzJuto32JEMlO+4ICcNuqujF+8JDy6Rz@vger.kernel.org, AJvYcCVmPlLkCW1xvwURh5qVEP/Y0/QWSqQ6cuskOP027OyBrBkJSk9qBSEGIItuns6LOH60BJQHRzJUpQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxxPNEWjPAx9lzJqJ4lBZvMGVc55p6tAX8Z+17oRSDvr4kbb6Nd
	rmDOrjbmlP/1bLUnTbO769IVL/Nh9MW9jVOHlBvvI9GnhC1RRSLrOZcbWWg6G26T+J5OdMlCpp9
	7LwWZ57lMHqym/sqrYvnlDIVYukw=
X-Gm-Gg: ASbGnctUFaOB5Pi3e7AeJ+RHkuMYOo72OzjIJKBqwc06FmsSKB0FWVgPgeDzUcOzZ1a
	LW8GgRr8fZsRLKi6VFz50TlRyRnF+rhU8ZCyO1sXjSAUT6cHp8qbTkody1HgWQ04r9YjI8M0a
X-Google-Smtp-Source: AGHT+IFAiJAcWRk2FhnIo4PD0nMMAf5Yg4hOP9gdcitpeidVl8VtxcT+1wk/TuZY2QcFBZPWFutzbWtDhXAo5dKS6eQ=
X-Received: by 2002:a05:6902:2701:b0:e2b:b9bf:f248 with SMTP id
 3f1490d57ef6-e438fe52dcemr3357472276.24.1734112533355; Fri, 13 Dec 2024
 09:55:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADZouDQpNvEd7ntUgOAQpU18PErENx2NsMMm05SXXODik6Vmtw@mail.gmail.com>
 <ca3b85d6-ddbf-48b9-bdf5-7962ef3b46ed@kernel.dk> <CADZouDTH=t7WTFgrVyL_vYsJaWF4stjAj5W8NF2qAK0bW2HVHA@mail.gmail.com>
 <2310bb0c-8a8d-4520-a1ab-40a0489312e5@kernel.dk>
In-Reply-To: <2310bb0c-8a8d-4520-a1ab-40a0489312e5@kernel.dk>
From: chase xd <sl1589472800@gmail.com>
Date: Fri, 13 Dec 2024 18:55:22 +0100
Message-ID: <CADZouDS7MWbFdh69DXeSdzUSt4AhEqN-+gy_PTdUV2pAAYyEjA@mail.gmail.com>
Subject: Re: WARNING in get_pat_info
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This should be the right fix on their side? I was just wondering why
the newest lts5.15 not applied this backport.
https://lore.kernel.org/all/262aa19c-59fe-420a-aeae-0b1866a3e36b@redhat.com=
/T/#u

On Fri, Dec 13, 2024 at 6:49=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/13/24 10:47 AM, chase xd wrote:
> > The bug was found in October and the newest update on lts5.15 was on
> > 2024-11-17 but still it has not been backported yet umm...
>
> What do you want to backport?
>
> --
> Jens Axboe
>

