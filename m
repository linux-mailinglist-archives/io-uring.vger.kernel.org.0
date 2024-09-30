Return-Path: <io-uring+bounces-3325-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BCA7498A818
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 17:06:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 464C3B288FC
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 15:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D56161917FF;
	Mon, 30 Sep 2024 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BPnuoTkA"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C631CFA9;
	Mon, 30 Sep 2024 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727708775; cv=none; b=hkbSrfGM4ERETF6ipFxqiPfKA9SR7q0GH148P8owfwV3TrfJ1TyhvIv1wAZFTdBvy6ZNQfZ7iKaEcT5oA5S8NnvvOgPWEqOzhj/DBcd6s6x+y4VA5Ke+/xm/fPkud2eEeHHGK3iZ3DoPQD1R47xPPR7Hb2C/GIRB1Kxg7/u9aAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727708775; c=relaxed/simple;
	bh=ngCu/hMHjH84wDb0iV2Bzjsfq89LHQRH4viM11PNXYo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YD+cmAJlUynjpnNl1uSONRbiKrhdKqwvB4lxQM8MhirdKioAVrCbCGQjByNHuaUPnIpHdaTfbUgsrZgVi/F62UkZwAqPO1aWayaVJXvPFywvhiKluokOb5NerTYlXNPfh1Vnl2R73Oa8eSbQADjB6zvQR7mqgbtHBLQFrFc56KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BPnuoTkA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271CCC4AF09;
	Mon, 30 Sep 2024 15:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727708775;
	bh=ngCu/hMHjH84wDb0iV2Bzjsfq89LHQRH4viM11PNXYo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BPnuoTkAce+HKTSoE8Qp66fgPmktDejNE4T3tbLfm7TfARmdTwqETAJusVUY84CRl
	 AgpYBe2bWwq6xxOfyrarjllBWu9xrjK3B8vWhdvB8Gs+9xkpckQTZIhNQbyJvbclwu
	 yDwK/jMFl5tvNSwRpwZEqbo12IgmYIFhAQqGiafyvb4jFQ262K2Mjqnk+bEA/qSiKf
	 bC6lvFBj5fbirWrZAq5lBMTUnaVhilwvEO76YtRLGS8aB9DT8jVjkzFWf2oLTDfE5o
	 pqOBYgMufHFLI67iRLMvFxcpC4qAUtP62n/EjPPmJ8aHPgIzMu9Bzdr1BmAbjJYDU5
	 Gs69Q6O4lf4bQ==
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3e03c736466so2857419b6e.1;
        Mon, 30 Sep 2024 08:06:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU8CGaicK8vdI0s0c4xABVTqGIGqNGrkWu1h4DgFO7mF6nUP1sFafKG+pl8oh3+HK016O7IFqsbpA==@vger.kernel.org, AJvYcCVAuf9uk15VrANfxzzaztSWutluOih75962c9STEzU9MqAlKOjx0gKPdeLk4X1ISncpYPT0gkWL2YcQLMho@vger.kernel.org, AJvYcCXifemE0chBDjVLecReFcHl8Y3i7RnQa6wRgV+hi9OSNrOSN1BYebLaCGRFHZapUSSoTyV+I48ONwz1o/I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYwOroSoJtVupTojvwqsuWyY1+Wu+LLIxg+PSlHuAnj0GxEK2G
	T/Cz+Mx/sLkSzwlPmTnheVlq71k4poN6T1GWt2E1pYuexUoPifmJD6GlhT87ufdzMHEtkylz3/O
	V5ezYwx8ukiWeTMd68AZNdYKA18w=
X-Google-Smtp-Source: AGHT+IHN/VxcDlbpcWnreYOVCjZ9Xx5U1zGFEV2WvRfWn65plcCQgbQL8OEGiHdwBwPyv3sdav6QuUSzbbrUsT/gLLQ=
X-Received: by 2002:a05:6871:e491:b0:277:e6f6:b383 with SMTP id
 586e51a60fabf-28710aad143mr7769921fac.24.1727708774441; Mon, 30 Sep 2024
 08:06:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240905092645.2885200-1-christian.loehle@arm.com> <20240905092645.2885200-3-christian.loehle@arm.com>
