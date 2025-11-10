Return-Path: <io-uring+bounces-10500-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A479C48344
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 18:07:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 919F642575E
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 16:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B5131DDBC;
	Mon, 10 Nov 2025 16:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LUKuim1N"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E8631D748
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 16:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762792927; cv=none; b=Ik+GEA99dTCVbQL/Mh2XMbs4rTYfWh/Xf3ese+XS5Y1EvO1FJhHVx8iz7ObrSC80hn0ug4txTw1x8oeLWmOG4OehX0cGxjioCIqwhQB6xcAvX4CXZm6+4MGTg04QjzVUK3bOefvKN0kZdY1Og6IWwbdfRMZjq7qbL3SjmG0Qqg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762792927; c=relaxed/simple;
	bh=GKjNPhJUmE3ffBWuGrURvcOJiiT4jJnfaIvMg2ZBr5E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TPaNj7HFZXf/hGqfaDyVHz8Xe4XOpMfXxKLnkP9BnrjyDoYRjJZNhr7HeqaiRbYTQ/QNxbvC3x06vwYegv1LdCk/Z0+0VKhZNuAm7n3FHqD1rSV1vrZAZaY+TFy7I+WXOs+Y+VKEgvRf5NoVTdba9NK2f/sbm5WXylC7+jcbmyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LUKuim1N; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b7277324054so473029766b.0
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 08:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1762792923; x=1763397723; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oEQJCmiS2IMzNjbxI9qhqVkNRGDbuejNOKBcwtqGw/c=;
        b=LUKuim1N0j3S16p1DLfN7+deJD/PIxRM9qwe+h2dwcZTnOoIRp4XfI9OAXWyIuP2yE
         qkfv3z07mbQXqV3bvSYeE70A6pDRsCxTvvHpGJIXKw4BjumgVJ8JO0p3IiIae6ult9Qx
         d+cSuFf+aJNcM/T8HZ/7EvgEhNyP11q0ADFx4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792923; x=1763397723;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEQJCmiS2IMzNjbxI9qhqVkNRGDbuejNOKBcwtqGw/c=;
        b=NkURY07xgfszhWOAhLJkLDM87jrxYXUZW0Yrv1HlPG2bvbnAG4TNOhMBMDOZgdWdUk
         0KOG3KnFXSmIUv8Rizp7YZOwt5LrDHowjLcBhJVjfrn91zF3DzQ7rGXzFtRJlK/AK8AM
         KuMU3buaeHFBox+tC7huEX0dQfpwSmilU/4CxQvrn7CSgDOVJnxP/vRtWvfpaR9VRyNY
         164meyNtqU/dHTIZqbGpkFVR4j4y333UoWdudYdPxpcLXApGx7JXC6uebquY8N41+ovX
         NE2pNQwdW6u7yZgPccSBtrgJuazC+pYdCe8chC9EWCR7fUPXnGdBxhhUqjo6Rl51+njY
         714A==
X-Forwarded-Encrypted: i=1; AJvYcCWZsDTyHC3klvIRdxpRIDZfVVxC7snheHMgHX34120g29ygD3RAt+mh2cDXvF2m45z12IgPxwNriA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwmEqhFJzcieQe3lP8Cos/nCpD33H00VPSJKIJpzWKjQ47h9Swy
	OCJEm2r3txGjr4kVLO99M1/1B3Gjv97fvlKdpNKZ78bT6iRHidTwhauYFAkmarT0J4t4b6TOJgH
	K/pGFz+Y=
X-Gm-Gg: ASbGnctlNosUgaY9zRnu+sZlF9iBlhfyzGLzocgwN1EsAK4nRq9tgfFH4WABJ4MUUbG
	1arayGZI64odUClFzZSjrB6wah3LhROUvi46eeOwHeo8Wr+QCDa5FmZLva3rekUYrLc3IL9ZE3x
	Ch8Db78/rlV/1a2WmsHbJBQUjjqUaQeq/R4WkX8aQ5f2JGfz8OCakx1dcnH2QlZLrsQQ5iNvT2+
	bmHokJE2FfrJXWHjbqABFh7e/ZxGXuVVOmSba2txCXttGbXMtpFmBgJWiFP0XDSjHrk45WP+2JN
	wvABUM7mB6O2Epxgxt5ofmpMF7o5FA45mVI1oYBEbOLWq3fathdTfkNKj/mq+yIdUwF0AZyQX7w
	vgYXOHURm/WqU0C898eT+yROE+pa6gOCBgc6FuEG7PtHW6vRaYDBpfn4cWSPr+kNHngBGzhVaiN
	X8AjLk7wm64kog4vqQ1GSJBeBzKy2qlX108y5QwLQXOCzV1ETBloX14Pfoves8
