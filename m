Return-Path: <io-uring+bounces-1283-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C31888FC83
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 11:10:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0244629816E
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 10:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 316E87D061;
	Thu, 28 Mar 2024 10:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="chfLHFAz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DD153E28
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 10:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711620593; cv=none; b=iw1XBIa0Lst03dIBM4Ld87gbDNn9UOIzshAVZzIxl4EGPJ6FQmPfdsIBFEbwfQ71S5pAUhOJeCJyWG0Z9EhIypGGKoDU5qejK3D25BB8XLfl9R13odjqqMGHkTLF2tzuSiRToLdqtKDQJzoh38tmLvnPXzXTfxuhHq2S5HKvOzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711620593; c=relaxed/simple;
	bh=Q1TGbULYu7TuYaZNobqACeoh02W86om05wel0i2BsIA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uo+X92dHaeC5DuJB/qv2tGjSf7hsgzY1smutfk5MimrwEHOoK0qji2su6ITh2Y/j1ra4orUg4UvUG1YmKFBJVxFKY0ZBzL4E/HqalgERi6gPd8Fwf0RgQmh8h4k51r0NoTqOPwhC9DPs0uxIs/9dMoHQ4Dl3l7AsfRZs9TJmwes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=chfLHFAz; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1e0f2798cd8so7176275ad.3
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 03:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711620590; x=1712225390; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=imitBWhKj5fRHkMDVQXkTQSjFX/+sLYMwaDPJCxrtck=;
        b=chfLHFAzHA7TsEUJ91Ruk9OVaXppiy3mf9EdScXz98gMuPdfTBJvpO7UVeQXnz+oRH
         a+tMQiKOE064qYPrKdPyQztFaFhpNsY20IaPCScOhKKqyZan00lGT81pYL1YqHVKm98+
         a8LwTpZr4uBF+ZtTXHgLRp7J4WWo/taU8hgJaDyGH1Gmu+HJQGn24uVtNV0fiNCp8sc2
         5WviyXjH8iR7E43keqbpzKSDpVAsPcyv66C8oGhJ9hSWHKSOEgEX5pIeGb8dM4v8E2pC
         c674nRcKTHDwEPTit3S9x+Tc7GaQkgYJnkFZmOl21piNKLDo3qMZnRpoKQykXKPjxl4E
         ZyyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711620590; x=1712225390;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=imitBWhKj5fRHkMDVQXkTQSjFX/+sLYMwaDPJCxrtck=;
        b=s4xhxWNAhubKH8rvxMi564Wen/Y8vEMqp3v+xArEu6iGqoGAfKvEGji9R6iD5dkZmA
         LiQnjKiP5z7CzgM9P/ubm4HUh8Xn8Nu6kCpy+xfnzs7J4rZGyJTX2E9t/PyjTDuWBxMX
         FwlA8MXAx2ubHXPyfCMqybabCwMxqpZUcuEJITW2cXGqeXIVbSj0fdRDK17M0bueAVq3
         oepyQ29Wb/Vc0zPAGcFLA7XMdnsheHdEvFGhvLVY4ACydpBgwqzEBLNC5KscPqiYzq61
         V1IdEOEzh1WS0eE1BoU6kd5fK3mnF/7BphQQ2/QZguLojf5r4P4ZvaalXtGd/FltjNXG
         ie6A==
X-Forwarded-Encrypted: i=1; AJvYcCVgGAprZxTiTe7KqaPVcQGMk5hUp+ZjWgge+rv3p9zH9Ink4JUzNsn0U80tmCDhbJmOa7lLPhZtQLBq8pojUaH8XoXZNuD/b30=
X-Gm-Message-State: AOJu0YxLdEX6THURgYUDwuyI4nDmUydRr0uO0SWh4cPnewkU7EGadr76
	JqMNjzWWHIR6ns6L8br4d+1HvTjqDWC7HViTIP+UmlUA9IkHMBmrwVrqErBeLV4fk0qJr4OHxZp
	3Y0yBDJ4We9NirZw9qP2R5yyQIg9E70j91Ss74A==
