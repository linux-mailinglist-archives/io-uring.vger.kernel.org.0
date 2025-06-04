Return-Path: <io-uring+bounces-8213-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD9E5ACDE21
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 14:36:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DD11164847
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 12:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9522D28ECEA;
	Wed,  4 Jun 2025 12:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GBgnyp2C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2FF28EA41;
	Wed,  4 Jun 2025 12:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749040603; cv=none; b=Rqx+L80S/o5SH1RCsUwMvR04eC1MQrFnO0emMpWLM+lazJRlSAIfFnM2RWzqfu+77xHTrWK53HNcFTDAYLukUrkNAgpoJCeT+tG/o5n3iEBmMzIp6ZuS4oh1NB4qeyqIm36qh5iV12QmtdjuVbERRaHp08Cuatk62Hcq5ORrF2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749040603; c=relaxed/simple;
	bh=tVbrkFg33kKCl6pz608RQ5AoDrhQHTPHfpoIjv/FzOo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u+kedBt0ua42jmajSv4YVZrbGLB0iKPPsx3qcUtcha8LbBsSWqbZmeRP6Qoxu6VcCbGTeCYuT1l06mf0dEPordQ4d+dQvjMD00xgKtfQCpu2HuVeQ/ivPozwDDjK7PK8ZEfodcPxQxlwi2GG30i8nQCSAsib0sBF6J8VdodFtqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GBgnyp2C; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ad883afdf0cso1285654666b.0;
        Wed, 04 Jun 2025 05:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749040600; x=1749645400; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DwqYeSj50tPrfJo7B8aScun0SAt0rmNbA2C7B5WvB24=;
        b=GBgnyp2C50i9T9ocFZuC2iZD4cLRiO/WFNmUZmYOKvDKQD8eMFcwUhskWNI4b45SFv
         vuHP7t6mFFqx7A1H7/tPtu1gIw82Yk9Eqqd9b1SH7LRpebjmFD7r77NZrGl/gCbZKfi4
         Tutc4t9Jy+D8woDvRGg6CsqPeJVa+1NnZOySA3mwYY9+jYwOHjZT2lkwPEQGa5d2hXW4
         agPVafJ1+B0U4tMFBaI4aF46/rJFbOMrsB8Sie4yv6Dz9YQxnIjwRodkm42l19ohVtWG
         uadqHjgfWZ0hTqlcfecZslN2qw1CpJo7Znu/DNXW4R6Wrtaad/DB8wcYvYIbFcpAATaJ
         /3UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749040600; x=1749645400;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DwqYeSj50tPrfJo7B8aScun0SAt0rmNbA2C7B5WvB24=;
        b=vQlCdXYjfrGaw64ZY8VBwWTJiDCrE8Y0St7X5vjVV1edZpzWfm+09OrJQZ6vFsTplJ
         79o73C/XBOjmO51kP13CHQ4JX0u1qXXS091jSyNGg7aNp02CPqiyAAlLR6XxAyICTTWy
         pzNOK0FtXwolFmbIidx4SWdpsF6DQdXYT5RA4lbnkC8/9e8Llwo9GpckGKPYdEqD4O74
         rXBpBo8mC2jmirXU+WICN2ExDm0VJvQ3w2MWFt+9JvmUS1xp2r7vqse45gOIMW6DbZuZ
         WcJf1ko4g1+UhjUwB+WAxrSKvf4/Npq1DO3Hde+Ny+2c7/YgrafexuvwUGvCCB72uzPP
         AYGQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/pF4tgKL3KioHJyIkePYQ1UtG/gCncw8t1ZmZFmyc3USnALLZ5tLQgt9+XPAbMGpCuFJHTxba9w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzqiIQEt5tYncBHBuZa9P38HSoCfSDd+BoT5fWNwHVlAN+lX8n7
	eLKw1yzVg5RiplNMG+P7ewjf/KV4JI57X/vouChDDB4rdzlApgqGBdi3BnY/kw==
X-Gm-Gg: ASbGnct/SHm6IJH392s7x9tDuEN6khd7TmsEiilC1Go2GXjdptYqXFGkFP8hf4dgrkA
	3SsoaIKJUeL+QYEqN14Ei9YEulZrPXbOIDGKZ8bX7YXHyBn8/T8DZzNlRd534J2ofEHjAazUdks
	shFhaw3vYnAOOpFUmzuhdt59eakAcM9GFHWEP2ScBMLmLeW/24peSgTKxGcxhwgoNSG5OR5Y1b5
	FYw6d8RutJTGMablOcIBDYpnzGaT6wObRlZCn2rW6xX5GidfcQ3SBppc7Oa6wwLI6Xmw1sNgOYM
	VYW1cMVixSG3p0zT9hHygbbRzEmdfeN1smvL2Tn3/xFKfAlov9+jim0RUYG4rmqj
X-Google-Smtp-Source: AGHT+IFd/CyVppJma2C+P75Q43NxxRfh7zM2X/byw+se/FmxoabmRdGrPSzYA6egeVh0yRQmYBEm3g==
X-Received: by 2002:a17:907:6ea2:b0:ace:cc7f:8abe with SMTP id a640c23a62f3a-addf8f19124mr236411866b.31.1749040599865;
        Wed, 04 Jun 2025 05:36:39 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::26f? ([2620:10d:c092:600::1:b3d1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad394f1sm1087613766b.135.2025.06.04.05.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 05:36:39 -0700 (PDT)
Message-ID: <a3430f8f-8e38-445b-a3e8-f7c0d0bd1f00@gmail.com>
Date: Wed, 4 Jun 2025 13:38:00 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] io_uring cmd for tx timestamps
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>
References: <cover.1749026421.git.asml.silence@gmail.com>
 <1cc7d36f-9bf7-4aa0-a974-35fea28a7f49@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1cc7d36f-9bf7-4aa0-a974-35fea28a7f49@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/4/25 13:06, Jens Axboe wrote:
> On 6/4/25 2:42 AM, Pavel Begunkov wrote:
>> Vadim Fedorenko suggested to add an alternative API for receiving
>> tx timestamps through io_uring. The series introduces io_uring socket
>> cmd for fetching tx timestamps, which is a polled multishot request,
>> i.e. internally polling the socket for POLLERR and posts timestamps
>> when they're arrives. For the API description see Patch 5.
>>
>> It reuses existing timestamp infra and takes them from the socket's
>> error queue. For networking people the important parts are Patch 1,
>> and io_uring_cmd_timestamp() from Patch 5 walking the error queue.
>>
>> It should be reasonable to take it through the io_uring tree once
>> we have consensus, but let me know if there are any concerns.
> 
> Still looks fine to me - is there a liburing test case as well?

Just a hacky adaptation of a selftest for now and requires tc
incantations either way.

-- 
Pavel Begunkov


