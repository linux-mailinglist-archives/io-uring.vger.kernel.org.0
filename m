Return-Path: <io-uring+bounces-2656-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4871F9481F8
	for <lists+io-uring@lfdr.de>; Mon,  5 Aug 2024 20:55:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2119280F1F
	for <lists+io-uring@lfdr.de>; Mon,  5 Aug 2024 18:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97C3715E5BE;
	Mon,  5 Aug 2024 18:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QoDLU2Rj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BC915F30D;
	Mon,  5 Aug 2024 18:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722884100; cv=none; b=Q3WR8lTssTlmgTRU+fitdYiuyR3J8Osay4S5YWY1gncnkBGa53WJb8i0jIWsCrPt+HINpcExEZ4WygZB8YbQOZeESj/vsalPeqO8RcgUbEzPdajXZoREvuluw9OK4olKhwsEoK6ouDTuo+xECkiX53Om7d6xhEWO7x2LhXqg7UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722884100; c=relaxed/simple;
	bh=ElScPhTVnoAf1SHZIdj1hCKDQkzxJazthJbB+rL/DmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z7vVqtnZl8X+HDecdWZfaxq6jfN5ixtWtKe1j0fi0CjXaD10rdLtcM+9a+x1yvgZXv1iEm7FcexQQopgqIP5vR5V5uanYOgHJ2VjfpHau/dRhLB9JE1cI722yEluDJe+xgtBDTNag+P9pcU9tz+UavgFPTq8iOtIUdecV36/pDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QoDLU2Rj; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-70d28023accso8166020b3a.0;
        Mon, 05 Aug 2024 11:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722884098; x=1723488898; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UIaYm1BCSBi7PARcW5jRLcINx0sc7JtDKRyhyRFuw+A=;
        b=QoDLU2RjTga+tVdlBHdk+pGRg8lmd0KGr8QkKGpd9UoTh7ufNB4umRW0Qn+szA+FFY
         h5cql7XHp2i2qEKuHfRu05Qfd3aZwD9Br2MPbc3eU6pQj4DnsVGyi2D5rlPkOTNEMGTP
         Nq9jRvAQ8zmt5X4FfzO8EOLQbri/zyNzsG9GrkWieNJYkxNZovb1ppaqhrPgAwWLNz1g
         4EeFTLeA7G2Ay3Wc7eExeGNH7hgCe16i5dZ/nwrB8+lAmIjlkzFO/6nOFUq75i7myzIs
         wa3EYrMn8krTrWQUNbqb1ThomOa973K64uhwz2xrVa6ncCDdXmQpbjOeLwmmjblp4Ip5
         AaXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722884098; x=1723488898;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UIaYm1BCSBi7PARcW5jRLcINx0sc7JtDKRyhyRFuw+A=;
        b=vYDF+D/ETIi66y1FZc9r/zLTt+OkGupCvs/FC7KNiI9iWT36vgjnVqZYzhjYOaKKri
         fJ1A7+898p12q/NSqoMG/ObrB/X+VLOYhAKCPAAdvSJttARQHYw4CedkWyAEWdwy0xCi
         LZzXpqS6q0AtZyC8USYHyCwq9X3E1XGNbXOybXWP0VudKcrL2n7jwq8iX8cHVMbFuFed
         2XmP8wdTzUnqUxYHQK8mBGJEham83gwo2W7VuTz6VKEDvSWDezOMr597nVECmMu/sOiG
         gNvccv/otaxF3GCkjPRhtVBO2petq47diDU9+Exfn4eJ8MGpmM3XQb5gBdhOsTAJSOpa
         I54A==
X-Forwarded-Encrypted: i=1; AJvYcCX6Z3+Rxl+TTQu0UqW9h2KLoAZALIV96vsBtKeiFydffQ3AHEyOHuorP5cInwjc0LMgKxVl6CmXenkGwrL1KZk1zQxqa1/xWG9S5FFMPyDoHLmAL+DAZrDzI+qfHAkieIupo/Njb4Y=
X-Gm-Message-State: AOJu0Yzuwe+nKj64k7OCAuy7JA/RHnYEWVZZ18LUaaY5n9FlNN6r48lS
	Dpl+Sap5QxCN9JaDeZF2lGa8dWGwxuhFBrffWVEn5mwDhOBJXt1ITBFKig==
X-Google-Smtp-Source: AGHT+IEkRk/0cKAShknFsUS2De6F9H9J13c6L+hHXKp6uHIgZdp8NgPPZuMNrirTceJ9g17Fnuogpg==
X-Received: by 2002:aa7:8890:0:b0:710:50c8:ddcb with SMTP id d2e1a72fcca58-7106cf90809mr11508525b3a.5.1722884098186;
        Mon, 05 Aug 2024 11:54:58 -0700 (PDT)
Received: from localhost (dhcp-72-235-129-167.hawaiiantel.net. [72.235.129.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7106ec42759sm5732538b3a.69.2024.08.05.11.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Aug 2024 11:54:57 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Mon, 5 Aug 2024 08:54:56 -1000
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+b3e4f2f51ed645fd5df2@syzkaller.appspotmail.com>,
	asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [syzbot] [io-uring?] KCSAN: data-race in __flush_work /
 __flush_work (2)
Message-ID: <ZrEgAOL9XrhlSPwr@slm.duckdns.org>
References: <000000000000ae429e061eea2157@google.com>
 <8ada52ac-48e9-48cd-afa0-c738cf25fe4f@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ada52ac-48e9-48cd-afa0-c738cf25fe4f@kernel.dk>

Hello,

On Mon, Aug 05, 2024 at 08:23:28AM -0600, Jens Axboe wrote:
> > read to 0xffff8881223aa3e8 of 8 bytes by task 50 on cpu 1:
> >  __flush_work+0x42a/0x570 kernel/workqueue.c:4188
> >  flush_work kernel/workqueue.c:4229 [inline]
> >  flush_delayed_work+0x66/0x70 kernel/workqueue.c:4251
> >  io_uring_try_cancel_requests+0x35b/0x370 io_uring/io_uring.c:3000
> >  io_ring_exit_work+0x148/0x500 io_uring/io_uring.c:2779
> >  process_one_work kernel/workqueue.c:3231 [inline]
> >  process_scheduled_works+0x483/0x9a0 kernel/workqueue.c:3312
> >  worker_thread+0x526/0x700 kernel/workqueue.c:3390
> >  kthread+0x1d1/0x210 kernel/kthread.c:389
> >  ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:147
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

The offending line is:

	/*
	 * start_flush_work() returned %true. If @from_cancel is set, we know
	 * that @work must have been executing during start_flush_work() and
	 * can't currently be queued. Its data must contain OFFQ bits. If @work
	 * was queued on a BH workqueue, we also know that it was running in the
	 * BH context and thus can be busy-waited.
	 */
->	data = *work_data_bits(work);
	if (from_cancel &&
	    !WARN_ON_ONCE(data & WORK_STRUCT_PWQ) && (data & WORK_OFFQ_BH)) {

It is benign but the code is also wrong. When @from_cancel, we know that we
own the work item through its pending bit and thus its data bits cannot
change. Also, the read data value is only used when @from_cancel. So, the
code is not necessarily broken but the compiler can easily generate the read
before @from_cancel test, which is what the code is saying anyway and looks
like how the compiler generated the code according to the disassembly of the
vmlinux in the report.

So, it's benign in that the read value won't be used if !@from_cancel and
data race only exists when !@from_cancel. The code is wrong in that it can
easily generate the spurious data race read. I'll fix it.

Thanks.

-- 
tejun

