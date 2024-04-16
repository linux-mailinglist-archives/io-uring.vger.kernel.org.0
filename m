Return-Path: <io-uring+bounces-1579-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5964D8A7208
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 19:15:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAF0E1F21940
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 17:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C34010A22;
	Tue, 16 Apr 2024 17:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="OV7tMwZ5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90B439ADB
	for <io-uring@vger.kernel.org>; Tue, 16 Apr 2024 17:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713287748; cv=none; b=GApmGkECTuwAyJZdzm7vPVoiqe3ScvDtdRzT1SQvfUFl7LHj/Guvf7rnWSF5quinw0Ed/sywk7RlNsVnv1FMkM3JeXesPbgXv+Bbb97BM7ZOoecxQlOpiFo2uFb+R50ieRjCkkDnFCL3DLlvZuEBMPpBLOD3CR4LBAtC8ft//HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713287748; c=relaxed/simple;
	bh=MQT6jyG8Dh6uTqUepq304Iz5DvJoz2C2ZxlSBnDndg0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t0wcBumkFKjwpRdK1XqZgjyTzyNCYtka+jlxrM6+L96XSrke7UBMP9z/Vhysa01QxyNjxsFO/G1y2x+oY6KK9WJ1YmPUCIzTJWe8YXiiqKyDW/UogEkliA0uddM0HT9ocVQXXpa6zw+gzttP6MaNbACBezV+SlbSCoHH+1NJNzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=OV7tMwZ5; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-61ae6c615aaso17368367b3.0
        for <io-uring@vger.kernel.org>; Tue, 16 Apr 2024 10:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1713287745; x=1713892545; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mlIaXljHgUnCCIy4J87+Qg7HO2SoOigLu1PurV4TaO8=;
        b=OV7tMwZ5TU37kE/4F95cw+AS7PgwZv+2WuQeKL+XZD6Ymdm7ETN75G5PeELq8NSA2W
         V1V8oaNxOdlgzdWJk7Fo7hfZZ+B1padTZ8NvrMUeXytnzyL3Uf+CTgey+Lrymh9VfdHO
         /2dvIWDQSngwiZuy4NLxOK9IwvTVb4C3Ao7Z5COz1HfZwhU/SLNZ9IEj7K8Q2VF9xvtR
         CVJCff+eALXkcdP8Cn3CCriXlO9hvYY4zot4XdOakiUxqb0pLTB+z8Sm8jinh+T0+1fk
         1Zv37+7INyK/E2jzITVaXmVEw50rLxwPkcNE9YdZyawHi7u9qmZK56DKnwBwlLocmQKs
         OKng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713287745; x=1713892545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mlIaXljHgUnCCIy4J87+Qg7HO2SoOigLu1PurV4TaO8=;
        b=IR9X2GVPFSNaqFLkss2UKx5gwr+9YhlzXMnVZN78CkiwvJSBpvCha0qhVfNMoLdgXD
         ODpJMwWcQAM9oW0YsjBA0shZD7GHufOtHPvDD8aRDvQuYFsmOEOFenvsqD5XCzdvAfW2
         H26GkYIPvkluHRQtCLMupDE/BYKUaWNJ+la1sBzxGmhiMWI1I+1iUNJwhSxS4FfegGL3
         0/Qgb1yB8/C4Ske2k6farbTVusg3qG+MBspX/g08ttLIp4jm1+OVHZ1u6O/ffYAxaE0l
         uBzwXjKmHiCglRVPVIrEJeF4pvwtkBJWlJeOe36gpfNn9XKSKCNL47h4LYgIT2JHhoQr
         I5tw==
X-Forwarded-Encrypted: i=1; AJvYcCUZcQlUSuk8PTuEns4b1vEY832iQ6+WvWei8jkMfky1kapT/PEeMtVCmSYSK6t3imNCbzk9wtllNLYUa7/114PE6MfxkX5WVFw=
X-Gm-Message-State: AOJu0YxQ0+0c/Hg49l/TZVjTmTnK72g3TbS9o8NSgcBXeg01RRZMJULw
	prE5ZvwuLlrN4s8ovSvJ9AqmKBlmkaAY7aUXFhsa0H5HCOjChreSePSefhSMmq18dcBYaPbrEgp
	ijbK+6yDw7ZhmhPisu7716EOllL9WiyEW6rl7
