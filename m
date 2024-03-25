Return-Path: <io-uring+bounces-1204-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CA27889BAE
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 11:59:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 240D52C1ED6
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 10:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 786E715381E;
	Mon, 25 Mar 2024 06:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=layalina-io.20230601.gappssmtp.com header.i=@layalina-io.20230601.gappssmtp.com header.b="f+W+83Kz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CFA16B44F
	for <io-uring@vger.kernel.org>; Mon, 25 Mar 2024 02:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711335195; cv=none; b=Sf0SMOdgreyPr0689q9jHoXMyOtgc+Ml8nQozvD/whqYT+inajHR1NdTaApkk6Zkhj6C2HgQwullcawCulDtXm1o+LkU2M3/pcosVZr9pRz6PHTZ+0yyco4XuCb5HkqkUHLuq5hnKkwkTahNFI1a8ymFZmGw0oXhreC9nhkikos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711335195; c=relaxed/simple;
	bh=Iwy35WEKGQaZWaKUprvpCF3gybVRdIbsl3SsAExl21c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dde5srmqZrumkHoNne1TeRbmVTf8o0UlXhHcMsq0YxXY8Wcx9eYTKwuVvqb9N1ljFKXwiTVy/Y1fjJ7SnMDXlQK+6cjmnJhUv9HqEzVMbM3LHlqOO+mMxemsLnADl5/7Yj89EsUkLyh151NrXcNl/CpFOkWwi4bHBjc3bWukBDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=layalina.io; spf=pass smtp.mailfrom=layalina.io; dkim=pass (2048-bit key) header.d=layalina-io.20230601.gappssmtp.com header.i=@layalina-io.20230601.gappssmtp.com header.b=f+W+83Kz; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=layalina.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=layalina.io
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-341b9f6fb2eso1616830f8f.2
        for <io-uring@vger.kernel.org>; Sun, 24 Mar 2024 19:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20230601.gappssmtp.com; s=20230601; t=1711335190; x=1711939990; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IQSoGNn9foRvk9xNgJy3vvfi1aDXWec9jix0W40tVdQ=;
        b=f+W+83KzVcFgOnBIYaWOsLNSTXRgX51IOnmNuCNUJmS/2G7HN6h2q2KVBH81do868A
         TOmAPiVO1AGVIF62bokjqbMA/KLKbR5PYslQgnzkLoBBrjOuTdHNvSWnQazK4Hu0Yvns
         Tgwss8zuyfX7MPLtdKvSiwV9nP1+OIHceTc3cb2Zzno9rzb7PiCmTQDEqp8SatcPatLe
         CtYkuXTESqoTwsnpSystKMCNBRpN0TOalAu965meiWNZ4LQOQYKTuDC298uBvHsaDBbJ
         AHLPidWzdNIvUmy/EQMM3MW4rgPgcms49zh+u9gUAd6q9bOZ+fD/Unisf8TQb+TUEe1d
         m3cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711335190; x=1711939990;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQSoGNn9foRvk9xNgJy3vvfi1aDXWec9jix0W40tVdQ=;
        b=X4MEsSrITkSafBOFiU04v1nnZljU6UfrgvP6wLqI/WtbY3RCQxJ5/ksruHp/KJ8xt/
         8CkulxBq7TqMdPi+2XbpqVT2UAvH2RYaV5pxnix8+sd1Wpgit3gNWoRbRBMeOldBc7Qf
         zthsvTFWBXAvt1QfzwZIHJC681XjkewL4NuXjhKT579l9T3aHyyLlYQLu9vSM3mfJh6T
         SxwirIEetZI6QZtkOGA3EYFDPuMC5e8h5PgkQ47Itur48l5ylJn8J1zm1c6qqWCf4sw3
         SZl6b2Tih3ojk5MJxxPUu0jL3QhIQ/uz6N0OaQ1dStvc7jmSFHTfG1HGb80vFLMyDToj
         24oQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzin+OrIPf/VcQmFO/J7ZDuS23bj61V0hgmbX+PUugjg73+66Uj736uXuj0uL5VFXh5YbOwAHbZf3H73E2ZDaIyoHusYsqtEA=
X-Gm-Message-State: AOJu0Ywq5ofZtoY94RBsiAaZemuv2g3X2OgZI4u/wOIGioWnxcDVoGNH
	QQQoiMhXhld5X9xAQeHqV++6fxr+CWbGglwk/KYpMK0iQlZ/4SPfslyRoujIiaI=
