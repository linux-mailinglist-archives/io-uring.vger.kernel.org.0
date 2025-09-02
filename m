Return-Path: <io-uring+bounces-9534-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF4C9B3FC72
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 12:29:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51EE57A1494
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 10:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E77872F90D4;
	Tue,  2 Sep 2025 10:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="NnJ2AwpV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B242F8BEE
	for <io-uring@vger.kernel.org>; Tue,  2 Sep 2025 10:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756808592; cv=none; b=kpx4iC+ZzIgvUbsr8Sps4Luq6jpo8y5e0i4xFiL4gdqOqove5jcUe7lVF7Wp49x5L+d0pHiwdfmbqnYrJ7vwaCZJAa07+2tpzpZa1d5aZOYVrCIfsad5XINATltnyGYmdMPMqOg/OrDXV18DymdeuP08fVwCjLl/c4ljQ5MuRxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756808592; c=relaxed/simple;
	bh=ak6o9wfTp5ryXXDPf6XC/P1UWDMbG95VtmT3E3nrYhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZoVvc7S0upg88ACDXEsmBjy3jfcHSl87v8USCdeNbB697cBanLKp/3gJwr/tXeB5GsV0Q6rlKKKhSeUvQ33DK6wyUra4/MSmTmedqu9bAgEf4pphzProIJUUnT8xYBmTBN12LjgI1dVfqX5vsi496hdvH3JROQNS/mJOu/5IDiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=NnJ2AwpV; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b4e84a61055so1516342a12.0
        for <io-uring@vger.kernel.org>; Tue, 02 Sep 2025 03:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1756808590; x=1757413390; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FiTS8gxM3M1BxU9qGDpyd7c4JddJzb5cIrv8kDeiKxU=;
        b=NnJ2AwpVAacprqgWWfpyHRoGiTuDLZQ4hjcTP9xeOhVaq1eYPuSXsBM3uvohyNsVOv
         8FiN2/pICcS06DijmGpYMNy+yq/7E3aMfASCAsNkfnT+vijtwJxr2/n0djHgtBIny/TX
         RPVLZeH08g0qdNLluDlRZLLBibZ2+tILMnEXg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756808590; x=1757413390;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FiTS8gxM3M1BxU9qGDpyd7c4JddJzb5cIrv8kDeiKxU=;
        b=FmmDPkiuex3PWnbT1aGqzoZZ4q4291WDCUGYNl1VNcBzYUkzlwP3VPQgECg0RQFCp+
         AXQ/KOiSSu3CJh1t4s3aJ3upSfUkbyMH/zLu3qLDe3bc7eQXipWMpKATE7zEcv5gtlG9
         xVfdZHU5P3ofO3sb51luXmJf0lUB4efjBZoY3/anw93L6hXLHgAHGKsBiNTWRGQrbocw
         bRyO1V/LM3qoq5fJibBVJBv9N2Mfg1RN9IQNoHCdRvXDOTnYwXFMClStgReEJa95NWsa
         W7uFUttqPiJa7H+7pVoP7lQSNRnGyHZIxgBfjf1VC/WCy2aMfA30NutCANZnTDpTG0dr
         Gpow==
X-Forwarded-Encrypted: i=1; AJvYcCUAUDMECYApvnHQfGHsj7FyUT9sV260qV2g2uC+2Rb6NVBu/b8BUJJkAk4JK7nuhFbl23oZcm09fg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyidavAc3921eWbQF+QMnGy9mZ3lpDufxxfRZv9SLrvFYXfSVpQ
	HKHESa68NbicjYTVQCZMUpWOgIGdDwWUZ/9AwV24QfEoIykF1oCh8qX9biOWqs81ty8=
