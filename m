Return-Path: <io-uring+bounces-8276-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF7CFAD0A74
	for <lists+io-uring@lfdr.de>; Sat,  7 Jun 2025 01:53:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CD451706AF
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 23:53:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7FA3214209;
	Fri,  6 Jun 2025 23:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oWa31asU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB30212FBE
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 23:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254015; cv=none; b=e6UyXwoZPKEG3bHUoli3AI5qkwn7xawR1iAfN6oMmqL9zwrDm+oWmH5yXWp3xFuj9hLN1dkawpn9j6HXBsxATZXC77b9x6LO3AT4Msu0h64c4rpeQjdX5axGqR2UBrbbRcQsPxUsSk1LpeC/TuDRTTbiE88pjQH8SKgka9cDCao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254015; c=relaxed/simple;
	bh=C69mEK9f5dGd363mZi85UBHC2hDP+QnavgYHflDcHPQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aANE6mCDkzO7t+EBoNkD+Sn/e0YUdR6lA7xyKaVglpK1MZvuN6LMUy1vRcRZuVffTAiwgSlT3fLC84OhlUH11QiN0BdiFuycC8NwMLme+aU4tua04flsSYZGfZeoMDkz/T1jhSSgBy93A993i8Zs7bR71lpt1nTShD3HFibV1ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oWa31asU; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-86d02c3aab0so73104639f.2
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 16:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749254011; x=1749858811; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/ikfBwYjTHxQuR+mYffXyjGfFCymaw2xCBrc7hB8EVw=;
        b=oWa31asUXOO+jkm1UnUHcaCn40pFF+JpfIeP5L0ZQ5+Z/6+/xaqY6/jQdEwm5VgSNL
         /IzeQ9q+mC8yuMBii4NYST+S/dokWVxCXMb7VEMczmt9vb1/LxC6ArmUvU6ZGvxKt/iM
         JoD0xOkl6PFbosQPYRPkqNzqdr8Wjsm8TOlbN7ugdcpj9lKFepPx4h7JWWU6lzIWvG7V
         7k/Ffw3Uf+IxXRrzAZ/4Gw3Gmq6M1zV2pUMm1Jls7Iry6QdgQdOpHILiycmaW3tSSymz
         /NIaLrkUNUDlSVVFbpi3skZscrjmQNAuqo4pvhZAJUUWFLmmEtCQu1JkJ739CWHysXO4
         Y9TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254011; x=1749858811;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ikfBwYjTHxQuR+mYffXyjGfFCymaw2xCBrc7hB8EVw=;
        b=wFD4QDLL8eKxlKjJMwmvDr6T4YiPRaz6pWBUj8Hz1tDkz9LggPHgOXJauDcCBG5XiT
         5niW+k5w7/M6v4yAZPfYpcZsBMOaJmfERZspH2SGcGg2+hQ+zWBidRLn9WzNVb8JxQ+M
         b6jsJYJHuQHfdlrkRiLmH7Fza8xIWGiAkfjGA8Zm9TUM2dKUZnqPV4w9WpnO00GQFlHM
         7wXZ8MXSTJSFqYhGCSXadloU1vROPz4+ae8XfTFh77QVN6BN8vEitiIztadIN82fJb96
         HAEnFvZraTzKd1wmiRWYzKo7pVq2ot0fUMf9SMYC3w9AoYHTTEl74QMu9fZcwERRqCUo
         5fDQ==
X-Gm-Message-State: AOJu0Yz8A7eKJc548t1XG6iFI7P2hI9PiQdE+QYohZAepgS8Ykejz/Yk
	z6ESuS5Fq8BzhJdt7RYy9a+O8q9Z58jZD1A+ym7OtmmC7DUrgCDl9O8+vbLsmMmibDRCNcoO0AH
	vzp1O
X-Gm-Gg: ASbGncvWeT6Gp9dKn+ikT1GRjuMD+fEzmByGb67ffYQg1J0PFDp5ezHtm84KG7oQP6O
	X487TJJ+K3QHk5FB5pa4xJe4JVPzhQtd72gqOsQsu+Rg+pN9qfLVYUSkcGqGdnFgnPUMAv8mQn7
	Y8+x7FHG/xROI2IVJvl/djfMp6alUqryWXiYGlS4V0JXUKmn7tNkdnupzkYGqeFFpdNjOzGkJF4
	GJ5LOZSStzfAI+YVO5c71YBvaXNykvV4D8aCSn9FSC9PnEQu60KbWpzVYR/GbYMDab2lZONQQoL
	smzuJGDKkh122JI6mjXdqlT2piyaqZJX146QXsZjbsqa7KP3
X-Google-Smtp-Source: AGHT+IFuLBNhuRnIj/H2p1R5jS2j0+5TT4LMUQmgS8hZfMKh8uKV5MHMhHumBePAcOISjzSaSH3RFw==
X-Received: by 2002:a92:cdad:0:b0:3d9:6cb6:fa52 with SMTP id e9e14a558f8ab-3ddce415686mr68280245ab.12.1749254011377;
        Fri, 06 Jun 2025 16:53:31 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-500df3f6896sm674739173.3.2025.06.06.16.53.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 16:53:30 -0700 (PDT)
Message-ID: <3b0498f7-f265-4b97-9df4-55f4d1a9b883@kernel.dk>
Date: Fri, 6 Jun 2025 17:53:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring/uring_cmd: implement ->sqe_copy() to avoid
 unnecessary copies
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <20250605194728.145287-1-axboe@kernel.dk>
 <20250605194728.145287-5-axboe@kernel.dk>
 <CADUfDZrXup5LN250NS9BbSCC5Mq5ek82zJ89W2KyqUKaWNwpTw@mail.gmail.com>
 <98a6907f-b9e7-4331-83cc-855a64bb1eaf@kernel.dk>
 <16075197-2561-4eef-bf4a-c50734021267@kernel.dk>
 <CADUfDZrzsUAVEmEYGFbO7fOy3F07SyyVeXj80p+tPgZKUnTKMw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZrzsUAVEmEYGFbO7fOy3F07SyyVeXj80p+tPgZKUnTKMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/25 4:09 PM, Caleb Sander Mateos wrote:
> On Fri, Jun 6, 2025 at 3:08?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 6/6/25 3:05 PM, Jens Axboe wrote:
>>>> Is it necessary to pass the sqe? Wouldn't it always be ioucmd->sqe?
>>>> Presumably any other opcode that implements ->sqe_copy() would also
>>>> have the sqe pointer stashed somewhere. Seems like it would simplify
>>>> the core io_uring code a bit not to have to thread the sqe through
>>>> several function calls.
>>>
>>> It's not necessary, but I would rather get rid of needing to store an
>>> SQE since that is a bit iffy than get rid of passing the SQE. When it
>>> comes from the core, you _know_ it's going to be valid. I feel like you
>>> need a fairly intimate understanding of io_uring issue flow to make any
>>> judgement on this, if you were adding an opcode and defining this type
>>> of handler.
>>
>> Actually did go that route anyway, because we still need to stash it.
>> And if we do go that route, then we can keep all the checking in the
>> core and leave the handler just a basic copy with a void return. Which
>> is pretty nice.
>>
>> Anyway, checkout v3 and see what you thing.
> 
> From a quick glance it looks good to me. Let me give it a more
> detailed look with a fresh pair of eyes.

Thanks, that'd be great. Ignore the commit message for patch 4,
I did update it but didn't amend before sending out... The one
in the git tree is accurate.

-- 
Jens Axboe

