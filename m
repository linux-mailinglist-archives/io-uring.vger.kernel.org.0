Return-Path: <io-uring+bounces-9623-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 81C36B4706C
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 16:28:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 312F54E02DA
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 14:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BABEA1DE4C4;
	Sat,  6 Sep 2025 14:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="IuT0rEO/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7F01F5F6
	for <io-uring@vger.kernel.org>; Sat,  6 Sep 2025 14:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757168910; cv=none; b=ifbeQs3bZz3AWy0i7SUFPth0UzqDbZgfx+5b6rCgRuqzzzjXqPYw2vWpTIULJkcYY1FugB1wBskHr9KP6bLMTo54MBxF28+5qsMohi2exAcnCw/1z57seCcWPnVh9tzN5G2EGRXuF6j9qmZrYsLplhV78CDs4h0KqwJacuEIuz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757168910; c=relaxed/simple;
	bh=cvVBltQY58106jEKVaMVmlSsZ0cpbuUvV04KfTiNAlQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h6RBTyOx+LIqjPtRm3EJflx3uYGkuiBi+8LHNBR1zJ8YbsSMQkijIu+mgHZPhPhN0qQeQe/fJxtyHMyy4yhnVI+VOkapzhvOkeBg17Al7w9TQr8JCJEDwdSiiflF+uACLQX9WvAEi1wDt9BY18EaiBZI4oIBE9TVcvnV3Pide6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=IuT0rEO/; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7722c88fc5fso2757242b3a.2
        for <io-uring@vger.kernel.org>; Sat, 06 Sep 2025 07:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1757168908; x=1757773708; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JRPXYbXfQcwsmqT/wZayRjzM8sUGrjVUjaV4P6FgvK8=;
        b=IuT0rEO/UKijQpWlCNMILjxVAdHPoY1VglOsgwg2umcU9sfbrNZ20k2MnaEpJeVMFR
         NMsAnAGi6gqZMKm8A1ckKQSqx75SBFhXS5h+XdF5xsaj2tnAQa/ACLbrX293GzrVHkox
         bckW5HnAVhIkySH6Le0uxPD/xsodvWaXhMx44=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757168908; x=1757773708;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JRPXYbXfQcwsmqT/wZayRjzM8sUGrjVUjaV4P6FgvK8=;
        b=Jpyvjwb8DU+KXYjmaj0OHJwk2iGfiOLNAtn2hsaF2HFqNlH1W1ts1yuTN9TqM5NH85
         W7HB0A2tAbKjbi+TxIsrD5mMgbnXkJHQ8ZyoWNeoGWixKmMcCnmmhA2VPddlM15LCgeI
         o5dW1zo3Xu+LJHUg4NI+VrEUNMAUvZxOFK2mUWSoxPyuxozGX5gS/of4nivfjCUefT+m
         PEKqcDNDSQClzAmLIBM6qIlEp3Rv4ZdfY9u2hgTOgpHfEVmIhACgPue7eJre+m9bWjO7
         aDL1c9AgP3oDNWi9uK0uGSdUduHIBm2K6vMrFppioiZVnNAq0/IYTsonkN+VICWFjT2G
         Q4cA==
X-Forwarded-Encrypted: i=1; AJvYcCWkOpL/o4wtzy03Ty9hPCM1OZ7cp/KUtPIr27W1lFPU+uX9/eyCwCdBBeihrgGd+2acE7kkWVukqg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9tsSXveMnhnG/4KhXDNTZy/ICRhyDDIQxbQlkdGMWpv4UyTmX
	Mf/ZD74NTTNXcfUkY58yYy+NLZobP5QChAF5aezWrd7RXDgIHaAuiOv7w6aKmcQ85x/UfPQguPF
	9yVaz9Qo=
X-Gm-Gg: ASbGncvbmNsOl8Q0uEDnJ1OAYB8iCYDrLgfj/wfKkgGXOp9NwAWLyfLaXzzsVcChVF5
	UMzOmtKSMYx7DwmcHoSlUIu5n6nCsseRPr5cGhwgPawnHaf+kSHUX4Tul1gGgMs0dMcJq40RBxM
	KE0jAgydFUDRZ/AVYR1104/DdJsq7y0VVE2GtODEGAjvWNlp/BHDRlSjvH8Pwsmxm48gZpykHzH
	pdsr8mHvUxgTXN5FHuFV/Q8y0FqsBirz+2tejZCjd8k/NRGGpxuLCf0kznFiRnHte+MP2NlC8l8
	d+sFGjGChKGGmykyUKoX0X8E0xAi2xqQr53JVfCZacwdv8LrEwznCT5G0Ob2fs2I1H0OHFyRBpr
	CSyulKrRDwma8QyVH7oU8fRoUQq1TOoTMF0E4AQbsYwDIx4QjQCV8ydKpaCMpJFQX/RpdMiJiwd
	0=
