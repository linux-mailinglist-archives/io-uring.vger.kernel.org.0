Return-Path: <io-uring+bounces-3059-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A907A96F572
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 15:34:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D560D1C2132D
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 13:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A4DB1CE710;
	Fri,  6 Sep 2024 13:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iOvStNji"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A690B1CCB42
	for <io-uring@vger.kernel.org>; Fri,  6 Sep 2024 13:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725629640; cv=none; b=oeJ5VLg/T0nbvUMrVe8glSaMNzQ+oUxMGD9UYKTTg+lEIxmNVCOXX/PMdXsgbEjVjFRlPYtnotA/6Ewbp/77sB8tG78h4HVB0lARNPlpCbIRItviKY3pD+AGDdQskwRDlVY3i6BSIdY+rQiFBq//fo7Cl37U4SSvgJ7okVWVGlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725629640; c=relaxed/simple;
	bh=HNdjtfOQm752sZTMDUmrsUHn0oF61IxJcRSvx06fsR8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WDG3sBmbshFZDoW98CVtq+Bbb2eQHOOtPEjJ8B+9XS1GgQpzBFnAJ7rhbsadUo8751k05xMG3C2/1T27LwlvKEWe3IBc58hg+6rwO0KhHSznTK6Q3f0ePdCZCe1to9x0ssMWkWavExGkaBPJJvES+xp/X84hjOOp1G/YXHhmvRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iOvStNji; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-718da0821cbso443221b3a.0
        for <io-uring@vger.kernel.org>; Fri, 06 Sep 2024 06:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725629637; x=1726234437; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M9k9mGUQh6ymK70nACgtx8FEIFPdT0heHOtbTeYory4=;
        b=iOvStNji6tZY8AjUdXNv8Xf9HEyvB0MYK5tvSJm6LonYMIRMyNHpeE+MsxbxWlpVlm
         uAzdolQnL/vbm16wtrrZrXuqKGzTbO7ri/wBpOROpsVqb2zQ99n5V0QJoJD5zDJwt33I
         waz9DemG8gkrqXVcn3x0z8y1E/tXyAEg1FxAOz+htoPXlQw66hXJE6W+jjdgFbb1hbtE
         0b/DOkyzT5laNfUHIvpb4dadTj68UZ7Avkl0DcdJYZ+bcmF3WSDZUDKuQO2GPHwl90Yo
         +eUgYRYpThwpaKZVTY1OIsOJ5hyI9RukvXcGMZRrpginnaoRLUbfxhIvwdwqzVrWvrwt
         zBYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725629637; x=1726234437;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M9k9mGUQh6ymK70nACgtx8FEIFPdT0heHOtbTeYory4=;
        b=qsFzo6rJdmP46H3wnCFZ0XXbdm7y2mcLSzubahVYd/OKEBYDJ9iV6tLCELUVnKb0H0
         +86Q0ZWEWiXb3L330f/xO/WRGbLkg4sgzYg9hqmMEokLNNvpYBx8Kslvnou1YKYsVg0U
         eTT9GbQNRo/xEMJpcBcVR/L6kt7/dD4TTOpfqtKSvqIoOGozeGCjj9/T/DJFvTP5WayW
         mtW6e14zwmmJTyAR7Ai6iOtkGAGNRH16xW8Y5RFshEaEx+XrIRfuipCWTk842HROJMbp
         g6yrzQZ65Mo3hi8Dc2FqFLn3KHg9Wcfnud6swRqY+u9hjM19JSRG9HwYnqLrKI4gzHzk
         mKxw==
X-Gm-Message-State: AOJu0Yy0oVE79Lp3d8S+W1vLC/fwQ1e1nuUwJumEkdnnt5oDLr4SqaVo
	iiVIJiS8QgHnoFzgjczRlKSQH0t6zCTjsMRNTeSNSt7XXjaqxukC1c8vaqZPuko=
X-Google-Smtp-Source: AGHT+IEcVspPJX4rn6qrwIEknWXoGvCdqiyWe0o9sFNLwhGQ4L8zpn2t0HOZ3tCOxfV0NxgDaoDFcg==
X-Received: by 2002:a05:6a00:21c1:b0:70d:2708:d7ec with SMTP id d2e1a72fcca58-715dfaeac85mr30870820b3a.5.1725629636689;
        Fri, 06 Sep 2024 06:33:56 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-718e01265f5sm251840b3a.91.2024.09.06.06.33.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 06:33:56 -0700 (PDT)
Message-ID: <08c550af-1e83-4372-ae21-003931b77927@kernel.dk>
Date: Fri, 6 Sep 2024 07:33:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][6.1][0/2] io_uring: Do not set PF_NO_SETAFFINITY on
 poller threads
To: Felix Moessbauer <felix.moessbauer@siemens.com>, stable@vger.kernel.org
Cc: io-uring@vger.kernel.org, cgroups@vger.kernel.org,
 asml.silence@gmail.com, dqminh@cloudflare.com, longman@redhat.com,
 adriaan.schmidt@siemens.com, florian.bezdeka@siemens.com
References: <20240906095321.388613-1-felix.moessbauer@siemens.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240906095321.388613-1-felix.moessbauer@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/6/24 3:53 AM, Felix Moessbauer wrote:
> Setting the PF_NO_SETAFFINITY flag creates problems in combination with
> cpuset operations (see commit messages for details). To mitigate this, fixes have
> been written to remove the flag from the poller threads, which landed in v6.3. We
> need them in v6.1 as well.

Putting these in 6.1-stable is fine imho.

-- 
Jens Axboe



