Return-Path: <io-uring+bounces-1203-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28202889676
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 09:52:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D34AD29890E
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 08:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A012F14B071;
	Mon, 25 Mar 2024 05:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=layalina-io.20230601.gappssmtp.com header.i=@layalina-io.20230601.gappssmtp.com header.b="WILBVUsc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4590815572C
	for <io-uring@vger.kernel.org>; Mon, 25 Mar 2024 02:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711333258; cv=none; b=IhzwHE1aEyNgpqpqWLV42W2CxJcxBlMuWXvUdTjENNPCu8WvxCj16MDEFJAb9PdWGAGM6s8wXtwDn3P1nB75Gyz7ACoDh3XXn6viiuo+wEsc7WyV/aXW7ol2jEe8pHebOXHjDEP+othdGtHcrAyCe6blBsVPV5fAcXsZjgtsZp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711333258; c=relaxed/simple;
	bh=a+5IO4bzkKk2FkrhKzrSPkAfIMWaw9+PBv6OhA8Vg0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pK5iXiDvB/dltBlXvb0+DmcEUnCiwQRycL32PeEz5T1Q2dQKLh+FsQ+ry6PlS4zmzkxgEtdB2H6wvwM3AGy7PF8pl2AYhjbwosrXLTbcm5yaANw/zk4Zjf3ar+IPCchJtzOEs2hnS4tL/bug8WWVf++GDwpJoWsyvnhm/fXY0eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=layalina.io; spf=pass smtp.mailfrom=layalina.io; dkim=pass (2048-bit key) header.d=layalina-io.20230601.gappssmtp.com header.i=@layalina-io.20230601.gappssmtp.com header.b=WILBVUsc; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=layalina.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=layalina.io
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-34005b5927eso2758997f8f.1
        for <io-uring@vger.kernel.org>; Sun, 24 Mar 2024 19:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20230601.gappssmtp.com; s=20230601; t=1711333253; x=1711938053; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3KYX5sN4/DQ0Ca+C7M+8tiNgEQ0vWfJgF6O4xHUhDV4=;
        b=WILBVUschp4CuVlN7IxfSSbcekKRUxY843c89N9f2TXzUAxcWfnvMLRYTeQyhll7UU
         fCEgVNTdjGNu3DzFmMDtsctqbTWpbgMTn73fXjf0alNQEHwUD41hmK3tVxa4UYRJOUo+
         m/jg4z0sXsuTfv4Cipozh/mGU8iH2flLHKj5ivZ7iiFqKTN9oZGGDupI7GTCaF3AsQKD
         d/WpSTOTL8kgJDsYCm7gB8gAlVcLID3ax6mFZVt/g0/v3Os0fepbMdbVh1OWrTCwlP9T
         2Ze4VF067ykKFmEdba6UQSixO1BJ2zZ7/f2bY11gN9fFq8DU60UYMiz1wQ98k12imiTs
         ijYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711333253; x=1711938053;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3KYX5sN4/DQ0Ca+C7M+8tiNgEQ0vWfJgF6O4xHUhDV4=;
        b=wfzr4LSFzHmA48InLHF2tWIEU1iXo998ikb5bxPiBYvBjBVTGDb8w75GWjV0NMKNsD
         LhlCOxYjmfMmYnKJ78uEqlBbjGCQ+/2oGwhOvPbHzEQkL5pqz6BZQg/KlSeRPoCXuebf
         KYAfTlHEE4Fyqrda0xuY4X5Y1U6fYZqDDH6Q2Qb+a8JUXnlHNG3A1IUM8u/hDWyVG92o
         wIOoh4taxpB3G2cSyrIaA/35TCs6ILMeqAPwz2QfeR4HQJH2MegGHfUTtvtz6a9CzUVU
         ShQMZ7bnLBnE6E9Ndni5HrmpPxBN/xuHBW6yjPqof1O6q7tKFsBuHpCIBIIG0qc1jgBb
         yONQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOyju7FBYxEvncLqQlydiMuVA4Lq/4RhkvQyUtLinikJMNu+F7pLdZMkh/WBzL0MIfQZ0cEQrQy2oijR7/av/YTCE7WVNm1G4=
