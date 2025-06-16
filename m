Return-Path: <io-uring+bounces-8354-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53CF7ADAC2D
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 11:43:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0206416EDF3
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 09:43:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76CC3272E6D;
	Mon, 16 Jun 2025 09:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qk10xB1d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62242E11CF;
	Mon, 16 Jun 2025 09:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750067009; cv=none; b=VmElNkAtHM1xcYIX6HO2KbDucZNUaAzf7w6cfZF5rEonok9yki4B1VJtnrTVdSQwW3VOPL6F14GTJ8Jj+cMEvCHxagwvEhuaGhadJLT7qOeAxQDZcpa8Ugzv5CCi4iT3Jpi5M6pIjizk48fh+O3N+1UDB/5DJXeU3LzAVlgNi2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750067009; c=relaxed/simple;
	bh=5Xnw2Jra1koYIIkdKsAEPyKurdAn/Vg9h1E/VggXMOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rc9YP2ztAiFeysk8hYX9nVf4YySnK97u6rMNmoAm3ixRljtQLX6LZCijp1nFaNHkICp03I4vy0lcXo+I+1u3ZjrKO6cAU4ICtjIjD2stmXVIVKuiLYbimMZ8CdAL31LKkGZ4VH9hOc7Upq8kuAE2vdR4q7nR/Q3df/dZzi1VSuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qk10xB1d; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-607b59b447bso7537013a12.1;
        Mon, 16 Jun 2025 02:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750067006; x=1750671806; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3VFAgYKBsVAl5qgJ+sBZ1kLGEhL365WNgJnTEeGjRfk=;
        b=Qk10xB1dEURRHPx/RfgKtCaMavRH2J26brjJEy3rNwM+n5Llsc48szN6UcNDE9ltQM
         4JCynhBe+qDA45jTOvBba3oKXEye8KZmu6XnMLLjfG5okTYH4/DidjpOKCSwOY8yEUIe
         dFGP7643vXtQqlDqcwxmZooJ/M7UiPHHIbIKjqpa97SI0SdOtQcNHb4l7Bi0bdrNRXEc
         gCpVu1v/8OSS3KmSZBnTGnb8R67tMZfdzy17yGuOFk4kyB5x0+7SmrGc4+BhrtWPdq9w
         CGEJlwFEMUJIV5Bvx+z7U3miZNaY4xSwwlZ/fX0aOd/Y6OttPjtokgme8rM15OJnzyrA
         D9tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750067006; x=1750671806;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3VFAgYKBsVAl5qgJ+sBZ1kLGEhL365WNgJnTEeGjRfk=;
        b=IIfP4nQa6XcMj7u6Epcj4PgbxVHUn+PUwZ9/85VhuiZaHFSUGA9D8n+0QSCs5SjADf
         u1NL6yU4uMISGk64ENj9dgFJLJjGXxVUPXKB918dLKrhVaJvyEg+fidjHF0BgpTkgz0D
         b+6bnsbizlSeoclHHYPCMkGLT9FS3seawqxprmjb3ZpUCK9dYeTKUQJoXNM11A7dQuQc
         EIfy8cPPaibbw6ca6Oqtevm7mlVOMIdwsZqo9xVH2Iew447YRWlivNV/dQKvItX9Orvf
         c8D9qtOGTfAx7XecV3BioYUIOPMA/QVrC9hW8g9gj3Ks9iC5/bzwbklrX/OSDFiIfiCv
         f84g==
X-Forwarded-Encrypted: i=1; AJvYcCVVLc2hgKnvgOAuEpBD/hx/IfOpp3bgrP/ybA3CODI5tnoCE4VaSsGLEa9RM91MSdD94egcL107+w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEbq0M6YZtdN0nY4+6TE50zgUAEX73xdV5g2o7CVHm5kL17VWV
	WeyRofLIWJre77jOGQjj329TXhhwQLCmnYWejJeJibSnbResSG4TWuMVnBN49g==
X-Gm-Gg: ASbGncu7lMZm5zZ54pt8ghh2ArbzXHmhOV5AnGHuxyNZPHEuwRs98vaUKGL8ctgN1cx
	aF+8iiOjcktZneKrtviH0Ha35ZF/WTe40tMTxN4Tn/GZYRNRapmuOkbTf0Q0Gl47C0gMGK9ZrP+
	lDlDSQOE5biM/zGbn6vDgT8Ug0OagkB52g0BrWe9Epf8Xnuei9RU25POeTlf43T1QCFLST/u6lz
	ET6dZctQSiAOjo3NgEWScvORyXf657eC5zGSQHfkcKRzvJLjKUpHj9IrH8THnTidhlJW7H7S9fL
	zlUYtfkqMIOia0CKH+5wmTKbyFgXz/vBS8oxUtLjafK668EZNHss5C0y60jlI4UcjHU8lTVVUtw
	=
X-Google-Smtp-Source: AGHT+IEXy41elW6R91h+1b/5pcTjDGeEn67tl0LlxbC27fgalPTWziAdASr5L3/R8cDfm0MnFN65nA==
X-Received: by 2002:a17:907:3f8e:b0:ad8:a935:b8ff with SMTP id a640c23a62f3a-adfad4159d5mr868055866b.31.1750067005785;
        Mon, 16 Jun 2025 02:43:25 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::2ef? ([2620:10d:c092:600::1:a3c1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec88ff6a9sm617061566b.83.2025.06.16.02.43.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jun 2025 02:43:25 -0700 (PDT)
Message-ID: <560f6cd7-f66e-43ca-b458-ae362d0779de@gmail.com>
Date: Mon, 16 Jun 2025 10:44:43 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/5] net: timestamp: add helper returning skb's tx
 tstamp
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 io-uring@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing <kerneljasonxing@gmail.com>
References: <cover.1749839083.git.asml.silence@gmail.com>
 <766c5e599bc94296fe58087e4c30226260cddff8.1749839083.git.asml.silence@gmail.com>
 <684f8218f2e39_1e2690294dd@willemb.c.googlers.com.notmuch>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <684f8218f2e39_1e2690294dd@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/25 03:31, Willem de Bruijn wrote:
> Pavel Begunkov wrote:
>> Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
>> associated with an error queue skb.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   include/net/sock.h |  9 +++++++++
>>   net/socket.c       | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 55 insertions(+)
>>
>> diff --git a/include/net/sock.h b/include/net/sock.h
>> index 92e7c1aae3cc..0b96196d8a34 100644
>> --- a/include/net/sock.h
>> +++ b/include/net/sock.h
>> @@ -2677,6 +2677,15 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
>>   void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
>>   			     struct sk_buff *skb);
>>   
>> +enum {
>> +	NET_TIMESTAMP_ORIGIN_SW		= 0,
>> +	NET_TIMESTAMP_ORIGIN_HW		= 1,
>> +};
> 
> Can you avoid introducing a new enum, and instead just return
> SOF_TIMESTAMPING_TX_HARDWARE (1) or SOF_TIMESTAMPING_TX_SOFTWARE (2)?

I can't say I like it more because TX_{SW,HW} is just a small
subset of SOF_TIMESTAMPING_* flags and the caller by default
could assume that there might be other values as well, but let
me send v5 and we'll see which is better.

-- 
Pavel Begunkov


