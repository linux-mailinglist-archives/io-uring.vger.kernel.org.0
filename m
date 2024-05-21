Return-Path: <io-uring+bounces-1939-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC84A8CB215
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 18:22:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE0831C21C10
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 16:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F35AB4C66;
	Tue, 21 May 2024 16:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kwKvp2Sn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7341C6A7
	for <io-uring@vger.kernel.org>; Tue, 21 May 2024 16:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716308543; cv=none; b=rxosD1hS7vnXEYP9BbyKS8nLEyvXef3gtOVLU6hjCU0cZ5wVQgb+bbQ3jT8IH+x3I4XEWQkfdVR3GX2AzA2mvSIrbWyXRwbdEu62zeot8okL4TumBKBAqUaiy/DKhgpFMxC5n0vtWg7yGpPzsnnEDmqMSqDxmoX/hePBcO06lBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716308543; c=relaxed/simple;
	bh=DHud8az1epbudvpz/IpiVm1Y+K8PiNZSPN7pMLHdqnY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=IcYZo7VDj4xm5tE3fzftXmNccEoTgJg36jOl23LuwwqYqo7b9rYMRlDYtJw/1/bNodMpn51J2gnTnmlkcmGw/u3XfI3LX3y2FquJ601A1T17EEU8RBKOdbu8WlWgHzpynwhlXazNwY88womAPBL4wxAKemBCwVr0oFbuUp3wvo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kwKvp2Sn; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7e195fd1d8eso19478039f.0
        for <io-uring@vger.kernel.org>; Tue, 21 May 2024 09:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716308541; x=1716913341; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZCGK78hZJKrOpf50PdGUurGLVSJhISvQM6TW9kyuGrg=;
        b=kwKvp2Sn9u/Jc2iFwLZSc9/VDtDibHIaB9UVRMtKZuIjRKSkbumQBazqX+27GIFIAX
         oviziNKmYTjI8FNpJ6r/Jk6dVN1ykj5iC6wftzvNbZh1NODTptdGI+HMmH7oPgGNfupO
         5FxkoxOnAsKFTw+OUI7JR+rqz6qXBlwfMHStPYj3Z0JXdJLCz0saXIEGE+plN8lovV/j
         TdFDYVrAF0TzubGGHUSo89uzUz2sWmtN4m67Hgv3tEv83i+GszYacbDem7Kt91WDb5AH
         lfLqAG3RW0XOT7E0yQ2JpjDcdmlNRg69iGMEvEzPCehEMhRV5pSiaiqNW7BOAw5PKhS7
         8j6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716308541; x=1716913341;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZCGK78hZJKrOpf50PdGUurGLVSJhISvQM6TW9kyuGrg=;
        b=QZn/AfQdp8/2HLOWltJn+noPuTk4D9jcliEvRlMnfTlJNBTWImdH3Ot4/6ynfPP75G
         Y6+GzLFBz9IHm6pFCpIrxXYncW6f7ec5MR3HdbE3TSDA2Wrk6ENrEs6Lq+46fdFOZ5eb
         AFMQQYb0XQ/h5rQvSLy9S1a33lgAjM6epgX2j973eQYhtxHkIg/mlYw2mXreXXd0lGLs
         KEH6FR1LPcNFBtrC0MYqlmYmN5pOCblBMpYBHn2br0HpK2QCS5zq4iVjuPqh9ZkkwCIz
         TgqynbP2Lvdvt9ahXDLkJ2IGkW2n1doe6/XPyjx7+qy/GDE7wbfLqr0E5CsplIsDtaXA
         SKQQ==
X-Gm-Message-State: AOJu0YzEGnFwS+lKfOxAwvbozvts4XCsGSVszitZEmSqr1fA5uD6/NN7
	ZJJJmjgwO5QT/U7Z3lKRnVvyo19ki4sxYrqQJ/uGWf+AlvbSQbZIPQPRER3I6OE=
