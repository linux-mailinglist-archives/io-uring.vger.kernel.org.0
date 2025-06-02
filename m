Return-Path: <io-uring+bounces-8190-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D3B8ACB90A
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 17:54:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4923E3B0E8D
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 15:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9978A221DB7;
	Mon,  2 Jun 2025 15:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aHMfpUqo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA639175BF
	for <io-uring@vger.kernel.org>; Mon,  2 Jun 2025 15:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748878896; cv=none; b=kmc98mVBPrZFOBak1TLg6hHX4mVK5lyKEwqLBPIKQNikDVAc1UqQpDDNSB3ibPIC+duRPQc7e0WI5xWMiJSmKgrUR3PlAT3Ik581lXQ5MVcyguMrMFsvvv9wSiRvSrdDwEV3hIZaKeefizvsSt1v+dJfGIRbmvuylaWoNl1lqNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748878896; c=relaxed/simple;
	bh=sxSWYhV9G7V5ejIhJM/2inXd3xFFDbcg1M1/m4COJ0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=EwkQkDu8o8sIYtknf3i2ZcOa81eq5CAFTFsKCHZfzr5dWXCjx9+xAOI37ZfcWCVl4pPxYktDeByXG+0l1+qGSKr4gPA9jARXastrzED9P0h3QBIK4g8oeZGp0LcBe/Hh4Iwo05+pcxnYzxTulCGKPY7AtHaOSOk2A0nQWQWZSCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aHMfpUqo; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-86d2d984335so203179039f.3
        for <io-uring@vger.kernel.org>; Mon, 02 Jun 2025 08:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748878893; x=1749483693; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9tACN594XC/T0M0VtSDYk74zSDy7r+dnG7sNaOAP8k4=;
        b=aHMfpUqoSr/ojdQHFaAj6ibFSUGpdoAjdU01vVE3KJawuyXPVtTehWdxtpINDsKp2I
         FJQZUFZT1Pw9UG1h00yV+xnGfYvOMftduKpw18DxF5Ajj3QW34I5vrUqID78dtPUHMgp
         zUyHT97gxLZ0AFvOlD7csT0kqgcgPHm2MlzyeOHHTGZZZyJaCv5FBImcVVUOEaxLn8Ha
         lqxRwT/54cvKZ1Z+V6RBzD7trYis0P/Rm1+XCxWA4HIhIv4YW2oD71iFqUe8FQPh+Bsz
         dzrED1fA3RT/p3QPSpstM6vDmvLDe0D8O4Ve0ooXEJfHbRc3cZuxWhrBCW9adSzHTPAJ
         Zqhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748878893; x=1749483693;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9tACN594XC/T0M0VtSDYk74zSDy7r+dnG7sNaOAP8k4=;
        b=wT2IAhlztgUnA9URYpW4mYfMUw8N3MY8sKbfJs8jazKPNJmPPheWCt3FDPUYlISDHX
         9OwuYiM+gfObA7XulL+DPnai5iw7T58RFO66Kt7rjAlsslapZ4aIB+ta/JwPhStwoxnx
         pmLUFSnGYAIRR4cMdfHnOw8YbhfEEJiq6uovpQCeDSa2ZxX6fvGp3zFP9reNiUOat4gR
         hceecWD9qJZkLFplCWHW06RjUiS8BB5QmoAuJDvguYMY8uBCaOE4ftOvFo9Kwr4pDVkP
         7TVpAzjR5Ef3VyDWBmsVhsNu1jExHVw4YRLCsLhjEP5I0864QMLzPs0ee4xiTSU2i+o9
         TWIw==
X-Forwarded-Encrypted: i=1; AJvYcCXXbOq2ngTXgOCmnIHTtpm5Dv5spAeoiU3iGGNN7FJ4eZTMf3cQ7e9c2N2KBAcrzj+qRHgWOz1L7w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQrViigkRB/ePVQ3YGnnWxWmX2I9dlr2xe99eCq1CbTLr2FE6K
	7sBZPszYOGK4wqtL+Z5nR8zc+ZvYRfGNfulsimdSKq9XPfeN5r/Sy0mH/Na/Yc+o5G4j3JMzwTe
	0EBwx
