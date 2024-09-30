Return-Path: <io-uring+bounces-3324-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C54FD98A7EC
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 16:58:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D5FEB25766
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 14:58:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7579E190471;
	Mon, 30 Sep 2024 14:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ruOjM2up"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4506323D2;
	Mon, 30 Sep 2024 14:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727708297; cv=none; b=c9Ylu9q0QB009kpNPr3Hp4gANzpjCjdIitbpwflDIdak0zFuCpTD1beq/Qbc4K5nYqaoXez6DXWVzJVx6VCAqBN5rKWwcNT0L/5xCKV/MQQ5jgsVJb5mZ4lXhb/mvcULAEI0YbUWVSzR/N0P38KmnUdJgGrc65FDORS/RP3cCnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727708297; c=relaxed/simple;
	bh=e8XB3ydNfSDEmQy4Tw08Jx3xkEBxnykNqG46Pse3slI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qBNifhi853A5bTC1TWlw69C+/Xqr9d67G+eohZIunt/REA47fyyawYuc0Uv73h+X74Szilfa1QqMrzHcCWNjJ01t2JSEob17HACWTF6G7H670F+I0jymDTdaU4Q27Jz9yYTwBZfpqcFwcdF3f33pJypas2Fi76F/6G9i4sxlO1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ruOjM2up; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CAFC4CEC7;
	Mon, 30 Sep 2024 14:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727708296;
	bh=e8XB3ydNfSDEmQy4Tw08Jx3xkEBxnykNqG46Pse3slI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ruOjM2upnDn7qFSfzTaTZmm7HnRrWdkg7qyr5N9kmVdVvIYDA9/4RGb1c5mFyN4AD
	 B3N1NIhbl0SQ7HqNfXOB5yTZRs9gqgNIEQHhV9yLqMl5i4Y73XiUjN/ZVa5yyRl/2b
	 fMxutbTmgWH1kM6+mQqjGSSIk1F0DCywEhLT5o8ROZaprOWnuFF7BlGk6zbtEnOSJQ
	 XGpNHA797Ew8JpBcdf9tNbAyI2lKrPbAwVw+5SEQWwZi8rSLhfBicQihZw1zj3uVRQ
	 HwtJALpGkhH2iUZYDBOEstsUSGf6bL86wTkRkV8wRujiBJyOKvhINIboP3UANgCO2R
	 cb//bMt1LsA7g==
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5e1c65eb68aso2952928eaf.2;
        Mon, 30 Sep 2024 07:58:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVjMs0Bfvqb/LanaLp4hT2Ovka8aCeXmjloGlc+VBIpneUm9JWDIUUiAoVKs+t4iFPnIKZSJ7iYEHB0kvI+@vger.kernel.org, AJvYcCW88/QvFgXWKyomBrleH/E/q3p3wzeXxsfYV8332M+xH1u2rveH/Nhb5KTaRslBbKFT5Soh0zFPAQ==@vger.kernel.org, AJvYcCWK05xJFrUsIOC6OzrmqQDD4BoHn/Xve/IpbUJGvP1ZnTTMdRaUPAo2WNhYx4N3iUFzeBEOxTUhe/eMDE8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRffMh2OR2jlZYWAgDJcmPUxWk+6JATr8hPUVrtSnmrxG+e0EJ
	Q17eIGDQC7ZFykGc+VhIqtaR4ykPLPG/bT8DPHh0fri7LBg1ueLImYO71subkerg45sH/1ZuEm7
	FchFOdQXOx+6s2pC39fSCTRO3Fkg=
X-Google-Smtp-Source: AGHT+IF+7+5qhllVS+kaGVmB3ADb4XHpuOTzvGqWJxj4/o1bdcXLC/kmOmyrKaN9zuvWGb3/Otosnf4BZj4AjyEuSdA=
X-Received: by 2002:a05:6820:1b8a:b0:5e5:b82d:a468 with SMTP id
 006d021491bc7-5e7727baf7amr6347905eaf.7.1727708295950; Mon, 30 Sep 2024
 07:58:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240905092645.2885200-1-christian.loehle@arm.com> <20240905092645.2885200-2-christian.loehle@arm.com>
