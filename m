Return-Path: <io-uring+bounces-9912-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62FCEBC1670
	for <lists+io-uring@lfdr.de>; Tue, 07 Oct 2025 14:47:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50E8319A2356
	for <lists+io-uring@lfdr.de>; Tue,  7 Oct 2025 12:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B4602DC353;
	Tue,  7 Oct 2025 12:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QokZM0qJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB6021FF48
	for <io-uring@vger.kernel.org>; Tue,  7 Oct 2025 12:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759841245; cv=none; b=Z71OdLst263vh/9ebeEu+/7qsIUEL0/c3TjhZ/lNSPREQY0QfP75azJrwBEXo7EuwJqHxsBQum1Se0G1ZU6Wu8cBWdSgM1YEo85lpXj/bVwHMtoHfald0h9P1wSG6BDNVn/SgDXQxPTLCqGZc2ZVAPDZXMtbcdToV9a7K/fF01M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759841245; c=relaxed/simple;
	bh=RQN/2lDlhzCHpCJtTDLlN1RlhI45f3qz73uJwycfNyE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=EQDvZ+qXwzKcLN/2Cjjccb54Zx6PxiIXeKQ6RY1asQagVWPklId54CfGQ8yBPLDOJWHWGHM7vfxfoEzMgvRYx+w9Fm5SiPGAv1GvH6AQnhf73QhsX0HZNRQ/Rmcmp0swjcY64iD7dX7uZrR7Si+tB9h+gK2toP45Q1fHb/NLlpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QokZM0qJ; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-428551be643so49555325ab.3
        for <io-uring@vger.kernel.org>; Tue, 07 Oct 2025 05:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759841242; x=1760446042; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CJuDLqWRo4Zntrd7FLhRCTIWZVZXh1mD+BCXSb25DVE=;
        b=QokZM0qJdV5QIxYrua/bpJ22oY2BnV9GPTZEEql/b5va0Gh3BNTQKKYGIREgbV1d/B
         oWHbaZCunLe5AfACdWoBEyXaOFa0kGEj+H8qKVzVinuTg0UKhMOsRNUlbEOiVmwLuCYs
         CPvoDpyfM69NZG+gkOI/1Kdiqh31iDopmAC40VYjY/D2bG1jUCFVKpgMakYSzMJQP8LZ
         cs75sNpUE8wnYZk9sUO50MgN6C71GNoxnYomQA08wxhBItUeDBENOF/g4jVCo4+SAjKe
         zXPb/E5HhRG73yC/NzhchCsPrXJb9rpFRXOLjbEWD+gm1KJjC4hQ47+CNciyEWYE2iKi
         Q4nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759841242; x=1760446042;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CJuDLqWRo4Zntrd7FLhRCTIWZVZXh1mD+BCXSb25DVE=;
        b=XGnS7OuMXLI1nFnlraOB8NT4JytAWmxRHgWe32u1f0v8m3qgLk9r8YNKLtFQrtoIRF
         r7wP6Tee813/AhD3qGLF/xfU/kk1M7cGYA+epxLJW77GbofqhSgveCGVfBAvbIWa7yYh
         rhjfHC11czpCrZ01jjyF5B+iqW/C8PWYdWKheFedXBfc6XXiaM+QZbw8QpTuFQM5yrZ6
         dnaYSkwCowKatw1t4HgPwP8Hqto3ip+qlZQAgipp3fzCe6LST8p4E6eYzLPghZMT7og/
         ikT1kmwMn5/lIApOJTsTeqPmmlqtWqNIZGHY7SCnEbCGxjftZrJkRfRPaGYpOduywctF
         raSA==
X-Forwarded-Encrypted: i=1; AJvYcCVHKvIXLUtmfHoZdW6OOpL8ycTzjUw8kEypi9up5PP/fb+WWcURDzf3XXR8J+pSrP/ts7mRRsy2OQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywga43ux2AWU+YrpqVKM1tZHFN+J4emDIbQ3QxfsJJ2D/hob0oc
	sCn8cck2tD0As69EWCNVR/BnOIA8hVQ+JPTpqimVKJrH/AZngbI9Bv4A6Xugtf5LfJw=
X-Gm-Gg: ASbGncsEQmLEdtYVQJYaYEkgbmoIWxEorBXXUY0nEFRf7RVjVPCx6zEZdvaQEeN2tVO
	ErCho/d9+Wdz1CAuWeX+4OSFwZTZF1MF8PhwpGR4yFqzbRHu+i/L7Bc1tpe3rphfWL+A2uJ61KW
	h7Q9NPVU/X9mPFSqf7DKmv8e9vWl/J6FGUTd6FrWOYsusrc2g3xjbK3+nEa/K6QTvC7ArFP/QBb
	Ky4lKcT4ELnbNg/HvfUNYJzTqSgpvsuKqeP6vXoxfuGS1FbCcOZNN/trewJ3Zhvr4sO4STHmdGg
	mPYbRSi77+UbfRg9xI0Ao3W6gIDvkhyQeHXM1UYhYHkKPZ0B5sDavSe74F8iX0LZ/NjlosR1zJS
	kNg6mYNDDYdvx0ZYaLwpgjui6m9w8O96bVgvEfYhsn0nzsIc59jnrttE=
X-Google-Smtp-Source: AGHT+IEhjV+rQNakagoyRfFs8Cw5QyuLbDFd/MmJxW09tmaws68gZlvukb/j2kPTZy0RgCpUbBD3iQ==
X-Received: by 2002:a05:6e02:1d89:b0:42e:38d1:7c61 with SMTP id e9e14a558f8ab-42e7ad8447dmr208356865ab.22.1759841242260;
        Tue, 07 Oct 2025 05:47:22 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5ea3a5basm6128505173.23.2025.10.07.05.47.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 05:47:21 -0700 (PDT)
Message-ID: <a2cb114a-e31a-46d3-8c27-35149bed668f@kernel.dk>
Date: Tue, 7 Oct 2025 06:47:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [nfs?] [io-uring?] WARNING in nfsd_file_cache_init
To: syzbot <syzbot+a6f4d69b9b23404bbabf@syzkaller.appspotmail.com>,
 Dai.Ngo@oracle.com, chuck.lever@oracle.com, io-uring@vger.kernel.org,
 jlayton@kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
 neil@brown.name, okorniev@redhat.com, syzkaller-bugs@googlegroups.com,
 tom@talpey.com
References: <68e4a3d1.a00a0220.298cc0.0471.GAE@google.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <68e4a3d1.a00a0220.298cc0.0471.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Doesn't look like it's io_uring related:

#syz set subsystems: nfs

-- 
Jens Axboe

