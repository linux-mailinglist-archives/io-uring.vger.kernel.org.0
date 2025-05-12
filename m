Return-Path: <io-uring+bounces-7953-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 100B8AB3A4D
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 16:19:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91C5117494F
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 14:19:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69CA71EDA12;
	Mon, 12 May 2025 14:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="V0HIJx+o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DA61E3DE5
	for <io-uring@vger.kernel.org>; Mon, 12 May 2025 14:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747059592; cv=none; b=YrNrmXDvQVZAMLW2rNOAxg58jOnEy73PEIu425x+qHJej7wqA8TrXk+usIdb+Ar9YjVqxbal8Ahi0PoYPXclnOOq7DrVrMTgqQgi1jN+uee5ZeUZsbKcieJBH8odgAKHzhVYbAkV8rme8F1v9mJBkVZd8gLgJ5GpZOQob88gvcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747059592; c=relaxed/simple;
	bh=/xVlWZqKuwC7n6PIWdKCU268PPIEAkHfXE9MzCd/m2g=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZQ0qXAk7B+q7cjq01xsQL+nk1ZcTEddOfqbSzG75WQIp8GQXDqIG8BdrcESjTljWiStre3NT3U2nMmu43LCmFt9ADSX14gsV5SAc/gOgkNEvrVK9ZhXi7ylmoXBpUaEct2/BiGQ4TXlYBEUBvsOEsYPUf3CyXxYFj/dLCVJQC1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=V0HIJx+o; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3cfce97a3d9so32044675ab.2
        for <io-uring@vger.kernel.org>; Mon, 12 May 2025 07:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747059589; x=1747664389; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O6OcOJ/6FgSuhgxzHWj6xZeWyLtWFgFxe2wsyc5+Q0A=;
        b=V0HIJx+oCiRX5OEWbm+B1HqQJpAy7aWhgGWhRj0tzRNgY6R1M7zbkcg08DGyF+8Eh0
         C50oJGZBtsfKQz8hjjak6g2H1HOiY1xLfoYMWAVRnuE+F8iY/P1Kw4b2yCk+5CWkpdCr
         pNS08ljUkglBciIL0uskMhGpZtsv4Qz8+Z45Y3JW6MQSejW9H7bVLhYWHhggfk39t15d
         C1aCLKRNz/tdQ1O+yEzAFYmqQzR49CGZCo+Z5I/SnIL/PBDj6yEp292w4Vl4W2Zb2KIR
         pX1cQm17spKr1eVeXcUg1No68GhJN9Ss5xtH7xMMCveSd8pg1bYiHOoqCCkXNL+avl/Y
         /02Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747059589; x=1747664389;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O6OcOJ/6FgSuhgxzHWj6xZeWyLtWFgFxe2wsyc5+Q0A=;
        b=Z1yhGNMoS7WujocRc6zQKtT9NltWNWdOlIkLT3Rd+Bg7Tt/GIB7GQfEgQyx8zhLh33
         rYJFMPQhtuc/ZYVmOM+q/BMsW4uyB5lV554qEuQVY0PLIEBh7jT8OajHV8j+7c7R862T
         6UQskKJFXqRcjJoipUapJ32f2HsYD0qHuPkpW8Nzn2mc5Tlk2enO0BrHf5Q2tKSJsBOD
         QaPq+pMYoUghTiL73XTTPrVGbH7bRJf5px/SSHf1269Uo8M93ikgcfZMtVXeeDrclc5W
         V0pAX1u+nZYALtNUARHCjtHTXff5boquVw/jaPQe7sOP1r+jBjMESvPLfY5Hs7gXeh8q
         B21Q==
X-Forwarded-Encrypted: i=1; AJvYcCUNW6YHnaju0O/qu8jUSpRiy4LBMI4pvNN+1Fm9qoi4olzDh0PWv0rZgIXLB+NOzFJVYRfe2HcQbQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDD8uatSF/FRZzZNZQFx2Ssn/AybEIMQKCdMSJ6RlSsSN2Ud6R
	fcFJ6OkdB3thpdRw5X0oQWFSR1MLnr6ogq10Dzi/WOFrqPy01CUfSMtGRXVYcyB4hkuWh1PZ+61
	7
X-Gm-Gg: ASbGncsJ2nS2A1QZffi3Q+uCMKV6Y8LwhzqV4++w2jjx+XjTGPvgIKCbiqmSyVmCAg6
	+V4T7glQCN9taP4rRBsAAH3wHS8Q6lhqREs1kkAckFMHsX/4lrA5ILqx4xwflV9KMkML1v3LdHW
	Q4iloLllumreEdGOTQqSDJwg8wVIWqcHdYrLDYAx1i3dE6KS8VXSePpmmzu5/OS+eWOdEsiZlld
	0IYYdsOTeZo+h/sNB1pBP7wV5CEky0zUauOO2jIshbLpGxIn92TUEiimhb/o5s2J+6HM0JW8Q15
	9bGWJZRq/RYdP9hDC6gpyNJZdDgzE/6jzYWynXfnp/+6e8Y=
X-Google-Smtp-Source: AGHT+IGPvWdg5+wNfSbkQW+NzEXHtbm7rRfKAyhcchqyNZ71CBVwmPMD6ecBpt2ZEqC6z6FwDlNy8g==
X-Received: by 2002:a05:6e02:1988:b0:3d6:d145:3006 with SMTP id e9e14a558f8ab-3da7e213c45mr154950825ab.20.1747059588863;
        Mon, 12 May 2025 07:19:48 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fa22658ddbsm1591712173.119.2025.05.12.07.19.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 May 2025 07:19:48 -0700 (PDT)
Message-ID: <69ae835b-89b2-44bf-b51c-c365d89dbb45@kernel.dk>
Date: Mon, 12 May 2025 08:19:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in io_buffer_select
To: Pavel Begunkov <asml.silence@gmail.com>,
 syzbot <syzbot+6456a99dfdc2e78c4feb@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <681fed0a.050a0220.f2294.001c.GAE@google.com>
 <3460e09f-fafd-4d59-829a-341fa47d9652@gmail.com>
 <a132579a-b97c-4653-9ede-6fb25a6eb20c@kernel.dk>
 <991ce8af-860b-41ec-9347-b5733d8259fe@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <991ce8af-860b-41ec-9347-b5733d8259fe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/12/25 8:19 AM, Pavel Begunkov wrote:
> On 5/12/25 14:56, Jens Axboe wrote:
>> On 5/11/25 6:22 AM, Pavel Begunkov wrote:
>>> On 5/11/25 01:19, syzbot wrote:
> ...>> this line:
>>>
>>> tail = smp_load_acquire(&br->tail);
>>>
>>> The offset of the tail field is 0xe so bl->buf_ring should be 0. That's
>>> while it has IOBL_BUF_RING flag set. Same goes for the other report. Also,
>>> since it's off io_buffer_select(), which looks up the list every time we
>>> can exclude the req having a dangling pointer.
>>
>> It's funky for sure, the other one is regular classic provided buffers.
>> Interestingly, both reports are for arm32...
> 
> The other is ring pbuf as well

True yes, both are pbuf. I can't hit any of this on arm64 or x86-64, fwiw.
Which is why I thought the arm32 connection might be interesting. Not that
the arch should matter at all here, but...

-- 
Jens Axboe


