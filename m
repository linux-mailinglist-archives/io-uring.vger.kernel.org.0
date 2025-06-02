Return-Path: <io-uring+bounces-8187-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6611FACAF4B
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 15:44:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 444F23A4764
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 13:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BFDA1F4CA1;
	Mon,  2 Jun 2025 13:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FY+JKJA0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E121712F399
	for <io-uring@vger.kernel.org>; Mon,  2 Jun 2025 13:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748871861; cv=none; b=Iy+2HgAP6LeT+ZD34JyE7Irxzfp7mKtbjjMme0I8o+L4mIOaS8Ruh9dwMlEISSIgXHo0ysgy01wNX0VgZ8nmMX5zKgvEIklNfNm90hhuUNyUBf8nGw1vH0Wdu48aPmwUmCIZmlo0msFIEnj91uOvWoGVuQsci+V/X9/+J/T7o24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748871861; c=relaxed/simple;
	bh=6B4tmAPjm21TzEqm43uvuO7beFHe/WslXThXwifi6JE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JCRYdVz0uy3lt3VhWSQDXwKRFPY5AhVfAb6fdS2o8GDDnShKPP4Kvlte+26zpgvwyInaiV+BOA2z5jYxLwA/6fBCXvDa9M1afqCfQ8se/DUVhJPcNPf3Z4N6+iyNeQ6Fw0FPQzeZxbQTN2AnQWlLkqXM1S9UIaIkWtSB0ae05y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FY+JKJA0; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-86a55400913so123018739f.1
        for <io-uring@vger.kernel.org>; Mon, 02 Jun 2025 06:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748871858; x=1749476658; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f7hLeRyXKWdw8YNAjXGICg/ZmVIL3erzad8+lKYGLKE=;
        b=FY+JKJA0q4kiQRrDFhglgBKlkSOkU+bX3frGCCfS7vsENz1HifPbv3N+jPf3hD8jPl
         hUiUU5efdCmZtxP2u/A+YYc4YzY293n8fDhpSUdHDbUL2O8BpCv+3ZqSdb1eSzQCQhqp
         jedPswSxNJ+GS7nj0nlFi/rz6oH1qwUUZGC4yjuklNwS1b+onDeam5FR5r7viVMaL/B6
         eM5aVEdZUBOEqgQjilugu9Ohz7eQ7H4KLMbKqZ3TAAezJi7itXU3OlFVYUQU3L7UBiLZ
         AHC59mYMsYfT29d1IZnXIVNZ0XUNSOHva8ezOMnkRpf4SOoDHu5BIAt9vt1hF6s9ArVL
         3E8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748871858; x=1749476658;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f7hLeRyXKWdw8YNAjXGICg/ZmVIL3erzad8+lKYGLKE=;
        b=uwr89llnRuP496cvC5Kzxwdzlpccxwx7iAmNphVYdy6KlI1udpITS+2PpvHgsADWhm
         iBQwD7eGEffhqvSfu2yJ9UNOPrS62jKF98WUuUpcoEm+wIzJ6bmary/GZKw5Ok5dvBTf
         pCx9HEw31g/poPgCynF6N4tjkMqWJlgjdcZl3z4HW8TdDrlCXbUc4eAvdp2B4cCz2aZA
         dAJ/l7zNhHv1//wZqgs0IJi7hqOTkLuWizllkrkbodida+/EmNe/RF3530XoY7YDa2pS
         sF6lwY1P3Ltjzdb67bc7eWIDkCyXcp1Z0bOfXkJCiI6eGY0wEAK6DleJ+suAR+qxnyDQ
         H9jg==
X-Gm-Message-State: AOJu0YykmOjyzjhcjX2eiLcqhNx638fmnSUPSeuXZVkDfDpLrcR388ed
	XfU+JLL5qAOEddPVe+CYcgEi8vq0Z6Z+l4YYGtbjMuSmck+sOJNGHa9Qj5kpWZk+L5o=
X-Gm-Gg: ASbGncu55PxmZDuUZ0aoDgxoE7kWSMDM/kGAqSk1omfRxCTt4GjMvivum8A5yL1h7zW
	MNlk3fFEY8FvWyHdztFVOQUEV5234cLEjyGFNkd9xjxJ8M3lCIEKGPxnBuUkhRTmZ0e9UDKG3w6
	ReTcwH977+kuMkMPbG2GT40G949axjDC272//hKeBHceUB1rvPBEqyjCHNaV4WUns67whZAKiK/
	fsTBCMct3jh5fPz1kt0buitwXgvDFAnz8A6c6oR/LemDhMjgPg7TyqEyB7zz2SGdJ9UX3/hZfRy
	O2zPiIMRq4FMfdnfnEXmCQ/Nvbo/NJFV8d7dnxZw/mXcxwQ=
X-Google-Smtp-Source: AGHT+IFZfLlJgHnd4Ujx/657sqUytziT8UpBhpgJi2TjFCanw114oJ6hyRQ1DPG11AVyR7THbPWUHw==
X-Received: by 2002:a05:6e02:1fef:b0:3dd:792d:ce42 with SMTP id e9e14a558f8ab-3dd9c738eb3mr121461115ab.0.1748871857920;
        Mon, 02 Jun 2025 06:44:17 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dd932c9eb6sm21691015ab.0.2025.06.02.06.44.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 06:44:17 -0700 (PDT)
Message-ID: <d1282c0d-21fb-46b5-926c-8b11b0448969@kernel.dk>
Date: Mon, 2 Jun 2025 07:44:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] io_uring/mock: add basic infra for test mock files
To: Pavel Begunkov <asml.silence@gmail.com>, Keith Busch <kbusch@kernel.org>
Cc: io-uring@vger.kernel.org
References: <cover.1748609413.git.asml.silence@gmail.com>
 <6c51a2bb26dbb74cbe1ca0da137a77f7aaa59b6c.1748609413.git.asml.silence@gmail.com>
 <aDnzIKDV3-CZHEC0@kbusch-mbp>
 <f6d26646-6cff-4aa2-bdf6-e63695f068a1@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f6d26646-6cff-4aa2-bdf6-e63695f068a1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/25 12:21 PM, Pavel Begunkov wrote:
> On 5/30/25 19:04, Keith Busch wrote:
>> On Fri, May 30, 2025 at 01:51:58PM +0100, Pavel Begunkov wrote:
>>> +++ b/io_uring/mock_file.h
>>> @@ -0,0 +1,22 @@
>>> +#ifndef IOU_MOCK_H
>>> +#define IOU_MOCK_H
>>> +
>>> +#include <linux/types.h>
>>> +
>>> +struct io_uring_mock_probe {
>>> +    __u64        features;
>>> +    __u64        __resv[9];
>>> +};
>>> +
>>> +struct io_uring_mock_create {
>>> +    __u32        out_fd;
>>> +    __u32        flags;
>>> +    __u64        __resv[15];
>>> +};
>>> +
>>> +enum {
>>> +    IORING_MOCK_MGR_CMD_PROBE,
>>> +    IORING_MOCK_MGR_CMD_CREATE,
>>> +};
>>> +
>>> +#endif
>>
>> Shouldn't this go in a linux/uapi header instead?
> 
> Depends on whether we want distribute it to machines where it's
> not supposed to be enabled ever. I couldn't find any notion of
> debug headers in header installation, what people usually do
> in this case?

It still needs to go in uapi, as it is a user api of sorts. Otherwise
we'd need to duplicate it in test programs.

-- 
Jens Axboe

