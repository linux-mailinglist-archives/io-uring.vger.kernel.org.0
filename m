Return-Path: <io-uring+bounces-10283-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C05FDC1CCC4
	for <lists+io-uring@lfdr.de>; Wed, 29 Oct 2025 19:37:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33ED63AD438
	for <lists+io-uring@lfdr.de>; Wed, 29 Oct 2025 18:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76D6A3563CE;
	Wed, 29 Oct 2025 18:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VVXa0Pq4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE852FC890
	for <io-uring@vger.kernel.org>; Wed, 29 Oct 2025 18:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761763036; cv=none; b=NcYHmjvbhGak/JUladN/JrbWEjXg9rLfzlL89MQNSPOWclvPcCy7GWL8BpsnOw7dtPomVnD06LL7ijihJLMmPlR1XTnCYm5pJWp7EpUPbpVxkS2AK0PW/Wwwh6/WjQApXXcFiiJ7FPWpBITeMGVqiLn+2ZAFqsHJc2g93JYBZ1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761763036; c=relaxed/simple;
	bh=rlMqFEqGQ2tp/lupHXdOzRnc8JHYetVtFELaNsuMHMk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wqr+Cm9/RhXk8O99yMrDHGeqe+JLknPws7Q2zJb3ACI1d8L5L1iw2xN1hzRo5iSegopXVzftLtCDoGQ2aa63Ww3cN+U2PvnqRZv8mGckyryw88NnVS2u9X2CQyPPh37qMbfJXyCnu9U39l73QP4LZcuxT9e9bsNo7mQR6pXPqXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VVXa0Pq4; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ecefc585d0so1947741cf.1
        for <io-uring@vger.kernel.org>; Wed, 29 Oct 2025 11:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761763034; x=1762367834; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rlMqFEqGQ2tp/lupHXdOzRnc8JHYetVtFELaNsuMHMk=;
        b=VVXa0Pq4FNOMoec59Dy2OPorEoGGVyXtQO2MSrmpwQBnQj7Xwbh1OjLKS9wAKNdQF+
         v//9XmXfN0DydgPWWeAZKXyQ1EWuyFNTPJQggK1aMHcWqbBuXFzr9S7YKhy4ex+3L5NM
         FaWdK3Jz674cHg/r0uUWr1HDcgWsV1kIA1/9LRCBsfVAxeio/5HxfRqDVogpUiaEnsVB
         Ahg4bhFOH+F/3em+tFSqBYPA9FS8anNohBqU4r7DLcuqe0fprkM5WLYtIsbQhJ6NnAw/
         IhwCWgA5y4PiAjZ0wn6K8hHwl6A1oEIcsYWcoViBZNDLm9XI8mzU1FzSAX0YW8hbMjH3
         EDYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761763034; x=1762367834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rlMqFEqGQ2tp/lupHXdOzRnc8JHYetVtFELaNsuMHMk=;
        b=NCipH9jc6cbj9ZFVSZNl7Hnik6TbkhIDIdt31HynqBs7tI64bx5bV2Rf3UeYvWu34n
         az44qpoh5ATOthZuUsydVOXuI0L7GO72ivJmYVoUMEtQDVK2liZWa/ro0BF+XjoIQHqQ
         AuQTqkFTwtA75ItTRV9rYV7nlcmVXYeezfPdigC+jXBS8sq6vswiLjbrqqt1Ufn45uET
         0eFyE3WZKjiaHpf8vXSwvjfD9/vir7aMePk9fxoLIneK6u0+BmPgAeclVgxgRuWEvAK2
         EUmelVd4RnZADkZwWvlwTtoKZOTeT01ifqj2tHyfCr0ci3pcV4zfAXLKifzxE76PM6QU
         nZaw==
X-Forwarded-Encrypted: i=1; AJvYcCUtRBDokEz2EROay7J7c28COXDgwX8MceViJX3YJfC/9NbVVKMtAWknMbDmghXfo9AA25TDH8vxYg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/WzuHFQfpb9VwenKa3o5B6FwMUatTjzlqFN3gvkUy6J7RW/kQ
	q31qj8vBpf4oMPBpzueZC6+wcITWxK2JrVFAFlxN8vMPgIIpboa0JRKOPpRCrYsLj0SQIpltWyy
	w6RdIW1gP6HZ0/KHX6DyUS0IO9Sk1kgI=