X-Google-Smtp-Source: AGHT+IG59/Ky716HurdeTVFpnSrvFsweZy84YJGoZ4Hi4NSc7jmRa3TENi3PZTobj8KmtDnOKAn23Q==
X-Received: by 2002:a05:6000:d8c:b0:33e:7ae6:6f4a with SMTP id dv12-20020a0560000d8c00b0033e7ae66f4amr4380793wrb.23.1711335190261;
        Sun, 24 Mar 2024 19:53:10 -0700 (PDT)
Received: from airbuntu (host81-157-90-255.range81-157.btcentralplus.com. [81.157.90.255])
        by smtp.gmail.com with ESMTPSA id t15-20020a5d690f000000b0033e95bf4796sm8123808wru.27.2024.03.24.19.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Mar 2024 19:53:09 -0700 (PDT)
Date: Mon, 25 Mar 2024 02:53:08 +0000
From: Qais Yousef <qyousef@layalina.io>
To: Christian Loehle <christian.loehle@arm.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
	peterz@infradead.org, juri.lelli@redhat.com, mingo@redhat.com,
	rafael@kernel.org, dietmar.eggemann@arm.com, vschneid@redhat.com,
	vincent.guittot@linaro.org, Johannes.Thumshirn@wdc.com,
	adrian.hunter@intel.com, ulf.hansson@linaro.org, andres@anarazel.de,
	asml.silence@gmail.com, linux-pm@vger.kernel.org,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	linux-mmc@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Introduce per-task io utilization boost
Message-ID: <20240325025308.6uqkhpyba6moxntl@airbuntu>
References: <20240304201625.100619-1-christian.loehle@arm.com>
 <86f0af00-8765-4481-9245-1819fb2c6379@acm.org>
 <0dc6a839-2922-40ac-8854-2884196da9b9@arm.com>
 <c5b7fc1f-f233-4d25-952b-539607c2a0cc@acm.org>
 <2784c093-eea1-4b73-87da-1a45f14013c8@arm.com>
 <20240321123935.zqscwi2aom7lfhts@airbuntu>
 <1ff973fc-66a4-446e-8590-ec655c686c90@arm.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1ff973fc-66a4-446e-8590-ec655c686c90@arm.com>

On 03/21/24 17:57, Christian Loehle wrote:

> > So you want the hardirq to move to the big core? Unlike softirq, there will be
> > a single hardirq for the controller (to my limited knowledge), so if there are
> > multiple requests I'm not sure we can easily match which one relates to which
> > before it triggers. So we can end up waking up the wrong core.
> 
> It would be beneficial to move the hardirq to a big core if the IO task
> is using it anyway.
> I'm not sure I actually want to. There are quite a few pitfalls (like you

I'm actually against it. I think it's too much complexity for not necessasrily
a big gain. FWIW, one of the design request to get per task iowait boost so
that we can *disable* it. It wastes power when only a handful of tasks actually
care about perf.

Caring where the hardirq run for perf is unlikely a problem in practice.
Softirq should follow the requester already when it matters.

> mentioned) that the scheduler really shouldn't be concerned about.
> Moving the hardirq, if implemented in the kernel, would have to be done by the
> host controller driver anyway, which would explode this series.
> (host controller drivers are quite fragmented e.g. on mmc)
> 
> The fact that having a higher capacity CPU available ("running faster") for an
> IO task doesn't (always) imply higher throughput because of the hardirq staying
> on some LITTLE CPU is bothering (for this series), though.
> 
> > 
> > Generally this should be a userspace policy. If there's a scenario where the
> > throughput is that important they can easily move the hardirq to the big core
> > unconditionally and move it back again once this high throughput scenario is no
> > longer important.
> 
> It also feels wrong to let this be a userspace policy, as the hardirq must be
> migrated to the perf domain of the task, which userspace isn't aware of.
> Unless you expect userspace to do

irq balancer is a userspace policy. For kernel to make an automatic decision
there are a lot of ifs must be present. Again, I don't see on such system
maximizing throughput is a concern. And userspace can fix the problem simply
- they know after all when the throughput really matters to the point where the
hardirq runs is a bottleneck. In practice, I don't think it is a bottleneck.
But this is my handwavy judgement. The experts know better. And note, I mean
use cases that are not benchmarks ;-)

> CPU_affinity_task=big_perf_domain_0 && hardirq_affinity=big_perf_domain_0
> but then you could just as well ask them to set performance governor for
> big_perf_domain_0 (or uclamp_min=1024) and need neither this series nor
> any iowait boosting.
> 
> Furthermore you can't generally expect userspace to know if their IO will lead
> to any interrupt at all, much less which one. They ideally don't even know if
> the file IO they are doing is backed by any physical storage in the first place.
> (Or even further, that they are doing file IO at all, they might just be
> e.g. page-faulting.)

