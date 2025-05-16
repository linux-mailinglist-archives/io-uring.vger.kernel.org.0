Return-Path: <io-uring+bounces-7993-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D409ABA0D0
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 18:33:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61BEE9E8305
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 16:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9910C18C937;
	Fri, 16 May 2025 16:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KXVG5o7N"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CE786359
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747413226; cv=none; b=mw7aS3hNZW7tVYhkjixA7d/VBEeCJgYbDflYOleHeJDFXGZGAyOruWbuZ0f/8TiK9IFdzeLEdl4zNanwtFrOD0hRt7TbNZ0Z8AT1Cs02A2SZaHdRscbm22wH5Ml8CP+GfOLXUY/eTLmgbbJQwzB7/JVpKXhPeDb5ep5w5WKcbTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747413226; c=relaxed/simple;
	bh=fJIOA07UH7EIDeAfCzFrFSMJcgCeJ/wH60EGlWSqEIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IiUhh0PGey+0E0QuodpRhq/o4PvNWnWxuOt4nShSeFYpsn/yq2J63YD2BUEjlViaonnVzDjboZQFp9OBaOJj2UIgmu0x/gWA36DY9v+8S+21eRL6d7XbRuHHtjSwj5h/IB6OLSmlXgT8Uc4hSujE8we1fB8a7rn5nHTERMwJ7NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KXVG5o7N; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-8647a81e683so61546339f.1
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 09:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747413222; x=1748018022; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vNJ/1ZARfPHdrVIjXH7JzgjCQlLIUrbJjua2vcWDZSo=;
        b=KXVG5o7NOztbx6qGUSdbAAD78B0HceO1u75MLA3XRi52b0UOCW5XYTgR11Ls+KEYJ4
         t4+4Jn24D9Gu3d43dqPdlWanmyerfMdCSYudOhkE21KVjvwvsu24xn76wv7Ofdn1hQB0
         8oLVi6LswPzzU3uqKA21kENwD7x5lcOTssci+89nIJFE4yYql2cFfnBg++qoi7a9+oSM
         yhErJ8uHbeRNHuytsTZohP7bXTT7/ohWgeEwybgYjtQtjuvtDvXbae+o7Qj7lgzq46ia
         LIWBiDAxPKvqd6r+URSEJG7Pe6bk7fSubqDue55wFoDnpqoblmFGrN/yITSNhu1dOfvQ
         RbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747413222; x=1748018022;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vNJ/1ZARfPHdrVIjXH7JzgjCQlLIUrbJjua2vcWDZSo=;
        b=A3L1AFGGWm9kwV0If6aaeP5dyjemeAmaWEGYHkRU0juyMfc+9/7tQjuuS28BPLU8bJ
         EuCbrr5XLmCRF/GYiGlm/zwwHLIy6ylH9BcMycqeAqP9T9oU23umkjpxDOwRqJ0F51H4
         eYyFWkiUbEaBTB2lV7Az5oLmQj7AigUjDjSP/vWSCjXYD6BI/ftmOyZujuh+Z21bN3AL
         tMaH3ffZzZa5JVbo9BAa70dXMA29CHWhGhZ3cQgLdAYGD0BePXhB9EWlIEMEXn81Deoj
         nlkX4CJEPkmQL/FDdfKP7Sd4uGQJ4QDKLV7VEkqehvviEjE6roZlh2m33RawOL7sqcCT
         PC4w==
X-Gm-Message-State: AOJu0Yy82HAbU/5R809Yj/BGFyZXclTgClTcOZEAqjDeRxGcU9t22Yny
	au2q1VE7jMDTZLeRWzzN74rbss4b/2Ct0VGUOJdtbSRrhBba8vSfQU1iSfLmS7DLHeI=
X-Gm-Gg: ASbGnctBdo+k1q8a7Q3WXcPPA/4sDwEVrby/CXFAeoWJSykW56ruwvcl9LPOyad0l6N
	z7CZxG7JktijGtJZPTMlH3QH7nWa9QtcWqPxmWEyI/0TUC7RXh5BlQVoNIqz7hAfMubqZw2d/FW
	wXgWeL/gL7bq/0t1yrL01RDPEvm4ya+iTfKdhCzTW4RrhYSpcPy6/kd+ZtVrwZFjFFSRmZqlrBs
	rxDBU5lPLZfIstM3mNd2Hlb2fQ/JhSd8n6+cLUgxy78JPZoT/sUs5lIierW/CeHGoqnkmwtYcG1
	8qmow7auiyXAEReLdhk8pdoLV67LZ8kLu30iotGmjB/gRtA=
X-Google-Smtp-Source: AGHT+IGu/6uFaVyO4wSlaP5W8EXMUQp8EzY9kcYhLV3iPLFE/QDo6AFWmkyvv7XaaNsGD9eBznWBvQ==
X-Received: by 2002:a05:6602:4c0a:b0:86a:246:ee96 with SMTP id ca18e2360f4ac-86a232298b6mr608388439f.11.1747413222203;
        Fri, 16 May 2025 09:33:42 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbd17aa855sm289305173.4.2025.05.16.09.33.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 09:33:41 -0700 (PDT)
Message-ID: <9bf4b0e9-df89-4f8d-8562-7122e57a47b0@kernel.dk>
Date: Fri, 16 May 2025 10:33:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring: split alloc and add of overflow
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
References: <20250516161452.395927-1-axboe@kernel.dk>
 <20250516161452.395927-2-axboe@kernel.dk>
 <CADUfDZrp-Qq93g5uZn4_=amFhzF=j2Yk0MqJ5zqi_qYC4ZdhUQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <CADUfDZrp-Qq93g5uZn4_=amFhzF=j2Yk0MqJ5zqi_qYC4ZdhUQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/16/25 10:31 AM, Caleb Sander Mateos wrote:
>> @@ -1442,10 +1462,11 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>>                     unlikely(!io_fill_cqe_req(ctx, req))) {
>>                         if (ctx->lockless_cq) {
>>                                 spin_lock(&ctx->completion_lock);
>> -                               io_req_cqe_overflow(req);
>> +                               io_req_cqe_overflow(req, GFP_ATOMIC);
>>                                 spin_unlock(&ctx->completion_lock);
>>                         } else {
>> -                               io_req_cqe_overflow(req);
>> +                               gfp_t gfp = ctx->lockless_cq ? GFP_KERNEL : GFP_ATOMIC;
> 
> This is in the else case of an if (ctx->lockless_cq). Isn't
> ctx->lockless_cq known to be false?

Indeed! Actually this part needs to be split too. I'll redo this one.

-- 
Jens Axboe

