Return-Path: <io-uring+bounces-1945-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 165728CB413
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 21:11:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 478AE1C20ACE
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 19:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FEE32AE6C;
	Tue, 21 May 2024 19:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="13YyVTUf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D156EB41
	for <io-uring@vger.kernel.org>; Tue, 21 May 2024 19:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716318715; cv=none; b=NN1G+CnkIauu2uD4FWqZjaaBO4V1yDbITo+g8xbiySCuxH4kv9bmXprga2TIlsaEzEO4Mp7TT6rNb9IIPb6Jai2Ccxr6XnI7sRZ2ZEyNBh4uPM6MVi48ZHOhr5Na7RNUG3mGwg26mAd8iNxGUYgx+oTgHKExFR2wEiiObgCfqGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716318715; c=relaxed/simple;
	bh=W4KBY+3wFgc33kZ7ocw1X4OcJKutAsZN9ixLcTINEEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U1T9Rk4D3i5NhSlohnPcPFMFIMouWp5kPvoj2VddzLkG+SS97DEI3Ow1ufKPS5jupt4b7LDmobtdmAMa6e/uDxr/jbMhzPL47BKR9G1H/TteDPV07mO6Qk/yn940SrNKH1Aumc+PM8DTwy9Obrcw3wU7KkbqL88VafgtS5oTq1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=13YyVTUf; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-36dbdb1caf3so1312735ab.2
        for <io-uring@vger.kernel.org>; Tue, 21 May 2024 12:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716318712; x=1716923512; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2R1lZ7cvE4ys+41YejloGdUV0GMIOF3sFj6PoCbWqgw=;
        b=13YyVTUfdbh3JVyepKfhAHV0WB6XuK5hpGt2UIHUEafipn/G1exrYlE+lkOkRCk8fo
         KI6bXpp7SX/f+FB5IAn/Ebcbhw8ueh7JFWXM2UN8IuLMjw0c30as6+qNcBtpKbSRu2HX
         FRkYAVAL6NB3rklATCCFInAPMk4xgxGNAOQWp0fpaZdPi+zagOBpQibFPyfpANttycr8
         ooVFW/SBA4g/ef/ZbzPJqJhNiLsMnF+IEB1jz9k7A41/cB+Ms/si5RBgQuBKug7Dsfse
         N411U53Slg3ryMXozVu2Eq0meuvXbRt35etMubXJwluPijKZ9WE9xqjZgJYBjQ3W0rOB
         Favw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716318712; x=1716923512;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2R1lZ7cvE4ys+41YejloGdUV0GMIOF3sFj6PoCbWqgw=;
        b=Xqiw+UQK4GudXAL4LJJSt1MF70Wj+he/TV02KnrWXt/AZPVgAhKrlCEev3UXnJnxmP
         pfvsJZF90m3TLw3ukDw7A6IVk+g2rhUarH0HL+thakpthcAdb7+O4JW+dvKhAU7b/381
         yHkwy84/wZC4k3tcq+TMfjkRo8mIxdsQKKbXsfEocN+DAGwgBg9LDz6b8Bmkj1HjxHlE
         MZ/KL/2Fm2bfasPHNGkD2h4M5oqQ+OPqR539f5GW9typmGpKLDcUM3oCVg/PNz5mFwZC
         8Bbi6gajLLjcYRmoUU7dnGGAb+PAM3lmeZOU+bHYkImM6qAhHXhUW8QFFjrma92ssaWx
         fNhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTU4BCUk3wbWMBk3bH0vZcpucaprdvVBRA2xyOIDj8O1VBzr3vnvrAcG/8fLehZU2taAz+EhNcvZK2Z0Iv+YgM5+xtquDc27w=
X-Gm-Message-State: AOJu0Yw51rUSxeYxOFsNj54Bs88Ai8ZpRhISeM86g6lHgByLjQcSnajX
	Rl2B1wU1ClzrKtCn2sL1KSmeiJqb0yunZ9KIfLwoCIcDMC2HUvGJBj4ZkfkRMlU=
X-Google-Smtp-Source: AGHT+IHMEI/NQlnj7qN5dyCM8kuLceJZQOhDuwzGeMbyVpzUYD2D5aem2PyaYHQ9VB3USbFeb4ppbg==
X-Received: by 2002:a05:6e02:1aa1:b0:36d:cdc1:d76c with SMTP id e9e14a558f8ab-36dcdc1d784mr139275585ab.0.1716318712300;
        Tue, 21 May 2024 12:11:52 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-36cceab150bsm56029305ab.10.2024.05.21.12.11.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 May 2024 12:11:51 -0700 (PDT)
Message-ID: <c7b07540-e204-4863-8b90-a96dfb4129e5@kernel.dk>
Date: Tue, 21 May 2024 13:11:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] ETXTBSY when running Yarn (Node) since af5d68f
To: Christian Heusel <christian@heusel.eu>
Cc: Andrew Udvare <audvare@gmail.com>, regressions@lists.linux.dev,
 io-uring <io-uring@vger.kernel.org>
References: <313824bc-799d-414f-96b7-e6de57c7e21d@gmail.com>
 <8979ae0b-c443-4b45-8210-6394471dddd1@kernel.dk>
 <8de221f7-fe5a-4da9-899e-de2a856a4ddc@kernel.dk>
 <yywbp7fjnwgqxvc66zimea4hgdc2eysjx5nezky3vndr7xw25l@jv76rdseqm3e>
 <b8018270-6e9a-4888-87fd-69620d62c4e5@kernel.dk>
 <0ec1d936-ee3f-4df2-84df-51c15830091b@kernel.dk>
 <ocpimtl6f32k46tpcytix4kse4fhaivp7qvs4ohqmcx7ybtign@3yujd4llvah6>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ocpimtl6f32k46tpcytix4kse4fhaivp7qvs4ohqmcx7ybtign@3yujd4llvah6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/24 1:07 PM, Christian Heusel wrote:
> On 24/05/21 12:29PM, Jens Axboe wrote:
>> On 5/21/24 12:25 PM, Jens Axboe wrote:
>>> Outside of that, only other thing I can think of is that the final
>>> close would be punted to task_work by fput(), which means there's also
>>> a dependency on the task having run its kernel task_work before it's
>>> fully closed.
>>
>> Yep I think that's it, the below should fix it.
> 
> It indeed does! I applied the patch on top of Linus tree and the issue
> is now gone!
> 
> Tested-by: Christian Heusel <christian@heusel.eu>

Thanks for testing! I'll add your tag.

-- 
Jens Axboe



