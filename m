Return-Path: <io-uring+bounces-1594-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BA7B8AAD9D
	for <lists+io-uring@lfdr.de>; Fri, 19 Apr 2024 13:21:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 294E41F22337
	for <lists+io-uring@lfdr.de>; Fri, 19 Apr 2024 11:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3729A81745;
	Fri, 19 Apr 2024 11:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QF44GZ08"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F8D81729;
	Fri, 19 Apr 2024 11:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713525689; cv=none; b=JI7Zdu1tk8K8/U/IXida3p+I/qPSPt84SIP27XRjKzPzGuDljJk3ULsFWZCJ/66Ok2P+EmWycguoIaOdVbC/yVd9FFx81/xKv/W2ScnmM821OrvlYHYEqzh/c1FBQhqKtCEtsuccWQSQC3m9r6vle9DGCdliBdbi7CKrplnrb+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713525689; c=relaxed/simple;
	bh=k9VcYFgyShcG1dhWPBt43rKEUHdDgANKGFJsHKd2Uok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z44YBpNYGjvL5L7jJiulDnVwgs4LcDuViqU+ZT+VhRo4E0mrOO8q4oRGt2ug1+d3E7qmVvoofJW8q3l7AggHu84UDGtcmyTLWtbzd0ldvvfdJRvDLc+rbbkp4fuPM1TWjDEHfxTjgfD/IYUVMFNwEuibIgBWtn/BwCkH6qDQqtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QF44GZ08; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2dcbcfe117dso10060211fa.1;
        Fri, 19 Apr 2024 04:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713525685; x=1714130485; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Oo5xMgK7A43edaSEKnYiqm0AuchtwStkZ/R1A6SoZFQ=;
        b=QF44GZ080IeSjM3+L5QLBBp7vcfooPBXcnLP8S1vxpmUUbmIapclGi8BlAgbCnYnQx
         Jk1YRtLqXURXwRx9+4y0y6ZA2jt2L18cwjLlk+cPdBmEz8A+uVonOwnlmzJQf2Ctzl7I
         N5lUN5ZYYglqpO2AXQoJ6Q/+Syyp+Tbf5auMvSiK7M+l/IpD0QEOJiWlTNMQjSxKKZ29
         o5AkhzR0weDZhbnHc14ez3aQ3GsiaWDpUmzmAWaZlQS4MPLjGmaJAW+P0+DqNGsbRBe4
         2vOnyPl6DztVbexyK+fbtpP+fjnrBKEJLw7zQvB9MbLX6bTtBohow3WYvs2r/N+sc4je
         aDTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713525685; x=1714130485;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oo5xMgK7A43edaSEKnYiqm0AuchtwStkZ/R1A6SoZFQ=;
        b=cotbupD8oepV1HbcWY6hVo5FDRU8nSvRddAEEVU6/E9h/7HJ+pdJ72YxWCUMvzK73n
         C4GAoyy7wQIMyClspqfb2ULt5S+5TkHTUb9vUeA8o7fSlWNwBnNXUu60ged8A7tvJO9U
         vRUXskTDfeIQzpv4kfTmvPMqvSdMxH1zUubqzjutTEqav3CcSJq8dS/WULf52OOFXa/e
         Yjbh3HzgWobobonsfEXxlCsCNKVtig8zrSYDiVAZOLhSsjhhuSRbtThN1p/P4cin1hX+
         q9lzJwYzxHJ1b4E4dmwTk/wp+OCzIModF2pkPxXhiNVYm7FTC3m3jXlHjQxX4fLvMJTp
         UnfA==
X-Forwarded-Encrypted: i=1; AJvYcCXGk1VMzZhQ5l7zfGNOCWb57KV34clvZU2Ct8tp7XdC3U5iC/Qn0tGofumgCXOnXd5MPm8CzfcGR74TImzwGtyt91dth3smgT9zsqWwMJtadseT/+dfJRLyHu4Q
X-Gm-Message-State: AOJu0YyX1Cb0oVDdC+WUD/5k0Yipzd707KW5ymn40oRnxMKA4hahGmdI
	nm40t8gkbwrXA8KqyMU1WNsFRN1BnQ8OsZKfa+82tUxontFJjqThV6CNHA==
