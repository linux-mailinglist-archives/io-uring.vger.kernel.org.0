Return-Path: <io-uring+bounces-7421-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E60AEA7D0CC
	for <lists+io-uring@lfdr.de>; Sun,  6 Apr 2025 23:53:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8773E3ADAD3
	for <lists+io-uring@lfdr.de>; Sun,  6 Apr 2025 21:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC50D19047A;
	Sun,  6 Apr 2025 21:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q+NzoOmX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4BC8C1F
	for <io-uring@vger.kernel.org>; Sun,  6 Apr 2025 21:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743976412; cv=none; b=HNMxZFYBhZkq3Gg6BXwP4UphJq0DrVUUguRxROzi5hTx9Uk9OoMFrZDh+YytKVFo+Y7xN5mil+upvujF0+kZoxRKmDWG2iz1PFG5uqVNAl/LQwxkqhTRLM9lFhFkSqq4ZgzHABji4kvsmrkBQ9oARzc1oMWR4QtCCk0EyZuR0qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743976412; c=relaxed/simple;
	bh=0F3HMEhboW4phadPSNQlhuo0PTKuI8ktGIYTCuAE3tU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XcY6m8OZ4PEcvvchyDONCzseNOBD4hBJZGQWIj10K9eUXzDC6K6LhoiScwjxyvgYpy5l2mNrK3BWzZf+aW86uGIEHmOuDhb+aWECoGerCDEsOaNK7bVaKWYU17Hs59Hs5x0aYqGWXklaxNBqAhAMYAid94ShnD9tHNPqh0LDgUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q+NzoOmX; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aaee2c5ee6eso504171866b.1
        for <io-uring@vger.kernel.org>; Sun, 06 Apr 2025 14:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743976409; x=1744581209; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=34pWYhYYDUqq6oYxaWbkKJ/uIfmIP5EhONY3szOjnug=;
        b=Q+NzoOmXTTW88GgVL8IHNeCIwrjoN+PLzoJ/hAxKb62O+PR7msxWsfqeSVdN9Jo3Zf
         S5Uxhx/GAS2aYXPAkAG1uVIUqw4ZpRiKqf8TTpQ6fRHL/rl7/bD2rE9JhyjcO3umCUN4
         u2J5jlU30aqacXl07lJFluAk0zdyMfHXpDmgqTbNJxIxqlSa3PKSbIU3ypJIIuFs5gcg
         1nsubua2e4pnzUhyHebCOGPZzFIPxuCA1Z10hKaPQ+iPvago8/r4dYZYXF/o5LWvKsvr
         VdhisF4WsPGGueg3AJdxvrs3A/OwurttPvh+jmyVIoYt/CKD2Scf2Ucbw89rbovt8X5y
         wkcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743976409; x=1744581209;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=34pWYhYYDUqq6oYxaWbkKJ/uIfmIP5EhONY3szOjnug=;
        b=KANr8srmALBRotX6Ebo+cEvZ10wy3mqWvSXimGbvXA/rLfSslF2raJex7dUYxnFfW7
         kbUEV6ZnXAMEc+jY1QrxHHZixR2qLfEWMy+tBI8144H8PAPIpC6veQC1rZFymQGShEta
         DMxSQvbkfsTaERLrWZ3ErflgZ6DsgNo2dZJ2iFckqosedw3BL8TwQqQvNZUUUdmVEnNL
         vL+lVhjIbjMNPSQpKlDxSecuKHrg3ZV6vQuNbMoCQFVTVxCYS/4cNjNfyVuO6z38ajjk
         cCYrhOOE9MX6p6xjRbe5jBX2KKCar96LozbJYqwsgIbHw0acovhmRY02/eBJrrFHeHHO
         Vxmg==
X-Forwarded-Encrypted: i=1; AJvYcCWNZzu/mjuy5lczf3p/+hOyTS/rEdFm4HD+UW2TLXYZKGFXHEsxdeDNAM/Vv9FqSB76kgIy04VdCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0qobirgUG2wdVfD5XR6ky4NwpxOE3cddWFfBH5UKH3u2bAgYc
	1hQ6fyP3dBvVl9fdOAu+53fRK8n97brK/hJO3ik/IxGxMkB+XcopMs29pw==
X-Gm-Gg: ASbGncvxIuW+jUTNjpNPQq6xutzhhsghWgQ6t/aOSBfhfYU5uUacDfrG0ENVqwEVOYP
	UhhSERicO+SCLRw34pJvatLU89xC16ywHESANb3wQFS84WeWNJUOH0Ncm35miBrUxfzDEteDrCB
	qKGJqhu50uUSK8QvyQmo4r5gdNFfLYL/83UsHTD4KFGoxE0LtnTc2a37vi8em0jMY1ZnM7Tj7BN
	si8WBhDA0EDi6b9DmvyRuVqNo3msk82qKOE02flBopMVW7SHY6MNpapEcFZ7b2KZnAQEA3e21IJ
	iKiZCGvVUvxHgfJCMQMcxTbWO/Nx/FNocVMpHyAuzUZV9IlBKujwew==
X-Google-Smtp-Source: AGHT+IED97r956s1ZWqHWk6WmFCC7S26nUygkx3PKEdE0eVriKgOw+x73RhKTaHFCyvQQlIw2MR9pw==
X-Received: by 2002:a17:907:2d8b:b0:ac7:322c:fd0c with SMTP id a640c23a62f3a-ac7d6ebb801mr923821766b.40.1743976408573;
        Sun, 06 Apr 2025 14:53:28 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.147.68])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfea2a67sm633112166b.73.2025.04.06.14.53.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Apr 2025 14:53:27 -0700 (PDT)
Message-ID: <d48a2c85-1ee3-45c0-8798-16116097584b@gmail.com>
Date: Sun, 6 Apr 2025 22:54:44 +0100
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
 <37b5fd439fc2af5b3d8ffb0bd0c8277d@yourcmc.ru>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <37b5fd439fc2af5b3d8ffb0bd0c8277d@yourcmc.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/5/25 22:46, vitalif@yourcmc.ru wrote:
...
>> Perf profiles would also be useful to have if you can grab and post
>> them.
> 
> I.e. flamegraphs?

Doesn't matter, flamegraphs, perf report, raw perf script should also
be fine, but if you do a visualisation, I'd appreciate if it's
interactive, i.e. svg rather than png, as the later loses details.

-- 
Pavel Begunkov


