Return-Path: <io-uring+bounces-8544-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B93AAEE868
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 22:41:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8DCDF7AD8A8
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 20:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1170D21D3D2;
	Mon, 30 Jun 2025 20:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="AV5kd1Fo"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756A23F9FB;
	Mon, 30 Jun 2025 20:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751316097; cv=none; b=t0GBfLPp2q2m/GDpoBqsIPuWkUC3tEOjp6W6HdLcRieS1qK4VN7FTWBhAiuzk/LAtnZ3lbAm8dUalNK/90+TOI6fkXVgwtZO5DUhTa9aRjFF1P59VFfW6JQUkh+oFp2ZweARi0RURp6yaWEipWJMcG4XriLj8lz1YHvQDG6Qj4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751316097; c=relaxed/simple;
	bh=1vuHaxefNMfw6O2ANTNqtKlS+BxavuUzTfaqhaxrujk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ne7MeWtUGzI2TriNmBDrEe/ou9IgB4J1v4Y7MFoD89XU4qXzZ2xH2dnpgTNcZlKvUD2Tl1IpQ3d+j/Z5NN0ZvFB36Ob1zf/aktdX6Z9b2oQexy19YUXGU0oGqvZ8j7MYwWnuJjfLEJVGs1AfvfkWH9txNTztLMGdSBI5VaopNLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=AV5kd1Fo; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1751316092;
	bh=1vuHaxefNMfw6O2ANTNqtKlS+BxavuUzTfaqhaxrujk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=AV5kd1Fow0MQTBCSncnPcp4SqdNuttB0/TTytK+fTCPCaMUKl5pBExMWzj3CFgrHH
	 mJW1/DRNVGh3ZT8LpOdRbIsdMDl+IRR37nmDfH0iScy5fnNtGDCLvbmjY6vaS/tNNd
	 9JcqejCm29mveLYMw5UHyAIqCVG11r1y052VL0gN35NPAAcDWqReYuvyc4w+KcAV3p
	 tnNEn6TSAx+gpmTUFNbHQikOZVEHhRZvHgKR3yFMUjoXZVduFDBFWRBWPBvYAqx1GR
	 JZ0L+ZxC6EXqntlm7KHmscC950f+fNP2kiNhS9j6UBoYojem/VFoADK5bdCxxpedtm
	 r5IeXtb5Wk7KQ==
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id C6B482109A84;
	Mon, 30 Jun 2025 20:41:32 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3141b84bf65so4694751a91.1;
        Mon, 30 Jun 2025 13:41:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVSWORX8ikYyy8/iyl+c7mlCO0iLi+k0Fkt7zIkryy+V2AHRqeRhYMdSceagR8euHnUKzBwzWg06JqokCRF@vger.kernel.org, AJvYcCW628r27tE+4odayrr+k5oviO9oSDIP0+ArIjrZO8sytwt6+0WlZwwDLlLU8yG1xz7mqJahjUzu/w==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy8sFjOyU5mXYntG1eUTJbUb+nxY6wNHlH4NOmhGEHOXM+6qS5
	9xL9tBT4wi3vcocPjykacbaOG/ePt2EZbh8iqjlAOlCaN3Xx/cSRPBWiK5BBI9dbdn+jbc3ExmM
	HcLvHurWbqIWZzkRq6+Z5SJ5khPIvDWo=
X-Google-Smtp-Source: AGHT+IFM/riXBofepRrWM0oi9uou69dBA3d0+YFI/1z/TETZ4JmmB0rFOJc2RB74Kg/1Z2JX9Kv6/LH4iroAX8SVwVI=
X-Received: by 2002:a17:90b:5347:b0:311:ba2e:bdc9 with SMTP id
 98e67ed59e1d1-318c930f9c3mr21034862a91.27.1751316090679; Mon, 30 Jun 2025
 13:41:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250630203641.1217131-1-ammarfaizi2@gnuweeb.org>
In-Reply-To: <20250630203641.1217131-1-ammarfaizi2@gnuweeb.org>
From: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Tue, 1 Jul 2025 03:41:19 +0700
X-Gmail-Original-Message-ID: <CAOG64qM-zfnBTX1xaGvab7+0i=07G-pasWbS8vkis1M4A1uxLw@mail.gmail.com>
X-Gm-Features: Ac12FXwPYc-55eqN8q1QwK0TcG6RzdbEzr4LxvbIb_2cdCYnYRBweIcfPi7DrUw
Message-ID: <CAOG64qM-zfnBTX1xaGvab7+0i=07G-pasWbS8vkis1M4A1uxLw@mail.gmail.com>
Subject: Re: [PATCH liburing] liburing.h: Only use `IOURINGINLINE` macro for
 FFI functions
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring Mailing List <io-uring@vger.kernel.org>, 
	"GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Christian Mazakas <christian.mazakas@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 1, 2025 at 3:36=E2=80=AFAM Ammar Faizi wrote:
> These 3 inline functions are for liburing internal use, it does not
> make much sense to export them:
>
>   uring_ptr_to_u64
>   io_uring_cqe_iter_init
>   io_uring_cqe_iter_next
>
> Don't use IOURINGINLINE on them. Also, add a comment on the
> IOURINGINLINE macro definition explaining when to use IOURINGINLINE
> and remind the reader to add the exported function to liburing-ffi.map
> if they introduce a function marked with IOURINGINLINE.
>
> Cc: Christian Mazakas <christian.mazakas@gmail.com>
> Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