In-Reply-To: <20240905092645.2885200-3-christian.loehle@arm.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 30 Sep 2024 17:06:03 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0gKeHsvB_Jfja=yYLijhe9_dWSjCaMDtE2isOuJa6dy8w@mail.gmail.com>
Message-ID: <CAJZ5v0gKeHsvB_Jfja=yYLijhe9_dWSjCaMDtE2isOuJa6dy8w@mail.gmail.com>
Subject: Re: [RFC PATCH 2/8] cpuidle: Prefer teo over menu governor
To: Christian Loehle <christian.loehle@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, rafael@kernel.org, 
	peterz@infradead.org, juri.lelli@redhat.com, mingo@redhat.com, 
	dietmar.eggemann@arm.com, vschneid@redhat.com, vincent.guittot@linaro.org, 
	Johannes.Thumshirn@wdc.com, adrian.hunter@intel.com, ulf.hansson@linaro.org, 
	bvanassche@acm.org, andres@anarazel.de, asml.silence@gmail.com, 
	linux-block@vger.kernel.org, io-uring@vger.kernel.org, qyousef@layalina.io, 
	dsmythies@telus.net, axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 5, 2024 at 11:27=E2=80=AFAM Christian Loehle
<christian.loehle@arm.com> wrote:
>
> Since menu no longer has the interactivity boost teo works better
> overall, so make it the default.
>
> Signed-off-by: Christian Loehle <christian.loehle@arm.com>

I know that this isn't strictly related to the use of iowait in menu,
but I'd rather wait with this one until the previous change in menu
settles down.

Also it would be good to provide some numbers to support the "teo
works better overall" claim above.

> ---
>  drivers/cpuidle/Kconfig          | 5 +----
>  drivers/cpuidle/governors/menu.c | 2 +-
>  drivers/cpuidle/governors/teo.c  | 2 +-
>  3 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
> index cac5997dca50..ae67a464025a 100644
> --- a/drivers/cpuidle/Kconfig
> +++ b/drivers/cpuidle/Kconfig
> @@ -5,7 +5,7 @@ config CPU_IDLE
>         bool "CPU idle PM support"
>         default y if ACPI || PPC_PSERIES
>         select CPU_IDLE_GOV_LADDER if (!NO_HZ && !NO_HZ_IDLE)
> -       select CPU_IDLE_GOV_MENU if (NO_HZ || NO_HZ_IDLE) && !CPU_IDLE_GO=
V_TEO
> +       select CPU_IDLE_GOV_TEO if (NO_HZ || NO_HZ_IDLE) && !CPU_IDLE_GOV=
_MENU
>         help
>           CPU idle is a generic framework for supporting software-control=
led
>           idle processor power management.  It includes modular cross-pla=
tform
> @@ -30,9 +30,6 @@ config CPU_IDLE_GOV_TEO
>           This governor implements a simplified idle state selection meth=
od
>           focused on timer events and does not do any interactivity boost=
ing.
>
> -         Some workloads benefit from using it and it generally should be=
 safe
> -         to use.  Say Y here if you are not happy with the alternatives.
> -
>  config CPU_IDLE_GOV_HALTPOLL
>         bool "Haltpoll governor (for virtualized systems)"
>         depends on KVM_GUEST
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors=
/menu.c
> index 28363bfa3e4c..c0ae5e98d6f1 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -508,7 +508,7 @@ static int menu_enable_device(struct cpuidle_driver *=
drv,
>
>  static struct cpuidle_governor menu_governor =3D {
>         .name =3D         "menu",
> -       .rating =3D       20,
> +       .rating =3D       19,
>         .enable =3D       menu_enable_device,
>         .select =3D       menu_select,
>         .reflect =3D      menu_reflect,
> diff --git a/drivers/cpuidle/governors/teo.c b/drivers/cpuidle/governors/=
teo.c
> index f2992f92d8db..6c3cc39f285d 100644
> --- a/drivers/cpuidle/governors/teo.c
> +++ b/drivers/cpuidle/governors/teo.c
> @@ -537,7 +537,7 @@ static int teo_enable_device(struct cpuidle_driver *d=
rv,
>
>  static struct cpuidle_governor teo_governor =3D {
>         .name =3D         "teo",
> -       .rating =3D       19,
> +       .rating =3D       20,
>         .enable =3D       teo_enable_device,
>         .select =3D       teo_select,
>         .reflect =3D      teo_reflect,
> --
> 2.34.1
>

