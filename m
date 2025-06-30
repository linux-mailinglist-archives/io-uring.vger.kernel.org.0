Return-Path: <io-uring+bounces-8525-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7368AEE4F1
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 18:49:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE09E3B7446
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 16:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7CCB25D1F7;
	Mon, 30 Jun 2025 16:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AwQBKP4l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9E18460
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 16:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751302157; cv=none; b=rs28Ovx9ZeFaFlX0r9V5cLmiOXZNZ54oZEsJMg3Ffv55vwJQTeZrrxnGFzFexHOzge4EC3OX2saD0Y42v3kN0ej3zJYbuGDtPtjr3S3IvDVIDde4xxant3nxxeKJ4VlcjneLJOs9s4UzQ4sBZfe4gs+V3Shoif+0IOVHAAV5RIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751302157; c=relaxed/simple;
	bh=fLeZEmgJO6R6pQRlJt5jvSYmhm8OOGQ8bdRM4ggeuS8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=PMFvGIJQgzgivRhilirYSCDfDmgP9kiiXng+5U7rUe2G4H4JRBCt4maCyGuJ8lDTcspojWzaBT5ZJt6cieE97WnjT5oS/HE3rxut3GiYqYA6LjB9H65JcGGYXVSScxryyYcxXtw2u0x/8fajCnNkX9B70JfhAQ7CsX9fDKP2ZJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AwQBKP4l; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-879d2e419b9so3565370a12.2
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 09:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751302156; x=1751906956; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mrW9f26fIExGANlWf3AAOlRqgG2ecTAhwJrAGUmlKz4=;
        b=AwQBKP4lWVsp3DAUC73NA7TPCm7p7/KA1D9zsDDLOoD/HQWMMzozxdYgMn1ZlIfsi1
         GOyqnhtI92lrMXNS/Iv4HJ8GkjMRQasECRHuVaHaxWGsYh7HfcRx/bs5d828D+MIyUoa
         GKcaTBuAENbBvFQ1BrT6qh0CyzBN42KRkd+Q6PuONkM+WR/oIALA6cJQL2454F91wXNW
         guK9DfHwU1peqN7yQ4+J4kp4x+ngOvKYYidR6Dwcm0EmuEIHmBK4ZDlOAj83J1AfA8r9
         I+oST0hks1szpcWX2DnoPRW/o98YSxb8xbzDuabnUMYjEnGUFqaEZb7BmVW7gimy8yC9
         eyCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751302156; x=1751906956;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mrW9f26fIExGANlWf3AAOlRqgG2ecTAhwJrAGUmlKz4=;
        b=whuFaEt1wX2wTqiwXJmR8V0AKozrjWFaPPiOhGQ8O+UsmJrRzIcLKKk+za/zPEMVsC
         5/0SRAojT8+mSB7yXtgw9Y5Rh0wU/bdf80oGe5Ip+4CQE7HfFCW+Ax5IOFbeBryXx72/
         5SVkRziGn7aybRhRn/OaBqX70ifMs9ynsyEVmamduUdymGWne4hVzaI/rJz+cfYkIoGD
         lvrRhw1oC0szGX+ky1hjr3ZCRQ8k248SXzO5jXzE+0CaE3G3CYzFPBj8Slk0no6p+0sB
         1jz1FEw6mwI9amZr01DRy6AV39R+9qWcmN5lSMGCNiAyB4AMLiya1m4CCgKWE7NXOudO
         YcnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOHXAyRPl39iel6z70U8wEdbFaJBkXrC9S84Ici5FhC/RzXsoSAmFOqB1CiFSNCeAGAGLtAaiQFw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yybp8+3xQCK5tWm/2gBALcUZz5GnGeKCIMPrTv2s8GzXQU01x+R
	q7MLxMVg+vGASfl2sM51xq6JWLfLcGbIx84fzDf0QzcIQdQLhK/wsUUhVkXdRm9Z