X-Gm-Gg: ASbGncus1YT8OiAy/p1Xj7kU787Jv0EXbDXxb6PhzAfgV+ph14OzoS6SWPi2HcNfx6u
	HRH9+fzbBEXvAo0LRwvpmwwpLGYIlRVsmk1rwZxDW8j2H/pJW9LHBelQRP7/39dJON4qKBPJ6Zd
	eGFq1u6pwpi9/QPJut+4+Et/2c4NQKozjwemM6cTQjDrdInOg6eJ8o6bwjtBU8IQVjUexgsut+b
	ZriFngbixESBpuDGL532FOKwJdF0ZF2bOxjkLEn0iuvAX2XbRNw6biMfyq7Wxglw9Vn6vKLZSbo
	ZtUXrsr3nHV/L17h7dsfPOeRL2ul/L+tlF38ods67GOuUrI=
X-Google-Smtp-Source: AGHT+IFbq/GrEA3Q5q1M6EpjwlTIwX6m8yt28tg2BDOeXgRFpzSALoO/XHEES3dQz1os+f8ZHAs87g==
X-Received: by 2002:a05:6602:3f0d:b0:86c:ff6a:985d with SMTP id ca18e2360f4ac-86d0519267dmr1588669539f.6.1748878892917;
        Mon, 02 Jun 2025 08:41:32 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7e3bfc8sm1768176173.62.2025.06.02.08.41.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 08:41:32 -0700 (PDT)
Message-ID: <29e97864-5406-4338-81ef-4974881e74c3@kernel.dk>
Date: Mon, 2 Jun 2025 09:41:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] io_uring/mock: add basic infra for test mock files
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1748609413.git.asml.silence@gmail.com>
 <6c51a2bb26dbb74cbe1ca0da137a77f7aaa59b6c.1748609413.git.asml.silence@gmail.com>
 <cf2e4b4b-c229-408d-ac86-ab259a87e90e@kernel.dk>
 <eb81c562-7030-48e0-85de-6192f3f5845a@gmail.com>
 <e6ea9f6c-c673-4767-9405-c9179edbc9c6@gmail.com>
 <8cdda5c4-5b05-4960-90e2-478417be6faf@gmail.com>
 <311e2d72-3b30-444e-bd18-a39060e5e9fa@kernel.dk>
 <ac55e11c-feb2-45a3-84d4-d84badab477e@gmail.com>
 <d285d003-b160-4174-93bc-223bfbc7fd7c@kernel.dk>
 <b601b46f-d4b5-4ffc-af8a-3c2e58cdd62d@gmail.com>
 <44e37cb0-9a89-4c88-8fa1-2a51abad34f7@kernel.dk>
 <e0e4562a-07e2-4874-b42b-1fa48c02c38d@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e0e4562a-07e2-4874-b42b-1fa48c02c38d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/2/25 9:31 AM, Pavel Begunkov wrote:
> On 6/2/25 16:19, Jens Axboe wrote:
>> On 5/30/25 12:14 PM, Pavel Begunkov wrote:
>>> On 5/30/25 16:30, Jens Axboe wrote:
> ...>>>> The same situation, it's a special TAINT_TEST, and set for a good
>>>>> reason. And there is also a case of TAINT_CRAP for staging.
>>>>
>>>> TAINT is fine, I don't care about that. So we can certainly do that. My
>>>
>>> Good you changed your mind
>>
>> Yes, my main objection was (and is) having nonsensical dependencies.
> 
> "I think taint (snip) is over-reaching" says otherwise. 

Since you clearly want to keep harping on this, I said "yes" and clarified
that the main objection was bogus dependencies.

Can we stop wasting time on this?

> Anyway, it's
> regrettable you don't take security arguments into consideration, but
> that's your choice.

??

-- 
Jens Axboe


