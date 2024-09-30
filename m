Return-Path: <io-uring+bounces-3327-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F51E98A9E1
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 18:34:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEB0B1F20F10
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 16:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64EB2193078;
	Mon, 30 Sep 2024 16:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I1hwE30B"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5663BB24;
	Mon, 30 Sep 2024 16:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727714077; cv=none; b=qAMEmUy40kIonmkTGnJAe7TLf6AIu1SwrNc9IDushGFcQbS/ekA6hpmhyFXZ7Nq2TaW8h1c1kaPxO8UptvJVyLAqA6NlXNG8EtgLayROjZOzvp7EDiwGjME8S5QXoXnCZZnzZX8vtcw1IDEoaO2GyOqluXrlz6zHFD7FHDz1gjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727714077; c=relaxed/simple;
	bh=XdzytvPqMsYQRMdXan0FNx1zIVM7FHK4m0ET+1fP0RU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yr8cKyeeQSW97eS7CggD08qAbfldhUn0o6UZmIkM1GpPEwxfJNNMR+FGihoz57Cul3BTMQe3h2oZzYnlDB99oM3uXgTedA83reOzg8CVExSpsTNXt0f4WO+ptblcU3IPfesHYyYmiZSfF80Yi/Jkm//Tg+NwgYMlyd0Kkdm3tO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I1hwE30B; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95B5C4CEDB;
	Mon, 30 Sep 2024 16:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727714076;
	bh=XdzytvPqMsYQRMdXan0FNx1zIVM7FHK4m0ET+1fP0RU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=I1hwE30BW23rrGpWygDIU17Nk4fAMnTTpriMHODBKktjDgXnP+OncNEmAH/jGPyCu
	 d6z0GJJvPQiYJvCk4/KkNEuCDeMp8/oU5NA5vm5EZbEs0Z4HFhSu2GPph2fPE3UNb3
	 hDxOX2sohf4tIvo/uWqQHFMtyXsjwuUpawalvWiBCJ5756K6iXdyL4/cEhOOU0SFKs
	 TuBLyzpcwCtoTyhy2pasbPjabxzMbNcNM0toADLhw5ZB6cxAc2lq2V0s/eaofFoJN9
	 Ww7ICEIScj/Znwrs3HioCUlsiKiVLkIq6F9GnKUsBMY8MLaJTYrwfM/CJ1Ee6w0OUs
	 SBJiO+YYtAzbA==
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-5e1b35030aeso2676312eaf.3;
        Mon, 30 Sep 2024 09:34:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU/wERmZLvhJoFYTpXRJK4rErYx6KcTUCcNG99pMA1RyQmL1sCNX3dE6rVThirD0/wPFSgQ+FPgHpXQOVgG@vger.kernel.org, AJvYcCUEKk/SXq0IeDc267WAnzVk+30edrh4fVcFy8kaV30lqb/NOp/+YZf+Kol3vigBtjWF/F4jhfdmsg==@vger.kernel.org, AJvYcCW+XRutr6FgrGMkw98rsdth081H3Diy/VkgnxCBvMXooLvRO7wkJpbwybvOq8vdzXB2g0ET2S0lGN/8gRA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiNH9UDmOUG1t2XLHJHJ6RND/KHv6RFysNS6W+jQHgnje2a+jp
	5JovK1IcikJXELceBj2loJ3nfDg/1ou4gnd4g7CgHfJdItolK8ZJH4f3FIwVG5nagS7D6FvtwL+
	IdI0CTLRL9qXWhteSbP8JhwaR+8I=
X-Google-Smtp-Source: AGHT+IF7xTdjgI1jeIbQVBtzv/eL/CjOcAjNUrL3IDbhmbsKEJSFatFkY45ecBSYGq5xtPZGsfJS+AsZPLj3cWKQY9M=
X-Received: by 2002:a05:6820:22a7:b0:5e1:ce95:9e1f with SMTP id
 006d021491bc7-5e7725cae58mr7076919eaf.2.1727714075637; Mon, 30 Sep 2024
 09:34:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240905092645.2885200-1-christian.loehle@arm.com> <20240905092645.2885200-6-christian.loehle@arm.com>
