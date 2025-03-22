Return-Path: <io-uring+bounces-7204-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 695C6A6CB95
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 18:14:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 405141889E5E
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 17:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B39416DECB;
	Sat, 22 Mar 2025 17:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="al1S1atr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2848F22318
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 17:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742663693; cv=none; b=PAJxb3/oz1ZFSJJtKp6yZDPA/rDeaXvMEhy34zPJxG/NLf3aNO3Wzc4cuHs/USK5vRCHFW4SbhnmVseH9u0bHQmW3iin73mjTb80fd1bA3Ie6XCO7OOb1b9bBmbcbf0kvaKFofUBVK/8/5UltxXHSB5tTj+v2ugg+VcG4ZYIjMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742663693; c=relaxed/simple;
	bh=0zEsJRpY0EY1okYRDRyG8eV4NGBgxAeQ2t2EDwGsRVg=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=rDGDgQNr9SYKSboSIa0Y/Ji5bJOcPDsfO3MmvmPtvUCbT5SJGheqVqxkoOw8vp63mM9r5WVUjhMoCQ501ChYF7DLYvO0aF3xS962Nwz+lf2F8nKVIC3aW1Y5rws1i9wxzXHUJUMQ9OEgOpwrJR4PWHimlM3XUlS07Xckdi/9XIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=al1S1atr; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d439dc0548so9065965ab.3
        for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 10:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742663689; x=1743268489; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1oASyvrueWCxjZuLSTQhkkKDLEFdgA+cHHupTlEA3UU=;
        b=al1S1atrzLqqA5RMXNupnrt+Z3RDkyYTuyOmvgc2WSv1jYdw3zyLo0s9xVUzb7c/p1
         29/Ed1qbcrsHAKHYTr1VnZxO7cQp2ZT9ARFVfUzeygebZ2nYvhlrHu4EqiZc9JBAFnnd
         W88Nv78oUqMFCKZveSi+vdiztmSoWwjdPm3uVQQmUWT9ZGwOyZxzs2prHIcZvkL/TiP4
         9anvz4Tq0hYQcE+UMezWSn10ahcOEUO6XY5Ty4Sej5lPbXDKC6FoSzsE92rbDDXLlnGJ
         AQ4PIqPT6FS6GxQbh/8O5zvibgakZE1GNMIUQlkS4l5pKah89SrnXxWN4xbe+9BXl2oW
         4yMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742663689; x=1743268489;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1oASyvrueWCxjZuLSTQhkkKDLEFdgA+cHHupTlEA3UU=;
        b=EP4S5aOrqu9kubqUW+kTtIe3H7Xhj7ks0RH80BzIIdKDbzr0ICZvkqfg9P10N/lMXy
         SybV/mmmo4xYUXLDxMmQVGdxatH6Gm1Qgp8nmm8WEUyHzmh99+B0VU3aAo6+NyJcCOcr
         burbfbM4pezhZU6Y/ZL8Ig8iS4byHK4VLGjiqON6pt59lCozp3T2xPVYv1D89zwiPbq3
         12y1RjMyckwE8ebc57NSoS/i7qj34juvuCtoVAivGne/EZjzwTrtwMgoaKWw8x39OtZX
         Dh4Y3Vu2kZL2zfjFLgnsV27oHmcT/X1ZHCYiw9fyFJdOg+e0IrbddiqwHXCVhU2T8cJw
         62SA==
X-Gm-Message-State: AOJu0Yz3+OPE45ytytK3vN98wAnCH81dydSPrP+S4PsTg2f63LeifbY7
	7WMQUEW2LEtWIekTk97Hd7GKr8/3ODUT3wl4NlwFLU3A9VWT4nyFZjYlcFUn9m+4ncZK9rsWGke
	d
X-Gm-Gg: ASbGncsSnEUQRe0RT4JMWMJBBb7JvBX7JrvJAgw6PmT7GnRc3FTpo8lxtyMzkYOAK1C
	4L0+9SidCUfhw7bBrW0H4kaBNCtAyIdBh0lT0Y75VEFi+IRz5vq1QldxpD1mh1FWIEU8bOFNIW5
	D6BTshqHuj3px78PZrKZlLeiQ8GPsqUbT4s/ZcqUqm3YuQNx7V5otcn2lrEINxF67yil8/1vp9W
	dAVLlmI3oXFP3dgfPUajNAaVf3taHUeKgDr3ERGYxV7omBvfSgseqQ522RzQZuMhVNQ92XFpw2a
	Ud5nBI+UJiO3dnY3JGbTw1qd1D79IBRSGw4uHmNHLQ==
X-Google-Smtp-Source: AGHT+IGvt1kK4jQSHNkn5M/UMk+SGyr2CBhhY+B9YAYlma14Njj8GihRpQFZ748oKsl9EONWo/qemQ==
X-Received: by 2002:a05:6e02:3308:b0:3d0:10ec:cc36 with SMTP id e9e14a558f8ab-3d59610878emr73348435ab.11.1742663689027;
        Sat, 22 Mar 2025 10:14:49 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d5960ceb2bsm9668325ab.51.2025.03.22.10.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Mar 2025 10:14:48 -0700 (PDT)
Message-ID: <da6fddfa-f9a5-4c18-9804-320d7efef6a6@kernel.dk>
Date: Sat, 22 Mar 2025 11:14:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.14 final
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a single fix for the commit that went into your tree yesterday,
which exposed an issue with not always clearing notifications. That
could cause them to be used more than once.

Please pull!


The following changes since commit cc34d8330e036b6bffa88db9ea537bae6b03948f:

  io_uring/net: don't clear REQ_F_NEED_CLEANUP unconditionally (2025-03-20 12:27:27 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.14-20250322

for you to fetch changes up to 67c007d6c12da3e456c005083696c20d4498ae72:

  io_uring/net: fix sendzc double notif flush (2025-03-22 08:14:36 -0600)

----------------------------------------------------------------
io_uring-6.14-20250322

----------------------------------------------------------------
Pavel Begunkov (1):
      io_uring/net: fix sendzc double notif flush

 io_uring/net.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
Jens Axboe


