Return-Path: <io-uring+bounces-767-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EEF786816F
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 20:49:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43E2D1F24BCB
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 19:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FBF3130AC0;
	Mon, 26 Feb 2024 19:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Fo+O2Cn3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6866312EBF1
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 19:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708976973; cv=none; b=OO/qLpVQuUBJGTcsqXngP5DhQ01YvWfGftpvpJY9a44fVfxtVGIy8M3ZGxDBVozBQyuz99Sfp+0q+jGBZsCjqdsHf6vByG0W5hL+KjZmWfDnfoNHi2DE3aOORbnxZNBgVUxSaIpdA4G74SNEIjreLtTVWbdAwrIDChHSjrWGAlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708976973; c=relaxed/simple;
	bh=CkOGURIelVMlywQY8JhtNHIzqVkTIsVatazf71b4bMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t1yuHbY7g4/WUVaizpaIUbudL99wW8v6GMiOyXrVMI/G0JSXVBbOf7sYFPRzYLdZs4kLHIv6Fw2tMWkD74POgBjrg5euaUXvd4SjuvDvco+6VC32Y1LJdmG2UQ/3zAxBF7AqU2qGOKCSXlQBKUjritmhx/rVZXE4Yr5CLDLzn/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Fo+O2Cn3; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7c49c979b5dso69076839f.1
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 11:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708976969; x=1709581769; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XSQAF6UHrxCz7YTathYTOlmJ+QfbsuWuxmlmh2V64HU=;
        b=Fo+O2Cn3D4vaDdVZ2oVJg8kyqUrJs/KIFgGAbSHRa9kxWdufue1QaYmu0I84YkclDI
         l618IOTUWzLg0ldAcvo28MU7BzRPZO3oK16Gh7z0onRanhtuuug8S5u1YQ+6BU24LJfI
         K7pnxqYuzWPNxRRS1su9c5yPQh9RfbuPC+2QCun7JN8DzGdYcnrc4I+YMj4xGyeyV7MK
         CGQ1+sSSAnEXMkDca5oUTM4I+p6KT8sNvlcA7kWNgYX0QlCkzAlnUwngotpKeTfARPub
         7lomg1T6xL7OvGZXgvw1XaWvouh9sCTbR3b/pbaEYbUsq58FxeXyY0NePRhlj8l7jvHI
         odsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708976969; x=1709581769;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XSQAF6UHrxCz7YTathYTOlmJ+QfbsuWuxmlmh2V64HU=;
        b=Y860qeYjTNEbsq1DLOr6xkaO0nnAfhQe/Vq/4U/VFA7KBEVXMMgkNUJRN3GGmuPKlh
         6Bv38UT0ju/Cx51dUTsMkwlBuiIP7iKWCKOVTMJwizYZEPRjulKKvvT04g57qdpPm347
         aYNmhnpJgi3Bc+BzBQ6rOaa9raFTjjhLRYc+lpfZd2I9slzu7Gu5Ih5wq7SyO6rp+rBR
         WSsR2fkD2ErhnNveJl+JRmUc3G4gCANxWpO5xheQA134IeJVPhHanzvdlqYIN/b4Yg4B
         n4dbXgacVwgxu6bjH+ItKuhaoWUHbS/XUsOFhgiSprVPbIiIjkWRDaASWdYRIIrY5Z9S
         rljQ==
X-Gm-Message-State: AOJu0Yz8o15lAvv4IRciVU0PQoc1ClUPCnbljJFF/3g6ZOVJ8wJ9Nf+V
	DfNzqzozoOtFwz/umbjCBysrtAF9QWb20EYkjdllp2iuGIlCYrmffbkV0gOPv781+3KvFNxrhPv
	K
X-Google-Smtp-Source: AGHT+IFoTuv1AKzFvuVcawRfxshpgORMNJOtALk4ntqq3YVfvd3jDc2tF8FIW+8c7n16m5ktzFJLHg==
X-Received: by 2002:a05:6602:3413:b0:7c7:acf8:54c6 with SMTP id n19-20020a056602341300b007c7acf854c6mr6926729ioz.0.1708976969393;
        Mon, 26 Feb 2024 11:49:29 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b21-20020a02a595000000b00474267973afsm1371341jam.36.2024.02.26.11.49.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 11:49:28 -0800 (PST)
Message-ID: <2b91d7b7-b415-47d0-b919-15a48dd4fcd3@kernel.dk>
Date: Mon, 26 Feb 2024 12:49:28 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] io_uring/net: support multishot for send
Content-Language: en-US
To: Dylan Yudaken <dyudaken@gmail.com>
Cc: io-uring@vger.kernel.org
References: <20240225003941.129030-1-axboe@kernel.dk>
 <20240225003941.129030-7-axboe@kernel.dk>
 <CAO_YeojZHSnx471+HKKFgRo-yy5cv=OmEg_Ri48vMUOwegvOqg@mail.gmail.com>
 <63859888-5602-41fb-9a42-4edc6132766f@kernel.dk>
 <CAO_YeoiTpPALaeiQiCjoW1VSr6PMPDUrH5xT3dTD19=OK1ytPg@mail.gmail.com>
 <ecd796a4-e413-47d3-91c1-015b5c211ee2@kernel.dk>
 <CAO_Yeoh=r+RVJ0vSt+C7YmoxSN4uKDw=O5GUfOUYGzr0UAt7RQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAO_Yeoh=r+RVJ0vSt+C7YmoxSN4uKDw=O5GUfOUYGzr0UAt7RQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/24 12:31 PM, Dylan Yudaken wrote:
> On Mon, Feb 26, 2024 at 2:27?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>>> You do make a good point about MSG_WAITALL though - multishot send
>>> doesn't really make sense to me without MSG_WAITALL semantics. I
>>> cannot imagine a useful use case where the first buffer being
>>> partially sent will still want the second buffer sent.
>>
>> Right, and I need to tweak that. Maybe we require MSG_WAITALL, or we
>> make it implied for multishot send. Currently the code doesn't deal with
>> that.
>>
>> Maybe if MSG_WAITALL isn't set and we get a short send we don't set
>> CQE_F_MORE and we just stop. If it is set, then we go through the usual
>> retry logic. That would make it identical to MSG_WAITALL send without
>> multishot, which again is something I like in that we don't have
>> different behaviors depending on which mode we are using.
>>
> 
> It sounds like the right approach and is reasonably obvious. (I see
> this is in v4 already)

Yep, thanks for bringing attention to it! I wrote it up in the man pages
as well. At least to me, it's what I would expect to be the case.

-- 
Jens Axboe