X-Gm-Gg: ASbGncssaP7bixcx9isx750hTLdNT1xh5cw7pZe9GSv1lc8haX4bt4gotxpoD5QoAlO
	AzsMh1l8aqGz+gmD5JN/ciOlGoJf0ojWhblmoAJhipZBh553qIuY7IzDFEcUUVuKiCAC5SFV7Cs
	no6aZT+bPZ+j6EIvIEpfqQvWvnEEpFqO4xcHeyZ4hrTqz4tj1P3X8M9LKxIEhlGMTTbo+vijIdX
	O7J9MmLpr3ejW2Q6jLE4PNhRXxsoi2gyyy10k3JloPJNZcRm1HLtEfIS3BbJt2gwMi4tAeYanLD
	/Z5xF15v1zhWjw82zczyQKsiOlWjl3i7YZ0IlQsB0LsCyUpY8kMfMGy7O1HBKLvAPwiujp2UI/I
	=
X-Google-Smtp-Source: AGHT+IEvOsDLZSD5Kee9E4sKUd84LTv4rNeg3yYX7DwLqwgl9hupXbOfpJIIiOXV43C17lDkPTpPfA==
X-Received: by 2002:a17:90b:2b8f:b0:311:c970:c9bc with SMTP id 98e67ed59e1d1-318c93163femr19533794a91.30.1751302155529;
        Mon, 30 Jun 2025 09:49:15 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:106::41a? ([2620:10d:c090:600::1:335c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-318c1392233sm9443377a91.6.2025.06.30.09.49.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 09:49:15 -0700 (PDT)
Message-ID: <1c1a2761-9e4d-4abd-ab43-e6d302092b6b@gmail.com>
Date: Mon, 30 Jun 2025 17:50:42 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] tests: timestamp example
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1751299730.git.asml.silence@gmail.com>
 <4ba2daee657f4ff41fe4bcae1f75bc0ad7079d6d.1751299730.git.asml.silence@gmail.com>
 <accdc66c-1ee4-44af-9555-be2bd9236e25@kernel.dk>
 <79255ffd-9985-41f4-b404-4478d11501e5@gmail.com>
Content-Language: en-US
In-Reply-To: <79255ffd-9985-41f4-b404-4478d11501e5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/30/25 17:45, Pavel Begunkov wrote:
> On 6/30/25 17:20, Jens Axboe wrote:
>> On 6/30/25 10:09 AM, Pavel Begunkov wrote:
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>
>> A bit of commit message might be nice? Ditto the other patch.
>> I know they are pretty straight forward, but doesn't hurt to
>> spell out a bit why the change is being made.
> 
> It's not like there is much to describe. The only bit
> I can add is the reference to the selftest as per the CV
> 
>>> +#ifndef SCM_TS_OPT_ID
>>> +#define SCM_TS_OPT_ID 0
>>> +#endif
> 
> Otherwise it needs to be
> 
> #ifdef SCM_TS_OPT_ID
> 
> All tests using SCM_TS_OPT_ID
> 
> #else
> int main() {
>      return skip;
> }
> #endif
> 
> which is even uglier
> 
>> This one had me a bit puzzled, particularly with:
>>
>>> +    if (SCM_TS_OPT_ID == 0) {
>>> +        fprintf(stderr, "no SCM_TS_OPT_ID, skip\n");
>>> +        return T_EXIT_SKIP;
>>> +    }
>>
>> as that'll just make the test skip on even my debian unstable/testing
>> base as it's still not defined there. But I guess it's because it's arch
>> specific? FWIW, looks like anything but sparc/parisc define it as 81,
>> hence in terms of coverage might be better to simply define it for
>> anything but those and actually have the test run?
> 
> That only works until someone runs it on those arches and complain,
> i.e. delaying the problem. And I honesty don't want to parse the
> current architecture and figuring the value just for a test.

#include <asm/socket.h>

Is that even legit?

-- 
Pavel Begunkov


