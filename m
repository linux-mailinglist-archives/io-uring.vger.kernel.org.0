Return-Path: <io-uring+bounces-1105-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B8B587EA46
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 14:40:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE55E1F22C2C
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 13:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F32F2482EA;
	Mon, 18 Mar 2024 13:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bfyJODfX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F8547F5F;
	Mon, 18 Mar 2024 13:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710769228; cv=none; b=h6p+eNSIs8cqd2lwVJQfxYQvwESShXMJVzmwf2rgKoN5uB4SBTnEAV/9Z+76JS8L1Bp0kjHROGCItd+irwYBSVGcEJ1ex/rm0jsQ6ejpRX9NSAf4S7D5a6ceGhXXbZu+JdZwOy4An6ARL+7E514SRm4AkoqwsM1XGOpvCuCt0OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710769228; c=relaxed/simple;
	bh=i362x5cTQ4Hm1L6kYB3NzX0TXmUT2V3EIeZ+kUQ17yQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jq/WspZVS69fiaypxfsJaN4OB/MCrB6IETjzjjb7bzisyWO93Gf7Z67tcWg2PNJya8rzyzTR78rVoxp2MepeaJAW9ZwBbkZb9rdVv44IPrQDwYnTEoR7ah0+jDibJNzLZp49VKBvQJclipErPQEpgUf1q82IcNe3U3IVL6oGD8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bfyJODfX; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5687feeb1feso3655131a12.2;
        Mon, 18 Mar 2024 06:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710769225; x=1711374025; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ouCBlKeB39kP5zLO0Dh3Jw2V/iZvzW7jVhr8PvCp8ag=;
        b=bfyJODfXWz60e91pRlo0gw14PIAQABNIeN+Mip0CPtarJ4Sn1MyMEKYRazgyQhon7r
         mEF8ugpBJUn/uDnBek5TCjfaf4qgIAc2XK3hmu0PXWFio8gc7LK25cw/S8xYR2fH4VZq
         EJUBn3fCjhruqK15m2E4R7kOV3HFKCIvuiY/LotECQlsZ2Mfyvc1PS3kk87t70Gjc3D7
         zNX4gZybf1zA2b/eA6hcHEDnLy9I4SBdaEmHH/vUByyfYMPb+HOCrLD/RcQV8++47Pt9
         M+W6pOXa1bk6O2uK0q5EGZ+2f8RAgN2/en8PIcuCTUyroZufvxbeJ8nVxG3bFddKQAfw
         H6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710769225; x=1711374025;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ouCBlKeB39kP5zLO0Dh3Jw2V/iZvzW7jVhr8PvCp8ag=;
        b=RlbhJMd0Q7UnmxPL5oxtvDOwk2ZfV2ND6lIEKRXL7OhffQcAsYLp/PYQ25e+hdHR97
         VrgzmrJX89u27PnJmZs8k5+IVhM6LEi55922kJ8Nh4I46rIhY5THMp/h5TydHKrUH/T7
         AF2JwC/xVtX27g4fz8QOCNsH0sgVEZFSBeOsCW483NVobhA8HR6C9hlshFcP6rcCCCJd
         hn7iWKo9UfFi1lcGa5vs3+QCa3cQcl8rwpLHAbAgJ/b49Y6aJmAbCl6uJt93cAk/qXjp
         PJ7+NfZRmFEqx+ObMPrdemPE1jUW3tpJDx+nFmhC9OXSmzV0XdKDjbFtU61FCLAYNtNA
         Xf7A==
X-Forwarded-Encrypted: i=1; AJvYcCV5K1Ry+qj8rOT9k9sMDVXIPuE2o5HcSYCtw7Z/qaUnjUg1uDbV5UxwU1AZKZiMG2v0XUofAwe3fwSJZQ12G2TRYtNMV5Qk298=
X-Gm-Message-State: AOJu0YwaosWcOvdh2CCWvYvClL7ph9kajLMZr52j8pdgyx8ppQkejdOP
	j2cFwkNk419oEodaRBpSXilQFjPg5p5ofMAnRCVmZRczAUrfFz9/
X-Google-Smtp-Source: AGHT+IEIc5hkwXpnjjPLRUhub4k8nyw8bOixZ3+/UNeK0b5DxfJ9tJ6uQtu5qHT5WDwmc0loI1ChDw==
X-Received: by 2002:a05:6402:5d0:b0:565:6e34:da30 with SMTP id n16-20020a05640205d000b005656e34da30mr7058132edx.21.1710769225348;
        Mon, 18 Mar 2024 06:40:25 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2181? ([2620:10d:c092:600::1:429a])
        by smtp.gmail.com with ESMTPSA id g38-20020a056402322600b0056b8cc4d6a7sm47915eda.43.2024.03.18.06.40.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Mar 2024 06:40:25 -0700 (PDT)
Message-ID: <97d8e2ed-c4e3-4473-99ef-8b5d8056640d@gmail.com>
Date: Mon, 18 Mar 2024 13:38:48 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/14] nvme/io_uring: don't hard code
 IO_URING_F_UNLOCKED
Content-Language: en-US
To: Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Ming Lei <ming.lei@redhat.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
 <CGME20240318004348epcas5p43e669407fc4400bbc403c670104ba796@epcas5p4.samsung.com>
 <e2939a17b63f9347ba3c1c193c4a9306c3ba0845.1710720150.git.asml.silence@gmail.com>
 <7a89d6f5-1c8f-2549-f435-61d334837934@samsung.com>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7a89d6f5-1c8f-2549-f435-61d334837934@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/24 13:26, Kanchan Joshi wrote:
> On 3/18/2024 6:11 AM, Pavel Begunkov wrote:
>> uring_cmd implementations should not try to guess issue_flags, use a
>> freshly added helper io_uring_cmd_complete() instead.
> 
> NVMe interactions look/work fine.
> 
> Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

Thanks, I'll add it

-- 
Pavel Begunkov

