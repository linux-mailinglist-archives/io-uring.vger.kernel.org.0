Return-Path: <io-uring+bounces-331-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 468D081A3BD
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 17:07:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA7BB1F218CE
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 16:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B09693A29A;
	Wed, 20 Dec 2023 16:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GJQnnvRF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C14B46439
	for <io-uring@vger.kernel.org>; Wed, 20 Dec 2023 16:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7b7117ca63eso61771639f.1
        for <io-uring@vger.kernel.org>; Wed, 20 Dec 2023 08:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703088388; x=1703693188; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VZ6OBeghSb+PMX3MCxqCEyg+gbKi+XvzXWAkModBVro=;
        b=GJQnnvRF6tfW0wUXRjntfbgozsdVj7mmm5S92EVbZgEcxXeKbDVkGpC1YWVe/Pwkl9
         kqXLafOUcmpNKSWF/VonxfFsufMAppMF3U6ZAWKLwdhIrj+e44TEPTVdrp+Yspw6yfxi
         H9iDZJUTjbE6x8PHykXkftZ5+MXLVi65BtusBs4aQvFxeGZ8M7wgl45z/gc0byiCgYCN
         EWGwNpMSUiz7lmGptO/eurFBlqecFGzAWJHozXxIXU0639oi53fmJxtMAyDr5vZco7Dg
         +HEFqjRAVTmot9SGFAVCjsplBVUoghmKrhYbgQxeYiv+5Mfp1E4lU/FcOfxtbQI0SkUc
         ziSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703088388; x=1703693188;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VZ6OBeghSb+PMX3MCxqCEyg+gbKi+XvzXWAkModBVro=;
        b=aF2KaYBqCMTWp6xbndv483pf6XIFhmB9zApFOVr3vuemubJwJqGIXrs613OIfjrTqG
         /jFU+8Hrz6ZbyoU+Pj5RMxz55C5/vRgnrhCBJrK7+3InS7lSu6iOaGc05JiGES0/bf63
         LIY6UEP6cHLAjTreGp4KFVPIxoNtKHzxPBGpduDpGT9OJ1iDy2BvTSvaIM2Affg1FJcM
         bkYSvLIUg8IMW9PrDSvFl0D9D63lY1Dt2Q2RE2HQHEW3TJ1grh7rEVhTfBN2CE2Pv7x7
         G3lCAgVDp5jHUn/DWgzJIz8gu7wtYtQ4ztJXzd+8mrT5fpl5ykeT+QINJVqC890SOpZE
         V1VA==
X-Gm-Message-State: AOJu0YzN5T5cJX1jNrUxXsAJ+h7F1Q3iaCZzhe+GUW23nIn+/Y4lYjA7
	SuQECqiuMNP37duoJo+WNDPJXA==
X-Google-Smtp-Source: AGHT+IG+QXQDe8FELkC+SxY/OEfKeHBY6Vv7IxIk2SPJPwttdSu5ZgVH5RwJHErLBv/bWIIE/Xsg+w==
X-Received: by 2002:a6b:ea0a:0:b0:7b4:520c:de0b with SMTP id m10-20020a6bea0a000000b007b4520cde0bmr33657528ioc.1.1703088388407;
        Wed, 20 Dec 2023 08:06:28 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ci13-20020a0566383d8d00b00466604d21d6sm6803961jab.124.2023.12.20.08.06.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Dec 2023 08:06:27 -0800 (PST)
Message-ID: <7fa21652-36fa-4f13-9f36-c1b5ec681bb9@kernel.dk>
Date: Wed, 20 Dec 2023 09:06:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 10/20] io_uring: setup ZC for an Rx queue when
 registering an ifq
Content-Language: en-US
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-11-dw@davidwei.uk>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231219210357.4029713-11-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/19/23 2:03 PM, David Wei wrote:
> From: David Wei <davidhwei@meta.com>
> 
> This patch sets up ZC for an Rx queue in a net device when an ifq is
> registered with io_uring. The Rx queue is specified in the registration
> struct.
> 
> For now since there is only one ifq, its destruction is implicit during
> io_uring cleanup.
> 
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  io_uring/zc_rx.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
> index 7e3e6f6d446b..259e08a34ab2 100644
> --- a/io_uring/zc_rx.c
> +++ b/io_uring/zc_rx.c
> @@ -4,6 +4,7 @@
>  #include <linux/errno.h>
>  #include <linux/mm.h>
>  #include <linux/io_uring.h>
> +#include <linux/netdevice.h>
>  
>  #include <uapi/linux/io_uring.h>
>  
> @@ -11,6 +12,34 @@
>  #include "kbuf.h"
>  #include "zc_rx.h"
>  
> +typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);

Let's get rid of this, since it isn't even typedef'ed on the networking
side. Doesn't really buy us anything, and it's only used once anyway.

-- 
Jens Axboe


