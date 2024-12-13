Return-Path: <io-uring+bounces-5484-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E41969F1449
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 18:48:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EAD8188D3E6
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 17:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1032B17B50E;
	Fri, 13 Dec 2024 17:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RI4ydRrh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503F018452C;
	Fri, 13 Dec 2024 17:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734112087; cv=none; b=saO0SifRYt4Ji/SZyq4YZ8se1/rQ1v7YAgOcQIcPMdGWSMzItB2HDsmPtNHIFrVOmlf34CI0zcoswH7qqvEhU6r4DVhvFa5WNjYEpgPHnN1lMeKSmitoefmFki5oAfX3WMo+d9Ho/3/zxXPdm3Gzs1RDXr4FOpuniulMh9I56WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734112087; c=relaxed/simple;
	bh=Z2GSe2PKQp2mT2rtZNiFE5J+/aEFFtbfC1olyaWRgmk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mvWa1aerpr0jsvtfWO01fIh25bXDNBS1KgWhucS10zh06vb0G/OhX4tzzLkr3vhMUs4oZqhGDyjCR9In0o9OEqmfYCGdHCf8FTn7iEejc0tpNFybA6RY3p9FAdViJlYXgPWvYsn9HnfCktVSd7w2Zdn0PQvFWGkVPa0dyHhMu18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RI4ydRrh; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-6efc58fae20so18534507b3.0;
        Fri, 13 Dec 2024 09:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734112084; x=1734716884; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z2GSe2PKQp2mT2rtZNiFE5J+/aEFFtbfC1olyaWRgmk=;
        b=RI4ydRrh8T7ErrCt4OWguAwkWv9szlsbHoVMvmbqaLuc8fj8vWNB4mXppcmSjmXF0Y
         8tNWoAOKaAPV47I0R5tfxjMa4LhiWNT6F2MWnCCHYCeIwZlfEbGGumhyGLXnA01WHqs7
         n+1wxm0QSpjTVFduTYADJDLlz74Vi9rcpAvtz7qDcdPmEGymWaM8UOOySGaPCup6mm/f
         w9YahFc2vCKYMb/NR+nDmeXLDPi0xIyvmsHgwj5JA7q+7azDpTmpTqIXiq8jsFhPOpZb
         6Qrg9LhSCq2W6Pc4iwO07d7i+ICeFIefkObGydVicp/exa6DV4I4x2tK7Hi4mXIBH3WG
         lPbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734112084; x=1734716884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z2GSe2PKQp2mT2rtZNiFE5J+/aEFFtbfC1olyaWRgmk=;
        b=KjEl+AtV8vLC9JIHnM5lEDPdthGNsYYO3UfjuEKw6Az3s/e8bNLWtguG+U8OSJkAjz
         M6JtjKKOg00Ppci0ZnSfhojHd1iYzD70AV7HmQaQCLRbV4zc8iee25r0RMRRu7R1k2rr
         Z8jFisqdwSu+Ri/8Dtcl1mpjXJrxJo5pvRR7FXGejjkcpXpRJsd+ru+s3FkssYjx6qgp
         o90Akk9GZv4/LVhNCL0B9ApPpc2lHVFxUzAadq/BscK5up18XrCJPY+aLv6S3gJwg7iV
         ZyjXE1p1mBW45PZ6CryHpouaZX14Ejaqok1L4N2IHhAsyi0kgUvxNPuRCZQMe6QbapY9
         SnwA==
X-Forwarded-Encrypted: i=1; AJvYcCVRibeTqyZdiHbCyDsR56WwlHqkY/y5RFf5VjrxqrKodjJGGqNvPqAzAF/cLWOYt0sRJabzGfkpqKJr0Sha@vger.kernel.org, AJvYcCWEu4A6aqLFG/6IXGhtKKtIcqMV6ywM4BgHBkDPiRDWmQoddfCc9zWIOsGx+gpNwrK7Ey4mTdEarA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLe7kGyJ/lGUBUAX3EORGlO+H0Qetq79jyg0Tz5Tu0HWQSUKdf
	mmLcMimYKRVyXPm1eT6GYRCFQMibpzO9gvtyPlj/Wqrw265cnFuV6+5D3PLKMUmKNcnsd62HSvd
	oaKxs+76ichlwSoUHobDAkrMpOgk=
X-Gm-Gg: ASbGncsNI47ywmLqTwq8U28MvUg8n8QY0Gx53Edvxt9R7tZ5EmdHF7lUcihSuHljfes
	yNBRcYK0zRh4gnu4oxEXfqWn7nIcWdj/j4zCGLIhenr03THzEVDDR2BQDMHpDjcGKaCIh44/a
X-Google-Smtp-Source: AGHT+IEHbE2vFmYYsljEogGAp+M5bV6igr7WvLKPnlF5AQ4+24uXzXXOtEJ5gRGexQe9v+Uy1+HYZ+JA7eXDQNFVpUk=
X-Received: by 2002:a05:6902:260b:b0:e2e:46e5:c2ca with SMTP id
 3f1490d57ef6-e434a2573a0mr3132675276.14.1734112084289; Fri, 13 Dec 2024
 09:48:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADZouDQpNvEd7ntUgOAQpU18PErENx2NsMMm05SXXODik6Vmtw@mail.gmail.com>
 <ca3b85d6-ddbf-48b9-bdf5-7962ef3b46ed@kernel.dk>
In-Reply-To: <ca3b85d6-ddbf-48b9-bdf5-7962ef3b46ed@kernel.dk>
From: chase xd <sl1589472800@gmail.com>
Date: Fri, 13 Dec 2024 18:47:53 +0100
Message-ID: <CADZouDTH=t7WTFgrVyL_vYsJaWF4stjAj5W8NF2qAK0bW2HVHA@mail.gmail.com>
Subject: Re: WARNING in get_pat_info
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The bug was found in October and the newest update on lts5.15 was on
2024-11-17 but still it has not been backported yet umm...

On Fri, Dec 13, 2024 at 6:41=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/13/24 10:35 AM, chase xd wrote:
> > Hi, when I tested io-uring on lts 5.15 I found this bug, do you think
> > this is a bug from io-uring or mm subsystem?
>
> See this discussion:
>
> https://lore.kernel.org/io-uring/f02a96a2-9f3a-4bed-90a5-b3309eb91d94@int=
el.com/
>
> --
> Jens Axboe
>

