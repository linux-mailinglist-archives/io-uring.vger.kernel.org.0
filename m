Return-Path: <io-uring+bounces-7161-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D558A6BD5C
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 15:43:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D0CC16A19E
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 14:41:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D57CC1D63F5;
	Fri, 21 Mar 2025 14:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CYKqw6Th"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C961D5CCC
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 14:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742568062; cv=none; b=Ku4GwW5CFRwSK28XYfEm18CBGJ8+7Esn7rwlH/QHVSjTR5E6gEpvBPbOTsq088hHl/VMo+izauz9UInwEeEYsr0bM2TVa4sn2WJEIBFCwgmpAlh4oB6MARCrXQnJlD3R6hCeuKkGp7TK72PiviWJna7ARpcCQWgQlxyvx0sZlYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742568062; c=relaxed/simple;
	bh=9avAOU/6tNKZ+ihKguu6rrkHyrIGtvmnbvJp/Gfk0Rc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hcaGNmUmA1zmzMoL17j9ZWiD5b93Oy9+uPNdDXRg9VLVxyK1uSvG+9v1rJWN5XgV+D+Fgzkjw1/AGmGk8ScAK5Jd6cC9z640Xge83++uQf6TuDcN5gtP4s6WVwQmWB1rW2SPzi1g26RCR6gGq/Ynj2eZEw5csCFagT8nLta+8Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CYKqw6Th; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3d3db3b68a7so21968465ab.0
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 07:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742568059; x=1743172859; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hXTXSYM/TQT1TTdW/FaQ9FsTaTA+GOxtG2MdvSRuuVo=;
        b=CYKqw6ThlyD4hZNlVWa+P0W3zZCZHWUrIS9iFyG4PKRtH8/f8V0PkPrKZlgt99AzXl
         d4Mvuv8XF3zTYI3fpooDEuBpxs1LAWsOQeU6cRcL/R/n/JWHkNirhQfMM5mVQ2DC1D53
         nORwsE57noqEBc6/viB7X2Tqdu5m/B+itJhF8zJySdizS3mr/nPBqVFKsxisLenlROEi
         xa1ddk8VvkecBkLYfH5Lv59ZXumH60I/1RGqjtSA+x3bvytOCuo5fypr2OcdJ6iGXt8J
         J2URcUXMpNxp0HEJ/r5qWl5+b24AhMHfra1GnouBEP7qURSJJQ4TUNh4j4wZ479wm5Jt
         4Tiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742568059; x=1743172859;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hXTXSYM/TQT1TTdW/FaQ9FsTaTA+GOxtG2MdvSRuuVo=;
        b=cCEh8VfWnessLLzHGbCkSMVhgBoaSq/WkXx0JyPprZwvSXO485blgPEOEvjH+3BjCW
         jYfHvzfMmXQQFbzA60wHKNYKCA5NVVIIxqJEQJecdOqBGMVtOE9DYqOU2FKPbe8HYV3h
         prC4WtZDg3LDaL1NUA9s0iBWehBHfYG902RcHtx/SpyGtt5yYcvLPcqXypGTxVtr4wj9
         G+e/GZFHudRYAAImPHGgtFbka0SAzH30rJ1OQTIiM1HHZ5Y/gJZDJcwc2R1PnI8gGZe9
         yex3cgDPdO10uZIaslaWXiFi+Y7BH0PsfuMRK8bgiSHHI1uZ1Yn+gInvtFoJHKkQ4FxP
         gvdg==
X-Forwarded-Encrypted: i=1; AJvYcCVv8F2xRVyeWOqk172p96Sn0KXU0IzG5QpwEkDUBWu+5ZwGfiwY9spoU7KDXQu6n/W9xnyOMd2FkA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh7BRHHsWtyNvYOyU/SrauB8576osKjqSVSeIEiNzisuhyICYR
	dTtDlm5R5WaBYFroT8jSnRnETeC3ZEWSDX6C8nvm49fcSYpoMc5mFydg6bAem+s=
X-Gm-Gg: ASbGncv/nu6dRSiR5kctA5USjpGk5OB4d8ZjQKAMO6Em6yRlMGdjninszKLnL9YIor2
	ZypDZ7i6/hMG1gPU2RODzOGRzHxg3GIXo3ORga6XsdMFPGx8w5MmlRl3yuKwNBRLl1OR1dutTz1
	oeoexKnnjskaYjI+iSzItdvPcYSGt5SgwQzgEmxgS6teGeI0K/a0CAA7WEnnChTwMowX817k0dd
	WAZwSVHoYU1aELlBN+zPj7Aaxutuhd2VaZWtWUXwVlIZLiJKvceCs0DjKnHYjAjM794UZ3L3f0N
	DzEEnACucewDx7R93bCsQP1e/zLCAoZAbOz2nvRLUA==
X-Google-Smtp-Source: AGHT+IGxCw6+NbzsZ9DJz+inUxfSDED1fgD09sc9LoNehooTC+o5GxAAK1qn7csbabxfA1auydQCMw==
X-Received: by 2002:a92:ca45:0:b0:3d4:244b:db1d with SMTP id e9e14a558f8ab-3d5960f5b15mr34757915ab.6.1742568058927;
        Fri, 21 Mar 2025 07:40:58 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2cbdb3a2csm467064173.7.2025.03.21.07.40.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 07:40:58 -0700 (PDT)
Message-ID: <10a64355-92d5-4580-be6c-84da18af22ef@kernel.dk>
Date: Fri, 21 Mar 2025 08:40:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug] kernel panic when running ublk selftest on next-20250321
To: Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <ming.lei@redhat.com>,
 io-uring@vger.kernel.org
References: <Z9140ceHEytSh-sz@fedora>
 <e2a4e9ac-f823-4068-918f-e4ab1180b308@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e2a4e9ac-f823-4068-918f-e4ab1180b308@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/21/25 8:40 AM, Pavel Begunkov wrote:
> On 3/21/25 14:33, Ming Lei wrote:
>> Hello,
>>
>> When running ublk selftest on today's next tree, the following kernel
>> panic is triggered immediately:
> 
> Jens already stumbled on that one, it's likely because the
> cached structure is not zeroed on alloc. I believe the
> troubled patch is removed from the tree for now.

Yep, ran into the same thing this morning, and yep the two last patches
in that series got dropped until this is resolved. Ming, if you use my
current for-next branch, it should all be good again.

-- 
Jens Axboe

