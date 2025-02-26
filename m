Return-Path: <io-uring+bounces-6773-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DCDFA454B2
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 05:52:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A9717A2A67
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 04:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FBEF18DB19;
	Wed, 26 Feb 2025 04:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="RIxDCrbM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C7815B99E
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 04:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740545560; cv=none; b=bwkJQLb8Z9dFgB6wr5DPQfUTphWawxg2yBJObzu63PM0+0ILKqLD9b4+JWML8wdHMPVJF99xwo2/KCzRzjX+BViNPHpiebfEvqAj81cP936R2lQgSVCIscISOovF3oeAVYEZmj/M8LEkM8KuTN3kkkI1Dx5AULc+TAzMDDnajvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740545560; c=relaxed/simple;
	bh=OmfKcIAXaMCIcV/1SJXlDjghgEnw5iTB1qPbh4UoXiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mGHVZq6DVACC5bjh1stmYi/nfdRderFKZwMyJA5duQb+tEFzj9Cmc681YsNx0cdbp/kRY3stHAimVKhxQ6FXlmjCWBXR+5L0rkolAvsd9Tk4a6fjGjk3qBQaOHceV8EYxNQMTDnyYnG48Ry/6z5SefSuQalD4Ir8cn9f+T6V8vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=RIxDCrbM; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2fc0bd358ccso12586293a91.2
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 20:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1740545558; x=1741150358; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kRY67v9dQslVh/+ZppBDHnsBMteDEDnqoVjoXMai1aA=;
        b=RIxDCrbM99rty5fjz+w724MEeZDQktDtJWmx6V9eIz2SdYfPh0M+JysEBBLf/pdkua
         mTJ2tTmAXcQzrq/VundPtwJNxDL4VxVzMecCNd9aQR9NDA+V+kOgj1gGXNhc5H2lEALx
         NBtLNVkIfSYp84Vqza7BpcesDxyRu5FT117cUP9RYm9liVnl2VbKC6Bq0n9w0ANoJp+p
         0uuXpmBqFlCvL4rChL+9/vcnNF854+INbKdg8iSFsmK5J2MAbYk64SdFznN70LRX31wt
         2I3+8ouQKiyJoLh5ZXGq42Na30XNvHerIzrEeK1Eyn8X0fTwTcd4QBVSYHkEjd6mIICn
         HWZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740545558; x=1741150358;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kRY67v9dQslVh/+ZppBDHnsBMteDEDnqoVjoXMai1aA=;
        b=ek1AKJpfxIvlRR12fZweLwnwBYj+gzLIUnWl/KUszOl9+KDYSCwNanenebTh4f2ikE
         MgemGYNCnFJyNxt1oDsa/OXyA2i1BRPD6P/c398ld/+JS4As0vbukgRuI8X5PJPgAOMx
         YoQGgqbN842ppcO9OVgQ7VP6DD0GORnKxUxd+bZz1z2dM1qm5mbVGZYKJxm2P6AAMOx0
         oK64jIYOtvCZDLcxUUor79SPeG4V9Clm/F4oni0x1XwAb79wjPeehjryQXc99idU4ee8
         jGHEdX9f4/iVO2YsBO7x5MJxFq+t+l+oNCA5pvtF+MvliG4ZzVZcaYrHqt77pGcncPBS
         kk6A==
X-Gm-Message-State: AOJu0YycuvEnur5EUSQTYcQTgmMAGHC+b+7Ezy0xqlkMzVnJbrGvr2rK
	30+nUz0iPXxIBmEFSne3/+LXeOLMz85ngTnCnryWSaZbmhZR1h1r28eXyyMwTfU=
X-Gm-Gg: ASbGnctqjldY0zXPgMM6evIt1fDgZQojJvT1voqnmGSTHgHfPOmWycSGXN5p8fkWGvS
	/Sqh+WiXIp7qzzO6WeJGpst1xIbLElTbMOSjuPs8I0GiCrmqnqTLZdDzdj5YKyxk1y1ZPTxvk3G
	rOWN2M5SntVVYxehGUqzRwuspLnPJ3ooDKAtATMA+SWKb9a3gN8QhzDgSmCuu7a/XLeIHzXpIFT
	Mw8IArKVxYtN5kZ6Hbdl6l/HXlyzIfv63ShH6DywJrfGQeTBRBwKbuePwNenzAqM/jjqtl91JY+
	yltMgudhTspIXgC/Tc2xMFI8kNM27hIlml0DYN2quKUk8dm0+/dIeYjq01/GCaHIWcS3w+ZYcAs
	q7w==
