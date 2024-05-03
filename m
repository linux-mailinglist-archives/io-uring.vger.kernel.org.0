Return-Path: <io-uring+bounces-1740-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 68E318BB828
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 01:23:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B07F286107
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 23:23:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60E2A83CD8;
	Fri,  3 May 2024 23:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QgbhR5TG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045305CDE6
	for <io-uring@vger.kernel.org>; Fri,  3 May 2024 23:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714778616; cv=none; b=eezTcFf8Kikl/DjDEfehI9SCG+soHEQVKJFmteEGzW00vDQYCnOJ2eDneTziJH1N7AG7M4pPwL+p2CHos4oUuRWZ8c3HGa+QXWnxULdKqFSF/4dcrdDXhvT4pIKNc84Bamqwc4P19jyUGJqxLMYeyFCBMXZE5j1gRzbESMp4zYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714778616; c=relaxed/simple;
	bh=zTpIfqRQDzdzVfUsy6l5qLMI78ldTHEPUTPdLY17JIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i3eJ/mDhVMVZzS7FYDiFFYEIAiCD31IdN61pTZdIOvFnQFKryS4Mj6Tewiy2ZHwTAXz++L6CbHXI8gEPZ0ay7PbvX+JkR6NvGS127TPmopG42+B6RBD4xYbbeCn1S/X9rW3vZ49gPFkLW2pRvfla+dOEfpFfErEpaMD7z5cbFmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=QgbhR5TG; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1ec486198b6so1373785ad.1
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 16:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1714778614; x=1715383414; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VUA37CihXVg7mm5FxSpz/CzjnHfbPR2trIEY0fDnh+Q=;
        b=QgbhR5TGzckPzZKG39guSJM+khq955ZxBWGEAq0fY52fc//uRlCu4dqNh8ggEc62Zc
         Vdd5iECV2R8RjmhJhKBVj0c+bd1l+dF9HPBZomRJmiJXJtNkcie5MbtnDa6iiew+wIii
         EBRNqwd/Wqpe7a4gS1eB3ujq8jMj6CFLDRrcQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714778614; x=1715383414;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VUA37CihXVg7mm5FxSpz/CzjnHfbPR2trIEY0fDnh+Q=;
        b=TCjmJvtjV/7EqlwwDcdgP1ZLXN9rFUydrYFfXXggPvgliv22tpxdkdjZ1NgxvkEUvg
         vA/JVTL3vNKv3OmFPFrAtOmJSgkKr9I0KFQb8KOtNOhKpsRzLrXbQrYmi7SCqF3XOovn
         +gqI6EtWImakLJe4EPap85LbY8R28Luo3FlmC5utxkOhIYQZME5lEguRZsJoGudUy6rC
         Hyb9HBySwaTIPCXJRcR0mtIg/n+JtoVnWlhWv1hLI6wrdrjWCN9hxarAz3exFNSMrY0i
         cyjcPpQrY2fRzQNCRUwv9IXDIeZMa7FGZcKD/uV/cVYrIJnDLP0H06bd2Ra/pYr8/5sA
         mfAg==
X-Forwarded-Encrypted: i=1; AJvYcCXqlJarvE0CEB0SfLfRzuJCg1alAhLT+r7KQNm2QXio92TTZo1jCsQaU391QHQLXo8qsbroUColaDPewGKAIhcjMMBSrFUUt9Q=
X-Gm-Message-State: AOJu0YyuPpyToe3GKItQt4xIx0J39Ni9j5zcn1eDwl9VSiZz0N11B/h/
	PlJCT2/d+j7U0yXeusGJJcR4OGMZBzOHxSTEofZC2TYZ/HQ2Ay0E3nW3nXXFag==
