Return-Path: <io-uring+bounces-3033-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9656F96C449
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 18:43:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2FCE1C23C48
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 16:42:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFEA41E00BD;
	Wed,  4 Sep 2024 16:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sgi/C4+c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF211DA319
	for <io-uring@vger.kernel.org>; Wed,  4 Sep 2024 16:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725468176; cv=none; b=YBglibMew1LJ3smabUTImYZk53ig9WKi2MZLc3SaIRWmVL8AuA5H38I3Jo3mkMz2u5nrqnBqk+I33xnWjWnbVioXAQHkQeJZiC9m35q00vnfrqMHfbcDvfJFLijewFnOvkFL1K7R43jUDmCWYLcsaMzgjsvyTZ5s20KqC6HpqZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725468176; c=relaxed/simple;
	bh=2g8hORqJfgJK6c4TQK5Uakx8LmMu/IUmPZLfREx32WY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HVkOM+i5RB2zMTWUZDI6oo91KVs9ILWDH/cGa1RsTLq/U47WJW8uSlEMTz1s00sfl5S9MWNdUrdD8SDdjD4J6t/UBAIeWJdoHqmeXAEc1j/Qz4S+RZBZjXwwAL9MheyOsyHJHtkkT/ISujoIMgvnmgC6jUKCTePJzgz5jkzMSoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sgi/C4+c; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-82521c46feaso298215739f.2
        for <io-uring@vger.kernel.org>; Wed, 04 Sep 2024 09:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725468173; x=1726072973; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7EhfYnDF3geuG4Vlp11MLOFukSIq+HchLGo2+d5gn5Y=;
        b=sgi/C4+csRpxX5SBHfUQo2JZc+iEDHieqzVx64/Dr3XeT8h4INMOb3dUSpeyHKDbHs
         88O8vEXIfp+wQsazDtnNaNZBF9uoAv3CNJOkGg4pWnVzkjlBxque8yFbaO9ho7ZjsjGk
         RYM6uC/PcCilYIj8HPcSm0XZz7NFOC8LhFovBTs1VReLK4xy7i+tYO/Onfaylwf/Pozh
         oW8w+4ltSgyMkyJiUKrinudNdJKtv3K27KilnLW/ee6GyGCiUDV/2fuX8YOSEEVP2kfn
         5mwrsHDQKzvSHcrzo6Z0+41hvRgmU1pOW26AKmdpTwrv3CW32vCOGH7Hhg5D9w+JcT41
         KfpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725468173; x=1726072973;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7EhfYnDF3geuG4Vlp11MLOFukSIq+HchLGo2+d5gn5Y=;
        b=TtADuK1NEnd8TVrVzZKtnC3m1UC6fmJ571I+Im60qYfEUpJZPuHfKcjlHEzQNh6mh4
         aCP89FLsj0UKpk/GsSzlvK8JDmlDAhdop/2NCNWsVGvisc3X2tMbfFfmxHN2HGVnK4YF
         BEVqR1D/BwLhsI6irDlCFnBVg+6Y5MDFnZa6U2SCRWtHxamUGmKHy6zQMsyrgSGpbO6P
         xKXcIDZfj4nC5EvKdX2b/tSJQmr22g8IXpgHjGB7mFSCIWzo+v95ZCTX2cFV3DfVVaGD
         L7K9vqejHyXke5MGACRaFg6YM9eK+gHP7ZXXXkpk1mgCsnusYVFC7yTQEw1B+NqbDzXg
         dEHA==
X-Forwarded-Encrypted: i=1; AJvYcCWefQM/v6fLBp2oKabjcKiqFwdtykB9GtvEETrvAVIk3vy4abqLviehIR6Z7OynGkMMDhKzzR2DPw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyXFJKX/bWgHaVxTPoqnvZHc4JfCLIeqVg02EEqJ1Mm3f4EzK6s
	jgwFTKPfnGGeMP8JxwPaaIdEWTGbUZMkPB4b8Virm2wPkWG+uPhwhkzriSz9cgo=
X-Google-Smtp-Source: AGHT+IHhCXKvkoFcAU16828iKL9lDAwOYMFjXGtZvWZm1i4uqR6mNtlu+n0aKognVOquEwQwRUen1A==
X-Received: by 2002:a05:6602:6c04:b0:81f:b53b:728d with SMTP id ca18e2360f4ac-82a37503513mr1463710439f.6.1725468173592;
        Wed, 04 Sep 2024 09:42:53 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-82a1a499273sm358522439f.34.2024.09.04.09.42.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2024 09:42:53 -0700 (PDT)
Message-ID: <e51abb75-b3f9-4e91-91dc-81931ceacad6@kernel.dk>
Date: Wed, 4 Sep 2024 10:42:52 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 00/17] fuse: fuse-over-io-uring
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Overall I think this looks pretty reasonable from an io_uring point of
view. Some minor comments in the replies that would need to get
resolved, and we'll need to get Ming's buffer work done to reap the dio
benefits.

I ran a quick benchmark here, doing 4k buffered random reads from a big
file. I see about 25% improvement for that case, and notably at half the
CPU usage.

-- 
Jens Axboe


