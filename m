Return-Path: <io-uring+bounces-5041-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E12ED9D8EE5
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 00:09:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8585C169B2F
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 23:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B83311925AD;
	Mon, 25 Nov 2024 23:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b8/h6TrA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF71B1E480;
	Mon, 25 Nov 2024 23:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732576166; cv=none; b=LXwobAvpQ9dpFPcWkN0TVgTHtVOmy9W8bT+F452Peb68jA1EBOSSW3dNvEDLSobFzNQlnMD9VMoeYs/iHWiqXHHx71VN1qawSGxOjKV8beKv3kju5EmSRptoxp8guJ4o7V58kSvEKroOpCiCQ3oP7O2nVmcorHIEP8tjqhluQWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732576166; c=relaxed/simple;
	bh=PJCmuQ4lMcanbRMirOcCM5Bjb+hCuj2GTmNSE+zMJaA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=tPN84iDQc2xZ00uee+2YKO+nuMMkusgyG+Gnuaa2RsoJ8T6/SO0TZrp1LBWQEJlMmApd0HtVFNniYpl4fAzanQwMtKuutjl//ZEJziBvTQIjxtjvJtO/Ki5u+QsSyBF1RvdCt+H2CFfJa7jJ6IK89Vgj4AJ4+Oug79orkjN6ifs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b8/h6TrA; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-38241435528so3274564f8f.2;
        Mon, 25 Nov 2024 15:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732576163; x=1733180963; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wZOY2+Zq+Uw5TtuUXacSqok50DLyY9YzgfmyZp7nZkg=;
        b=b8/h6TrAgEcBPc8lon5eZMU22GvEdILFTDZV9oXOa6xNUUtV5RMrOphbJko8V+d2Bk
         ITejYRbumio+l5FrPtF3/TQz/RCiRAj2IGQYsAgeK2ir/iXw5SQUB2x53myIbuBqugcP
         nAGGy2Irjxt1OHhRNqzNyCpwBRs6tgdfI+GneBJuPHFcYj6CxD4zQxY5FIajRl2hUL7F
         0J0kfsqGNgAI5D/9nnY/gqwZ+HYlsuEoUqRvpRD1Ut9V1ALqCQOmf0UGQltP89g9n/fn
         zDZilaf91l8UYEdYjHDYSxjnfDapxfjYk3X5GYXdVDWwyqFQSrdHgi9h4Nj5wUbGMggl
         lIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732576163; x=1733180963;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wZOY2+Zq+Uw5TtuUXacSqok50DLyY9YzgfmyZp7nZkg=;
        b=shUagO2baUym7N9cB8MLwF7vSNQEP1p8tmZROw+hY4S367GA6KuMTzWdezzt3hr5Rr
         YH8reg+o27Aep3wmfUd/EpMhAdz650LIh1ynP3On2C3PT2Or+nMCf7a0ec0/HddiwIay
         1Xv1N68arUl9Ai5vPJSPt8pfQF4k9Uvs7ikJXlFBF6PY47LxxNr6j5pq+dZWaoSrXjP6
         rMNRwcrRNFpt74tstKQypq4Kdfl2T+P+oz9gWdmmY75gEfDB0cNJoZnt/IRoolYCsDdT
         8EGTja07CnaWP/FPDqEXqEtj2cPOMDhfmjdALx3PIb9Gz6wTwuRTlw97TUrCziDLlrua
         yxWw==
X-Forwarded-Encrypted: i=1; AJvYcCU+1kVIHxP0sp6e5OGcVrv5b2r2Qdvxo8RBUjMZ/MY11wMlOA0DHX1TJAMTpFDA5EpV0uIWL5dlXA==@vger.kernel.org, AJvYcCXuxETze5cfa1MBwmez//NFN7pQXoyawVkaf4b3tZFJTerBxuTxHdSkBtE6sITmVLSc+6sO04k/Uri31gqP@vger.kernel.org
X-Gm-Message-State: AOJu0YynO4/9v3r1pOe/Bk+ZEYwze2Bk3QACd+157rPm8b9atrJzevoZ
	ZrLNtnjfZQDt/kX2OUi2ujHHk6zxBzvBHeu6Q8b/3Kn+OuECv54L
X-Gm-Gg: ASbGnctpty+DqUwdo2Ni943qUwhd5nyTwKMpEmqJmZfosHARUEtD3jNDFqIo7Rf8uEb
	C9hH7csdG8pyLBNtdr79tPIoXCq/ceGCdy4CqCqBUhS6XrgCp0eFtZmsin9+RfiC5CNuPdpl/Cn
	4yxIz2nVZx86xjV5Q/bParw/CN19MMaPXy7t7l0cQwHbO8sdbkGYmcX7lJxB3fUNEmF6BDRdSAs
	ExORlDJT/NUt/hoK1eotPUhU5SBi7X5vwIbPolVUfKaLfI3daCdE1lgK6o=
X-Google-Smtp-Source: AGHT+IEAvhRyubWGmJrGoBa6eObFznxLem+K1BoEP7lNbFWgLmd88TKnPzPEGV/NdKFRegw7oxz2EQ==
X-Received: by 2002:a05:6000:2c8:b0:382:4926:98e0 with SMTP id ffacd0b85a97d-38260be53f0mr12726095f8f.52.1732576163170;
        Mon, 25 Nov 2024 15:09:23 -0800 (PST)
Received: from [192.168.42.143] ([85.255.233.86])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fafedbcsm11803444f8f.41.2024.11.25.15.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 15:09:22 -0800 (PST)
Message-ID: <4db729f9-eece-4732-8d6d-405a997ed35c@gmail.com>
Date: Mon, 25 Nov 2024 23:10:10 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in io_pin_pages
From: Pavel Begunkov <asml.silence@gmail.com>
To: syzbot <syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com>,
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <67406232.050a0220.3c9d61.018e.GAE@google.com>
 <ea5487ba-bed6-4a0a-833d-262bc70cfe46@gmail.com>
Content-Language: en-US
In-Reply-To: <ea5487ba-bed6-4a0a-833d-262bc70cfe46@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/22/24 15:02, Pavel Begunkov wrote:
> On 11/22/24 10:51, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    ae58226b89ac Add linux-next specific files for 20241118
>> git tree:       linux-next
>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=14a67378580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=45719eec4c74e6ba
>> dashboard link: https://syzkaller.appspot.com/bug?extid=2159cbb522b02847c053
>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=137beac0580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177beac0580000
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/fd3d650cd6b6/disk-ae58226b.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/89a0fb674130/vmlinux-ae58226b.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/92120e1c6775/bzImage-ae58226b.xz
>>
>> The issue was bisected to:
>>
>> commit 68685fa20edc5307fc893a06473c19661c236f29
>> Author: Pavel Begunkov <asml.silence@gmail.com>
>> Date:   Fri Nov 15 16:54:38 2024 +0000
>>
>>      io_uring: fortify io_pin_pages with a warning
> 
> Seems I wasn't too paranoid. I'll send a fix

#syz test: https://github.com/isilence/linux.git syz/sanitise-cqsq

-- 
Pavel Begunkov

