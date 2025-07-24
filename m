Return-Path: <io-uring+bounces-8787-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B5EDB10F62
	for <lists+io-uring@lfdr.de>; Thu, 24 Jul 2025 18:05:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B45A17ECDB
	for <lists+io-uring@lfdr.de>; Thu, 24 Jul 2025 16:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 309322DE707;
	Thu, 24 Jul 2025 16:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="RTcZwWK0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC5D1E47AD
	for <io-uring@vger.kernel.org>; Thu, 24 Jul 2025 16:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753373134; cv=none; b=ZdIH4hBTHH9AGDHRWTRJ11Z2Mxk4N8pyAAT5wJt69/9b4dottHLsfv3xWKn4zDHr1BCoft+FPn9mpTmHRGumhDuGfw7VxkDNR6Z7dUYkJCY47/IxmuQ/TXFL/foT0pTlHeBcw6POrsqydu2dHxvJtsgoGB8VnYzwve1Jwv2znJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753373134; c=relaxed/simple;
	bh=0VUcTAlTKI8Uut+YrFJ9JnFPeuS1MyI+ehjEzU6u9SU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BSXLSZIa3X/rsVI4n6uxnUWbWZkCr7eKTpxE4n/8f5aw2Zxkg7YLsfZA4boQkVRytS5R23vQ51L3tyGxTuHkwMb8adZ9pcjxtTbg0vSZRDdaT3x9VKEXoIwukrVXB/f68y9hTjyi0JXyF2ea4zcaP4QEOqU2eEyU9HXD6N/xnR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=RTcZwWK0; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2363616a1a6so9839455ad.3
        for <io-uring@vger.kernel.org>; Thu, 24 Jul 2025 09:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1753373132; x=1753977932; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lPrDAQdM9SEh1PC8EgiE1RAI5sFJN3A+tD++JaDKFmM=;
        b=RTcZwWK08KSyMDVKrfSebH8hoeuDIYUlw5feYTyayOgg2QYqwsMAVXlRuzUHzT0gGa
         zh97hlaBLZd6JXnHS0NFBzg6Rph+ttaux0ByZIzet+MyJ9aSITzw04sUx4UlSlA2FSim
         GofF3h7y09FlPRUGLA0dt1gPfICTmVsgF8I/0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753373132; x=1753977932;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lPrDAQdM9SEh1PC8EgiE1RAI5sFJN3A+tD++JaDKFmM=;
        b=Nx31gZu77E80ETFFfU7D38TipuTquCDO/PqCxCKnKynrk4kqpRCX4YVW4D0u+kBA/g
         g3oMCE2kAt+IT5JooSYpyiKQJu2r0+3p8I86HXbgtawvZ7EFSVF56/c3KuAK2Wki3X9a
         ZsUQ9N/uXWSfsYvrVtH6G/c6GdN9UQ16fN7gDFNojJuNj84IC7+Zs8Ii0Rpsil/5ruln
         CbCD6tks1pf91Axi8LUrzNHVaJAvZHlv8n9WfNZL1tIs4dGLIka6blrDdn89ZnnaiyWF
         Kf2hrgjfJF6rywuUnwtYbFUan/QqLavxM4OJvTu0GchiIy0GluTro1hzRdZXeHuUd4wI
         5Phw==
X-Forwarded-Encrypted: i=1; AJvYcCXOFd3bYlUTZk3qX7WalG2CJYGWHAqGJX5LrIdxysmPzEE+c929pRYYCpGnXgj3Kn6z0Ni2qYP3Uw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyRBh8vKHxycasbIQwSWevAGZ7xSJbofZhFhv7p0qXjaLQg6yqR
	5MM7Xlxbf+7hS7C59sm1tLTC8dsr8XgQg8RJrIIXhGakqhZKxBhiLdgsb8Dq8t9nlZw=
