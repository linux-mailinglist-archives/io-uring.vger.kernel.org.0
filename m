Return-Path: <io-uring+bounces-8170-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F31E9AC958F
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 20:20:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B866A1653D7
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 18:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD4F51E7C27;
	Fri, 30 May 2025 18:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="frAF83Gd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC0F2AF14
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 18:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748629208; cv=none; b=Fe/apu3HBVIrOdIdVJi5HuNunjcVT2p2KXyDNRjODqJYctfEMhSFldlRyhbm3BT7Wien4kM1FklYDtvQEqAuWuVmbFvGqQPukE8qI68AmCbrgzbyVHsbtuH64R/YVkOlQnnGWqu3Ru0HIlOJky/el07l5EfsW0kONcM3B7BrEWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748629208; c=relaxed/simple;
	bh=t9U/TWM0UJ0dLDDTI3kknkEiJP7yQeGvn/1FGll7xsM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YFhHd9NWy31qmdAudUxkMPw2AIbGdQSjvd3Xj08eBifNm7bbHcCdz+j2ze6d7hye7Ct8sK6gI6JNunoomJXv+/GynNAUwi85JfSgOJJ5Uqv68BG5zXPRz8OZ0Aa3X6IxNbFm/1lvlf11DA2chr9wm0A71iTYpp3IX7XOrzsdevM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=frAF83Gd; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-acacb8743a7so404704266b.1
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 11:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748629205; x=1749234005; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b3ZkEpm7iiivjOT2igIPY7uIIEXy8lnN0BRAwNUWTrg=;
        b=frAF83GdNK3qWilasZJzQmNfMhBbkgAxQZhB5kPyxnf0ffmxTkulp6ajigOnWnIKIg
         4aju3bGKOcQ/dqF2RrwirVmbF+owWlw2ZP90QqR/p4f+JYHnuzFus/wrxnzo2er6G0nq
         v4+hViPy3Yb1OO0aAv/T7jslLJ9r/063wDJBbvVQEDFMgZrIIfKvKxrToB20yb9RdId+
         G/eoe3nFSgzSINw5QHoFqx/ZN009xtZG9Uob14S4wiS9QvPs7EhxlsoG2c/8kY5J6J+e
         2SAwEruFl+YsQHwEk0R4ndD6XzdYhhihjBwPErEy+IrtEu88K4cnri53LEwGXRMxBVp/
         JG2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748629205; x=1749234005;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b3ZkEpm7iiivjOT2igIPY7uIIEXy8lnN0BRAwNUWTrg=;
        b=W57OGD3Ww+oW/ykem/L4KzS1AxsDXDx2Vdsob/PCmECbezv8Or7wSvdO3GM+5dxwtf
         t+4pFxrijHu4b71q3iLZ6JJJGONQudGzUvovOELwGr8EOXY910feXYDvKzfbaJUqjuxx
         onYFvofEHIcm+GWXZzcePRbeJodrlLBreNA50Vy4TPvX5UzvX8eTQxAOSFZKmYm6635W
         U3rhZMU2hHuWcor+skvS1EKFtrpwKBogb03gH7/FhS8QvZm1k/K21F05DyeEOYT2d6oI
         PyoC1J3FkNtZzV1vLVivh1XReX2dP5pHdAtThHfvnUKVU5nf7QRdyijGopMGSYULzOs1
         1i2w==
X-Gm-Message-State: AOJu0Yzdp7E+qqE77wz4OdDJgtnH15T//WdoAeqp44jKU/Xlb8bMDf23
	/4kOcd7YIeg6ohTTJ/bK/tgVzDxwz5wnHPVa5ap6MqxzCQIW1ON8PM2L6DKn5g==
X-Gm-Gg: ASbGncu8Gyex8d2gD1kKPrDnW/o0IM8DtWo6v3lJrX2o58PJqwzLP4WXQN9xqJScDJc
	rjjjaLS8BElIrUhclkKJhfb4bzDqvmEOznBoBIAQNV2/JdygbGJSrLXAKNBuiC/4ew2C10kQ41X
	UtsuORmWdcvqJhu3U1eG1m6v9fbkNCRyGZ4FOOlOzD26zk4pft+U2QUWhy2nUrU6Y4O7SuDMQMI
	+DNu2vBxEFD2IorVU8PgiczEyU1xvDqC3aCIaG8H0Ig2Atiyc8J6Msn821haZItbMH24XhzT1hW
	YmYN2DRV5TvIDIO2WKEMysGZ0A7lqPSWX6NP25fp5PaqTHMPqN8zMKNxh7yqEA==
X-Google-Smtp-Source: AGHT+IHuZVegTsddRUk4c4spGEiPWybF6lO/oqIhITl0jgW5Lb7BzdidwCEoYdNcp1+lf9xUczuevA==
X-Received: by 2002:a17:907:968d:b0:ad8:942b:1d53 with SMTP id a640c23a62f3a-ad8b0e8c9eamr713509466b.27.1748629205013;
        Fri, 30 May 2025 11:20:05 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.133.152])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada5dd045c8sm366055266b.103.2025.05.30.11.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 11:20:04 -0700 (PDT)
Message-ID: <f6d26646-6cff-4aa2-bdf6-e63695f068a1@gmail.com>
Date: Fri, 30 May 2025 19:21:18 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] io_uring/mock: add basic infra for test mock files
To: Keith Busch <kbusch@kernel.org>
Cc: io-uring@vger.kernel.org
References: <cover.1748609413.git.asml.silence@gmail.com>
 <6c51a2bb26dbb74cbe1ca0da137a77f7aaa59b6c.1748609413.git.asml.silence@gmail.com>
 <aDnzIKDV3-CZHEC0@kbusch-mbp>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aDnzIKDV3-CZHEC0@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/25 19:04, Keith Busch wrote:
> On Fri, May 30, 2025 at 01:51:58PM +0100, Pavel Begunkov wrote:
>> +++ b/io_uring/mock_file.h
>> @@ -0,0 +1,22 @@
>> +#ifndef IOU_MOCK_H
>> +#define IOU_MOCK_H
>> +
>> +#include <linux/types.h>
>> +
>> +struct io_uring_mock_probe {
>> +	__u64		features;
>> +	__u64		__resv[9];
>> +};
>> +
>> +struct io_uring_mock_create {
>> +	__u32		out_fd;
>> +	__u32		flags;
>> +	__u64		__resv[15];
>> +};
>> +
>> +enum {
>> +	IORING_MOCK_MGR_CMD_PROBE,
>> +	IORING_MOCK_MGR_CMD_CREATE,
>> +};
>> +
>> +#endif
> 
> Shouldn't this go in a linux/uapi header instead?

Depends on whether we want distribute it to machines where it's
not supposed to be enabled ever. I couldn't find any notion of
debug headers in header installation, what people usually do
in this case?

-- 
Pavel Begunkov


