Return-Path: <io-uring+bounces-105-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74A877F18C2
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 17:39:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F75828240B
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 16:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C614E1DFCC;
	Mon, 20 Nov 2023 16:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fqt7mxD7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F13CB
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 08:38:58 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-35b0b36716fso405855ab.0
        for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 08:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1700498338; x=1701103138; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r2RQ820cC686EcqNlIVK+j1vz6wK5IexeuwOn8xmLzg=;
        b=fqt7mxD7sUfZ5ocKo7ZLAZKVDRA4J/wcMUpsGctXC8DPB2YIgk/ugl3tWJ2PTlSx6o
         itmoPiQYA58QwDB7WFE0/t4sApyRKsi9H7EEhKTld+KdrbPtS8xqmQbGdPiLhfZyIdTT
         ul00q2+qTrj6GvNtPsdNS2bwmlAQSZORo2dDAhO2Ncbao0KRxONxOoHuJp3G+3cW/vSH
         llLftf/iVn4eoUEgmPLlNDcVS9tSkT790KtgVsB/Yp3vRvUUxEWCKs90A5D7orNDqn8n
         0oriOVXGeoz1FoaWrnDUp+G1sud7ib5YcILkp7hYHnBJFN4ucM3wVZ2AhX9rmgGLrmrz
         61oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700498338; x=1701103138;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r2RQ820cC686EcqNlIVK+j1vz6wK5IexeuwOn8xmLzg=;
        b=Ai6yAve2zBhlrGvb8CoHumJeSj7ol4NT/V4B85aqlPkKbADsYFaPDWNMed6lEewkyg
         h96DO1EAt5OrdEfQz8VaMccTE+AIATTCt477YyR6L0ViuaxY7eWkhci3h3VsvWz1cTe1
         1jwgi1pBFp3BFj6k3WCZPJhMHXAgB3icrFh6TZYoM+AfCGMS4K3vbfhuBcSdXCC0WuKf
         +vG6BG5GLag/ENnhMs9fwVusc+2V9ljr85bTpmTUTIx86xJnIblLH8JRX2CK77drJKaY
         nXY/BFxAgqeUmjHeWmcUDvUiNAl2rwV3cxqsYPVEWGHEtJqoZC66QYm8sMyUG0q3MViz
         u+3g==
X-Gm-Message-State: AOJu0Yzd0rV4eDOmWJOoi2V689alDzryU3b4520p9vi1dKPOzFewin27
	ErBTLlo/ka/Q4RAo02w2PY98rQ==
X-Google-Smtp-Source: AGHT+IF5Go4liIvNyvGx9ZajPCVJjV0EEZpjieU8RV2xgqmksNAJoh3rLDngxGSoAd4FEaYS8CSyBg==
X-Received: by 2002:a6b:fc0b:0:b0:7b0:7a86:2952 with SMTP id r11-20020a6bfc0b000000b007b07a862952mr7153354ioh.1.1700498337987;
        Mon, 20 Nov 2023 08:38:57 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id gt17-20020a0566382dd100b00463f7eb97d8sm2086256jab.69.2023.11.20.08.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Nov 2023 08:38:57 -0800 (PST)
Message-ID: <b7a7627a-da93-47e7-b26d-08f918de10ea@kernel.dk>
Date: Mon, 20 Nov 2023 09:38:56 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/fs: consider link->flags when getting path for
 LINKAT
Content-Language: en-US
To: Charles Mirabile <cmirabil@redhat.com>
Cc: linux-kernel@vger.kernel.org, asml.silence@gmail.com,
 io-uring@vger.kernel.org, stable@vger.kernel.org
References: <20231120105545.1209530-1-cmirabil@redhat.com>
 <8818a183-84a3-4460-a8ca-73a366ae6153@kernel.dk>
 <CABe3_aHtkDm0y2mhKF0BJu5VUcMvzRWSd7sPeyTFCZEFZt05rA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CABe3_aHtkDm0y2mhKF0BJu5VUcMvzRWSd7sPeyTFCZEFZt05rA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/20/23 9:34 AM, Charles Mirabile wrote:
> On Mon, Nov 20, 2023 at 10:59 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 11/20/23 3:55 AM, Charles Mirabile wrote:
>>> In order for `AT_EMPTY_PATH` to work as expected, the fact
>>> that the user wants that behavior needs to make it to `getname_flags`
>>> or it will return ENOENT.
>>
>> Looks good - do you have a liburing test case for this too?
> Yes, see here https://github.com/axboe/liburing/issues/995 and here
> https://github.com/axboe/liburing/pull/996.

Ah thank you - for some reason github stopped notifying me...

-- 
Jens Axboe



