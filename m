Return-Path: <io-uring+bounces-4334-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B70B59B9976
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 21:29:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E86471C215F5
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 20:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F3A1A2658;
	Fri,  1 Nov 2024 20:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vbKLqbqy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB501D89E9
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 20:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730492961; cv=none; b=iovbtfztqgaR1SlRTxVKBH7/xMvltT99Sax4UG3Gzkc3F+6prwp9AwoG+Vr5p4HeT3VxHEnBiCt/NmvYjgMik9mbQS0qro+rqYgv7PP27k3lVsWntgTwLuwLzAO1Rt7T+BFGhn5T+5ZOFmKwpr122W2HMpr4m7nk+qGcC8PMHBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730492961; c=relaxed/simple;
	bh=SHtIzlTdskgqF/JotKMdHU2LJfq+lln40ai2gKwXBZo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eyvgud8p01IcARX4UIo9l5YUpG5s8QkBrzSDiP216TL0HwOzNzNFDTWC65vhXRuffwegJajzSVfu1ZkR/cjAaJY4qAckK061rCO0ARVz2tAoYx+0yU9JmVa15Mdkl4i8QYs8H7wdRhPbeW1Xm3WsveV4vyXHVlMBt8GIlMa2J5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vbKLqbqy; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2e3686088c3so1812687a91.0
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 13:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730492957; x=1731097757; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=37Ml4ihCR1TC/QhKboatJNZ1ET5x5XZk+QbDisk1nWE=;
        b=vbKLqbqyaU/YRnm42T062qh51fNZIQQ77ahIorhJnkIlbj8zKBZR9eXHr0nIH/KkWS
         M+cnm81iYoMlRBH41ykIJCGC992YiG5lzwttPg8pURfL1yr1n/EFRI38u9m/sFhHX/Z+
         fNpt7RJbgJlMUkQbeAWNVdPD+zpeKYEj8aQiwVhkSZkELQG6Az4Rt/8xXV2tN0/2CLDu
         bOcgE6kBQOCc8ZfkemHfPrn7VClkN9uwz+ApfGYnxBvy9t4VPYwQeE/NNe2HqKNUvLuM
         Uj5G1rSOjxCbSOFN/uR7Cxz5iX9auy6y79rhzHPAO0ggOENYu60NTVDQV8hbSkBZ9fsT
         YZzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730492957; x=1731097757;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=37Ml4ihCR1TC/QhKboatJNZ1ET5x5XZk+QbDisk1nWE=;
        b=bZLWKnRZD4uUfOcjUMhZlQGdnBZtsCqJvbhPKiIeT7rQW4Y5llLDKZ9PIpIxkN6LMa
         C2oD4Mc6hPxFw/tNVJSdVxPrkkmmVOvd13+M+lSdxObQ/X1UyZitWQkJVEhKzKFVQD0X
         PfDBhgO0ZvAyjc4B9F/KH1TWeYNb/ZipBjeiraMd3pQGh+2o7RsJ0b/OksNpzvYIBdg1
         nZIWf0tvfmIk1mpqVo0bGLS0V8Vrk878MLN6kdDI644wWiYffE9UfuQSHTlMQmSS3GTD
         L79Hq8LpPTWuHti5rInuUbOxtYobMdhjqcv5HROn5+4bitpzpJOW+kaT4Q6ciYIrKhn6
         FSwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUeaQFZYQjgatqTExaeev5oQrXAoYExQJ67spEDXEnhhQCZBDdaRIwOye7fLYvjSzMSLtadY7sKA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzG6X3wqhB9jxmC9qtHu+QeZKdFbc3DumbyocTz7fh5T4x7oHsZ
	MVuB6uVSoppkzaAhKoN60bPVdrDje2fLWmbuf1rYMdid9CF+jq1gBFPpdopIFio=
X-Google-Smtp-Source: AGHT+IEuGyZz/WBx1ul7rIyEtn2aVVVvVjBz+RnMGGnpTvoeJ0INGxNW/v4lDRjyuwVayFnotQksXA==
X-Received: by 2002:a17:90a:a58f:b0:2e3:171e:3b8c with SMTP id 98e67ed59e1d1-2e92cf2d074mr12419264a91.25.1730492957589;
        Fri, 01 Nov 2024 13:29:17 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e93daac445sm3153148a91.18.2024.11.01.13.29.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 13:29:17 -0700 (PDT)
Message-ID: <8fb2e8a3-c46c-4116-9f5e-0ab826ec9d22@kernel.dk>
Date: Fri, 1 Nov 2024 14:29:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] general protection fault in
 io_sqe_buffer_register
To: syzbot <syzbot+05c0f12a4d43d656817e@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <67253504.050a0220.3c8d68.08e1.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <67253504.050a0220.3c8d68.08e1.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/1/24 2:07 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f9f24ca362a4 Add linux-next specific files for 20241031
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=12052630580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=328572ed4d152be9
> dashboard link: https://syzkaller.appspot.com/bug?extid=05c0f12a4d43d656817e
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15abc6f7980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10eb655f980000

Same deal:

#syz test: git://git.kernel.dk/linux for-6.13/io_uring

-- 
Jens Axboe


