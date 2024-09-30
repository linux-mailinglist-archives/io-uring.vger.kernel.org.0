Return-Path: <io-uring+bounces-3329-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABDB398AB9B
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 20:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAAE01C21401
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 18:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E760319925D;
	Mon, 30 Sep 2024 18:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eoKpjvYg"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B250919922D;
	Mon, 30 Sep 2024 18:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727719438; cv=none; b=DVrDzfaleIhp7UkOmejkqqY0ebqv4T4pn5o1hbvfz35WgInPogmEo5Vmy9sOT+O+4CWM3T+XO0lGH3Zp/uYcJ0Yrd7r1def3SL0Oil4q15xmJ1DBGSJvPtTfmzqeTQnr5hAxqFmMRipeTUzODIogIoyK/lJwg3sFkv55GhyGNoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727719438; c=relaxed/simple;
	bh=ZEOnbltI4OSiFpvW76m8lvrTI7x6MCWSM6rlKozq8Zs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C5C5Ae6yPrpOA9Keh5r9Yi3nidecu/oLbaCdUE+BfeRkGPej1Fa/MQoC4XSZNhVFC3qOqiEZBDtWsodHYQDrjo4jjA9BGsN8ohkjLCVWKR/3l23+Gj4g+27/inYIKxu+uSNUKQ8l3Fr+1bpFGBi0zZKajdzS/K9hUAwxwks1AcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eoKpjvYg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1A5C4CECF;
	Mon, 30 Sep 2024 18:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727719438;
	bh=ZEOnbltI4OSiFpvW76m8lvrTI7x6MCWSM6rlKozq8Zs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eoKpjvYghAEVM9YD+8Xz0Bci8m8jaRwZzktRuto5oIVxe6FvP18hhbptJwiFUpvLg
	 UkZIswBW3/m4RmNIJq1FS+Uw75OiKEGRxUgUtChe9wv4Tfyd8KhzuHFTCfLcGKKbHp
	 99eUFzOS/2x6xSRjIH7LGm2DTVonU03I31YsS+pcwHFRnLnIZi7IeDBu1b/QRHNJ2v
	 dgFycosVrLhgHjG3cQ0+6+YKPoAFzZoL4Bka+x2rbMwqDrU2fWLYu0v9zXpN0LkxZQ
	 pvLfbSlwPqV3W+Y2x+D2b099OHs+kP4tzkKOdeNe0n9zKpxx7tyP3skblYNH9cjVBO
	 Ni1e7m7y99uJg==
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5e57b7cac4fso2768771eaf.1;
        Mon, 30 Sep 2024 11:03:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU4funPCt2EuWOOHSjIySrSz5bD8p3OQ23tl2j7uF5uIVAVMAf7jtDQ1LcPkqe+Nw/vxXvU7hgSJH1wQpo=@vger.kernel.org, AJvYcCUqOTBgN+IwNmcj8CcPUKb05NoEQz5WyKvghZxyAyHfEmHxDxpYvduNlu6JVuBSOJYefw8oeYtXVP32E6vT@vger.kernel.org, AJvYcCWYp1iSqhvOAxhC/x6iNhxNpzfGvFKhQ/dorZ3J41bltwIRt1cx5D0jWS9D2D94QQplv3t5HgQaFg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzMMlkLV0qy4WH29bxvh+pY2KuJ3QMqwrR2SHJarzXj5XoJjsy9
	EJT0PkUdDeqWMRw7PZTQK4M3RLFDGPmCRMTD68hJQtexsUiaf0a5kCSHEvvMwFveUJnbdHAyQN5
	iML2HyiOMbxArDSBX3DDokrXBkBk=
X-Google-Smtp-Source: AGHT+IG3ujjyRdCEUsPatj+no7TnwxN27pJHjwq1ZLvHYOHrgYDrLwHqMQ2l/ksLAGCgBBvDMYnZEP24XZVr/DcuPnI=
X-Received: by 2002:a05:6820:2208:b0:5e5:7086:ebe8 with SMTP id
 006d021491bc7-5e77244736emr7313486eaf.0.1727719437428; Mon, 30 Sep 2024
 11:03:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240905092645.2885200-1-christian.loehle@arm.com> <20240905092645.2885200-7-christian.loehle@arm.com>
In-Reply-To: <20240905092645.2885200-7-christian.loehle@arm.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 30 Sep 2024 20:03:45 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0i3ULQ-Mzu=6yzo4whnWne0g1sxcgPL_u828Jyy1Qu1Zg@mail.gmail.com>
Message-ID: <CAJZ5v0i3ULQ-Mzu=6yzo4whnWne0g1sxcgPL_u828Jyy1Qu1Zg@mail.gmail.com>
Subject: Re: [RFC PATCH 6/8] cpufreq: intel_pstate: Remove iowait boost
To: Christian Loehle <christian.loehle@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, rafael@kernel.org, 
	peterz@infradead.org, juri.lelli@redhat.com, mingo@redhat.com, 
	dietmar.eggemann@arm.com, vschneid@redhat.com, vincent.guittot@linaro.org, 
	Johannes.Thumshirn@wdc.com, adrian.hunter@intel.com, ulf.hansson@linaro.org, 
	bvanassche@acm.org, andres@anarazel.de, asml.silence@gmail.com, 
	linux-block@vger.kernel.org, io-uring@vger.kernel.org, qyousef@layalina.io, 
	dsmythies@telus.net, axboe@kernel.dk, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

+Srinivas who can say more about the reasons why iowait boosting makes
a difference for intel_pstate than I do.

On Thu, Sep 5, 2024 at 11:27=E2=80=AFAM Christian Loehle
<christian.loehle@arm.com> wrote:
>
> Analogous to schedutil, remove iowait boost for the same reasons.

