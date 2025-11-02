Return-Path: <io-uring+bounces-10319-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10816C28949
	for <lists+io-uring@lfdr.de>; Sun, 02 Nov 2025 03:05:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53B8018977C2
	for <lists+io-uring@lfdr.de>; Sun,  2 Nov 2025 02:06:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8D5D1990C7;
	Sun,  2 Nov 2025 02:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1jpKEx8q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256F714B96E
	for <io-uring@vger.kernel.org>; Sun,  2 Nov 2025 02:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762049137; cv=none; b=L47tbZehLMndSLx2WoI5/6vYtUtZC0As46YJtxf9uGnNrwN0QYWzk+3dlnHCDUG95Dj3wlPxVxL1ZuWGI1CLu6EhnLhIsGqBrgz/9StLK1ZIaxDa61Lj1ZuYMYbVXPvKy19GTRd3DljrbBBgHd7EjMqH2vznR6IO25SBKDHGXA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762049137; c=relaxed/simple;
	bh=5JNqMVBy4glto3/E447gOut+UiSy2POuFSmwlFR+QCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YPrI2G4Rva1T8nWy+wS7ysY5KSpYP9U4ajP2rJUzZGLaIbtXYzM+3zbkVJcyN5OtYq2oBiRy3V7SzdnfRxDanzVbNWXJs9xTyXZT9honnV5P7KSSTLJGxPLX9XNfYE57XrbMPfiSU3j1c1Ag7uTIefHx4+N/cOV/ZvCI4dRFFlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1jpKEx8q; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-93e7e87c21bso341408339f.3
        for <io-uring@vger.kernel.org>; Sat, 01 Nov 2025 19:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762049134; x=1762653934; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gu2n0sHcfbeAOZk71KmAbrhzHpdNeix6s3INTo4MZbU=;
        b=1jpKEx8qSUOYaLvZCRpSI+0aPFcj5tm8Oy/QsXkLYSaWJT8BhFR897b38/aPIouTRE
         9desOywGtUszRuaqPnCto+7020FHt+UWuC4DZJtcwvpNTkYhMQ7onWLA48ixJh7KFgx/
         ZjQGe43O6K+/qkq5ECHo1lGKVO++M8B3/TIXgfVJ615GuIq/lajUF3XOI8uO0185mfbm
         i+Q7HDqUKjd+bEdas4BiB80TmD6QhK+Q0Tyo/U3CQiCDcmItBk6/yz/4k9Mj8JybECAU
         a8gI5FFuL18LLO+o2u0fvge7Xk4e3aMjNQ1KkoKOPPFkX7EorcMry8liMD5jbtR5Jc2l
         fyiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762049134; x=1762653934;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gu2n0sHcfbeAOZk71KmAbrhzHpdNeix6s3INTo4MZbU=;
        b=TGQfYSadc/tnVmv9A7zWPfr6PsODiSAXZuKfq9xHeyKSJRhi9oLxR8X/y/+LMtV42u
         I6PLXk9SXcOiPUgPzCFArgk7AymHI0qyFZ2M7NTOy+rEaL4TMalyq/vP9kSY4XWZhDPp
         QEPu+0pLdSF39dmCBPN7CPuvLFE8uE6FEHywadLLkKB2KF8xwVgAZsGnYXaRefVC3Lay
         dr2m0jSIauJNKV8jyz36PuioF7AH5p0d1boqGzFA1+uL7zAm03eAzH6I7mJ/CU+UeRhb
         GWWIbtRwsI4vRMyEWehIZXWFmxLczLv0jwWTXWD9qoWEbgnea6Ka3u22gOhcJdlPav/t
         m7iQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvL2F74vX7BAjA/h5zY1gNC//woQVb9q7y/Smi+/ysEhRLxrE8KxZ6jbMtMWzp3KfcsBOZgUXBQQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2QR6PWW33RxeOM1ZtPpYKzm1fdBD5CgIWctSc5xEMRbG3HCMv
	KjcUrnHvg3vInGM7FUwrOJG7BcQEal6AsYhHAeOSvp4qUYrkwCFURI1NAVNkt+kF2kA=
X-Gm-Gg: ASbGncu6YSidT8Lts3xtgIAT/N/mzwXWVLuCGyZ+IgA42YF5G9LbAq8ZKOWkX0/noGt
	N3+ESitxixKzzFsm9ECPCi7lsYB1vXpPFulw9tR7lOOfYT6QbvuuyCOzD0oVYGTKXsqAPHiYr+L
	hAD/N5VBrfXQeJvVUUP8SrYd/8LB6A4XWehPqBifBmn0FOtkpxsuD0AZ31Og4vEyLp68HxDPM2r
	MDSxA7+Jt/Sl3akId3Zy/661R2rbqmTjv94FYr5eF7ZviwN+KUqJ8NSxbDtVlKyt70OcUQHvbe6
	MrPEyTCvoULQ6FAsDbzho2Dkbl87HRH/jUxZotrNCSfPWeJWk7DrYXlnIHj871+Ejii7Na1KMvC
	lgkDvw4sAX0J0HKC0HzQMrjhuHCj3nqGXaQ99Uijyx3jknRDtqjPKqG2rnYOVrrIyUaJu85z0fq
	LCzDbr0YyL
X-Google-Smtp-Source: AGHT+IGjMI1rKpG7CijB7s0irk8MN/wZQwzi5MM80pP4THiIReRrkAxicJFqmepnEDD0WGpc7yab+A==
X-Received: by 2002:a05:6602:2b05:b0:940:d4aa:a34d with SMTP id ca18e2360f4ac-9482291e21fmr1360299239f.1.1762049133969;
        Sat, 01 Nov 2025 19:05:33 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b6a55b1b27sm2289836173.41.2025.11.01.19.05.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Nov 2025 19:05:32 -0700 (PDT)
Message-ID: <9f8428a1-ab65-4baf-8f46-af2531cd65ec@kernel.dk>
Date: Sat, 1 Nov 2025 20:05:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] INFO: task hung in
 io_uring_alloc_task_context (6)
To: syzbot <syzbot+898dd95c02117562d35a@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <6906b77f.050a0220.29fc44.0013.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6906b77f.050a0220.29fc44.0013.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/1/25 7:44 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f7d2388eeec2 Add linux-next specific files for 20251028

Old one again:

#syz fix: io_uring/fdinfo: cap SQ iteration at max SQ entries

-- 
Jens Axboe