X-Gm-Gg: ASbGncu1eYei/xE18weyDneu8YCKiCJjYcLqRj4MCb7N1j1Z6QyBAbdVurrtYlLEdal
	Zt5hFbiEGzjc1F3CSRKrDFuvMx14Rgix8GizrSaeug758aq5cx5Rgrds/liRlMz8lGKsvp1tKZw
	h3bf06gb03a2jzYtFu6NFOMXHrrZyiHtffYHSniEOSsj8fPIZZyCJlezQAEJ1m99F2C8nVQGNH4
	Jv8Wlp0WulyCBJ6JDm9rMVFI8aNn/NUxQWzNVC6ypQQhRBWN5ofKoowqP1l4ydZ/RCrAozU75Iz
	3/uKlg8IBycVVpM=
X-Google-Smtp-Source: AGHT+IHgIkmc3mkjw1A0X4RdtInXSBpx0/kdi0c/7Nq3j9rg9RxSDfZPvNtlC3pN794suC14mfp8fiuRmWGrZxTUB60=
X-Received: by 2002:a05:622a:28b:b0:4e8:a090:abc1 with SMTP id
 d75a77b69052e-4ed218197admr8590011cf.15.1761763033696; Wed, 29 Oct 2025
 11:37:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-2-joannelkoong@gmail.com> <455fe1cb-bff1-4716-add7-cc4edecc98d2@gmail.com>
In-Reply-To: <455fe1cb-bff1-4716-add7-cc4edecc98d2@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 29 Oct 2025 11:37:02 -0700
X-Gm-Features: AWmQ_bnd9bZ1JJ-CuASC_l_MLN93h-zD3KzdQQLXsQD0Rb0tLIWRTMQs1MotSSQ
Message-ID: <CAJnrk1ZaGkEdWwhR=4nQe4kQOp6KqQQHRoS7GbTRcwnKrR5A3g@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] io_uring/uring_cmd: add io_uring_cmd_import_fixed_full()
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	bschubert@ddn.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	csander@purestorage.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2025 at 7:01=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 10/27/25 22:28, Joanne Koong wrote:
> > Add an API for fetching the registered buffer associated with a
> > io_uring cmd. This is useful for callers who need access to the buffer
> > but do not have prior knowledge of the buffer's user address or length.
>
> Joanne, is it needed because you don't want to pass {offset,size}
> via fuse uapi? It's often more convenient to allocate and register
> one large buffer and let requests to use subchunks. Shouldn't be
> different for performance, but e.g. if you try to overlay it onto
> huge pages it'll be severely overaccounted.
>

Hi Pavel,

Yes, I was thinking this would be a simpler interface than the
userspace caller having to pass in the uaddr and size on every
request. Right now the way it is structured is that userspace
allocates a buffer per request, then registers all those buffers. On
the kernel side when it fetches the buffer, it'll always fetch the
whole buffer (eg offset is 0 and size is the full size).

Do you think it is better to allocate one large buffer and have the
requests use subchunks? My worry with this is that it would lead to
suboptimal cache locality when servers offload handling requests to
separate thread workers. From a code perspective it seems a bit
simpler to have each request have its own buffer, but it wouldn't be
much more complicated to have it all be part of one large buffer.

Right now, we are fetching the bvec iter every time there's a request
because of the possibility that the buffer might have been
unregistered (libfuse will not do this, but some other rogue userspace
program could). If we added a flag to tell io uring that attempts at
unregistration should return -EBUSY, then we could just fetch the bvec
iter once and use that for the lifetime of the server connection
instead of having to fetch it every request, and then when the
connection is aborted, we could unset the flag so that userspace can
then successfully unregister their buffers. Do you think this is a
good idea to have in io-uring? If this is fine to add then I'll add
this to v3.

Thanks,
Joanne

> --
> Pavel Begunkov
>

