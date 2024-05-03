Return-Path: <io-uring+bounces-1727-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C6EB8BB5CB
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 23:34:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58BC6283FD9
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 21:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63B3C56750;
	Fri,  3 May 2024 21:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I041ed7w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57CC54903
	for <io-uring@vger.kernel.org>; Fri,  3 May 2024 21:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714772038; cv=none; b=CrM5qVFq5be+EeaJhjM548Rz+7wLO03H+MZhuB4t0IRPUQPhT0GBxh9EQsSYj9CdV76thm0QuKrQGphJf/lQCa7MyPf+e2t2VG0MxbMAw2RsgKUg4eFKfpaOO55DDGSfp5nbTPpxDLQyMfq9nWyWhIBtTZyQTEMh+xa66fryB1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714772038; c=relaxed/simple;
	bh=9Qapmfzm6lSNA1KjLLEHmaWSypEB5MZ/Duccomf7UwA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HbVzQVh1SznxwWGKLm+C9srm60jsrAY6sEzt/M36TXGVwNej9QkmC2cbqoAP0RMb8b+Wu7jFmccXaaYKWQeg13mlzy5kSH7cW0rc3K1UTeaJsx+KeGTbCcFCsqBPxzha6xd7NiSVvyq3sHZRnoNaA/x+Hp//bhxMgsgJ0gPrzH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I041ed7w; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a595199cb9bso10738166b.3
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 14:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1714772035; x=1715376835; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H0cKj1/eeDlsag1nYyx5cuj3RktPC8YvvhuCxa/6SIc=;
        b=I041ed7wq74EqHv+lLpw/4OnY1kI3FzQ0ynGOUp7811sa7ORamvQCjH55bC3YnkSar
         Klx1rhzeK82r5sekSRH+Cic3Wo0satWx94LLNP051CXWwirSPCCliSE8FVQHfxNUSvej
         uk8KtcOJLyEkqe0pyZgWuEHuRw49MMa4Hn1p4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714772035; x=1715376835;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H0cKj1/eeDlsag1nYyx5cuj3RktPC8YvvhuCxa/6SIc=;
        b=FULIezt5YLH63p8p92wahz3o+WdLySlY+RB+fZoH3Nz/oNcZVWC18h3G7inJZteEPV
         6Njq014G4CVgrPWCFCDpQ1WkLpHQ0KInnNitJUpb6u0lbwD+84ps/6dfvpChDKdiBuMk
         f1Gnewbb9b/dcP/GPJySNs0AjtJpJl4ZwV5G50TiMAeN1jcMdJz9RrQ0hNjzYmi2NQxE
         JVYXu0botnlBFIebUetGmymnF3tSM7RNDvBO21fJayY76MEbjzVmeipm0RGGcEGFwK4l
         mqKu+rMJx5KxTIIrjC1bFGaAh/nJJd9i/0ZnTXXeXYxidPqnoTwKXVacdDZ2jyttk+A+
         jGsA==
X-Forwarded-Encrypted: i=1; AJvYcCVDWD7wVzZ6BK3OYULW7tgc8T/gH8ctWbA2voGNXfnGjS3N9eO1C70NhRryI7YzoiUSjyJaz5SO+YoHR/l4//bormf++5i4lVI=
X-Gm-Message-State: AOJu0Yz7ehZh9Phjw6vWCxQH1q1vwGIY4WvJJhA5S6dv5uwzSLPvaOLr
	0BfKnCKBygsVu8i071h21PGrL3S8njniolnUBDTz8+ZEJ/I8Z7D0oKjPigqRiZja6JcmocF39fc
	am3nc8Q==
X-Google-Smtp-Source: AGHT+IGbs0TFnfUkLkNYaTER0tjlJ7ltqs8Dn5oufmSySPGUUNM8wC8S1xBG2OkeBGYbqZdOUBvw2g==
X-Received: by 2002:a17:906:af42:b0:a52:6e3a:87ac with SMTP id ly2-20020a170906af4200b00a526e3a87acmr2440563ejb.76.1714772035016;
        Fri, 03 May 2024 14:33:55 -0700 (PDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id c25-20020a170906155900b00a599a2d9a45sm856666ejd.100.2024.05.03.14.33.54
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 May 2024 14:33:54 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a598e483ad1so13919566b.1
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 14:33:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWhz65qiTrcQqj59DkoFJb+DM16OtSaqZw0r3snMRhADwlGTjqQn1PJfjT5GYHHF6LzVp074wyfO19ozlkv1NZDA9Ak/YvwLB4=
X-Received: by 2002:a17:906:2c50:b0:a59:761d:8291 with SMTP id
 f16-20020a1709062c5000b00a59761d8291mr2183947ejh.9.1714772033952; Fri, 03 May
 2024 14:33:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202405031110.6F47982593@keescook> <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
In-Reply-To: <20240503212428.GY2118490@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 May 2024 14:33:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
Message-ID: <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: keescook@chromium.org, axboe@kernel.dk, brauner@kernel.org, 
	christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, 
	linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 3 May 2024 at 14:24, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Can we get to ep_item_poll(epi, ...) after eventpoll_release_file()
> got past __ep_remove()?  Because if we can, we have a worse problem -
> epi freed under us.

Look at the hack in __ep_remove(): if it is concurrent with
eventpoll_release_file(), it will hit this code

        spin_lock(&file->f_lock);
        if (epi->dying && !force) {
                spin_unlock(&file->f_lock);
                return false;
        }

and not free the epi.

But as far as I can tell, almost nothing else cares about the f_lock
and dying logic.

And in fact, I don't think doing

        spin_lock(&file->f_lock);

is even valid in the places that look up file through "epi->ffd.file",
because the lock itself is inside the thing that you can't trust until
you've taken the lock...

So I agree with Kees about the use of "atomic_dec_not_zero()" kind of
logic - but it also needs to be in an RCU-readlocked region, I think.

I wish epoll() just took the damn file ref itself. But since it relies
on the file refcount to release the data structure, that obviously
can't work.

                Linus

