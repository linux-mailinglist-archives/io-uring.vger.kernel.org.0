Return-Path: <io-uring+bounces-3543-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D8089978F8
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 01:16:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 31C451F235F8
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 23:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A031418E02B;
	Wed,  9 Oct 2024 23:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iGl7Onth"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009B8149C4F;
	Wed,  9 Oct 2024 23:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728515764; cv=none; b=OU0IP777DFVO6n12y4v8+y/V+c4g+KR5xDio+G6FVZIQVEccft1Dp8h5l3aHjwExfp6ZGNJshX6kgVU/qXDEg/1hGS/dQHxWvasKw6z2K+++GY7Tobxzyp5MQHy243VKeiYl8BTFZwdplPv6IqIQmFnNkkd/Bo+dEGIHAO36xqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728515764; c=relaxed/simple;
	bh=vTqGZCEk/zBnFttORfT4upYwuKwwziq6Bi6LEe9RMPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VNa9dbpmOGwUSTlZTSRf1VYsdRzAu1U9vw5HEhfiReiWdNFm6BMN6Qrm4Mn5DWp6L9P8qMqOQquqT/ny0BY4/q/k9XjlMpWD9BokQA+5a/JQOumfeniv0m9oTzlFVwMRpMbiqg0lYoKxyKhzyXdFoY11/u7iP8dWFCMmlcVkY84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iGl7Onth; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43056d99a5aso8940675e9.0;
        Wed, 09 Oct 2024 16:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728515761; x=1729120561; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=httgxAgVR5a8WQxl6ZZFyi5BU8XXltONSneJVMDwTRw=;
        b=iGl7Onthz1Rf2nHaflejDIJgccZxhUtLKjoMmMHrNurvYMYDnAQkojRPX87a5LZfo6
         yJ2c9cvPksOQblK3bgNJXogQIUuvfzs1q5XPaO1HucHsTDoZPBOVFdcg5mZ0uRCPwpI7
         lLHN85DJ8Pi4gyxLUAi6R/vpazVq9RLi1JZoEPa6snB13DaBqwWXo+WOUMESazRQRN44
         WS+5yomlXxEr4I4ECm2TdVb9rJVsjNpuJHyBtFCLE7cMy7aieTkxrU6GgRI+frZ84NWC
         eJ0ST9t2BwfXA+FxnlbhAwkqrMHs2Gp4/VAk9YKi/kuaxfvxa0FrhG6Jzokw8sR2W1n2
         6FWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728515761; x=1729120561;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=httgxAgVR5a8WQxl6ZZFyi5BU8XXltONSneJVMDwTRw=;
        b=mSZxin+OUoJDpk3UTdodwhuE0dbSqv1UwYpOQyZgxoG4TUjK5PZVuED+EPfN7NKp1+
         hWU6pnHhKDHiwvPi8+x1sWgUVqviy4e7m8dPniD34L/vP51HPfEcAa0ST9UDXESzvQlX
         EtWpPRniuSno2i23589XO84KRU7pmH3gu4DshwKrgiLvLTz94J31YtmLdO0TJQJDC89X
         5FSj2Bq6jlv+QXTC9q/yxISHEQlnHyuzN2hxxhtu7RMrd1g46t70NaovmdiA83eiXlLK
         lWTr5jqPk64Yd4v/GBwDcSXlgDZ6DRvqW9JjL3HukNwfsP01Y4+8xvUms9FdDMvfTtsO
         dgQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYehoX5y87334gf6DPV9XsXItlZS0SeqrNc3Vl+aXjv2QCOAFSSHxH1XL6ld1LgITM66WD4gQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlDVWRnFNfEb+oprxkkgc0SzRqE7vSVGmbhiThaxiCKFv7gOSr
	ncIFbcXJEUME10gttlWlIYbI+q1tWvxhHuWoSIbpygkMlQob31TV
X-Google-Smtp-Source: AGHT+IE6GvfmxDSCj3qW/WZsSVLBtqw4g4R372xGsqAo0mPvbnOVjbuscCtQj/xUV14myhmw+xcITw==
X-Received: by 2002:a05:600c:4fc8:b0:430:56de:d0ae with SMTP id 5b1f17b1804b1-43115acf9f3mr8529315e9.15.1728515760822;
        Wed, 09 Oct 2024 16:16:00 -0700 (PDT)
Received: from [192.168.42.9] ([148.252.140.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-430c7e653absm33031125e9.0.2024.10.09.16.15.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 16:16:00 -0700 (PDT)
Message-ID: <ed21bca5-5087-4eff-814c-39180078a700@gmail.com>
Date: Thu, 10 Oct 2024 00:16:34 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 01/15] net: devmem: pull struct definitions out of
 ifdef
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-2-dw@davidwei.uk>
 <CAHS8izMHmG8-Go6k63UaCtwvEcp=D73Ja0XfrTjNp_b5TUmUFA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izMHmG8-Go6k63UaCtwvEcp=D73Ja0XfrTjNp_b5TUmUFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/9/24 21:17, Mina Almasry wrote:
> On Mon, Oct 7, 2024 at 3:16 PM David Wei <dw@davidwei.uk> wrote:
>>
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Don't hide structure definitions under conditional compilation, it only
>> makes messier and harder to maintain. Move struct
>> dmabuf_genpool_chunk_owner definition out of CONFIG_NET_DEVMEM ifdef
>> together with a bunch of trivial inlined helpers using the structure.
>>
> 
> To be honest I think the way it is is better? Having the struct
> defined but always not set (because the code to set it is always
> compiled out) seem worse to me.
> 
> Is there a strong reason to have this? Otherwise maybe drop this?
I can drop it if there are strong opinions on that, but I'm
allergic to ifdef hell and just trying to help to avoid it becoming
so. I even believe it's considered a bad pattern (is it?).

As for a more technical description "why", it reduces the line count
and you don't need to duplicate functions. It's always annoying
making sure the prototypes stay same, but this way it's always
compiled and syntactically checked. And when refactoring anything
like the next patch does, you only need to change one function
but not both. Do you find that convincing?

-- 
Pavel Begunkov