X-Google-Smtp-Source: AGHT+IF6rDcptWTIfwJXxZWtRWKvJkGKnOFcU8ZqBb8gePkCL6jzK9HKZ2ttbWlwp+K7TIMG5rp49w==
X-Received: by 2002:a92:d40a:0:b0:36c:c4eb:fef7 with SMTP id e9e14a558f8ab-36cc4ebff44mr294020845ab.2.1716308533665;
        Tue, 21 May 2024 09:22:13 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-36cb9e142c6sm65054805ab.72.2024.05.21.09.22.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 May 2024 09:22:12 -0700 (PDT)
Message-ID: <8de221f7-fe5a-4da9-899e-de2a856a4ddc@kernel.dk>
Date: Tue, 21 May 2024 10:22:11 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] ETXTBSY when running Yarn (Node) since af5d68f
From: Jens Axboe <axboe@kernel.dk>
To: Andrew Udvare <audvare@gmail.com>, regressions@lists.linux.dev
Cc: io-uring <io-uring@vger.kernel.org>
References: <313824bc-799d-414f-96b7-e6de57c7e21d@gmail.com>
 <8979ae0b-c443-4b45-8210-6394471dddd1@kernel.dk>
Content-Language: en-US
In-Reply-To: <8979ae0b-c443-4b45-8210-6394471dddd1@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/24 10:16 AM, Jens Axboe wrote:
> (removing stable as this isn't a stable regression, and the commit
> itself isn't marked for stable to begin with).
> 
> On 5/21/24 10:02 AM, Andrew Udvare wrote:
>> #regzbot introduced: v6.8..v6.9-rc1
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=af5d68f8892f8ee8f137648b79ceb2abc153a19b
>>
>> Since the above commit present in 6.9+, Node running a Yarn installation that executes a subprocess always shows the following:
>>
>> /test # yarn --offline install
>> yarn install v1.22.22
>> warning package.json: "test" is also the name of a node core module
>> warning test@1.0.0: "test" is also the name of a node core module
>> [1/4] Resolving packages...
>> [2/4] Fetching packages...
>> [3/4] Linking dependencies...
>> [4/4] Building fresh packages...
>> error /test/node_modules/snyk: Command failed.
>> Exit code: 126
>> Command: node wrapper_dist/bootstrap.js exec
>> Arguments:
>> Directory: /test/node_modules/snyk
>> Output:
>> /bin/sh: node: Text file busy
>>
>> The commit was found by bisection with a simple initramfs that just runs 'yarn --offline install' with a test project and cached Yarn packages.
>>
>> To reproduce:
>>
>> npm install -g yarn
>> mkdir test
>> cd test
>> cat > package.json <<EOF
>> {
>>    "name": "test",
>>    "version": "1.0.0",
>>    "main": "index.js",
>>    "license": "MIT",
>>    "dependencies": {
>>      "snyk": "^1.1291.0"
>>    }
>> }
>> EOF
>> yarn install
>>
>> Modern Yarn will give the same result but with slightly different output.
>>
>> This also appears to affect node-gyp: https://github.com/nodejs/node/issues/53051
>>
>> See also: https://bugs.gentoo.org/931942
> 
> This looks like a timing alteration due to task_work being done
> differently, from a quick look and guess. For some reason SQPOLL is
> being used. I tried running it here, but it doesn't reproduce for me.
> Tried both current -git and 6.9 as released. I'll try on x86 as well to
> see if I can hit it.

Reproduces on an x86-64 vm:

[root@archlinux test]# yarn install 
yarn install v1.22.22
warning package.json: "test" is also the name of a node core module
info No lockfile found.
warning test@1.0.0: "test" is also the name of a node core module
[1/4] Resolving packages...
[2/4] Fetching packages...
[3/4] Linking dependencies...
[4/4] Building fresh packages...
error /root/test/node_modules/snyk: Command failed.
Exit code: 126
Command: node wrapper_dist/bootstrap.js exec
Arguments: 
Directory: /root/test/node_modules/snyk
Output:
/bin/sh: /tmp/yarn--1716308447842-0.8496252120161716/node: /bin/sh: bad interpreter: Text file busy

I'll poke a bit.

-- 
Jens Axboe


