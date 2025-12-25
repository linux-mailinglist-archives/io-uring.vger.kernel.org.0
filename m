Return-Path: <io-uring+bounces-11308-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 12241CDDDE6
	for <lists+io-uring@lfdr.de>; Thu, 25 Dec 2025 15:58:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 97440300DCA8
	for <lists+io-uring@lfdr.de>; Thu, 25 Dec 2025 14:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E56A1E25F9;
	Thu, 25 Dec 2025 14:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LSL3XT14"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C29B1917F0
	for <io-uring@vger.kernel.org>; Thu, 25 Dec 2025 14:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766674697; cv=none; b=Uj39+seeAqxW4btgFgo64OxyGeUM8iTBnWDlIlRIs1CT3lJ7N+JPerPij6ko12FUi38yS/UlZJNEltlza2AHKSmMZZJKwos/rT9RykE5C1LkW6TTiXLY8wvUbCzrc8WoEkyiN20jtaIzj31kJu35Z9JORBm/4S/Nbd9lLG70xSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766674697; c=relaxed/simple;
	bh=jhTPnm3oFKXz+ipm0uIVJtKtcYoNuBr7fAjHpdYN3Hs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RTF7jh5oB8oj7kT4wrrSkcDatWeByG8GCbNNlo1Kzs6dmj8EFN4AQAdos6jL7WJjstLeyyf8JCow129Oq2UHW4W2JxrTjNGaXkdXp/TsGHJvRBXeiTNzBS7CjqJsiEybMjBmYqP99AQlrh3TIwHBC9IYGKqII6bIyz6oKdEAiNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LSL3XT14; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7c71cca8fc2so4131676a34.1
        for <io-uring@vger.kernel.org>; Thu, 25 Dec 2025 06:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1766674693; x=1767279493; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hji0XicsQUErLbiGDeZxt0h7DdgSYTr09a/lmErjN3k=;
        b=LSL3XT14eYfRHLYQpmcNNry5SJFcXGyVmrwU50G8uJTjnuWxtyMceIiIquH6tVBDug
         3KWGrDpL1rFXV+ZiapNg8QLxo9tjTOH8cxfIAmV4HqPd1ZYSlIyLtGve+DJt3d2pV8xP
         AAoj/AWdg2I6JA7UBS9m2e0ehRInlDvoFe6pW2rzy2xxuRDKKKh2HUBqCneAEVbHW2ov
         WXVRAW8bJxxvoa51L1xFcDJ1T8yQJk0Bfj4382MQ2633QNkwoP/PRXKL0M1riFroRAs9
         6SSykEu2BgOk1HNWMaKZcO3L7vQZnrju9Gh1/6lTYb0Ry2vFT9O0F3y/pMCJ8Wc0SvPP
         VEEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766674693; x=1767279493;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hji0XicsQUErLbiGDeZxt0h7DdgSYTr09a/lmErjN3k=;
        b=mBPdxxgfaQGLpsTbdsFieffNaSt5T1lvtVTtUHS/ImWEWqUaYJlGrFoRnsA+UcGPQg
         2IypkaD0uOnd96gRnOxcKwDJVlBbWLlcMt9LazkYB6XquScKYaxx6EyjptGknCuTCU+q
         0/F1oWxyyTKMJrbez0YLJ8b21wxVNiHr6VAJKVDzR7BWHw59KeRAc5/fbTBYFCiBk7Ni
         9GyjRZCevQlZv17SwdCSjs8dCMa9vcISLksqib4x27NTnpUX5ckWhVFUQBj/OMoDapsh
         TdfdI1qeLoSO24rOWiHLfWpIr6sevp8RrCaQnlTYfxd88gpn5OQ1YFSvFZ8aLyH4LlfD
         4BSw==
X-Gm-Message-State: AOJu0YwPP05YOutcpl/rh4Esn9mSjd2a889B+G3pVXN9Jx9AU0cDGbmJ
	/LXDrufGx/iigO1+r62FgnKvDuLJCvNR3V+FtIpmVpdhifq3adj2o2htawb97TNbseU=
X-Gm-Gg: AY/fxX4rjOUtYFw10DA0cgEi7t+o+72nHrgi8i0KEkmtG7MouqjT4dZw0DfnnYCESMI
	Uv/zPNWnqc8qxTZi7VEOsdReoIc3II5QjP+f5/JC1YNM/EdnMR5lgwruwKidGpRheOc7C5rK/Jn
	7siWia5YcDkno/QZLBMmlpTjHj0VYZ6a51YHnB8DydG5B9aJHg/PcHIa0mfUE5mD6DweWd7Fn+q
	a7MbBLfSK3aYcGpVeJWWtXLvQqyd8StnOId23S7ZQdR0mtOmBQiXV1erd73StEWN/xA061pnqzz
	iMnEs9JlQAaGlLrwxavbsPqg40nxC4yigiQUdAHcOIioS6ayGnmvVHUq1w/M/engRtPUCxS4dVg
	Y9I3X9e0eiecta64DbPV8tJWWmpLKOwrBhUDqD1TRCOCXBsgO6QpcIrOD5yOwAlb1mxd8wRDSkV
	F+AYM/JWm6
X-Google-Smtp-Source: AGHT+IEl06568X86BVzNgKQ7sr4wYLSEd+yHkAPiNbCo94xUa63OAJFZtsNW2hDsBmep5OZidthgGw==
X-Received: by 2002:a05:6830:410a:b0:7ca:f50d:b2fd with SMTP id 46e09a7af769-7cc668b669fmr12509788a34.13.1766674693021;
        Thu, 25 Dec 2025 06:58:13 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cc667ead3asm13308380a34.20.2025.12.25.06.58.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Dec 2025 06:58:11 -0800 (PST)
Message-ID: <564afab7-a894-4da8-9980-7d68a0a1babc@kernel.dk>
Date: Thu, 25 Dec 2025 07:58:09 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: fix filename leak in __io_openat_prep()
To: Prithvi Tambewagh <activprithvi@gmail.com>
Cc: io-uring@vger.kernel.org, brauner@kernel.org, jack@suse.cz,
 viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
 skhan@linuxfoundation.org, david.hunter.linux@gmail.com, khalid@kernel.org,
 syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20251225072829.44646-1-activprithvi@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251225072829.44646-1-activprithvi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/25/25 12:28 AM, Prithvi Tambewagh wrote:
>  __io_openat_prep() allocates a struct filename using getname(). However,
> for the condition of the file being installed in the fixed file table as
> well as having O_CLOEXEC flag set, the function returns early. At that
> point, the request doesn't have REQ_F_NEED_CLEANUP flag set. Due to this,
> the memory for the newly allocated struct filename is not cleaned up,
> causing a memory leak.
> 
> Fix this by setting the REQ_F_NEED_CLEANUP for the request just after the
> successful getname() call, so that when the request is torn down, the
> filename will be cleaned up, along with other resources needing cleanup.
> 
> Reported-by: syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=00e61c43eb5e4740438f
> Tested-by: syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>

Thanks, just missing a:

Fixes: b9445598d8c6 ("io_uring: openat directly into fixed fd table")

which I'll add when applying.

-- 
Jens Axboe


