Return-Path: <io-uring+bounces-825-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 774C3871191
	for <lists+io-uring@lfdr.de>; Tue,  5 Mar 2024 01:20:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A659E1C216C4
	for <lists+io-uring@lfdr.de>; Tue,  5 Mar 2024 00:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A345647;
	Tue,  5 Mar 2024 00:20:09 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CB338F;
	Tue,  5 Mar 2024 00:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709598009; cv=none; b=dmtf132D2qTG54L2rbJ1MWcKAcfIFN+rRH9jRcfMefnAQ1QbGA9UrmpFpVKxhYfMgHXPocxsF3GFwHFLsRrw/ncQCDHfRbRz/94raECYTQDAXpslzQb9ZozgRwdPSS9Q56Jb1rxGj1g02k79o0NLZVE5dDwcR/FVLb2p68mn42s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709598009; c=relaxed/simple;
	bh=n2iJRsp0wDisq9D8A56Nk0XQND53SVEzey0fC0b0eoA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TfyIH01cLm9EnldVxllm24xxqtzdl/FJV0C1WdP71Lgyj9wdSCustdc1UYZZIMs1xfGFT4Hlm5udhfx9K64mRqrPB23BtQa0Y2wTtpD/imqUKhLbwjajjOVPh80Ht3r4tiinLH86FUYt5Srw1lpBhP6cQIMNE/eyF2lBtfGhlVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d944e8f367so34723125ad.0;
        Mon, 04 Mar 2024 16:20:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709598007; x=1710202807;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cThLIQ7kVxrLe0hSQIUMvSBEyZArR8R8aoZjQ4ZGD9Y=;
        b=was2wiNeEz3ikHkDbBksGf5yMmRdYmVqVM4mu7xJlO4oPr6IefrML0XBo3xdlJ8hD/
         lFTMEU3VQV+fKnr+MDM3Ne4aWsf7O1s6TfH8A4jKZzHr/ZDSDKH2zpr9emaFNqkNUxe2
         fTFIBa6SuCPQ8ZDxBtds1LuOACLJZeeqMxNKL8d9KkY1AwYkgNkVxDB1H1MO5snhknb7
         zGwoUtCcvXFt3G0WGoPRZ6P25fnNZ4TGp4GG4SEUtGJZxi58fAryhDEf5QctkvFuklxY
         LYRJCp9TdjfvV1t71viqA96ZSc9NuJpKxbPnd/S3VSY4P1OAwUy8n13H9OdiucA2l3Dx
         Y03Q==
X-Forwarded-Encrypted: i=1; AJvYcCWo5yZ2rqTsNvmWjDrXOE3bp+6qWFBFUTDTKCLUG6dJlKUyKPPodDg6g1fcFEfFnpMM106QVBNdsDFPnBTdB5EVLf3xhNZszHhjCXhQHaeyqRyGRpjCBGLb6izavl/+fj4i7clEkrYqhulxSvJVSsr3+W9shsUYR0N4SoJBZGZBAzpluy9JT06UJ9n2ucHlCQKMRXhJjBRajvSGMyNl
X-Gm-Message-State: AOJu0YxWKbf4rfs9qmSbZJ8rwm7NLQwvIB/HkbPYbpK4ApFE1eLM3c5+
	I0raVJn8zAHcuJTOlSObgFuoY7k5P2/tacZqqlfsly/2sVb0/MzVKslNXvLk
X-Google-Smtp-Source: AGHT+IGBK4qsXJ6u6xsgg6YtuRQ4ARl1MW9KjGEbxUYd3grb5H4MLJb1AFN9dYWTVfSXWKh/RmLRuw==
X-Received: by 2002:a17:902:d50b:b0:1dc:d773:ac with SMTP id b11-20020a170902d50b00b001dcd77300acmr381569plg.7.1709598006843;
        Mon, 04 Mar 2024 16:20:06 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:9ba8:35e8:4ec5:44d1? ([2620:0:1000:8411:9ba8:35e8:4ec5:44d1])
        by smtp.gmail.com with ESMTPSA id b6-20020a170902d50600b001dd0d07b3d8sm3298602plg.201.2024.03.04.16.20.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 16:20:06 -0800 (PST)
Message-ID: <86f0af00-8765-4481-9245-1819fb2c6379@acm.org>
Date: Mon, 4 Mar 2024 16:20:03 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] Introduce per-task io utilization boost
Content-Language: en-US
To: Christian Loehle <christian.loehle@arm.com>, linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, juri.lelli@redhat.com, mingo@redhat.com,
 rafael@kernel.org, dietmar.eggemann@arm.com, vschneid@redhat.com,
 vincent.guittot@linaro.org, Johannes.Thumshirn@wdc.com,
 adrian.hunter@intel.com, ulf.hansson@linaro.org, andres@anarazel.de,
 asml.silence@gmail.com, linux-pm@vger.kernel.org,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org,
 Qais Yousef <qyousef@layalina.io>
References: <20240304201625.100619-1-christian.loehle@arm.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240304201625.100619-1-christian.loehle@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/24 12:16, Christian Loehle wrote:
> Pixel 6 ufs Android 14 (7 runs for because device showed some variance)
> [6605, 6622, 6633, 6652, 6690, 6697, 6754] sugov mainline
> [7141, 7173, 7198, 7220, 7280, 7427, 7452] per-task tracking
> [2390, 2392, 2406, 2437, 2464, 2487, 2813] sugov no iowait boost
> [7812, 7837, 7837, 7851, 7900, 7959, 7980] performance governor

Variance of performance results for Pixel devices can be reduced greatly
by disabling devfreq scaling, e.g. as follows (this may cause thermal
issues if the system load is high enough):

      for d in $(adb shell echo /sys/class/devfreq/*); do
	adb shell "cat $d/available_frequencies |
		tr ' ' '\n' |
		sort -n |
		case $devfreq in
			min) head -n1;;
			max) tail -n1;;
		esac > $d/min_freq"
     done

> Showcasing some different IO scenarios, again all random read,
> median out of 5 runs, all on rk3399 with NVMe.
> e.g. io_uring6x4 means 6 threads with 4 iodepth each, results can be
> obtained using:
> fio --minimal --time_based --name=test --filename=/dev/nvme0n1 --runtime=30 --rw=randread --bs=4k --ioengine=io_uring --iodepth=4 --numjobs=6 --group_reporting | cut -d \; -f 8

So buffered I/O was used during this test? Shouldn't direct I/O be used
for this kind of tests (--buffered=0)? Additionally, which I/O scheduler
was configured? I recommend --ioscheduler=none for this kind of tests.

> - Higher cap is not always beneficial, we might place the task away
> from the CPU where the interrupt handler is running, making it run
> on an unboosted CPU which may have a bigger impact than the difference
> between the CPU's capacity the task moved to. (Of course the boost will
> then be reverted again, but a ping-pong every interval is possible).

In the above I see "the interrupt handler". Does this mean that the NVMe
controller in the test setup only supports one completion interrupt for
all completion queues instead of one completion interrupt per completion
queue? There are already Android phones and developer boards available
that support the latter, namely the boards equipped with a UFSHCI 4.0 
controller.

Thanks,

Bart.

