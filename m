Return-Path: <io-uring+bounces-5478-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B4EB9F0EC0
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 15:13:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88C5F165372
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 14:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 640761E0DD6;
	Fri, 13 Dec 2024 14:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Vn/DV3wt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43CE1E0DB3
	for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 14:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734098994; cv=none; b=qZ3VKR3fXgM0wfjlDZe3UDu5cJxCSNDYCLg6xWJcv9Iqa6SZVtWPxxPU3zdIOhuNRdJmsdKkTLJxFpnzaxw5cXM2cIymCXHtlZYXgNyi/oI9P/Yb6tuNSERPu8L/qfoisS3KxA1b7WCqGwFEH8WsKxwVPerLsuA5OjO0WKQS1zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734098994; c=relaxed/simple;
	bh=Z4k204suA60/SXJuVjRwwHu5G541O7oLWa1RT9V0WnE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IklatAGS0ZZxn+KVUPiPk+qv83CK+SfXK+L9JidnlX+bWhYxEL1VZwnQFh4COk1iz+2A5icWtNjyzxuX2kl03xIp8Z44rn38s9KgO3EBpDQF78A0V0WqqALTIbOTFu1EPPBnlPR6WB15OFwBr8O3VJifhR4MmRWb//PeIa3C1ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Vn/DV3wt; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3a7d7db4d89so5490775ab.1
        for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 06:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734098990; x=1734703790; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zWSFlALklVPWBvuhYOI1ONlxQ38UgxUHGcn3LfxanEU=;
        b=Vn/DV3wtc/ogxNV6n2/+2nsw3tHZKk2PY00DIkiBRDa8Y/p1HaHpnk6g42NMHk3jbA
         4lTjdxYJwrYDr3Dcb+g0or85oQIvmCb18gZL1TDmV4yP3Bet1W252zlBiCZ2BHHKeM7i
         9cfssRgsYSGdf3OM+pDd7rSlE2R8kPY2nhKuLUaXhzMJH37MzGGMQ5E2CzLDUNvryQHb
         8YJFFqGp027b8UGhn2dWkI3G0AoSz1vO5TF71gWByjp1+UUNuPJGNvKLZiYle43JGcUi
         jrhhWU1hW1amrzd9wHOTF8SHHKRo2yihL+YVzNs2x7fMef94OQ7hRjzQHrsKqAT0XfxN
         3FsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734098990; x=1734703790;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zWSFlALklVPWBvuhYOI1ONlxQ38UgxUHGcn3LfxanEU=;
        b=hK/jOZcxEoKPGfiKktO6mUFsadguQCCwk78ImIuiB2bYHp5XO0NDiHTGtzq+kSXKrU
         YSdoKijrS/vbdiKTOTFJIKvEG41foyb8nJ6hrPNOCiqNBdLud3b2159/2yP1FTGA6lsU
         8iE8ACy7v0Sikqxi5wyq6OCo0qzSkk9L3m6Xy4cDKG/hLbgVUrjOSV3eXB6zgUhg6cz0
         pYy4MLI1gjl+ow2JbJFu6YposBc8gMMcg4xyEGCe9h+OEOUKc9Q9gN9PUA6lXBaK2JV7
         CsPOlNfKvAB+7FkqJpK8R2XUWuv+eIuisAIfc39o11dRmGXx5JP18y9vFHNQo3Rmnmpu
         COog==
X-Forwarded-Encrypted: i=1; AJvYcCVPZ7uCFvn5E/kGj1e+XSb+cvzHoRikqIUUPMxLkeW5k4tohTacVLLVtRTxfbhe3ay+hWo54g9N7g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyDyJrIV6JHLv8V48lyYeDQK6lakpRFExwFI5BpQrtGsNA0Kfhy
	OKSGnpi/8WLtA+/s9KZ6ZfwAsPBwWtEhaMFHehmd82P1BIO098qIIEDQfdF/GKo=
X-Gm-Gg: ASbGnctkE9y5B2E3GgY4JqA2hxtpxTkEAUDvw/vC9rRFdZn7Tg3mL+4UXLn2Hcc+r3a
	KhIu4lvh6fWwrHaCfDwJ2cUpriDEoXQCuf7HbMty00pUfmw6nKRYdVRPu4V+Jc4w61+vsLpplyw
	cdXl0/DyhstDYrFYv8ZmrsKkLtSH9/4ELA10nQe/Y6sDsVHe89/kOCSXbIaGFZaQmKvbLK9n299
	TuLvtb9CVQV3a2VKSeUZkB6flnz/S30NLEGaq1g+CF4GGQrbwvF
X-Google-Smtp-Source: AGHT+IFxfLsEYNSzt1ijeVP2axPSjVHTMFNfMKOLhfeGPGhogWa2tIb3yIz5mXqPGgr0csMBvr1Vfw==
X-Received: by 2002:a05:6e02:13a5:b0:3a7:e0c0:5f0d with SMTP id e9e14a558f8ab-3aff4616f35mr34733195ab.3.1734098990648;
        Fri, 13 Dec 2024 06:09:50 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a808cdcdd1sm50139615ab.0.2024.12.13.06.09.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2024 06:09:49 -0800 (PST)
Message-ID: <b4b2993e-1684-47b5-b8d2-5ade368c6b28@kernel.dk>
Date: Fri, 13 Dec 2024 07:09:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [io-uring] general protection fault in io_register_clone_buffers
To: chase xd <sl1589472800@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CADZouDRcO6QORhUUHGRBQvZ_q8nip0S+Mn4Hb61W8zi_OfmSag@mail.gmail.com>
 <85c4b3a6-559a-4f1d-bf2d-ec2db876dec7@kernel.dk>
 <CADZouDRVN0eVMNXDPX9vSGXYbOPSHRgspWz20VO4fzNeFq18ew@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADZouDRVN0eVMNXDPX9vSGXYbOPSHRgspWz20VO4fzNeFq18ew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/13/24 2:39 AM, chase xd wrote:
> Sure, I'm glad I could help. The kernel no longer crashes after this
> patch, so it seems to be the right fix.

Great, thanks for testing. The fix will go into the next 6.13-rc. And
thanks again for running syzbot against the current git tree and sending
reports, very useful!

-- 
Jens Axboe