X-Google-Smtp-Source: AGHT+IHkFm3qzYwxgW3HLSkACstSKMok8vGwu3XPMJJY080YjRz5JwoPZy+04JvEa16/jfPOBvRc8hoChulBAhrzEX4=
X-Received: by 2002:a81:6dd7:0:b0:61b:19e:9532 with SMTP id
 i206-20020a816dd7000000b0061b019e9532mr610255ywc.26.1713287745625; Tue, 16
 Apr 2024 10:15:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0cea7b29-5c31-409a-a8d3-de53c7ce40eb@linux.microsoft.com>
 <CAHC9VhTWbFu8vbapWG5ndt=r-y5SkSSe=AA3YEufreYtjPMrUw@mail.gmail.com> <15cf9f3c-efd7-40ce-8613-a113439c6fb6@gmail.com>
In-Reply-To: <15cf9f3c-efd7-40ce-8613-a113439c6fb6@gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 16 Apr 2024 13:15:34 -0400
Message-ID: <CAHC9VhT2X=19CJUkbt30C026p-+Q9q8g87txb0axeUhOnGaPUA@mail.gmail.com>
Subject: Re: io_uring: worker thread NULL dereference during openat op
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Dan Clash <daclash@linux.microsoft.com>, io-uring@vger.kernel.org, 
	audit@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 16, 2024 at 9:45=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
> On 4/16/24 04:29, Paul Moore wrote:
> > On Mon, Apr 15, 2024 at 7:26=E2=80=AFPM Dan Clash <daclash@linux.micros=
oft.com> wrote:
> >>
> >> Below is a test program that causes multiple io_uring worker threads t=
o
> >> hit a NULL dereference while executing openat ops.

...

> > Thanks for the well documented bug report!
> >
> > That's interesting, it looks like audit_inode() is potentially being
> > passed a filename struct with a NULL name field (filename::name =3D=3D
> > NULL).  Given the IOSQE_ASYNC and what looks like io_uring calling
> > getname() from within the __io_openat_prep() function, I suspect the
> > issue is that we aren't associating the filename information we
> > collect in getname() with the proper audit_context().  In other words,
> > we do the getname() in one context, and then the actual open operation
> > in another, and the audit filename info is lost in the switch.
> >
> > I think this is related to another issue that Jens and I have been
> > discussing relating to connect() and sockaddrs.  We had been hoping
> > that the issue we were seeing with sockaddrs was just a special case
> > with connect, but it doesn't look like that is the case.
> >
> > I'm going to be a bit busy this week with conferences, but given the
> > previous discussions with Jens as well as this new issue, I suspect
> > that we are going to need to do some work to support creation of a
> > thin, or lazily setup, audit_context that we can initialize in the
> > io_uring prep routines for use by getname(), move_addr_to_kernel(),
> > etc., store in the io_kiocb struct, and then fully setup in
> > audit_uring_entry().
>
> I'd prefer not to leak that much into the io_uring's hot path. I
> don't understand specifics of the problem, but let me throw
> some ideas:
>
> 1) Each io_uring request has a reference to the task it was
> submitted from, i.e. req->task, can you use the context from
> the submitter task? E.g.
>
> audit_ctx =3D req->task->audit_context
>
> io_uring explicitly lists all tasks using it, and you can easily
> hook in there and initialise audit so that req->ctx->audit_context
> is always set.

In a few cases, see my previous comments for examples, the work done
in the io_uring prep functions needs to be associated with the work
done in the actual operation, e.g. openat, connect, etc.  The reason
for this is that we need to carry over some bits of state from the
prep portion to the operation itself so that it can be included in the
audit_uring_entry()/_exit() region.  Unfortunately there are a number
of reasons why we can't leverage the submitter's audit_context here,
but most of the reasons essentially come down to the disconnected and
async nature of io_uring operations and the separation between the
prep work and actual operation.

> 2) Can we initialise audit for each io-wq task when we create
> them? We can also try to share audit ctx b/w iowq tasks and
> the task they were created for.

There is still the issue of connecting each individual prep work state
with the associated operation within the audit_uring_entry()/_exit()
region.

--=20
paul-moore.com

