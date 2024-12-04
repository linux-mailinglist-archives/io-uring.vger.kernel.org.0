Return-Path: <io-uring+bounces-5231-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 919CC9E42B4
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 19:00:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51DA32868B8
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 18:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03BB5217F58;
	Wed,  4 Dec 2024 17:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N0qLsgi0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6973E217F54
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 17:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733333700; cv=none; b=uQL/MoDiXuALWCDt2nWLE3h/Qr+WwKbjv354/eSgikEaeddJKqhiThNBRui1M2C79+Dh9QkSLzLmwFjAMfskUqRkTbPEU1YXHLNQTMipjbBOFmo8079jJfIGStKWzcSOjl5KdoQ25d0yL6xCpCxhjwYMeiIIOI2d/ga7wFwIDKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733333700; c=relaxed/simple;
	bh=dlihfuBp2YdmTwP/7phGNNouqWJWqjGdJ8qALliZeIY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oOh4bxHwNqYLoFVXMTaBhbc8nNm/56G8YXwKFO0mWYotbPtYzGDUdot6f+qKI2Ia5g+PFjHvDUmcj0IktqADJeVfE9P19jGqtzmd1u/mHQJSPE8dcQG8Aimkco8fcB9KrCDergT6AorwrLAvf9He6lFqg3WM2Pzojg5+uOWYVSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N0qLsgi0; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2ee74291415so46857a91.3
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 09:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733333699; x=1733938499; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dlihfuBp2YdmTwP/7phGNNouqWJWqjGdJ8qALliZeIY=;
        b=N0qLsgi0Q029EI7QXQLQ8NRybU6WOfneD5UhNYsy0RKlgZ+1XxqRBrtI8QXkqj3IlC
         smbMCVRFzD83cJjbOGFnUivl7R9ux0hZ5d3jnVo9hRE3hEd24CVzQlTqPxbfBGO1TfnU
         r8NVRn7uhschJCYVp6DyvytBCU1ab/kf6PmdBaNmZdgGhxbRzXy6k72ti1d99oWH6/qz
         Nt/E2QOiR3EBkO29GU3IBFt5HRasqMFD8czBUor7siB+AnV5d56l+AOgTNATKDI/1Mse
         Wn9LGzTo1/rwliCCfoH1zhgsoPWSZbAbd84hMJco4wcsM4x01R8drzyOTXmDELQP0YCW
         xalw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733333699; x=1733938499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dlihfuBp2YdmTwP/7phGNNouqWJWqjGdJ8qALliZeIY=;
        b=K8Was0oD1xLML4KoFQ8LRUAaMvSsCHEjqnvrx4YH/kI08omQKUPIYGSj7vftfavqFF
         PaShCGxdOI+JdbOFg9G4kJWl96EgUWw6i9I2nFtb2R6b+KWRAp/N/AdtpBG2VT56ayq7
         b7LnBl8m2S9KWqz2n5/jyak/Ymp4CCAeS+mo46bAYkfF0MTQ6TrbAk43ps6lsvkmcjRA
         xXSeX/chbKHZOFg8Ylnx1Eg27gsos8YSiZC8fhIRGyLKFmCLbNsThjsu9qqwNAwz9iXg
         ZDVbdj68B8A5xYK9IIX0W4UmdjDNFiQ9QXxxcHnVfh+bkusQO/SHqF40hbgB8Na2vJwX
         EztA==
X-Forwarded-Encrypted: i=1; AJvYcCVz1vGHEwtFDUmtPwbuFjfRAPdsgcShsXugrfEhqS1ZsmON6F8hxffutfZaPJRK5PxCs4/kRCAQNg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw22OG6s1n2FSK3w0JorGQSOZXGH5K9pZV10M5Ts3yAJ9GEYM8K
	OcZos0ZANwsFP0v5KxPmtRNv89jOC23wcKfgQpy6lfEAGIvF6KRS76tGAsTt8xJzdZatAm7rGvA
	92jEe4PJjMaQsogeuG0PjAlTnod11NiZqvVz3
X-Gm-Gg: ASbGncuHXDtLRy5C8YBBw54WTH2uVVUWnIHaQKiuvZpwopZOBylIpB6BdOu6w547sf1
	egxzKavV4qsvbU+5O0FvV97IlWlZ1XgHaz3ri3ws7Api4pkyAQCoYIxrJNYWnKQ==
X-Google-Smtp-Source: AGHT+IHRzC2VYGKnvKMJTo0lMqyoXM3QWGse1yWJvWexAnmSFEoDo0s4BM0ZVzAdXpM8Wl3GTl7EyEL7ik5RHAsQBfQ=
X-Received: by 2002:a17:90b:3b4c:b0:2ee:bc7b:9237 with SMTP id
 98e67ed59e1d1-2ef1cf04837mr7054839a91.27.1733333698535; Wed, 04 Dec 2024
 09:34:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67253504.050a0220.3c8d68.08e1.GAE@google.com> <67272d83.050a0220.35b515.0198.GAE@google.com>
 <1ce3a220-7f68-4a68-a76c-b37fdf9bfc70@kernel.dk> <CANp29Y5U3oMc3jYkxmnfd_9YYvWK3TwUhAbhA111k57AYRLd+A@mail.gmail.com>
 <9e8ccb61-e77a-4354-a848-81242625658c@kernel.dk>
In-Reply-To: <9e8ccb61-e77a-4354-a848-81242625658c@kernel.dk>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 4 Dec 2024 18:34:47 +0100
Message-ID: <CANp29Y4dWOk3Hk2NJbQSnSE-XoQfCv5vM1FM_FWr5Xbv+d3yFg@mail.gmail.com>
Subject: Re: [syzbot] [io-uring?] general protection fault in io_sqe_buffer_register
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+05c0f12a4d43d656817e@syzkaller.appspotmail.com>, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 6:14=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/4/24 10:11 AM, Aleksandr Nogikh wrote:
> > Hi Jens,
> >
> > Just in case:
> >
> > Syzbot reported this commit as the result of the cause (bug origin)
> > bisection, not as the commit after which the problem was gone. So
> > (unless it actually is a fixing commit) reporting it back via #syz fix
> > is not correct.
>
> The commit got fixed, and hence there isn't a good way to convey this
> to syzbot as far as I can tell. Just marking the updated one as the
> fixer seems to be the best/closest option.
>
> Other option is to mark it as invalid, but that also doesn't seem right.
>
> I'm fine doing whatever to get issues like this closed, but it's not
> an uncommon thing to have a buggy commit that's not upstream yet be
> fixed up and hence not have the issue anymore.

I see. You are right, thanks for the explanation!

There's indeed no better way to convey this at the moment. I've filed
https://github.com/google/syzkaller/issues/5567 to discuss what can be
done.

--=20
Aleksandr

>
> --
> Jens Axboe
>
> --

