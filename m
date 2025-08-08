Return-Path: <io-uring+bounces-8904-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE836B1E87E
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 14:38:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F5923B9C2A
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 12:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D502797B1;
	Fri,  8 Aug 2025 12:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OIERPGqt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96FD1CAB3
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 12:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754656685; cv=none; b=T3CB8Q1f4OQlgwgob4uL0IMc3DluW/VpbeZkxA4MaxC2ckaaTfm9hIXHizEmZ7S44cFFEgi/AB+gxT/ygUeLGHdIxk9g+iDuVW3qPgMf+4taefA1yFLl490PYRCGrEwM1J33TP2b7bKSZHqS4ny+GJubIv1HaJXWSxUoUxDUmO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754656685; c=relaxed/simple;
	bh=npalT/8QO6lw78o58J3uBApiPSfitDFzKf7CTMqMokQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=izq+nTTRfafWT5jXuweZKFSQZ0rZIhRmAIYfMBITgHa4Zuy4n1gu/Q4GnI5DKYy8FSg/XwY9AimyTe+tOOoJ56iolTF+HhSbrShJps4ZP1lQ+FPb2ugGThufcc+M0F9BPNAgv+uNnvDRzgjds6z2wVdjsaGQlV9r/9FBYQoHmhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OIERPGqt; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-23c8f179e1bso28663135ad.1
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 05:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1754656682; x=1755261482; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7nYv65QLcd8UEW5OR9mcPXDLjPJAlMx7YfY+s3XfWB8=;
        b=OIERPGqtaFnaJwMO+uiLgFHWVY/wnJKn56ewf/rbKol0vT2fbu8Ja4lW8ATfFIwapg
         mXoVE20liGVynYxvNRfuGlWHouGmBdf4BlmWxD7DQxqAyTXRotBykXrMcj+p9N/SvzUA
         C3kBYpx2HcjwOvEboTF3rOHjmrQI2iZ68AWOayTJQU+fbo0sGjfrG+t9eGYOBvsvYQ3V
         9H97DvqIhdaLqIHQ/RTNovCb4UhPWU97iQBAqUbcA8EhMmwb8ycXwtNZ+MfiqzYUobaa
         CwsA+xbPuNRGfqp0DIgJ4tafh90hHK1q7PUNnoIX7wu1iFaI4MKm+EMo9U0xTRNR7pdL
         QuEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754656682; x=1755261482;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7nYv65QLcd8UEW5OR9mcPXDLjPJAlMx7YfY+s3XfWB8=;
        b=AKjNR6/QZPAR11XyigP4NrDRgNu90+zccUBtuLgjcPs8Wzn9E6JUK0AFdZ/ZhAv24q
         feQc8hobLGJOOx3ehchtXSyad/7AfgjRY7qBq8bAj+bceztAPPjZOIsq/y1bjvL019YR
         isC6D1MUdKR6G+UyONQNDL3z0bBkfzpFL9RhsxwnVZlXH2DH1iJw14111flguAvWpIN4
         5vfzEO5SykGiuBCJNibgdIS+4djFdl9PAlaopRufF7UwzCo+QUESwcoKusor9VwQpbjQ
         wcFQ7C6pRUASRJlrjXgGDIr1yDqWQSJvUXdGq7M92dkZ6DLSFn9vsetHQuWZGqFixLGb
         1ORA==
X-Forwarded-Encrypted: i=1; AJvYcCUDysYKPxl5SiYcANS11OYaBDnq5wnpf0u7h9McXrfGLb3ttnezyecB+ayvpo/XowzGuV7z82vw1A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzINez9noSFPMQqsdVVfMUS/OaNHR365clwslHQvH6OJbUg9YU7
	yBdZYFRnlOPRvnkeP+DL/LWrBzeifqqXu2JZ2kr2LnRiOhd1EbvLwJ2ZvhGsz9VWiAA=
X-Gm-Gg: ASbGncsWa8l/xDQ8to2nxbKR3sTWdxj1rFO2QvIpo+vehy0EW9Aq4wmK06S10tfl12z
	jJJNhOZDQCx72nDyEPj60/JW3d4C9erpLKxAoi+UVA8eLbbqE3b7SXnrZgyVApN1WyZA3SPJchT
	fbTjLtHoH8o2rL7swy5jN4G57MF2t6+AKNyotxWlNiMICnQYuoWhG4jXR4ut9/t7gwEg/ZBXQJ3
	qONhPNr65YM/YYyau96FDLEfKDXghGPu7H7Y836hjTqX0Z7LVeixURRbzTzdQeXoeA7Yy7Ro5Jq
	fWFqaXhhs0CNMzPv3wDnvi8pf4fGB8y+sje11jty/EAGv5nOzv/4CZdGmainR0g9V+iGhSHXbG4
	6oh0SgxXr8GDiM01d00zg
X-Google-Smtp-Source: AGHT+IFe3L6GdF8vbl9AdxCmgfV+mpm1iGs/ucyZNOfOA8Sh66cHUp/+TjdrbyUid8dxHNkBZLN/jw==
X-Received: by 2002:a17:902:d481:b0:223:619e:71da with SMTP id d9443c01a7336-242c225767emr50293615ad.49.1754656681999;
        Fri, 08 Aug 2025 05:38:01 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1f0fb3csm207239045ad.61.2025.08.08.05.38.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 05:38:01 -0700 (PDT)
Message-ID: <c04ad55a-7c66-4e30-bc22-e05682eeb10e@kernel.dk>
Date: Fri, 8 Aug 2025 06:38:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in __vmap_pages_range_noflush
To: syzbot <syzbot+23727438116feb13df15@syzkaller.appspotmail.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <6895eebc.050a0220.7f033.0061.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6895eebc.050a0220.7f033.0061.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/8/25 6:34 AM, syzbot wrote:
>> On 8/8/25 2:17 AM, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    6e64f4580381 Merge tag 'input-for-v6.17-rc0' of git://git...
>>> git tree:       upstream
>>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=166ceea2580000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=5549e3e577d8650d
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=23727438116feb13df15
>>> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10202ea2580000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140a9042580000
>>
>> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git> 
> 
> want either no args or 2 args (repo, branch), got 5

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git


diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 725dc0bec24c..2e99dffddfc5 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -156,7 +156,7 @@ static int io_region_allocate_pages(struct io_ring_ctx *ctx,
 				    unsigned long mmap_offset)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
-	unsigned long size = mr->nr_pages << PAGE_SHIFT;
+	size_t size = (size_t) mr->nr_pages << PAGE_SHIFT;
 	unsigned long nr_allocated;
 	struct page **pages;
 	void *p;

-- 
Jens Axboe

