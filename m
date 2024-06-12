Return-Path: <io-uring+bounces-2174-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A3028904CEB
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 09:40:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 298DF1F23846
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 07:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA376F513;
	Wed, 12 Jun 2024 07:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="m1DrhvWa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA2616B729
	for <io-uring@vger.kernel.org>; Wed, 12 Jun 2024 07:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718178012; cv=none; b=RECpqjFx0wQBZGlNgzb/snyADVG0QGiv58WdGWUcM0HdJx7O+g7CLikzLI04eFl7esmqF2gBpu/AqX84ZzAM+Jpm4VKu4KN1HSE+Zq3GeUYTbz77x2qNnipdKhSF6P5sX8/PTLwWOWSBZXyzUQxT3TqwgzRotgkXESy8SEEJSvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718178012; c=relaxed/simple;
	bh=SHhjjQf+XCiZG5//svZCudcWMjc3JF2y5+r1zKFDWBQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a3ZbGcJTuWVF1Km1Ce/OFUb/v2F7aCPCkgJD5yHLuJ6CB6kO+GkeIoexBrdEUJXD7f63gw1yLtYAi64pbt8esBOSXJkNMfZFfXWElNH/3SQVdKq9q2h6JnDfp6m14vZXo/EKhqT4OmKRIoT7O8DNpha6Wnbpco1FuMWNfCNHDbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=m1DrhvWa; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a6f13dddf7eso426852166b.0
        for <io-uring@vger.kernel.org>; Wed, 12 Jun 2024 00:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1718178008; x=1718782808; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+QSosQqQLy64+Tlgv470e85em5LRwQwoSTGn3Q1iK/g=;
        b=m1DrhvWa+IGqpiaPH9Kq7EKcFQA9Q5HPDdfYlJt4DqGLLFqECaXmjJcx0K7gbkyRje
         ShnXJxm0G/VzssZygfRcnJT6SpKwOGjEZwAcllar8BcNvKgUwdkak/Y9MeLdiYMaHBXZ
         ZJGmisH4LnzMDlIG5y+o5LDFvRB4C3240ot9I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718178008; x=1718782808;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+QSosQqQLy64+Tlgv470e85em5LRwQwoSTGn3Q1iK/g=;
        b=HSuSiE2WKPaeDR6Kdoxu4pNmrxzwlLwlMh/sbEkQtsTvspqVbNph9sQ30H08UAtYVK
         aXr7VO9leFd0lFO1xG3IkrNtnougY12dtyU6BefkScCR6iuJmfl+/Asd1oA6Dmfp+rby
         XF40gFUjh3Xvxiz1uE/fw7ddlhVyfm8fUcyj8FerHDeNT5+PdmKJw5ERJJmqkeZeCrH4
         1KlRtcjtExrarWrUeCCEpqxO2o0GxYKKFQqh075sNdaKzoAdqMDgW2JtgOTnnWp75Cu+
         MWYCWF9EmoPPsesLXvmfPDTat8AKEX0h40MHXD5Sodm2tCXUVqGRyHFWs2B211uQLLvE
         OkdQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYIkZ2JoV1tsaZYk51ImPYh5B+O/fnM/W4J50TwEgU5jQ0vEoQW0ipzMHVRYivREjk4b4bRJooStye5l4LHPv791ovGHHBvZQ=
X-Gm-Message-State: AOJu0YzgLj0xWW1lr6SXI7SxxeS4TS/1hnaUgexND47n2aoVk6UTUa4q
	yKwin+nD7o+vyPl/o9RC97uvFIZDeQ4hL+xwiOqeWC2p6nzcJno0NGeut5kmc/n8dQdiu6kMtfk
	83x2L9Dm4od2lZMIXMGvg8tt5fw54SeWNcCVyaQ==
X-Google-Smtp-Source: AGHT+IHBlOirImqV0ywldrD6heA5rRT/yeHkVra4yo2c9+kHD7C+vJadXIrbCeB1ZgdxilgFkjhV/mtFePl8gIIao/8=
X-Received: by 2002:a17:906:2712:b0:a6f:1c81:e220 with SMTP id
 a640c23a62f3a-a6f47f52ec1mr60243766b.13.1718178008049; Wed, 12 Jun 2024
 00:40:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
 <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm> <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
 <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
In-Reply-To: <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 12 Jun 2024 09:39:56 +0200
Message-ID: <CAJfpegsq06UZSPCDB=0Q3OPoH+c3is4A_d2oFven3Ebou8XPOw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Bernd Schubert <bschubert@ddn.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org, 
	Kent Overstreet <kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Tue, 11 Jun 2024 at 19:37, Bernd Schubert <bernd.schubert@fastmail.fm> wrote:

