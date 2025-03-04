Return-Path: <io-uring+bounces-6926-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62FAEA4DA58
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 11:27:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1B7E167053
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 10:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C5DB1FECA7;
	Tue,  4 Mar 2025 10:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YmeSjW7t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445D51FC7CA
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 10:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741083921; cv=none; b=eRLZQr+dmxSAavPsfQhyVMGOPVl9UQpn/+UgkmWdGFXViCL21Cz2M1kkYWlriga7kyPcMrnovxTZffDg6BhLzpN8cpU65wtxbrBeJokuGgwtFilj4y0VrN09KqsSvWZ/W9H33Yn7a58g8D4laMJ0DxKIN9YBOFMDbrnZ4fJPo7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741083921; c=relaxed/simple;
	bh=hZrqkYIx76w2BEKqNqvfQWE3VHp193AFE07Ft7mTSsg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q/+9BqPUHW2M3gn8jlXA1QeVnFsZE22WHEvT0hykkXZLsFboWE7WkWeJDKzXgxgke6LuTkmPVG3rR7mxhP/nSWioCrOVhFW3lgaA4tELJfrl781PQi7dVaKby/MFuaTzsZk1jaoKsJdzo/J7q/ACHdPrcrGpj1T1ErWGuEFVPtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YmeSjW7t; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5e4d50ed90aso6175634a12.0
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 02:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741083918; x=1741688718; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5aQankNrdaVHTKpdrv3ndiMXj5U3MwfOOGZeznifd6Q=;
        b=YmeSjW7tdBxW9NrKZ720FrFiLoqRadnZlHBIo35MOAOIT00sHOkWVEvR7Kdq2LTPCK
         nizSJYvweTDLMOF3BLr0DvJKuGRy+pxXXdaz5TEku0WA8FLaIy8LbUAG+6gE+hq1RrhK
         bZGZTPkcGYDRMMUskR2Bkt0g3t7snCeshfyNtU2Uq8vs4QO1akTYr++KbM0znMvpO5UH
         uD/Au6evF44MzW/RWNPFQRQRKPUXWsyndxhOexO8wyhk65OTS8Ifbvf+c/Cd/ii96WR7
         KewdSAhE1PaKYCotLEjCmhAop6JsevfHdp7EprZGtugfrf1a6A1lCjxLPi4X2KVWlU6f
         tSbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741083918; x=1741688718;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5aQankNrdaVHTKpdrv3ndiMXj5U3MwfOOGZeznifd6Q=;
        b=sQY6hcVTUkCooYDPubN8XiJ2pLaNpEgOtW8/Xd0vBm0NGXkI0iqZ9dG53WvZgm0/GQ
         4s2UkCp441bgCWAcVdkJyGSLO4WDl5XqzXXQU6a8vQuFQoT+6ArsWYTfaJtDXwgp0ueb
         HJBydY+KUCVAdzOCPg9L5LDQ39WyQBqHrCAqYVLnkmCWZuREmkBbpTHOUBokCQM+A4J7
         xErlrOLEmzLEe8d5QlQBJB+tzmY7HfwJVuK1E9XUIX7wo5146F1k5I3IZmeLc3OkwbKU
         teBQr81rY8Gi6pT99VVoVdSGGgjIcQ04na3CTCJ3utJM7bfXI00lL6YkHFJ0STlMi1gm
         ZQQQ==
X-Gm-Message-State: AOJu0Ywz8UWNWUKnpFbJBS9osEDcv25vkQruktY9bL8R80JrD/sTC1ag
	J3YhCe7XwjQZVmU4UacixFaMc+RAJHMzmnFCxGgbKZJDLHXYf/+c
X-Gm-Gg: ASbGnctULN5BNdsdZcPKoKmDOxgmaxOY3inj3gs3Al/HKWw9qF1p+nrItgVyNp2u5Ap
	MaNKOw37PiMte9MswPq4adyAeNwMcn433zU5vlZcgO5BAWzu+ZjjlkkptB7SnXzeQdOq/qrYStm
	aUCVnK/A4wA40UhSUZlNQKeA6cvFCMtCFMEmLrt1vV23z9ccEXgIXl0krQIDyj+kFnDtKFGw6bZ
	TqVOdHRN4cqGNLArdihQDaG0iL4KtcTQpWNNjS5p2cEWhsSuMOAfbK49EvmyzK4qH7n9n+LDjWk
	PJ28JK9c2jT+zEbjz482KsPjIiDQk9DQVVQYi3BIqYEbti3nAPU7EAkptQr8/U2bBf5LRUWt74h
	t1w==
X-Google-Smtp-Source: AGHT+IHsOMDD10Ss/RyXiq+5Y2v2PzWYQOXpeso1d8qEgtGhjGGHG5o2JpOnLtdOwRO82IRtZ7lheQ==
X-Received: by 2002:a05:6402:84e:b0:5e4:cad2:b687 with SMTP id 4fb4d7f45d1cf-5e4d6ae4ba4mr17815353a12.13.1741083918351;
        Tue, 04 Mar 2025 02:25:18 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:87eb])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e4c43a6f2bsm7972706a12.75.2025.03.04.02.25.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 02:25:17 -0800 (PST)
Message-ID: <631ea31c-cb25-4c71-87cb-e8242c62b79a@gmail.com>
Date: Tue, 4 Mar 2025 10:26:28 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] Add support for vectored registered buffers
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, Andres Freund <andres@anarazel.de>
References: <cover.1741014186.git.asml.silence@gmail.com>
 <CADUfDZqrXsdnwT=W3HqaVUeegY0jee4G4YztancBfsNBXMKWOg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZqrXsdnwT=W3HqaVUeegY0jee4G4YztancBfsNBXMKWOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/4/25 00:34, Caleb Sander Mateos wrote:
> On Mon, Mar 3, 2025 at 7:51 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> Add registered buffer support for vectored io_uring operations. That
>> allows to pass an iovec, all entries of which must belong to and
>> point into the same registered buffer specified by sqe->buf_index.
>>
>> The series covers zerocopy sendmsg and reads / writes. Reads and
>> writes are implemented as new opcodes, while zerocopy sendmsg
>> reuses IORING_RECVSEND_FIXED_BUF for the api.
>>
>> Results are aligned to what one would expect from registered buffers:
>>
>> t/io_uring + nullblk, single segment 16K:
>>    34 -> 46 GiB/s
>> examples/send-zerocopy.c default send size (64KB):
>>    82558 -> 123855 MB/s
> 
> Thanks for implementing this, it's great to be able to combine these 2
> optimizations! Though I suspect many applications will want to perform
> vectorized I/O using iovecs that come from different registered
> buffers (e.g. separate header and data allocations). Perhaps a future
> improvement could allow a list of buffer indices to be specified.

That's the design decision made, otherwise the API is becoming a mess
as well as handling. The user has to be smart and keep a small number
of large registered buffers and potentially growing them, which is a
good thing regardless of this feature.

-- 
Pavel Begunkov


