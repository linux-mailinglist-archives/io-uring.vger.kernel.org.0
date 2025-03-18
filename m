Return-Path: <io-uring+bounces-7106-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 50B26A66B9E
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 08:30:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1077E189A66F
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 07:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E04E1EF364;
	Tue, 18 Mar 2025 07:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rht4e5qS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7784C819;
	Tue, 18 Mar 2025 07:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742283000; cv=none; b=BMYSd4Cs8CjxPLMCcHTNakzC30G4y6cheWv2olXoBDljuy67dmiVwcnJIRNq9ADl2am6Faa6UYtq+7kkibad35zlO4OhIOi9XwFG3r38bvULHlB08zbVsVPbWpKtv3akUbibnlhdkjGigQPJsnx0LL+nkGr9VFDfpKtZH5XrKwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742283000; c=relaxed/simple;
	bh=tcvxj4PIa1waBBL6l754/qOz+8d90FeRW4GdsEEgZVE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HWPjxXfIGcd2xuNvJWEMlFOtUkGWRp5Beo7lBhzKOwLvxK0JCN4gse1pJGbJIbu7HxZLnvcPgh2aEiHtsqHlZEjz/1BaJa+u7AGO7F0XXwkbjGj2Svnu5LIT0tvDiGqDZAzHLn/SLyY4YsoeyMFUaYD5aLc6BlgflB8+nReaKpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rht4e5qS; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43948f77f1aso20705865e9.0;
        Tue, 18 Mar 2025 00:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742282997; x=1742887797; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dEkSf7YkQseqbRIT+58nKY7l+ePmbHGz98Q/dsgxupo=;
        b=Rht4e5qSHUZg504X0ZkHTTisEsObwDHur3ueJMep/xv9BpKY9lC0jGr/PxRljxXbDt
         LSRcpXBZ4taQwkehuS78n+pyoJIRBrwV27X7zLuRHjR6i1NyqK74RI4rADk/0efuYq2x
         7/dDRmDd0iv84zQqiCEVFoEpu1TQOY7332V34pO9JDEcPZXKcDKt4wQGszEkj2bYx+X3
         1+Ji5ZoHXYHMf2kY8Y/GVhov+j1MwHQySv7f3ASLoDSFUCE4bkGYEdeziSUSpa/W0XDJ
         kREfc8FXk0oKcaDNAM+gDOKPdBSB7xG93Qa8aRrZDBgUlsykF2JyJj1GT7fcNDpIrfap
         9Krw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742282997; x=1742887797;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dEkSf7YkQseqbRIT+58nKY7l+ePmbHGz98Q/dsgxupo=;
        b=Cy/qeu43BNLBXeCayvaUnZ3wswuqTIDDGO7qoVJAzUoF9+931ieN9a7Kko8MEKarWF
         Nj35+zKdoQ4x0ZlRHHJ5phyZl7IjXW6LygkRqgUdcGjF7jv6lh1sgUhSExePwt218tVN
         AWrOzcpltMV1Zuj1vrfu4XjhRhauKF05njXEvDmn1QsCQQewmrhKgoGsdXDYnVqqRyEP
         sHcIZ8I5T/fIbNt2pw4/m1J23IKxZn1d1drqiLrL+dVvkPawDSoOhwKAsodJI9xmnpP8
         BxoWTftmh03aP8uD5P3pNhd37+NdyMcT9iaRwvzOap0b/3Vui0qKIPQt4JxsUMcK4o7S
         te5w==
X-Forwarded-Encrypted: i=1; AJvYcCX+m2Em+JMFlVF54IMERzzOyZC5F0ozZ8c56ri7O1Bx5N4nX5W/PikcQnOm021D2Gz1XBUU4W1OgQ==@vger.kernel.org, AJvYcCXsj5AEOhB0QYVc7H7dFI39F/OtAKIBrHgecv9sAAeXfR2K1B3buom6WTua872CPyigVj2D0jxgsRryZHsm@vger.kernel.org
X-Gm-Message-State: AOJu0YxGpr724liHprA0yPLSJ9W3ichld2u+3xtRiWisoYwg6cau8Xv4
	69V6eKYm2oC9KKJFQOSKLpXYYKhDOONf7W1OBZyqH9HMroC8XeR/KIdEmvfF
X-Gm-Gg: ASbGncuHOCNH9GbphBxuRq2t1j8Z5kGguqI2FNNnxMEFbkjwF0CH/GoBm6BtvdwAOTO
	Sfd4Ajyh0msFSbDg5COpO1gSQTPf2vdtKCP3kBkaCo4aiOyLnyBcAzuww0FgUaPFrM1Cv9Ps9wl
	xU451BTQGAEE26RTBJL4WMXN3415Xv1/56yWzyHfjppidGKKcP6+jEEA1zjlDEmMtdEb5TJC+JW
	Ypzxw2zR4p81zyKc60MghTH4PKdg82cQhBvUKVIQ1bgkrFb36+ROnUMNsQAisYhOBlPswMYNyJZ
	rTFxRHku7m1jHfSSDWcQDGd5PBwaKqbCQ5PiiXgIcIvhwCP/oMkcucckQvMrvHu2z4hv0Y2EUA=
	=
X-Google-Smtp-Source: AGHT+IGGIOPDAeHE8IwCdogCBZZVdb4eMCRh750HNjE8cfxw/VQIyR4LHg7IZo8p/U8isipy1a/o8Q==
X-Received: by 2002:a05:600c:1e1d:b0:43c:f85d:1245 with SMTP id 5b1f17b1804b1-43d3b9a340bmr9408555e9.17.1742282996499;
        Tue, 18 Mar 2025 00:29:56 -0700 (PDT)
Received: from [172.17.3.89] (philhot.static.otenet.gr. [79.129.48.248])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d1fe152ffsm125536935e9.13.2025.03.18.00.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 00:29:54 -0700 (PDT)
Message-ID: <fe4fd993-8c9d-4e1d-8b75-1035bdb4dcfa@gmail.com>
Date: Tue, 18 Mar 2025 07:30:51 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 0/5] introduce io_uring_cmd_import_fixed_vec
To: Sidong Yang <sidong.yang@furiosa.ai>, Josef Bacik <josef@toxicpanda.com>,
 David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20250317135742.4331-1-sidong.yang@furiosa.ai>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250317135742.4331-1-sidong.yang@furiosa.ai>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/25 13:57, Sidong Yang wrote:
> This patche series introduce io_uring_cmd_import_vec. With this function,
> Multiple fixed buffer could be used in uring cmd. It's vectored version
> for io_uring_cmd_import_fixed(). Also this patch series includes a usage
> for new api for encoded read/write in btrfs by using uring cmd.

You're vigorously ignoring the previous comment, you can't stick
your name to my patches and send them as your own, that's not
going to work. git format-patch and other tools allow to send
other's patches in the same patch set without mutilating them.

-- 
Pavel Begunkov


