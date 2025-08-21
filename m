Return-Path: <io-uring+bounces-9132-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 25D65B2E976
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 02:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 973CF5C2D9A
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 00:31:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE5AA3C17;
	Thu, 21 Aug 2025 00:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="A/LTY2aA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275C133F6
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 00:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755736294; cv=none; b=kprMrZSfBpjwfTnXGXCSwOzINje1s4ss/Pm9LAj4LgXoWgvBzWfgW9SPPZCp+qGDzLQ0/DliAz5eY+B25frVLYqRXkuvN2Q265zk5FspA4fjep1MRXBpDWEG8u+u0jjYL9VRPW3/3PyfyfTRjAN5499UNBl2aUuhZa9P5T8wvSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755736294; c=relaxed/simple;
	bh=4DecUNWaz7qy8IIfvspVAW8jCR9bRjJqwUSh0MCtBo4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=p7rN7H6hsyWIhocEqpzI9t1MBRifo5gH1b0rBb0Fljqnwvk9StaLod6qwoiH5+As8q6g0HIwNkN7844mxy72cf6y1xKM4h2X5xJM/Eyb1w8grh58KTItRiSU1S7tdl+WA1eCrY1pK+3sX3Tykfy1GvE7V0dawXCHzsx63B133ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=A/LTY2aA; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-323266b1d1aso355343a91.0
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 17:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755736290; x=1756341090; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1Dd9oplcLIPtFxrTGVpYxXXEA38BCQ/nUU7UBEjcn/k=;
        b=A/LTY2aAaGA4sc5uf4MvqBeD2Dwyy981c6a2dhOg0kYG31HqGa11avsb6hPzNTIotO
         EmJjimGnDWpckzTNukwSFv9HXXypWACZjqbEf0BeC4nLmYBErABO3Xiq/6qogsdhg++r
         xbRcUgqF6n82hvZBoC+/O3qSxAprIFzZ/In3w5CsbtSI18W7ZLITkZCS4zFR+0nv6Y3L
         YjWHdizkp1JahsTACcnF9PGK3d46kWyupYKbcO+g41N+WsxZw0KJt9ufWGRFDfWN8bOT
         ZdOmrLvI00+Pbrb/mTb6pDp1gfjapO0j7CvkJlWN5pyo9DjHXS3ozOwQ9QFkorZQdt2P
         BWMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755736290; x=1756341090;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Dd9oplcLIPtFxrTGVpYxXXEA38BCQ/nUU7UBEjcn/k=;
        b=iqWyFxBqwmJ/sWdUetfXEQi96OybpSaMVo6jTCmgsWGziOd+eUh/p04uq3uzLllrSj
         a2oKoY5WT1ND6RIhD4zEEQfoAW5soHrITnzC0zpyGlyarGwdR/HO8c2QfEGI6dy4SDhp
         WjLC6d5nUJC7fqojieNtTJbEilevCsopXRUSon9eHgGgEwLJzhLdsg39JmKSs3QjoeBS
         3RmysJZgxHwDBaD/aiqrtuheDFQiMh4j9q0oaZCblQ3dWa8xMR/gAFPyx0ANuK1gWj9J
         y1lbZBsB8s8MXeB1yxHCa/FHyv7qJo1dKVFSm6t99y0g9Iw3wI+7isIRt5aGcBhqcw8y
         Rmog==
X-Gm-Message-State: AOJu0YwtuieYd1JLi8zjDfoAbOu+GkgDrcl/O7b46LBPoPfQACGi+oL4
	n2fY3tIbp3tKO4kPChlqFeRCBHsW0PKW/Ea1LmZCU1xFg8G79xAUnP22veHQiDDw9c01EE+b+Rk
	Fls6P
X-Gm-Gg: ASbGncsiO+C5F7tBoaxqrzTBhxfSCp0FBGZGkGXZyWq+XN52mrNVksP8Zdr8f7Jqay9
	4EMNOqDgdrsNIr5WcX6vXlaNpiPGtY8MGnaMrKtNIrGMESXAyj27FxD+CuD5OWteMnfLEnYF6Zo
	UA/YGA7SKzd4kC+TI2aCWsZ5oZsTts4uI8aHqCKCC4rknMnPFgIeFQwTRR8+UmOdQzN+oXSM7wc
	oopFpjkiNO8ijTCHprrQQ1VVmBERq4PuHnTkVsNQ68m9GJwyUb92kTZh+Mm9wUi0rRMlVb1qXYM
	N8IIzmpztdpIJv0dP17okpMD5+N2y8qXVR43HHFowx0dddXYKXXn8HMRZOxigXXEToHS6xhXXzN
	Wo6yp3hq42whtxmFScVf1eRW+fqTF6Vs=
X-Google-Smtp-Source: AGHT+IG/R/oxE+91kw23vI2vCF819XHdyKRpCKC3IbiFubLXRyK8poVs535R9k2dHaz94shZ+K4vXA==
X-Received: by 2002:a17:90b:1d4c:b0:324:eb2d:7537 with SMTP id 98e67ed59e1d1-324ed12ac00mr1004345a91.20.1755736289680;
        Wed, 20 Aug 2025 17:31:29 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e7d54df86sm6348788b3a.108.2025.08.20.17.31.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 17:31:28 -0700 (PDT)
Message-ID: <b7d3cc3d-36af-4ba0-bdfe-e38f8188dd15@kernel.dk>
Date: Wed, 20 Aug 2025 18:31:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/kbuf: ensure ring ctx is held locked over
 io_put_kbuf()
From: Jens Axboe <axboe@kernel.dk>
To: io-uring <io-uring@vger.kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <e2f14b20-2ad4-4e59-9966-26dd6aa70f31@kernel.dk>
Content-Language: en-US
In-Reply-To: <e2f14b20-2ad4-4e59-9966-26dd6aa70f31@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/20/25 5:16 PM, Jens Axboe wrote:
> The issue_flags will tell us if this is needed or not, however a
> previous commit was a bit too eager with the cleanups and removed the
> required locking in case IO_URING_F_UNLOCKED is set in the issue_flags.

Actually, disregard that one - on closer inspection, it doesn't matter
anymore. On the legacy side, it's just being freed. For ring buffers,
they would already have been committed.

-- 
Jens Axboe


