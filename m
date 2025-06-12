Return-Path: <io-uring+bounces-8317-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF2AAD6BE8
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 11:14:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3025E7AA78A
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 09:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BF472248BE;
	Thu, 12 Jun 2025 09:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K6RIjzzG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3699224244;
	Thu, 12 Jun 2025 09:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749719671; cv=none; b=L9myPDWRW6PCg1ll1wehnxgVRlqEr9Q+pLwGR1lOZnmgCdjXky1jmGNiMU/f3Z09FeGZY29Xcfo2mo2AS7X3AyJ7/lRr1of6oTa/rpPsUcGApNDMwl9V5K65qbe/qt1aApTe54TJxSYrSfFzAfTVobaOQsksU1R+Woo6O4j0xhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749719671; c=relaxed/simple;
	bh=OWNjSkSJvE2sfoNgmC6p5w20Yx3MWT0X4bBvBXk1SsY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g4MnuD+j8Y0/lPPYUUyIwnFhNKYGnSGtQ+wMf879RnyuwyMmPGp3GX85+ZoZeL7BjHFlhQNNhPj1NFcqMoC4FDqE3gkmy/LXaZ7IDzVqyrf3sXFluPrNCdi1uWBE9XF4fGm2shExAFJzN9XwMT3nxPepNBcqdXgDCUnsqqtpmFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K6RIjzzG; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ad88d77314bso157411566b.1;
        Thu, 12 Jun 2025 02:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749719668; x=1750324468; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zeyxqUHZy6QVzGR9NXN+50F6/05thYdhp5HaVT4lX0Q=;
        b=K6RIjzzGe4arazGkEm7AgE2F5Gz1M98jpDTHCndasxMNE9jBdHuqV/Tt1Qlhv92T43
         mLBDwjHX2W/TMUXFSIzooT3zysUkahOO+X06QgrqcrFAPg4r4qI/Iu/AEJlMvbtK4+P3
         7wFvIcGNa/Sa5Hu1c6QMsLzgN48wEWcFVP+SxvuWU5eDTZlXZq48RAFG6ZqLGAnLw2vy
         sHjk5A2mDLe9DlmGdjTXfinfPrtCw+7iV6qDW5L1ZdCXdDwxV2qa/6I3JhIOIZqZQTEK
         TJXNdE7mModO5IGhyfEf6XB/XIrK38tTy7dWryebrZTQVt8ZuWXlq9y3rEJhGmy+QDbB
         JYnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749719668; x=1750324468;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zeyxqUHZy6QVzGR9NXN+50F6/05thYdhp5HaVT4lX0Q=;
        b=k1P1BJhVE8R5wDq/kWZIxTANg3aFnPqKO+LqVZhKhEOyBLRvtK3Im9r72WZE2cHcna
         DBg58SCASf2m/LAPrFX3mz9FPxqZUqskeaJudAEPZ3wC93a6AN3U/hoEh9310POkoM0X
         Qin1Altg5kFJ32MVX0kZWT7xmBssKvqNVg4AD1bvoNpKksmy56/XMac0iZSvkt6+eHQN
         PIuL163nvH8mRiIA54D9FBH3NaEd0A4vEOcRW+Rz8dW49+SaWXgSjd+JVrNbrtj7QCJa
         1Bel6I70Y6pliFYeyz7oyxi+VhSg/i0zWImKmWDD5z5MDsBC3vb/2EZaUgeoXGCPegbx
         hRsA==
X-Gm-Message-State: AOJu0YwdCISWWcH/mb+dTqPH9t8x5y3kjFqZSJWy4glgI8CtxGIBDvR0
	jdKp/L8nyQ180hMvjO45lcfQwMmZESNiqto3oLGuAga53IO8reR8vnJHePmdSw==
X-Gm-Gg: ASbGncuhDxoNZ/u6gcXsRHD/FtkkVlrStoCxHYCawgpS52C5zJzpgFyWBSJFdi5dHOE
	s26GRlCzlLp6SKrpsJszlz7kjuJSLoo3GyMYkZxSbe2nJRvuKP8MQKsgvHkOzs+NHXEAsNV6ISI
	7eGxcaLiWZim0bUgL07pYi+rZGfVc3HIn5vbQr3UuX1JLec1ZCytO4KcSpT0IwaGe9NlZLPs5PR
	iGAnBrrO9gtL9o18v5NgIZTLfXXViQ6jBcdUaX3M6/HQqoi2kAegVO/pVgiM6KahLA9i8pq+jBW
	4hBL8WYsE4IPl4XvBlQX1iwcsyDJdMnjXb8VXMQzVSBg/Q7uZbabyRs1K9dMwxKLtK0BeDnD0fU
	+35zOzfCWJX54pdvJQw==
X-Google-Smtp-Source: AGHT+IEPiTGs3HqkCUv9d7gXn+31hkMp9lyWYrUDt96zcBLtXubAKBTxS2ILkfmci1gnrQ0xBa9s0A==
X-Received: by 2002:a17:907:d8f:b0:ad8:a4a8:1034 with SMTP id a640c23a62f3a-ade893db0cbmr588478166b.8.1749719667403;
        Thu, 12 Jun 2025 02:14:27 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:be2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adeadecea68sm100750566b.146.2025.06.12.02.14.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 02:14:26 -0700 (PDT)
Message-ID: <3ff6b1e8-ea46-47db-aa52-65f252550396@gmail.com>
Date: Thu, 12 Jun 2025 10:15:50 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] io_uring cmd for tx timestamps
To: io-uring@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing <kerneljasonxing@gmail.com>
References: <cover.1749657325.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1749657325.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/25 10:09, Pavel Begunkov wrote:
> Vadim Fedorenko suggested to add an alternative API for receiving
> tx timestamps through io_uring. The series introduces io_uring socket
> cmd for fetching tx timestamps, which is a polled multishot request,
> i.e. internally polling the socket for POLLERR and posts timestamps
> when they're arrives. For the API description see Patch 5.
> 
> It reuses existing timestamp infra and takes them from the socket's
> error queue. For networking people the important parts are Patch 1,
> and io_uring_cmd_timestamp() from Patch 5 walking the error queue.
> 
> It should be reasonable to take it through the io_uring tree once
> we have consensus, but let me know if there are any concerns.
> 
> v3: Add a flag to distinguish sw vs hw timestamp. skb_get_tx_timestamp()
>      from Patch 1 now returns the indication of that, and in Patch 5
>      it's converted into a io_uring CQE bit flag.

FWIW, it's a relatively small change, but I dropped all review tags.

Also I pruned the test I've been using (derived from the tx-timestamp
selftest). Pushed it here:

https://github.com/isilence/liburing/tree/tx-timestamp

-- 
Pavel Begunkov