X-Google-Smtp-Source: AGHT+IEFY1gjmCiW7j8xVLYIyr8i8P2p4D1KfDmvOJjtfOhFv2qZUrBCLs8x/0cxV2+TI3RJGn8Yug==
X-Received: by 2002:a05:6512:ba0:b0:51a:b955:4014 with SMTP id b32-20020a0565120ba000b0051ab9554014mr1557073lfv.18.1713525685086;
        Fri, 19 Apr 2024 04:21:25 -0700 (PDT)
Received: from [192.168.42.27] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id hx11-20020a170906846b00b00a46d2e9fd73sm2076372ejc.222.2024.04.19.04.21.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Apr 2024 04:21:24 -0700 (PDT)
Message-ID: <0f6355d6-b563-458e-9671-ea7e047073e1@gmail.com>
Date: Fri, 19 Apr 2024 12:21:30 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring-next/net-next v2 0/4] implement io_uring
 notification (ubuf_info) stacking
To: io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
 Eric Dumazet <edumazet@google.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Jason Wang <jasowang@redhat.com>, Wei Liu <wei.liu@kernel.org>,
 Paul Durrant <paul@xen.org>, xen-devel@lists.xenproject.org,
 "Michael S . Tsirkin" <mst@redhat.com>, virtualization@lists.linux.dev,
 kvm@vger.kernel.org
References: <cover.1713369317.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1713369317.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/19/24 12:08, Pavel Begunkov wrote:
> Please, don't take directly, conflicts with io_uring.

When everyone is happy with the patches, Jens and Jakub will hopefully
help to merge them. E.g. first staging net/ specific changes [1] and then
handling all conflicts on the io_uring side.

[1] https://github.com/isilence/linux.git iou-sendzc/notif-stacking-v2-netonly


> To have per request buffer notifications each zerocopy io_uring send
> request allocates a new ubuf_info. However, as an skb can carry only
> one uarg, it may force the stack to create many small skbs hurting
> performance in many ways.
> 
> The patchset implements notification, i.e. an io_uring's ubuf_info
> extension, stacking. It attempts to link ubuf_info's into a list,
> allowing to have multiple of them per skb.
> 
> liburing/examples/send-zerocopy shows up 6 times performance improvement
> for TCP with 4KB bytes per send, and levels it with MSG_ZEROCOPY. Without
> the patchset it requires much larger sends to utilise all potential.
> 
> bytes  | before | after (Kqps)
> 1200   | 195    | 1023
> 4000   | 193    | 1386
> 8000   | 154    | 1058
> 
> The patches are on top of net-next + io_uring-next:
> 
> https://github.com/isilence/linux.git iou-sendzc/notif-stacking-v2
> 
> First two patches based on net-next:
> 
> https://github.com/isilence/linux.git iou-sendzc/notif-stacking-v2-netonly
> 
> v2: convert xen-netback to ubuf_info_ops (patch 1)
>      drop two separately merged io_uring patches
> 
> Pavel Begunkov (4):
>    net: extend ubuf_info callback to ops structure
>    net: add callback for setting a ubuf_info to skb
>    io_uring/notif: simplify io_notif_flush()
>    io_uring/notif: implement notification stacking
> 
>   drivers/net/tap.c                   |  2 +-
>   drivers/net/tun.c                   |  2 +-
>   drivers/net/xen-netback/common.h    |  5 +-
>   drivers/net/xen-netback/interface.c |  2 +-
>   drivers/net/xen-netback/netback.c   | 11 ++--
>   drivers/vhost/net.c                 |  8 ++-
>   include/linux/skbuff.h              | 21 +++++---
>   io_uring/notif.c                    | 83 +++++++++++++++++++++++++----
>   io_uring/notif.h                    | 12 ++---
>   net/core/skbuff.c                   | 36 ++++++++-----
>   10 files changed, 134 insertions(+), 48 deletions(-)
> 

-- 
Pavel Begunkov