X-Google-Smtp-Source: AGHT+IGpKoND8Hj5asHhR1IyrNPyxjDoX5kHnPXJ6xOWXzDm76r5mfJyHm4FG7YdV4pX6SG8iYswIqPcbn2QxDOdpe0=
X-Received: by 2002:a17:90a:c78f:b0:29b:33eb:1070 with SMTP id
 gn15-20020a17090ac78f00b0029b33eb1070mr1940134pjb.14.1711620590360; Thu, 28
 Mar 2024 03:09:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240304201625.100619-1-christian.loehle@arm.com>
 <CAKfTPtDcTXBosFpu6vYW_cXLGwnqJqYCUW19XyxRmAc233irqA@mail.gmail.com> <92ecab7f-6e35-4e23-a8b7-097a9c26f551@arm.com>
In-Reply-To: <92ecab7f-6e35-4e23-a8b7-097a9c26f551@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 28 Mar 2024 11:09:39 +0100
Message-ID: <CAKfTPtDXnAHLhdT267roPugGkvNm6VtfqZt-d7d86bznBQKhpg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] Introduce per-task io utilization boost
To: Christian Loehle <christian.loehle@arm.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, juri.lelli@redhat.com, 
	mingo@redhat.com, rafael@kernel.org, dietmar.eggemann@arm.com, 
	vschneid@redhat.com, Johannes.Thumshirn@wdc.com, adrian.hunter@intel.com, 
	ulf.hansson@linaro.org, andres@anarazel.de, asml.silence@gmail.com, 
	linux-pm@vger.kernel.org, linux-block@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 25 Mar 2024 at 13:24, Christian Loehle <christian.loehle@arm.com> wrote:
>
> On 22/03/2024 18:08, Vincent Guittot wrote:
> > Hi Christian,
> Hi Vincent,
> thanks for taking a look.
>
> >
> > On Mon, 4 Mar 2024 at 21:17, Christian Loehle <christian.loehle@arm.com> wrote:
> >>
> >> There is a feature inside of both schedutil and intel_pstate called
> >> iowait boosting which tries to prevent selecting a low frequency
> >> during IO workloads when it impacts throughput.
> >> The feature is implemented by checking for task wakeups that have
> >> the in_iowait flag set and boost the CPU of the rq accordingly
> >> (implemented through cpufreq_update_util(rq, SCHED_CPUFREQ_IOWAIT)).
> >>
> >> The necessity of the feature is argued with the potentially low
> >> utilization of a task being frequently in_iowait (i.e. most of the
> >> time not enqueued on any rq and cannot build up utilization).
> >>
> >> The RFC focuses on the schedutil implementation.
> >> intel_pstate frequency selection isn't touched for now, suggestions are
> >> very welcome.
> >> Current schedutil iowait boosting has several issues:
> >> 1. Boosting happens even in scenarios where it doesn't improve
> >> throughput. [1]
> >> 2. The boost is not accounted for in EAS: a) feec() will only consider
> >>  the actual utilization for task placement, but another CPU might be
> >>  more energy-efficient at that capacity than the boosted one.)
> >>  b) When placing a non-IO task while a CPU is boosted compute_energy()
> >>  will not consider the (potentially 'free') boosted capacity, but the
> >>  one it would have without the boost (since the boost is only applied
> >>  in sugov).
> >> 3. Actual IO heavy workloads are hardly distinguished from infrequent
> >> in_iowait wakeups.
> >> 4. The boost isn't associated with a task, it therefore isn't considered
> >> for task placement, potentially missing out on higher capacity CPUs on
> >> heterogeneous CPU topologies.
> >> 5. The boost isn't associated with a task, it therefore lingers on the
> >> rq even after the responsible task has migrated / stopped.
> >> 6. The boost isn't associated with a task, it therefore needs to ramp
> >> up again when migrated.
> >> 7. Since schedutil doesn't know which task is getting woken up,
> >> multiple unrelated in_iowait tasks might lead to boosting.
> >>
> >> We attempt to mitigate all of the above by reworking the way the
> >> iowait boosting (io boosting from here on) works in two major ways:
> >> - Carry the boost in task_struct, so it is a per-task attribute and
> >> behaves similar to utilization of the task in some ways.
> >> - Employ a counting-based tracking strategy that only boosts as long
> >> as it sees benefits and returns to no boosting dynamically.
> >
> > Thanks for working on improving IO boosting. I have started to read
> > your patchset and have few comments about your proposal:
> >
> > The main one is that the io boosting decision should remain a cpufreq
> > governor decision and so the io boosting value should be applied by
> > the governor like in sugov_effective_cpu_perf() as an example instead
> > of everywhere in the scheduler code
> Having it move into the scheduler is to enable it for EAS (e.g. boosting
> a LITTLE to it's highest OPP often being much less energy-efficient than
> having a higher cap CPU at a lower OPP) and to enable higher capacities
> reachable on other CPUs, too.

