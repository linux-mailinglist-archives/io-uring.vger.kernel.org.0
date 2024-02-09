Return-Path: <io-uring+bounces-593-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 38E6F84FF80
	for <lists+io-uring@lfdr.de>; Fri,  9 Feb 2024 23:14:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88BC6B22A92
	for <lists+io-uring@lfdr.de>; Fri,  9 Feb 2024 22:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B477E25610;
	Fri,  9 Feb 2024 22:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kYFmOjvL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D1D6AA7
	for <io-uring@vger.kernel.org>; Fri,  9 Feb 2024 22:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707516858; cv=none; b=gRxJ4XHYHnJt/jtgGhcylD+PsCiiskbIRQj0zpkRbWMvzAN/4IikQzSCg5pJ3cmz5sRuxmIIxOyUN7uSHrnXk1yvV58uq1IoRFdQOl5GNrC1N5rxbBA0UEcPG2t6zTE6/rQL/dEqPGdmFDBR18fI05F1jwjM6NijWNeRLaV22cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707516858; c=relaxed/simple;
	bh=rHZgrCLeMlII+qi8FZ1rKBlMwnLdJdbS7Gn8kvBazlQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZYvyuIONXL+9M7yRqXZ5epzZ4fasOm90xesbecvc6pzx/DkAbukEG+n+rNz06sVx5nu3GB5zFIrrhZvBcrVj9PTWpuwh9WkXGEYYIG/2zyh2RTum96VCpK91qT6W9mnTf0L4ssKc+5KetXDDHifp2l3EJ3lOfdAU2zAUloFauZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kYFmOjvL; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-35d374bebe3so1506695ab.1
        for <io-uring@vger.kernel.org>; Fri, 09 Feb 2024 14:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707516854; x=1708121654; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iHHrEy1QU6/3tm3dziYnjNjm04AxZNfRHfWpI6uOyB0=;
        b=kYFmOjvLHQyTMTG5jhC96gYFMaI0sMf/DSHh6RnQCB7KJVnT7g8bbgphVW5gK3pmr2
         StkE8IOW1oWw19cuoRuSRIeCzJwOFKfTI6ZP+bJtm1fCW3PW02mKI7Qk+B1hyRlF0hmv
         FNrTbsnPLWPb9jk85aZsFKygV8BzMzJ5chSFS3TuV/oAPzdFhR0DWDOBaVabKjnmxanw
         gcxfJrDyJPVGb5ADGs9b67VsrEqyZWF80ysHQ1ZSIiVmtoU9U3p7tBF+9CoaBJAN6TCE
         8D7MYXlhlaXCWAoLxFyMn23Oep2frzpUv0XptAFEd2S3KjXKlZPTydzNX6Z7VwEHmHrM
         QR9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707516854; x=1708121654;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iHHrEy1QU6/3tm3dziYnjNjm04AxZNfRHfWpI6uOyB0=;
        b=LwuuVDSrrrP/kd/80DJE1vjnMVV7soerSHuOve+tQPDd5u7lWjJjGqgdOrXf8/WM7H
         fQutC7h3IoKpbcHIUg0NBJxrjSMsMH9W658mGcElNdw+8BH3FaT3aAYnM1QcT772t+59
         frExTW2J7fJEzWlquuQFyirEA1gs8fxfdCnXHZN2gex6uaHXOt4LX28GMew3f/rcbCL+
         26de4m6TdIB+yafwi22vZ1Lols0Xw3mAm6o5e9StipQj2tEtjXBi5u66S6vJ/8DTAt9b
         198AurDqIOfgKpo9E4Zgcpm0GJxo6lBFcZ2+mhRoXzeCUftom//p48EP0rVWdtHTjOWI
         eLvA==
X-Forwarded-Encrypted: i=1; AJvYcCXLFU1O9wFzA0F1y9ZgWSto3knVLT68H4XObDva3OtVlEoklSaJYVCL0d2DIDTg1m1lOaaXvXvGNczEV7prFuPEiNxXhC4yraQ=
X-Gm-Message-State: AOJu0Yw8b5S/VPp8Kvep6nDWEsul0ciNuP/meLCCLYfrYpSeJwgDToro
	ADfWWW8DwcHa4LodGrhVNsI+fXUpcbo6/PeSuDtwHSwWHFqXKNZW2M4T8Uytm/k=
X-Google-Smtp-Source: AGHT+IE38G6ozuG6sB1WL3hQGUavb4WA/MOVVouMtOWmenub5ifqgVK5HeJdmoU6BqmBpeTrR2Tafg==
X-Received: by 2002:a5e:8c11:0:b0:7c4:1966:63e3 with SMTP id n17-20020a5e8c11000000b007c4196663e3mr794385ioj.2.1707516854288;
        Fri, 09 Feb 2024 14:14:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWHCzhgiLUxWyPqAqvdXPYUtFjW+UMQ93fBJp3wmGN3XlSU3wtWn9aKfBg0SVdLj6C2emVIhnvCGQeQYV5C2B2kFSesgnmJfBmJ3k6nF4lE8JK1Zdyvk/sZh7B4xGCo9t1BRAuMxlN/3fwdNrzIlgm8rJVoN22RWo0EM9b0ROxSHpwJ2FSOaVoiHQDsQyUAiaElgbT4G7aZOkHMcCUHgWM=
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j28-20020a02cc7c000000b004711fb50f8dsm82492jaq.159.2024.02.09.14.14.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 14:14:13 -0800 (PST)
Message-ID: <f7a6623d-b55f-4301-be1d-ee0327ebd353@kernel.dk>
Date: Fri, 9 Feb 2024 15:14:11 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_rw_fail (2)
Content-Language: en-US
To: syzbot <syzbot+0198afa90d8c29ef9557@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000004b1fa70610fa3230@google.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0000000000004b1fa70610fa3230@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/9/24 3:10 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9f8413c4a66f Merge tag 'cgroup-for-6.8' of git://git.kerne..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1743d3e4180000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=656820e61b758b15
> dashboard link: https://syzkaller.appspot.com/bug?extid=0198afa90d8c29ef9557
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

This was fixed a while back, not sure why an old kernel is being tested. But
in any case, the result of this was just garbage in cqe->res for a request
that was prematurely errored. Nothing to worry about. In any case:

#syz fix: io_uring/rw: ensure io->bytes_done is always initialized

-- 
Jens Axboe


