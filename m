Return-Path: <io-uring+bounces-1731-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 050E68BB66A
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 23:53:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B533C281041
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 21:53:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D45E738DDD;
	Fri,  3 May 2024 21:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="huuBMvIb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3C3210FB
	for <io-uring@vger.kernel.org>; Fri,  3 May 2024 21:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714773179; cv=none; b=OdtKroY8LjRF6lcoPpIZmMuA92Y8CNNSjrj+J+cxQwcfi3x+YKwrSyENailiup2f4J7A8U17DHBbgIKBO334ZJqpRBucPTmn6Ey3Tp5C2vqekteBxmXAzAXrtTHr/DddD5wksx5saQ1CMPQc3Ps0hEgmxb5+aPFxovDiqQ8T1yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714773179; c=relaxed/simple;
	bh=d5soG/vdOcHc+T4G2kOCRoZhsfh2zUDag1A1J17X/z0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mmp5AgQ4aBcIedSIAgJY/OoxUADuNQSntor49QQtrjrNRwHg/wgJMk1BHdNF5W6nrm4GJ+1BnIXnRFjhITWj7voaI+7S+rrS2Mp9AA5Z0iLx0amAuovsTSunKcc/qw4YE9gbFasQ4MUQgJNh5c2LqdLdbLsiJIyfZgekRogY0t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=huuBMvIb; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a599af16934so17664766b.1
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 14:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1714773176; x=1715377976; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A7KwjGqB6cN3Dl955k2+YGPiXLoEdjHxOLmUV0m+ZBo=;
        b=huuBMvIbJRnhXNGnfhWTl/8RmzkvVfAA/eyOTiGwbrJpFW1AMRk4T2gc6j+pnbqa4g
         qkD29080e6P3DhOf0a4zzVcKj0oTS0l19mdgaBNgdbXLxQnAZ4vnD+aOs5IsnaDHcATT
         gZQ4zEBUYQFaZvFKsi4yYIvc0vm8F9Ue44vTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714773176; x=1715377976;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A7KwjGqB6cN3Dl955k2+YGPiXLoEdjHxOLmUV0m+ZBo=;
        b=ntp6bvhEvd6YnN2wVMpSDxV5S2RIK/2uWvrYNj84kJQtsGxeBFTLJOCMv7/RnanaC3
         lUoVTijwT5ui7FQhOF/Jp4jujhz8TeTX43EEvQnr1C0FP1awvy8Nm4EdSQZvvV6F983W
         Hl7R5v0wFPL9XNiGUp2uaVw4yqAsWdQo9WY3PMdbvvIMpYQPlTRDgKAqGvD+WMPwEl6T
         L4t/MMMJ3cenUzTxgg3UchsbyVrI9BWSTK4dUjfcB00zfzpZeR7DDzB4LcMguSkf6Gl7
         Rz/8FIUs1de7mUmEX4wiAJ6Roi2gU+vH0Ls+oaojATzowU/vAsXozk7XffzptXsJaXAl
         aOCA==
X-Forwarded-Encrypted: i=1; AJvYcCXLUW1CVCE9lUXIwOdLP/SAQc184kxKP+upfw9Gh9VWuW7PI2tGsobfFCm2d4QVVGdlB8zEL2tFz5FE+W1X54dDujdGbU8LSYs=
X-Gm-Message-State: AOJu0YwriB4/o9gBsrlOS+aGdiIQPxB7YDfrA4OS/k1IGt/Xt9rwixLR
	eKetbJebRo+4+uvogNMfgZ8eLd9d+MJ5WXjagaCd8R4KUh9hH4TLhy6v7GBo3SAhwwFTF5SpKS4
	vG8pL+w==
X-Google-Smtp-Source: AGHT+IH6Ru84Y1JINkyMiMz429dIETDgmR1EukqPW4m0GygJCCf7tcPwQm4ZpYDkaBQZfHZp3zYaOQ==
X-Received: by 2002:a17:906:7fcb:b0:a58:bb3e:937b with SMTP id r11-20020a1709067fcb00b00a58bb3e937bmr2700337ejs.63.1714773176166;
        Fri, 03 May 2024 14:52:56 -0700 (PDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id nc8-20020a1709071c0800b00a5974b95c31sm1774136ejc.103.2024.05.03.14.52.55
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 May 2024 14:52:55 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a599af16934so17660866b.1
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 14:52:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUu8r+ezkoRqPauA2grJXixf5U02F0ewx8qqE9GS8X4FBOLPtM+Vpe+ut3VDYZO2qQFC+Dbt6ivlnMLTVZZ3ElEeP2P5D22S70=
X-Received: by 2002:a17:906:eca8:b0:a58:c639:9518 with SMTP id
 qh8-20020a170906eca800b00a58c6399518mr2622517ejb.76.1714773175036; Fri, 03
 May 2024 14:52:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202405031110.6F47982593@keescook> <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV> <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240503214531.GB2118490@ZenIV>
In-Reply-To: <20240503214531.GB2118490@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 May 2024 14:52:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgC+QpveKCJpeqsaORu7htoNNKA8mp+d9mvJEXmSKjhbw@mail.gmail.com>
Message-ID: <CAHk-=wgC+QpveKCJpeqsaORu7htoNNKA8mp+d9mvJEXmSKjhbw@mail.gmail.com>
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

On Fri, 3 May 2024 at 14:45, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> How do you get through eventpoll_release_file() while someone
> has entered ep_item_poll()?

Doesn't matter.

Look, it's enough that the file count has gone down to zero. You may
not even have gotten to eventpoll_release_file() yet - the important
part is that you're on your *way* to it.

That means that the file will be released - and it means that you have
violated all the refcounting rules for poll().

So I think you're barking up the wrong tree.

                  Linus

