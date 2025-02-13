Return-Path: <io-uring+bounces-6419-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 276F2A34BD8
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 18:25:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5091418837EE
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 17:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C539221713;
	Thu, 13 Feb 2025 17:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hvsLb/wi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22F42040AF
	for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 17:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739467529; cv=none; b=UU4KqYJOIcHYimhTdQvipRRkQnURNOSaVq43GDBoptEEGwc/obFUcW/Ijipe3JDrCCLIQdYXgpdo+rPkPpuXGMCVbXT1pGMl3z0y5Sbkk3SuS1bQ6m74H1/YXg2MIPmzrhwvGRphojERy2M/Sy0a26DwmtRP4Rj84EIQhiW1e98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739467529; c=relaxed/simple;
	bh=cTRb0kqpJGX1F9jL8FnOhn6Ca4Hg9EI26LBCLKGL23o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MrHdmC05um1F2PpNWNSGhNFWndLAEH0RXjXC+AMz+6r9NwollazHBBxv3k7z5r5WOUqCbfUOeGT+8j2I5Utum8KDa6Valrpz3+G5LLl6qsz3B0YjXztCf0pEgD7DlcucZTxVXl2pSP/AeR3V/JpQyPkyZx8FpPhG8etZ+0HIJKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hvsLb/wi; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3d193fc345aso1508295ab.2
        for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 09:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739467524; x=1740072324; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7DjdmdjC1xidHv/YMuUJzKruUB46GV9Gz4lLNVHpEWA=;
        b=hvsLb/wi3jQsDzDC8IVPXm24SO4xyxLx7SBSwP1gNMg/ij2uTWK7rfxfg6/43BPlE+
         1+FtGsADA/BVhjOSVTiY8L3J19SFee0pIBUX5dL0QEFdS/F9PyAFWJ1NC4il/fi9F/iy
         7ZHht0rg1Isg7jGqPIoopG0B4bfRcIJRNVWFMiylNxcx4iQXfsfpx9agjIhHdrp09s5Q
         GE8GzDR5GLXt3lPovJqJbylhlyNfkDWcPw12hSokXhobwv+JFMWIxBp0GqCbjAqvKpQZ
         O3SjKiaLop3A8wvuphDESDrwkS4Qz6TWgsLlFSK5uxlmpkcZvAJp1N6IzOq7Ljkw4kXc
         PaiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739467524; x=1740072324;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7DjdmdjC1xidHv/YMuUJzKruUB46GV9Gz4lLNVHpEWA=;
        b=ub8nFWO0OXYhg00hFojX9N/Uqilo215s8QJTdS6lAXrSZoXqNudFqTITl5979qwCW7
         b94eS6N+MhighlH8sH/107icN5isyQzPLcA+kznXQOzVET3XynfyBR5IY5yP9+CydMwm
         v6SolQsgDkYCf6MdE2UblZRNTE8yDlxFefe50iMLvg/iquLMIhGaL4a9bv/OTmzWGPdt
         5/eP2b8O1OPyL0DUznhLiSZ0fjsNn6Iaw4uK6n7Eda600tIzsGhtJfjVMA+/lQiCgz0N
         ZAL9bmKlsw9y1RGZf5NYVFEKbvqTk/xTGq+tDY9UWbpbk8phxnZov0COVOJ+q5kVFRHK
         A+LQ==
X-Gm-Message-State: AOJu0YzsJFLAH92bMj2fBtb+eHr64k47FfhYsjpN+JQrOYPuaHzrQalR
	VYC0cSEQ8dmRjJeHWzQnA2A5Jgcm+A1EKadyi8fDT0u8XO3eklHviZSzTAr0QXvHeCUr4IFg05X
	p
X-Gm-Gg: ASbGncstk++G5JEjOt5XDpSATyi1XxEaI6GRJIsNMoBRO7Qxx/kXuyTrjbjBFNJoqxg
	IkoQpf82x3lP3hq7U4UELD3DLap1u3/CQy31rQroG+kVbArIGskXKgjwVL1VoL36vWJBNWMlDj7
	6DHTMHcwRDpTZEA5uyX6Y2hp1ibfjB+0Kk0qvdg96azQxPNFzzUpRjTXTR8hReNUt40VCjpqtw+
	8gXPbMrrHT6FjKxTbfUPZrfSKU8O58qG19wY5J6uKo6xzriovDtYfIjMSOwIENI6+lOn6Bf0zpA
	AFvSeYulr94=
X-Google-Smtp-Source: AGHT+IELjr2vL5KHwrZdiaiJSKdNVcxLFTAoXYOHxCLgiy0EnNbDEL+PBUSpwgBizO2YMVnvgqnO7g==
X-Received: by 2002:a05:6e02:1c2b:b0:3d1:79bf:a0e0 with SMTP id e9e14a558f8ab-3d17be197a4mr71935735ab.7.1739467523882;
        Thu, 13 Feb 2025 09:25:23 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d18fb56889sm3276685ab.51.2025.02.13.09.25.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 09:25:23 -0800 (PST)
Message-ID: <ed5285c1-2b83-4e95-9b7a-63eaccd7f0f8@kernel.dk>
Date: Thu, 13 Feb 2025 10:25:22 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/uring_cmd: unconditionally copy SQEs at prep
 time
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring <io-uring@vger.kernel.org>
References: <4e4dcdf3-f060-4118-911d-5b492cef8f8f@kernel.dk>
 <CADUfDZoqVAOeAKCHw2z-Er9_CY6d536wL41KUKu5uqDCjw52aw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZoqVAOeAKCHw2z-Er9_CY6d536wL41KUKu5uqDCjw52aw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/13/25 9:39 AM, Caleb Sander Mateos wrote:
> On Thu, Feb 13, 2025 at 8:30?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> This isn't generally necessary, but conditions have been observed where
>> SQE data is accessed from the original SQE after prep has been done and
>> outside of the initial issue. Opcode prep handlers must ensure that any
>> SQE related data is stable beyond the prep phase, but uring_cmd is a bit
>> special in how it handles the SQE which makes it susceptible to reading
>> stale data. If the application has reused the SQE before the original
>> completes, then that can lead to data corruption.
>>
>> Down the line we can relax this again once uring_cmd has been sanitized
>> a bit, and avoid unnecessarily copying the SQE.
>>
>> Reported-by: Caleb Sander Mateos <csander@purestorage.com>
>> Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> V2:
>> - Pass in SQE for copy, and drop helper for copy
> 
> v2 looks good to me. You might add "Fixes: 5eff57fa9f3a", since we
> know it fixes the potential SQE corruption in the link and drain
> cases.

Sure, I'll add that, reduces the risk of it being missed for stable.

-- 
Jens Axboe

