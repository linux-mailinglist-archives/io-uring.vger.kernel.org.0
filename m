Return-Path: <io-uring+bounces-8527-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A8AF8AEE50E
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 18:55:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D54C3189D6CE
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 16:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B912900BA;
	Mon, 30 Jun 2025 16:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="n/dBr8X/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F07292B35
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 16:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751302461; cv=none; b=XVeTEl89LGZixVBaOYUPX5JiUuO9HcrXmbKWDxq1ORV0Ee8cajDeID/3BG/q9cmMh4Ezbl/f3EpCu/DgMzOP/vjsJwcy15h95Go/LO+0Y63+MPcUJhhXvuLfi4bw/UD0nYE92BliS3DzESve6UkijkOij9m070RoV9Bk4oZFHbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751302461; c=relaxed/simple;
	bh=hIicDJomNI+T0FBpJZKvllTZ2iiqC+aiC4Tw0xXleuA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ReramhrjVeCZmzRs2FQZKgb5LK2+awOhUet/aaR2jwWg7/pD2igW9WpOaKNGkTMzr5ILKjRGSB6+k2asJBLHUDhbFh0PtDFqKi+N66wGdBzUy0cJ7er40PTOIjSxbokh8CmtzR3oU+jVCrxdN5vCUjJ7D0H3hwuV4HMbKojC+6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=n/dBr8X/; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-86cfa53d151so2602339f.2
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 09:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751302456; x=1751907256; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mtJIAjrtHSY0a3dQckVwISiiBjQW3PZAQk5wVdLJAE4=;
        b=n/dBr8X/ACZAfMO4uh96zs1zB0G2UbyA2MUKzBazWdyUXsBN77mKV99GHcQGEU4BX0
         Sx3CwLhooDHiMHqe7K721LNndUKFntyz2zNS+9mF1z/D+zSOXyWFEshx992/yuBb+HaB
         xlyZF3EVMldMPI8xOy8kO+IbiPf1GoqXBzLyw1NFddZDGeP1O2qnPYX7RwYIZlGYDloV
         r+30c2wfP3s9qLnhVqOWnKNjIYSn3zPNCLteNaMb5YwS3MLSs2c0va0NZqc8csBYpNrb
         EvOSRrramFtMioOLyx1JGG+lxGhc90pGmRGwlL1ml6us6Vo2zguEaxGLydrS8XdTlu/N
         MdgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751302456; x=1751907256;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mtJIAjrtHSY0a3dQckVwISiiBjQW3PZAQk5wVdLJAE4=;
        b=o/dazGzi0kvZNNyog2UBluxLKu6iJBLRppZnqBx1WKI2+fjc/LnwvbKvXcTqgAXLh1
         a+NQgZ6/GDevTQjyPAaOiE5/v+D19w/H8KrFLj9hApvK5ARo5U6Pi0TdSuFpmpUHHah/
         RTO2p1Cl48t5agD09Mu7YsnF1/1PQhD9xQeqlECzEKeNfZh4Xx++DlIbU//OZvCRHEF5
         HBNrKQLkj7rpSA66TKp+36v7Cq5VYJOLhwoIM6oegpbYDp3tJHm3C6lFf8GcDSQd1WUC
         zw9TIWS2+Rr9dHC9AQ8i38bb67eqxvs8RDBTJmt8P+ta2yRZ2TPPKYhGYphPmq7NM9AS
         gf/w==
X-Forwarded-Encrypted: i=1; AJvYcCVuYY0czG+/4c47fIXmtn338O1W+6IDhBydTIjM0ZYi2mDigXznex8RCjYax+v890JgWlFE5HsWxg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yym1otiRJoebxjfUagNGiEybj3/P+pi3I36iQpzffhCL6zTJJVo
	0ADVtV7kwQ2odIxTq6nRdDJpZPaTrNI4yANzkep0Q3IyQHdnrSv+VgLOw/fmk61pSeE=