> > So I don't think it matters to performance whether there's a combined
> > WRITEV + READV (or COMMIT + FETCH) op or separate ops.
>
> This has to be performance proven and is no means what I'm seeing. How
> should io-uring improve performance if you have the same number of
> system calls?

The ops can be queued together and submitted together.  Two separate
(but possibly linked) ops should result in exactly the same number of
syscalls as a single combined op.

> Also, if you are using IORING_OP_READV/IORING_OP_WRITEV, nothing would
> change in fuse kernel? I.e. IOs would go via fuse_dev_read()?
> I.e. we would not have encoded in the request which queue it belongs to?

The original idea was to use the cloned /dev/fuse fd to sort requests
into separate queues.  That was only half finished: the input queue is
currently shared by all clones, but once a request is read by the
server from a particular clone it is put into a separate processing
queue.   Adding separate input queues to each clone should also be
possible.

I'm not saying this is definitely the direction we should be taking,
but it's something to consider.

> > The advantage of separate ops is more flexibility and less complexity
> > (do only one thing in an op)
>
> Did you look at patch 12/19? It just does
> fuse_uring_req_end_and_get_next(). That part isn't complex, imho.

That function name indicates that this is too complex: it is doing two
independent things (ending one request and fetching the next).

Fine if it's a valid optimization, but I'm saying that it likely isn't.

> > The major difference between your idea of a fuse_uring and the
> > io_uring seems to be that you place not only the request on the shared
> > buffer, but the data as well.   I don't think this is a good idea,
> > since it will often incur one more memory copy.  Otherwise the idea
> > itself seems sound.
>
> Coud you explain what you mean with "one more memory copy"?

If the filesystem is providing the result of a READ request as a
pointer to a buffer (which can be the case with fuse_reply_data()),
then that buffer will need to be copied to the shared buffer, and from
the shared buffer to the read destination.

That first copy is unnecessary if the kernel receives the pointer to
the userspace buffer and copies the data directly to the destination.

> > So I think either better integration with io_uring is needed with
> > support for "reverse submission" or a new interface.
>
> Well, that is exactly what IORING_OP_URING_CMD is for, afaik. And
> ublk_drv  also works exactly that way. I had pointed it out before,
> initially I had considered to write a reverse io-uring myself and then
> exactly at that time ublk came up.

I'm just looking for answers why this architecture is the best.  Maybe
it is, but I find it too complex and can't explain why it's going to
perform better than a much simpler single ring model.

> The interface of that 'reverse io' to io-uring is really simple.
>
> 1) Userspace sends a IORING_OP_URING_CMD SQE
> 2) That CMD gets handled/queued by struct file_operations::uring_cmd /
> fuse_uring_cmd(). fuse_uring_cmd() returns -EIOCBQUEUED and queues the
> request
> 3) When fuse client has data to complete the request, it calls
> io_uring_cmd_done() and fuse server receives a CQE with the fuse request.
>
> Personally I don't see anything twisted here, one just needs to
> understand that IORING_OP_URING_CMD was written for that reverse order.

That's just my gut feeling.   fuse/dev_uring.c is 1233 in this RFC.
And that's just the queuing.

> (There came up a light twisting when io-uring introduced issue_flags -
> that is part of discussion of patch 19/19 with Jens in the series. Jens
> suggested to work on io-uring improvements once the main series is
> merged. I.e. patch 19/19 will be dropped in RFCv3 and I'm going to ask
> Jens for help once the other parts are merged. Right now that easy to
> work around by always submitting with an io-uring task).
>
> Also, that simplicity is the reason why I'm hesitating a bit to work on
> Kents new ring, as io-uring already has all what we need and with a
> rather simple interface.

I'm in favor of using io_uring, if possible.

I'm also in favor of a single shared buffer (ring) if possible.  Using
cloned fd + plain READV / WRITEV ops is one possibility.

But I'm not opposed to IORING_OP_URING_CMD either.   Btw, fuse reply
could be inlined in the majority of cases into that 80 byte free space
in the sqe.  Also might consider an extended cqe mode, where short
fuse request could be inlined as well (e.g. IORING_SETUP_CQE128 -> 112
byte payload).

> To be honest, I wonder how you worked around scheduler issues on waking
> up the application thread. Did you core bind application threads as well
> (I mean besides fuse server threads)? We now have this (unexported)
> wake_on_current_cpu. Last year that still wasn't working perfectly well
> and  Hillf Danton has suggested the 'seesaw' approach. And with that the
> scheduler was working very well. You could get the same with application
> core binding, but with 512 CPUs that is certainly not done manually
> anymore. Did you use a script to bind application threads or did you
> core bind from within the application?

Probably, I don't remember anymore.

Thanks,
Miklos

