Return-Path: <io-uring+bounces-9683-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 984CCB504AC
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 19:50:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F628167DC5
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 17:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F15E13148CA;
	Tue,  9 Sep 2025 17:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fU2/lPRK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4E21C863B
	for <io-uring@vger.kernel.org>; Tue,  9 Sep 2025 17:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757440244; cv=none; b=NyMNxLDbosRTDNkD3xo2yDQLoh84MCZL14QFo5FOBDtlvk3eWUfkGRhW/f7BhzkaicRZhYhHUYB8HDpyugpguH3v17UOQc41y4Hbzrt57hNt9ulJgBOlQ3Gc1TdKOeZZjBibsByC3m1QoMT5IT212n2bQ2SinbJbXAtoy2+x7wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757440244; c=relaxed/simple;
	bh=PficCqT+rEbrs5pcKADEXtmjS2T6Jp/bREqqflB7AEk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mlZttI26UgKqupbil3EjCp7rbnk5IeGyGev8NJm4Brr2moAoIroD9AhaFPk8MortNioxmOrZecy46wp0tIcx2qMxUCggKb385zdeAyxTSQqni0VstKZIOzBGvOblJSPHLkJsiOGIHlm9tZVrgbRicQ08o+XlPkwGh4kY4QLexWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fU2/lPRK; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b042cc39551so1060368666b.0
        for <io-uring@vger.kernel.org>; Tue, 09 Sep 2025 10:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1757440240; x=1758045040; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9ayI9RafIVeDOxPGUeZSrHU9WK0+PURxl43r1e78tQ=;
        b=fU2/lPRKy44x/fIuO5Skevrg7DK3uEg0N+CLuY168u5Kx2dDj6jPvd5BM0Is2FWziv
         W+rYQ+36LkFRWDeefm/AxYKLY4mS3P9r61B6Xjh6PXWXOslE9JEgxirS8NoqwEQ+EQKE
         AU9UfKIMiZT4fqRvIWL3V/ybjRRRZ79Oka16U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757440240; x=1758045040;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q9ayI9RafIVeDOxPGUeZSrHU9WK0+PURxl43r1e78tQ=;
        b=k0GI//ooVVTFsGxy++2QjPH2VeqD8vgpf7U8MaahrImX1EqVpjoBhOtBIp2PHdC45v
         GAwZDzwsXbK3bi1FzFPDxm6smOjQbgcZR5iemdhV5u4bArHUpgZokcDb/HTVY8aPU1YU
         EN97xZk8GIoY6AHwCUTRaHVchJiISD1Wmu3ia5H1bGcM+MgoWqIrjEfYDGaRhNXUH+q/
         3QVwnzOVu+YDd6dRBWsSA8nPfqzJO8JkVx74JX2kxPmK2oE5f/ml5PY18L9k5N5xy80C
         1iDk3syzvZpcgW2/d3LR9/MCZB2erRPN76gNkuo3Y9eY6GVNd51lydqC7wPSjUphw77Q
         I65A==
X-Forwarded-Encrypted: i=1; AJvYcCVCUKdnu2aMHZ8XLRyabJm28sKzDnxkzrnkFy7a5FPZruzzIZd1R7tQif1zJpnGSET+0EIUsrIu5w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwaMxD1LeEkryduyNauGtWg/5FX19l5foICWo8gxQkES6DzkHgi
	L/myuMcESfDypSKB33iI0il23nMsFbCjNFEpyhEgvQhbUQ9S+R4Qk4dV8UqsVSslvJYJrOjSysQ
	T7jyoJyY=
X-Gm-Gg: ASbGnctf0JwCxYgET1TIXx4Aw1DdVFwQWd6kc5FQjVOuCqLUPMYaaNi19RcDIH6x63I
	SMJfv7I3rBwUuQdgO6ubGRKJgXJQudrbPAJxkoeLscmwsB+wqt6d9VfBupcbBIRF8DOnTFmXJa3
	hVyZWxOWlxp57dTgvyiDDs6Vb7wCpUjAJCmGXR6dWar+32PFPj9lHKhcTcJu1F0vK2Lj++qZKSZ
	ilr1IMHAcr1Zx5diwu6zdckYlRgEVXvXgUEGX/8T4N1h4JPk/JmVkkVUpJyA1y0nyfx7dfaOi07
	GYUn91p+VsDYeyaLEB1OOGgd8wK8iHzOVi6A3HOoWuNU6HvQ1xZ44klauwY0arxtuXHGhnhc+sx
	2AMIxe78cE5T/Jg3s5PrbFYakwWjeqHlUr9SqRdtUpRgrsUYEfzMMVm5hEerUSCYjimoCmMJT
