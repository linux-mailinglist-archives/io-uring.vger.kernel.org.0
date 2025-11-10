Return-Path: <io-uring+bounces-10501-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 85411C4822B
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 17:54:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 31E1934A91B
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 16:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F5E31A069;
	Mon, 10 Nov 2025 16:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U0eiQAtz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8D82877E6
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 16:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762793433; cv=none; b=mEUYhWdguuLxYWJSYDpc22QpUbARSqXsg11/Ladm5xY4/GW0Iw3oSZGzIEpE/BQeSk7p7Vyz45F3GKYyzHPXu2WB+/jq6+QsrEWqbO4nLTt2PlxxxGv7ZtJ4T2WYw0d3RVP3nXYCPDP/owZ4cfcfMuseRq3MbtvMohKn6Wr4Qvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762793433; c=relaxed/simple;
	bh=XltYOg7k6APNYxmEk9YbYTSDtH+b3EpjGO8HEYY9tKY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K5M1NeeihfZ2TNCMmc0k/hll0clguIfahxci/c/LEHNMYGJ7G++2RIKlncA6dgCacLwsEsC7lcJoe0h6oAgmiGVVAyhG1lW1VAdlNTz+EWFNgMW8NceNKYjpVTMcwv8DuYOvVQ9VSoUkN3tHr0JgN2mihGODEsBDcLJMvlzTefE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U0eiQAtz; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-641677916b5so3105398a12.0
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 08:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1762793429; x=1763398229; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DkZN9c+POTwUaLOiQGKa5zH5Hbhc5P5pBlVymH+hWeM=;
        b=U0eiQAtzfgyVzzeGYX7dXlwKhAieJvyB5T6egjx0ez+8Uk1373vvuxlO8Ftpa6dasV
         aq4eSqea2YUMqbDwOHphQdRmHzWCB4GYVuIhc3h24KgHZ0ej4BisXfCQnIMLtdTEpStf
         QEO1C+p08cnvyH67ShKcHep/RvSDMFY+wmomQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762793429; x=1763398229;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DkZN9c+POTwUaLOiQGKa5zH5Hbhc5P5pBlVymH+hWeM=;
        b=GaJnzy8Z4pHAqS6cEgc13SPGzMvctTonAi9zOSdEm08dhSGyhCYtdjXf51bDcNg80b
         VhHFt185wHdL+PBNY3ekPcEdNHNRzVzzwQ2i83iRzoVJEw5pWg+cbg6/OaHbS4ec6yji
         O52WPRdqS5OkBvL70ubfCSHBcH5kOGkQdFSa5JOKHVIHcpvBaDJtVFKS7lIQdztMmu7U
         sBoxAZG0p5HlCKvI2/9oF98wLoSWS3d7szzhS/j0h1oPXM9QIiw/AlpfgtJRuRGKmW6K
         hu8/1Z+DG/jdmDmAxxX+v2TgFoo/Os+M6WtZ5c549r1xB81c5fcWJlTuWJZAWNRkNnFn
         VPsw==
X-Forwarded-Encrypted: i=1; AJvYcCW6JgxMYCM9UtrRhOIfGz9QG6SFHudATW0USyslC/GWMIZrzuu05B8uRHF2ANG4MwDhXctYwm6klQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzR2ka/7wV2PL6fx0wMqMHKpE/4WCN8lSPWabBkOefAGU0fp3Jn
	FtsCqBNYqieKTbq7g6s8woMUlMrGBvNuJZHSxLJWwa+XgreC9Kv1EvRPXnHdoWhtq+BnXoFxdbe
	O4EoYjJg=
X-Gm-Gg: ASbGncumSTZLTEO2VjjnjQERD5TLgPZK1Hjq3z5Akzx/VrhoorrAi/2hFuZb+KhGfVG
	u1oLRAM4WFCTQSVpGypPuZjNk+3ngg3bq2ro1zoLoSy3nWrfbvzF6hq2UdfHqRADBu3TH3mre6V
	YXU5NregqyWrjggMvnltldztUvrSyzZLAtiHoLy90QgxGTNQs+2KHYDMbgPHu2HjUQPotw8PM/h
	BmeO5ti+SJfub7FPvY7HTYr5YWLwQRUSVJj0vfbbWREefvBFKWYBq/H/37nOBfeqm70YNDnOHDx
	JTrEPHqy6/I9TqDWYB4hAvyGIinMK8GkZ2Ekt/RKlS8lgdtnybBPdDwow8xe2+/w1j10XaONlVB
	glNZKAeKN81bVII7NwfVhKAAhKP6BOuDKJ9QmLO5fjYIdPV8Uw27ZhxaDhI/DqWhs0G87lcSgTx
	QkzFQPngcVHjUKngKabbmIT+twuqIMAXEUUql3g+vf4bWrT8F5lQ==
X-Google-Smtp-Source: AGHT+IFpx6JOT7ujzgkLlw9jC0h6YbJx0tuQZX7+ZTjKc9Eqi3aFBlUyHxDRTaDAAjJwMhXk7IlC/w==
X-Received: by 2002:a05:6402:51d3:b0:641:72a8:c91c with SMTP id 4fb4d7f45d1cf-64172a8cfb4mr5615036a12.27.1762793429385;
        Mon, 10 Nov 2025 08:50:29 -0800 (PST)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64166d0653esm6142441a12.29.2025.11.10.08.50.29
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 08:50:29 -0800 (PST)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b7291af7190so473559566b.3
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 08:50:29 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWVhJwQ+qt5yBJGVKUnx17DP9YPMH7Pi5H52FHSgVgqmcX9S+9CgVCYUtBax+dyQBVPjVu9f42rGQ==@vger.kernel.org
X-Received: by 2002:a17:907:da3:b0:b72:a899:168a with SMTP id
 a640c23a62f3a-b72e031d007mr811932266b.28.1762793427368; Mon, 10 Nov 2025
 08:50:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk> <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
 <CAHk-=wjA=iXRyu1-ABST43vdT60Md9zpQDJ4Kg14V3f_2Bf+BA@mail.gmail.com> <20251110063658.GL2441659@ZenIV>
In-Reply-To: <20251110063658.GL2441659@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 10 Nov 2025 08:50:10 -0800
X-Gmail-Original-Message-ID: <CAHk-=whxqWfNmPuE59P56Q-U29he2x3BO9C0Q4bUPphBtNdQpg@mail.gmail.com>
X-Gm-Features: AWmQ_bne3SudUbW59AJIrZv5w1KqgWCmrYPp42xrhe0AZmxb-UOp-XffXDbOnBM
Message-ID: <CAHk-=whxqWfNmPuE59P56Q-U29he2x3BO9C0Q4bUPphBtNdQpg@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz, 
	mjguzik@gmail.com, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 9 Nov 2025 at 22:37, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> > @@ -258,13 +264,13 @@ struct filename *getname_kernel(const char * filename)
> >
> >               tmp = kmalloc(size, GFP_KERNEL);
> >               if (unlikely(!tmp)) {
> > -                     __putname(result);
> > +                     free_filename(result);
> >                       return ERR_PTR(-ENOMEM);
> >               }
> >               tmp->name = (char *)result;
> >               result = tmp;
>
> That's wrong - putname() will choke on that (free_filename() on result of
> kmalloc()).

Yeah, that's me not doing the right conversion from the old crazy
"turn allocations around".

It should just do

                char *tmp = kmalloc(len, GFP_KERNEL);
                .... NULL check ..
                result->name = tmp;

without any odd games with types. And yeah, that code could be
re-organized to be clearer.

             Linus

