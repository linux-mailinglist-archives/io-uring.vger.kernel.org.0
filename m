Return-Path: <io-uring+bounces-8780-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8A0B0DECB
	for <lists+io-uring@lfdr.de>; Tue, 22 Jul 2025 16:36:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE51A18878FB
	for <lists+io-uring@lfdr.de>; Tue, 22 Jul 2025 14:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DF8E2EA499;
	Tue, 22 Jul 2025 14:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="BEtMaDSW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E618245012
	for <io-uring@vger.kernel.org>; Tue, 22 Jul 2025 14:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753194809; cv=none; b=H7N3nJRpcGd6rnxaM6Y1ocrWehCoegv89ECf/vkZlQOfz43SkRNTD4bdRwIm2ZNZAIwLLxmitdmnk+XZIDljKxQ5Geh0tomuj2x+cUJw11q6K/+EZhO+ZyAPDw5kzZ8jqnpxDwjXaAFxfVXyq6/l5HA2GP1gn/0hTRrOKRYuHxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753194809; c=relaxed/simple;
	bh=fv7AJ047lftjYrvdeOh9awJwbVijUB3ZG9yyk9jPZz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G6XhlJF1hGGozGdXghuupV2X45tTq3bG69dFYKMRt4Qm7uFCwi9w/sGVxohxh2LS02K+XMtRwwi/HZjrH9avq2hV3gDbKuQ7Jw1nxXddNmbf4fgBzERwiSQzGBypYrPy5zFqK2Zbpgxz4V+SXmJCaBGFdtfhNqqn4WFQ1vSnn34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=BEtMaDSW; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-75ab31c426dso2998541b3a.3
        for <io-uring@vger.kernel.org>; Tue, 22 Jul 2025 07:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1753194808; x=1753799608; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M7fGZKT3ggFMUdBYkzEIRO465LQFB1F7egGN40OaEMk=;
        b=BEtMaDSWRnEErqlT7JMROzTBNDaniQfYpuvkkaLWdVuc8S/uZcH9ZMvOvWoCBql8j5
         O0VLmGKvWpCx70qaln764Y2bXuHS7ZlA8U1kNnT421YQ7RFZojot5ittvwVjW5NsUMsr
         ZKoy93gkMtr+TpKupcYAdB8wQtVIAcY/VnVWA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753194808; x=1753799608;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M7fGZKT3ggFMUdBYkzEIRO465LQFB1F7egGN40OaEMk=;
        b=BpseolcoW1iWl0aZ5p7l2APEzX36ZYm9KmArlEkTY9b1A6KlfXDCk7xhosHpbmgM0O
         v7bZ3wE5sTQyrbFV5LFNHUuoUfsTZYYjxtDCHUpG7/tfHoXQQJxk3xfcC5YnbkHB3pZQ
         eCuZp0MJVB0di0UqdgPtQTOSbhiq4/+UMUjZ276ldqdwjGQyHZYE5qRlew+uKveJrtNM
         EHcL1KEujWbYAAz/K58fGARgdCDHl19f2+6ginwyrNjY1djXyjEPNck9GIoyEfnEOOLF
         iRqfrZpp5nj7Ic1yYzGgAj5VaIeGggvGJ+D0uXv6lK6s9GI4FBz2HGxNQuXyyAlaUB6+
         X0tw==
X-Forwarded-Encrypted: i=1; AJvYcCWR2YfpyrrKbu6ckv5thV56Z1GP873A8yNpLjU1ToX3Kar00mX/1sUjjz2n82cSMUWJ17eHnRQBOA==@vger.kernel.org
X-Gm-Message-State: AOJu0YysNfW0+vUEpcjXih2MR5xu+xNsBfz7fEXnni5sPia7YaXyxfVu
	ZRYsP18UXY1kQuLRP4S39F7hrfsMj7EjAiDDProp/D6shzipYfoWAV88zg80KfD5M54=
X-Gm-Gg: ASbGncscl+xlMlnUVkqNMOfXJu2uRCCu5XLTblLNUEX/T9eZ/sqb1ULimrBrUb48d6c
	rNHE+PEU8Fmz+m89At87CHYMLdF9SQ+moy3NbB8nouxmUFJcPJwjdnzIwtkKNkwVuhzQmRPdWvi
	qKOXL/nuHpttdAS+aEDUlaeBzF7lrtIidbqhoGzyewtdU0md1M/CEQGB4xPNb39D7OlH7oJPc4Q
	zVr42pU9m7MAyHDpkHm/n3wyjdKJECvOgZBvg2hznijU2d2y67aYCP8YJEbBlT8sYqzljfM8GrN
	oqyTaVaYpvNIpi/u5h1fPKBnFP09qg8QsaXAFN8RMa4C/ouQZChBVY1fxOmOhUWEvPx+WCzPE5L
	iVn4KAaiQjzIQ780zU+svDXo5O4NSPktcsgPrdldVejDfXbGlDC4lxDwECTFetK+fS1SjKg==