X-Gm-Gg: ASbGnct/QR8Lcls/oRgZ4/MhKfhAfTr2/GquDwP9KiHgrItm3UmKBxwRRASiMv+20xx
	USx0GDekVSh8hPmXnBiNE4Tv0Dwkl23Xjf09wHnYZkTBOX7fkCmZc0sF5yH88qkVYx257ztP3Xy
	USpL6GL8Puo74ZeekLcrPPG0Wzf446p0RmSwceB+tOYpNukXzx1JPkxwCFV9Wj2UbrGpScmOAfP
	aFGCzUNAy0v8EnPPfdkz/PAw2tSfCfNcq7GgSO8vL3d1ybQZKGL2e2OFbJiGyyY7DMtHQCj971O
	NqZ1uBnLOaFJnE+rj3130a0sF5OeslyNFObq4LpIydQO6IZKfN34N/J9vTIX1iYDoaW3AM4QbBj
	lQ7/xwcy91jPGO0p1lwBNTi3fNvD6sW4O3QMsrst2vo4Zv2jyd9yj8HZh
X-Google-Smtp-Source: AGHT+IFOb7VV+hEvYr5JMOJR9pYJzMfOIn04UMDsdukQyZlKdVzKoT94AbgXvi68H4CvfhuA1xh5ag==
X-Received: by 2002:a17:902:d2ca:b0:234:8c64:7885 with SMTP id d9443c01a7336-23f981efd84mr99141955ad.53.1753373132037;
        Thu, 24 Jul 2025 09:05:32 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa475f3d3sm18905165ad.40.2025.07.24.09.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 09:05:31 -0700 (PDT)
Date: Fri, 25 Jul 2025 01:05:10 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Benno Lossin <lossin@kernel.org>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 2/4] rust: io_uring: introduce rust abstraction for
 io-uring cmd
Message-ID: <aIJZthYtM4e7-E4v@sidongui-MacBookPro.local>
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
 <20250719143358.22363-3-sidong.yang@furiosa.ai>
 <CADUfDZoBrnDpnTOxiDq6pBkctJ3NDJq7Wcqm2pUu_ooqMy8yyw@mail.gmail.com>
 <aH3OsKD6l18pLG92@sidongui-MacBookPro.local>
 <CADUfDZrLKrf6evTXQ03cJ1W4kj0gxsF9Bopu+i2SjkBObXKnMA@mail.gmail.com>
 <aH5g-Q_hu6neI5em@sidongui-MacBookPro.local>
 <DBHVI5WDLCY3.33K0F1UAJSHPK@kernel.org>
 <aH-ga6WdOpkbRK3T@sidongui-MacBookPro.local>
 <DBIT6WL2C5MG.2J7OBX6LCVYP7@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DBIT6WL2C5MG.2J7OBX6LCVYP7@kernel.org>

On Tue, Jul 22, 2025 at 08:52:05PM +0200, Benno Lossin wrote:
> On Tue Jul 22, 2025 at 4:30 PM CEST, Sidong Yang wrote:
> > On Mon, Jul 21, 2025 at 06:28:09PM +0200, Benno Lossin wrote:
> >> On Mon Jul 21, 2025 at 5:47 PM CEST, Sidong Yang wrote:
> >> > It's safest to get NonNull from from_raw and it returns
> >> > Pin<&mut IoUringCmd>.
> >> 
> >> I don't think you need `NonNull<T>`.
> >
> > NonNull<T> gurantees that it's not null. It could be also dangling but it's
> > safer than *mut T. Could you tell me why I don't need it?
> 
> Raw pointers have better ergonomics and if you're just passing it back
> into ffi, I don't see the point of using `NonNull`...

Agreed, from_raw() would be called in rust kernel unsafe condition not in safe
driver. Thinking it over, using a raw pointer would be convenient.

> 
> >> > from_raw() name is weird. it should be from_nonnnull()? Also, done()
> >> > would get Pin<&mut Self>.
> >> 
> >> That sounds reasonable.
> >> 
> >> Are you certain that it's an exclusive reference?
> >
> > As far as I know, yes.
> 
> So the `IoUringCmd` is not refcounted and it is also not owned by the
> `done` callee?

Yes, io_uring_cmd would be allocated in io_submit_sqes() and it's not accessed
concurrently. io_uring_cmd_done() sets its result to io_uring_cmd and prepare
some field to completion.

Thanks,
Sidong

> 
> ---
> Cheers,
> Benno

