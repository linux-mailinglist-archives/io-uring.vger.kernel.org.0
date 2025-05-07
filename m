Return-Path: <io-uring+bounces-7881-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7DFEAAD84E
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 09:37:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D13F3AC046
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 07:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 310A0211A11;
	Wed,  7 May 2025 07:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xdy/G8Mv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526864B1E78
	for <io-uring@vger.kernel.org>; Wed,  7 May 2025 07:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746603232; cv=none; b=PymTxm0EsjZl426ytpf+OWO/ah9Wp0JwVrjGz8MeUWLNFRPXcw6mJV/Dt65hlJhk5XwK7tlEyJdiWIl2y1sVlHOz66BiNkRu60laCsYvne1gi3+8+Qfzug8GTZgm8oGENhgPmgBdj/VMEVr6uZyZput6P1XCqv2tU4tl7QbVzuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746603232; c=relaxed/simple;
	bh=u103Ny9sZO8Mn/LRHmVWnMuc3cqClfayFMKLvNMx1S8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mDsgRDEzkAAOeaUZnLNElpKqYEF9wzRyETldJ5orAfpSJjG64V2btrcOYcTOczubjOUm5FORMsro6oLDpUHKs10YQElypdKtTGpJ7eYIGx+RZYjUModUnHCRdAKAZNPuVGeH6Z4k+nfJQa4m+TFsHOwkU17NHHfC3kd5I0CeeYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xdy/G8Mv; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5f3f04b5dbcso9815550a12.1
        for <io-uring@vger.kernel.org>; Wed, 07 May 2025 00:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746603228; x=1747208028; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U3rlbns3fFFV2REAphk/UvUHj5Egepgssg8ets0atGU=;
        b=Xdy/G8Mvo0I+ZekiBcm5RCACElk6k8leLkYH856e8S6lWGF8FP6HRLKmkiEAaDoAtC
         44pLvE6fsAx+hceRC3icELq89B3O/urw+eQoYmqMid0BxPnJcKcJlTK1M9iWb5CD6KrQ
         VCSIyq1ZGJriti94KM6WcKROpDw9Lt/qv5GCzgbzW1IOrgs+XtYX3NAzDadRhhGag5JQ
         g9oSAcrHxfS3RnBk+O9TfsjtXTab9vinLMm1WvY17+hVO7EF0rdd14xHAfq51AiUpZhx
         IOBUs5/hQrZ3MK9vd/9rudbN/MlnTkyGXJh4dNf38km5IYoCGa1WRs3ar2AdgJ63luay
         HSHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746603228; x=1747208028;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U3rlbns3fFFV2REAphk/UvUHj5Egepgssg8ets0atGU=;
        b=J4Oh8TqVQfmDUqvIptcj1Any8yTML7r88e+jhDsQLPhEtcR20Mv4EYidPPdExHzmH8
         k21yYH1ydvTiee+3ZylTHcIMgyJikfRnbZAJRaeU0viUq9//cYqZCSns9ni3LD2SuE6Q
         VMxJzccHYyPoPhZJhTEKsd8eDp/CobsSXxQMdrJIAEqXsaF+m0Y3/ugTnRB/NMIh/kLu
         f/swCwGGis9nYS3FP3fNLqvkoAOgUOYIkvi0GyqDNGwiqpIsiBWWXAkASAkeVaHGrlQA
         /0hmYEiXd6pYIBm3MbQy3npEzDIQ9KO5f1UjrYevEk7Rb5uhohvSwN8XXLe1iGVyOy+9
         rbzg==
X-Gm-Message-State: AOJu0Yw7fwnhfTAA/LTJrvXN4GMM8O8xXPdhvTxOiCO8uuZNcZNRl2ep
	Aye2L+YnG64/z14GTPSdu6+vYOaifzbNKioQX3IQvByYvvVwV8HA3Xqsjg==
X-Gm-Gg: ASbGnctwqN0l2/xgbpKvAR/Xdf5LmqsLdBXVejTDP1kQODF/vcDTL+7y/+8admTczff
	bpYlXYkIPeXWF+ahBx8Epuiasi/BlXwW2a3lsW0i4a/rD753Svhi2X1J9nc8yFmimGY7kWpZ6hL
	d/t6fmamXLL2gChjHM/VgsUtduhDv27rcfrwcvR5HCZv+yDR9g3WX0CYOOAt5lTiQwcJmdNa66J
	cm3j95YlRRh/qD21/zF/8F13ImiCwsclFZ/K+ns3QqDNvUm5EVYKB9/IIjP6rGo+rXlXvt0IQcN
	pRcKSuiq3FxxltxrtlyVkacQGby/nLJtOG4ASx7RWHYU3HoezFK8Mg==
X-Google-Smtp-Source: AGHT+IF2qZhrp2r1/kB3ojA2jFMpNEO4btme+zDsSA3gUTkdSGhlX5mYfU04wQ7VofReW2zZI8fo1w==
X-Received: by 2002:a17:907:d1c:b0:ace:c3b7:de7b with SMTP id a640c23a62f3a-ad1e8b9c9demr203992566b.11.1746603228365;
        Wed, 07 May 2025 00:33:48 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::1ef? ([2620:10d:c092:600::1:ef63])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad1891a15d5sm852218966b.44.2025.05.07.00.33.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 00:33:47 -0700 (PDT)
Message-ID: <e7c8d8f8-511f-4119-b097-864249d0dfb4@gmail.com>
Date: Wed, 7 May 2025 08:35:03 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/zcrx: fix builds without dmabuf
To: Alexey Charkov <alchark@gmail.com>
Cc: io-uring@vger.kernel.org
References: <6e37db97303212bbd8955f9501cf99b579f8aece.1746547722.git.asml.silence@gmail.com>
 <CABjd4Yz01BWsS=2dnk-81oZLoGxsGGaGZ1yMayTsyx_WjygeAQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CABjd4Yz01BWsS=2dnk-81oZLoGxsGGaGZ1yMayTsyx_WjygeAQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/6/25 17:58, Alexey Charkov wrote:
> On Tue, May 6, 2025 at 8:07 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> armv7a-unknown-linux-gnueabihf-ld: io_uring/zcrx.o: in function
>> `io_release_dmabuf':
>> zcrx.c:(.text+0x1c): undefined reference to `dma_buf_unmap_attachment_unlocked'
>> armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x30): undefined
>> reference to `dma_buf_detach'
>> armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x40): undefined
>> reference to `dma_buf_put'
>> armv7a-unknown-linux-gnueabihf-ld: io_uring/zcrx.o: in function
>> `io_register_zcrx_ifq':
>> zcrx.c:(.text+0x15cc): undefined reference to `dma_buf_get'
>> armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x15e8): undefined
>> reference to `dma_buf_attach'
>> armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x1604): undefined
>> reference to `dma_buf_map_attachment_unlocked'
>> make[2]: *** [scripts/Makefile.vmlinux:91: vmlinux] Error 1
>> make[1]: *** [/home/alchark/linux/Makefile:1242: vmlinux] Error 2
>> make: *** [Makefile:248: __sub-make] Error 2
>>
>> There are no definitions for dma-buf functions without
>> CONFIG_DMA_SHARED_BUFFER, make sure we don't try to link to them
>> if dma-bufs are not enabled.
>>
>> Reported-by: Alexey Charkov <alchark@gmail.com>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/zcrx.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
> 
> Just wanted to confirm that this fixes the build in my setup, thanks a
> lot Pavel!

Thanks for double checking!

-- 
Pavel Begunkov


