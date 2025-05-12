Return-Path: <io-uring+bounces-7952-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E43DFAB3A4B
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 16:18:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7155917CD0A
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 14:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CE71DE8B4;
	Mon, 12 May 2025 14:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FX1IC68h"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C476C120;
	Mon, 12 May 2025 14:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747059515; cv=none; b=NgvE47GvGXq/iv1ZoFWTjU6XiLgKSoDlX++77ORuKyy/41eL0y1BdpbdpR3x/jjyz00lfkw6t4L091LH/72EeO0tAQTS3UjGkv2CT/anckL/G2jToc0/ut2ygHDkVITjNiPiRs6qS0ahEehha3W5GE2oR5Y2uLFeED2ZICQD8B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747059515; c=relaxed/simple;
	bh=PWyCro5Arl71gS7aXicWA1gWzWOFkcIdrTuSfdRnAtc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nybOpHqBpNGSYwF7/l7pc65MC3eZ5fX9iwuYZkyfsQZ8DskG1FQibRoObQQdAbQqd581oi7WkjE3v/BQMtkcmnmIyQjMUkD0He1o5RiX9Sx62o/OHXrnPHhfNSiwC5sZmJMPlRoYZTyYQi2Pby0ThbikEDUGaCNhNbgGdRuqxYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FX1IC68h; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a0bd7f4cd5so3864145f8f.0;
        Mon, 12 May 2025 07:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747059511; x=1747664311; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qntgFFlTUmZuHaXkoN3Wz1XUBmuj23hxDCYjUFK093w=;
        b=FX1IC68h4yDejxCTn1cNQUbgIqc8be4bMBep2xHSLTidBCbsj4d7VcpKqWoYAJT5By
         BDwMRbHDeMpBAvvQ3rw8Py4D/P6mDRdppTEq7Iz21Z2HkgzCSEgFJkdo3oZpiko2dFkP
         hwQeN7TXU0z1ThRopZ6ZEmGgz7C5fs7VRncpt9+/D51CPkINzODbfMvDG0BgnfU9TSRH
         BTpsH3WY7hm9BLKFSPKvjys8sCgKf2GKUOIM5kgXgcqjJReqdRbEMIJChk1cjG22ag26
         L1GTU8RcJW6aPh7OTvGFoFqRSbv1ufA/kuKDRH0yYfx496YWvMJ7Y7SEUyVM2t3dpjm8
         Tvyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747059511; x=1747664311;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qntgFFlTUmZuHaXkoN3Wz1XUBmuj23hxDCYjUFK093w=;
        b=SB/7JDz0/06NLj1t+bH3pSVcqAYu0J8mV8i7m5SXiPaLGtwQK5QD3TdwqJMwIKey/h
         YRDxysIzrigN+S1jySvZw8LNAESTHPpuS/EcNBCT10iqy8I9mB2DOi4TFVC6T1ZWNUrV
         scKwGwlV0IP6gq9DsEGCXl5ETYiWM2Cev6JqzK5km05bvQoK8ll9/h03RVK20DXLYWia
         7fi5r3J5FXxoOl4Vz0zOMKogdKarnZi8Bf4aC4xXJcV/nJiwwz6NxUa8LMlHve94Jry7
         gKsgB1qLCmyoO4f/y6leO0N7JAVo/YtVEA/CUfxNna63rwLsALhP3hKZ03+TkqMK9mO3
         jYZw==
X-Forwarded-Encrypted: i=1; AJvYcCW5Wiy6+xPlimXp2G2yJkkYaNS9i1vl9DIPJW9ta2MEErUMe7aJV3w3MPqoqjhUqSZMzRWAtY3dZE/qcGLT@vger.kernel.org, AJvYcCX/CranLKaYR6EKLXGLeVHDwA/7tJZzMJtwPb53BnabAqcV50N9Q8rVVSCLDdto+Pkfxgxu1F5Cqw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxEhdvRsTpky7qxvleXBv72Ani1Ki27Cv4o89WfkEYTUUYYhvKF
	6scZNu6J49VU2yT5Gj7RJ8thiaerffo+xezvAFlYONkcVHKqlEPC
X-Gm-Gg: ASbGnctiV7I0BFLGjBdk5IGoSpOgBgrRf6sQ2drzRt0C5DRqfsN+iSAp4Av6NkgiJs4
	4v7Ro9MsXiMnRVImXH0PCjSSbTplM/ZOK5JEyN+52kXzNM2OiMK7YhVcavuHZdfRUE+JUgsZRtu
	cxd/vasUMfCBFiToTgZtn9XeShM3zLS90wXCZPKbTnFlFUb8iIoXMYXAEEFLCt+WVyeEj9upSoK
	xySJGr3ljuC2Q3cpk9ZsoVwVFG3yb7SKIyCR3EMAWzozhkhU+uRZqxAYZgUp0aXapptWshepm5H
	Tqt4+QLT29ju6PuGZF8nBsUOlpk6t595nfY9u3sUrrzIEx7yS8tTgXuLoSW87xlUpNKjm6Nq
X-Google-Smtp-Source: AGHT+IHnVZTjDbiztbGgUxZr7sBk1UQUuu3GZBgxDRzLralfAn92TIQzlTGKlm9O7qMKdUHTo/6s8w==
X-Received: by 2002:a5d:5983:0:b0:3a2:202:fd93 with SMTP id ffacd0b85a97d-3a202030026mr6425894f8f.29.1747059511468;
        Mon, 12 May 2025 07:18:31 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.146.237])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a2d2d3sm12751000f8f.63.2025.05.12.07.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 May 2025 07:18:30 -0700 (PDT)
Message-ID: <991ce8af-860b-41ec-9347-b5733d8259fe@gmail.com>
Date: Mon, 12 May 2025 15:19:41 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in io_buffer_select
To: Jens Axboe <axboe@kernel.dk>,
 syzbot <syzbot+6456a99dfdc2e78c4feb@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <681fed0a.050a0220.f2294.001c.GAE@google.com>
 <3460e09f-fafd-4d59-829a-341fa47d9652@gmail.com>
 <a132579a-b97c-4653-9ede-6fb25a6eb20c@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a132579a-b97c-4653-9ede-6fb25a6eb20c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/12/25 14:56, Jens Axboe wrote:
> On 5/11/25 6:22 AM, Pavel Begunkov wrote:
>> On 5/11/25 01:19, syzbot wrote:
...>> this line:
>>
>> tail = smp_load_acquire(&br->tail);
>>
>> The offset of the tail field is 0xe so bl->buf_ring should be 0. That's
>> while it has IOBL_BUF_RING flag set. Same goes for the other report. Also,
>> since it's off io_buffer_select(), which looks up the list every time we
>> can exclude the req having a dangling pointer.
> 
> It's funky for sure, the other one is regular classic provided buffers.
> Interestingly, both reports are for arm32...

The other is ring pbuf as well

io_uring_register$IORING_REGISTER_PBUF_RING(r0, 0x16, &(0x7f0000000040)={&(0x7f0000001000)={[{0x0, 0x0, 0x3, 0x700}]}, 0x1, 0x1}, 0x1)

PC is at io_ring_buffers_peek+0x24/0x258 io_uring/kbuf.c:227

Also "tail = smp_load_acquire(&br->tail);"

-- 
Pavel Begunkov


