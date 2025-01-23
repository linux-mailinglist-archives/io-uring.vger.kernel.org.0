Return-Path: <io-uring+bounces-6055-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19703A19C1A
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 02:10:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A7E6160C5D
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 01:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD2ADAD27;
	Thu, 23 Jan 2025 01:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rhad0kjn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09C71E519
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 01:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737594605; cv=none; b=IBDr9iNTytw1naC382i1JNXJzLcFEIx0w/u+gLlCGMUmOLiukab9jzsgNkktUpjnR9EpgLI9p0wO/rv9DSXRyJA9uF1Y0D5vPYrtxqS1NVzebpkhhO0Kxzmtm68DgHpzAcIxYYn+R33xbnzEoij7ZhXo170ASmv2t2IB27FAy+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737594605; c=relaxed/simple;
	bh=MHw0qvhnTJJPVQqdH9o+gtSovsANsN0+zim+6qBWE/M=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=hGyvAJa8g9BVUAMfjqyFnTmDf5a+nOlQUY2VGe/Klf64+Hx1fxoqUIEsqgDTo4sYn28AGxC2vuphW1SXrVCiI6v0ZkG0ZkeYOnlWECUkE7IyzmtKt6sA8HZtk5nMBcQKbRb3DlYzvoITSWsvSdgpJBo+Av6bdfSBQcg/KX2snsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rhad0kjn; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4361b6f9faeso2513055e9.1
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2025 17:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737594602; x=1738199402; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pW5nVefi6LB4tdxlOC30BQ16Xhxspqlmownh7ujn+4U=;
        b=Rhad0kjnv122LI1oCZRT3GrNuTRbDRYhxu8gWvYCEPNjb8poNDeDigLfUfVjgiw0MN
         YppYk/nCMU6lnTQydkXkRSjEF5EOJVkVe0bJUQQXBZgOGaKKRRulU7Dei3m53u3dAIIm
         dPiYUZ18KvdTD1hDHaN9e5uX/cKzsnifDZnLHKuSLFKIH75GnOvTS3YmHkfNqy24xQdW
         GfciYbXcOt4jPb2qHCnkdmHvorp5J4d//NQ+BbnqW5jRmQZa2IAfpE5r2iBuPdxwz71l
         5Q0NVdiTbN3fh8ktaMPoiMfPZlk4q8VVwb10niKo1j8hRGOCH9eEvUeF2XQWSd6GYVQo
         z9LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737594602; x=1738199402;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pW5nVefi6LB4tdxlOC30BQ16Xhxspqlmownh7ujn+4U=;
        b=uGAFs3rZG8/dikfvWsZSBYKppkbgSxtl7komOj747Rncuq9tleaxQSIvgIqoA7tBvx
         cWUsIPa3TWziuGI5pzTd1jnN3IL/9wJNiGah0b9vK4NjKubQEYffjqP2tkGltREc+0rl
         8IpOmV96r7LTaIGqzpG1oHCWdoaSlurB3BfjibLxmMLYazbkUBP0zK5KSi6gT/8Dd8Qi
         2wydvFLO5iIfR2TG8gI5LyQVwojFCE2ZYSiBuQUBwGv8GGUwpjT9S4fC1XvuEyJIm1eJ
         Z+FKRDCXReGiJIpAHYfFnwYwVs7oeL2DRMOovufAi2+NCbmHbTWnYk5rv0tJAX5h4ssc
         kLRA==
X-Forwarded-Encrypted: i=1; AJvYcCVsaTnk6hNjHOeSPC5waCA5dwZkkdp/GCY/5K1DjgLAaM2rp4XmeIt9aRVd4MS1ekzdgh0srFodQQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxbsie2BsTyNejlrRKlhBztVqWr0yOZh5H742Ogwgp0SEjbpaU+
	PTMYActXwuch2WjKAdG9ElaSW2kOYzfJ8kDO1qMZpmeTeXc3pmnL
X-Gm-Gg: ASbGncv1gCUzVlYDH0LlDIwM3DPV3DabeXmozDOmFgRsWFWAY65b0X0LYQrQNMOYfFF
	1sIw4QKwgs4QRC6DDimAY5BEjT40dacp211UDWE0BN0w+MMxiH2NncvICYt9uetVfMfNbOMXn8Y
	t/y4Of1ZmDO5uy/tn83oSdo0w96QewaAkoNoIwjLZfyhBNSAFBhLNtQa+RJcnkvQGEa6BUyQAc6
	6TRF19Cb7NfOV2nTOHpbWf89mDbb3cE+dHVsB4pGuq+oHGGF3kDzqLoNlDVUC6qLVwaCIhfPB9G
	y5tC/cmZkEM/fqs=
X-Google-Smtp-Source: AGHT+IFwwG9dDCXEQRcy6GX29S1ftRD6T+I/QRsa8f6mcOgMSAhNXZ7d6AqtJ8iPp1BzE8D+WVc8NQ==
X-Received: by 2002:a05:600c:21ce:b0:434:e65e:457b with SMTP id 5b1f17b1804b1-438b883ed8amr11609835e9.3.1737594601594;
        Wed, 22 Jan 2025 17:10:01 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.156])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b319fac7sm42210785e9.13.2025.01.22.17.10.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 17:10:01 -0800 (PST)
Message-ID: <a7989b50-0ec5-4c78-a251-f1db7df102a2@gmail.com>
Date: Thu, 23 Jan 2025 01:10:35 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/9] Launching processes with io_uring
From: Pavel Begunkov <asml.silence@gmail.com>
To: Askar Safin <safinaskar@zohomail.com>
Cc: axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
 josh <josh@joshtriplett.org>, krisman <krisman@suse.de>
References: <fd219866-b0d3-418b-aee2-f9d1815bfde0@gmail.com>
 <20250118223309.3930747-1-safinaskar@zohomail.com>
 <9ee30fc7-0329-4a69-b686-3131ce323c97@gmail.com>
 <194906b5253.5821bf1b68241.219025268281574714@zohomail.com>
 <ce08e62b-0439-4968-8b1e-510c8bacbf3a@gmail.com>
Content-Language: en-US
In-Reply-To: <ce08e62b-0439-4968-8b1e-510c8bacbf3a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 00:31, Pavel Begunkov wrote:
> On 1/22/25 23:49, Askar Safin wrote:
>>   ---- On Sun, 19 Jan 2025 07:03:51 +0400  Pavel Begunkov  wrote ---
>>   > I also wonder, if copying the page table is a performance problem, why
>>   > CLONE_VM + exec is not an option?
>>
>> Do you mean CLONE_VFORK? Anyway, CLONE_VM surprisingly turns out
> 
> No, vfork is troublesome. What I mean is a task that shares
> the page table, or in other words a vfork that doesn't block
> and has a dedicated stack.
> 
>> to be a good solution. So thank you!
>>
>> There is a bug in libc or in Linux: https://sourceware.org/bugzilla/show_bug.cgi?id=32565 .
>>
>> I suspect this is actually a Linux bug.
>>
>> After receiving your letter I decided to try CLONE_VM. And it works!
>> There is no bug in CLONE_VM version! You can see more details here:
>> https://www.openwall.com/lists/musl/2025/01/22/1
> 
> I haven't looked at the bug, but IIUC fundamentally posix_spawn()
> does the same thing, and if so it's likely that any problem you
> have with posix_spawn() could be triggered for your hand crafted
> version.

Seems I was wrong, posix_spawn(3) mentions it uses CLONE_VFORK.

-- 
Pavel Begunkov