X-Google-Smtp-Source: AGHT+IEKkYTV+HlV6GSN1kPh9Q2+3D2op5mHnHlKQYTUWJMxMwtJjAzeHEOVmGEAdo1mJMcC5Oq4EQ==
X-Received: by 2002:a05:6a21:10e:b0:1ee:d860:61eb with SMTP id adf61e73a8af0-1f0fc89a19dmr10136147637.39.1740545557911;
        Tue, 25 Feb 2025 20:52:37 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7347a6b8a82sm2440416b3a.6.2025.02.25.20.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 20:52:37 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tn9PO-000000063jC-21Q7;
	Wed, 26 Feb 2025 15:52:34 +1100
Date: Wed, 26 Feb 2025 15:52:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	wu lei <uwydoc@gmail.com>
Subject: Re: [PATCH 1/1] iomap: propagate nowait to block layer
Message-ID: <Z76eEu4vxwFIWKj7@dread.disaster.area>
References: <ca8f7e4efb902ee6500ab5b1fafd67acb3224c45.1740533564.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca8f7e4efb902ee6500ab5b1fafd67acb3224c45.1740533564.git.asml.silence@gmail.com>

On Wed, Feb 26, 2025 at 01:33:58AM +0000, Pavel Begunkov wrote:
> There are reports of high io_uring submission latency for ext4 and xfs,
> which is due to iomap not propagating nowait flag to the block layer
> resulting in waiting for IO during tag allocation.
> 
> Cc: stable@vger.kernel.org
> Link: https://github.com/axboe/liburing/issues/826#issuecomment-2674131870
> Reported-by: wu lei <uwydoc@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/iomap/direct-io.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index b521eb15759e..25c5e87dbd94 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -81,6 +81,9 @@ static void iomap_dio_submit_bio(const struct iomap_iter *iter,
>  		WRITE_ONCE(iocb->private, bio);
>  	}
>  
> +	if (iocb->ki_flags & IOCB_NOWAIT)
> +		bio->bi_opf |= REQ_NOWAIT;

ISTR that this was omitted on purpose because REQ_NOWAIT doesn't
work in the way iomap filesystems expect IO to behave.

I think it has to do with large direct IOs that require multiple
calls to submit_bio(). Each bio that is allocated and submitted
takes a reference to the iomap_dio object, and the iomap_dio is not
completed until that reference count goes to zero.

hence if we have submitted a series of bios in a IOCB_NOWAIT DIO
and then the next bio submission in the DIO triggers a REQ_NOWAIT
condition, that bio is marked with a BLK_STS_AGAIN and completed.
This error is then caught by the iomap dio bio completion function,
recorded in the iomap_dio structure, but because there is still
bios in flight, the iomap_dio ref count does not fall to zero and so
the DIO itself is not completed.

Then submission loops again, sees dio->error is set and aborts
submission. Because this is AIO, and the iomap_dio refcount is
non-zero at this point, __iomap_dio_rw() returns -EIOCBQUEUED.
It does not return the -EAGAIN state that was reported to bio
completion because the overall DIO has not yet been completed
and all the IO completion status gathered.

Hence when the in flight async bios actually complete, they drop the
iomap dio reference count to zero, iomap_dio_complete() is called,
and the BLK_STS_AGAIN error is gathered from the previous submission
failure. This then calls AIO completion, and reports a -EAGAIN error
to the AIO/io_uring completion code.

IOWs, -EAGAIN is *not reported to the IO submitter* that needs
this information to defer and resubmit the IO - it is reported to IO
completion where it is completely useless and, most likely, not in a
context that can resubmit the IO.

Put simply: any code that submits multiple bios (either individually
or as a bio chain) for a single high level IO can not use REQ_NOWAIT
reliably for async IO submission.

We have similar limitations on IO polling (IOCB_HIPRI) in iomap, but
I'm not sure if REQ_NOWAIT can be handled the same way. i.e. only
setting REQ_NOWAIT on the first bio means that the second+ bio can
still block and cause latency issues.

So, yeah, fixing this source of latency is not as simple as just
setting REQ_NOWAIT. I don't know if there is a better solution that
what we currently have, but causing large AIO DIOs to
randomly fail with EAGAIN reported at IO completion (with the likely
result of unexpected data corruption) is far worse behaviour that
occasionally having to deal with a long IO submission latency.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

