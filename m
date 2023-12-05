Return-Path: <io-uring+bounces-244-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0D038062C4
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 00:12:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96B621F21764
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 23:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81CC6405EA;
	Tue,  5 Dec 2023 23:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zWPF9flz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2B21AA
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 15:11:45 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1d03f90b0cbso11763155ad.1
        for <io-uring@vger.kernel.org>; Tue, 05 Dec 2023 15:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701817905; x=1702422705; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FzHfEtanc3DWUPQKxwHeD6sP3ILtMAzdMo7iK6zqngo=;
        b=zWPF9flz3i1dfydzyx1Z8lhtIYcr/e2zL1UngEl27d25jRswOTE17/oVjf48u9wrC5
         9a8o86Nz8HR+NXF+gpSBcOD1zDhN7U2ttd21kbxmHkEGXjdKYcrekeBQyNr1nJBFF94a
         L//Q5Ls+sD5cal5VPGyt0L1vzswYut4f1x4F+2/gR+jPGlBIJAntLvLNYYtLfFZ4H/9f
         L9JekOTrIdDPyeht29EtDsaoKKMN4Zc10NnogKx6S3qhoypGRObrcEJjceI+OGHy8FMw
         fRYAuggF5122Ljz7S7k1Gz+hMtNMikShdJ4ruaT0Vyq/k/cXDHON9oV3cg0yc3Bwa+73
         B1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701817905; x=1702422705;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FzHfEtanc3DWUPQKxwHeD6sP3ILtMAzdMo7iK6zqngo=;
        b=t0JhWbcCnhloln6Kkn5qmRyqTIlDr0fVXOgqq42+o7Z/bJQUrU7cAAbeQSwfvFr++r
         KD5gUNrbgrBiwtOViejKPRxpf+h1gAnkolmPKgu1L99m5wGl9gaYMfvssOAhwJHf0Hsm
         zKbDvJe13HxKJx8FTN4bb3d1tWnaGSvNV1TrNVHXUVsHmTfKYFpwfmluheFsaD3w1w+W
         eOCrGtsuHehFCzMM+H0oFSRTfVatAQ57Ai7O3vf13y6HAeZ2BQ5l3MB1HoyMLeDXD31F
         QplMOR+8jR2SBjjgqRnT9Ez+Yt5bG8FUKsDihScbt4maIIcHxXVnJB5bMX9ui7XRHbdi
         xAeA==
X-Gm-Message-State: AOJu0Yx5gf3OJ94Xr2GhMGRZRmN7cWDm5amO4UNvXDZ0zfhfWXIKgDFv
	Iw3WniN0dwZaWOubB5R3IvNPeg==
X-Google-Smtp-Source: AGHT+IGhwMVeUczYgtmNJ5mhA7/x0z2uWs5xQhBaiCd2Cc6G9Vk6H0FpQt8QPFOHf8ETehucNRJfTA==
X-Received: by 2002:a17:902:7b87:b0:1d0:b6ca:3dda with SMTP id w7-20020a1709027b8700b001d0b6ca3ddamr5643578pll.2.1701817904931;
        Tue, 05 Dec 2023 15:11:44 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id iw13-20020a170903044d00b001bf52834696sm8868530plb.207.2023.12.05.15.11.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 15:11:44 -0800 (PST)
Message-ID: <9aa4aa06-7cc8-4a64-821f-1a00eff9cc9a@kernel.dk>
Date: Tue, 5 Dec 2023 16:11:43 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: save repeated issue_flags
Content-Language: en-US
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
 asml.silence@gmail.com
References: <20231205215553.2954630-1-kbusch@meta.com>
 <43ff7474-5174-4738-88d9-9c43517ae235@kernel.dk>
 <ZW-sE1hOG4EB3ktS@kbusch-mbp>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZW-sE1hOG4EB3ktS@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/5/23 4:02 PM, Keith Busch wrote:
> On Tue, Dec 05, 2023 at 03:00:52PM -0700, Jens Axboe wrote:
>>>  		if (!file->f_op->uring_cmd_iopoll)
>>>  			return -EOPNOTSUPP;
>>> -		issue_flags |= IO_URING_F_IOPOLL;
>>>  		req->iopoll_completed = 0;
>>>  	}
>>>  
>>> +	issue_flags |= ctx->issue_flags;
>>>  	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
>>>  	if (ret == -EAGAIN) {
>>>  		if (!req_has_async_data(req)) {
>>
>> I obviously like this idea, but it should be accompanied by getting rid
>> of ->compat and ->syscall_iopoll in the ctx as well?
> 
> Yeah, I considered that, and can incorporate it here. Below is a snippet
> of what I had earlier to make that happen, but felt the purpose for the
> "issue_flags" was uring_cmd specific and disconnected from everyone
> else. Maybe I'm overthinking it...

I'd just do a patch 2 that does compat and syscall_iopoll. And then if
we ever have a new issue flags (as your other series), then it'd become
natural to add that flag too.

It's not a hard requirement, but it's somewhat ugly to have the same
state in two spots. Which is why I'd prefer if we got rid of the actual
compat/syscall_iopoll members as well, after the conversion is done.

-- 
Jens Axboe