X-Gm-Message-State: AOJu0YzS2kWVyEaeNB0cgpjldgYeS348qrgLeOXPQ3AtK6Ptur/lRYSt
	1ysBmDoVJB1bBUQHUECUbIsgQTqp8Rv1nnlEhHHFXZDq1yP1sKrnDKF6CB4ar7o=
X-Google-Smtp-Source: AGHT+IEGylOZLmAkTa4hEo69V3BZPeCBsFyo1QAQu5pjIFuYSIkRj6IiZDL9UF3nVTOfhI5RA3UbGw==
X-Received: by 2002:adf:f241:0:b0:33e:78c4:3738 with SMTP id b1-20020adff241000000b0033e78c43738mr3519996wrp.54.1711333253412;
        Sun, 24 Mar 2024 19:20:53 -0700 (PDT)
Received: from airbuntu (host81-157-90-255.range81-157.btcentralplus.com. [81.157.90.255])
        by smtp.gmail.com with ESMTPSA id t17-20020a0560001a5100b0033dd2c3131fsm8095566wry.65.2024.03.24.19.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Mar 2024 19:20:52 -0700 (PDT)
Date: Mon, 25 Mar 2024 02:20:51 +0000
From: Qais Yousef <qyousef@layalina.io>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Christian Loehle <christian.loehle@arm.com>,
	linux-kernel@vger.kernel.org, peterz@infradead.org,
	juri.lelli@redhat.com, mingo@redhat.com, rafael@kernel.org,
	dietmar.eggemann@arm.com, vschneid@redhat.com,
	Johannes.Thumshirn@wdc.com, adrian.hunter@intel.com,
	ulf.hansson@linaro.org, andres@anarazel.de, asml.silence@gmail.com,
	linux-pm@vger.kernel.org, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Introduce per-task io utilization boost
Message-ID: <20240325022051.73mfzap7hlwpsydx@airbuntu>
References: <20240304201625.100619-1-christian.loehle@arm.com>
 <CAKfTPtDcTXBosFpu6vYW_cXLGwnqJqYCUW19XyxRmAc233irqA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKfTPtDcTXBosFpu6vYW_cXLGwnqJqYCUW19XyxRmAc233irqA@mail.gmail.com>

(piggy backing on this reply)

On 03/22/24 19:08, Vincent Guittot wrote:
> Hi Christian,
> 
> On Mon, 4 Mar 2024 at 21:17, Christian Loehle <christian.loehle@arm.com> wrote:
> >
> > There is a feature inside of both schedutil and intel_pstate called
> > iowait boosting which tries to prevent selecting a low frequency
> > during IO workloads when it impacts throughput.
> > The feature is implemented by checking for task wakeups that have
> > the in_iowait flag set and boost the CPU of the rq accordingly
> > (implemented through cpufreq_update_util(rq, SCHED_CPUFREQ_IOWAIT)).
> >
> > The necessity of the feature is argued with the potentially low
> > utilization of a task being frequently in_iowait (i.e. most of the
> > time not enqueued on any rq and cannot build up utilization).
> >
> > The RFC focuses on the schedutil implementation.
> > intel_pstate frequency selection isn't touched for now, suggestions are
> > very welcome.
> > Current schedutil iowait boosting has several issues:
> > 1. Boosting happens even in scenarios where it doesn't improve
> > throughput. [1]
> > 2. The boost is not accounted for in EAS: a) feec() will only consider
> >  the actual utilization for task placement, but another CPU might be
> >  more energy-efficient at that capacity than the boosted one.)
> >  b) When placing a non-IO task while a CPU is boosted compute_energy()
> >  will not consider the (potentially 'free') boosted capacity, but the
> >  one it would have without the boost (since the boost is only applied
> >  in sugov).
> > 3. Actual IO heavy workloads are hardly distinguished from infrequent
> > in_iowait wakeups.
> > 4. The boost isn't associated with a task, it therefore isn't considered
> > for task placement, potentially missing out on higher capacity CPUs on
> > heterogeneous CPU topologies.
> > 5. The boost isn't associated with a task, it therefore lingers on the
> > rq even after the responsible task has migrated / stopped.
> > 6. The boost isn't associated with a task, it therefore needs to ramp
> > up again when migrated.
> > 7. Since schedutil doesn't know which task is getting woken up,
> > multiple unrelated in_iowait tasks might lead to boosting.

