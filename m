Return-Path: <io-uring+bounces-5745-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6B77A04929
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 19:26:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28CEA3A49E7
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 18:26:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE6919C54F;
	Tue,  7 Jan 2025 18:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f/TeJRDQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7FB86330
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 18:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736274401; cv=none; b=nWTSvGMpjOHrnyHPXbfnZE2i27yO8saYRMQ92yhRTSHVaijo12JtNMIWiQX92Y6PEMBR1y4O5hGwbnCKeHpnEy2vf9vFaR9uAg/jdXa8RMdN0/bPO+3Ulv5OTc0lWNOI/56oP6/5ChxYSQRGmmA7T3rdZXOsSGplxYJxO6Ua/Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736274401; c=relaxed/simple;
	bh=LJC92LBxdT99kNk6rjqSUZuVZfl+9W5Yza7/nO6GH7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PWwpUHi8AR2X6JPLvv8nWLJiRqorlo+7GzXNXCvooIYSLqZmJPz7a3DVkp0M+iZC59o+nyBJdu1WTdkWi6nwl2cyxZrq7C8yljPPE7Ro1JlUkCyZKKJEcPR72+miA6edgIQJVqyBHxflwnySOcFR/TcQLHcSfFB0rrqmrePbrNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f/TeJRDQ; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3cda56e1dffso19580635ab.1
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2025 10:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736274399; x=1736879199; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4CQyxguET1UERd70gvv8fQ8eFbyVPeXPr/OhZ6rFLow=;
        b=f/TeJRDQSIdAuchTpKzRnrvu/FDmVzL1Qn0MvEJF3vMUTueo2SRVOHs8kT/2WtG9KM
         DzTolEqETUa/rCPQfPIH0hKu43x4qVNuJ+C12Pu9RVsj2owp/2joaiwk3X3yxpVH/Xrx
         IjqOXqJ3l6o6IRs+9Qu+C9f9FnGVnwE5H8dTsB2smmTve84YNUSfOW5uvFOuY6bAVFXK
         0lV94KQWgpYZ60CQ6u4MRJNSUHhU+WZbZAnogvmJGAfzbSS6dLvx97uH1aPedg6gHVso
         A1IET+5wres167NfE6lXN7+43qRN1BWIBdNoj6jX271JueNPHk3px2ITR8GvAbsS4d3U
         Q6bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736274399; x=1736879199;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4CQyxguET1UERd70gvv8fQ8eFbyVPeXPr/OhZ6rFLow=;
        b=Autips22YZ0qi+2EbJXw7cnFWn7DbNxZ0fXzIW3CrDVVyRt3nP2+QNAvIH1CwHh3q/
         sRBEJwYzwpSTt+hVVHejj+LexSlc8OQZQNVWzZzyeQfcRlKEdeyiy9GB1AlzNc/CSe0D
         9+wpY0R9w7qxdLxN2VuZXkkNjt7sasJHpPt2VpxpRUuELQx8GxFQkkJY/H5D+9VpmhUU
         JLwkbnqHLS2oyqViZBGyN8uumuItKK26Znb5e86ytnYI46VwzDRqdwthDu34yyjDBKwE
         Ka2erO21Ksfkgzm8XNOx84PC86AdCDwTObBIniafPym/+uQLJiyqCTt8xMiGvyS04zni
         S01A==
X-Forwarded-Encrypted: i=1; AJvYcCXFzFJY9QRviEURSudIwf6X2GTSKiQ5+2fla1bBdzM2ATnP/v1krqUBR/hdYwEGTPjFGemR7uW5hA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxQa4IORli/xgeO+T0GL9uohBi9uekJLEKWKet35JMW+kkT/yE5
	JJmNONynoDpemAzeV4Q0uPF5Kca6XEE/62ruNz4O2jEjWuFFB5ZP8IsjqGqoV/c+rY2yWVPvmpG
	F
X-Gm-Gg: ASbGncvzzgixV95Phi/mH31lm8qw/tKPQm3GSUWNqcIWEGoMQoNeqzEyPDG/syy8MR3
	7BXvYWqx8Chezl6p4g7NZwsK6bfNZtZ/3X2QUjskb7YnMshvI1aFwOwydq8H3giuCYpCbgpjd/B
	FYsSmSULIUOvaQbL1LEtvOSDVDWxKIniJPaDNacWMGGWJ9ovSTHVZv/pCegyYgTRipRa/WyRKet
	ad20jf4GqUZETGC+/JedzdO1E2wdE334GbflZlJuXva8mtP04Po
X-Google-Smtp-Source: AGHT+IGq8SSKQMQ1QHmkkO0MYWxwhkS+6UrfWVqaB9JW4aW2r1BW3Dkcu07/3oE122me3fTbqfgZ2g==
X-Received: by 2002:a05:6e02:1c8e:b0:3ce:3016:fbc3 with SMTP id e9e14a558f8ab-3ce3a8882c6mr1681105ab.14.1736274398767;
        Tue, 07 Jan 2025 10:26:38 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3c0e47d6d6fsm103526395ab.69.2025.01.07.10.26.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 10:26:38 -0800 (PST)
Message-ID: <4c531b2d-c852-4a33-bed6-b8bbc3393f98@kernel.dk>
Date: Tue, 7 Jan 2025 11:26:37 -0700
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
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <IA1PR84MB310838E47FDAAFD543B8239A95112@IA1PR84MB3108.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/7/25 11:24 AM, Haeuptle, Michael wrote:
> Thanks for the quick response!
> 
> When I remove that check on the 6.1.85 kernel version we're using,
> then it seems that the user space program is losing IOs. I confirmed
> this with fio. When we hit this issue, fio never completes and is
> stuck.

That's because the io_uring logic assumes it happens inline via
submission, and for your case it does not. Which is also why it gets
failed. And hence setting the retry flag in that condition will do
absolutely nothing, as nobody is there to see it.

> I can certainly try that later kernel with your fix, if you think
> there are other changes that prevent losing IOs.

Please try the branch and see how it fares for you.

-- 
Jens Axboe

