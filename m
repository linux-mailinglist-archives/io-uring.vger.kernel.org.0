Return-Path: <io-uring+bounces-4006-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6903A9AF2FD
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 21:54:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BEED1C217B0
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 19:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EE7618BB88;
	Thu, 24 Oct 2024 19:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0SuUErA2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4BF17333D
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 19:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729799660; cv=none; b=R4ABGaV7as5rJ5zVCkOmhRLWkbyZ3Kwxbjd7rQjs6UPmyhXWvD5QfXOeOwOK3Pd4qtwaBsG3sMeyQ/OCU4umYG8dSmmjGQVnO/oZXecXVyKGI/9Ai++yV7AAhYysq7O00LNLadM9JbxIFKcdmnTaABEsp8p7kcziUf6rqTo8oqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729799660; c=relaxed/simple;
	bh=JggJ/7URdu0TC2ehLXRKpdVpHhV92VgsV6WqmIKaO+k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ujJqDD7vxFSpBJFaVLt6BWJfFOPjV/vo14ez1Piw3XxtCXTWK9D4zFtEr2eQZN7uk4/aUiJrkeQn5upciSRO0j3sr9aUgWAqUx4RmkdDmGFiXimMc1rcLbYPBUKWT6usK6XJskAXWf0taaKtuFmMC9G9y05/j3DikOazMt08mBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0SuUErA2; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4315a8cff85so58035e9.0
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 12:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729799655; x=1730404455; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4fj20FV0F8MW4w4N9HS1TGWpU7PTIz/WWuH9hG64MXM=;
        b=0SuUErA2i9qvm0lnUQG4NaUZJQcgqnIwnHpLeRRMBetuRstwschLnhe7VS5TA5q8LZ
         IjHGd3Q19dih60KatE5x+mkTuWHGfCujdk1jRgKw+bySsisjQ2xMNKq2AOWa3p69kzew
         xpRaPF3W67NalNXXsufepn1M2i+oCKNk981rASoMv56ewLxcbhRmMRW8jphK6oiQSahl
         teh8B2i/760XLHHBpxxtncmauYOiFxpqwN6Nb2A1T1Ut4sL1/BAyE8Tvl/zT7ge1fqR7
         qaAsNUVx7pYSYYTpbxUV+TONEaOgqoN1QKQcGQfWgLErN3lncMwij43Y34Gz7nZei7om
         5Uhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729799655; x=1730404455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4fj20FV0F8MW4w4N9HS1TGWpU7PTIz/WWuH9hG64MXM=;
        b=rLyzqBQl83iQjbHqw+0SYkiRenRzXHc0RDSw8Bi56D+4wJ/o2LGzeiw9BvyY4u90uG
         /DP7TL4OGqbxx/o3CLjYj6eayzWZ92bj0d0iXKl15PwuSYhux4ZquTL+wYnebUZ1XAAo
         bXofSd11Ot/uuXQA4Ph2G1A8z93g2h8csqJnaDSWgcsWfEooukUMHN5F1SC7i40Fj71X
         SFmnNLjvZov5X6E+pQw7X8q0ammi/lFZIOk0kNE70p5ppC83yXzpw3CUNTfsYV87Dg5J
         Ez2UZQlssoB5LVq9o0e9NXOLvinT1x6ksJf9SYq+Xl5KHQZNU6eqAtNlH9YZIyYt57TV
         v0lA==
X-Gm-Message-State: AOJu0Ywzi8w10tbi9dWstXueUmlCx2SCVvNOxzzuwULIvDdb0X5udmY+
	/U4/M17P9p/yfvBOPKpirkOalAyBTzKs3PHNkJDQMBonc75004GvA5vwHaQu2j/zbmNqM8g8ao+
	u4xh0LdZl02O9Av/wKRhN/87jiHg8XJQnrfYaXxE+ctp96SsxpHcC
X-Google-Smtp-Source: AGHT+IE1FXEav7wQ1YgNE50EpGpocl/rbt3NFVATV1uaKAr/ZjSS2wbXrWsIJaapaVY9Q6JTRqViIJViRMZUBHSATQU=
X-Received: by 2002:a05:600c:1d92:b0:431:3baa:2508 with SMTP id
 5b1f17b1804b1-431923b033bmr742175e9.3.1729799655008; Thu, 24 Oct 2024
 12:54:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241024170829.1266002-1-axboe@kernel.dk> <20241024170829.1266002-5-axboe@kernel.dk>
 <CAG48ez3kqabFd3F6r8H7eRnwKg7GZj_bRu5CoNAjKgWr9k=GZw@mail.gmail.com> <aaa3a0f3-a4f8-4e99-8143-1f81a5e39604@kernel.dk>
In-Reply-To: <aaa3a0f3-a4f8-4e99-8143-1f81a5e39604@kernel.dk>
From: Jann Horn <jannh@google.com>
Date: Thu, 24 Oct 2024 21:53:36 +0200
Message-ID: <CAG48ez3KJwLr8REE8hPebWtkAF6ybEGQtRnEXYYKKJKbbDYbSg@mail.gmail.com>
Subject: Re: [PATCH 4/4] io_uring/register: add IORING_REGISTER_RESIZE_RINGS
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2024 at 9:50=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
> On 10/24/24 12:13 PM, Jann Horn wrote:
> > On Thu, Oct 24, 2024 at 7:08?PM Jens Axboe <axboe@kernel.dk> wrote:
> >> Add IORING_REGISTER_RESIZE_RINGS, which allows an application to resiz=
e
> >> the existing rings. It takes a struct io_uring_params argument, the sa=
me
> >> one which is used to setup the ring initially, and resizes rings
> >> according to the sizes given.
> > [...]
> >> +        * We'll do the swap. Clear out existing mappings to prevent m=
map
> >> +        * from seeing them, as we'll unmap them. Any attempt to mmap =
existing
> >> +        * rings beyond this point will fail. Not that it could procee=
d at this
> >> +        * point anyway, as we'll hold the mmap_sem until we've done t=
he swap.
> >> +        * Likewise, hold the completion * lock over the duration of t=
he actual
> >> +        * swap.
> >> +        */
> >> +       mmap_write_lock(current->mm);
> >
> > Why does the mmap lock for current->mm suffice here? I see nothing in
> > io_uring_mmap() that limits mmap() to tasks with the same mm_struct.
>
> Ehm does ->mmap() not hold ->mmap_sem already? I was under that
> understanding. Obviously if it doesn't, then yeah this won't be enough.
> Checked, and it does.
>
> Ah I see what you mean now, task with different mm. But how would that
> come about? The io_uring fd is CLOEXEC, and it can't get passed.

Yeah, that's what I meant, tasks with different mm. I think there are
a few ways to get the io_uring fd into a different task, the ones I
can immediately think of:

 - O_CLOEXEC only applies on execve(), fork() should still inherit the fd
 - O_CLOEXEC can be cleared via fcntl()
 - you can use clone() to create two tasks that share FD tables
without sharing an mm