You forgot an important problem which what was the main request from Android
when this first came up few years back. iowait boost is a power hungry
feature and not all tasks require iowait boost. By having it per task we want
to be able to prevent tasks from causing frequency spikes due to iowait boost
when it is not warranted.

> >
> > We attempt to mitigate all of the above by reworking the way the
> > iowait boosting (io boosting from here on) works in two major ways:
> > - Carry the boost in task_struct, so it is a per-task attribute and
> > behaves similar to utilization of the task in some ways.
> > - Employ a counting-based tracking strategy that only boosts as long
> > as it sees benefits and returns to no boosting dynamically.
> 
> Thanks for working on improving IO boosting. I have started to read
> your patchset and have few comments about your proposal:
> 
> The main one is that the io boosting decision should remain a cpufreq
> governor decision and so the io boosting value should be applied by
> the governor like in sugov_effective_cpu_perf() as an example instead
> of everywhere in the scheduler code.

I have similar thoughts.

I think we want the scheduler to treat iowait boost like uclamp_min, but
requested by block subsystem rather than by the user.

I think we should create a new task_min/max_perf() and replace all current
callers in scheduler to uclamp_eff_value() with task_min/max_perf() where
task_min/max_perf()

unsigned long task_min_perf(struct task_struct *p)
{
	return max(uclamp_eff_value(p, UCLAMP_MIN), p->iowait_boost);
}

unsigned long task_max_perf(struct task_struct *p)
{
	return uclamp_eff_value(p, UCLAMP_MAX);
}

then all users of uclamp_min in the scheduler will see the request for boost
from iowait and do the correct task placement decision. Including under thermal
pressure and ensuring that they don't accidentally escape uclamp_max which I am
not sure if your series caters for with the open coding it. You're missing the
load balancer paths from what I see.

It will also solve the problem I mention above. The tasks that should not use
iowait boost are likely restricted with uclamp_max already. If we treat iowait
boost as an additional source of min_perf request, then uclamp_max will prevent
it from going above a certain perf level and give us the desired impact without
any additional hint. I don't think it is important to disable it completely but
rather have a way to prevent tasks from consuming too much resources when not
needed, which we already have from uclamp_max.

I am not sure it makes sense to have a separate control where a task can run
fast due to util but can't have iowait boost or vice versa. I think existing
uclamp_max should be enough to restrict tasks from exceeding a performance
limit.

> 
> Then, the algorithm to track the right interval bucket and the mapping
> of intervals into utilization really looks like a policy which has
> been defined with heuristics and as a result further seems to be a
> governor decision

Hmm do you think this should not be a per-task value then Vincent?

Or oh, I think I see what you mean. Make effective_cpu_util() set min parameter
correctly. I think that would work too, yes. iowait boost is just another min
perf request and as long as it is treated as such, it is good for me. We'll
just need to add a new parameter for the task like I did in remove uclamp max
aggregation serires.

Generally I think it's better to split the patches so that the conversion to
iowait boost with current algorithm to being per-task as a separate patch. And
then look at improving the algorithm logic on top. These are two different
problems IMHO.

One major problem and big difference in per-task iowait that I see Christian
alluded to is that the CPU will no longer be boosted when the task is sleeping.
I think there will be cases out there where some users relied on that for the
BLOCK softirq to run faster too. We need an additional way to ensure that the
softirq runs at a similar performance level to the task that initiated the
request. So we need a way to hold the cpufreq policy's min perf until the
softirq is serviced. Or just keep the CPU boosted until the task is migrated.
I'm not sure what is better yet.

> 
> Finally adding some atomic operation in the fast path is not really desirable

Yes I was thinking if we can apply the value when we set the p->in_iowait flag
instead?