Well, first of all, iowait boosting was added to intel_pstate to help
some workloads that otherwise were underperforming.  I'm not sure if
you can simply remove it without introducing performance regressions
in those workloads.

While you can argue that it is not useful in schedutil any more due to
the improved scheduler input for it, you can hardly extend that
argument to intel_pstate because it doesn't use all of the scheduler
input used by schedutil.

Also, the EAS and UCLAMP_MAX arguments are not applicable to
intel_pstate because it doesn't support any of them.

This applies to the ondemand cpufreq governor either.


> Signed-off-by: Christian Loehle <christian.loehle@arm.com>
> ---
>  drivers/cpufreq/intel_pstate.c | 50 ++--------------------------------
>  1 file changed, 3 insertions(+), 47 deletions(-)
>
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstat=
e.c
> index c0278d023cfc..7f30b2569bb3 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -191,7 +191,6 @@ struct global_params {
>   * @policy:            CPUFreq policy value
>   * @update_util:       CPUFreq utility callback information
>   * @update_util_set:   CPUFreq utility callback is set
> - * @iowait_boost:      iowait-related boost fraction
>   * @last_update:       Time of the last update.
>   * @pstate:            Stores P state limits for this CPU
>   * @vid:               Stores VID limits for this CPU
> @@ -245,7 +244,6 @@ struct cpudata {
>         struct acpi_processor_performance acpi_perf_data;
>         bool valid_pss_table;
>  #endif
> -       unsigned int iowait_boost;
>         s16 epp_powersave;
>         s16 epp_policy;
>         s16 epp_default;
> @@ -2136,28 +2134,7 @@ static inline void intel_pstate_update_util_hwp_lo=
cal(struct cpudata *cpu,
>  {
>         cpu->sample.time =3D time;
>
> -       if (cpu->sched_flags & SCHED_CPUFREQ_IOWAIT) {
> -               bool do_io =3D false;
> -
> -               cpu->sched_flags =3D 0;
> -               /*
> -                * Set iowait_boost flag and update time. Since IO WAIT f=
lag
> -                * is set all the time, we can't just conclude that there=
 is
> -                * some IO bound activity is scheduled on this CPU with j=
ust
> -                * one occurrence. If we receive at least two in two
> -                * consecutive ticks, then we treat as boost candidate.
> -                */
> -               if (time_before64(time, cpu->last_io_update + 2 * TICK_NS=
EC))
> -                       do_io =3D true;
> -
> -               cpu->last_io_update =3D time;
> -
> -               if (do_io)
> -                       intel_pstate_hwp_boost_up(cpu);
> -
> -       } else {
> -               intel_pstate_hwp_boost_down(cpu);
> -       }
> +       intel_pstate_hwp_boost_down(cpu);
>  }
>
>  static inline void intel_pstate_update_util_hwp(struct update_util_data =
*data,
> @@ -2240,9 +2217,6 @@ static inline int32_t get_target_pstate(struct cpud=
ata *cpu)
>         busy_frac =3D div_fp(sample->mperf << cpu->aperf_mperf_shift,
>                            sample->tsc);
>
> -       if (busy_frac < cpu->iowait_boost)
> -               busy_frac =3D cpu->iowait_boost;
> -
>         sample->busy_scaled =3D busy_frac * 100;
>
>         target =3D READ_ONCE(global.no_turbo) ?
> @@ -2303,7 +2277,7 @@ static void intel_pstate_adjust_pstate(struct cpuda=
ta *cpu)
>                 sample->aperf,
>                 sample->tsc,
>                 get_avg_frequency(cpu),
> -               fp_toint(cpu->iowait_boost * 100));
> +               0);
>  }
>
>  static void intel_pstate_update_util(struct update_util_data *data, u64 =
time,
> @@ -2317,24 +2291,6 @@ static void intel_pstate_update_util(struct update=
_util_data *data, u64 time,
>                 return;
>
>         delta_ns =3D time - cpu->last_update;
> -       if (flags & SCHED_CPUFREQ_IOWAIT) {
> -               /* Start over if the CPU may have been idle. */
> -               if (delta_ns > TICK_NSEC) {
> -                       cpu->iowait_boost =3D ONE_EIGHTH_FP;
> -               } else if (cpu->iowait_boost >=3D ONE_EIGHTH_FP) {
> -                       cpu->iowait_boost <<=3D 1;
> -                       if (cpu->iowait_boost > int_tofp(1))
> -                               cpu->iowait_boost =3D int_tofp(1);
> -               } else {
> -                       cpu->iowait_boost =3D ONE_EIGHTH_FP;
> -               }
> -       } else if (cpu->iowait_boost) {
> -               /* Clear iowait_boost if the CPU may have been idle. */
> -               if (delta_ns > TICK_NSEC)
> -                       cpu->iowait_boost =3D 0;
> -               else
> -                       cpu->iowait_boost >>=3D 1;
> -       }
>         cpu->last_update =3D time;
>         delta_ns =3D time - cpu->sample.time;
>         if ((s64)delta_ns < INTEL_PSTATE_SAMPLING_INTERVAL)
> @@ -2832,7 +2788,7 @@ static void intel_cpufreq_trace(struct cpudata *cpu=
, unsigned int trace_type, in
>                 sample->aperf,
>                 sample->tsc,
>                 get_avg_frequency(cpu),
> -               fp_toint(cpu->iowait_boost * 100));
> +               0);
>  }
>
>  static void intel_cpufreq_hwp_update(struct cpudata *cpu, u32 min, u32 m=
ax,
> --
> 2.34.1
>