In-Reply-To: <20240905092645.2885200-2-christian.loehle@arm.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 30 Sep 2024 16:58:04 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0ghjVdBsDsnBSuMA_H9SNgATikck3QxsokqrkHesUKTRQ@mail.gmail.com>
Message-ID: <CAJZ5v0ghjVdBsDsnBSuMA_H9SNgATikck3QxsokqrkHesUKTRQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/8] cpuidle: menu: Remove iowait influence
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
> Remove CPU iowaiters influence on idle state selection.
> Remove the menu notion of performance multiplier which increased with
> the number of tasks that went to iowait sleep on this CPU and haven't
> woken up yet.
>
> Relying on iowait for cpuidle is problematic for a few reasons:
> 1. There is no guarantee that an iowaiting task will wake up on the
> same CPU.
> 2. The task being in iowait says nothing about the idle duration, we
> could be selecting shallower states for a long time.
> 3. The task being in iowait doesn't always imply a performance hit
> with increased latency.
> 4. If there is such a performance hit, the number of iowaiting tasks
> doesn't directly correlate.
> 5. The definition of iowait altogether is vague at best, it is
> sprinkled across kernel code.
>
> Signed-off-by: Christian Loehle <christian.loehle@arm.com>

I promised feedback on this series.

As far as this particular patch is concerned, I generally agree with
all of the above, so I'm going to put it into linux-next right away
and see if anyone reports a problem with it.

