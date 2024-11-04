Return-Path: <io-uring+bounces-4403-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ECEA9BB587
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 14:13:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63678282B7D
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 13:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB6E1BBBD6;
	Mon,  4 Nov 2024 13:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NM8yH0dG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0D21B4F02;
	Mon,  4 Nov 2024 13:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726000; cv=none; b=uikXFg9EYcnreVCRLusNp/U1JW5vbdC7m16dzzDd5l6QA6rWC6aFmkFADqD0UgZl4yUKifBpGKcaUugxJu92Z8nVgW05xlufxxuRKvsT6oi4OpO9M7Z9GgLUsv+3JPt/x0ITfeCI0IrpFB6cKDHaPehy3Y0raZxooLCHNhtzpIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726000; c=relaxed/simple;
	bh=4S/nDSwNz4r1OOsRvGLuHNivXoyvioHRcrVAPEQX/Dk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jSkiSzl45sKuut+tcsSXzDsKk65QzZaqtPRMsLRTl11F67NA7WLpqCCqOxlMU9MRrfKF4acQ5djCq7YpLM1DDXqZcjuyhT3xUyCCBiByd0pGLCkikIcWbgc6aWczsHlbSzgk4j+Bk7wrcB2d0NttA9VmI3ftzoslO6E/08GlccE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NM8yH0dG; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-53a097aa3daso3851152e87.1;
        Mon, 04 Nov 2024 05:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730725997; x=1731330797; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yMCvtP1NYhEVKqyeGiRcuaYl7HQ6ehAW0WV2WwfufNo=;
        b=NM8yH0dGtv8r8DqUFMcQcwUhB+fEJzYTkE/oq+38GGf1bDfe+fXgk9xEMVWBu151GV
         vMljJrxikYiRf+vKP/5m/3YRe1aaR6n+amDXj2b6h1DP3Zrx+AuCW0BCjObR5YLfaynU
         jaU/9pw5V8fLX9afLETWUZHkSrGhtJKdNx5j65WZO4DOePNRLqWFAMw3FtpbxF6YEss3
         Uu0GNjD+g8c3S7nC/2gQ9D4vknmDzwthvRKd+qrn3i10LwI1teI0yoWv9ildDwrRSXbL
         bKEvuSoS5fqyGBLvBh9Oc2c9dbCwp6unJBDYAQvUw9OpHoaRuZ0fw7YWmMRU6rPlkgA8
         xvhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730725997; x=1731330797;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yMCvtP1NYhEVKqyeGiRcuaYl7HQ6ehAW0WV2WwfufNo=;
        b=vqrLu++9kRNitBLbofVcpxDLluTMr7ps6jwoZvSxGp13e65QqLpjjKDIK1tvGEKB5n
         bBkJVm0FwDbLAKeOxLP2JA6SYrb+GS2NMVKCPqKsKoXWvhUMWAsjqiiVqnJQu3ftiRxq
         Ub+YtegWaqXJIT4Ww+J0Yz4Y+X2o/ts6ovH7/RNrvVi/Tl6eWLWU25w75QcmRDbKrFfT
         sHtXFWot+dZmt69LszEMmEz7uitMnVygZeEtahvkdQhsp9mShgRlFbsFdmjqCrtPGfYe
         Ep3ZCue4R1itHWmtYqTqY6+4IT1mUVnPAcmM7Rdh5Pu35INhri5edX8Dft9Gd0J8iaK/
         tjHA==
X-Forwarded-Encrypted: i=1; AJvYcCUA5+KLlNpRZb78ZmBpuk8DW43p3ki+5cbiBW0NP4u29Zy7ShdqgH+K8PiqmHuT8UQqw+G2SgTSHw==@vger.kernel.org, AJvYcCVyFDXdtjCRs7hBRncGwbSIXjy0QkIIm7XW0sCne7DhCDsveqLTznFW2k8UOvNXdNzhd1EEwjx+TX8dH426@vger.kernel.org, AJvYcCWEWWoiPnoyaeFBZTtvIUMM8OFNjWPrp40FAj1kwQhLP1Q0n/hFCwZpybA0/+zXdaJKXihhudctLBXw@vger.kernel.org
X-Gm-Message-State: AOJu0YxvvlVW+VRQtnk8N6fMYK8W6W6Q0o+qmrPOe44z13iVzoisefG0
	0ZUOknuswlaMrLPYcHVRAWEReanXKz9rccHUBvCgRooJEBLsGesO
X-Google-Smtp-Source: AGHT+IGSbukATV4IJRXSVcWr62/WHLmPU6mosjBIruFuQ+D8QqoaI8P8X8caXtAyklebDmlPKgxsoA==
X-Received: by 2002:a05:6512:3b8c:b0:539:d22c:37bd with SMTP id 2adb3069b0e04-53d65e02641mr6111495e87.36.1730725996534;
        Mon, 04 Nov 2024 05:13:16 -0800 (PST)
Received: from [192.168.42.215] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ceac7e97e7sm4216843a12.91.2024.11.04.05.13.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 05:13:16 -0800 (PST)
Message-ID: <13da163a-d088-4b4d-8ad1-dbf609b03228@gmail.com>
Date: Mon, 4 Nov 2024 13:13:22 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] [usb?] WARNING in io_get_cqe_overflow (2)
To: syzbot <syzbot+e333341d3d985e5173b2@syzkaller.appspotmail.com>,
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-usb@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <6728b077.050a0220.35b515.01ba.GAE@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6728b077.050a0220.35b515.01ba.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 11:31, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 3f1a546444738b21a8c312a4b49dc168b65c8706
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Sat Oct 26 01:27:39 2024 +0000
> 
>      io_uring/rsrc: get rid of per-ring io_rsrc_node list
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15aaa1f7980000
> start commit:   c88416ba074a Add linux-next specific files for 20241101
> git tree:       linux-next
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=17aaa1f7980000
> console output: https://syzkaller.appspot.com/x/log.txt?x=13aaa1f7980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=704b6be2ac2f205f
> dashboard link: https://syzkaller.appspot.com/bug?extid=e333341d3d985e5173b2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16ec06a7980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12c04740580000
> 
> Reported-by: syzbot+e333341d3d985e5173b2@syzkaller.appspotmail.com
> Fixes: 3f1a54644473 ("io_uring/rsrc: get rid of per-ring io_rsrc_node list")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Previously all puts were done by requests, which in case of an exiting
ring were fallback'ed to normal tw. Now, the unregister path posts CQEs,
while the original task is still alive. Should be fine in general because
at this point there could be no requests posting in parallel and all
is synchronised, so it's a false positive, but we need to change the assert
or something else.

-- 
Pavel Begunkov

