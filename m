Return-Path: <io-uring+bounces-7422-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A7064A7D0DB
	for <lists+io-uring@lfdr.de>; Mon,  7 Apr 2025 00:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FAED188CCB3
	for <lists+io-uring@lfdr.de>; Sun,  6 Apr 2025 22:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A6EC188587;
	Sun,  6 Apr 2025 22:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="byIfw+PV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF7F25634
	for <io-uring@vger.kernel.org>; Sun,  6 Apr 2025 22:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743976838; cv=none; b=nuwMXYHNggZbzsx05f7RoXTG74bPNcbqrLvEtnND0sWmAjcteA2PBag+WTZC9V2OZFvva7KsoisRTlCKDbgI10FViiRWR03BPWuPSQBGUpRZXh1biznPe1VMipmtVD6lPh9tWHcLzY0tqwca0cI3oBWOprYNx7G35ziamCwO8XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743976838; c=relaxed/simple;
	bh=NenNfLt56wsUL1jj9zHUnnqcNUDN203dseeyclvBJQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rHEtB0VtwYOiNYU7zeIfmcYXMCgHzvI5B2UJa0XFNd/JhAsUH/rJiC1HsAbR5DdiM96mFaVgRFZ9xQ5MLXxkZR9WVaOyYGMHLAbZaOK8d6+Faj2n8WiiV8Cxx9mMF9IxYQFSkTLq+JP0gsSlRtouwEbtsgJLxivuFR7TUgQC7xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=byIfw+PV; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ac298c8fa50so626973166b.1
        for <io-uring@vger.kernel.org>; Sun, 06 Apr 2025 15:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743976834; x=1744581634; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TNEj3oRQc7i+proNhaHKnpBUf6WAE4S0TVYwxPkXTOk=;
        b=byIfw+PVOWZuquixDEiMPNwmI8ZBw+vsFl+EQyWbIxEa+hnBxG0nKLwHyL8EFl1Pd0
         EGLQZaFc/FoiWbu4ogl8dNm4Ar+Fb5tDYGhNJh5dDg7gZBhALyesFqcS2dTpEugLVI6s
         7ZD7JkIXcCQ6kEDQaoUw6Q+WD4calrVWCrVwanURUbosaA47MNobem68eFd+NeVNyowu
         YMyEWoikC+hjvWMyq+4b1+SCXl6D7iRoOud/+fgz6Hm/33UlulZ1+ORCww6FsYwsL3gv
         +iK2Gx85YGWfKl43RnxyKkWPp6fnD9qdZdncYJERTISHGyyPkgr2Cfy62F5vJjhdWita
         bRCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743976834; x=1744581634;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TNEj3oRQc7i+proNhaHKnpBUf6WAE4S0TVYwxPkXTOk=;
        b=joTaagClnZiK6OVqLbUSahehRwm03fSDWXcRHvtMLCrCZnYSXq7kBEHjOtM2hhuAri
         LzqfpkpPRybvOA3O/esiUrZVqb0zZJxgzsuZzlKIxprV6fJxli/Zb1FxVI1MChS/zn42
         NBrgNeFsh7GA7yMcDAFuTMXHjdd1BH7knPoYMfYWucwmjPjdFn3jpdIuqN79s0dTQPJv
         fh6Tu06SlQQui9ZT2NcVzzpsl1ftkXGTKr3J2QrkPD966OD5ub3OpZ710YCaJi0TQ6Y4
         TuY5HYGWDjJYKAwPIo6N2HNwKLG8PTzVfKWTaTO7yFJ2zHeovT0zkSQOdDAgcjwBXVxW
         6V1w==
X-Forwarded-Encrypted: i=1; AJvYcCVCfwget6s8bWTwK2TsokYOiuK8IlCLSl3Fdu+MAa70vfR9ai+G/IyZWNJbHebVm6VkZquBuIyWgg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFpy9jvQLZFIaW0GAJk/4zPICIAagzT1LEwu/CYNRqYEhZatWV
	uoUy4ZLitiCIHm86qB/7OQT6XVpKuo2Dcj/sTrpj8CBTRCR58NHUbCasNQ==
X-Gm-Gg: ASbGncutXRmGtzwxgBuA8PFx6JrupfRLfcvhXFK3QwhruI5teYrHwJug0XZZ3lAGjJO
	Q6gtHngVJo2aaqaEd5BIx+2EXpn4k+9JxvH8uc2iV56xuwq8035UWjKOLP+NR6LzQMdtdPcynoS
	eKYenElBLxm5RQ3w2yIScktq9iolFKtbZzKhrvpF7xEgFfzN336cOD4v4pu/X7LuSXxcnFBmn6Q
	A6nADGV6kkd5zR78Lo0LQEFU0go2zq0v8vI+w5hVFuAZm/OKBykrCAhqMBIm9slsgXR6NBflVpM
	U7CWxCYULfkLin175K/eKb0lcLvZdhdSuRtHULOmKGw9PDgzCeK5zBCjKP8HNf5g
X-Google-Smtp-Source: AGHT+IGXU4H6USw6eguPgtkpT46G2+MCNRv7Luwc8mUUfBS+hPV5v5iCfDFCxPQkhMRKiNCSaHV5Tw==
X-Received: by 2002:a17:907:7214:b0:ac6:b811:e65b with SMTP id a640c23a62f3a-ac7d1821920mr939825066b.36.1743976834353;
        Sun, 06 Apr 2025 15:00:34 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.147.68])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c013f29csm634924366b.113.2025.04.06.15.00.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Apr 2025 15:00:33 -0700 (PDT)
Message-ID: <d7a31a1e-87bd-4a3b-abbb-f1e26b2a03f8@gmail.com>
Date: Sun, 6 Apr 2025 23:01:50 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring zero-copy send test results
To: vitalif@yourcmc.ru, io-uring@vger.kernel.org
References: <5ce812ab-29a6-4132-a067-27ea27895940@gmail.com>
 <f1600745ba7b328019558611c1ad7684@yourcmc.ru>
 <f7e03e2c113fbbf45a4910538a9528ef@yourcmc.ru>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f7e03e2c113fbbf45a4910538a9528ef@yourcmc.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/6/25 22:08, vitalif@yourcmc.ru wrote:
> Hi again!
> 
> More interesting data for you. :-)
> 
> We tried iommu=pt.

What kernel version you use? I'm specifically interested whether it has:

6fe4220912d19 ("io_uring/notif: implement notification stacking")

That would explain why it's slow even with huge pages.

...
> Xeon Gold 6342 + Mellanox ConnectX-6 Dx
> 
>             4096  8192   10000  12000  16384  32768  65435
> zc MB/s    2060  2950   2927   2934   2945   2945   2947
> zc CPU     99%   62%    59%    29%    22%    23%    11%
> send MB/s  2950  2949   2950   2950   2949   2949   2949
> send CPU   64%   44%    50%    46%    51%    49%    45%
> 
> Xeon Gold 6342 + Mellanox ConnectX-6 Dx + iommu=pt
> 
>             4096  8192   10000  12000  16384  32768  65435
> zc MB/s    2165  2277   2790   2802   2871   2945   2944
> zc CPU     99%   89%    75%    65%    53%    34%    36%
> send MB/s  2902  2912   2945   2943   2927   2935   2941
> send CPU   80%   63%    55%    64%    78%    68%    65%
> 
> Here, disabling iommu actually makes things worse - CPU usage increases in all tests. The default mode is optimal.

That doesn't make sense. Do you see anything odd in the profile?

-- 
Pavel Begunkov


