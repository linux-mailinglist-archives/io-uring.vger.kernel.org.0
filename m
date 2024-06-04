Return-Path: <io-uring+bounces-2091-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ADDD8FB3DD
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 15:33:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50A52282BA6
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 13:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E40B1E519;
	Tue,  4 Jun 2024 13:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vcx3iuGx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ED61E49B
	for <io-uring@vger.kernel.org>; Tue,  4 Jun 2024 13:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717508022; cv=none; b=LGRmJ5GiTJV+r6RO2ZjPH07O3XbNhqXbrWOS0K91nBreEFyh7TMuOMYDVMhWIcvGroRZIXYbdcl6h6OekKrknoFqHnUmPztp81QGDmULQ5Ta7LEJHakEpv9fHnDsbAjTwcaLVYTdXXYjoAkTgh8WrT8wOlQ6b2xH3nfpQQW29BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717508022; c=relaxed/simple;
	bh=IvX5mJkqROIQOibcUrt+aye6rYPh/NGQgC0Q9hOQYuE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ek1ElFwjPHcs0xl9pDENo7dCg8O+EkI5uK4thARh6Qtlc+W8g7UMqNa+9WdkDLyxVWiaUqFLlA5PTCtCHPVLqB/WYTvVzVLcfITy3XsVpS0GD5fEplEUsEtQ1eUCrmpwQhjIMl1pzXw5K1AusHApN/haUX6AfOWIaBAkaIr4+XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vcx3iuGx; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3d1c051a9e7so2386350b6e.0
        for <io-uring@vger.kernel.org>; Tue, 04 Jun 2024 06:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717508020; x=1718112820; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IvX5mJkqROIQOibcUrt+aye6rYPh/NGQgC0Q9hOQYuE=;
        b=Vcx3iuGx5a59DIVaJ9NVFcGI97l1HJkdjwtCluZex20ULi/uSrllheQx/4TTCPqgKr
         3PmJ3hBR2GbOo6aCiR8eJ87BZfZe6GzW6nSan5n8Nn9vFlIl3CmeurnGm7ccfeDnksPY
         N4qfHDQ3wW9E0GahvMIcenb3t7QKhlXTDg/XSqgzG+GCD+zIVqzIAVPYU/gfWqVSpVxf
         2lBUaRnao9sRgK5xCyBSlu0uELP8kGR6AISoG0skCyp+T2Awppqh/n/xjuQAbK8+brDe
         RcxeeWGfdPfJTSiAuRaAFP37AMaC6xM8GA4+FTcECZSU0Dk0R5dcM5u1fwz1ZOYeb1r/
         WLGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717508020; x=1718112820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IvX5mJkqROIQOibcUrt+aye6rYPh/NGQgC0Q9hOQYuE=;
        b=miCnChk7wsQ7+4jFqdZqUq/+TXHfuKzyOrcViLlzuArH/nKvYj48EkcNZHYtHnmMWP
         pjnYmMfP8EC5NsXSybf1EWcGFoKlnCiogGDNhvO/yYxl+59nNxRoi0Qz0autmcWqfLRW
         LiJ0KJ4ko8fA+HzjXwpFuh//NV5J5vdchZ+Xjq77EVAhpVO5j8tI7wbpnemz3MXhhrC1
         NXzSyWclJ3Q/5o0uVWNkiMJBz2CKZd6b53hzXYH404EC5RktbyRZwdq3D23ilbzZocUe
         3llAI7CH8FngXEwV/EMcE2ANK/lNqS9DnJjQjY0fHGubpAz+eYgi/W6sh9Sf+4Q6GJ3I
         m3jQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcxjshiTDENfvREq6O+/coSrzAZrHUAZeziof45Qd7CHU+B1OpzVQ4l6579SZPobgM4do2gMM25Qb2pamgpSiQcsOYkvAe8+Y=
X-Gm-Message-State: AOJu0YzQOxvxalWpSx87ezfeuqBogZlGLck0aGkAMLD0/XsjONjiiLgK
	DMCkXBWDS/Y49CUhVhT8QHlnQFmRNUtjwJLpnu5efEUP1iBnPjfwYWN5d/Y2+BkS0DZ/WUsjL9X
	TKh70AtzQReR2fSPZS5ey0N732A==
X-Google-Smtp-Source: AGHT+IFKJ9q5C0qxwPOaYCu12xTHoF/R1aHsgkBjqrYEzWlOSNGIG8fW5gaZT/t2Nw+1C6ilGtV8bW21T8izNCzLBME=
X-Received: by 2002:a05:6808:10d2:b0:3c9:9379:e833 with SMTP id
 5614622812f47-3d1e35b90e7mr15115081b6e.40.1717508019548; Tue, 04 Jun 2024
 06:33:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240530051050epcas5p122f30aebcf99e27a8d02cc1318dbafc8@epcas5p1.samsung.com>
 <c99eb326-0b36-4587-b8a2-8956852309be@kernel.dk> <20240530051044.1405410-1-cliang01.li@samsung.com>
In-Reply-To: <20240530051044.1405410-1-cliang01.li@samsung.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 4 Jun 2024 19:03:02 +0530
Message-ID: <CACzX3Atk2hHpc9FdOcVT57+6Eyka0GeUxcNBy7upgy9sEc47ng@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
To: Chenliang Li <cliang01.li@samsung.com>
Cc: axboe@kernel.dk, anuj20.g@samsung.com, asml.silence@gmail.com, 
	gost.dev@samsung.com, io-uring@vger.kernel.org, joshi.k@samsung.com, 
	kundan.kumar@samsung.com, peiwei.li@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 10:41=E2=80=AFAM Chenliang Li <cliang01.li@samsung.=
com> wrote:
>
> On Thu, 16 May 2024 08:58:03 -0600, Jens Axboe wrote:
> > The change looks pretty reasonable to me. I'd love for the test cases t=
o
> > try and hit corner cases, as it's really more of a functionality test
> > right now. We should include things like one-off huge pages, ensure we
> > don't coalesce where we should not, etc.
>
> Hi Jens, the testcases are updated here:
> https://lore.kernel.org/io-uring/20240530031548.1401768-1-cliang01.li@sam=
sung.com/T/#u
> Add several corner cases this time, works fine. Please take a look.

The additional test cases shared here [1], works fine too on my setup.
Tested-by: Anuj Gupta <anuj20.g@samsung.com>

[1] https://lore.kernel.org/io-uring/20240531052023.1446914-1-cliang01.li@s=
amsung.com/

Thanks,
Anuj Gupta