X-Google-Smtp-Source: AGHT+IF5qYeK0UbUxWYC9IlWRcaPj6pzLyL9bDYToDewGqEYc8L0CUlZiRY9pupXnoDGMdN9J7RKPA==
X-Received: by 2002:a17:907:7ea3:b0:afe:8b53:449c with SMTP id a640c23a62f3a-b04b1687e42mr1032793866b.34.1757440240499;
        Tue, 09 Sep 2025 10:50:40 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b078340e49csm25340066b.98.2025.09.09.10.50.38
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 10:50:38 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b02c719a117so1051751166b.1
        for <io-uring@vger.kernel.org>; Tue, 09 Sep 2025 10:50:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXof1m7/6x4LJV92J3y6xOFd3/47TjZsZBha/ZELYZOc0As1AXuVg1FrqvlYEccjlGBWOe3+FRo8g==@vger.kernel.org
X-Received: by 2002:a17:906:6a1d:b0:b04:4175:62f7 with SMTP id
 a640c23a62f3a-b04b1687ceamr1313344566b.33.1757440237933; Tue, 09 Sep 2025
 10:50:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur> <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
 <5922560.DvuYhMxLoT@rafael.j.wysocki> <20250909071818.15507ee6@kernel.org>
 <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk> <20250909-green-oriole-of-speed-85cd6d@lemur>
 <497c9c10-3309-49b9-8d4f-ff0bc34df4e5@suse.cz> <be98399d-3886-496e-9cf4-5ec909124418@kernel.dk>
 <CAHk-=whP2zoFm+-EmgQ69-00cxM5jgoEGWyAYVQ8bQYFbb2j=Q@mail.gmail.com> <af29e72b-ade6-4549-b264-af31a3128cf1@sirena.org.uk>
In-Reply-To: <af29e72b-ade6-4549-b264-af31a3128cf1@sirena.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Sep 2025 10:50:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiN+8EUoik4UeAJ-HPSU7hczQP+8+_uP3vtAy_=YfJ9PQ@mail.gmail.com>
X-Gm-Features: AS18NWBdgXLEGA42KiP7hBpdYuD5iEhjlm5va7PappHV7NFwUOo9aBTGKqi-tac
Message-ID: <CAHk-=wiN+8EUoik4UeAJ-HPSU7hczQP+8+_uP3vtAy_=YfJ9PQ@mail.gmail.com>
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for 6.17-rc5)
To: Mark Brown <broonie@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Vlastimil Babka <vbabka@suse.cz>, 
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>, Jakub Kicinski <kuba@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, dan.j.williams@intel.com, 
	Caleb Sander Mateos <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>, 
	workflows@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 9 Sept 2025 at 10:08, Mark Brown <broonie@kernel.org> wrote:
>
> That works great for pull requests, but it's not so useful for a random
> patch like 5f9efb6b7667043527d377421af2070cc0aa2ecd

Sure it is.

The one-liner is just different. Use the patch-id instead. See Dan's
email - and the whole long discussion about how lore *ALREADY* has
most of this support.

Yeah, the patch-id command is admittedly a bit more esoteric than just
looking up the merge parent commit.

Using "git rev-parse" is already a bit obscure (although honestly,
it's a really useful command, and I actually do use it somewhat
regularly from the command line).

Using "git patch-id" is definitely in the "write a script for it"
category. I don't think I've ever used it as-is from the command line
as part of a one-liner. It's very much a command that is designed
purely for scripting, the interface is just odd and baroque and
doesn't really make sense for one-liners.

The typical use of patch-id is to generate two *lists* of patch-ids,
then sort them and use the patch-id as a key to find commits that look
the same.

That hopefully explains why the patch-id behavior is so odd, and not
really suited for using directly on the command line.

But my point is that we really have the infrastructure already in
place, and it's better than hardcoding some broken link into commits.

Now, I don't have that commit you mention (I assume it's some recent
commit in your own tree), but I picked a random commit from my
top-of-tree that contains one of those useless links, and look here:

   patchid=$(git diff-tree -p fef7ded169ed7e133612f90a032dc2af1ce19bef
| git patch-id | cut -d' ' -f1)
   firefox http://lore.kernel.org/all/?q=patchid:$patchid

and it's right there. It finds the stable tree backport too, and if
there had been multiple versions of the same patch posted, it would
have found the history of it all too.

Look, I readily admit that I would never write that as a one-liner. In
fact, I got it wrong the first time - I don't use 'cut' often enough,
and I forgot that the default delimeter is 'tab', not space, and got
garbage.

So that 'patch-id' generation line is just crazy line noise. I'm *not*
suggesting you do that.

But this kind of thing is literally what I'm talking about when I say
"maybe we could add a few scripts to support what you are doing".

                 Linus

