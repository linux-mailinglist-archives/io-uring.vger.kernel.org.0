Return-Path: <io-uring+bounces-852-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4582E8750D6
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 14:50:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00C7E28A539
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 13:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C14B612D744;
	Thu,  7 Mar 2024 13:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KTQDko06"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D3F12D1F9
	for <io-uring@vger.kernel.org>; Thu,  7 Mar 2024 13:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709819354; cv=none; b=raPvC9vbZ+3XFHcB8eKqx+icIMs5/ZGTT6tMJ1A2a9juf6LjhBtqlblBa7BF8wEev6izJe2k0mH/P1qwZOxfaa+K8YAZ9nA5aEQMTTK9MSK1BNP3L5RZdCFieFgU7mnuqdyMlbv5XPjxU3P5kR5bGF/VHA+B2XvQPf9gJGZmw54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709819354; c=relaxed/simple;
	bh=cJ2wUxJ1ASoA9JJfHcYJMgj1KQvH9GRMxkmBI46IeTI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gjN/l8gnk0ceW0QsTWvKTZDcnhIuOSjqYo5q4hfpkqMGIEW4j+znZwNMlDVkI8PHlH8j4uTL5krorf+FbQrAckn5eZJMKiXytzf1HjaKTxecedNARamMPooIe4nDRbDW5LGzR3H59+dx+UqytfOFskjTFbb8PPZLF6GSWAsIf3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KTQDko06; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a45bb2a9c20so124344966b.0
        for <io-uring@vger.kernel.org>; Thu, 07 Mar 2024 05:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709819351; x=1710424151; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OGH5osgGoLYvXYa8tgi3g5NusqqjvsNrOaZ7FlMkvko=;
        b=KTQDko06UIzt0OhmuMMFpn6BNKtxWev1wiiX0Ym+CK7FGAIRB6RMQslqfXrXUq/vlj
         //LtRrjzW+SJIGypMEpjCmTfU35fU0/2oAwJh+UOnRdzbBj3le1M0Ocv3TnsWEPSDSU/
         equci9Ml8ag4r8s70kU/XrZeF0rUHZBrD7HdjGGwJ7otL2jciXeBhEyiW43xMvSUAImI
         mAgvWHJCWf/b4LyrhxG5gTRgeu8swlZFmVcDsBtqqfm1BIdMiA/QHTeudzn5tbKXhSqI
         /Z5SVlRYHy/Q4+y+q19j6CxveA0cREHALCFVJSbLU6GLXe5oKVNO84p7Q8of9LMKOZHF
         rG5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709819351; x=1710424151;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OGH5osgGoLYvXYa8tgi3g5NusqqjvsNrOaZ7FlMkvko=;
        b=K0b4eNqubn8tmEC4rgGn/rw8/1cWcM7JrQHQjq3Cfqpzle+vXdrOuq+lI90alHIQig
         grsZwJ2RoNT7yBHfcmwU/sQ2u6whjrZRGhwVlgqDCm1U3aNh26j8EpDFoXcf8uxnsr/D
         WN2lIBv6D7mKlnVkM3NwrJguNJf1luMuu0TzNM29HQN++raxHMKPK3FY0ndexVYsFB7L
         /3aHY9CUBY+lF4rkuasHpW3VdBUCW63KX6ss1JM5l0ZKK8QLBLL8IQCf8WqjaEIpDgGW
         EVKHwg9WF446CWUjsnWuTCI/t9/MBH01E4EfJCeUigluvnM5Wc3e1Ng2SRmrA4b3FV0A
         QwMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOgD0Zwx1mKPQT/pKCfKl0GXosViz4ISecqYvM14kSu7S7xfEh/49LIrIGkZ4ygMvgaVmEDFQJR2rQ4j5k0QuHBIk8zSAY4m0=
X-Gm-Message-State: AOJu0YwZrHmRq67DKo8abk9cTpKsS/76qk0vB+FPJmXNrQ2NefcaJ2Ip
	3avwu2I7+xLAxnaoD8XtGQdk4ZvPx15wgJaT/aUCYEBwsAZpkUlgyYDIirDCrXA=
X-Google-Smtp-Source: AGHT+IEePyPlvDzA/vwqY6mNVg6tNXUbCmSyNq4Dr1qulZpjbU51f1sfsue0ZM6VQPv6DdRorHFM/A==
X-Received: by 2002:a17:906:e24c:b0:a45:30d3:4f55 with SMTP id gq12-20020a170906e24c00b00a4530d34f55mr8623170ejb.68.1709819351142;
        Thu, 07 Mar 2024 05:49:11 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::2041? ([2620:10d:c092:600::1:86e8])
        by smtp.gmail.com with ESMTPSA id lf7-20020a170907174700b00a44d66a16efsm6164803ejc.2.2024.03.07.05.49.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Mar 2024 05:49:10 -0800 (PST)
Message-ID: <99b95279-f90e-41ad-99a3-c7bb0aab973e@gmail.com>
Date: Thu, 7 Mar 2024 13:47:54 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: fix mshot read defer taskrun cqe posting
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <6fb7cba6f5366da25f4d3eb95273f062309d97fa.1709740837.git.asml.silence@gmail.com>
 <faf44f4f-1aa4-4d72-9a32-8038a6554a9a@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <faf44f4f-1aa4-4d72-9a32-8038a6554a9a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/7/24 13:33, Jens Axboe wrote:
> On 3/6/24 9:02 AM, Pavel Begunkov wrote:
>> We can't post CQEs from io-wq with DEFER_TASKRUN set, normal completions
>> are handled but aux should be explicitly disallowed by opcode handlers.
> 
> Looks good - but I can't help but think that it'd be nice to handle this
> from io_wq_submit_work() instead, and take it out of the opcode
> handlers themselves (like this one, and the recv/recvmsg part). That'd
> put it in the slow path instead.

I have a follow up cleanup patch, but I like this idea even more


> Anyway, it's applied, as it's a real fix and any work like the above
> should be done separately of course.

-- 
Pavel Begunkov

