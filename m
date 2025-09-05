Return-Path: <io-uring+bounces-9605-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE295B46386
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 21:24:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75127A41A28
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 19:24:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC59F2773C3;
	Fri,  5 Sep 2025 19:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0hI+83e4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABC51FF1AD
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 19:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757100239; cv=none; b=ZFoq1hafFGMs6wXwTfY4BZDKnmPJk9SkisNXesWaoomxC0Iu9SJ1/0E1cXJLYwT3ThOSpX65DkkuTB0vsHxJD8KkxlIv4bbyI1jhocvUPxjQLl17BU05XRQgaNjLYsf6qG+1By4yJCAmGbz4hTFcJijgXI0KYxroP76rhUV+M+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757100239; c=relaxed/simple;
	bh=DAzrUBYZwtbnfGozyw36W8kyyqia+hHgEUvMnkirV50=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EN4Kgb/7K3G4MWIZiIptHRFCi/d4vnwu6lfhUXYPu57YUvAqpULJG/2luLim91rZQy//e1EmqpI23Ug91fwZm007eB0zOkz4O6t6VdbPgQYISsvO8il8oho7u9ya5ptrPV1AY+Mpj67HSie5tuKKeYhZubp/ZZzqAAbYaeTzXI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0hI+83e4; arc=none smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-60479737d4cso128309d50.0
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 12:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757100236; x=1757705036; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FOcaAtJRnFCVyknR8EKRy8AkJA4DWmnrZ3j3mQ7cyWQ=;
        b=0hI+83e4WMZ063f6to+d186po3rgsM5/Mb7mwhFAdWtUEbV8qzcxAt0Er9TtZf3G7G
         lIVtfWa8+nF/H60q1JtDzZjsIq+X4zGdkHir8jXP98FVVUg6YjEtLhC4NodUvk2rS+1J
         z7mGxOAbxHxxoOkQyatdAFoUDvIFAcWaUQqXt4+vp+MSSBgvIbTDk7QzrXfnq6rGL/s+
         u5c5JHY9eKXkdsUJeVDDKtNTRhX3Auhvs/3cgZhwrZvoKqHjLPw3JJ/5v9XgLdmmJitF
         Q6mEqf5r28C1c4UHN436eSxcRgZkeg1DyCdNVlnihUbMNww6UHLI3eKuG0oNFbdELCGa
         WV9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757100236; x=1757705036;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FOcaAtJRnFCVyknR8EKRy8AkJA4DWmnrZ3j3mQ7cyWQ=;
        b=t+y5HA1bSgkCEzhy96jjo+VmWN4MmsDrKhafmSw2NQA30e1NXDYtQjkvHE7o+J8I22
         gvpOE7pSdAwNHTRRX6FfyNlLmjjIa9mgbTLGTVd8C4+0llEEee/JkDkJa8YWg5De7ZyC
         9MRj54NXuPN3Imtt9RI7wsMTXu6s9hParopuw4aEXfHQw/78sBR55SYQFL2kK0oTIw6I
         pMud5SVTdcTpTix6lDMX/WZ6CEd9z1EJlYYTH4byxUMRoZF6bHxbdsOENyy+kU3N/IlJ
         kO/BMREc5DVMOy24hC5BYJBjPpw9PsrP6LCWE7sEib5XRHEVey+G9rxCMfpuOAHYw6Eh
         5/Xg==
X-Forwarded-Encrypted: i=1; AJvYcCWxAITTlGWmXLx6BXdHdZGYLaIcQ1TjQ8WeSqSSom1deAB7dmqKDk+m06i/ezhOYBxstAFPdXBxDg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyAuq1TEvGkiauTLM+5LflWRrEzysc336t7n96AYYSk22I7aDuR
	qywCWRfGq7hRdYK78MFyS6Y+r+QB8JBR9zJuQMWzR+s35jjWdoiRzASceQsEYID+wGw=
X-Gm-Gg: ASbGncuWqHHCuXCeJlAaDW8pcckKsK0FuetUv3WIXbmjciJj9H2kDcjFHp7q8XYhRji
	SE3RBoaXIDIqBRJAvgDmaS+NzxyKerkkP6YjM8eItYatkx91yynurkdlkpVaZqpmJDU+ZYbCGSi
	cvo5F4UtKjNIX5IdFVP7vip3G8oarJ1b0jPgbe7a5OEAMe4tt+rk/RhDffeYV0t6Mqt8jCuz6hj
	13BmTv/y88vIiXsAqXG73Z3/IA/cEAd1WH38tbpfY246gfLbSbZnONny2RYXf9fJKh2fTlQLEzL
	GBSBe9Ka/8Vp/Xu9wYwZQbdhVNzdIN+wkZ227BDzxug6vlYnlbHSyRqPsf8t7avkcg+ndTOO7KJ
	sRVGl/FIsRoGcylRKryo=
X-Google-Smtp-Source: AGHT+IGWDyFo3vZJl2AAeSnDBnU0spXfdg6K85ezZJaKYzh1+2xoWw4ebe4nhqg5Fq4S4ALzSVzdmw==
X-Received: by 2002:a53:ca4b:0:b0:5fd:dc27:e11f with SMTP id 956f58d0204a3-61028bc2afdmr123022d50.15.1757100235889;
        Fri, 05 Sep 2025 12:23:55 -0700 (PDT)
Received: from [172.17.0.109] ([50.168.186.2])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a832e435sm31900587b3.26.2025.09.05.12.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 12:23:55 -0700 (PDT)
Message-ID: <51f10765-1d74-48dd-8d5b-76178cf5dc66@kernel.dk>
Date: Fri, 5 Sep 2025 13:23:55 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] io_uring fix for 6.17-rc5
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
 io-uring <io-uring@vger.kernel.org>,
 Konstantin Ryabitsev <konstantin@linuxfoundation.org>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <f0f31943-cfed-463d-8e03-9855ba027830@kernel.dk>
 <CAHk-=wi-jomx2=9jRbUz0F_AQ9vKs2uN42mPsEurYNQsUCJn-w@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wi-jomx2=9jRbUz0F_AQ9vKs2uN42mPsEurYNQsUCJn-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/5/25 1:15 PM, Linus Torvalds wrote:
> On Fri, 5 Sept 2025 at 12:04, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> IMHO it's better to have a Link and it _potentially_ being useful than
>> not to have it and then need to search around for it.
> 
> No. Really.
> 
> The issue is "potentially - but very likely not - useful" vs "I HIT
> THIS TEN+ TIMES EVERY SINGLE F%^& RELEASE".
> 
> There is just no comparison.  I have literally *never* found the
> original submission email to be useful, and I'm tired of the
> "potentially useful" argument that has nothing to back it up with.
> 
> It's literally magical thinking of "in some alternate universe, pigs
> can fly, and that link might be useful"

Then let's please define the rules. I always add a bug report in as a
Link tag, if it exists. I think we agree that's a good thing, because it
shows the origin of the patch and what it's supposed to fix.

If someone sends me a patch which may be a bug or a feature, add the
link IFF discussion actually happened there. Useful discussion,
presumably? Because what typically ends up happening is that someone
sends a series, and there's discussion, and then V2 is posted. Repeat
until good. When Vn is applied, there's zero discussion. But a link to
Vn is useful in that it helps you find Vn-1 and so forth, as it leads to
the cover letter. We can put the cover letter link in there, but that's
not useful in an big series, as it'd be in all the patches. Create
temporary branch, apply series, merge into branch where it belongs and
include the Link to the cover letter? Or the cover letter itself?

And probably more?

-- 
Jens Axboe

