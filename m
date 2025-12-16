Return-Path: <io-uring+bounces-11056-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D72ACC096F
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:18:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DFF3B302262E
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 02:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CBFF25C838;
	Tue, 16 Dec 2025 02:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="bRDzwOHK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E107F2D838A
	for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 02:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765851510; cv=none; b=YKn0QTtXRww5uRcb543fPqNJl+IYrb1/3cMN7qNeLmx+u42vnY1xLRFmIJ2L9JJReEMX4Nk6osv3e85NI9hCQU+M8YqaWF6XN5CW0mJie3rridadXbdeNpSBHtbtKP08ZRHOgd24kxLBKUA4HNNU0N+3HnPPE10To/3MYcARsR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765851510; c=relaxed/simple;
	bh=87IUC5B+EmxqpWOYohTUfn4MeP9hxTM96c9slLvqD+M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V54/DO0Njb2NVq4HtJ+8rYCCbTaUF81FZQo2DBKWpHBWpab7BNIx6Frm7LyYwJfe/FT03lvyMX8kujuwn+w3jIEjaxcOP2KIeqpk/QZVMmLOsAcKDymEn1rIplXj1tBOiHIrMQpF8ygslDOGk8JXhzGjksNzuuE95Zl3xk19S0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=bRDzwOHK; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7f216280242so1230206b3a.1
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 18:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1765851508; x=1766456308; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gRjpFIpOzRZ2BiN5IiVV5goUIm9mEGJRGqt04cQHEgw=;
        b=bRDzwOHKf+ddNhsIaSzQ+GVimdKudyYrZ6qE9F6bTCB6zCFsplK7eGPK8aPLqbGsBm
         qyBUCyBYT7CNuVtCISJbBZoJECVSkk9VcJ3FMicEfoG3NYs2ZgWoXgSR9KE3sF0+uoAn
         91+qMg0e1z/llL18hp634ePTGGivr/aT3drbwVJOKAxXE0+RBbQZxanYJf44YtBJRMaX
         1Gk55GB71x/bDfIkT7ZN+wWRPDEUmy04x2jovo99d1j9YNRYxqewExSj9xo/TRRn8jyM
         TicxeTNWsh5u5sTWZDC9w1BB8MaVJmUP6qKhVxXQlsykmiVJTJx3nZPvRpJbz34L8o3c
         YPGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765851508; x=1766456308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gRjpFIpOzRZ2BiN5IiVV5goUIm9mEGJRGqt04cQHEgw=;
        b=tFVYJP2JKp3g8eHG6TkBqtunlYB+55+JbOGHI8wdI6bmWDvyyOkbtuFVzGKx6Djx3+
         5v1EdzMVV3x1wSTOLrLPhuqdywXcNtckwinBZkfu8K1+axFOdnSbDMjtn/6pp1vXe2T2
         KPl7CoLSj8kRNHfVCG7+DxE3k6RofCtYbIayaPOCjw6Zd/lGiNRRXAzCftnYKBBOpDs4
         k2XtPvbtl/WIb4fU5n4RExABdU42LSKX5Us4MxbPMATdP8YijT5/d0n9HInB+bO079Lz
         aVH22H1ZQibrqlVdrQlUn1j5JmATkK2zWSW9ofTRJzaKCvuBLS7v7KrAD3H+7qjwQTZP
         0LTA==
X-Forwarded-Encrypted: i=1; AJvYcCVbPO9x65OjBS4aR/AKjT0YHu01J09uQuZc0TN52gw0i/uNtby8CgqH3eWYD69E06YkoZwIePfSBg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2fb87wPb/ekQP4zjwJZeFPnx/OObHhr5Ytk9cbDiSgSPRIsCu
	rSWuZZodP5+3B6KUfCMqXjAjeUJrY+5QyVszsaHCmZjqhC4seL4JelFheIM17ZKfPP0LKAtPWG4
	gLErlQOKm8oquBScvWkUIilGlbVt4MVfzaglFoFII
X-Gm-Gg: AY/fxX48+k2JKyqECNBciJkKABy59Beyf0I9rN5rjlWp9gdC+euctEgQwlW55WlHi8G
	qMzVaMIXBgCKljnzQIlljJaL6fvRCqbHAPjGYRLQheXqUMyqPESWtBkXjJF5IWCAMn/Nqd9MlPj
	045xdfZAja7gvRHzRO+TgDHo6Aa/oFDwcrzh4BbF6lCYplvdpA7sNXUJ9MyrkBcuyo5dKhkgEFZ
	yfwLjkuhPNKnjCEoboCb6s5e6ffWXShlNHt1SzJ3xFTmGebgfWonlOiRg61EByPLK2Zjg4=
X-Google-Smtp-Source: AGHT+IFN0n0Z1ONhFG1K1mRun3mzBO+ovfpXWV0d4D3ZLmKRc7ZoVjis/NHaXg57M0CIY4CVmn7rWzSq94ROZvDyD9s=
X-Received: by 2002:a17:902:f786:b0:295:55f:8ebb with SMTP id
 d9443c01a7336-29f24e9fb9dmr117523255ad.21.1765851508255; Mon, 15 Dec 2025
 18:18:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251129170142.150639-1-viro@zeniv.linux.org.uk> <20251129170142.150639-19-viro@zeniv.linux.org.uk>
In-Reply-To: <20251129170142.150639-19-viro@zeniv.linux.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 15 Dec 2025 21:18:16 -0500
X-Gm-Features: AQt7F2qp5TJTQsl_u69giqHIzesppxwKZN0S7rImDG0A9kbJZcYWwHrgoa-C3BU
Message-ID: <CAHC9VhQ4Mh=UYYFw83RYEG6VfcNpx9QSXdQbBgY0WG0Rb7a_9Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 18/18] struct filename ->refcnt doesn't need to be atomic
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 29, 2025 at 12:01=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
>
> ... or visible outside of audit, really.  Note that references
> held in delayed_filename always have refcount 1, and from the
> moment of complete_getname() or equivalent point in getname...()
> there won't be any references to struct filename instance left
> in places visible to other threads.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/namei.c         | 10 +++++-----
>  include/linux/fs.h |  8 +-------
>  kernel/auditsc.c   |  6 ++++++
>  3 files changed, 12 insertions(+), 12 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com

