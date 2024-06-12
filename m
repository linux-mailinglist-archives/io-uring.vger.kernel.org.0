Return-Path: <io-uring+bounces-2170-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79722904837
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 03:18:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5BF3285A4A
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 01:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 642DA17C9;
	Wed, 12 Jun 2024 01:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mdEiVUvS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C844F19E;
	Wed, 12 Jun 2024 01:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718155077; cv=none; b=PDpNYYRCaN6cO1TedhP2B/T3k3D9KZ+liNWiyyLXtajlpYSt8UZai14ismCDw+kkxDpSC/zfcr9VFcPUFCige/HFMVg043+O1e+YvVYcw5iCZNIGTCK3xOikG5Cah8DC4WggOCheqaSCvte57EJi/eMQYFHY/Bg10tT6vrvSF2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718155077; c=relaxed/simple;
	bh=Wpot//ptBnwxFpH8gLdMHLSAI8pYw5L7pb2Ed/6G3zk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=S7Uls4dLedbdjTJJO8UYGizo0iD3JI5XqaejcVLFJ+l4o0VjRCt5gZnYq/GVYOT80ASMB0gnkHYtYFgM9ig5cx09o3J5TGMJ/wUBGW7/W7CCehN/0HRrIJTiMbnwua/2nTtXRZqFbScWRVX/nGL86X7v55qZisps/5zO0HwXM+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mdEiVUvS; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-421757d217aso43380215e9.3;
        Tue, 11 Jun 2024 18:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718155074; x=1718759874; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pCv6ajRKhcY8qVxlzaOwPMPORHc/9Fq5KLDBItmkFu8=;
        b=mdEiVUvS9zLM0TWYQuchsidJ2hr3bmPZfB0fBdvdAS8SoT+aFVQ60uBmz3nHZCe4dj
         J+muGpKpTD2MXW1uwxKKNB6XOgzXa8/Ntcl7YwVgV1bZnUk2A9QOmilD/TUGWvJl60HB
         f1LLggwQ5m8DQVYck24qWKlI8/78Pzv3ZweNnMKzvAtS9zHwKC+0sN2dYIlniC4YKcGS
         Y/xxElwmSC9/V3dhHoa31b/z56JBQ6ngdqduQF/TOpXs42hT1UtxDKZ2uQXWs6qGXu+6
         r6cx3ZfQA8T2NUTvWgiOLHNPF8YObUSS1xQfltGNWW5faCxflAMpLEQuc2fuMZd7qU9g
         Dulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718155074; x=1718759874;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pCv6ajRKhcY8qVxlzaOwPMPORHc/9Fq5KLDBItmkFu8=;
        b=Syd3XudG5OMU3HbT21lOmxXkG9M4A3vFBQYE7UpN/5BsUkFzSD3ON1edJI7n8vZtGx
         ko/6GTdsXiQpsfEmdegKQ/OkAQkZz0RMYCrNlLDYLSafX5L6MmBt0nIH1kKq2INaqGlC
         jUJJ4RNuVUFFQDDyn0JBSyssfsi4TqK8R4IP71eTse2q5feCT+tmiMOmjN0VH9L0iLQ7
         ETTWxZYzLzCkUTpFtOkrK8zjeFt2AX7XItqHMSCbHOoDVBEPk3c19JAMr6OykLMy/gIt
         YhoLTbb8+BrbDDAxbyY8hVnEsRzhSu1C8i4acNVEUcVCN8O9hWxvpRN2xcaNaw4Voj/C
         v/ug==
X-Forwarded-Encrypted: i=1; AJvYcCX7N7LSYFwKCr58q4OiUpohS0SBPsQgfw9FOxMwREdMxCwFKc2tLNWrypzUQkdSg3lNv83Vb4pP1/3hIR5d1HBT4CgccrZrnhVTMbNED2W1X/YS9rn/eQQ8HJAMHLkZx+TqdNTKXJw=
X-Gm-Message-State: AOJu0YzYy8aCPv6Pk4xyfsKGFOoA8BeR3clv5E3MI3pcYCwpCMkE8O6z
	tE5JyDe0Clw0iSlHEjBWQawaRddcV9ED6Gxi7HKc4YpKzLzh+N27
X-Google-Smtp-Source: AGHT+IHG1eIIlq1XhVH8enTwZXdY/KeybOcu3BmNE99YBuSztl54+G1oyVFyIohnm6dp2p1QTetpjQ==
X-Received: by 2002:a05:600c:500e:b0:421:7f07:92cf with SMTP id 5b1f17b1804b1-422867c00c0mr6268585e9.36.1718155073925;
        Tue, 11 Jun 2024 18:17:53 -0700 (PDT)
Received: from [192.168.42.217] ([85.255.235.105])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42286fe9263sm5588205e9.15.2024.06.11.18.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jun 2024 18:17:53 -0700 (PDT)
Message-ID: <9baaad14-0639-4780-809a-0548e842556f@gmail.com>
Date: Wed, 12 Jun 2024 02:18:00 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [io-uring] WARNING in __put_task_struct
To: chase xd <sl1589472800@gmail.com>, axboe@kernel.dk,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CADZouDTYSbyxzo3cXq08Kk4i0-rLOwuCMRTFTett_vTTmLauQA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADZouDTYSbyxzo3cXq08Kk4i0-rLOwuCMRTFTett_vTTmLauQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/24 18:15, chase xd wrote:
> Dear Linux kernel maintainers,
> 
> Syzkaller reports this previously unknown bug on Linux
> 6.8.0-rc3-00043-ga69d20885494-dirty #4. Seems like the bug was
> silently or unintendedly fixed in the latest version.

I can't reproduce it neither with upstream nor a69d20885494,
it's likely some funkiness of that branch, and sounds like
you already tested newer kernels with no success. You can
also try it with a stable kernel to see if you can hit it.

-- 
Pavel Begunkov