X-Google-Smtp-Source: AGHT+IFWFM/ezEnw+gUjX3lXlEi7sZO9lCCQrwj/IgdE0HPpAyeUUj5d+7M3EkDn2sTRy7/yVS+0Jg==
X-Received: by 2002:a05:6300:6199:b0:232:9550:128f with SMTP id adf61e73a8af0-23813237521mr37395363637.36.1753194807942;
        Tue, 22 Jul 2025 07:33:27 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-759c84e2008sm7230211b3a.30.2025.07.22.07.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 07:33:27 -0700 (PDT)
Date: Tue, 22 Jul 2025 23:33:21 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Benno Lossin <lossin@kernel.org>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 2/4] rust: io_uring: introduce rust abstraction for
 io-uring cmd
Message-ID: <aH-hMYr4u95x03H0@sidongui-MacBookPro.local>
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
 <20250719143358.22363-3-sidong.yang@furiosa.ai>
 <CADUfDZoBrnDpnTOxiDq6pBkctJ3NDJq7Wcqm2pUu_ooqMy8yyw@mail.gmail.com>
 <aH3OsKD6l18pLG92@sidongui-MacBookPro.local>
 <CADUfDZrLKrf6evTXQ03cJ1W4kj0gxsF9Bopu+i2SjkBObXKnMA@mail.gmail.com>
 <DBHUR00PDVO2.16BCDQ94SF29J@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DBHUR00PDVO2.16BCDQ94SF29J@kernel.org>

On Mon, Jul 21, 2025 at 05:52:41PM +0200, Benno Lossin wrote:
> On Mon Jul 21, 2025 at 5:04 PM CEST, Caleb Sander Mateos wrote:
> > On Mon, Jul 21, 2025 at 1:23 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >> On Sun, Jul 20, 2025 at 03:10:28PM -0400, Caleb Sander Mateos wrote:
> >> > On Sat, Jul 19, 2025 at 10:34 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >> > > +    }
> >> > > +
> >> > > +    // Called by consumers of io_uring_cmd, if they originally returned -EIOCBQUEUED upon receiving the command
> >> > > +    #[inline]
> >> > > +    pub fn done(self, ret: isize, res2: u64, issue_flags: u32) {
> >> >
> >> > I don't think it's safe to move io_uring_cmd. io_uring_cmd_done(), for
> >> > example, calls cmd_to_io_kiocb() to turn struct io_uring_cmd *ioucmd
> >> > into struct io_kiocb *req via a pointer cast. And struct io_kiocb's
> >> > definitely need to be pinned in memory. For example,
> >> > io_req_normal_work_add() inserts the struct io_kiocb into a linked
> >> > list. Probably some sort of pinning is necessary for IoUringCmd.
> >>
> >> Understood, Normally the users wouldn't create IoUringCmd than use borrowed cmd
> >> in uring_cmd() callback. How about change to &mut self and also uring_cmd provides
> >> &mut IoUringCmd for arg.
> >
> > I'm still a little worried about exposing &mut IoUringCmd without
> > pinning. It would allow swapping the fields of two IoUringCmd's (and
> > therefore struct io_uring_cmd's), for example. If a struct
> > io_uring_cmd belongs to a struct io_kiocb linked into task_list,
> > swapping it with another struct io_uring_cmd would result in
> > io_uring_cmd_work() being invoked on the wrong struct io_uring_cmd.
> > Maybe it would be okay if IoUringCmd had an invariant that the struct
> > io_uring_cmd is not on the task work list. But I would feel safer with
> > using Pin<&mut IoUringCmd>. I don't have much experience with Rust in
> > the kernel, though, so I would welcome other opinions.
> 
> Pinning in the kernel isn't much different from userspace. From your
> description of what normally happens with `struct io_uring_cmd`, it
> definitely must be pinned.
> 
> From a quick glance at the patch series, I don't see a way to create a
> `IoUringCmd` by-value, which also means that the `done` function won't
> be callable (also the `fn pdu(&mut self)` function won't be callable,
> since you only ever create a `&IoUringCmd`). I'm not sure if I'm missing
> something, do you plan on further patches in the future?

Sure, this version is full of nonsence. v2 will be better than this.

> 
> How (aside from `from_raw`) are `IoUringCmd` values going to be created
> or exposed to the user?

Nomrally user would gets Pin<&mut IoUringCmd> from MiscDevice::uring_cmd().

Thanks,
Sidong

> 
> ---
> Cheers,
> Benno

