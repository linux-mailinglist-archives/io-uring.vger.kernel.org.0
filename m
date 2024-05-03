Return-Path: <io-uring+bounces-1743-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7CA78BB889
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 01:55:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 553EE1F24476
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 23:55:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF7D884DF9;
	Fri,  3 May 2024 23:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZGjV9bOJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D359D5A110
	for <io-uring@vger.kernel.org>; Fri,  3 May 2024 23:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714780506; cv=none; b=rKaqUzq7gZEX5s8oZrzD9qgTqY4hTdGWCNyeVB33V9GEn5VDi0TD3zllf/mCc5YfJdnLHo9uvWFmLKF3r6/s8jMg7LnVWkGHzE3PzyXwtlX0lec+1Sa+7M+Cy9sSohdc/XafvEVUgCsrVam2aThPP3qfQ7CAzohXvT/skH/0T74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714780506; c=relaxed/simple;
	bh=tf8gPRKnHuj1S8RN72oCYha0zRiI+Zqb52T37Eym2SU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W0NqODA3tS9RS8eIsy7/vRgcUS3hB6xulrCuduglM+4rOOjdmV0HJZ/LgOZfmMTYcNo0xKfNnNsrIWAZHLef7ljM17VZmmOUjxml7rtmjbozTkzofQGk/+cgAIh7y7W0M8hMDMxyKHKtRuOBXqS6fMAJyUENTmO3y46h3Df5vaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZGjV9bOJ; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a524ecaf215so25681166b.2
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 16:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1714780503; x=1715385303; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NxPhlO3npeMKaw71dXY38r1VkXmdKnYRPE7+RntnY6E=;
        b=ZGjV9bOJtsx4vpIPOC+jl/xOHEhJ7ml4JgIzgS1AsIh9S5KtVKfqLKs5lLGdXsqdqf
         rWkxV9dUaT0DUgXtI/DlRGk7Nc6D3XFWtZVWDF3oll1MHPi3o8BiJMn9wp/AQUXXjouJ
         RyC5Ror5S88Byqw9QIUO/60WEA9J8Zz0r3ca4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714780503; x=1715385303;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NxPhlO3npeMKaw71dXY38r1VkXmdKnYRPE7+RntnY6E=;
        b=VEPu60bo3fANF/55jxMRr1fY5HfZ2G4PdTv1o8OsJrtpqkjaG2PSDxZcfP01q19dDO
         CCOUxg4sr3lBGjFrgAEnlEvSF5OTUhq+E21hGNM4oIdVQhSmo+8cdDqcUL9IlKVdbmA/
         uRB4RRAg1G2UDjL8sdeMobgpZNl1m6jYwfFt8LJkTPNIZQstHyLz+izVIHld7xOuE4d9
         b2pW0OTlQqCl3zmruns5+RMiLGZL9LFu7zyCkF50luVTvgWsChJ53fm3XV9HoBU4Qw1F
         y+3U0TfMb10GTJrdFxzaf+cCb2SKxb073EmaqfPh2hsTvM7FspBwYHSVw4RvRaBjFU5F
         K5sg==
X-Forwarded-Encrypted: i=1; AJvYcCVrywCxW+R33p4b/3C8cVlrGd0RJRiuTpscjuHbUw0oSeeNZsqa8tVfwVcBTx+BEf+rhaiK28FJca5j/L4/nNRvy3m4DPEs8og=
X-Gm-Message-State: AOJu0YyaLqiYSLe8o4jYnA3uPVt9I5qI5dVD8DGkVMYcg6hyJi1C8ivE
	diq8Z+kjhZc7FghuH8mvuOtEvXID7OnShObTvf1Lt3ENOWSFCJ5td5tSLtWKMGRVbULe8VBQY6Y
	nkFTubA==
X-Google-Smtp-Source: AGHT+IHDHYqgP/kAa3EqTpthB/lulFmUmu8m1Vp/BBPBmAue2iVt8C2Uo34yp7qoMeBhlyjQqQF8BA==
X-Received: by 2002:a17:906:448:b0:a58:cd39:d154 with SMTP id e8-20020a170906044800b00a58cd39d154mr2507403eja.11.1714780503198;
        Fri, 03 May 2024 16:55:03 -0700 (PDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id jw24-20020a17090776b800b00a599b64c09dsm874854ejc.128.2024.05.03.16.55.02
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 May 2024 16:55:02 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a524ecaf215so25679266b.2
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 16:55:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXy4Sp/yw5OJFkG3tTTNSBfpfGZmmyNz0u2TbrVqfX0+Ur2d1vx/x8bWCbfX3cUd/glPhrokhh6enR3jY23zIJVqmcy+7pIRhw=
X-Received: by 2002:a17:906:3e4e:b0:a59:a64c:9a26 with SMTP id
 t14-20020a1709063e4e00b00a59a64c9a26mr202788eji.23.1714780501707; Fri, 03 May
 2024 16:55:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202405031110.6F47982593@keescook> <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV> <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240503214531.GB2118490@ZenIV> <CAHk-=wgC+QpveKCJpeqsaORu7htoNNKA8mp+d9mvJEXmSKjhbw@mail.gmail.com>
 <20240503220145.GD2118490@ZenIV> <20240503220744.GE2118490@ZenIV>
 <CAHk-=whULchE1i5LA2Fa=ZndSAzPXGWh_e5+a=YV3qT1BEST7w@mail.gmail.com> <20240503233900.GG2118490@ZenIV>
In-Reply-To: <20240503233900.GG2118490@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 May 2024 16:54:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjjjsm=f+ZJRe3dXebBQS8PzpYmHjAJnk-9-2FAj3-QoQ@mail.gmail.com>
Message-ID: <CAHk-=wjjjsm=f+ZJRe3dXebBQS8PzpYmHjAJnk-9-2FAj3-QoQ@mail.gmail.com>
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

On Fri, 3 May 2024 at 16:39, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> *IF* those files are on purely internal filesystem, that's probably
> OK; do that with something on something mountable (char device,
> sysfs file, etc.) and you have a problem with filesystem staying
> busy.

Yeah, I agree, it's a bit annoying in general. That said, it's easy to
do: stash a file descriptor in a unix domain socket, and that's
basically exactly what you have: a random reference to a 'struct file'
that will stay around for as long as you just keep that socket around,
long after the "real" file descriptor has been closed, and entirely
separately from it.

And yes, that's exactly why unix domain socket transfers have caused
so many problems over the years, with both refcount overflows and
nasty garbage collection issues.

So randomly taking references to file descriptors certainly isn't new.

In fact, it's so common that I find the epoll pattern annoying, in
that it does something special and *not* taking a ref - and it does
that special thing to *other* ("innocent") file descriptors. Yes,
dma-buf is a bit like those unix domain sockets in that it can keep
random references alive for random times, but at least it does it just
to its own file descriptors, not random other targets.

So the dmabuf thing is very much a "I'm a special file that describes
a dma buffer", and shouldn't really affect anything outside of active
dmabuf uses (which admittedly is a large portion of the GPU drivers,
and has been expanding from there...). I

So the reason I'm annoyed at epoll in this case is that I think epoll
triggered the bug in some entirely innocent subsystem. dma-buf is
doing something differently odd, yes, but at least it's odd in a "I'm
a specialized thing" sense, not in some "I screw over others" sense.

             Linus

