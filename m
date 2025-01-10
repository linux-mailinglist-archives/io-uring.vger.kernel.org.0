Return-Path: <io-uring+bounces-5807-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1A2DA09458
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 15:54:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC8AA165BDC
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 14:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FAA9211700;
	Fri, 10 Jan 2025 14:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VneXnBlT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA352210F65
	for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 14:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736520807; cv=none; b=LjaATQk+sKopOrOwhz6X2ZgcpMOYe972IV3LTPeDriMyKeTHEdm5hDWUqRUEE37bBHA+2VM5qefCPCj94eF2mZdYSe3u8FjCXfiDV3mlmOy7QdmL9JbL5NwKPlLUwi5bgMxgOQzsDmke4rQn6RykdyCPE99vtPfEoMHeoWfSeRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736520807; c=relaxed/simple;
	bh=wEICEznzeBn54+HmyvWGe3Usp52h47MPHLiXWPJTgyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=X1+JqWaLR/Uc4TIURlYhOiiTA5R8oC1dn9eCd7bvJOQKUJljvRl0fkKgqNjF8sjDcgn0bs+7N1yrzg1kb0Sh5+pXtOm1TEndMyrpoAgxoxOzKeuSh7c2nylHHtTRh/zTm2XLvF6+RlfR/L2AvHkYsSNKTtlrfmPok++VywbC3HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VneXnBlT; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3a9d9c86920so5177515ab.2
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 06:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736520804; x=1737125604; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fkJYW1Ot4J418dYXoH3AucYO/ipZbvvVI2LkVTZ6Img=;
        b=VneXnBlT5K1zz1dA9VhJTCNzVqp7RBjYwHk3bmef2sbiP9W4Smpf6BWUAUwrW/f1Sg
         6pdoYIcd/Dv/iDXUjQ4yzGwbyQLCQoDv2DlgBRL5xH6VE6SKYEQ1rJtSg2Ni6EXiQ8cv
         xjsfvOc35NqpQI5kqDHB4mzsfU8+mDudFWWLXJ+TUmspgSJg8uR+jDqDQUfdIbKmGXjs
         BEcVoT2EoAupf/9IbOo+z2faH06L8rb3Rnov9dIx6/Q5vfChHctq1tdx3EzIKsWpRDlM
         AI0y6JhaADHU8D4AjPw0rGN2kx52iter2S5+STzSRnmKGsaXRq9FjqtN0bY0sqMYI1tt
         HSIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736520804; x=1737125604;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fkJYW1Ot4J418dYXoH3AucYO/ipZbvvVI2LkVTZ6Img=;
        b=SMkjgKZt59PWcVjvAzuDmW8fVFVMcyEmPpR/jMNyUbAVhG42rL941WNpmASkhG0zUc
         dMeZRPYskRjA9rm7FFA6UWcK2OuzuXdxVx9XhT9KhgPX4O/TKGSDgbIv5aq7iYAZFszu
         yojetKbHI1sS2fPVXbBEMS12W0+orH3I103f3hCa7APe/RqePzmqVZf6q+gGh30BeL+U
         eM2QHySPx62avsnppRrGbRYt9z4GlbahHk+Xd/ObRMQJDvKz8wDrWI1/isLinqhjTEpx
         LLNsaLdYZVRWuMIxe5B+whTocSzfvX4ACMWaHBz3KzZ7IRJHEekZX9yCxY/0DgdGjLRl
         dAhA==
X-Forwarded-Encrypted: i=1; AJvYcCWWk/1nL7xXrH7N8yMxvYJOREJKsMevXKboubCHiTxssZG8oY+1JwrzKSyjP6m8rTwJwHjT/74kxg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyilwhhpbowt6PBtsqd51Juyy+Y6IZUUwFdMQchrjvAa3N8iF6y
	DrY93YQE77Rx/gduR58r6CfSQay8UQI89E3Cs4lPYD/QKEWWfNupPP3AR0AFOU7ctF5+3MURXl7
	e
X-Gm-Gg: ASbGncvkr1GmgTiwycRprM1NJDE/weErhLvlkFCakzmpPn1LuNRuBqthaRGDK3DZc7A
	lVsokRdrpn2ApPkDgo0J3NKMdD5ogeM1sZrimDzLROvIKRkGzYcofvB1eHoFhG9hYncHojD7VBQ
	bqvZrufwjfdVrcX749OE1o7qf3PDK64Co7761Du7e59Z8H+UBNlgRnZTsX8IpOcSdDySfP+A8nd
	SRNYPxo6uE+9K62ss4yk1D6P5R2qc1tva0A5MZZum0aKFjQM2s7
X-Google-Smtp-Source: AGHT+IFsqAIGBNXBvtp0vMlwo5bVhIzDUuThW6pBSQ8e8+UhqqXYtMqZLRk4RUB0u7pkvIlvrzx9bA==
X-Received: by 2002:a05:6e02:1b08:b0:3ce:61a3:8647 with SMTP id e9e14a558f8ab-3ce61a387b7mr1685625ab.11.1736520803745;
        Fri, 10 Jan 2025 06:53:23 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b7459e9sm922576173.118.2025.01.10.06.53.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 06:53:23 -0800 (PST)
Message-ID: <8a0eb82a-52b3-436c-85fe-86a6a1ebbf2b@kernel.dk>
Date: Fri, 10 Jan 2025 07:53:22 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug? CQE.res = -EAGAIN with nvme multipath driver
To: "Haeuptle, Michael" <michael.haeuptle@hpe.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <DS7PR84MB31105C2C63CFA47BE8CBD6EE95102@DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM>
 <fe2c7e3c-9cec-4f30-8b9b-4b377c567411@kernel.dk>
 <da6375f5-602f-4edd-8d27-1c70cc28b30e@kernel.dk>
 <8330be7f-bb41-4201-822b-93c31dd649fe@kernel.dk>
 <df4c7e5a-8395-4af9-ad87-2625b2e48e9a@kernel.dk>
 <IA1PR84MB310838E47FDAAFD543B8239A95112@IA1PR84MB3108.NAMPRD84.PROD.OUTLOOK.COM>
 <4c531b2d-c852-4a33-bed6-b8bbc3393f98@kernel.dk>
 <DS7PR84MB31106A2E2315A53CFA33B2B495132@DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <DS7PR84MB31106A2E2315A53CFA33B2B495132@DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/9/25 11:09 AM, Haeuptle, Michael wrote:
> Hey Jens, sorry for the late response.
> 
> I was unable to reproduce the issue with your branch. However, I
> didn't even hit the spot where same_thread_group check was removed.

Might be a driver side issue too on the nvme front, if it no longer hits
the retry path as much.

> We backported your changes to 6.1.119 and we did see that our original
> issue is fixed with your patches.
> 
> It seems to me that io_uring performance increased quite a bit in the
> latest kernel, judging from fio queue utilization of my workload.
> Maybe that's why I'm not hitting the place where same_thread_group was
> removed.

We do try and improve performance all the time, but most likely this is
caused by the same effect that reduces the reissue attempts as well.

> Your patch didn't cause any regression after 1d testing in my
> NVMF/RDMA & multipath setup. So, I think it would be good to get this
> patch on main.

Queued up, thanks for testing.

-- 
Jens Axboe