X-Gm-Gg: ASbGncuaLY1og7E/2R5qLJ+aC+6wTBMLa537/Oimnx2+m4jLMwo+mb35cL/abx586G5
	S7PsftNWpmE0a+CzTeaSRuZTDA6f9ir7et/pDdeysnW5V3SBDqaYEFjBpBt+FpCIN7epqheXLll
	67TLzG5khxXKQ+hqYvTbdALyyihMylwpi60U2+3qCNZkKbn/SsYOgP/LPcgF7jhk7+uhMSRLlau
	FvMltbqYNSBu9BwBkiHallnPi/LA3wfABwQkP9raaTk7VeQ4rA8p6Iu4gqq5c1o04h3SRkR1SEV
	NEBq8rPatNWcW5CBGOaug7XVJAWaBQ5173J/7+Y8Cs9n9jnm1N/kJAp2sq3+lw/xS1Fh0R7+E7i
	69HwpfQzzqCX5EQqhqc5oSW5uh9QCmUE9ZRdOuLZ8h3mLb74r+aIb3KLOe3NZHEcO
X-Google-Smtp-Source: AGHT+IGWCmV4r/pIo/9Wk0+jYQ9MaFKAPcMCdaaijBHwrZWR32/Er3eKPO5sjeX9rGf22Y8ZIdV76Q==
X-Received: by 2002:a17:90b:3d48:b0:321:cf49:2c04 with SMTP id 98e67ed59e1d1-32815433803mr14753274a91.9.1756808590452;
        Tue, 02 Sep 2025 03:23:10 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3274572be3bsm12098423a91.2.2025.09.02.03.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 03:23:09 -0700 (PDT)
Date: Tue, 2 Sep 2025 19:23:04 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v3 2/5] io_uring/cmd: zero-init pdu in
 io_uring_cmd_prep() to avoid UB
Message-ID: <aLbFiChBnTNLBAyV@sidongui-MacBookPro.local>
References: <20250822125555.8620-1-sidong.yang@furiosa.ai>
 <20250822125555.8620-3-sidong.yang@furiosa.ai>
 <CADUfDZpsePAbEON_90frzrPCPBt-a=1sW2Q=i8BGS=+tZhudFA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZpsePAbEON_90frzrPCPBt-a=1sW2Q=i8BGS=+tZhudFA@mail.gmail.com>

On Mon, Sep 01, 2025 at 05:34:28PM -0700, Caleb Sander Mateos wrote:
> On Fri, Aug 22, 2025 at 5:56 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >
> > The pdu field in io_uring_cmd may contain stale data when a request
> > object is recycled from the slab cache. Accessing uninitialized or
> > garbage memory can lead to undefined behavior in users of the pdu.
> >
> > Ensure the pdu buffer is cleared during io_uring_cmd_prep() so that
> > each command starts from a well-defined state. This avoids exposing
> > uninitialized memory and prevents potential misinterpretation of data
> > from previous requests.
> >
> > No functional change is intended other than guaranteeing that pdu is
> > always zero-initialized before use.
> >
> > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > ---
> >  io_uring/uring_cmd.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > index 053bac89b6c0..2492525d4e43 100644
> > --- a/io_uring/uring_cmd.c
> > +++ b/io_uring/uring_cmd.c
> > @@ -203,6 +203,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> >         if (!ac)
> >                 return -ENOMEM;
> >         ioucmd->sqe = sqe;
> > +       memset(&ioucmd->pdu, 0, sizeof(ioucmd->pdu));
> 
> Adding this overhead to every existing uring_cmd() implementation is
> unfortunate. Could we instead track the initialized/uninitialized
> state by using different types on the Rust side? The io_uring_cmd
> could start as an IoUringCmd, where the PDU field is MaybeUninit,
> write_pdu<T>() could return a new IoUringCmdPdu<T> that guarantees the
> PDU has been initialized.

I've found a flag IORING_URING_CMD_REISSUE that we could initialize
the pdu. In uring_cmd callback, we can fill zero when it's not reissued.
But I don't know that we could call T::default() in miscdevice. If we
make IoUringCmdPdu<T>, MiscDevice also should be MiscDevice<T>.

How about assign a byte in pdu for checking initialized? In uring_cmd(),
We could set a byte flag that it's not initialized. And we could return
error that it's not initialized in read_pdu().

Thanks,
Sidong

> 
> Best,
> Caleb
> 
> >         return 0;
> >  }
> >
> > --
> > 2.43.0
> >

