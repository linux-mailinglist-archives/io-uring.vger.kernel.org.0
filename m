Return-Path: <io-uring+bounces-475-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E33F839D2D
	for <lists+io-uring@lfdr.de>; Wed, 24 Jan 2024 00:24:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41AC21C23A43
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 23:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFA3B3611E;
	Tue, 23 Jan 2024 23:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="C2Ts7+dF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A192E2B9CE
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 23:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706052274; cv=none; b=mpkzrBbcBJfAuOqcnlhxBZBbbeQ3GInunuyYnaX30cD84R9TuXI1C/jISQDXvkg0tOGfMddy2CLUj17pFRdvDj46XiGzHEViJn52OlUyjKb3KXS2jlOZA3fZhBi46yxVSV+qqRq20g5jJg54cfvPgXnuS6cchIauo7Y3Y9zT4E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706052274; c=relaxed/simple;
	bh=Qm+YyA3dd6Q6vC7FU0kgtHMnYaQBfxC59lDHA8gX2U0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aTlhQ8+/k9oFcgQKk59VpF5kBYclagXv4qIAxsnV8g+mi8Bt7JvdeckhrwcEOhWSSXMbYKBvsE+/pzMidSlFloCUAmLYbDhsLne5y+KrfQZSXz/8vUdkxAZj70+VwyqYG0d46QoSVutEH0olm/OIdgh9LRUR3eHRtQkmJ02CYys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=C2Ts7+dF; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-290327b310eso669055a91.1
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 15:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706052271; x=1706657071; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wqs6O/Jrzc9cQQ2SZct/FMuBE6/cHEOMF/8PWzq6D8A=;
        b=C2Ts7+dF3PCZp+OEe744tQS1YTjOHHSs8fp6+OrPWpPYgSAHrrPtYFPnLdIuTkTG26
         oUoz66o1tgNr0P5zaiqPhcQQNUi24/Q75/bC90UBrOMQF8rIHjj3JP6lF8vtiYXofzAQ
         7vIk6l++5/fIK2gx3TcUy4e10ZLwheJlRphqRkHaMXc+EkZLWbCEfPX6Irh4EbGf7bSb
         slSTd4yuFhgkHluFqmagPjEBQydxJV2XIPfmx4D17nnq7Njbf7H1wxTkltLg86Ux9gDO
         +Gn4CZmZIUlBSqkxzaD0KYL1FitKkJXytd884UcJFtwSVKPLSerSaF7CnBdqTVeruif/
         VERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706052271; x=1706657071;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wqs6O/Jrzc9cQQ2SZct/FMuBE6/cHEOMF/8PWzq6D8A=;
        b=NfynUKKev9R+c1eeQSwJ24aScg45X+3T8WSs/Y5UqLEpPnO1iH1Q5sSC931jo+SW9q
         O+Gh3Wcr8OPnC4ItRUN5/cVQoAuFu+nEkgak0OdLOFy64T5PRr3th2a9+hw2aLAsUfTB
         3kWDXzenY0krGReHjHYInLERqaO0dUmoTHr+CFuOneN/1h7ENsIrpmyMTwUA6MMFvexo
         GP6ljoCoqzjwsbsqMCTomLAg0guq5SeewPDDS8Yk/IXiFC37JPw/3+CWwT9Q9j5Gc6Y1
         nUqC38T2FwaOt9kHl0Av7wtKdOry7I9/xn/ug2SAffsCRxiYPmZ2f9W/TIYs7YTz+f/Q
         UY4A==
X-Gm-Message-State: AOJu0YytMUsJA1kTu14SNMkZkr5+3d5L5qhWkx2ylOYPncWa1dr0ofkm
	BPds1z2s4J42uYufJf8iuJiaDL9bMcxL6Vyi1vfAp+KNDiCwOV42fUuc7MhkQvg=
X-Google-Smtp-Source: AGHT+IEHY+h+vRH/Z0OH6AWRBZ5SqpXEwne7xK8pZkvjrHKeiTcdOce1l1TGWD1c1CMvhh397hOm+g==
X-Received: by 2002:a17:902:d3cd:b0:1d7:4e2:293 with SMTP id w13-20020a170902d3cd00b001d704e20293mr862640plb.0.1706052270924;
        Tue, 23 Jan 2024 15:24:30 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id ku11-20020a170903288b00b001d72846e441sm6636197plb.72.2024.01.23.15.24.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 15:24:30 -0800 (PST)
Message-ID: <f298acda-f946-45b6-9a4c-659b0be709ee@kernel.dk>
Date: Tue, 23 Jan 2024 16:24:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] io_uring: add support for ftruncate
Content-Language: en-US
To: Tony Solomonik <tony.solomonik@gmail.com>
Cc: krisman@suse.de, leitao@debian.org, io-uring@vger.kernel.org,
 asml.silence@gmail.com
References: <20240123113333.79503-2-tony.solomonik@gmail.com>
 <20240123223341.14568-1-tony.solomonik@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240123223341.14568-1-tony.solomonik@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/24 3:33 PM, Tony Solomonik wrote:
> This patch adds support for doing truncate through io_uring, eliminating
> the need for applications to roll their own thread pool or offload
> mechanism to be able to do non-blocking truncates.

All looks go to me now! But I think you should send out a v5 and cc
linux-fsdevel@vger.kernel.org and christian Brauner <brauner@kernel.org>
to get the fs internal bits reviewed and vetted.

-- 
Jens Axboe


