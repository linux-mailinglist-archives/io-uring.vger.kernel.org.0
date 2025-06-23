Return-Path: <io-uring+bounces-8451-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21117AE47CE
	for <lists+io-uring@lfdr.de>; Mon, 23 Jun 2025 17:04:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8451E160E0C
	for <lists+io-uring@lfdr.de>; Mon, 23 Jun 2025 15:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8668726FA76;
	Mon, 23 Jun 2025 15:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wLlW136u"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1D326FA5A
	for <io-uring@vger.kernel.org>; Mon, 23 Jun 2025 15:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750690861; cv=none; b=LApxo6tHqK6qExNuZGuvBQtbX/t0J+amaOeNgoDy+xFytHYSE0rg6CP3H9/DiMwZRNlGUEINxUQjS5bq+rYamCS8fLu7Xu7CkeU9byYAx+up6Q8c3+cTsOzmy29UfHGntYC7C6maBX3nEFSv3VQ4X1NcyNvk+Q4IiE6KVZV89Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750690861; c=relaxed/simple;
	bh=DWG8vtTRJO+BwOywGgWtNmxhuxvbJmczNlvdJL8Ky58=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rbMzqIg/PIhfvwj6SaV1wLD1kojPASW20OLEcgO26uYJa1HQHHE0hIw7BbUZ5kufzfUvyTWATDsQZI/B2M5HhqObxKnExmKRT5mqnyp14yjGQbQrf9WAxnX3F0Yy8B8r/4m7ScaF2kz8VO9t75ekrggDDfUjCGhLZMQefJ0QBO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wLlW136u; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3122a63201bso3060479a91.0
        for <io-uring@vger.kernel.org>; Mon, 23 Jun 2025 08:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750690858; x=1751295658; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/Efb7h4IiluZ8rF9i5BpJjDumz0UB34EpNqVIk+T6z0=;
        b=wLlW136uAiMH7DxLLvH7WmLv1A5VP+RO7/RYN59n8y2CD5Vtlvz/e1IPQAHwHtMawZ
         Li+cnta3H1udrgJ6Bt2TLWMdSxOPwASQo+RcYHqni185Cw4j4jm3aEUMZi5oZd6E68iR
         H41iJx712BaVxL+qOE5MlMexH5sC+Zp/REquWEdMkjQvN4TgB08JD718jgLXFumeRXCi
         IZeyiEV2J2aLzVOLX8ZUnbddrjv4dR8zpXPrcNepSh4PlaRg22C7XH4PDVoSd2Vj+Hkg
         rw3+M1Ue2IGhJ89VeekClTjnE+o8zScdjouP5tCu2oAVcymsHWya2lw5sUeq5sj2w/32
         0iAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750690858; x=1751295658;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Efb7h4IiluZ8rF9i5BpJjDumz0UB34EpNqVIk+T6z0=;
        b=w+v/oIcFpzYJi/PUv2ZVTPwzqf9F0186WyPec8dCcOd2u+Ld7B2pr0+Cv3Fh2UqbAM
         7IksGxhm2D3NjZzgrvxWzrMH+0QgxGOKlHxiLNz1mHIGFEjjCwZIFr2VpvDOA7uf5+Z+
         hs+7cg2Ps2W3g7IOuVtJBaIGkwUL+epexIGxAGeN8YJYhf6AB56u49a0pSunbf80nagK
         Xxhqtj86wQZGs4jMuS38KFK8pOEuJT08rRGCutWv38CBXmNRc/pf+qAmj6dBxRLxmfD8
         N3bNUHLNCk6aKRUxzvyWeOzDNYxycrQlVG0ky/IFD708Xkm7byWTlJMu+/RdHJkWQe9e
         Z3sQ==
X-Forwarded-Encrypted: i=1; AJvYcCVslf1uaQD4oyVlZ/DZuPNXztm2z3xRKTPq4N8EoHjXXx5Y+f6f2sV8gQ+zc+QS3xcogVn9EjxDwg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+mx85SLcbGXdvXbBcPmxIAqrq/ajhH4B9/DMr8rcdJrD/3j+u
	zwhFiYH6BEckEJvm+aLX72L3Nil4eL3reONpfL2+QPnZjhCEHrXdCI8bAafTmSo81dc=
X-Gm-Gg: ASbGncuZAPhNDYhXHROtxk/F2zaof4dN18W4LGWTE5aujKzcUQvAKCOaBMmvt55rJYW
	Idq2fZ06sakTDFChzcIhncIvzv1R8ORu7u8/jjiJ9K+/ngaDo3gD/vc/TvmWh86/Hl6KvyO9BvP
	aqYC4BRGIR3ui3f4f8uznJVFrY1f7Gf6I2FENJZ/feMr3cYS0tzCVN4Dt5n6w5LwRNf6DPE0W39
	mTT3Nk0Nlc9v3QpsHY/I/TyRFXjYB85LgTSpu6vK3mX79S7Bp8vUTE4VVklocyJvdgo7BXmXQrz
	sK3olTydDbqqdZTKjgfpO6BIh1bvFxZnffKc48j4w+qBfx0garltNYrhDg==
X-Google-Smtp-Source: AGHT+IGUUjQjuUqX05UT3HAo2u5Qjh7WVT+efnt7MqKr01cpayVTTMTARQsofUWceMLkZlA6eMUkqA==
X-Received: by 2002:a17:90b:2ec3:b0:312:1c83:58e9 with SMTP id 98e67ed59e1d1-3159d62aba3mr18008699a91.5.1750690858254;
        Mon, 23 Jun 2025 08:00:58 -0700 (PDT)
Received: from [172.20.0.228] ([12.48.65.201])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-315ac2991a7sm6350927a91.25.2025.06.23.08.00.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 08:00:57 -0700 (PDT)
Message-ID: <1ccc3268-5977-40e4-8790-d0fe535a1329@kernel.dk>
Date: Mon, 23 Jun 2025 09:00:56 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/5] io_uring cmd for tx timestamps
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>, netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>,
 "David S . Miller" <davem@davemloft.net>,
 Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing <kerneljasonxing@gmail.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
 <efd53c47-4be9-4a91-aef1-7f0cb8bae750@kernel.dk>
 <20250617152923.01c274a1@kernel.org>
 <520fa72f-1105-42f6-a16f-050873be8742@kernel.dk>
 <20250617154103.519b5b9d@kernel.org>
 <1fb789b2-2251-42ed-b3c2-4a5f31bca020@kernel.dk>
 <20250620124643.6c2bdc14@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250620124643.6c2bdc14@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/20/25 1:46 PM, Jakub Kicinski wrote:
> On Fri, 20 Jun 2025 08:31:25 -0600 Jens Axboe wrote:
>> On 6/17/25 4:41 PM, Jakub Kicinski wrote:
>>> On Tue, 17 Jun 2025 16:33:20 -0600 Jens Axboe wrote:  
>>>> Can we put it in a separate branch and merge it into both? Otherwise
>>>> my branch will get a bunch of unrelated commits, and pulling an
>>>> unnamed sha is pretty iffy.  
>>>
>>> Like this?
>>>
>>>  https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git timestamp-for-jens  
>>
>> Branch seems to be gone?
> 
> Ah, I deleted when I was forwarding to Linus yesterday.
> I figured you already pulled, sorry about that.
> I've pushed it out again now.

I've pulled it now, thanks Jakub.

-- 
Jens Axboe


