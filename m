Return-Path: <io-uring+bounces-7262-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02F40A7345A
	for <lists+io-uring@lfdr.de>; Thu, 27 Mar 2025 15:28:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B376175305
	for <lists+io-uring@lfdr.de>; Thu, 27 Mar 2025 14:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44DD521772A;
	Thu, 27 Mar 2025 14:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vEAVHh8v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21B3217F32
	for <io-uring@vger.kernel.org>; Thu, 27 Mar 2025 14:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743085652; cv=none; b=PL/0evQoRWX1iqMqHAP5lba/hC3gAPJEfrqNgJeAAWvy2GM4b21NoZ+ZZzMkpFg5KUPIWFbY2WA8hASyZdIAvjoAcVou6v/TdjS3GNgr+XZfSb8KtEE92OqEqVVv7fbLjzb3JKA2BLQ6XC3Pd33VumFGVIfvc55577jZZM5sSXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743085652; c=relaxed/simple;
	bh=W38Dwex5GU4zaAGSixDudlie5ntiw0nDMfpf6Mreccw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=UN3DK1odO3JOKltNqQBjtzus8p94dTxxftVO2WL1TnwPKvg2WhhOlTIqm77TNqUXgytAhqzZisS2zoxTE/s1JElmjUArbYmVjGbVnCdJeaDw9uJH76gPLj0CrusID2yazIrW2q5id3rHqY+OUnut5BTyMeFP1/Fh/omAcTiK0MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vEAVHh8v; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-224341bbc1dso21194095ad.3
        for <io-uring@vger.kernel.org>; Thu, 27 Mar 2025 07:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743085648; x=1743690448; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qmh8dsKDaojv1RFds1+r+UWq6ageoFkZuB8OV5Mde9U=;
        b=vEAVHh8vhwLhT9FYFIqPHScfzW7FybwG1mFs6LG69pBnV/BDLzSgpriEfgfCMCNPtl
         zjAru8QmyUigbMKyjL/LRcHE8GcCJdSB2ODNHQJC0HrJ0R0DQ3OlC+cIH03xnasfQHum
         d7VwSg2c+e86RjLY6/fvNTuHovFUopz1cCVoAh8VID2hSfcP1jfhlZbeqwFpEGGfTibi
         lYFruJhRPkH3858wK7GkUiSKdaQqe2CYZJT9UgBG+st0KyycOP3z0ZPdUavQwoIlqEnv
         CToGlmE5LK0z1AgIA1L+MfbQ2OUjxEo3KnuDv4voDh5vVmVpStViYGK21cdeh6Fw0Hqw
         9bZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743085648; x=1743690448;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qmh8dsKDaojv1RFds1+r+UWq6ageoFkZuB8OV5Mde9U=;
        b=h35Fr245BGiqqkGdgekonV0Q0Wkc3CV0KQj57PGafctbPp4KmEZ936XtNGkBSEaEem
         pr+JhQkLqzB2lMY1/fet4f7ByCAG1m1mYwE8Q3O/xcIIro5V3B4q8602m+PK8b+jpGpC
         VmfmyqdOFFxdbM3RxGGn67/+aU1r03Y7CHSWLCD2T63A7r0v8EPgFBI5yQgkDgKVjM8q
         lDjPGKAsX0ZneND0bmm8XmNPjkiy+LH6wpL1NrFULgqo4M8SvfJb0R1n5O5DxMECMINr
         PCmwpxR7K3jIptsFcSJdDK7dWFyuyRz8CzgSSBciDr6SupRu7Aab6An8Qs4Tzbz+NRUp
         KPYA==
X-Gm-Message-State: AOJu0YxC7y+fqYbdcu6ceXdqKiek2xXI75V7EKM2m8h+IzCDS36vRw8Q
	R7MgxzD+VSwlqF5fPoiKviZff9dvyGqgAqr7I7JgcxPGfkRI4OeA1ho0TWbYIBzQHZS6wRn6Qgk
	LKp8=
X-Gm-Gg: ASbGncs7y/4SAX/ybI6x+F58Lf74zX3rR87LpphrzmwhWHje8mMs+JFNzac2QM+9zYI
	n/Xvjf5Qm0PtLFb0/EZxpz5uib3dNbzGvLfGlxwL1sHPLkz8h45UNFSGpE2v6ham+T6ZbuGf/iy
	xWnZb6HdBdt20BsVpP0KuNvnggBtaKVN6jkJjHAHxrbISUl9sIjiv/7JJhBox9L/xVCoWYkeCuC
	a3Op6IqD6UGQtu6XxtyPe9oMXaRX/sqvhCABnRkfWs5dTSN4tySzyLFgJuxKhiLVKrIV53vCxpz
	hjy8gQiAFuAjTcl/LROpNWV1gdDOO26Q4IJxupVqNW6UV9B5VqeXeG264wG5quFDVOz2DAzv7xV
	qzeyfTWIz
X-Google-Smtp-Source: AGHT+IFAKAJHCmDcskz04m6AoKAPbhjC+lsOjmbS03ctE0DcAoPB70gWhkySMbvlEeypuqe67EMNAw==
X-Received: by 2002:a05:6a21:328c:b0:1f3:32c1:cc5d with SMTP id adf61e73a8af0-1fea2e98ba1mr6320495637.21.1743085648030;
        Thu, 27 Mar 2025 07:27:28 -0700 (PDT)
Received: from ?IPV6:2600:380:863b:551:3a8d:2504:4577:2126? ([2600:380:863b:551:3a8d:2504:4577:2126])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af8a2a4d016sm11055985a12.69.2025.03.27.07.27.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Mar 2025 07:27:27 -0700 (PDT)
Message-ID: <75d2935a-b560-40bb-aed9-d6cfd885b6a9@kernel.dk>
Date: Thu, 27 Mar 2025 08:27:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] io_uring epoll reaping support
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
References: <3ad3c346-1415-45bd-bcb2-2f9b46164f30@kernel.dk>
Content-Language: en-US
In-Reply-To: <3ad3c346-1415-45bd-bcb2-2f9b46164f30@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/27/25 5:47 AM, Jens Axboe wrote:
> Hi Linus,
> 
> This sits on top of the recently sent out zero-copy rx pull request.
> 
> This adds support for reading epoll events via io_uring. While this may
> seem counter-intuitive (and/or productive), the reasoning here is that
> quite a few existing epoll event loops can easily do a partial
> conversion to a completion based model, but are still stuck with one (or
> few) event types that remain readiness based. For that case, they then
> need to add the io_uring fd to the epoll context, and continue to rely
> on epoll_wait(2) for waiting on events. This misses out on the finer
> grained waiting that io_uring can do, to reduce context switches and
> wait for multiple events in one batch reliably.
> 
> With adding support for reaping epoll events via io_uring, the whole
> legacy readiness based event types can still be reaped via epoll, with
> the overall waiting in the loop be driven by io_uring.
> 
> Relies on a prep patch that went in via the VFS tree already. Please
> pull!

And even with having prepared this earlier, guess a big conference dinner
was enough to still make me mess this up. The correct git location is of
course:

   git://git.kernel.dk/linux.git for-6.15/io_uring-epoll-wait-20250325

which is what I get for creating the signed tag later than the actual
PR write-up.

Everything else in the original should be fine as-is, thanks!

-- 
Jens Axboe

