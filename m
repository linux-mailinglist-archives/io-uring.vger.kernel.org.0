Return-Path: <io-uring+bounces-3458-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83F1C993A12
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 00:20:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48013285417
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 22:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7C618C91B;
	Mon,  7 Oct 2024 22:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="k2ljK1qR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01F03FB9F
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 22:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728339640; cv=none; b=pI/X3MPYCs8+lhiEsgxldeldSGH+zZ4BIZrlpfwH1LXMV8SS4NXKIHwBc0Hc/ZKbWxhnOvc147EfjLNKbQRYISC2dGtN2avvDmQR4kJKf2nUefzGq/oVJBhap7XHBO6BhWivCwWIlLf2nJWWGbPq53+Bkq/A29xUI70grHVu+Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728339640; c=relaxed/simple;
	bh=kONiedfm7nbqc7vigAL0H85kxZfK+hPd9pfj5JlFH8A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LaCTRH2mogdRoqXWSvMel1AgRiYHTCUEXdMBy5GyOpOWMTn8dHqwSAXcBMQW9QQsBrgXecByT9JKC2zRjtUVnNSXZzbywaJ8SuTl0Jz6fPQYb35BYiHe6cjlKGG2W+pLDofGNxsy53MYfKit6qqP4SwNLSQZZ+q74lIfL+tAAgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=k2ljK1qR; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-71e01207fa0so1243818b3a.3
        for <io-uring@vger.kernel.org>; Mon, 07 Oct 2024 15:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728339639; x=1728944439; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kONiedfm7nbqc7vigAL0H85kxZfK+hPd9pfj5JlFH8A=;
        b=k2ljK1qRzy6gtVOb3D9wKisfVo4POUVnMRfeRUNWyxYA8mtgHXhWCauJQ6V0nchK6x
         gwwGYza8FZpiNvhwBncQW9NR77QF9Y+VpvXObRedPZDa35E45NrRTOHlXhNKs0eyfveR
         DU5j3fG2Qj6kMcB9amhRiJbBnQU7Hbu+QEG/SI9+L0/CW5ct9GhgR2K4WeDZhQXm7vLC
         FmE4EmKMiOdUh5ucXcGShv9dCA57P/jyFDSNyWc0jHIzjGnFu8wB/Nm1EAKPReNK4ttx
         x8MGe7VEFR0W8zkdRrdACI7X4rV+oXHFVAz6nhaPiMD5zLm8s1QxtjBZtInay2SPyOt+
         Ilwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728339639; x=1728944439;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kONiedfm7nbqc7vigAL0H85kxZfK+hPd9pfj5JlFH8A=;
        b=BO06E+y8CErN8FThZAKB4R1H96f/B7bPocci80rg9mnGZhomrJk+Q3YB0sBwK253f8
         feQj2+c09jpsEpaSCEO2zpq2qR5WeAlycLO8Fbts42no3m0SUT6y89Ibmtvdt2PoPwZz
         u0baPCObC6wKzCOId8r6KPCsl3JLRelwfX/WJWqw1hX9u9jv6xpDKLIj1GNV2A1oTTky
         FZ7rkz2xbtqaLuQlV6ZEMhnSrSi+U0NUJIatuami827GZb/HKehbM6Zg9aJyLSzDNmuo
         uARDeVIf+zTtPcy3oqe3TAWHyUwihX2cJnITQR1CNjgOysNRSNGjYPAnedRqWxJ/gllU
         5h/Q==
X-Gm-Message-State: AOJu0YyM/OlhS1I+PXJJAw4/KWmAoKk6TBZ1035WDMpUCLShUssLczcR
	9YQKnDuuvlLBpZsYlcRagrr2Ff9U3/K5IwpPayQ+YWOVwvbdXbi/oKgpXeV/5mmcjpvPb38r1aw
	a520=
X-Google-Smtp-Source: AGHT+IHLERWGRZ5Z4ELyB8U/zT9nKxCdsc46PbEhiwN18zexSUm8WmIDV6fOoPO20En1qusM0LMc0Q==
X-Received: by 2002:a05:6a00:2d10:b0:71e:9a8:2b9a with SMTP id d2e1a72fcca58-71e09a82ddfmr5137263b3a.23.1728339639196;
        Mon, 07 Oct 2024 15:20:39 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::4:f136])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0cbc48asm4900573b3a.21.2024.10.07.15.20.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 15:20:38 -0700 (PDT)
Message-ID: <0ce58780-d7e4-4253-ae76-934586179684@davidwei.uk>
Date: Mon, 7 Oct 2024 15:20:36 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
Content-Language: en-GB
To: io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <20241007221603.1703699-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-10-07 15:15, David Wei wrote:
> This patchset adds support for zero copy rx into userspace pages using
> io_uring, eliminating a kernel to user copy.

Sorry, I didn't know that versioning do not get reset when going from
RFC -> non-RFC. This patchset should read v5. I'll fix this in the next
version.

