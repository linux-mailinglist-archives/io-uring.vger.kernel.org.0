Return-Path: <io-uring+bounces-7249-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 19432A71CA6
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 18:05:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C342189360E
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 17:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BF6D1F63F9;
	Wed, 26 Mar 2025 17:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="d+O+IyA+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DCB1BC9E2
	for <io-uring@vger.kernel.org>; Wed, 26 Mar 2025 17:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743008710; cv=none; b=X4eH4XSrPcy8JYOibDaDgD6tHuTVU6kexe0EKr7JrlAPWhlVzk2l2X3+1GnYz3DSTxxI8TxHmyHh9BVxeW7cUQPMoZqtGvYshClmXUzRisIqxWghM1k50uzuTrezKLP0JYQBjSWxbQDipWB3aCfKRODW70qXi/RXnnlJpQOjrGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743008710; c=relaxed/simple;
	bh=bJM/U2KIErHcbrpoSbkqV/L6KHKuSPxeK7SWuXRVQU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RZ+0uA0aXpUtkFMN84ZtNbl4t1E+AeckKo93xs4csh5lAT9CeoPFkbK9Pd44RTMlEQXjpsO/hNbPJSTnMYEdmbOBQQx13n0KssFKwC3gRLUp8e4fa7uB9m5M0qmcoz0A4Fg+xbd+G2O4csqu1E6OI8M47EarKbK3vQzLpwHdAMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=d+O+IyA+; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6e41e18137bso81016d6.1
        for <io-uring@vger.kernel.org>; Wed, 26 Mar 2025 10:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743008705; x=1743613505; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I73PY1mjkb5IFUpjGFh5jx5We9m1IBveOeOAn7WEGu8=;
        b=d+O+IyA+e5wMywypk4Gc+nNx1qvjR03WDOx342LH69RLxG1ES8KxU3MSjfvxuP+zEm
         C+m+ncxydXr6koOoJcgDmABSiLIEXTgK6rojZSPEuoPjknsQmenbwX+qDncIIzdhOSXY
         3M3GBSD+nq1+U5zBSxQB2e2OqFyUyG9nJWRHmiOF7pUbOFEGZMw0Jv/LgawTv8fSBiGv
         K+ZZHiKJam2uQh8O7HZph3XdL9i8xqmYM55xM24dWkrrAA3uOgPInCI2ihiSuYG/A2kW
         1iYmlmNRyF+bhtioWIgVQf1p/DE9kN4mp2GzbDNJfNgQUSgjaFAj43Bb3ErrFDBqQ/V4
         I+/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743008705; x=1743613505;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I73PY1mjkb5IFUpjGFh5jx5We9m1IBveOeOAn7WEGu8=;
        b=ih9L1oW3N9ZBhgqVoYdocqQ2Dd4TI4T3rbdEDo22p+i4/U5D/ucPXMKm8kofhnPYxc
         C1o9yoXtYL4piQeTnOl1884guVJIRI3K+JFrS1Im2379vMJJahRZFOT7+ZL2XM+lCrZn
         UMRFd+saku1iUW2PyweZL7HJoc1B3TKb89X+kSSv4HTSSMFSzqOFSbm5RPMSS0/YAx/+
         PWJrXKaCwMyynidV9yW7fAKlGgGkhDMChQRVlS7bNGtneGr5dZ3p71Qsx8EVL5fq9tk6
         tb+NNFmbIDKVmvvknw3BapFGw2Gqk+D01yWz5/HDOelldXcTgOhHJYA692Yux9kWzKk3
         c40A==
X-Gm-Message-State: AOJu0Yx1BYG3sSfFG/ki3U0rLI+fspinLgP6wXOGQX6tQ8ILgv1qVI98
	lzLw2OqtINEOC0rMN64JF1yMC7vGDOYTPNEaxaG4Yh8xKfCzM0oGyMhy7mdr1vU=
X-Gm-Gg: ASbGncshrt1WT5vH39Ovx7TUfx2RcvQiznWcGVNVwYQno4FxRm5bl/9ccjiltlLA61l
	QscpZdjCBjUmBpKFo3co3jOzgSCkyuDifL45u3jt+E2n52UTNo+kPhkTuBTSo7ojZhX6d+5RjOX
	DRRA3lDtki0hoKdW5U9ntZYu1wZUKY3rWlKInE4BJI7kKsbb0zMy4QBKu2CmBaj584lnfhj4zT1
	Dg28rbYDh8UYxfB3N8vF8jwdGWbqAsSfzV3oZpnTqQ9gdiYHxaENCj7nVmwiC3qRJ2f/5BoiGXI
	Of0RhlXk60spPrVuwwZzX+X9L2ABqGyACEeAzg4=
X-Google-Smtp-Source: AGHT+IHu+Vsyz4EOtnj1TNh8JqfFnw1qNqrb8unnl7fgTesbDtUyjffDpeAqu2lE66Oahnty+UNLlA==
X-Received: by 2002:a05:6214:410f:b0:6e8:f166:b19e with SMTP id 6a1803df08f44-6ed23898ecbmr3304216d6.17.1743008704882;
        Wed, 26 Mar 2025 10:05:04 -0700 (PDT)
Received: from [172.20.6.96] ([99.209.85.25])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6eb3ef344fasm69659916d6.57.2025.03.26.10.05.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Mar 2025 10:05:04 -0700 (PDT)
Message-ID: <9770387a-9726-4905-9166-253ec02507ff@kernel.dk>
Date: Wed, 26 Mar 2025 11:05:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/net: use REQ_F_IMPORT_BUFFER for send_zc
To: Caleb Sander Mateos <csander@purestorage.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250325143943.1226467-1-csander@purestorage.com>
 <5b6b20d7-5230-4d30-b457-4d69c1bb51d4@gmail.com>
 <CADUfDZoo11vZ3Yq-6y4zZNNoyE+YnSSa267hOxQCvH66vM1njQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZoo11vZ3Yq-6y4zZNNoyE+YnSSa267hOxQCvH66vM1njQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/26/25 11:01 AM, Caleb Sander Mateos wrote:
> On Wed, Mar 26, 2025 at 2:59?AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 3/25/25 14:39, Caleb Sander Mateos wrote:
>>> Instead of a bool field in struct io_sr_msg, use REQ_F_IMPORT_BUFFER to
>>> track whether io_send_zc() has already imported the buffer. This flag
>>> already serves a similar purpose for sendmsg_zc and {read,write}v_fixed.
>>
>> It didn't apply cleanly to for-6.15/io_uring-reg-vec, but otherwise
>> looks good.
> 
> It looks like Jens dropped my earlier patch "io_uring/net: import
> send_zc fixed buffer before going async":
> https://lore.kernel.org/io-uring/20250321184819.3847386-3-csander@purestorage.com/T/#u
> .
> Not sure why it was dropped. But this change is independent, I can
> rebase it onto the current for-6.15/io_uring-reg-vec if desired.

Mostly just around the discussion on what we want to guarantee here. I
do think that patch makes sense, fwiw!

>> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> Thanks!
> 
>>
>>> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
>>> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Note for the future, it's a good practice to put your sob last.
> 
> Okay. Is the preferred order of tags documented anywhere? I ran
> scripts/checkpatch.pl, but it didn't have any complaints.

I think that one is minor, as it's not reordering with another SOB. Eg
mine would go below it anyway. But you definitely should always include
a list of what changed since v1 when posting v2, and so forth. Otherwise
you need to find the old patch and compare them to see what changed.
Just put it below the --- line in the email.

-- 
Jens Axboe

