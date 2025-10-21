Return-Path: <io-uring+bounces-10094-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C68DDBF901F
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 00:09:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B3F044E2570
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 22:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4781D799D;
	Tue, 21 Oct 2025 22:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sXdiQ+6p"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372A328031D
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 22:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761084553; cv=none; b=hKBJFkX98EqZYLMzXCG3Zf002dxSuC4p+UMDOzCJwC/RXyahhXzO9t3fRa/N32viv2tFly2ZAQQGsu1gUmj20Hv8yvflQkfzadPUq+MalEVsBnZbKO8gdkOer1zNdTqk4FYOde29miAiH6ScxsEG22xcN8J/T7wBzUpeijKgSOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761084553; c=relaxed/simple;
	bh=hQWk2KFZvcv5cHl1OJaB0qB8wMB1ZR4uTzWpCcVFIIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DicZ53qTAivdEUdqsoVhe/zCJ3deED+SBggNDjSm1H67PEhatm5Eiq+Gczs+WkZ5tzWbH/IvWL31kLHOItb82RCvqS+0TjzHr9T8sdflkdhjifEQxofeJRlWZbSkLNQsmyEuUsEAnaeGdOSg1hsEqBo6PGUFmVb1g095Q/T6rhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sXdiQ+6p; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-92aee734585so271007739f.3
        for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 15:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761084550; x=1761689350; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kkiagy7ZyGWau2xMqms1oiD3LF5PDf2N6kEfuIJ8VhI=;
        b=sXdiQ+6p9GLZ8uq6bamxdbY/NBjzPCzd0HZDi4gXc7xyxj3e53ZUziItqkddFFfqKK
         nFKWhr+JS1+ahRk9SxMGyyboJIfzMlD7m6A1ktpYGw4Xo1IU+JcKeLiGkspsUdeSlkjC
         o8aJuuqaYvGPCX/q6efqdTpqDK6kHMCQqCJKcQfDhy1RUxY/rJFfr5kKXnCKzqQBBfBK
         wNJEa3n4laYp3ol4LrEehgjtyqW4+Mgqs2AXPDxRzVGmWjg0LMjFxJh4h0FGXNyVwrHf
         R2OuTfXMdxbQwwPEvgwQAwHBhKKaOAatUfBq4N6fKWyxZPhZKfpRQchEbLwrpZUpYZdV
         UXzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761084550; x=1761689350;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kkiagy7ZyGWau2xMqms1oiD3LF5PDf2N6kEfuIJ8VhI=;
        b=IKmYtFZGtkPHrX9Kk1RmIt1MEeAJLKwjMoGC+0Dsauj20ULG0NjWUxtlMcgU6yo27t
         +x1nUfC43jqnZvu6iW3dfKLv2b3JKZVDj9j/9bHhR42bJXlIAzLue9z1aonZfCMgPum/
         WpY34GohWvPWApSOoGkQPRFHmG9DQLV/D3cXMk3RPLNuVkEp2KlrFH3yuHgM7xSH8jbb
         Fjo1irEbPLNNBENKRNbm4YdTFA1x3XzI66H5MdF3iR1EeVzcHrm/wYudChnwDUxuJxiU
         IMe7EJ1ImuVbQCwx8mGdeI3xkcsk+qvaxXhv3gU1Sem4rlJ4DYtjIVUHsOFVcZ6PW0g0
         9PWw==
X-Forwarded-Encrypted: i=1; AJvYcCWqWdBT5UI1+ruKyuqK2tgp3Nfpv3UdtpmLeOqh4MTPPEiBZ2kvhHY0UTbStBGbwgmCV45ZZk3mvA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc6LVoLo6fv5iDIJ/ap4rEGbAjvOppb04ghLRvVaWu6z4qWkgi
	gZnXfIPjrHz/etJyvv7wRLrWCD2BgG3X7DsR8RWOGYeTClmdz5Lc2uoh24+xYaTX4UU=
X-Gm-Gg: ASbGncvZwy+8Ex0Tynf1uDhYDFkIz/NAqVqkyeVSu2KqDVNvvgVmghDjSXt75lVfjh6
	0n1W1kYhVU1YWz/HoiaPqWRcjUUd3sqpYnzEMRmtzxnOEurc+P2eRI7H6i42DGAWeM0flHPm46j
	zDpTDvlUpyFwTEx0ajX0wXRpkDmLTSuZ4heUSNsu1CFp6yz4FkAzpNZ9Aw3iKpVKclsx3vb1RSJ
	OsmoT1AVfUOFVk0DWFPaQ+7Cphm4C2DzZxHQYsjE6pVlKrqqokHLYHTaazt5+jd3T/QhFwmOg5+
	W0nBFCnOEAu7rRdu1BWd2ndOvTnOne9sTupP8ginyd5pjRUBRJ/Uv3GNTrEUz00Oyg0wcnVB8oJ
	SIeAspVzh9k6FrFAsy3xhGcnIq5uTusI4/TKhmIqUpe3f6oRBefZ5INM7n9VRsVk7nC6yBANl5D
	hE3+P7RrBg
X-Google-Smtp-Source: AGHT+IHmL8dGaaCJmRQtjZSHh/lLzCz4NZWqD74lllZ3M5GCzDRjH4BhEYdkEf03uS5/z0TTF5S4vA==
X-Received: by 2002:a05:6e02:12e9:b0:430:9104:3894 with SMTP id e9e14a558f8ab-430c5318de7mr255907145ab.30.1761084550115;
        Tue, 21 Oct 2025 15:09:10 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-430d07a8341sm47419245ab.26.2025.10.21.15.09.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 15:09:09 -0700 (PDT)
Message-ID: <5bd2c43e-4b02-4cdb-90e1-ee5555600cb3@kernel.dk>
Date: Tue, 21 Oct 2025 16:09:08 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv5 4/4] Add mixed sqe test for uring commands
To: Keith Busch <kbusch@meta.com>, csander@purestorage.com,
 io-uring <io-uring@vger.kernel.org>
Cc: Keith Busch <kbusch@kernel.org>
References: <20251021213329.784558-1-kbusch@meta.com>
 <20251021213329.784558-5-kbusch@meta.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20251021213329.784558-5-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> +	ret = io_uring_wait_cqe(ring, &cqe);
> +	if (ret < 0)
> +		fprintf(stderr, "wait completion %d\n", ret);
> +	else if (cqe->user_data != seq)
> +		fprintf(stderr, "Unexpected user_data: %ld\n", (long) cqe->user_data);
> +	else {
> +		io_uring_cqe_seen(ring, cqe);
> +		return T_EXIT_PASS;
> +	}
> +	return T_EXIT_FAIL;

All braces if one has braces. In a few different spots.

Outside of those little nits and the previous comment, I think this is
looking fine.

-- 
Jens Axboe

