Return-Path: <io-uring+bounces-4943-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BF0FD9D52CC
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 19:51:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44FD3B24AE2
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 18:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45E691C8FB3;
	Thu, 21 Nov 2024 18:50:51 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09351CB9F0;
	Thu, 21 Nov 2024 18:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732215051; cv=none; b=VYtnIpbPabc0/eUfYT3GO/8Rci7MsOQxHXIJ962OXuolElmyQftLknrpaJUiyineppHvUwZ25qKwGuMAwJ3MRkNUAymmCD4HijL29ob9rSObCXh8pEwQuzdB3n5aWO2hiU6dqNt0lx8u23apjzV/6u70b8aSgiWJ4bhjfTwSeW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732215051; c=relaxed/simple;
	bh=wKNU16KpaJnt0VzAm6J26LFqDGxUFxBpqWBfN2icH1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pQfAmaANaSRmBSwXjLMg7D4NwZhrtXjyOCzpYF1aFIQVpivknnDN+PGdCUcHOvJHETTiG+yT5dPCjbYYsPLl0w1OfzePO1+Vh4532TBEP+npR7XoU9ncbinbZYxV89pk+Au2W8bfrGxsOY67qYtabLix7KPWMXDri22YqXSKEXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e3889bc7ec6so1283233276.1;
        Thu, 21 Nov 2024 10:50:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732215047; x=1732819847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N1SoflphJdSTWjWlYBW10VBQhVvyygIYFn3eyN0CY8E=;
        b=Dy5pklLJ2GLXIGIBYbpVV6uLnWtJGYi6uBJp+oKMK+2z4LE1yRYgiF1+Y7xCHUHhSb
         GM2YW/nlXvsoy3uTAX/1R47tYizDe6lB86Cl6jNdUDnJJQHDq6AydXJstsE/yc9/uwbn
         xK5H7J7IZx346IQsCXxcs2sTAb6uMTjgRctBw+M/Yvccm0Vy6KWBSAN8zijy0sqTLTGb
         yZgEb8JjF8AHe0xNi6QRUD/CtpgUq3WdvOZiuw3lMd7k5b3TCulg+SzAMqORl4IWH1/h
         wZCN3QZsx9GUHW7nbDqn6Doln19C1CZGqFH1WQZhfNKUUVOO1GFC2HUE9EDug1or5Nlo
         eAmg==
X-Forwarded-Encrypted: i=1; AJvYcCVpHUGpG2V3hMhDzo6Ty5xPRzIjbxj/zpZQvmxbrZbFjxH+pxvstBjDs7otMxq5aAqOKncUogIeQ1g2gk2O@vger.kernel.org, AJvYcCXP5IHwPlr3eUhDg+rstyepkdF/kpVXu8+seLpBFgXGWvullhWibE5gUobBpMikODdTKgPKTh4wrA==@vger.kernel.org, AJvYcCXr9XJfk6PaY3RU30ZX+JFTZ9ikgLTOLpETEbTIJkj5xKn3+UjReNE5fwzTj8qeqKAZ55FgQqzavLPWJQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9HqHog9LMlWU7O9rBEOEHiftl91HxMbovW7gW+W2Uh1OvyDPD
	kOtAE6JVLo4JPjl6/Ra0CjM4r3fh9CjeMeIbeIRZuJByAiplqb/kb26+XviQ
X-Gm-Gg: ASbGnctfR68mUuAgabXRPbD0U2HfYgvB8UoTKatLlfW7Kai1YgWWstPC6fG6xtlfwls
	thceGAGJPszJHraE+SWIAsEFFhHkwEJGmwSmYSi61/vTxW1vRnZB+YEn6oTH66RrnaLBr27VqaP
	SW4MOIRdyJ2oPMElvcm4v4hbmXXr4MuGTdMT5/WRrktUFtjYhGbffFAKXI3Ug53kq36tnOeR3R6
	pPSO3CR//WQiQIJLEECftBVjb9FyO8LStSgUispd/rcGrenwn/w5jBKaVV2Ho1RbVEBjnLd8+fU
	+Gl2oBgyvvB2KZLW
