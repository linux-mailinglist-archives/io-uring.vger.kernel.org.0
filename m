Return-Path: <io-uring+bounces-1842-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEFA68C1234
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 17:48:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0CF41C21252
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 15:48:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9C0216F824;
	Thu,  9 May 2024 15:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FKLtlobq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA2E16F0F9
	for <io-uring@vger.kernel.org>; Thu,  9 May 2024 15:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715269721; cv=none; b=J8ApmU8Ln1Ml9llif0GRNYi/DBbgsZORvqrL4AYlL8ZZZ/sw7CI34shr2vgkqPfVDdNKF04YbVvw8Ibo2qJxsieL/8yBcmsJd1u9ZZduDtWlbzZ6zBn6fBQ4DBzSgLN2Te4WARIJKOYaaIt8eckLaJO2pSbfFmg0xflhDhHiuR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715269721; c=relaxed/simple;
	bh=mA/fCF0Hyf2s0C0NAXcut1RdJ0/A1Vl70kRKZc0yNVY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dcvKXfal2AzqVmtk7lVbKEdJXi5br7uF7JpAxBCHdGe6x95RbiAE5MQYJRZg1qkxAWntblYMM9HLQunRJGwtNagG9EkZ+VeHCmBnbQgjWmpF2se52L6Z6yVvDlpc6djDrK/v/Wy0mVW7iQNyRqtwvBgL6Cxktzr8bH0MDm1nnpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FKLtlobq; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a59a609dd3fso181314566b.0
        for <io-uring@vger.kernel.org>; Thu, 09 May 2024 08:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1715269718; x=1715874518; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=38BuvpIpkB3oaxq+zw4VsWBKcS3P81IEjFcYuWVYCpU=;
        b=FKLtlobq4c6hJOYoFGwAOWHfvoVBC1mWG916sFHcipx/7mLXaSKcHIKMpEFA9F06In
         JE5Rz3OadyS6/dUEr5bGb91Xfqgn5TZlShcu9qkb9y3zlOezbiC3z4YXBJ/vCrRxmZ6E
         RNui+TVxmHxWodFoZX3cCZcChPXt7pFjcPnfI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715269718; x=1715874518;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=38BuvpIpkB3oaxq+zw4VsWBKcS3P81IEjFcYuWVYCpU=;
        b=i7QrRItfDvBq3BhBFB2GFVkfyEcdFSSOAkDu5NqwoLI0sWVZuW/T3p+J96uPMloC5W
         16fu5ukLa+Nl4RMOnzjKy6XhJLQy6HvWDdLm+g8Icea/2/jBTEZEfaVeiQsFHT2O5Em8
         ID8HZz0L/QupSmJz2sHG9A/xrgofz2NVU8SAec35EAimXb4Rcibp35IqEzcAidw27YbJ
         iAz5+gtVWj1luNZ4OgewI1BSVSejG6n2uKrRYsHXgBHZIuHxsRKrTTh4J8A0kp+P4FcY
         hLZhwz2/+OEHssAvl0cvMIT0+Mqqom+muEGRDEF4a5Ldoy0TfYtp8DFPDiIjVKXkpyKL
         d4Kg==
X-Forwarded-Encrypted: i=1; AJvYcCUfnG6qXh+UN/PoiWyMyJ4pr88EIfPLTOoT8AJ70cQ3vjIavjqz3elM/nc1axScojDJ8kuWZHFsoWMa8IAUA4JzxxivxspTpkY=
X-Gm-Message-State: AOJu0Yy/LsPE59tXR9NKhTNR/jwXX8K8TL8BnygyIx/yzTuCvV9y2wFo
	3mo7SwAiG2EzVXPop013M79CWZqJUO8N2ZYDh+Laf1YVTN5PUqJsWDR59HqT+GhifA13B6x0JaS
	/Q7BLzw==
X-Google-Smtp-Source: AGHT+IFF1dxpdWghkEvfiXgVD/7VDmSsH1NvR0XZ0HYXCJ0PfFVCVtj5Vr6/Q2tk0C+lqEuuVBRRuw==
X-Received: by 2002:a17:907:86a9:b0:a5a:24ab:f5e with SMTP id a640c23a62f3a-a5a2d27d8bcmr5853966b.25.1715269717915;
        Thu, 09 May 2024 08:48:37 -0700 (PDT)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a1781d5f9sm87870266b.17.2024.05.09.08.48.36
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 May 2024 08:48:37 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-573137ba8d7so3958436a12.0
        for <io-uring@vger.kernel.org>; Thu, 09 May 2024 08:48:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXX+mOT8QUvVeCMxV32Z9ddZw00JVQKRGojJcX0mqXYIQbxgbW0mp2rQs+yob0OA5jHVXizcmE5i9IIyJc2+CXKaKggoe7cF8M=
X-Received: by 2002:a17:906:19d0:b0:a59:fb06:5d35 with SMTP id
 a640c23a62f3a-a5a1156665fmr240732966b.8.1715269716628; Thu, 09 May 2024
 08:48:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wj6XL9MGCd_nUzRj6SaKeN0TsyTTZDFpGdW34R+zMZaSg@mail.gmail.com>
 <b1728d20-047c-4e28-8458-bf3206a1c97c@gmail.com> <ZjoKX4nmrRdevyxm@phenom.ffwll.local>
 <CAHk-=wgh5S-7sCCqXBxGcXHZDhe4U8cuaXpVTjtXLej2si2f3g@mail.gmail.com>
 <CAKMK7uGzhAHHkWj0N33NB3OXMFtNHv7=h=P-bdtYkw=Ja9kwHw@mail.gmail.com>
 <CAHk-=whFyOn4vp7+++MTOd1Y3wgVFxRoVdSuPmN1_b6q_Jjkxg@mail.gmail.com>
 <CAHk-=wixO-fmQYgbGic-BQVUd9RQhwGsF4bGk8ufWDKnRS1v_A@mail.gmail.com>
 <CAHk-=wjmC+coFdA_k6_JODD8_bvad=H4pn4yGREqOTm+eMB+rg@mail.gmail.com> <20240509-kutschieren-tacker-c3968b8d3853@brauner>
In-Reply-To: <20240509-kutschieren-tacker-c3968b8d3853@brauner>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 May 2024 08:48:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgKdWwdVUvjSNLL-ne9ezQN=BrwN34Kq38_=9yF8c03uA@mail.gmail.com>
Message-ID: <CAHk-=wgKdWwdVUvjSNLL-ne9ezQN=BrwN34Kq38_=9yF8c03uA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] Re: [PATCH] epoll: try to be a _bit_ better about
 file lifetimes
To: Christian Brauner <brauner@kernel.org>
Cc: Daniel Vetter <daniel@ffwll.ch>, Simon Ser <contact@emersion.fr>, 
	Pekka Paalanen <pekka.paalanen@collabora.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org, axboe@kernel.dk, 
	christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, 
	linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 9 May 2024 at 04:39, Christian Brauner <brauner@kernel.org> wrote:
>
> Not worth it without someone explaining in detail why imho. First pass
> should be to try and replace kcmp() in scenarios where it's obviously
> not needed or overkill.

Ack.

> I've added a CLASS(fd_raw) in a preliminary patch since we'll need that
> anyway which means that your comparison patch becomes even simpler imho.
> I've also added a selftest patch:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=vfs.misc

LGTM.

Maybe worth adding an explicit test for "open same file, but two
separate opens, F_DUPFD_QUERY returns 0? Just to clarify the "it's not
testing the file on the filesystem for equality, but the file pointer
itself".

             Linus

