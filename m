Return-Path: <io-uring+bounces-8154-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E8375AC9085
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 15:48:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB0911BA1126
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 13:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5A4A17B505;
	Fri, 30 May 2025 13:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dh7diYCg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A8579CF
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 13:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748612922; cv=none; b=CmU9VcHWwYtAyeERMsbKMGOBKjzNy89Z7ikGeUDXio9lJgenl6sbzowGmJW9Jf6aMiP6t+0QgNHyYJcH0OMILLOGBKP91IsYngmBNHRqPSklTcCwaBK1FOBkLVw8hIyhwrEPWwSFgQZmb4GwtYg6mcW0yQKU3RT1EcYXkyTsmhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748612922; c=relaxed/simple;
	bh=8ruD0Ko17kHNqkiBdOhkxO2MdCEpoYlpMUbQNwHydqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Z7phcW8WunORQ7l4z9aEyz18m0eU41nXvm9491gms9s8Qw3rRoVZPIWl6ol+9A0jK+rVuHpEbIlZI+tkoqQXjDiTGn5Jxe+ISf/bZ/PUJ6gLq8RNB5/tLHlwSWo0bfT8/zNoSYNMAA4N72Jkf/Qx6Xjyigmcb4/Uh3ZGaUcS1Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dh7diYCg; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ad5273c1fd7so424148766b.1
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 06:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748612919; x=1749217719; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YFMZ/AQYc71yRrROgEekYEFYOXgAQ+yO0wDbV3lfmm8=;
        b=Dh7diYCgMfMOju6+GydYNMIeOarja9X2ugfJyQwblNt2MWXrRevEGNEpP98CeyiPig
         xkdzaB5qKj5JaR8uYvvJnrAk8M/XWlDhBtcj/gCM7a2jLzs7/aBxzqnLuRihGkr877H9
         qTXvanopGmGW//qQgQUpO4d4KIIpVKUwe83F/n/IR41cASmDVEYnv80EsHCRNDz6WuRo
         ulWob2+vzq9W++jeI6b2Qbm+elqTfb1cfUn97lFnqqGKAPIJGxtVtBncLsdFynfTHqZY
         GFk+fL1WnEz9qAz7GhjXl58v/J+0juD+kuyNCwt+laZ2Eyeryjh+XXh4TbU4jNgIRXVZ
         EGqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748612919; x=1749217719;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YFMZ/AQYc71yRrROgEekYEFYOXgAQ+yO0wDbV3lfmm8=;
        b=RRms3wp2CB1uBW11u3zzyh5/rX7pO5xRr5N7kC85LpVGU8OBg+w8IILiB0KxSXZ9do
         ab3Uw2AAtatrZhGiGUKMMdeUSjKIlzf5VdRdzKlacz9wG/QUlQlSZZ3vi5cAR/GG/OMx
         1R4L3lFVNseNS6uiV++WWSJBiGAb+smBSr0jpIeS0I3JL1+lhfRDRNRF0DhGoonaRP7O
         qk3ZvAdyYpK0GElrCFVie5E2YkgR1KQUcxnyitJJVNqa5A0MwRk5YFgJMyRpg6QwJSXK
         FE5EzOPlu+zBbwPrCEXXKw/A8XZA8RsG1nSpkI8Wf3oMuQ5bNERHhQr9RsN+fjERAdIk
         6ukA==
X-Forwarded-Encrypted: i=1; AJvYcCW0CekpYgF5wU3JSr+OWgiWMWPL5f6i9KcKpFGVjhq/Ajl5Mw/TwjuXXVBT5wOFb7PD+/hUoLYIVg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwgCdYRTRpViifzkFtqf+E4WYYmT0ZG8sXxd+UPcgHBcL2gSMtZ
	s6vaVAMV3YFikBTvvWMDdBkJ60hXVDrzrrKvwqjhPxGL7+6cC3sh6YUP0bJw6w==
X-Gm-Gg: ASbGnctrDxoMBUqsoKnUjViTeGD+3EVLbkWf+EqdVISzrfog2o+gfO/qvXU5wwL9wSS
	G2/jY3r+UWSUpHsiGREm8biBuIm85qr2QmIsLmpIP8tKGJNZe11l9mp7fVLaoDu7TxHYj46r+q7
	ur8DIU3TjmJ0Nfcc+gL1lphU8GNMw2BCGzB5ueMmHP93gNs5b6MMtyLYYzfdM11+RsuH6VibJY4
	xGw+u1BVesRQVT5h/3UvIiz+r64f81kX98X/DvdnZI+2/oAGyRQPUtpDKI986eDA6FQKOt6j3Qe
	DmrO93KTJ/Om/X6JW2F85415or8qaJpoXxP4kqgQCht+XbGmcq9x8yp6vPfkmUvAuP/SRlORTbo
	=
X-Google-Smtp-Source: AGHT+IHRYYpHiXUNpehbWDn08fiTO4XoIjW6dRegSFCEECVQSOgrgGQxdqnuwuUlg1bSRXxh1t323w==
X-Received: by 2002:a17:907:1c1b:b0:adb:1804:db93 with SMTP id a640c23a62f3a-adb36bf053cmr215425666b.49.1748612918987;
        Fri, 30 May 2025 06:48:38 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::15c? ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada5d7fed96sm329827166b.32.2025.05.30.06.48.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 06:48:38 -0700 (PDT)
Message-ID: <876cb4ad-e674-40ec-b1c4-928638198fa0@gmail.com>
Date: Fri, 30 May 2025 14:49:51 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/6] io_uring/mock: support for async read/write
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1748609413.git.asml.silence@gmail.com>
 <6e796628f8f9e7ad492b0353f244ab810c9866d7.1748609413.git.asml.silence@gmail.com>
 <792793b0-fcee-4915-afdd-e13cb4d59a53@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <792793b0-fcee-4915-afdd-e13cb4d59a53@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/25 14:27, Jens Axboe wrote:
> On 5/30/25 6:52 AM, Pavel Begunkov wrote:
>> Let the user to specify a delay to read/write request. io_uring will
>> start a timer, return -EIOCBQUEUED and complete the request
>> asynchronously after the delay pass.
> 
> This is nifty. Just one question, do we want to have this delay_ns be
> some kind of range? Eg complete within min_comp_ns and max_comp_ns or
> something, to get some variation in there (if desired, you could set
> them the same too, of course).

That's left out for later. You can always invent dozens of such
parameters: introducing a choice of distributions, mixing,
interaction and parameters for polling, but that should rather
go in tandem with more thorough discussions on which edge cases
it needs to test.

-- 
Pavel Begunkov


