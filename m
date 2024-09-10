Return-Path: <io-uring+bounces-3123-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E4DA973CF2
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 18:06:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B176C1C24117
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 16:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6531419F480;
	Tue, 10 Sep 2024 16:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3GvOCpBv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DD8199FCC
	for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 16:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725984381; cv=none; b=JJKiY4H78rf7VQ3Cu0obHm4VcGXW7G93t7b0YWVd1XZGfPJz7jrXbKdQA6PyFAL7OI++Xh+fQHbeh1sYYYLSzBZbTlyE+I6TSsRQb7YSw2gn8C2piWtCn/6cZE7xtqoS2o3EMWkv7UdRH4iyyD+7WgfOAdnGBELfViZrpkzi3fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725984381; c=relaxed/simple;
	bh=nWxhKnjkJZTFdW4bOUswy11ck0je6HBAn64rjghcv9k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E7aRXLCu0xgR6eo+dDRlxo5PR/87u+BH/IpYTRf0hNqRsgGm+xVb5isbF0Epl+lrzvIDcpmHhL2g4MCbNtPx/CaNiTjLm+ZcuQuQn1OvK3BTkvMplpLOwKuwf0TBSW/7ZNUrJ6KdVU0Ve+BVXEMr6IujzehVAn2QPXuvONJYqkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3GvOCpBv; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-39fd6a9acb6so20655785ab.0
        for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 09:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725984379; x=1726589179; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bvqx2vUM4wd2hXHXQjB5hyTmP0TgEc86Le9MQ8ED+GE=;
        b=3GvOCpBvNSixz2oivkKV8UQUxbeQLklaq5Xokw7Nkjw2uiXYNYWsRf8iTpitzZginM
         GJ8YiknMOTessUI6LP+P+RuvptXj3/lz/uDso08U0OKByk4QGFs5J8sW99ODVAgLxxnQ
         hMidSTQ2QcEv/B0KUKJgD6WM+WUpdcR6JeqSdvBDIPL9hcdjCDAmDZHybj6rm6rEE7bw
         AIZO8dCbks6AsW5UYR4NgxTB8OtW0lCuTuLf9M+q0p1seR4287bGxna3xqP6lXv/hZAg
         9q7dP34jdPaIceKZTM5SVx3IhxJf+KXXOpRiXkSQIRkiciYWfgc3RRtXKcTukDBoF2kx
         Tc5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725984379; x=1726589179;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bvqx2vUM4wd2hXHXQjB5hyTmP0TgEc86Le9MQ8ED+GE=;
        b=wA7XjD75GzXUrT1JGdJm/4B8E7SDKdVi2Z+ds6LMBaFN7bz87c52CAKaG8oT5qFiWU
         tJNQ6d1Mw8AlrTasZkZaAaX1sr1QiFymoDsJlXFu/eH+ZyWdV59LU5FcMaZn9lIuOteI
         ZfoBYalkrz5a3JDy3RPLJOzm73YO0lwm/MuZc3JUSCuWHjDjX+Gf6N37aUQDTRIn9aen
         8sKXuQvciq9ewlaaEVGSwy860Rc39EKS+2F5BLptyZHNEMLqeoCWO6cSaMa/1mLFvhzu
         KbbXv6cP6DBDYHTFgjp7J2pHx16idmzN6ki/WXu2sSIdkAUjb31LkS4K/jz+/wlqGGcd
         /cIA==
X-Forwarded-Encrypted: i=1; AJvYcCU51FBdwS+daIolxCkABuOWOm1sjJPw3k4iAGSZ/N/DaZc0xzd5HdEa/rbhVmBQ2ZZgOcWtASnc7A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyRKeXVNc2dr66pm6dTPXg7fp1ku213dUYwBbVY0rmPe9QABTpm
	k+am9qVVlXT5BnPKMx/EB/yLDMStINUjh9YhLDU4gngr/AQv8LpVKLZan6N/iE8=
X-Google-Smtp-Source: AGHT+IHX75F0Eqmzt177RZxt2H/sYXCSIl0I7Lx9d0azKek8qgV+BEFrXeK1FHTUf13yUcErwKBz9g==
X-Received: by 2002:a05:6e02:148c:b0:397:75a:39b9 with SMTP id e9e14a558f8ab-3a04f0ce20fmr183706515ab.16.1725984378868;
        Tue, 10 Sep 2024 09:06:18 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a05900e618sm20608515ab.55.2024.09.10.09.06.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 09:06:18 -0700 (PDT)
Message-ID: <4c854271-3c5e-4549-81e6-dfa0a69bf9b6@kernel.dk>
Date: Tue, 10 Sep 2024 10:06:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring/io-wq: limit io poller cpuset to ambient
 one
To: Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, cgroups@vger.kernel.org, dqminh@cloudflare.com,
 longman@redhat.com, adriaan.schmidt@siemens.com, florian.bezdeka@siemens.com
References: <20240910154535.140587-1-felix.moessbauer@siemens.com>
 <20240910154535.140587-3-felix.moessbauer@siemens.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240910154535.140587-3-felix.moessbauer@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/10/24 9:45 AM, Felix Moessbauer wrote:
> The io worker threads are userland threads that just never exit to the
> userland. By that, they are also assigned to a cgroup (the group of the
> creating task).
> 
> When creating a new io worker, this worker should inherit the cpuset
> of the cgroup.

This still has that same ambient usage in the title which I just
cannot make sense of?

-- 
Jens Axboe