In-Reply-To: <20240905092645.2885200-6-christian.loehle@arm.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 30 Sep 2024 18:34:24 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0hJWwsErT193i394bHOczvCQwU_5AVVTJ1oKDe7kTW82g@mail.gmail.com>
Message-ID: <CAJZ5v0hJWwsErT193i394bHOczvCQwU_5AVVTJ1oKDe7kTW82g@mail.gmail.com>
Subject: Re: [RFC PATCH 5/8] cpufreq/schedutil: Remove iowait boost
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
> iowait boost in schedutil was introduced by
> commit ("21ca6d2c52f8 cpufreq: schedutil: Add iowait boosting").
> with it more or less following intel_pstate's approach to increase
> frequency after an iowait wakeup.
> Behaviour that is piggy-backed onto iowait boost is problematic
> due to a lot of reasons, so remove it.
>
> For schedutil specifically these are some of the reasons:
> 1. Boosting is applied even in scenarios where it doesn't improve
> throughput.

Well, I wouldn't argue this way because it is kind of like saying that
air conditioning is used even when it doesn't really help.  It is
sometimes hard to know in advance whether or not it will help though.

> 2. The boost is not accounted for in EAS: a) feec() will only consider
>  the actual task utilization for task placement, but another CPU might
>  be more energy-efficient at that capacity than the boosted one.)
>  b) When placing a non-IO task while a CPU is boosted compute_energy()
>  assumes a lower OPP than what is actually applied. This leads to
>  wrong EAS decisions.

That's a very good point IMV and so is the one regarding UCLAMP_MAX (8
in your list).

If the goal is to set the adequate performance for a given utilization
level (either actual or prescribed), boosting doesn't really play well
with this and it shouldn't be used at least in these cases.

> 3. Actual IO heavy workloads are hardly distinguished from infrequent
> in_iowait wakeups.

Do infrequent in_iowait wakeups really cause the boosting to be
applied at full swing?

> 4. The boost isn't accounted for in task placement.

I'm not sure what exactly this means.  "Big" vs "little" or something else?

> 5. The boost isn't associated with a task, it therefore lingers on the
> rq even after the responsible task has migrated / stopped.

Fair enough, but this is rather a problem with the implementation of
boosting and not with the basic idea of it.

> 6. The boost isn't associated with a task, it therefore needs to ramp
> up again when migrated.

Well, that again is somewhat implementation-related IMV, and it need
not be problematic in principle.  Namely, if a task migrates and it is
not the only one in the "new" CPUs runqueue, and the other tasks in
there don't use in_iowait, maybe it's better to not boost it?

It also means that boosting is not very consistent, though, which is a
valid point.

> 7. Since schedutil doesn't know which task is getting woken up,
> multiple unrelated in_iowait tasks lead to boosting.

Well, that's by design: it boosts, when "there is enough IO pressure
in the runqueue", so to speak.

Basically, it is a departure from the "make performance follow
utilization" general idea and it is based on the observation that in
some cases performance can be improved by taking additional
information into account.

It is also about pure performance, not about energy efficiency.

> 8. Boosting is hard to control with UCLAMP_MAX (which is only active
> when the task is on the rq, which for boosted tasks is usually not
> the case for most of the time).
>
> One benefit of schedutil specifically is the reliance on the
> scheduler's utilization signals, which have evolved a lot since it's
> original introduction. Some cases that benefitted from iowait boosting
> in the past can now be covered by e.g. util_est.

And it would be good to give some examples of this.

IMV you have a clean-cut argument in the EAS and UCLAMP_MAX cases, but
apart from that it is all a bit hand-wavy.