X-Google-Smtp-Source: AGHT+IGYEU76uRUVHu3t+p2cOz6G2yu0aNydyl6VPEopXdNsv2Uoe1Hs5RLUXZ183qrKjCrJ/IlslQ==
X-Received: by 2002:a17:903:1c2:b0:1e4:6243:8543 with SMTP id e2-20020a17090301c200b001e462438543mr4608970plh.5.1714778614174;
        Fri, 03 May 2024 16:23:34 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id b11-20020a170902d50b00b001eb2f4648d3sm3793511plg.228.2024.05.03.16.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 May 2024 16:23:33 -0700 (PDT)
Date: Fri, 3 May 2024 16:23:33 -0700
From: Kees Cook <keescook@chromium.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, axboe@kernel.dk,
	brauner@kernel.org, christian.koenig@amd.com,
	dri-devel@lists.freedesktop.org, io-uring@vger.kernel.org,
	jack@suse.cz, laura@labbott.name, linaro-mm-sig@lists.linaro.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, minhquangbui99@gmail.com,
	sumit.semwal@linaro.org,
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Message-ID: <202405031616.793DF7EEE@keescook>
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240503214531.GB2118490@ZenIV>
 <CAHk-=wgC+QpveKCJpeqsaORu7htoNNKA8mp+d9mvJEXmSKjhbw@mail.gmail.com>
 <202405031529.2CD1BFED37@keescook>
 <20240503230318.GF2118490@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503230318.GF2118490@ZenIV>

On Sat, May 04, 2024 at 12:03:18AM +0100, Al Viro wrote:
> On Fri, May 03, 2024 at 03:46:25PM -0700, Kees Cook wrote:
> > On Fri, May 03, 2024 at 02:52:38PM -0700, Linus Torvalds wrote:
> > > That means that the file will be released - and it means that you have
> > > violated all the refcounting rules for poll().
> > 
> > I feel like I've been looking at this too long. I think I see another
> > problem here, but with dmabuf even when epoll is fixed:
> > 
> > dma_buf_poll()
> > 	get_file(dmabuf->file)		/* f_count + 1 */
> > 	dma_buf_poll_add_cb()
> > 		dma_resv_for_each_fence ...
> > 			dma_fence_add_callback(fence, ..., dma_buf_poll_cb)
> > 
> > dma_buf_poll_cb()
> > 	...
> >         fput(dmabuf->file);		/* f_count - 1 ... for each fence */
> > 
> > Isn't it possible to call dma_buf_poll_cb() (and therefore fput())
> > multiple times if there is more than 1 fence? Perhaps I've missed a
> > place where a single struct dma_resv will only ever signal 1 fence? But
> > looking through dma_fence_signal_timestamp_locked(), I don't see
> > anything about resv nor somehow looking into other fence cb_list
> > contents...
> 
> At a guess,
>                 r = dma_fence_add_callback(fence, &dcb->cb, dma_buf_poll_cb);
> 		if (!r)
> 			return true;
> 
> prevents that - it returns 0 on success and -E... on error;
> insertion into the list happens only when it's returning 0,
> so...

Yes; thank you. I *have* been looking at it all too long. :)


The last related thing is the drivers/gpu/drm/vmwgfx/ttm_object.c case:

/**
 * get_dma_buf_unless_doomed - get a dma_buf reference if possible.
 *
 * @dmabuf: Non-refcounted pointer to a struct dma-buf.
 *
 * Obtain a file reference from a lookup structure that doesn't refcount
 * the file, but synchronizes with its release method to make sure it
 * has
 * not been freed yet. See for example kref_get_unless_zero
 * documentation.
 * Returns true if refcounting succeeds, false otherwise.
 *
 * Nobody really wants this as a public API yet, so let it mature here
 * for some time...
 */
static bool __must_check get_dma_buf_unless_doomed(struct dma_buf *dmabuf)
{
        return atomic_long_inc_not_zero(&dmabuf->file->f_count) != 0L;
}

If we end up adding epi_fget(), we'll have 2 cases of using
"atomic_long_inc_not_zero" for f_count. Do we need some kind of blessed
helper to live in file.h or something, with appropriate comments?

-- 
Kees Cook

