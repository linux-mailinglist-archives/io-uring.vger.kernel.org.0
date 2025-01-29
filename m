Return-Path: <io-uring+bounces-6180-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 73C51A22468
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 20:11:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D769C1887E71
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 19:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2653A1E1C1F;
	Wed, 29 Jan 2025 19:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CQ+AuUaY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724AB194089;
	Wed, 29 Jan 2025 19:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738177869; cv=none; b=dh/EJ0Ij2Bi7tilPpcVpXdsoURu3QIM9ZzRWgtAgGMmtq3gUFHuZJNDlwgy38PAbbeH3prIyoyCcC+/KgwGNoGAYepNjXklJ2NNMCikm/8NRMhxpFJQ1H60EyjCXrqvFWfmr2O9fQ0NL5SJN+RcAn9hR2bDt14wlbSowKXjG9BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738177869; c=relaxed/simple;
	bh=Z3hEyDlfLsij0qd9ZTKWy2lWob92wfkk08MbVtVNmLo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NFvUtIotEEv1OngWuOmsmKJsft6VBLrXGhiwYzIR9hBE3i53nUo8aLnKd2V1jgPBntHDby8OH9Rpf5Xc8rPHVTkWuim3fj9a4mmaYybWbKmx3qmNw3wxQ/ZC2IuTuKEGuDxkwPbXxLnqyFqio92eIKeCp6o+hH+tDlWkCriYWhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CQ+AuUaY; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43625c4a50dso49129285e9.0;
        Wed, 29 Jan 2025 11:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738177866; x=1738782666; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QgeY7iYAvB41Lp1Ji64FMn5cPOZfexlcQFJUwtwrKjg=;
        b=CQ+AuUaYk8QHDi1oyZLuU2xXhsMmESw/XuZ9W5C5HNO7sTje/Vx+YWlK4vVXmfrcc6
         jdAecKI4Mu9KZzlkKb69fhpg2FRtsFi/4SK5f4LBY8ZC53zPO1WfgUaGu0ViE3cCpGNs
         Sfww4KaiQ79fKCH3kXKMHoU6XN7qPkkQ64dmSHmB8kDrAMiRIeJeeD1E/BC0DbBW8Vxp
         G+mEiwQFudf4cmVhYN/x90jlhAp86E3BA0qmH8axyVjcxzuyaij+uWHQJJkM0+KVektU
         SMAcORL2qKxaJQtMOu3af5OUlV8O2ejZ344EFS7tskW7CpSt5YByowfMz85BL6mcv8hS
         /asw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738177866; x=1738782666;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QgeY7iYAvB41Lp1Ji64FMn5cPOZfexlcQFJUwtwrKjg=;
        b=aa15EiCeeHcu1zBK8HrE6Rjl3O9yc1JiZrPveka2STKSHNlQY/TJdq3DbmVXejsr5A
         GFENC8AiOWCm8Xi5g9pmSwctk5SE4rzS2hPujFP4tXuvOisB7Jpbh21lsyeKaJ4nvv7F
         a2sg1kxdznw1JdKNX7YHhfJ8NsKOkbxgtvRWpzkDPt1qb55j6TSJTBOlxFPe9JceFSA9
         wY2o/zI71prxLvvP/PFyvrZBlWoWffSE9jqqMux/22Qq/VOdf8r2jEMblSGll2zpggT0
         xGsOKkkko/DUinpLXV+oqrzzQV7vALFHOrdP7ZmsqgGg0VvoDGzi0C6338PRK2TjfxUW
         bRlA==
X-Forwarded-Encrypted: i=1; AJvYcCUXncrHiVfzSa0oMn9OnFMaKPa6ELYzIqbsXadOTUQuZsalZd/cT/ZJ6bv2+ZcoQ+PFGHHexJqOhxMsaoER@vger.kernel.org, AJvYcCVNwOHSLWV2NU7D3JaOfNYd8Fa0PtDKI0MtJLHJJEXCjeOfHERvEzc/pGVnLcbeHV2spwHqz17Hcw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZC6Fw53Gm9wgU5DWypImMabfavU7NhNCPuK74yUHpbupP9v5y
	2CuhKYQdMWH6ArUvMh5+ivW6tM8bgFdISgOb/02rkAlfpRaPDJ6ehSMOeA==
X-Gm-Gg: ASbGncuCPTXzvhC+cX4OxGN9V0c7MptrnRnNhGMevKL/QlB2ZrDkSxCAyYeE8CRR7/f
	/9aM77Acuv20oZ/NcER98CNQuuZPUdnwHfXoOqtfgbTRDK2eiwBC+aoUfpjB04Frh69dDVOtGWE
	YKbm1RYxJXjMM6VkgCzPoIjhsCBMkcz65psqSNJ3pKm7kPah4fzXW0lePX1RBZnPN5VDPVKlLnm
	JQlvuDeESQ76tXg0KeL6FWnCv90KHhcQ6DUUOmws8Ork5zIWzASZSts2YEbZmoM0UYwlHpnVcaA
	3RDLhVbAW+uFsjl0XRvA2TGZ1Q==
X-Google-Smtp-Source: AGHT+IEwAcbssK88/hcC6plD/ZBGatEP/2v+f8dosmhfagc3cV7z+G1s72FHIfFXsaFedr+LdrEIcQ==
X-Received: by 2002:a05:6000:1faa:b0:38a:9f27:838c with SMTP id ffacd0b85a97d-38c520a0fd9mr3506850f8f.55.1738177865531;
        Wed, 29 Jan 2025 11:11:05 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.217])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438dcc2e239sm31894565e9.18.2025.01.29.11.11.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 11:11:04 -0800 (PST)
Message-ID: <a7733b94-c7c0-4e95-975d-e45562d54f3f@gmail.com>
Date: Wed, 29 Jan 2025 19:11:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] io_uring: cache io_kiocb->flags in variable
To: Max Kellermann <max.kellermann@ionos.com>, axboe@kernel.dk,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <20250128133927.3989681-8-max.kellermann@ionos.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250128133927.3989681-8-max.kellermann@ionos.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/28/25 13:39, Max Kellermann wrote:
> This eliminates several redundant reads, some of which probably cannot
> be optimized away by the compiler.

Let's not, it hurts readability with no clear benefits. In most cases
the compiler will be able to optimise it just where it matters, and
in cold paths we're comparing the overhead of reading a cached variable
with taking locks and doing indirect calls, and even then it'd likely
need to be saved onto the stack and loaded back.

The only place where it might be worth it is io_issue_sqe(), and
even then I'd doubt it.

-- 
Pavel Begunkov


