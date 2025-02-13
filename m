Return-Path: <io-uring+bounces-6427-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE294A351F1
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 00:03:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87D9D16F1A7
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 23:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7493622D78A;
	Thu, 13 Feb 2025 23:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C7IEZMT7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CA52753F3;
	Thu, 13 Feb 2025 23:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739487687; cv=none; b=Q9cv8wHzKDMNYiTSZGcXzEzlThiObCazudNWSreWETZmmRCqHV4yl8ivDIluLvf9zf24TFWV29eQkyGdLtKFrhIMAcmNXDgF+aNYi4XQ10+wwsPySmA0GRQJ0EIRfDrxpQgWXoGwZ65JGvPugXJXnIYgDC9pUZFsSMT6L9B2WCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739487687; c=relaxed/simple;
	bh=f+VqCUKTXO/xssWz2k13fbba3g2FgBnxzvZXnRXuEfM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MuFk8sbYKmKcaGdppeqL7/PEBrrzZxoi2wEp7ljzoigUvmgf6VLYnhRPqJDQW95EyYoJVYW9ZtGaJnbA3m0Y0vuWjU3mbLxszHpCjhA5Lh1D9FITlPVoyMiFmeF/wdT23w1DcpoBNWSnLXP7VjQBE5mELIYMeLd7sEsBJW4GDHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C7IEZMT7; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-38dd14c99c3so667551f8f.3;
        Thu, 13 Feb 2025 15:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739487684; x=1740092484; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hUsP2+hCOBdUxXA2EqnEJAQRbP8eK0Kie8gPA7PXpDs=;
        b=C7IEZMT7CCXrPyIAgDb5S7zNveDSY/zAw3Ih1wXxyTTtn5r4IcgyLu5lSKIXiDUBMB
         fWVyjvQHUYio9MUD60NVYdfps+Qg/8WQSdIAFH3Efqj2AuUi9au0+OwuqkW8s6YVO7WW
         ff23z7deCLuBxfiWRk/3bAxcieRZT0KF0tyic++SJiYDoSx/RJL2z18sA0xzXETr1Ziy
         jL0LOGcRV1c3Pl+yBcT8PIBZaGhBvA1qkjgTA5wRIPOJAV/rco6+TrRBXVF8sx47vuEA
         CW9cVFnwol3EiSvwLUyyYQY4A7Sx5PnepGinjO1WI2iim/zktgsdHYMicff68xJej8du
         sTaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739487684; x=1740092484;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hUsP2+hCOBdUxXA2EqnEJAQRbP8eK0Kie8gPA7PXpDs=;
        b=RLTx8/Xx+DVTzoz57C3pgWLtjJDAkqkK8rXS8sTRhR0NJ+TdTfOHdjUCQbv8O8Yr25
         q7rwAT25qpKhuhAIowfXYyZT38VYh8ffOiDM6KX1p8CiiXOCWmjD+jyTxPXR385UwalE
         O9nQDJqc6Huk915oh9TPHnisD9Wj87hMM5d3CYy3af2ak0paXeI2JXG2TarGHcc1XbVQ
         hzIt2IQxLYEVF8zbDyhb7cf5wJdCWwMKrrjFGhpb8VTS3qK7Sm9kanBecmkc/9rubGwp
         8M6SIG9VavvQQTepeUp2i82NQglOHIa3HTHtzEqOKlysWlw1vqAbeVG4Qf9l790dtvYl
         cY2Q==
X-Forwarded-Encrypted: i=1; AJvYcCU5emhx92bFkni5/MUP+EVCf4U23CqPe93rSmzIcw6TdRxJflyo+73c9+4MuTQy4loBIXwNJ5V3@vger.kernel.org, AJvYcCXEj7ah+cDk57xYvbwr8aB2cMH0UNnoCCr2X4zsuEFM0WVWAktYhZzgJDvHrZ547CIJ9EhDLs+OVg==@vger.kernel.org
X-Gm-Message-State: AOJu0YySql0IYGe+I4+k2MnT4x8pnSCiVKAg0znL5tzjcu+8GodEB1gB
	lejewU+F7FAhLNLW4IQf0RVSMZDmos2DQ//gfy9l25nlr+0o28eT
X-Gm-Gg: ASbGncuUtdDzOoRdL9SQLP94V71UneS3C+bjn2jVNIPe2Hro49nrJEFL1jAyY+X+on/
	tuBbvuKY4YDUQpUT+wfSsjTaGxcVAGSausIbdx5H0hIwd0NXbcdySw98ZSFcxQKXTWwuLE0fkoZ
	plaxr5WbM7XrlLE23zAHzhzQRPAtaUxjLtQS+Ut0MpAOzr6eHn10sIEgXXyPY/G3kCC0IHBRKbW
	ezr3GmItZDvm+DKSlGbxO8gczAK/6SpzDIyLWAY19cMibDDWzUy1USHouQUCn34CVJc1Sgb7o+E
	56C4PUpgDJw/gp+SnuHLqEp3Rw==
X-Google-Smtp-Source: AGHT+IGxqTAbOhE84Dw5KDxc0yjXSmm1K8s3yvP71PdF6ThtbrAzzMXfkX/gNrEhMBrFu87kEnyuPA==
X-Received: by 2002:a05:6000:1a8b:b0:38d:dffc:c133 with SMTP id ffacd0b85a97d-38dea2e8191mr11348806f8f.44.1739487683969;
        Thu, 13 Feb 2025 15:01:23 -0800 (PST)
Received: from [192.168.8.100] ([148.252.146.210])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259d58f3sm2992510f8f.73.2025.02.13.15.01.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 15:01:23 -0800 (PST)
Message-ID: <72ba3146-2b9a-4e39-a3cc-6fe0bd75041e@gmail.com>
Date: Thu, 13 Feb 2025 23:02:25 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 00/11] io_uring zero copy rx
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250212185859.3509616-1-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250212185859.3509616-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/12/25 18:57, David Wei wrote:
> This patchset contains io_uring patches needed by a new io_uring request
> implementing zero copy rx into userspace pages, eliminating a kernel to
> user copy.

Hah, I just noticed that patches are marked net-next, so just
to avoid confusion, this set should go through the io_uring tree.

-- 
Pavel Begunkov


