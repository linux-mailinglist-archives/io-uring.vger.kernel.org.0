Return-Path: <io-uring+bounces-11624-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DC343D1B9BE
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 23:37:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C59543047198
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 22:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 217AD3203A5;
	Tue, 13 Jan 2026 22:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zTwVlFru"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7FF632
	for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 22:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768343838; cv=none; b=DhIAsPlpUM2YbZ8ERFZD8r3l5lOZ11OjQU7Py7GIddt7j2xtrcnp6/eMj8i34cje3VeGpx2+otqc1mSdZ1TuLzh9RdryDasBVsIlXuiE3kPcTtoAKXXKFmWS9Rvdqi/3t8NGqZF/YEa+xd6xLogIDb1K7Rw69CAS0WSjrMGxXww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768343838; c=relaxed/simple;
	bh=1gRHqxkgkMgsfY+XR7t13KGaTxXVlYq6I0TbOzmD+gc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GPNuHzeerHnpumJdkIWoNfYE6HY4Ew3kq8UgXbu6FB4vRK7YKUVb3+m9MXqxTR57fMf4vzTo9l3XRmx2xGYxgpxcUxzZNwxokPQXuTnVpHqot1HZSWDFox8e4P72mEoyje+NqglsY7u9PwSYRNmT/ChGe3nlc8DXRtLfzMBAZig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zTwVlFru; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7c7533dbd87so6302281a34.2
        for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 14:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768343834; x=1768948634; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c5e4ahrcoPGo/J/QT+BRTCZXxjRxmM4qxMK3sQDtB/8=;
        b=zTwVlFruUBnPuyxI6kRFVYCNQoL3hoeDEL7sTmIWYLLD3qQgLcasclR4vzihYxrVP1
         eUHB+/yIm0QQr3H9yBgx7RK1NagtIWH1LZQx2jLl4ilB45lPT8bn8jkxX0xz/P3C2iDa
         dIFlDcJUPG3MrFKO84Gk2tgOOAJVTQp4fOEFQUHNzKDy0mzJkNvd87aqS1cBKuUdOgZz
         jkMIAAoYb+tx4gz4OkFOkF9XWVWknCEsqxc2L9wH8xFbuwDXQSBI4nDuFNKicF/n/RTI
         zdsEY75KikzsqW5k3KTNKzGkdTsuHY0ffJpCg+5PFuL4BrvrcUtwQjqi9tg4P1cRxloA
         f6AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768343834; x=1768948634;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c5e4ahrcoPGo/J/QT+BRTCZXxjRxmM4qxMK3sQDtB/8=;
        b=jj888GH5Dth7Kp6FS2BursoxfBoMhuUdADJd03MjXbFrxobMaYsJpDkOeiC5CBg+zb
         P8SfrOJEjClJIHae57jkoq4sxd8URF1K3fnA7vLTfEp4xVDqoFFG/NNCFAe+RLG13rhm
         l/a4OfDdsRcyYeJzKLDAzA3aqcqM7cyH4LGRPy/SmHSdiyuP/SNI7DghtZbCJ7OGWP3n
         vSk2T7Cfj1XBQ9AFWFdB15OB3wlac9jnJp7057Mj90JSqeqy8Ta1nGivzWNE1D2vXv5v
         q0TLvOojDQF5fHZvn+0rwl02+wfynBcW2Mu+FtycF7hq0H/E+J4H8vfWHf8Q0aGp1qM1
         cdUA==
X-Gm-Message-State: AOJu0Yz4GXmzKRRBRghQOsIl3SomF9rcKKEdW/0J7CMhPWTDpMZlTK8N
	/utHamblaByLYuu6xFnRsNhcB4zSSGMk1G/gHwuz8iuwcgjR7kkls776AmiOJWzPnDE=
X-Gm-Gg: AY/fxX7MoFji9VN9odUbk/SbxvVzClTz9MUcx5JzSezMHOOyY8jccXbcC7zEe9I3nxF
	MsuVqiWjqLGDkzyZqX/MZTuDtzaZOq/05xeJg5+DWvnOVDBNpgLFxQaWtTAcLDPusobCAjDFNRF
	30T4/ljMzyF9qgJo0JC+Z0VNfVnQu8VMSKYJ+iIzFj6Axy8RVN2TkkiIB/Z7UiluVt+W8SNpck3
	/TIjvTsjqOC5QnFbxdZwZMBOrNNQAloddkrRPy3uQ3fkdD/2wcRUj+SMzsWpzY2GoA6ZoRPpVJY
	clMqYWfopkmvdHz0Kn6S/QG4twjR2U2TCGBqR/xMC65boDaJRgp/pIew/8XJBhbSRGddNYUmCE9
	sOHthRA6DbEavYABwcRoq8BrwyiYCjHJWaepKgGsq/q8SNTz6H+NM3qqY6NvhJJeltPNWr4hKEU
	S5dQ3Wb610
X-Received: by 2002:a05:6830:4ac5:b0:7c7:51e4:1360 with SMTP id 46e09a7af769-7cfc8a5bc7cmr467610a34.13.1768343834507;
        Tue, 13 Jan 2026 14:37:14 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce478ede38sm16426630a34.26.2026.01.13.14.37.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 14:37:14 -0800 (PST)
Message-ID: <d3a4a02e-0bcc-41fd-994e-1b109f99eeaa@kernel.dk>
Date: Tue, 13 Jan 2026 15:37:13 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/1] man: add io_uring_register_region.3
To: Gabriel Krisman Bertazi <krisman@suse.de>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
References: <6ba5f1669bfe047ed790ee47c37ca63fd65b05de.1768334542.git.asml.silence@gmail.com>
 <87ldi12o91.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87ldi12o91.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/13/26 2:31 PM, Gabriel Krisman Bertazi wrote:
> Pavel Begunkov <asml.silence@gmail.com> writes:
> 
>> Describe the region API. As it was created for a bunch of ideas in mind,
>> it doesn't go into details about wait argument passing, which I assume
>> will be a separate page the region description can refer to.
>>
> 
> Hey, Pavel.

I did a bunch of spelling and phrasing fixups when applying, can you
take a look at the repo and send a patch for the others? Thanks!

-- 
Jens Axboe


