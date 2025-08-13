Return-Path: <io-uring+bounces-8949-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 673F6B23D5C
	for <lists+io-uring@lfdr.de>; Wed, 13 Aug 2025 02:54:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98C24685DA5
	for <lists+io-uring@lfdr.de>; Wed, 13 Aug 2025 00:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6ACA12FF69;
	Wed, 13 Aug 2025 00:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="TNtK1W5T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB47341C72
	for <io-uring@vger.kernel.org>; Wed, 13 Aug 2025 00:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755046490; cv=none; b=YxHlt4psW+RWwmpVQH4EyXt1PgXPjRj+DygsrlmF0z1sXFB6Cfu4nNqwTXuWhMOAnHl5mDsnJea1OhYpdoKQnjR44iA+TDW4zpzsNj6tbAekFWegGX4dSrj2OLbE/Xy1tKLM3o/+y1nke8KlQB/0TXw9hQyvJKJJaZ+qO6/Adgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755046490; c=relaxed/simple;
	bh=ZAK0iu2nam4TRzSPQ+RT8lQPoKAFlyGFpIFTAuhS/Js=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HCuYOlIanFPvaRUYVQe2iKbyAjleQgskyx5QMPFKl8dqpwRIcRQm0ntBXmlCV3lfJwOwMmESJ4jaCudNrp9kA3bm8KDKV/ZzepSjD4Gv69PVxxZUuPYneI+/IKoVKWBYFiSTwL00DkB9j/yAYuv/Fc46BMC7oGLfWYPtgZI1BMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=TNtK1W5T; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b421b70f986so4435648a12.1
        for <io-uring@vger.kernel.org>; Tue, 12 Aug 2025 17:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1755046488; x=1755651288; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6NpFBcxoc04uyrK8/s01LPPrR4PakN3UQlJaijfjW20=;
        b=TNtK1W5TlTn7jtoFNeZaElo4Vz8Q+ZqaQg/AAemruxmBgdGWDXrjHwSt76FvkKhih0
         8Y5XMVf4aLsB9QMPr0PjaDPqpqV+TaazjZcDD8DE557XG1eWpNxLRRzVqggLit2oFT6p
         tjuVhjWF8yVUicW76Zm9CWvvMQdXStPubPF+U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755046488; x=1755651288;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6NpFBcxoc04uyrK8/s01LPPrR4PakN3UQlJaijfjW20=;
        b=sZOfATQAhEA0jClBCtDCj6MWwMYe2y48HEE+6Q4h7qaLafwqoPqO/1FlhWs7/rB64g
         lIHLTK9IyY1FK4Li9QsbZHFOKt8isPr7gZn8aU2QxFnhWuJ7KS03oF2R3Kqq1cEUsfDQ
         55OfYm0i2BB3usnTv6T0gesdl+39xs0dI+rXhprnAW5nAN+bwc293S1FH7g7eEhEEbag
         9K8/H+0g6iEuYzzBXLA9d02NQvmuM8n3II26RZLr3dL36pgIgY39pu4hCaHEZ2A8Pxqj
         MPGrwT5AR70EhuwPBIkIaGh+91wxNsOrTLjaDLsGME1luEMJHzDYmDd3tpPU6n5cYeD4
         cEwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvaG7xnPXK7c15waougnErvjecTiTYMLEfgg6CGCYn7nWZicDW3R5nLAbETXm9cT9gLetCdk/PMg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJdlTCFCj3+EFZ7jZtiOcykCE6rZJm7OVmLFixV4jdwMghnUir
	TuXCHcanhcqiCJ4u+dXuJV5DSrfhQn8fZFPrMIG9d95dIbRcFnK7TMJ0PyfiU0Hsnu4=
X-Gm-Gg: ASbGncuxOEfj/fytV+IZraq18gOGtR/MBc0tqgfAMLHI6rUpOlTVLzARCAY86tGWTBX
	QvrCk4BqsEPdAxPwKy1iPD8BuykTBz5u5u5iKbS/GRxtUDF9BtOXq64Czk7ls/1/Iz2BJwBypQP
	BImI9bAUOKeZtEzgkTV+GVuY6BwnbHRTP086OTYQ0G6DdlQAz9lL4QfacMQnplvqxv5s30T438Z
	q2v7Nemol6dxIt/I84++zApX1fh24WS7ROzEUKo9yjXOhpa6Tges0yVximVIvyXr0vi/UMa4JTX
	xERimi0ASlMP2WOg/ZIIORXJeTn8C2cH7I2Zo9WflH49Vkli5iFh2sOAc8GxpzW9k2/+urpm4d7
	jdC6MjNT/LSPChZw59fF9AIk4wrLP4TIS/UtAgOgyomG7fs1nod6zbnBYFAy8K8qx