> Signed-off-by: Christian Loehle <christian.loehle@arm.com>
> ---
>  kernel/sched/cpufreq_schedutil.c | 181 +------------------------------
>  1 file changed, 3 insertions(+), 178 deletions(-)
>
> diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_sche=
dutil.c
> index 5324f07fc93a..55b8b8ba7238 100644
> --- a/kernel/sched/cpufreq_schedutil.c
> +++ b/kernel/sched/cpufreq_schedutil.c
> @@ -6,12 +6,9 @@
>   * Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>   */
>
> -#define IOWAIT_BOOST_MIN       (SCHED_CAPACITY_SCALE / 8)
> -
>  struct sugov_tunables {
>         struct gov_attr_set     attr_set;
>         unsigned int            rate_limit_us;
> -       unsigned int            iowait_boost_cap;
>  };
>
>  struct sugov_policy {
> @@ -36,8 +33,6 @@ struct sugov_policy {
>
>         bool                    limits_changed;
>         bool                    need_freq_update;
> -
> -       unsigned int            iowait_boost_cap;
>  };
>
>  struct sugov_cpu {
> @@ -45,10 +40,6 @@ struct sugov_cpu {
>         struct sugov_policy     *sg_policy;
>         unsigned int            cpu;
>
> -       bool                    iowait_boost_pending;
> -       unsigned int            iowait_boost;
> -       u64                     last_update;
> -
>         unsigned long           util;
>         unsigned long           bw_min;
>
> @@ -198,137 +189,15 @@ unsigned long sugov_effective_cpu_perf(int cpu, un=
signed long actual,
>         return max(min, max);
>  }
>
> -static void sugov_get_util(struct sugov_cpu *sg_cpu, unsigned long boost=
)
> +static void sugov_get_util(struct sugov_cpu *sg_cpu)
>  {
>         unsigned long min, max, util =3D cpu_util_cfs_boost(sg_cpu->cpu);
>
>         util =3D effective_cpu_util(sg_cpu->cpu, util, &min, &max);
> -       util =3D max(util, boost);
>         sg_cpu->bw_min =3D min;
>         sg_cpu->util =3D sugov_effective_cpu_perf(sg_cpu->cpu, util, min,=
 max);
>  }
>
> -/**
> - * sugov_iowait_reset() - Reset the IO boost status of a CPU.
> - * @sg_cpu: the sugov data for the CPU to boost
> - * @time: the update time from the caller
> - * @set_iowait_boost: true if an IO boost has been requested
> - *
> - * The IO wait boost of a task is disabled after a tick since the last u=
pdate
> - * of a CPU. If a new IO wait boost is requested after more then a tick,=
 then
> - * we enable the boost starting from IOWAIT_BOOST_MIN, which improves en=
ergy
> - * efficiency by ignoring sporadic wakeups from IO.
> - */
> -static bool sugov_iowait_reset(struct sugov_cpu *sg_cpu, u64 time,
> -                              bool set_iowait_boost)
> -{
> -       s64 delta_ns =3D time - sg_cpu->last_update;
> -
> -       /* Reset boost only if a tick has elapsed since last request */
> -       if (delta_ns <=3D TICK_NSEC)
> -               return false;
> -
> -       sg_cpu->iowait_boost =3D set_iowait_boost ? IOWAIT_BOOST_MIN : 0;
> -       sg_cpu->iowait_boost_pending =3D set_iowait_boost;
> -
> -       return true;
> -}
> -
> -/**
> - * sugov_iowait_boost() - Updates the IO boost status of a CPU.
> - * @sg_cpu: the sugov data for the CPU to boost
> - * @time: the update time from the caller
> - * @flags: SCHED_CPUFREQ_IOWAIT if the task is waking up after an IO wai=
t
> - *
> - * Each time a task wakes up after an IO operation, the CPU utilization =
can be
> - * boosted to a certain utilization which doubles at each "frequent and
> - * successive" wakeup from IO, ranging from IOWAIT_BOOST_MIN to the util=
ization
> - * of the maximum OPP.
> - *
> - * To keep doubling, an IO boost has to be requested at least once per t=
ick,
> - * otherwise we restart from the utilization of the minimum OPP.
> - */
> -static void sugov_iowait_boost(struct sugov_cpu *sg_cpu, u64 time,
> -                              unsigned int flags)
> -{
> -       bool set_iowait_boost =3D flags & SCHED_CPUFREQ_IOWAIT;
> -
> -       /* Reset boost if the CPU appears to have been idle enough */
> -       if (sg_cpu->iowait_boost &&
> -           sugov_iowait_reset(sg_cpu, time, set_iowait_boost))
> -               return;
> -
> -       /* Boost only tasks waking up after IO */
> -       if (!set_iowait_boost)
> -               return;
> -
> -       /* Ensure boost doubles only one time at each request */
> -       if (sg_cpu->iowait_boost_pending)
> -               return;
> -       sg_cpu->iowait_boost_pending =3D true;
> -
> -       /* Double the boost at each request */
> -       if (sg_cpu->iowait_boost) {
> -               sg_cpu->iowait_boost =3D
> -                       min_t(unsigned int,
> -                             sg_cpu->iowait_boost + IOWAIT_BOOST_MIN, SC=
HED_CAPACITY_SCALE);
> -               return;
> -       }
> -
> -       /* First wakeup after IO: start with minimum boost */
> -       sg_cpu->iowait_boost =3D IOWAIT_BOOST_MIN;
> -}
> -
> -/**
> - * sugov_iowait_apply() - Apply the IO boost to a CPU.
> - * @sg_cpu: the sugov data for the cpu to boost
> - * @time: the update time from the caller
> - * @max_cap: the max CPU capacity
> - *
> - * A CPU running a task which woken up after an IO operation can have it=
s
> - * utilization boosted to speed up the completion of those IO operations=
.
> - * The IO boost value is increased each time a task wakes up from IO, in
> - * sugov_iowait_apply(), and it's instead decreased by this function,
> - * each time an increase has not been requested (!iowait_boost_pending).
> - *
> - * A CPU which also appears to have been idle for at least one tick has =
also
> - * its IO boost utilization reset.
> - *
> - * This mechanism is designed to boost high frequently IO waiting tasks,=
 while
> - * being more conservative on tasks which does sporadic IO operations.
> - */
> -static unsigned long sugov_iowait_apply(struct sugov_cpu *sg_cpu, u64 ti=
me,
> -                              unsigned long max_cap)
> -{
> -       /* No boost currently required */
> -       if (!sg_cpu->iowait_boost)
> -               return 0;
> -
> -       /* Reset boost if the CPU appears to have been idle enough */
> -       if (sugov_iowait_reset(sg_cpu, time, false))
> -               return 0;
> -
> -       if (!sg_cpu->iowait_boost_pending) {
> -               /*
> -                * No boost pending; reduce the boost value.
> -                */
> -               sg_cpu->iowait_boost -=3D IOWAIT_BOOST_MIN;
> -               if (!sg_cpu->iowait_boost)
> -                       return 0;
> -       }
> -
> -       sg_cpu->iowait_boost_pending =3D false;
> -
> -       if (sg_cpu->iowait_boost > sg_cpu->sg_policy->iowait_boost_cap)
> -               sg_cpu->iowait_boost =3D sg_cpu->sg_policy->iowait_boost_=
cap;
> -
> -       /*
> -        * sg_cpu->util is already in capacity scale; convert iowait_boos=
t
> -        * into the same scale so we can compare.
> -        */
> -       return (sg_cpu->iowait_boost * max_cap) >> SCHED_CAPACITY_SHIFT;
> -}
> -
>  #ifdef CONFIG_NO_HZ_COMMON
>  static bool sugov_cpu_is_busy(struct sugov_cpu *sg_cpu)
>  {
> @@ -356,18 +225,12 @@ static inline bool sugov_update_single_common(struc=
t sugov_cpu *sg_cpu,
>                                               u64 time, unsigned long max=
_cap,
>                                               unsigned int flags)
>  {
> -       unsigned long boost;
> -
> -       sugov_iowait_boost(sg_cpu, time, flags);
> -       sg_cpu->last_update =3D time;
> -
>         ignore_dl_rate_limit(sg_cpu);
>
>         if (!sugov_should_update_freq(sg_cpu->sg_policy, time))
>                 return false;
>
> -       boost =3D sugov_iowait_apply(sg_cpu, time, max_cap);
> -       sugov_get_util(sg_cpu, boost);
> +       sugov_get_util(sg_cpu);
>
>         return true;
>  }
> @@ -468,11 +331,8 @@ static unsigned int sugov_next_freq_shared(struct su=
gov_cpu *sg_cpu, u64 time)
>
>         for_each_cpu(j, policy->cpus) {
>                 struct sugov_cpu *j_sg_cpu =3D &per_cpu(sugov_cpu, j);
> -               unsigned long boost;
> -
> -               boost =3D sugov_iowait_apply(j_sg_cpu, time, max_cap);
> -               sugov_get_util(j_sg_cpu, boost);
>
> +               sugov_get_util(j_sg_cpu);
>                 util =3D max(j_sg_cpu->util, util);
>         }
>
> @@ -488,9 +348,6 @@ sugov_update_shared(struct update_util_data *hook, u6=
4 time, unsigned int flags)
>
>         raw_spin_lock(&sg_policy->update_lock);
>
> -       sugov_iowait_boost(sg_cpu, time, flags);
> -       sg_cpu->last_update =3D time;
> -
>         ignore_dl_rate_limit(sg_cpu);
>
>         if (sugov_should_update_freq(sg_policy, time)) {
> @@ -560,14 +417,6 @@ static ssize_t rate_limit_us_show(struct gov_attr_se=
t *attr_set, char *buf)
>         return sprintf(buf, "%u\n", tunables->rate_limit_us);
>  }
>
> -
> -static ssize_t iowait_boost_cap_show(struct gov_attr_set *attr_set, char=
 *buf)
> -{
> -       struct sugov_tunables *tunables =3D to_sugov_tunables(attr_set);
> -
> -       return sprintf(buf, "%u\n", tunables->iowait_boost_cap);
> -}
> -
>  static ssize_t
>  rate_limit_us_store(struct gov_attr_set *attr_set, const char *buf, size=
_t count)
>  {
> @@ -586,30 +435,10 @@ rate_limit_us_store(struct gov_attr_set *attr_set, =
const char *buf, size_t count
>         return count;
>  }
>
> -static ssize_t
> -iowait_boost_cap_store(struct gov_attr_set *attr_set, const char *buf, s=
ize_t count)
> -{
> -       struct sugov_tunables *tunables =3D to_sugov_tunables(attr_set);
> -       struct sugov_policy *sg_policy;
> -       unsigned int iowait_boost_cap;
> -
> -       if (kstrtouint(buf, 10, &iowait_boost_cap))
> -               return -EINVAL;
> -
> -       tunables->iowait_boost_cap =3D iowait_boost_cap;
> -
> -       list_for_each_entry(sg_policy, &attr_set->policy_list, tunables_h=
ook)
> -               sg_policy->iowait_boost_cap =3D iowait_boost_cap;
> -
> -       return count;
> -}
> -
>  static struct governor_attr rate_limit_us =3D __ATTR_RW(rate_limit_us);
> -static struct governor_attr iowait_boost_cap =3D __ATTR_RW(iowait_boost_=
cap);
>
>  static struct attribute *sugov_attrs[] =3D {
>         &rate_limit_us.attr,
> -       &iowait_boost_cap.attr,
>         NULL
>  };
>  ATTRIBUTE_GROUPS(sugov);
> @@ -799,8 +628,6 @@ static int sugov_init(struct cpufreq_policy *policy)
>
>         tunables->rate_limit_us =3D cpufreq_policy_transition_delay_us(po=
licy);
>
> -       tunables->iowait_boost_cap =3D SCHED_CAPACITY_SCALE;
> -
>         policy->governor_data =3D sg_policy;
>         sg_policy->tunables =3D tunables;
>
> @@ -870,8 +697,6 @@ static int sugov_start(struct cpufreq_policy *policy)
>         sg_policy->limits_changed               =3D false;
>         sg_policy->cached_raw_freq              =3D 0;
>
> -       sg_policy->iowait_boost_cap             =3D SCHED_CAPACITY_SCALE;
> -
>         sg_policy->need_freq_update =3D cpufreq_driver_test_flags(CPUFREQ=
_NEED_UPDATE_LIMITS);
>
>         if (policy_is_shared(policy))
> --
> 2.34.1
>

