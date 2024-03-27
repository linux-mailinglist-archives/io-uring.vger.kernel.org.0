Return-Path: <io-uring+bounces-1250-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2171288EC66
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 18:19:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4E71299BB1
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 17:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DCA914D45F;
	Wed, 27 Mar 2024 17:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="U5wUCTha"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B67714D451
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 17:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711559951; cv=none; b=qaTRA2y1SEvtv87mFfES6osyv+y85657ADfXnVf8mbZ/F4hVerN2crHzMqJ16I48uL/h0ZqhzgKjaWY+aO7lbqN7qP2iObPYSYOEGb8ec8JPmGqEHTdo8IzFGitQZ2wuwGopkdMYbQUl/DHEanWEEFWNoUul3fwa+mpuYAxwB4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711559951; c=relaxed/simple;
	bh=29h2AUzAAJnDFXLXJwmwzPe73vea4EZeTwwo589Dbk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZNkQMWt/dYdI10PP4hMJSyV25O9Dt5e2Z4u1jbdhAt8124qQQzs1IAicVgId1Tix+P6Ea0Hl4ji9BXJ1OHDPdXU4jICOp6KiWxMLJwOS5CklZX7S1d4iWzuMG400tNOUPd0yCTOTqXfYSAWLAkUxl2IYotWTt/aN0ozXusMigoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=U5wUCTha; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1e09a7735ecso70145ad.0
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 10:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711559949; x=1712164749; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6XH30giHm4xuVAjFduERXiIJfhN32OXXVD0HlYbYbu4=;
        b=U5wUCThapf685eE9N+MygSUVV3fxDGpFK1Llr9kTGaZ1yt4KZ+CGeO4GlshLjU/+iZ
         VSbnYcPvKBLuKt2Yx64cmWiID/IxeDCWNQcI3pFtnMJ+RCnfgkh2Q72e86+eCHqT0Ygj
         28eg6KS6SOzMyZ6ebh3b44qDaQFRrjWCNg4nzwOgiU0X60AxJEn8FMDLsdcZQKdPrrUS
         PlWSJEYNMGzs3V7cpGV+GRpuRic5kD1Dm7NP6wdCUs9vP+PV1zUKiAvKFNzc5QrPtITr
         9oxQ2Jh6FJLNoljLQTarcFHb/NmDKdtY6pd6EOvVYI2zNA9EE4OaQ6rOc60RgolnBDnA
         mHDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711559949; x=1712164749;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6XH30giHm4xuVAjFduERXiIJfhN32OXXVD0HlYbYbu4=;
        b=mGSNl1wuCw2FTD1+fFRmZGRaPrao/YBCMrNp4+rOhW3Nd31oly41WFYUkYU98GHniF
         yyOcIxBlS2ltcrSaTgTHxJwFSkG8OkiR4TxyfrU75GOk1fzXB0RKrmRmGuIVkNiAFd1S
         6CPB5uaLFADPxOpVOiXunreJcnzvPvX9jrBjmzmGeVkxDk3XsNvO1E6z2/iFCu4H3Qbk
         SkUmXjBBE4IGv3lQeTbFdG3UFYM2BOFx9f9KiKcliEbJ/O1j1xynxVjm0lJ5EXnxv6De
         93aUC17K+cuFW9WvJ+RSonAipWAZIckNb4RybC13uMEsvz8zpuEdL3peF/xKGwVzKrdX
         r3Uw==
X-Forwarded-Encrypted: i=1; AJvYcCXvktQLq4Z9bAqbdxntfcIYhxfkDRepL2wiE257MZeGprIFvxk7to4k2uHim0ZJuTvciDY/7LHoPhPnBAW9NLW7O7W5veRoZ5E=
X-Gm-Message-State: AOJu0Yw3vc/xKoVYHTzSYhk0BYl590FDf+/sGQ2KLD40bBpaSPfS+vWw
	dhOP/p4b1Oet5BRg0jgy4JPBkaoyGyqBnvLSOu7VOJ8VB75DhVCVlzwCpsrttbrk2fHCEANYX9W
	7
X-Google-Smtp-Source: AGHT+IHQbekEyHpay7l7rXYFodfJX33zwaI5uIhjFxi+PNIQFoF5Tr15zzymhsRzZ1YV5p6JX0QuZw==
X-Received: by 2002:a17:902:ab96:b0:1dd:de68:46cf with SMTP id f22-20020a170902ab9600b001ddde6846cfmr286761plr.6.1711559948631;
        Wed, 27 Mar 2024 10:19:08 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:122::1:2343? ([2620:10d:c090:600::1:bb1e])
        by smtp.gmail.com with ESMTPSA id f1-20020a170902ce8100b001dd6ebd88b0sm9290497plg.198.2024.03.27.10.19.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 10:19:07 -0700 (PDT)
Message-ID: <e6a61c54-6b8d-45e0-add3-3bb645466cbf@kernel.dk>
Date: Wed, 27 Mar 2024 11:19:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [RFC]: fs: claw back a few FMODE_* bits
Content-Language: en-US
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
 Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org
References: <20240327-begibt-wacht-b9b9f4d1145a@brauner>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240327-begibt-wacht-b9b9f4d1145a@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/27/24 10:45 AM, Christian Brauner wrote:
> There's a bunch of flags that are purely based on what the file
> operations support while also never being conditionally set or unset.
> IOW, they're not subject to change for individual file opens. Imho, such
> flags don't need to live in f_mode they might as well live in the fops
> structs itself. And the fops struct already has that lonely
> mmap_supported_flags member. We might as well turn that into a generic
> fops_flags member and move a few flags from FMODE_* space into FOP_*
> space. That gets us four FMODE_* bits back and the ability for new
> static flags that are about file ops to not have to live in FMODE_*
> space but in their own FOP_* space. It's not the most beautiful thing
> ever but it gets the job done. Yes, there'll be an additional pointer
> chase but hopefully that won't matter for these flags.

Not doing that extra dereference is kind of the point of the FMODE_*
flags, at least the ones that I care about. Probably not a huge deal for
these cases though, as we're generally going to call one of the f_op
handlers shortly anyway. The cases where we don't, at least for
io_uring, we already cache the state separately.

Hence more of a general observation than an objection to the patch. I do
like freeing up FMODE space, as it's (pretty) full.

-- 
Jens Axboe