X-Google-Smtp-Source: AGHT+IEKlnZ2gDV6Cf7vzckuTfU2tI51NA7SFZfkMS2CWcnbSL2aSdEew+cS5mnzCI48399CQ9rm8g==
X-Received: by 2002:a05:6a20:2589:b0:249:9c7a:7702 with SMTP id adf61e73a8af0-253444130a3mr3464477637.36.1757168907718;
        Sat, 06 Sep 2025 07:28:27 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4fa1a29cedsm9763439a12.46.2025.09.06.07.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Sep 2025 07:28:27 -0700 (PDT)
Date: Sat, 6 Sep 2025 23:28:17 +0900
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
Message-ID: <aLxFAamglufhUvq0@sidongui-MacBookPro.local>
References: <20250822125555.8620-1-sidong.yang@furiosa.ai>
 <20250822125555.8620-3-sidong.yang@furiosa.ai>
 <CADUfDZpsePAbEON_90frzrPCPBt-a=1sW2Q=i8BGS=+tZhudFA@mail.gmail.com>
 <aLbFiChBnTNLBAyV@sidongui-MacBookPro.local>
 <CADUfDZpPvj3R7kzWC9bQVV0iuCBOnKsNUFn=B3ivf7De5wCB8g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZpPvj3R7kzWC9bQVV0iuCBOnKsNUFn=B3ivf7De5wCB8g@mail.gmail.com>

On Tue, Sep 02, 2025 at 08:31:00AM -0700, Caleb Sander Mateos wrote:
> On Tue, Sep 2, 2025 at 3:23 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >
> > On Mon, Sep 01, 2025 at 05:34:28PM -0700, Caleb Sander Mateos wrote:
> > > On Fri, Aug 22, 2025 at 5:56 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > > >
> > > > The pdu field in io_uring_cmd may contain stale data when a request
> > > > object is recycled from the slab cache. Accessing uninitialized or
> > > > garbage memory can lead to undefined behavior in users of the pdu.
> > > >
> > > > Ensure the pdu buffer is cleared during io_uring_cmd_prep() so that
> > > > each command starts from a well-defined state. This avoids exposing
> > > > uninitialized memory and prevents potential misinterpretation of data
> > > > from previous requests.
> > > >
> > > > No functional change is intended other than guaranteeing that pdu is
> > > > always zero-initialized before use.
> > > >
> > > > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > > > ---
> > > >  io_uring/uring_cmd.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > > > index 053bac89b6c0..2492525d4e43 100644
> > > > --- a/io_uring/uring_cmd.c
> > > > +++ b/io_uring/uring_cmd.c
> > > > @@ -203,6 +203,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> > > >         if (!ac)
> > > >                 return -ENOMEM;
> > > >         ioucmd->sqe = sqe;
> > > > +       memset(&ioucmd->pdu, 0, sizeof(ioucmd->pdu));
> > >
> > > Adding this overhead to every existing uring_cmd() implementation is
> > > unfortunate. Could we instead track the initialized/uninitialized
> > > state by using different types on the Rust side? The io_uring_cmd
> > > could start as an IoUringCmd, where the PDU field is MaybeUninit,
> > > write_pdu<T>() could return a new IoUringCmdPdu<T> that guarantees the
> > > PDU has been initialized.
> >
> > I've found a flag IORING_URING_CMD_REISSUE that we could initialize
> > the pdu. In uring_cmd callback, we can fill zero when it's not reissued.
> > But I don't know that we could call T::default() in miscdevice. If we
> > make IoUringCmdPdu<T>, MiscDevice also should be MiscDevice<T>.
> >
> > How about assign a byte in pdu for checking initialized? In uring_cmd(),
> > We could set a byte flag that it's not initialized. And we could return
> > error that it's not initialized in read_pdu().
> 
> Could we do the zero-initialization (or T::default()) in
> MiscdeviceVTable::uring_cmd() if the IORING_URING_CMD_REISSUE flag
> isn't set (i.e. on the initial issue)? That way, we avoid any
> performance penalty for the existing C uring_cmd() implementations.
> I'm not quite sure what you mean by "assign a byte in pdu for checking
> initialized".

Sure, we could fill zero when it's the first time uring_cmd called with
checking the flag. I would remove this commit for next version. I also
suggests that we would provide the method that read_pdu() and write_pdu().
In read_pdu() I want to check write_pdu() is called before. So along the
20 bytes for pdu, maybe we could use a bytes for the flag that pdu is
initialized?

But maybe I would introduce a new struct that has Pin<&mut IoUringCmd> and
issue_flags. How about some additional field for pdu is initialized like below?

struct IoUringCmdArgs {
  ioucmd: Pin<&mut IoUringCmd>,
  issue_flags: u32,
  pdu_initialized: bool,
}

> 
> Best,
> Caleb