The way I see it, it's like gigabit networking. The hardirq will matter once
you reach such high throughput scenarios. Which are corner cases and not the
norm?

> 
> > 
> > Or where you describing a different problem?
> 
> That is the problem I mentioned in the series and Bart and I were discussing.
> It's a problem of the series as in "the numbers aren't that impressive".
> Current iowait boosting on embedded/mobile systems will perform quite well by
> chance, as the (low util) task will often be on the same perf domain the hardirq
> will be run on. As can be seen in the cover letter the benefit of running the
> task on a (2xLITTLE capacity) big CPU therefore are practically non-existent,
> for tri-gear systems where big CPU is more like 10xLITTLE capacity the benefit
> will be much greater.
> I just wanted to point this out. We might just acknowledge the problem and say
> "don't care" about the potential performance benefits of those scenarios that
> would require hardirq moving.

I thought the softirq does the bulk of the work. hardirq being such
a bottleneck is (naively maybe) a red flag for me that it's doing too much than
a simple interrupt servicing.

You don't boost when the task is sleeping, right? I think this is likely
a cause of the problem where softirq is not running as fast - where before the
series the CPU will be iowait boosted regardless the task is blocked or not.

> In the long-term it looks like for UFS the problem will disappear as we are
> expected to get one queue/hardirq per CPU (as Bart mentioned), on NVMe that
> is already the case.
> 
> I CC'd Uffe and Adrian for mmc, to my knowledge the only subsystem where
> 'fast' (let's say >10K IOPS) devices are common, but only one queue/hardirq
> is available (and it doesn't look like this is changing anytime soon).
> I would also love to hear what Bart or other UFS folks think about it.
> Furthermore if I forgot any storage subsystem with the same behavior in that
> regards do tell me.
> 
> Lastly, you could consider the IO workload:
> IO task being in iowait very frequently [1] with just a single IO inflight [2]
> and only very little time being spent on the CPU in-between iowaits[3],
> therefore the interrupt handler being on the critical path for IO throughput
> to a non-negligible degree, to be niche, but it's precisely the use-case where
> iowait boosting shows it's biggest benefit.
> 
> Sorry for the abomination of a sentence, see footnotes for the reasons.
> 
> [1] If sugov doesn't see significantly more than 1 iowait per TICK_NSEC it
> won't apply any significant boost currently.

I CCed you to a patch where I fix this. I've been sleeping on it for too long.
Maybe I should have split this fix out of the consolidation patch.

> [2] If the storage devices has enough in-flight requests to serve, iowait
> boosting is unnecessary/wasteful, see cover letter.
> [3] If the task actually uses the CPU in-between iowaits, it will build up
> utilization, iowait boosting benefit diminishes.

The current mechanism is very aggressive. It needs to evolve for sure.

> 
> > 
> > Glad to see your series by the way :-) I'll get a chance to review it over the
> > weekend hopefully.
> 
> Thank you!
> Apologies for not CCing you in the first place, I am curious about your opinion
> on the concept!

I actually had a patch that implements iowait boost per-task (on top of my
remove uclamp max aggregation series) where I did actually take the extra step
to remove iowait from intel_pstate. Can share the patches if you think you'll
find them useful.

Just want to note that this mechanism can end up waste power and this is an
important direction to consider. It's not about perf only (which matters too).

> 
> FWIW I did mess up a last-minute, what was supposed to be, cosmetic change that
> only received a quick smoke test, so 1/2 needs the following:
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 4aaf64023b03..2b6f521be658 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6824,7 +6824,7 @@ static void dequeue_io_boost(struct cfs_rq *cfs_rq, struct task_struct *p)
>         } else if (p->io_boost_curr_ios < p->io_boost_threshold_down) {
>                 /* Reduce boost */
>                 if (p->io_boost_level > 1)
> -                       io_boost_scale_interval(p, true);
> +                       io_boost_scale_interval(p, false);
>                 else
>                         p->io_boost_level = 0;
>         } else if (p->io_boost_level == IO_BOOST_LEVELS) {
> 
> 
> I'll probably send a v2 rebased on 6.9 when it's out anyway, but so far the
> changes are mostly cosmetic and addressing Bart's comments about the benchmark
> numbers in the cover letter.

I didn't spend a lot of time on the series, but I can see a number of problems.
Let us discuss them first and plan a future direction. No need to v2 if it's
just for this fix IMO.

