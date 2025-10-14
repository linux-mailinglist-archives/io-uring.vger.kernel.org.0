Return-Path: <io-uring+bounces-10007-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F7C0BDA8B5
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 18:02:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59A6F540027
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 16:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B20B321CC55;
	Tue, 14 Oct 2025 16:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QJAYlBmG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18852DAFAE
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 16:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760457675; cv=none; b=LXNpBHS0ABu6HWF319wzqbfOh7J824FHhDr08DI6HYBqo9JCV9dxb4UUMuH+jqm/TjBbaOxrO+IJkRhkrk9bmmoHxIeSB4UBim9w3tMVFaUGTqlI0dfrQUI9ddhL/hrEgweUDfTD+FAYLUG4ftKIsJO/h+LzETOm2LafadnCVLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760457675; c=relaxed/simple;
	bh=9ZTyz+9vnyFWv7dHuIPQIUtWGw43gHXzO2NCPL5spb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fU7i5TdrrSuRT7P2jXJLf6BnyU8x8AcrxFMCKTdv5+WZfZLY9cPOUDHXv2aoy5KvVYhOjT8KblDuqg0ZwHX2Mlz/ex7js0IOX4Pn8OiWJcCcpabp7V0XtQIEiQVXXlZ3bj5ghYET7pwA6FaicHVEd1q4TTaWCYJj/myEWQOkQwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QJAYlBmG; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3f0ae439b56so3311826f8f.3
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 09:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760457672; x=1761062472; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UrQiQlXYG1KK+ohn8UEyV6j3qmxffTPapeGrBY2xIig=;
        b=QJAYlBmG2uwdJUtZN4Qkzi6dK2W1kgGDGssVVEd+foToam0oVIsmALkh7lx4GHQwhv
         LoLZ/Bz8CBZeR8/j86XmUDpZSJrqYBY0IBRt5sxrImxrpUNn2+JjXAjQ0CVHxgtZYua1
         gFTCsezfrukcqEP8RlIfvib0bq9vR6djj4UD+QoBuhyLlbt0Z4aCGUjrvDi6BOwVKGT4
         EbTDzK8U+0eqTdUqrjl0JC0qV/hUwAC1BJp2EeFEjO4P69fA0KlLMCVlMn912AASU0O8
         4ij7kiwoqCknM7njSmsvW4qs4q0nglNOUF4xQaa/7YENr7K4SLmEWmzYJzeZAkOr0zK6
         /Tzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760457672; x=1761062472;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UrQiQlXYG1KK+ohn8UEyV6j3qmxffTPapeGrBY2xIig=;
        b=rWSKakLX/daEipec++F67wnqsTK1hLIQqV021i3oePOtpIV7JMk0aweYG8md2od2PL
         v4H92LfDIVmtak0zw5eRZRQBmvg3DckesVg5tuWcnoXROPgggUU7teQOMSK6s5AC2qam
         tjjawB0fFUpfMKjLiZ8MjXHu6G3YAEzGUdu7lB04etIyp8PiNFeMDsSHBKSpFIGPaic0
         bE3s1ouHJ4UONLj/ft4q7yaN+OR8LzUiLtjgNsYqWPQbmcI/cEcysyCX7/CqUI/cRUfH
         B/vS+gwAL9jLqNSJ/nQwd3je9AElbV3Oui9W3xj7e9YpqpNIrkZRkvdrkiuh5ImAvY70
         dbJw==
X-Forwarded-Encrypted: i=1; AJvYcCWspVUNCBrdkjQ/G4uMdVm78H8DbDXvSiKnpGmDuGJFBrC6ZoCnrmi2A4NBcyENC3uIjV7e+KRNrg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxTDa5WowIkoIUQ+JMxaydgxCTlcncl9E/c/fJS1A754IrN9fd3
	wfj0QL/UjSOxNY+I78c0tm1ARpCIaCKB2FTWHCEzkxECg1DlFKSCtZRPF0nHNw==
X-Gm-Gg: ASbGncsx8xAzM6Wo1Pu9rEJvzy18BeAmUBoD4HL3iRa6Vf5Hy1y11esfu2ZG3TMDb1Q
	PJ/zLRy35+JgNEPVuoI86B7/JehTyywuaynVcuDuhXM3BeZkL4tICADKlBqL/XqJCJRIdqOn9RN
	9VGoY2HHthAQu/1AVoYTAFRbl0Iw3ATcq6JLFMxyZ0qA/XQbhKNJHrx3qgF+q+YrczCi5epJfcX
	qWg5ybCv71jPeZ2vaSAuIY/AHbstAoy5GIItAiXOERax+dVtxTtoNCsNZAwJdPkrcqSNcpYJHxv
	ezDPXZwA6MXE2MqpVx68OQhCm4qM+UQG9PuohAjavVfUbVNPWDr3A24PfpgnYLNhJAf6xZ63DGi
	kEZXX0CJlkG/jWWZAED+Az3GV6hPRUbcrDDgbM96WlbpyCw8kU8jzkDYuXS0VSuZPuOP5z2D2gA
	==
X-Google-Smtp-Source: AGHT+IGJKKAS7cVVjblBBt0M6O6gE3V+mc/gEmQ2N9tT/gj6w6iKTiIqJ5osQ1nYQ7pstzquXcr/LQ==
X-Received: by 2002:a05:6000:230e:b0:3ee:1294:4780 with SMTP id ffacd0b85a97d-4266e7e00ccmr14481433f8f.30.1760457671485;
        Tue, 14 Oct 2025 09:01:11 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:75fd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426dac8691fsm15798613f8f.50.2025.10.14.09.01.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 09:01:10 -0700 (PDT)
Message-ID: <de8f211d-6a9f-4fc4-bedc-1be47d4ef292@gmail.com>
Date: Tue, 14 Oct 2025 17:02:26 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Introduce non circular SQ
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1760438982.git.asml.silence@gmail.com>
 <845640f0-d8a7-4fc1-aaff-334491780063@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <845640f0-d8a7-4fc1-aaff-334491780063@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/25 16:05, Jens Axboe wrote:
> On 10/14/25 4:58 AM, Pavel Begunkov wrote:
>> Add a feature that makes the kernel to ignore SQ head/tail and
>> always start fetching SQ entries from index 0, which helps to
>> keep caches hot. See Patch 2 for more details.
>>
>> liburing support:
>> https://github.com/isilence/liburing.git sq-rewind
>>
>> Tested by forcing liburing to enable the flag for compatible setups.
>>
>> Pavel Begunkov (2):
>>    io_uring: check for user passing 0 nr_submit
>>    io_uring: introduce non-circular SQ
>>
>>   include/uapi/linux/io_uring.h |  6 ++++++
>>   io_uring/io_uring.c           | 34 +++++++++++++++++++++++++---------
>>   io_uring/io_uring.h           |  3 ++-
>>   3 files changed, 33 insertions(+), 10 deletions(-)
> 
> I like the concept of this, makes a lot of sense. No need to keep
> churning through the entire SQ ring, when apps mostly submit a few
> requests at the time. Will help cut down on cacheline usage.
> 
> Curious, do you have any numbers on this for any kind of workload?

No, very likely it's a micro optimisation in the grand picture and
would be hard to measure for anything sensible / realistic. It
shouldn't be too difficult to come up with a test with a bunch of
pinned tasks putting a memory pressure, but that would be as useful
as it sounds.

-- 
Pavel Begunkov


