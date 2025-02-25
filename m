Return-Path: <io-uring+bounces-6765-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F8C7A45079
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 23:48:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7950716F377
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 22:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC46F230D0E;
	Tue, 25 Feb 2025 22:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eKgUBuTe"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5412309B1
	for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 22:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740523691; cv=none; b=TLstNA6ExlWYsAKbnQblvnAknr4/7De/WN7qL5gGx5yn3UHCV9Pt6DCLx0r1eZUoGFjI6N2Z9iCV/rVQRkq/G/lyAnKoGyB8XkAS5wyB8cD+JtL2wpgLm4U4OLwKU05yC82c8I8LMUudxz2XJsYokQ75MagUEixSwuikj8xH4Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740523691; c=relaxed/simple;
	bh=qzC+lGL7EH++UOq8QNHetUErviEIDwfxlbcdJesnEwg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eQ+oiKfo9mA6PXr/UXxSjX8A7sE6mob5dizCcrBhOZNVy+SCjFfU8F2470S4MnjG5GA9IyKWtbeG1o5hhNrkOcM2y+RvzXtM209P2XGQN/Kp65dvd0yk636to7Qj4d4/oTlOBiTtbD/FHBbT9rA6UKqN7NH0gFaI4uWQpum1Nq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eKgUBuTe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740523688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jaBUGZoK9+1So7KWTYrLf+zCW6V1rwpWUPmzcKAgRM8=;
	b=eKgUBuTe8K/YqG/swrTAjBPB7kfJZ2sgoQGrwh2lLudfPU/RYFe4uYyRoLfNXPcssHnpbT
	H5i8i7YzhjIMjssJHpu2jFtb23UB1hkqEVYeKvyw+iuarZhofXmLiNk1sGt3+9pR7iGGQz
	vfY+du8jhOk1IKl3xSbgkCOki6+xyIY=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-oc2Sw7yJMiKtM5BLC-aAhA-1; Tue, 25 Feb 2025 17:48:07 -0500
X-MC-Unique: oc2Sw7yJMiKtM5BLC-aAhA-1
X-Mimecast-MFC-AGG-ID: oc2Sw7yJMiKtM5BLC-aAhA_1740523686
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-52093440b07so1538586e0c.2
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 14:48:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740523686; x=1741128486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jaBUGZoK9+1So7KWTYrLf+zCW6V1rwpWUPmzcKAgRM8=;
        b=BOfBFEywCDz59ljQShFVclnnA/JxWnukDFEURNdJIUVpbo6HwZb4MDo/5MsgkVaAQ0
         VDG4P/MfHAEBxMnScvRUnirii6cefbFCYNDZf27JdsK52xp5+2DiTYtUM1fe4BBh4clT
         VSRxGuExwTFdpf6DwMPGRIXO9spikYHor6/sta0m7TJ+J4dQEqYUFkvmNPMfA4MpULmF
         fXQFbL6+Qc8AmlGquW6XKlKk/lc0zUNg+xXXZp4g8cMPnTF1UVqGoHwhgdkupEG9Wnn6
         dtTptFbI/QgwXNRdGcLwAJEqglBjwXirFvA4dtH3r+2zMs0czQtIxF44Z24LEwNwm3SP
         nbbg==
X-Forwarded-Encrypted: i=1; AJvYcCVpw1CT+QF5S/keqB2OOzixL5WdgT7l4IBQtx7TEaGml2oal6o2FjH22QP+IMPq7KhGVfYAibBTBQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwxhZ4r9eYGpTnPLlBNgqbNkbzjW32Kse39fDk8M/E5GLifyDZM
	BaE2XbXRuxXQFKqQJTVmqjR0JxjDqwmQCV076LZjOH9RmSO53XRrWd+/ZMHqCITK3EGCD0lAcl2
	Bw4LST4NnK3b1Eq4YavMWNNwjqdRepkbwNHmI2rlVplu1cRNRvZVEtaf6DIRf8oD0bs9PrEWNPa
	Hb8NOaF53nVyzS3WsZd5VN2G1DpH/JXbk=
X-Gm-Gg: ASbGnctYLm2Fhvs2sOEy0/nm01PhXU7P4CtCXdxBQ6BXiVa46JtRX4Fi5Y97q+Kkf0Y
	BZ1TV1u2Q/qIJQqlLmkgwCNobARpb8ryFB2r5B/plRIcQ/B4ValKr7klfK522WMr7djHgEj7U+w
	==
X-Received: by 2002:a05:6102:508a:b0:4bb:dc3c:1b49 with SMTP id ada2fe7eead31-4c01e3030aemr662882137.22.1740523686732;
        Tue, 25 Feb 2025 14:48:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFhzohP7hrmisIZ9DUcY5fYiv3GQVUmjgxILxbMm9KgVtGWNa6Qp8fKJpRYI6dfcb5oS1RZ+tWx8qH96oDNcDg=
X-Received: by 2002:a05:6102:508a:b0:4bb:dc3c:1b49 with SMTP id
 ada2fe7eead31-4c01e3030aemr662865137.22.1740523686411; Tue, 25 Feb 2025
 14:48:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250224213116.3509093-1-kbusch@meta.com> <20250224213116.3509093-8-kbusch@meta.com>
 <Z72P_nnZD9i-ya-1@fedora> <Z73-rhNw3zgvUuZr@kbusch-mbp>
In-Reply-To: <Z73-rhNw3zgvUuZr@kbusch-mbp>
From: Ming Lei <ming.lei@redhat.com>
Date: Wed, 26 Feb 2025 06:47:54 +0800
X-Gm-Features: AQ5f1JrH0V1OM2iSAYX6FGpKLPOiKMppIW2w-3AO8cm6eSMwxLQgJoSa4g0JnHE
Message-ID: <CAFj5m9KA1QUS-gYTRdpQRV4vMBcBE_7_t22YDrCh21ixgQMcxQ@mail.gmail.com>
Subject: Re: [PATCHv5 07/11] io_uring: add support for kernel registered bvecs
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, asml.silence@gmail.com, axboe@kernel.dk, 
	linux-block@vger.kernel.org, io-uring@vger.kernel.org, bernd@bsbernd.com, 
	csander@purestorage.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2025 at 1:32=E2=80=AFAM Keith Busch <kbusch@kernel.org> wro=
te:
>
> On Tue, Feb 25, 2025 at 05:40:14PM +0800, Ming Lei wrote:
> > On Mon, Feb 24, 2025 at 01:31:12PM -0800, Keith Busch wrote:
> > > +
> > > +   if (op_is_write(req_op(rq)))
> > > +           imu->perm =3D IO_IMU_WRITEABLE;
> > > +   else
> > > +           imu->perm =3D IO_IMU_READABLE;
> >
> > Looks the above is wrong, if request is for write op, the buffer
> > should be readable & !writeable.
> >
> > IO_IMU_WRITEABLE is supposed to mean the buffer is writeable, isn't it?
>
> In the setup I used here, IMU_WRITEABLE means this can be used in a
> write command. You can write from this buffer, not to it.

But IMU represents a buffer, and the buffer could be used for other
OPs in future,
instead of write command only. Here it is more readable to mark the buffer
readable or writable.

I'd suggest not introducing the confusion from the beginning.

Thanks,