X-Gm-Gg: ASbGncvb6lrDGdDkFQyCSEcyMtaTqWbawDakgKICGixJEbQMJ6Vv4VX/S8yCalTDBlE
	xUcOv7LM1lSwX/bc081UgZDaOPHAj/FJT1md1XLa3miWcR669oVYZRWngnE/tAwJWEGmHQ4JtSz
	nDkdLC13JjuJY2ehkWdJzxrxHsqrOXM1++LyP/ENchXPhlrjeVh62vIOHAOMr3IlGJmyqg+IAo3
	kdhZSMwbOM2HU5ImUyhVciAZhiYM86eHbKKYaiLjqXz2sjAQTqZwCBNO40J4iTli0CpXm3xWEfP
	kZa6Q1bFK7S4Id2u//dMXNjiQHgHTU49AGf9CxtHWlGq1DQZvjsLO94y3tU=
X-Google-Smtp-Source: AGHT+IHJJ+NZMQE/+J5LgUQ+BGgDDV86ksa69HYnqvS6JgAv6a8w819wlFG8V3pr7ffTmxLVm3+8ww==
X-Received: by 2002:a05:6602:1683:b0:862:fe54:df4e with SMTP id ca18e2360f4ac-876882c7367mr1653664639f.7.1751302456374;
        Mon, 30 Jun 2025 09:54:16 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-502048608c6sm2008378173.17.2025.06.30.09.54.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 09:54:15 -0700 (PDT)
Message-ID: <0c7bca50-5026-4049-aa80-ec19e4d0544f@kernel.dk>
Date: Mon, 30 Jun 2025 10:54:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] tests: timestamp example
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1751299730.git.asml.silence@gmail.com>
 <4ba2daee657f4ff41fe4bcae1f75bc0ad7079d6d.1751299730.git.asml.silence@gmail.com>
 <accdc66c-1ee4-44af-9555-be2bd9236e25@kernel.dk>
 <79255ffd-9985-41f4-b404-4478d11501e5@gmail.com>
 <1c1a2761-9e4d-4abd-ab43-e6d302092b6b@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1c1a2761-9e4d-4abd-ab43-e6d302092b6b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/30/25 10:50 AM, Pavel Begunkov wrote:
> On 6/30/25 17:45, Pavel Begunkov wrote:
>> On 6/30/25 17:20, Jens Axboe wrote:
>>> On 6/30/25 10:09 AM, Pavel Begunkov wrote:
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>
>>> A bit of commit message might be nice? Ditto the other patch.
>>> I know they are pretty straight forward, but doesn't hurt to
>>> spell out a bit why the change is being made.
>>
>> It's not like there is much to describe. The only bit
>> I can add is the reference to the selftest as per the CV
>>
>>>> +#ifndef SCM_TS_OPT_ID
>>>> +#define SCM_TS_OPT_ID 0
>>>> +#endif
>>
>> Otherwise it needs to be
>>
>> #ifdef SCM_TS_OPT_ID
>>
>> All tests using SCM_TS_OPT_ID
>>
>> #else
>> int main() {
>>      return skip;
>> }
>> #endif
>>
>> which is even uglier
>>
>>> This one had me a bit puzzled, particularly with:
>>>
>>>> +    if (SCM_TS_OPT_ID == 0) {
>>>> +        fprintf(stderr, "no SCM_TS_OPT_ID, skip\n");
>>>> +        return T_EXIT_SKIP;
>>>> +    }
>>>
>>> as that'll just make the test skip on even my debian unstable/testing
>>> base as it's still not defined there. But I guess it's because it's arch
>>> specific? FWIW, looks like anything but sparc/parisc define it as 81,
>>> hence in terms of coverage might be better to simply define it for
>>> anything but those and actually have the test run?
>>
>> That only works until someone runs it on those arches and complain,
>> i.e. delaying the problem. And I honesty don't want to parse the
>> current architecture and figuring the value just for a test.
> 
> #include <asm/socket.h>
> 
> Is that even legit?

Good question... We can always try. Looking at debian, their newest
package for testing/unstable is 6.12.33 which is why asm doesn't even
have it. There is an 6.15 based package too, but still listed as
experimental.

-- 
Jens Axboe

