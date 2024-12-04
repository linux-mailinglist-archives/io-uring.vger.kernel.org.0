Return-Path: <io-uring+bounces-5206-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 279689E3FAB
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:30:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6C9828225F
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 16:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B0E13AD39;
	Wed,  4 Dec 2024 16:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3ChaW2Nl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4318C1F16B
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 16:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733329813; cv=none; b=rUe5C71GRGnPNEbwH25bVdINvyTwS+rQhPEzsZ8hGkRWhJ44wXv3soMx2Gmt3tTT9DZHwt8eqrKH5qvQx7fWogwjXuj5EY6HXCEUDV5uUOLj73xp+CHMm02DHyZ3RpROwtcF5gd/0qtfN6pMADyJytSKFIpghw7IZo3Q+7lcLC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733329813; c=relaxed/simple;
	bh=urV50fFEUHAz7GM7OFQy5uUFQN9WNAvDHF0Hycp7gek=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RcaaObxDQKs2cbUWYyIXamGLFFgp2gMXxw7757fujnaFwvjvfvF2hLz8//Zb13LXnZbtTAiJaK3xszlWRbmT26oGix+R4UvayJm3w133rTuPl0MVdN7ZjyTxFPTBVytUKdSgXrhcAZGd0GllFsA/kntGzu3i51EJDI8sAMaJ5k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3ChaW2Nl; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2eed82ca5b4so7534a91.2
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 08:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733329811; x=1733934611; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o2GY+PBovLSxAEtnaJXWzOG8+IlUvACJXHa/cfec7e4=;
        b=3ChaW2Nl9CBWAworIVpwAO/fK3rqhdbKiMYra/4db3lLCfVrOW/sRsvGgQVOQd9bi4
         j4eNs2yW9gFib8so8glHrhucNebBxjCntLXAYnoXue0Nookcns3+7e84trNTineqbT2j
         SUU3nhWmXUMJtKHwdA2QNCDCVrYLMhcc7HCJjL7WTBUTrgpoOtGp6El6n1xCPZ/OIVPW
         xTfT+cd7M/8yRK0Au5PBFyI7S2NdOl5SR9D3ndM02S1MOk47CuLqNwbZ5iNP9H2uu3+x
         tIqCDWKckXwiCRG/3lG7ykwrfDZd7h7Vd9pZqIs3f9Qg4jxgqG+3r01RN20jP1H3lq8I
         BkQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733329811; x=1733934611;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o2GY+PBovLSxAEtnaJXWzOG8+IlUvACJXHa/cfec7e4=;
        b=fFElXbTBjOehLuhVJU3abviXQJh6+VNcJNlBWmrHuyBCLyTAZst3zK86Gqx6X+oMKj
         yb8xb6y9PCcfhoWDkLKOMfRtbfoG7/oru5w8yZozTfut+E+5m7Cozj0Y2fgPtI7ICD+R
         ltLcRSNyF9t5wJFNxdZxqqf7pK+K82Hd2eQdWmhd6VoogybC23AbvhsnuRxyuV9uWxK4
         054WxLvFwqITetx5OHytMIYaQhv0sNVp4HxE/xmhqJfDP/ID3RBgMMOxMoD2lmU4JnW8
         eT5gmKO10zTXbHM/xZYVrvhhQV1lm93mMIlk0ii5xzk2kiJbCevRjgO5s3+iAd7lreOD
         1ipQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0AFOp3qTKHsX7KG/TMyvLfSgYiCHGnUMJeU0F8SajTpFvJhc8dYpiXFFXZKDc6fGtjKulnGDfyQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxvz8rpJiDeqzl5BjP1bgwkQMf/oKujmR4WQ8IijSGAqpixpB2S
	WAEim6mHnOOvlLqUF8bneqDQJmmZpW3NfJeSl82guJyLsY1SzF9LQAKOQVz84co=
X-Gm-Gg: ASbGnctBZrlo4jgvFCd80aWgRBnp8Rt1e5guRbMKFVv0l/LZsI4aCdWvFLK0F6ypmte
	FX/1KtyNfc999KxZYlaDJ2dzLP0aZTJKwU6h0+jf+4QFW5K8Z+GCkNdi64LY/CNBMm+8nf1jPNA
	ACYsq9M0ymXCkkmPUwECG66q4XL2TR3UJc2VfPrw/rIElE2crXyQgRz7eMk09DzbXVSY54Mo3a1
	BxOTgv1T9rtbz782wJSN512aKh88QAqeFAELkLdz0MySSbPPOU7rU2tWQ==
X-Google-Smtp-Source: AGHT+IEfC5rJtR5hn5JJzshNrMRsGI4JAytGlAB4t9Cm7+Jzl3qzEVcKLAtbVHjx1MYWcxrU8TkD5g==
X-Received: by 2002:a17:90b:380c:b0:2ee:ab29:1482 with SMTP id 98e67ed59e1d1-2ef011ff673mr11676098a91.16.1733329811270;
        Wed, 04 Dec 2024 08:30:11 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:122::1:2343? ([2620:10d:c090:600::1:a7a9])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ef2700aa25sm1623877a91.16.2024.12.04.08.30.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 08:30:10 -0800 (PST)
Message-ID: <916e2d95-0715-4b63-a5b1-a4d586342368@kernel.dk>
Date: Wed, 4 Dec 2024 09:30:09 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KASAN: null-ptr-deref Write in
 sys_io_uring_register
To: syzbot <syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <67505f88.050a0220.17bd51.0069.GAE@google.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <67505f88.050a0220.17bd51.0069.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz set subsystems: mm

-- 
Jens Axboe