sugov_effective_cpu_perf() is used by EAS when finding the final OPP
and computing the energy so I don't see a problem of moving the policy
(converting some iowait boost information into some performance level)
into the cpufreq governor. EAS should be able to select the more
efficient CPU for the waking task.
Furthermore, you add it into the utilization whereas iowait boost is
not a capacity that will be used by the task but like a minimum
bandwidth requirement to speedup its execution; This could be seen
like uclamp_min especially if you also want to use the iowait boosting
to migrate tasks. But I don't think that this is exactly the same.
Uclamp_min helps when a task has always the same amount of small work
to do periodically. Whatever the frequency, its utilization remains
(almost) the same and is not really expected to impact its period. In
the case of iowait boost, when you increase the frequency, the task
will do more work and its utilization will decrease (because the
overall periods will decrease). This increase of the utilization
should be the trigger for migrating the task on another CPU.

> I guess for you the first one is the more interesting one.
>
> >
> > Then, the algorithm to track the right interval bucket and the mapping
> > of intervals into utilization really looks like a policy which has
> > been defined with heuristics and as a result further seems to be a
> > governor decision
>
> I did have a comparable thing as a governor decision, but the entire
> "Test if util boost increases iowaits seen per interval and only boost
> accordingly" really only works if the interval is long enough, my proposed
> starting length of 25ms really being the lower limit for the storage devices
> we want to cover (IO latency not being constant and therefore iowaits per
> interval being somewhat noisy).

Your explanation above confirms that it's a policy for your storage devices.

> Given that the IO tasks will be enqueued/dequeued very frequently it just
> isn't credible to expect them to land on the same CPU for many intervals,
> unless your system is very bare-bones and idle, but even on an idle Android
> I see any interval above 50ms to be unusable and not provide any throughput
> improvement.
> The idea of tracking the iowaits I do find the best option in this vague and
> noisy environment of "iowait wakeups" and definitely worth having, so that's
> why I opted for it being in the scheduler code, but I'd love to hear your
> thoughts/alternatives.

There is 3 parts in your proposal
1- tracking per task iowait statistics
2- translate that into a capacity more than an utilization
3- use this value in EAS

Having 1- in the scheduler seems ok but 2- and 3- should not be
injected directly into the scheduler



> I'd also like an improvement on the definition of iowait or some more separate
> flag for boostable IO, the entire "boost on any iowait wakeup" is groping in
> the dark which I'm trying to combat, but it's somewhat out of scope here.
>
> >
> > Finally adding some atomic operation in the fast path is not really desirable
> Agreed, I'll look into it, for now I wanted as much feedback on the two major
> changes:
> - iowait boost now per-task
> - boosting based upon iowaits seen per interval
>
> >
> > I will continue to review your patchset
>
> Thank you, looking forward to seeing your review.
>
> >>[snip]
> Kind Regards,
> Christian

