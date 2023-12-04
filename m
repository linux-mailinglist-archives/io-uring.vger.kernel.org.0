Return-Path: <io-uring+bounces-222-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CCDA0803E6A
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 20:33:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8083328112B
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 19:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A1D531745;
	Mon,  4 Dec 2023 19:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HWdaDdQP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123D6B6
	for <io-uring@vger.kernel.org>; Mon,  4 Dec 2023 11:33:16 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-35d374bebe3so3614265ab.1
        for <io-uring@vger.kernel.org>; Mon, 04 Dec 2023 11:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701718395; x=1702323195; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VPLyZ99seCPicBCXDZB9lqIEFSMnRlWV8gcxMk/enRM=;
        b=HWdaDdQP3ltISdSCmnLELXLyDYbmEIkSPNq7+iRhMRohQne+toMA26NV7TIZAaWfCz
         Gl9qadg2vNgjXVLYMhucmflzexcjjRwCNweq3jtJN2muO5voL92QWhSj4A17+nV/zNtw
         El4LYiFkpLhWypQnGyIxKZd3VooMXdnSACkXa84LkmYbADNJ9RU0rqN36+lM6LP49kEI
         JbsOMJOxkuWC8GGSl6X4BID25YsyV5IzthOqLP5uDNxG2R4YGQaV+s6eoZLVEi5OBaBN
         +9k/Go8PYwgvOIzTSROglpJLtoCRdaN2+B0mDFwKYMDwEuraJXLryt0egI90zz5fox3+
         xp8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701718395; x=1702323195;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VPLyZ99seCPicBCXDZB9lqIEFSMnRlWV8gcxMk/enRM=;
        b=uMb4eDYCTP2kCGHF28D1xZo30aieqm9aulk6rLPDTAIIUwQ3LEMNXPdfdhdsVW9HvS
         ihjm6YK7bMOtpX8BhR+IAIMD6LZUZhosDhkCJKWJMdIVEOXZ9W6k5+zM9CHWMVFqhjqA
         ctWhLa5YWe+dWRISJ7uWSnuSdXH7+taLF6FbmAk28hnMDmS0Uu5cTWIPOE0pmpuqWevd
         jQdVrTR2aCon+0ZLx74AUZyexRL6afEDqy9iUcjBnhfvxiQCAV51vyPDyWBeBdkakwV4
         /25KQWvyZTk+vAlXxBP+PPFazL/56LOU37a7qYxqfB8eOhr4r9XHQXvun0KxsqUpRh+Z
         /fbQ==
X-Gm-Message-State: AOJu0Yw270iYj/s7wL+xtHvILac3zpGDW9fINrMWtzaYFxpGaE5ZrWgX
	Xe/9E5b4I55yPA2+ceFxNS3L2Nhkf9oRn7JIoxwfTw==
X-Google-Smtp-Source: AGHT+IGkrKaGiFhAp7oK0f4BIQy2oFELmC3jxP+vwpzj8s/Gl4T3A6gIJhi/I7plWsz2YyH/VgUi4A==
X-Received: by 2002:a05:6602:2245:b0:7b3:5be5:fa55 with SMTP id o5-20020a056602224500b007b35be5fa55mr33072956ioo.2.1701718395387;
        Mon, 04 Dec 2023 11:33:15 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id y14-20020a6be50e000000b007b35a715c92sm2857601ioc.24.2023.12.04.11.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Dec 2023 11:33:14 -0800 (PST)
Message-ID: <aac915ff-6726-4463-985e-9401228404ca@kernel.dk>
Date: Mon, 4 Dec 2023 12:33:13 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] iouring: one capable call per iouring instance
Content-Language: en-US
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, linux-nvme@lists.infradead.org,
 io-uring@vger.kernel.org, hch@lst.de, sagi@grimberg.me,
 asml.silence@gmail.com, Keith Busch <kbusch@kernel.org>,
 linux-security-module@vger.kernel.org
References: <20231204175342.3418422-1-kbusch@meta.com>
 <x49zfypstdx.fsf@segfault.usersys.redhat.com>
 <9c1ee0ee-ccae-4013-83f4-92a2af7bdf42@kernel.dk>
 <x49sf4hsrgx.fsf@segfault.usersys.redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <x49sf4hsrgx.fsf@segfault.usersys.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/4/23 12:22 PM, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 12/4/23 11:40 AM, Jeff Moyer wrote:
>>> Finally, as Jens mentioned, I would expect dropping priviliges to, you
>>> know, drop privileges.  I don't think a commit message is going to be
>>> enough documentation for a change like this.
>>
>> Only thing I can think of here is to cache the state in
>> task->io_uring->something, and then ensure those are invalidated
>> whenever caps change.
> 
> I looked through the capable() code, and there is no way that I could
> find to be notified of changes.

Right, what I meant is that you'd need to add an io_uring_cap_change()
or something that gets called, and that iterates the rings associated
with that task and clears the flag. Ugly...

-- 
Jens Axboe