X-Google-Smtp-Source: AGHT+IHX2mf5rujr0Gw98cuoiZkHaZb2gYQKCSs9744BLWJf37z8ND06BeOnp2kfhIIFl+0fbrGxJQ==
X-Received: by 2002:a05:6902:2606:b0:e38:a203:bc16 with SMTP id 3f1490d57ef6-e38cb60c945mr8387030276.45.1732215046971;
        Thu, 21 Nov 2024 10:50:46 -0800 (PST)
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com. [209.85.128.170])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e38f6089523sm82574276.32.2024.11.21.10.50.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 10:50:45 -0800 (PST)
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-6eea47d51aeso12371667b3.2;
        Thu, 21 Nov 2024 10:50:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUOwogVxjrOmozWFw8OvkFfPjTyZ0MusjgFFp7UejGFbbeeVkWFG8YxdQ49K+CylkkiuDmRWj4v3Eko9A==@vger.kernel.org, AJvYcCVbMzIPMGYxQ9vv3WxVFCyICEb1gg5hbXjrz0GHlIqk0NVTyNT0C3H9gZZ+u25372n8QsPiMZJ5xg==@vger.kernel.org, AJvYcCWKxL5zmNo8aMFt4bLf9PKqJ1FAWPwfmIENPOYqY0+ygdP1sGb1KQXc31f9jhjg8yvBR8Pjz9/rRXxh5ltt@vger.kernel.org
X-Received: by 2002:a05:690c:6a01:b0:6ee:86da:3a49 with SMTP id
 00721157ae682-6eee08aba14mr4213967b3.8.1732215045390; Thu, 21 Nov 2024
 10:50:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
 <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz> <2e704ffc-2e79-27f7-159e-8fe167d5a450@gentwo.org>
 <CAMuHMdWQisrjqaPPd0xLgtSAxRwnxCPdsqnWSncMiPYLnre2MA@mail.gmail.com>
 <693a6243-b2bd-7f2b-2b69-c7e2308d0f58@gentwo.org> <f602e322-af21-4bb3-86d4-52795a581354@roeck-us.net>
In-Reply-To: <f602e322-af21-4bb3-86d4-52795a581354@roeck-us.net>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 21 Nov 2024 19:50:33 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXDmLoNAcKHpjp2O4D05nAd5SOZ=Xqdbb2O_3B09yU1Gw@mail.gmail.com>
Message-ID: <CAMuHMdXDmLoNAcKHpjp2O4D05nAd5SOZ=Xqdbb2O_3B09yU1Gw@mail.gmail.com>
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
To: Guenter Roeck <linux@roeck-us.net>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>, Vlastimil Babka <vbabka@suse.cz>, Pekka Enberg <penberg@kernel.org>, 
	David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, 
	linux-mm@kvack.org, io-uring@vger.kernel.org, linux-m68k@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 21, 2024 at 7:30=E2=80=AFPM Guenter Roeck <linux@roeck-us.net> =
wrote:
> On Thu, Nov 21, 2024 at 09:23:28AM -0800, Christoph Lameter (Ampere) wrot=
e:
> > On Thu, 21 Nov 2024, Geert Uytterhoeven wrote:
> > > Linux has supported m68k since last century.
> >
> > Yeah I fondly remember the 80s where 68K systems were always out of rea=
ch
> > for me to have. The dream system that I never could get my hands on. Th=
e
> > creme de la creme du jour. I just had to be content with the 6800 and
> > 6502 processors. Then IBM started the sick road down the 8088, 8086
> > that led from crap to more crap. Sigh.
> >
> > > Any new such assumptions are fixed quickly (at least in the kernel).
> > > If you need a specific alignment, make sure to use __aligned and/or
> > > appropriate padding in structures.
> > > And yes, the compiler knows, and provides __alignof__.
> > >
> > > > How do you deal with torn reads/writes in such a scenario? Is this =
UP
> > > > only?
> > >
> > > Linux does not support (rate) SMP m68k machines.

s/rate/rare/

> > Ah. Ok that explains it.
> >
> > Do we really need to maintain support for a platform that has been
> > obsolete for decade and does not even support SMP?
>
> Since this keeps coming up, I think there is a much more important
> question to ask:
>
> Do we really need to continue supporting nommu machines ? Is anyone
> but me even boot testing those ?

Not all m68k platform are nommu.

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

