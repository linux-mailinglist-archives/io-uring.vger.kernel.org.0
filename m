Return-Path: <io-uring+bounces-4973-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F05E9D6108
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 16:01:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39BB51F217C3
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 15:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8DE31DE2BD;
	Fri, 22 Nov 2024 15:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nBexm9sS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F2B2E40B;
	Fri, 22 Nov 2024 15:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732287693; cv=none; b=g6877xHP49iIyccWzDxd9K3FIFNHdNislfmdMdUoocXbgs405dvDPk49ScvQF1rpC/vvAKCgiefJx8EZi0q2N5fwL+06nhJ2GltFMvCUiPv1f0MnFwMk2WIq6WFBL4+hHanhJsUhybAmsZLGCZchBTQj25YDuMxECoHyTVmFuUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732287693; c=relaxed/simple;
	bh=o2hYbmh6WZb2rbM3LbbvOkv/YlRbcg56XEY86TK1jYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rTD7AeHWZ3dIs0Y79nLobUNp8OCdxTvscEHj4F7JDSTu+UTTaDUySoe5+RcI5moDOVnv/Oj6xDmYiN7V/LNioAo1+FOD0318tLynghCVKwZK/2uBtF6yU7f+ErfiSE1Lu5C9mlig1KEDON8r1aWWDMd6geNRlHM4kJps27IzL4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nBexm9sS; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5d01db666ceso1204814a12.0;
        Fri, 22 Nov 2024 07:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732287690; x=1732892490; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JpNYDmkZcF/Pw3eH99b/3FGi+WkD37GDU4ziFek5GvQ=;
        b=nBexm9sSaYZTWoTC8ihz+KVwmnMXzX7HdiWA4wf2xAOnImlkQmmSk4YoH599QfsKHE
         t2+bJTGDUFv0/yObPsdhttN3Ioa4447wmWaGk1jzujQ/hGJZYHO6c63eldjyjA4hv947
         qICBvUU7So/py8MxQUlh2tabjAG8MwYFv1o9DNYHaXvcCEvDMkSUTJkuzjfrSCsyJL3K
         IK0O6+XVt2h8eRqWQncw4h+AOp3U+Q1nug6RMRabv3SteD7ARc08MMbmmmcfPmvbyh9w
         7rIn7jmAJ7UIJszx5EXczHP3+ynZGhD1WFhLCPQ+iypmwWDijH6KfXqFGh5TYLxDKBFR
         AyQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732287690; x=1732892490;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JpNYDmkZcF/Pw3eH99b/3FGi+WkD37GDU4ziFek5GvQ=;
        b=uT2ny8hAuAyX3Ahk7kGXnHeB16nfv9y0eVB9fQz+pa+2UJmbrtAjvOJeFY5E+ekfPj
         /Ol+RIOmAOukLBNL3R0MEscaA0qxmAVMDM7k9Q39AHEr0qj8pvSzLzOvhK2dRweZBwyt
         y0CuaA2tQ3Wo2a9jQq4HFaBpb783O58j0at68j6QOOyEyVCVTwBatZDUQkvToOFLR8od
         I16kx2EGQ/xizFEmMhaEPYtN0srsxl0Uzx8/v4M5BpAkKG+UT6Px/PLrfRZAv4yFgem9
         Ob+D3ZjwRtkda50CCH/bHw8api3mO2kwQf88xEutVqq3LFwdokoBdWb7xHOVvjKrrKbX
         hpqA==
X-Forwarded-Encrypted: i=1; AJvYcCU12kTQgzHelxBT9kk7GPFGub82HGun4hRxbkmkdt9QVWZOY+7xatqPJOrDOIfjR9FQQEPKDntb3Q==@vger.kernel.org, AJvYcCXwRX/D9iGamrAzx3+OkYCspXU6gTukcoeHhdlEa1sIEG5lM6p+QJLbIwE5yN/DH+bRa97sVPbAhH0gUdeA@vger.kernel.org
X-Gm-Message-State: AOJu0YyAchCQCdFXQ4qbQZpRNLSOYcxK7cBNYXpLEuXcJwsknts8thAk
	jqS/1zXQLit5dTXSzmN1CHfeWluStjb4qO8COf0m+zvBpfXdY+bs
X-Gm-Gg: ASbGncuxI0VwnTxFg8evG7Sem8WPeYbrLFCgYHZde5utygSZe0UvQLL0k9wmKtQ/uTq
	VljCVWtvlSGX21hOlM8nwNux7J3xk1N4Cmj1J6VP6WVWuTjjQMD6nTJxqN6784r/mRAy3co29Wr
	6qGqjyiZpqzss26sneQjUOwgEPB/mdenOGAO+waK5ny/26Qgtsi8ZPCFIobrUHj+iJHrw8Me+NT
	vmR0SW2+hAfpOT3Hiqb/tDlnnizCXQ8DBm7epurzYVqC44czsTh7v35uu6mvw==
X-Google-Smtp-Source: AGHT+IH5AkiN9HBYWdxSNHggPsO4pXattVthUr6Lt5v/dwhOLwTGiovHWjrNBVkAoZPfv6QJxvWK9Q==
X-Received: by 2002:aa7:dcc4:0:b0:5d0:225b:f4fd with SMTP id 4fb4d7f45d1cf-5d0225bf514mr1964365a12.30.1732287689537;
        Fri, 22 Nov 2024 07:01:29 -0800 (PST)
Received: from [192.168.42.192] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d01d3c0458sm1010450a12.45.2024.11.22.07.01.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2024 07:01:29 -0800 (PST)
Message-ID: <ea5487ba-bed6-4a0a-833d-262bc70cfe46@gmail.com>
Date: Fri, 22 Nov 2024 15:02:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in io_pin_pages
To: syzbot <syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com>,
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <67406232.050a0220.3c9d61.018e.GAE@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <67406232.050a0220.3c9d61.018e.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/22/24 10:51, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    ae58226b89ac Add linux-next specific files for 20241118
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=14a67378580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=45719eec4c74e6ba
> dashboard link: https://syzkaller.appspot.com/bug?extid=2159cbb522b02847c053
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=137beac0580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177beac0580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/fd3d650cd6b6/disk-ae58226b.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/89a0fb674130/vmlinux-ae58226b.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/92120e1c6775/bzImage-ae58226b.xz
> 
> The issue was bisected to:
> 
> commit 68685fa20edc5307fc893a06473c19661c236f29
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Fri Nov 15 16:54:38 2024 +0000
> 
>      io_uring: fortify io_pin_pages with a warning

Seems I wasn't too paranoid. I'll send a fix

-- 
Pavel Begunkov

