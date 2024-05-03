Return-Path: <io-uring+bounces-1729-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 326598BB657
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 23:47:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E3981C227DC
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 21:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 392F482D94;
	Fri,  3 May 2024 21:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BWAXnd37"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D1681AAA
	for <io-uring@vger.kernel.org>; Fri,  3 May 2024 21:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714772564; cv=none; b=TGLOZyPdAKeL5NFAy+s8rna0lPHTAZXrDn8kxo1DqTny0e81mfsGsG9r+VdbGiYisezdU59aiwq6+PM7HEOmwkLh8S9htp6pyEIqteM6+vpbsPVW2KlqENGbtTHmhOMQC4FIjo5hp3b7BI1mmvzrmob3p/E+z5VzrFE0ZDwED+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714772564; c=relaxed/simple;
	bh=5kw/vQ2Z4GIERA/PZJO8R5H1So5ym6+6uJIhwrtRtXs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PUInTgFWYIf0JxRt6+FRpbP3Sa3ttjHO94PQa1BPl03rMzAjES2x+wS51eaNMc0Y40GfMTwHwq3Q29N7nGq7yGrjSvMsNzPncoDXk3nTVYS1mehcmQsy9iH+nTSWrsAbrAICweJpL6GjwMP4y5uSh8Hc37hQoQp4Lzgdj8YCXn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BWAXnd37; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a59a5f81af4so17033866b.3
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 14:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1714772560; x=1715377360; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gwyBdWufoxKVrcKcsHh2OBVbUooApVD3S23GDedqB7U=;
        b=BWAXnd37oXbnZsHze4We8ZkQ2HKVHWZsPh/SWnlt/VZHjV0RmWa4S4DKTQ+NL27DM0
         nMyoXBjC0O29EriEDpUE8WaETB0t4T89h9M+RrAoO/8hwJ2k/lrg9hT4ucl70xcNtSYA
         XZNEbxPjWWleEcwSiTWkepTDqZISPhB2T2YFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714772560; x=1715377360;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gwyBdWufoxKVrcKcsHh2OBVbUooApVD3S23GDedqB7U=;
        b=Y+F+1xQt0CVqTnoujWPdtKkoRpwXWOxYApv7KPfHFduxsUEPgt0pbLJ92oR3cTjpzJ
         +0CZndgW0ysxK3OAmazT8D1jUPH3hLgUJBiZN7hnctx0gigyHLKypWOaQ6xnGrFJ1aCB
         KFQNHY7093Xf57jnEE2CkddcVA2meGGS+bLVh/JXAo2zy7Vro+TMfFjwZoQnxDh4jACC
         LRSfDK3MSWukmCGBw6suiQemi0cn+OmfVf9x5Bgfyn4gQY02rZGYAEThtWHu5D3Z7Bfd
         NuP0U/ha/JtYcoAr/nl7gK/cWH9mC1T6qD8OUlsGHWVLe7aGvAnzflxaA6DBWo8+4TFL
         fTSA==
X-Forwarded-Encrypted: i=1; AJvYcCV2AOfAm/8vdB0xpkDLKjzAC0FVXJrUPS93kmlMugvH88d8IjwryPkmYh9a+Y3l7j6lrb0CNMeGGUhMrbi/Boa0/qGrdFZgxM4=
X-Gm-Message-State: AOJu0Yx/C1ORrHVM04LLMSIk40lzeR0Uf+pY6uw/eIz2IqC1AH9Tzjt0
	VXQySG4sgrObNCXHHcfKjO7afn0Mna265iqi14XFVUJNwiHq+XvZAfqwlduD4PHgACYLCS2s20w
	3NoJbiA==
X-Google-Smtp-Source: AGHT+IGF129Yq/j66GxqSezDeWxcWF06ZaNAMBuTOtjKIvQ+4SnVNoL09z4KSMllsJ/FkNbTBhALCA==
X-Received: by 2002:a17:906:2610:b0:a58:7f48:18c4 with SMTP id h16-20020a170906261000b00a587f4818c4mr2330228ejc.68.1714772560685;
        Fri, 03 May 2024 14:42:40 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id w21-20020a170906481500b00a59a0001840sm448213ejq.31.2024.05.03.14.42.39
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 May 2024 14:42:39 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a59a5f81af4so17027566b.3
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 14:42:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUzKI7FGxq4s7dn7yy/I3HoTDPM6P1nYH7lPkYBP1MtVfmVJaJfawDOzEJxHzJFjoPZMEpF27E/FaZenRJinfc68otCIcBGeYc=
X-Received: by 2002:a17:906:29d4:b0:a59:8786:3852 with SMTP id
 y20-20020a17090629d400b00a5987863852mr2658677eje.55.1714772559064; Fri, 03
 May 2024 14:42:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0000000000002d631f0615918f1e@google.com> <7c41cf3c-2a71-4dbb-8f34-0337890906fc@gmail.com>
 <202405031110.6F47982593@keescook> <64b51cc5-9f5b-4160-83f2-6d62175418a2@kernel.dk>
 <202405031207.9D62DA4973@keescook> <d6285f19-01aa-49c8-8fef-4b5842136215@kernel.dk>
 <202405031237.B6B8379@keescook> <202405031325.B8979870B@keescook>
 <20240503211109.GX2118490@ZenIV> <20240503213625.GA2118490@ZenIV>
In-Reply-To: <20240503213625.GA2118490@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 May 2024 14:42:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgRphONC5NBagypZpgriCUtztU7LCC9BzGZDEjWQbSVWQ@mail.gmail.com>
Message-ID: <CAHk-=wgRphONC5NBagypZpgriCUtztU7LCC9BzGZDEjWQbSVWQ@mail.gmail.com>
Subject: Re: get_file() unsafe under epoll (was Re: [syzbot] [fs?] [io-uring?]
 general protection fault in __ep_remove)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
	Bui Quang Minh <minhquangbui99@gmail.com>, Christian Brauner <brauner@kernel.org>, 
	syzbot <syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com>, 
	io-uring@vger.kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, Laura Abbott <laura@labbott.name>
Content-Type: text/plain; charset="UTF-8"

On Fri, 3 May 2024 at 14:36, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> ... the last part is no-go - poll_wait() must be able to grab a reference
> (well, the callback in it must)

Yeah. I really think that *poll* itself is doing everything right. It
knows that it's called with a file pointer with a reference, and it
adds its own references as needed.

And I think that's all fine - both for dmabuf in particular, but for
poll in general. That's how things are *supposed* to work. You can
keep references to other things in your 'struct file *', knowing that
files are properly refcounted, and won't go away while you are dealing
with them.

The problem, of course, is that then epoll violates that "called with
reference" part.  epoll very much by design does *not* take references
to the files it keeps track of, and then tears them down at close()
time.

Now, epoll has its reasons for doing that. They are even good reasons.
But that does mean that when epoll needs to deal with that hackery.

I wish we could remove epoll entirely, but that isn't an option, so we
need to just make sure that when it accesses the ffd.file pointer, it
does so more carefully.

              Linus

