Return-Path: <io-uring+bounces-1938-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03CE48CB205
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 18:16:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5F78AB20D90
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 16:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA9A4C66;
	Tue, 21 May 2024 16:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="K9XUZwMH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2761F1B948
	for <io-uring@vger.kernel.org>; Tue, 21 May 2024 16:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716308191; cv=none; b=RodLS9swlVVEBRfl7E4M/7Ze6JRAT+EP4Y3YY48iBnM9E7vyK5C7YeiaUSFAu7UQ27FrDogGr22ifRXtusOlpAlT3XAghMTc0IRRZ6bKWY9brIO+TALmvq++BczUq7qhMKoriESCzQYwLevxitHIvv9/IlMiBwCpWTgSbrj/POc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716308191; c=relaxed/simple;
	bh=qjBVA8ggLNmGa0E2b6IVKynsyFNB2lzDbYb/vF/UBE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xg27hvUHqZ5yfX+x2UdZbEElmBzdgsPPBFKkTCW7C9KrTsRLCityLpKOfYfyRoGJi3TEHpOqxM6ODnUk/c0zN47cTPKAmGWeKJfrAHN6qNDUdSWYi36IHJYv+2LAEbIwMgLFHLhjWrOtGcfKT5/LPcxg9lRaEe/Ncta8I6xD+rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=K9XUZwMH; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7e22af6fed5so19088639f.2
        for <io-uring@vger.kernel.org>; Tue, 21 May 2024 09:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716308188; x=1716912988; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VPlnRVU+taSPs3KUAXhcI2PpqAt76JjV3d+nQlsudCE=;
        b=K9XUZwMHeb1MLniOffAgwuO1e8AT0qnpjyv0DR+er2ZsY+cgofqh97mbww1C2qkz0K
         HPdmULaHQ3MXmrqAiYKP0hvu3Qcg+w5l5IEOqijmMLnb8tYetT73J1SPbSEXDrcHNuoG
         61hi+ZRhfv9nzhGl2kUYUrp3KaDrUrEmWwSmxlZklrrCCs/24ekqQvqpfWbHArpLYGVX
         rwMZlQ2bolaVVfOPy34ONdQytHJUgioSCQ0EI2a2kcgcaRCBHS9VXRSckaOi2n3vv+y5
         PKZeDmAxcCON9z5trBx0zxJNs2/ZNPZqMRNTTTzv2zNWHX6LY3D+QdPZ8XyfswwVmUhQ
         YP1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716308188; x=1716912988;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VPlnRVU+taSPs3KUAXhcI2PpqAt76JjV3d+nQlsudCE=;
        b=VQRWxpFDYAkYluJLtFl6U5G421dxqzaHjQOf/GzbXpJMjV4bY7nK2Us4bR21oqag0v
         0Cqrf/R3FGZ2A/nDr7keZ+tl2XUVcR9u3gzNpdAiz4qoVO3MQhzq8J9LN6OoKYk284pl
         z9Umkk97MYN0tJMUVO2+JRGu4iaUoCDfDtokDIdHWBtHOVIoxZRfdckfZHgq1tzvNxWt
         /Ub9eslyt0BUd7AdQLa6bKpQEOZlk5BzOUlEshhEbbleOIuAz1DjNuTiLtxV0LqWWarm
         N83piHmWVenZ7hSVMevAvPGX3Xt3PRa+NaA4BZ6NCKhKq5jCrgRjRzpSVF5wSbxsTGdG
         XLLw==
X-Gm-Message-State: AOJu0Yx4qexWw+GqJOtnw2poOQEY1QmWN4C5HHjwLU007LsDrbHjdY/x
	9iHTlLdMZgHf4eb/C8e/LVGtkKBXlaifA/7HW4OcQD8YsKfnGybKReYnGFiK2yY=
X-Google-Smtp-Source: AGHT+IE3hXU7Nbrl5o9NXAKpyjo2WFIT5cKrhXoGADD9AqeueOOV2X7KdFSsHAqSHS2D9/aObYkyPg==
X-Received: by 2002:a92:d40a:0:b0:36c:c4eb:fef7 with SMTP id e9e14a558f8ab-36cc4ebff44mr293860395ab.2.1716308188166;
        Tue, 21 May 2024 09:16:28 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-37073b59f96sm5620305ab.53.2024.05.21.09.16.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 May 2024 09:16:27 -0700 (PDT)
Message-ID: <8979ae0b-c443-4b45-8210-6394471dddd1@kernel.dk>
Date: Tue, 21 May 2024 10:16:25 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] ETXTBSY when running Yarn (Node) since af5d68f
To: Andrew Udvare <audvare@gmail.com>, regressions@lists.linux.dev
Cc: io-uring <io-uring@vger.kernel.org>
References: <313824bc-799d-414f-96b7-e6de57c7e21d@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <313824bc-799d-414f-96b7-e6de57c7e21d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

(removing stable as this isn't a stable regression, and the commit
itself isn't marked for stable to begin with).

On 5/21/24 10:02 AM, Andrew Udvare wrote:
> #regzbot introduced: v6.8..v6.9-rc1
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=af5d68f8892f8ee8f137648b79ceb2abc153a19b
> 
> Since the above commit present in 6.9+, Node running a Yarn installation that executes a subprocess always shows the following:
> 
> /test # yarn --offline install
> yarn install v1.22.22
> warning package.json: "test" is also the name of a node core module
> warning test@1.0.0: "test" is also the name of a node core module
> [1/4] Resolving packages...
> [2/4] Fetching packages...
> [3/4] Linking dependencies...
> [4/4] Building fresh packages...
> error /test/node_modules/snyk: Command failed.
> Exit code: 126
> Command: node wrapper_dist/bootstrap.js exec
> Arguments:
> Directory: /test/node_modules/snyk
> Output:
> /bin/sh: node: Text file busy
> 
> The commit was found by bisection with a simple initramfs that just runs 'yarn --offline install' with a test project and cached Yarn packages.
> 
> To reproduce:
> 
> npm install -g yarn
> mkdir test
> cd test
> cat > package.json <<EOF
> {
>    "name": "test",
>    "version": "1.0.0",
>    "main": "index.js",
>    "license": "MIT",
>    "dependencies": {
>      "snyk": "^1.1291.0"
>    }
> }
> EOF
> yarn install
> 
> Modern Yarn will give the same result but with slightly different output.
> 
> This also appears to affect node-gyp: https://github.com/nodejs/node/issues/53051
> 
> See also: https://bugs.gentoo.org/931942

This looks like a timing alteration due to task_work being done
differently, from a quick look and guess. For some reason SQPOLL is
being used. I tried running it here, but it doesn't reproduce for me.
Tried both current -git and 6.9 as released. I'll try on x86 as well to
see if I can hit it.

Maybe someone can describe what is happening here? I'm assuming that
something is racing with an io_uring operation done by SQPOLL, which is
keeping the file open until done.

This may or may not be a kernel issue, depending on what assumptions are
being made on when operations are begun and completed. Maybe those
assumptions are correct and there is indeed a kernel regression here, or
maybe the user side is just buggy in its assumptions.

-- 
Jens Axboe


