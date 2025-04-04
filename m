Return-Path: <io-uring+bounces-7397-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67769A7C0C4
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 17:41:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 725E817A68D
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 15:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476B21F427D;
	Fri,  4 Apr 2025 15:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XTw9OSLG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AEB1EEA5F
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 15:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743781208; cv=none; b=bEMXmJ9uOavwyedFqk9yIDFDmb0MLYNpZ3XnkBdj86GbGf+cQLckukbq7imE8dE9TdpWprcT1cEMsMYvSPiDKLqadYTqa+OkR0QJOGEoL+lpdhVHJMWVXVRdnd0YeY8J3lHsAc5dxuRylzONEtf873EAIWFoImoSYdoe+6xkoHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743781208; c=relaxed/simple;
	bh=n9p/b0lGD7rs1Oj0VL2lB3iStMGy8thpoLy9R6Yj8xE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rsIg+rzE44s7omQkniIyBOxmu1A/3s6gstPQlTfSNGlg2owdhtqTVsMu5E7rkZgQzCRqfTIQzVw6clSzNRBAdEjicJp37n4KpQ7SD+oQXR+5OBAeewv8fNBLVo62t++ezHhQn1ueqdI0nCi6NgyIIaiVi1W6oIUxrcciVhPVAv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XTw9OSLG; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-85e1b1f08a5so53074039f.2
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 08:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743781204; x=1744386004; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0SXxZpa1JaKYu20FdFjnW9/WtFmkDM1cox/WDceFGr4=;
        b=XTw9OSLGbl3H4tCT8+5QlDi9jduUgjYcFLEFvs4Vei/A2u3eywpy3g2sRi3HKQvuqa
         RpdcrJL31RCd50tkY0G64XTJG64VsICRArVy6KG9lWrxhyoOsY2sj13YbQn6j/HeaH/q
         5CzXX3B9LydsxuQ1KDNKcOGlA2YNjA/IJSokpmtYRhpLEX6+KXrc4zGPX7eC/UrQFX9c
         8gWH0DH6Fy1D8J0ECEz8KhrWwR1XzQMjfN6zICkoo6R2vkKzblY3W01QYLNDRPoQdIGt
         yu0vI8GxbhZgSOxpHmzT5x6iBVZbZdN6UVJ/1k2pNgOULDHtfqQIEcUCxWwH8nHLtpc0
         HJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743781204; x=1744386004;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0SXxZpa1JaKYu20FdFjnW9/WtFmkDM1cox/WDceFGr4=;
        b=D4XIn7oUdS5B1WY+6ZsWpX+itjCK0hL1QtG7nlqKg2ETqs+kRb55FclDmMHHLTRraI
         c28xr2KeWX8PCAWC15nuJr8CwqL39KYmaqrTUbdXsGiVWgk0EGmRE07p/fux8dbWcCFr
         5gdZL6ZrIn3zw0lFdQuHAyp6Tc/rtbX4OvDyJxcfYIXvEfnMIyoDyR4voRLum69DUdLe
         J15z17Bup0WCHLJzenPC9sPSVEBvoUy1LqZ541TgAGdNCJ2BPHpZ0B/WDunKgukJDAPo
         /k+TzhScF78SuaH2Vtp0pm7uGd4dnDqcClo0dzzJSXcS7aW+vUn64BkKDc8fnvuzYjRs
         dSmA==
X-Forwarded-Encrypted: i=1; AJvYcCWWRUqrJIPSMEEI8acXDQKdaBqYsAH1Nz/KagvKcWCpPzg/BA+8Qlm+AB+EltvUTNmbTYeJl9WQcg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJJteE1LA7BlOLY8tHK9Ld6LlbTUQ8rIeP90VzwLC8FxpfptIm
	5kmvH94w4ItFzzpDoi25p/5KsSzJItw6M4Jw/fGjkEgRcsO3ZXPcWQW3Pir5JDRj+kSkfqbtP2G
	Q
X-Gm-Gg: ASbGncvRtOjYnVXbYYCazoNEzUT564o/OZu92SayG90tLIocHEesY3JY6/GqkyE4DZp
	Uu+M/th+NCodA0r9Gn163ZeS1NhTE5WGUJVWzCnnF5oAhyLoWl3Gl7i9epansXKyknhsT7J46lH
	nRAD7QRwaKAUysDmN6vQoFipuCSo4yOM6hgAJlKtlKxt1qyGAGDrGlDH/xQWyZGz1F+rXCD8mpK
	hfKfNwM3aopb76NEvhcN7j/F5Ye7xh07du1DIY8wcqYK1tpoJsTGgVzqZbjsL3uh8I3g50UNyCb
	4u22y7dydGql/w62HjPQB1ftMHSwc7lbjPXHDpKN
X-Google-Smtp-Source: AGHT+IGAFmi9gbUTIP9acCHyKmDAJmFsg13176LvKRX5pwt3qOZyRyXRu1yrjSF4aicmwJAFDj1Jeg==
X-Received: by 2002:a05:6602:394b:b0:85b:3f8e:f186 with SMTP id ca18e2360f4ac-8611b42442amr401065139f.6.1743781203924;
        Fri, 04 Apr 2025 08:40:03 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f4b5c69f2esm853256173.74.2025.04.04.08.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 08:40:03 -0700 (PDT)
Message-ID: <b075d31c-e49f-4150-abfc-660766ccc250@kernel.dk>
Date: Fri, 4 Apr 2025 09:40:02 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: fix rsrc tagging on registration failure
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <c514446a8dcb0197cddd5d4ba8f6511da081cf1f.1743777957.git.asml.silence@gmail.com>
 <655729ed-7950-4b8b-baa6-5615eb11b8c4@kernel.dk>
 <2b3d9c22-fcd6-4422-8834-73f87d4c3df2@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2b3d9c22-fcd6-4422-8834-73f87d4c3df2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/4/25 9:37 AM, Pavel Begunkov wrote:
> On 4/4/25 15:55, Jens Axboe wrote:
>> On 4/4/25 8:46 AM, Pavel Begunkov wrote:
>>> Buffer / file table registration is all or nothing, if fails all
>>> resources we might have partially registered are dropped and the table
>>> is killed. When that happens it doesn't suppose to post any rsrc tag
>>> CQEs, that would be a surprise to the user and it can't be handled.
>>
>> Needs a bit of editing, but I can do that.
>>
>>> Cc: stable@vger.kernel.org
>>
>> We should either put a backport target on this, or a Fixes tag.
>> I guess a 6.1+ would suffice?
> 
> Fixes: 7029acd8a9503 ("io_uring/rsrc: get rid of per-ring io_rsrc_node list")
> 
> Looks like this one. Recent enough, I thought I'd be worse.

Oh yeah, that's nice and simple then.

-- 
Jens Axboe