X-Google-Smtp-Source: AGHT+IGfTQ+dvYdG1sBBtvgS+dJiE28s3g4dLHp9HVGHwXqH+5tNIEKiCPGh8tAlVs3alc0YzgsPKQ==
X-Received: by 2002:a17:907:1c9f:b0:b5c:753a:a4d8 with SMTP id a640c23a62f3a-b72e05bce7emr850596066b.62.1762792923350;
        Mon, 10 Nov 2025 08:42:03 -0800 (PST)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6411f862bd0sm11856745a12.26.2025.11.10.08.42.02
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 08:42:02 -0800 (PST)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b5a8184144dso422244166b.1
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 08:42:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXvWKRzqJmKIedsfE/tS9nUcWnktMrh9Efb9piOcTMFbvtCd/Tmn3WGKZkY4lU3Nqkk/6IFkIquPA==@vger.kernel.org
X-Received: by 2002:a17:907:7ea4:b0:b72:d9ee:db89 with SMTP id
 a640c23a62f3a-b72e056d064mr770836966b.47.1762792922013; Mon, 10 Nov 2025
 08:42:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk> <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
 <CAHk-=wjA=iXRyu1-ABST43vdT60Md9zpQDJ4Kg14V3f_2Bf+BA@mail.gmail.com> <20251110051748.GJ2441659@ZenIV>
In-Reply-To: <20251110051748.GJ2441659@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 10 Nov 2025 08:41:45 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgBewVovNTK4=O=HNbCZSQZgQMsFjBTq6bNFW2FZJcxnQ@mail.gmail.com>
X-Gm-Features: AWmQ_bmrAqXZ2m4pzkboWqVgXqNR03LoZBcEW296TEL_nMeJgv27T0QqUNlPZ1A
Message-ID: <CAHk-=wgBewVovNTK4=O=HNbCZSQZgQMsFjBTq6bNFW2FZJcxnQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz, 
	mjguzik@gmail.com, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 9 Nov 2025 at 21:17, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> That's more about weird callers of getname(), but...
>
> #ifdef CONFIG_SYSFS_SYSCALL
> static int fs_index(const char __user * __name)
> {
>         struct file_system_type * tmp;
>         struct filename *name;
>         int err, index;
>
>         name = getname(__name);

Yeah, ok, this is certainly a somewhat unusual pattern in that "name"
here is not a pathname, but at the same time I can't fault this code
for using a convenient function for "allocate and copy a string from
user space".

> Yes, really - echo $((`sed -ne "/.\<$1$/=" </proc/filesystems` - 1))
> apparently does deserve a syscall.  Multiplexor, as well (other
> subfunctions are about as hard to implement in userland)...

I think those are all "crazy legacy from back in the dark ages when we
thought iBCS2 was a goal".

I doubt anybody uses that 'sysfs()' system call, and it's behind the
SYSFS_SYSCALL config variable that was finally made "default n" this
year, but has actually had a help-message that called it obsolete
since at least 2014.

The code predates not just git, but the bitkeeper history too - and
we've long since removed all the actual iBCS2 code (see for example
commit 612a95b4e053: "x86: remove iBCS support", which removed some
binfmt left-overs - back in 2008).

> IMO things like "xfs" or "ceph" don't look like pathnames - if
> anything, we ought to use copy_mount_string() for consistency with
> mount(2)...

Oh, absolutely not.

But that code certainly could just do strndup_user(). That's the
normal thing for "get a string from user space" these days, but it
didn't historically exist..

That said, I think that code will  just get removed, so it's not even
worth worrying about. I don't think anybody even *noticed* that we
made it "default n" after all these years.

             Linus