> ---
>  drivers/cpuidle/governors/menu.c | 76 ++++----------------------------
>  1 file changed, 9 insertions(+), 67 deletions(-)
>
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors=
/menu.c
> index f3c9d49f0f2a..28363bfa3e4c 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -19,7 +19,7 @@
>
>  #include "gov.h"
>
> -#define BUCKETS 12
> +#define BUCKETS 6
>  #define INTERVAL_SHIFT 3
>  #define INTERVALS (1UL << INTERVAL_SHIFT)
>  #define RESOLUTION 1024
> @@ -29,12 +29,11 @@
>  /*
>   * Concepts and ideas behind the menu governor
>   *
> - * For the menu governor, there are 3 decision factors for picking a C
> + * For the menu governor, there are 2 decision factors for picking a C
>   * state:
>   * 1) Energy break even point
> - * 2) Performance impact
> - * 3) Latency tolerance (from pmqos infrastructure)
> - * These three factors are treated independently.
> + * 2) Latency tolerance (from pmqos infrastructure)
> + * These two factors are treated independently.
>   *
>   * Energy break even point
>   * -----------------------
> @@ -75,30 +74,6 @@
>   * intervals and if the stand deviation of these 8 intervals is below a
>   * threshold value, we use the average of these intervals as prediction.
>   *
> - * Limiting Performance Impact
> - * ---------------------------
> - * C states, especially those with large exit latencies, can have a real
> - * noticeable impact on workloads, which is not acceptable for most sysa=
dmins,
> - * and in addition, less performance has a power price of its own.
> - *
> - * As a general rule of thumb, menu assumes that the following heuristic
> - * holds:
> - *     The busier the system, the less impact of C states is acceptable
> - *
> - * This rule-of-thumb is implemented using a performance-multiplier:
> - * If the exit latency times the performance multiplier is longer than
> - * the predicted duration, the C state is not considered a candidate
> - * for selection due to a too high performance impact. So the higher
> - * this multiplier is, the longer we need to be idle to pick a deep C
> - * state, and thus the less likely a busy CPU will hit such a deep
> - * C state.
> - *
> - * Currently there is only one value determining the factor:
> - * 10 points are added for each process that is waiting for IO on this C=
PU.
> - * (This value was experimentally determined.)
> - * Utilization is no longer a factor as it was shown that it never contr=
ibuted
> - * significantly to the performance multiplier in the first place.
> - *
>   */
>
>  struct menu_device {
> @@ -112,19 +87,10 @@ struct menu_device {
>         int             interval_ptr;
>  };
>
> -static inline int which_bucket(u64 duration_ns, unsigned int nr_iowaiter=
s)
> +static inline int which_bucket(u64 duration_ns)
>  {
>         int bucket =3D 0;
>
> -       /*
> -        * We keep two groups of stats; one with no
> -        * IO pending, one without.
> -        * This allows us to calculate
> -        * E(duration)|iowait
> -        */
> -       if (nr_iowaiters)
> -               bucket =3D BUCKETS/2;
> -
>         if (duration_ns < 10ULL * NSEC_PER_USEC)
>                 return bucket;
>         if (duration_ns < 100ULL * NSEC_PER_USEC)
> @@ -138,19 +104,6 @@ static inline int which_bucket(u64 duration_ns, unsi=
gned int nr_iowaiters)
>         return bucket + 5;
>  }
>
> -/*
> - * Return a multiplier for the exit latency that is intended
> - * to take performance requirements into account.
> - * The more performance critical we estimate the system
> - * to be, the higher this multiplier, and thus the higher
> - * the barrier to go to an expensive C state.
> - */
> -static inline int performance_multiplier(unsigned int nr_iowaiters)
> -{
> -       /* for IO wait tasks (per cpu!) we add 10x each */
> -       return 1 + 10 * nr_iowaiters;
> -}
> -
>  static DEFINE_PER_CPU(struct menu_device, menu_devices);
>
>  static void menu_update(struct cpuidle_driver *drv, struct cpuidle_devic=
e *dev);
> @@ -258,8 +211,6 @@ static int menu_select(struct cpuidle_driver *drv, st=
ruct cpuidle_device *dev,
>         struct menu_device *data =3D this_cpu_ptr(&menu_devices);
>         s64 latency_req =3D cpuidle_governor_latency_req(dev->cpu);
>         u64 predicted_ns;
> -       u64 interactivity_req;
> -       unsigned int nr_iowaiters;
>         ktime_t delta, delta_tick;
>         int i, idx;
>
> @@ -268,8 +219,6 @@ static int menu_select(struct cpuidle_driver *drv, st=
ruct cpuidle_device *dev,
>                 data->needs_update =3D 0;
>         }
>
> -       nr_iowaiters =3D nr_iowait_cpu(dev->cpu);
> -
>         /* Find the shortest expected idle interval. */
>         predicted_ns =3D get_typical_interval(data) * NSEC_PER_USEC;
>         if (predicted_ns > RESIDENCY_THRESHOLD_NS) {
> @@ -283,7 +232,7 @@ static int menu_select(struct cpuidle_driver *drv, st=
ruct cpuidle_device *dev,
>                 }
>
>                 data->next_timer_ns =3D delta;
> -               data->bucket =3D which_bucket(data->next_timer_ns, nr_iow=
aiters);
> +               data->bucket =3D which_bucket(data->next_timer_ns);
>
>                 /* Round up the result for half microseconds. */
>                 timer_us =3D div_u64((RESOLUTION * DECAY * NSEC_PER_USEC)=
 / 2 +
> @@ -301,7 +250,7 @@ static int menu_select(struct cpuidle_driver *drv, st=
ruct cpuidle_device *dev,
>                  */
>                 data->next_timer_ns =3D KTIME_MAX;
>                 delta_tick =3D TICK_NSEC / 2;
> -               data->bucket =3D which_bucket(KTIME_MAX, nr_iowaiters);
> +               data->bucket =3D which_bucket(KTIME_MAX);
>         }
>
>         if (unlikely(drv->state_count <=3D 1 || latency_req =3D=3D 0) ||
> @@ -328,15 +277,8 @@ static int menu_select(struct cpuidle_driver *drv, s=
truct cpuidle_device *dev,
>                  */
>                 if (predicted_ns < TICK_NSEC)
>                         predicted_ns =3D data->next_timer_ns;
> -       } else {
> -               /*
> -                * Use the performance multiplier and the user-configurab=
le
> -                * latency_req to determine the maximum exit latency.
> -                */
> -               interactivity_req =3D div64_u64(predicted_ns,
> -                                             performance_multiplier(nr_i=
owaiters));
> -               if (latency_req > interactivity_req)
> -                       latency_req =3D interactivity_req;
> +       } else if (latency_req > predicted_ns) {
> +               latency_req =3D predicted_ns;
>         }
>
>         /*
> --
> 2.34.1
>

