Return-Path: <io-uring+bounces-4455-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 74FA29BCD4C
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 14:05:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 143691F22308
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 13:05:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 839DE1D5159;
	Tue,  5 Nov 2024 13:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TBI0PQEz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64231AA785;
	Tue,  5 Nov 2024 13:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730811911; cv=none; b=mr8+PmXHw797/24K7nC98sva2a0Q9UOzZ0NZnBKyynXFYu/O3mCRXlz2F7l2eBuQcH4uLRI4zJ6VAT+QqhJipeYoFZixbXw0cWG3ZmX+TP0vOVl3y61kt9c0etPfQgSkxypOCtl/NgSWRV1s1zo218fOtwKTKySCBBsfc7Zo26Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730811911; c=relaxed/simple;
	bh=fTH4WFQl44MZo2K8HCqfF+HKDqxdQyvMXtNA1sRPJUQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m1I+ZpcShlZIgeX2Z0GFoJwn+8vTMjalxLKrY9+v/ah2iX1jBd+5TtAaL9GuqU3x/ob5nnYFp7ig7dWC9FgHEyj1T/2tYyF2BKf7JoM9xxIuxWjt/d8GDPr23IsajkzPQxeQ0LemE7DiX0Gk/WV4myusQuphS5C5KShliuwRBP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TBI0PQEz; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5ceb75f9631so5568447a12.0;
        Tue, 05 Nov 2024 05:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730811908; x=1731416708; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fTH4WFQl44MZo2K8HCqfF+HKDqxdQyvMXtNA1sRPJUQ=;
        b=TBI0PQEzd2eycVToUg8AJOCKJwwonqX6Mx/T8l38ix8RuzfDXYenK38PRuEDqPcIiB
         ilsJsGJ/0u6/3nfCT/jqXM5QftyeOqPC6pX2b1RHJE7gj1y/AeGRbBzeaCteCylD3HTq
         v/f5NoirUrIdjkCHtTRNHqUZ7i9PIxgFMJ5DNPWBBSnDONdyguHweegB2e1N3jgWDhs1
         dU+rSGtZisT4mah8JT1GUTJk7CIsZoF6ghuMpO35l0mlgoxYSY/+lCluHMzNskp4JvhU
         Pmy09pzh0nZDZk9Ek59WGP5auNZLuHCg0OvJxgVpS24cbW3ODfz2gYZ21IVjuOjg6ifc
         o/Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730811908; x=1731416708;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fTH4WFQl44MZo2K8HCqfF+HKDqxdQyvMXtNA1sRPJUQ=;
        b=wiFWiQA436lWIgFXNQOeR9ZGI9rIlpGuVNc+X1oldRIhjY5iK8MwiDTF4KJuHOXIbi
         9LyQEIQ6wiSFlN43jZlVzD+WR8Usx6/jfob/NTGHT/7wlKVFMA/+pU9OL2VLlcQkbsZh
         TCPS2+TDO03otWU88vW43p9uBEB/8q3whsgRVT54zWP2S60LGa4uRTMahVOe31QMA4eX
         LzVFaK86KVCTPp7aaofo3e/PTNNuoJiZr/exZOyfZij2mrWIrzNmurqYqxJ0Zt0XZVwP
         f7Ehxth0gERvUQK2Kb/YjfxHBQuECpM52eHn9xRyhgu8OGzW7wTRXzQNLev9LLRQH5kH
         83ug==
X-Forwarded-Encrypted: i=1; AJvYcCUa5dUxnHba+/zpzk2LZanKW2NxDE9K/Hqxfz+ag2mHDOOW/zm0JJa2GTnb/uF5uv3Ye/y6TzIWe+uYfQ==@vger.kernel.org, AJvYcCUq/b+IN5LY3yUYXPsingvcRNc8rD/LgNacf5YgmhE4ORTwAaj6jB8NyyA6Qtlj1+/8XwrhNe+P63Try1PpSg==@vger.kernel.org, AJvYcCUynic38+62aZqFlBn9u6cKu/azZzhixeKL2Xa54QyiMpcWBIy2tLxz6asYGs6RyuEUesocIP0eW2HR+5Q=@vger.kernel.org, AJvYcCVEqTvXX7PyfzmI3RJpUh83jZLr4ijSk/KQvNZz6w6+tYzCCgbFa66PPgU/r2ttAbHEk4wcU0Hv6Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxKqWw4E5nrRsa8WuWMtywc0LAW5rdQsnQfPcKveckSFosFC4Zf
	G1wjswpVN8UrG7LtByxEUpJgcvxiXqQ3VUNCKFCX3Qhui4InWNmZU77Olu+6Ki5v2rgKNchw1J0
	rjGHpQlI5C4nAfZRL5ypgzM3RYg==
X-Google-Smtp-Source: AGHT+IF01wR05OjwQeh992AAL/y5UPKmRBQ8OJmD/daNR7F3czK12/2t8R6t75acTlCyTboaI0WJ85eVBHqdyctE/Ic=
X-Received: by 2002:a05:6402:1e8c:b0:5ce:c8d4:c6e5 with SMTP id
 4fb4d7f45d1cf-5cec8d4ca1emr8823138a12.22.1730811907858; Tue, 05 Nov 2024
 05:05:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241104140601.12239-1-anuj20.g@samsung.com> <CGME20241104141459epcas5p27991e140158b1e7294b4d6c4e767373c@epcas5p2.samsung.com>
 <20241104140601.12239-7-anuj20.g@samsung.com> <20241105095621.GB597@lst.de>
In-Reply-To: <20241105095621.GB597@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 5 Nov 2024 18:34:29 +0530
Message-ID: <CACzX3AuNFoE-EC_xpDPZkoiUk1uc0LXMNw-mLnhrKAG4dnJzQw@mail.gmail.com>
Subject: Re: [PATCH v7 06/10] io_uring/rw: add support to send metadata along
 with read/write
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org, 
	martin.petersen@oracle.com, asml.silence@gmail.com, brauner@kernel.org, 
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, 
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com, 
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 3:26=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrote=
:
>
> On Mon, Nov 04, 2024 at 07:35:57PM +0530, Anuj Gupta wrote:
> > read/write. A new meta_type field is introduced in SQE which indicates
> > the type of metadata being passed.
>
> I still object to this completely pointless and ill-defined field.

The field is used only at io_uring level, and it helps there in using the
SQE space flexibly.
Overall, while all other pieces are sorted, we are only missing the consens=
us
on io_uring bits. This is also an attempt to gain that. We will have to see
in what form Jens/Pavel would like to see this part.

