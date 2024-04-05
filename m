Return-Path: <io-uring+bounces-1407-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8E52899C59
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 14:06:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 266D31C21FA9
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 12:06:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A39CA16C6BC;
	Fri,  5 Apr 2024 12:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bhVdlC95"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05E116ABCE;
	Fri,  5 Apr 2024 12:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712318803; cv=none; b=bIMaLVcdaE2Y2LjjdIerbSvotQFJGHncmb6x9bKxmjEDhq2Z3a4R9+aDzGg1jd6nMcvOD/dT1muAku0OCPzre5SRuChtR8yCYWnv7WpWf3MRWyNVqHxqUG56IJF/eedLApuWWDMAqVIzM2ZTaZiQIEc1yIP3Ey+edRf+FbTxKnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712318803; c=relaxed/simple;
	bh=QRvOuAu53+EArfY0qfpIBAa+WtOG64cUCx3bEohfA+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fKMPrf4euZqCqaW24k115a8OiCdg7KPidv8c5t7xeJNrUdOst0PFUZPgL4Er1CNh1QdOUCYBVpIkgDVXCYSnIik7zV+Naj46aZhj2yvrRIj1hs1UNLLrQhwJJeUfLvK3Xw4OaGEPmDQbev0TvYHVYenHnUB+nzworKfauRNpvjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bhVdlC95; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a519e04b142so119057366b.3;
        Fri, 05 Apr 2024 05:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712318800; x=1712923600; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=951nXGkKjtOMWvE593+3+1defoukyWk76h9tCSdYH3U=;
        b=bhVdlC95N0N8ZKDVL/D4DHZbzh+2X2/L6m58E3yntxQ/mtWR7z8hY+LePEYtyrvHk1
         kFnJbamnmlTM8s0sg7hWBCaqnJPlGlgmqO/TLWS8bmVU0+IBc0iE1dS/XwIAFcVo1obx
         rP4kPBN71q4hw1d7gMZZqQTSxD4ujJN4WLzgrgKvJ3wgCBb1IzjjwicvobBOXdNyiqrB
         HwAj318mZz5qCULex9qugeP3svbvyHiJ6SNiIHn+qm/jhSrUFesJx7ChGYfZ50zNvMUk
         L2QnVC/RmNweBfPL625r/YBwGLvDk4nVNiKPwhkJhZzRGOPKAzdX7sg66DqtUtomKgGh
         TGxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712318800; x=1712923600;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=951nXGkKjtOMWvE593+3+1defoukyWk76h9tCSdYH3U=;
        b=iTLxph84CcuRk5t6vw1WTjzq516Jv6ax2FW6HCE7AyLZH8ujZgcYRMoXh/6+PpIg/N
         AIzLpeVjMikIQQ3CAA11oW5fP2+n6t1uwMzFxAnHMI3RcVh7ufXehSuSWVPtGZVh3ryZ
         iRl+YlLT1TqKXbIv0P+2nHyOyR/syjKMjh2aMgQv2/1JmUVTFYiU5j55P0Q6aCN4z81U
         IGKgcJaPTpjxd1kDMn3CtwzaYsANDw4UHPZxhooG9SFHTQ+ZjPrekvj5s7bO1HBTvU/j
         AiQq1w9KopjkOfYGrWuqP4yEw5k12lQfwkD8Qdv9UkhlEgF1nMma+tnQJ1Klz8d2ihYW
         5gDg==
X-Forwarded-Encrypted: i=1; AJvYcCUAmMQF/SXrHLcos/jwlxfchZo9lX6tc5F8knNpdfKOHljDHEYhlPAajUTF6CbH0hmrC8+paURsAl4cVZAKo+IHSCD7r/NMxPU8ux4gI+VkQFwZMxMcpmlDb7uU8u1IyXADL5f2WULKLdsMfA/H3BEi9NnhDNd2gejKI5w2hSlqrDd1zvzj
X-Gm-Message-State: AOJu0YzpPcx5EfTaUS5JhT5ZprUQDohOVlStAWQzbUDk0HW8xaSbP6dd
	h+QkvSSpoz+nP6ZtLx2Gp/veX4mVepa4+pAID7L276Pc2fP+ILlv
X-Google-Smtp-Source: AGHT+IFM21RPOG0tBkcKSWY7GAr7G2myaGTXDGJk7JBt2SQYunxK5QAwm2BlpDVWn1tZtx9+NzyVsw==
X-Received: by 2002:a17:906:29d5:b0:a4e:57c5:e736 with SMTP id y21-20020a17090629d500b00a4e57c5e736mr999133eje.25.1712318800025;
        Fri, 05 Apr 2024 05:06:40 -0700 (PDT)
Received: from [192.168.42.78] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id lc24-20020a170906f91800b00a4e2d7dd2d8sm753430ejb.182.2024.04.05.05.06.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 05:06:39 -0700 (PDT)
Message-ID: <e3c0da47-8748-42ba-bd0e-872a5e66090f@gmail.com>
Date: Fri, 5 Apr 2024 13:06:40 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Add REQ_F_CQE_SKIP support to io_uring zerocopy
To: Oliver Crumrine <ozlinuxc@gmail.com>, axboe@kernel.dk,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, shuah@kernel.org, leitao@debian.org
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1712268605.git.ozlinuxc@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1712268605.git.ozlinuxc@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/4/24 23:16, Oliver Crumrine wrote:
> This patchset allows for io_uring zerocopy to support REQ_F_CQE_SKIP,
> skipping the normal completion notification, but not the zerocopy buffer
> release notification.

It's an io_uring internal change not altering how it operates
with the net layer, you don't need to CC the net list.

> This patchset also includes a test to test these changes, and a patch to
> mini_liburing to enable io_uring_peek_cqe, which is needed for the test.

For the same reason tests should be in liburing, where all io_uring tests
are, and the selftest can be dropped. See liburing/test/send-zerocopy.c


> Oliver Crumrine (3):
>    io_uring: Add REQ_F_CQE_SKIP support for io_uring zerocopy
>    io_uring: Add io_uring_peek_cqe to mini_liburing
>    io_uring: Support IOSQE_CQE_SKIP_SUCCESS in io_uring zerocopy test
> 
>   io_uring/net.c                                |  6 +--
>   tools/include/io_uring/mini_liburing.h        | 18 +++++++++
>   .../selftests/net/io_uring_zerocopy_tx.c      | 37 +++++++++++++++++--
>   .../selftests/net/io_uring_zerocopy_tx.sh     |  7 +++-
>   4 files changed, 59 insertions(+), 10 deletions(-)
> 

-- 
Pavel Begunkov