X-Google-Smtp-Source: AGHT+IHA/9Hoe2WUXGmM827/WBBWCmDTjLeBDQa+8tvMPHlD5EOr8tpNby6jVzEanoAxA3ONDgWNew==
X-Received: by 2002:a17:902:c94b:b0:243:43a:fa2b with SMTP id d9443c01a7336-2430d299051mr17789945ad.56.1755046488174;
        Tue, 12 Aug 2025 17:54:48 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24309cd3e2bsm15232115ad.62.2025.08.12.17.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 17:54:47 -0700 (PDT)
Date: Wed, 13 Aug 2025 09:54:42 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Benno Lossin <lossin@kernel.org>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction
 for io-uring cmd
Message-ID: <aJviUiNhTwCsMbaX@sidongui-MacBookPro.local>
References: <DBY6DMQYZ2CL.2P0LZO2HF13MJ@kernel.org>
 <aJijj4kiMV9yxOrM@sidongui-MacBookPro.local>
 <81C84BD8-D99C-4103-A280-CFC71DF58E3B@collabora.com>
 <aJiwrcq9nz0mUqKh@sidongui-MacBookPro.local>
 <DBZ0O49ME4BF.2JFHBZQVPJ4TK@kernel.org>
 <aJnjYPAqA6vtn9YH@sidongui-MacBookPro.local>
 <8416C381-A654-41D4-A731-323CEDE58BB1@collabora.com>
 <aJoDTDwkoj50eKBX@sidongui-MacBookPro.local>
 <DC0B7TRVRFMY.29LDRJOU3WJY2@kernel.org>
 <06EA9E60-9BED-4275-9ED3-DA54CF3A8451@collabora.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <06EA9E60-9BED-4275-9ED3-DA54CF3A8451@collabora.com>

On Tue, Aug 12, 2025 at 11:38:51AM -0300, Daniel Almeida wrote:
> 
> 
> > On 12 Aug 2025, at 05:34, Benno Lossin <lossin@kernel.org> wrote:
> > 
> > On Mon Aug 11, 2025 at 4:50 PM CEST, Sidong Yang wrote:
> >> On Mon, Aug 11, 2025 at 09:44:22AM -0300, Daniel Almeida wrote:
> >>>> There is `uring_cmd` callback in `file_operation` at c side. `Pin<&mut IoUringCmd>`
> >>>> would be create in the callback function. But the callback function could be
> >>>> called repeatedly with same `io_uring_cmd` instance as far as I know.
> >>>> 
> >>>> But in c side, there is initialization step `io_uring_cmd_prep()`.
> >>>> How about fill zero pdu in `io_uring_cmd_prep()`? And we could assign a byte
> >>>> as flag in pdu for checking initialized also we should provide 31 bytes except
> >>>> a byte for the flag.
> >>>> 
> >>> 
> >>> That was a follow-up question of mine. Can´t we enforce zero-initialization
> >>> in C to get rid of this MaybeUninit? Uninitialized data is just bad in general.
> >>> 
> >>> Hopefully this can be done as you've described above, but I don't want to over
> >>> extend my opinion on something I know nothing about.
> >> 
> >> I need to add a commit that initialize pdu in prep step in next version. 
> >> I'd like to get a comment from io_uring maintainer Jens. Thanks.
> >> 
> >> If we could initialize (filling zero) in prep step, How about casting issue?
> >> Driver still needs to cast array to its private struct in unsafe?
> > 
> > We still would have the casting issue.
> > 
> > Can't we do the following:
> > 
> > * Add a new associated type to `MiscDevice` called `IoUringPdu` that
> >  has to implement `Default` and have a size of at most 32 bytes.
> > * make `IoUringCmd` generic
> > * make `MiscDevice::uring_cmd` take `Pin<&mut IoUringCmd<Self::IoUringPdu>>`
> > * initialize the private data to be `IoUringPdu::default()` when we
> >  create the `IoUringCmd` object.
> > * provide a `fn pdu(&mut self) -> &mut Pdu` on `IoUringPdu<Pdu>`.
> > 
> > Any thoughts? If we don't want to add a new associated type to
> > `MiscDevice` (because not everyone has to declare the `IoUringCmd`
> > data), I have a small trait dance that we can do to avoid that:
> 
> 
> Benno,
> 
> IIUC, and note that I'm not proficient with io_uring in general:
> 
> I think we have to accept that we will need to parse types from and to byte
> arrays, and that is inherently unsafe. It is no different from what is going on
> in UserSliceReader/UserSliceWriter, and IMHO, we should copy that in as much as
> it makes sense.
> 
> I think that the only difference is that all uAPI types de-facto satisfy all
> the requirements for FromBytes/AsBytes, as we've discussed previously, whereas
> here, drivers have to prove that their types can implement the trait.
> 
> 
> By the way, Sidong, is this byte array shared with userspace? i.e.: is there
> any copy_to/from_user() taking place here?

No. pdu array allocated from kernel. I'll use `core::ptr::copy_nonoverlapping`.

Thanks,
Sidong
> 
> -- Daniel

