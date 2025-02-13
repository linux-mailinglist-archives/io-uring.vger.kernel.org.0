Return-Path: <io-uring+bounces-6428-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 938C6A351FC
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 00:06:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 749C916218B
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 23:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97504275401;
	Thu, 13 Feb 2025 23:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N4Nh5RcI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B0C2753EE;
	Thu, 13 Feb 2025 23:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739487900; cv=none; b=fJjMjLaPQFsu58w0ueXiFvBWfiT4pMlMpTrF8TrVrak+rrJOtJTzTsRP5F6em0C78yWAPkJIBrnYTK7ENMHt8+Ryv3dv57N6IkxpMX8TLVBk0UkrbAROaDEyqdwUQNfVlwtQd3i3iQsHTpEsZ2YSILn/Ooz9ziTf4sCaXi/ybHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739487900; c=relaxed/simple;
	bh=4kp0FiqDnygaPBdS2DUeCMzUSXmvQSOITjc0/6XahIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZAYYcU5YcPg1vmN4eaWBM9LUZuGPG/TFpBk9bJilwdZypUibI/0XhqyhnZ6T9BawrOP8US0rQSQTsEcSB2nabUVHXaprsb6N/bIgQdUhYkPQ3KFZzYiPkVk5xKERcAkJrF44yMiroKW3YdkQ4tTEaxkOHBbJ1aMjRMnwIq3QBoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N4Nh5RcI; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-38a25d4b9d4so988794f8f.0;
        Thu, 13 Feb 2025 15:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739487897; x=1740092697; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hQyZOny7QrhPAG9ndWlmAKtQTyPnNKP+eYGPxCd8ZeI=;
        b=N4Nh5RcIfuOD32nP6LS+kPiPIchND1KvNoKLvaHF4lqohDUY7vylyevWmFD1DNHY5T
         0ArsJXZHoIaPQt6zyQk5oBzjrFjmlFACKxyHl2nVNJmVl2kJUnB6+i5sNZRCRKjQWXA0
         Pbt2F4KNh3tx1C6+3aKMZ9cCA/slnrezeO9mbNNqJEIkXWybzJ8elOBiNlaI756xwdNd
         /sInQT77oJkF3y0U9KZucdNRmDTFzINEBU9bBmqfRG5GDWiRrs1wyAc/YLkqd2obR8yV
         VaDDGfDoo6WIi0SOiPI8bcgw+ND87mrXdD4A0mPLJ53N88rz4UFVLDmCAKBf9tDvRjae
         jE4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739487897; x=1740092697;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hQyZOny7QrhPAG9ndWlmAKtQTyPnNKP+eYGPxCd8ZeI=;
        b=iTgEu9TOdGnmIvYXnucjqmM/cjtuP8Ec3MehT0hu11nGWQ+P6/hJNuOqWpx9706qpK
         TOqOhuylH5x2Z081khdV6RLZQrVpLtrFpcR8x1LJ+6h+lw+sSmbuxW+x8Iu5NB3pe75X
         haso27vR4o5PwfIFs7ZqYuHriVJCFpzI7oQL5qY69VVQ1Ox4lexqbnLK8re+74r/ImkS
         R1WRYUdOuv3r6hTihj+lQcuQ+tjxFbwT3avQ9fySj6L77dZo1L3UoTh/F7VtHd7BY56B
         mSA+MmDbXGB4bogJuc+DZgGQ2Cl5DbCq0aPauEGWPgjxda/tYjyYYCXiCPDAjvufUmFK
         hpng==
X-Forwarded-Encrypted: i=1; AJvYcCUpFC7EcgDeYgT+T5uM8cHx/P9fATywplYuU8weFf8sGyi4mEcjHH7Sp9xWPEoEKLaWhlT9rU1hrw==@vger.kernel.org, AJvYcCVYAO4N/N41NHjYh59w0FWIw0U0FctMDHUkFG91mMTcvUFA6i6jnhZnFJSBPM4doJBJ4dfhh2s7@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4z5YK72h0HIqykI4EhWUbl4ttWe18BfX3+ymHM+zbI15yrvfs
	cZ1ebAzKh4qTlLrg+hnOiy5yJL/pe1mzUfzec1JnvdgIeDu9xAzg
X-Gm-Gg: ASbGncuoTLlBxp7UrTEd+NzuHWmBVqc9F+lO01lfJ46yk0/MFh+UMGegP16vQ/gX7bs
	7fYSccjzaja+uOLz/yuOqXADN9aa75HwVCR/FxC4tfk22dvvyES5USNHH1dUPPiALfV6v54KJaR
	Q0qBIuiLq0AmmpPr3NezG087d/2eLsHY5vYyvoVWFZNguKvw8L00xIJ7K0E2MxV+uUiNXBzCiAN
	NnlBYzY/yoTsGP2GLcjuzgf+S/SpfpbBImLf1tU61Rd6f5KpE6dl2YSM+KR13VsLvnO3242J76a
	wKvsHeRvrXVArEOe9zPey2DlXQ==
X-Google-Smtp-Source: AGHT+IFgnRN58gxTl7HlUt/nC1Wu/5mBIxFPrKN3erplZ1PSLvM5SgQhy4f+S9mYm8HfwjNiawSqPA==
X-Received: by 2002:a5d:5182:0:b0:38d:e078:43a4 with SMTP id ffacd0b85a97d-38f244f9308mr5029876f8f.31.1739487896890;
        Thu, 13 Feb 2025 15:04:56 -0800 (PST)
Received: from [192.168.8.100] ([148.252.146.210])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f25a0fa2dsm2974866f8f.101.2025.02.13.15.04.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 15:04:55 -0800 (PST)
Message-ID: <fa186760-2a37-4b1b-98ec-68ec61fbbeb8@gmail.com>
Date: Thu, 13 Feb 2025 23:05:58 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v13 04/11] io_uring/zcrx: implement zerocopy
 receive pp memory provider
To: Mina Almasry <almasrymina@google.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250212185859.3509616-1-dw@davidwei.uk>
 <20250212185859.3509616-5-dw@davidwei.uk>
 <CAHS8izMOrPWx5X_i+xxjJ8XJyP0Kn-WEcgvK096-WEw1afQ75w@mail.gmail.com>
 <7565219f-cdbc-4ea4-9122-fe81b5363375@gmail.com>
 <CAHS8izMXU_QEbd11rY8Dpd+Rr=jvy4F5LSey4AstMPRShsCHxg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izMXU_QEbd11rY8Dpd+Rr=jvy4F5LSey4AstMPRShsCHxg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/13/25 22:46, Mina Almasry wrote:
> On Thu, Feb 13, 2025 at 2:36 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
...
>>>> +       if (pp->dma_map)
>>>> +               return -EOPNOTSUPP;
>>>
>>> This condition should be flipped actually. pp->dma_map should be true,
>>> otherwise the provider isn't supported.
>>
>> It's not implemented in this patch, which is why rejected.
>> You can think of it as an unconditional failure, even though
>> io_pp_zc_init is not reachable just yet.
>>
> 
> Ah, I see in the follow up patch you flip the condition, that's fine then.
> 
> I usually see defensive checks get rejected but I don't see that

Yeah, sounds like that's the rule in net/.

> blocking this series, so FWIW:
> 
> Reviewed-by: Mina Almasry <almasrymina@google.com>

Thanks for the review!

-- 
Pavel Begunkov


