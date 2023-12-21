Return-Path: <io-uring+bounces-342-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA01781BB40
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 16:46:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 191421C25D5D
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 15:46:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 560AA4EB4F;
	Thu, 21 Dec 2023 15:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FDr8+EXO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3B4539FB
	for <io-uring@vger.kernel.org>; Thu, 21 Dec 2023 15:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d3efb6bfa3so2401625ad.0
        for <io-uring@vger.kernel.org>; Thu, 21 Dec 2023 07:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703173592; x=1703778392; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1Lh0BKtyrN6yro9u80s5vCgpZBYXmKXJHEdT+0k/Q74=;
        b=FDr8+EXO9DzACRVq9DLbzrnmCMNMI58h9+3DztlZjs9++HEKGqUcCzoRjMsbTZEQXD
         +LkHEP189HUbtFaeScq4wZRZv4FMI/yi0+JHV7ptTfufOIG23V9JxP45P7CLTSZQi0RJ
         K32/0kdCSe/kllBQlJW+RZz40vHoCHRjYpfP9yZBy0YMSJAmsHS48svKo+DDY9G4WsDj
         L5dcBRUui3BQKQCtqITkRF4aGtyy89Xdwfei7RDJ5ZaUHWdiHYUzYluEk87bp3eobJn/
         YtomhUz5O1s8m+WZGd9nHMlj+S4cOd2Xcjlq6XbjvcEf+WYUIhhTg2DqqfzwyBAKs2yZ
         5+QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703173592; x=1703778392;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Lh0BKtyrN6yro9u80s5vCgpZBYXmKXJHEdT+0k/Q74=;
        b=lOy/vjgBth5pcWL9aXaoF8ItmEiTeqNjdINf70nl+ozVuRa9hrZQY4hty+KYLq/YY3
         FwYNOEP0jnVnrpGzcVlyl6T3hJuvkBsDwLepf/76SUTktafPI9XdUMim0v/g0eX8hNjU
         c+Z/+ahTRiHFKjGcXNi3CDkciA0v78i+XDsIxRu+pd9wtg5JI1klZc4rTYorTarQEs32
         2fha6INFxsYTrE7Y/MPVyJpAaf/KZHppkicgxpzHaL4ZVEVXg2DfOESiRQoriXK1sxnt
         /u7XXD66ATL+03m2REL+pBbZlrJv3vwDwOhCPZjhZ0CGhqbfd+cx/6iwYXlz6OAHjVyU
         HYwQ==
X-Gm-Message-State: AOJu0YyDVtNsBNguh3S781CYW9195pQ+K5+FKIh11bDRpBVLhmFzuZsa
	9BFZ6fD2g6RLDD6y7G0D5xItJA==
X-Google-Smtp-Source: AGHT+IE2VNshP+sAbnUUrOxFL6xMZpyArSCAn7aqXcXGUtjj8frJbojM4Xg7E+9w5FA1jvSOWwmbzA==
X-Received: by 2002:a17:902:e88c:b0:1d3:f2df:da26 with SMTP id w12-20020a170902e88c00b001d3f2dfda26mr4798309plg.1.1703173592555;
        Thu, 21 Dec 2023 07:46:32 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id be10-20020a170902aa0a00b001d3c3d486bfsm1784959plb.163.2023.12.21.07.46.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Dec 2023 07:46:32 -0800 (PST)
Message-ID: <c64745d9-4a85-49c0-9df7-f687b18c2c00@kernel.dk>
Date: Thu, 21 Dec 2023 08:46:30 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: KMSAN: uninit-value in io_rw_fail
Content-Language: en-US
To: xingwei lee <xrivendell7@gmail.com>,
 syzbot+12dde80bf174ac8ae285@syzkaller.appspotmail.com
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 glider@google.com
References: <CABOYnLzhrQ25C_vjthTZZhZCjQrL-HC4=MKmYG0CyoG6hKpbnw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CABOYnLzhrQ25C_vjthTZZhZCjQrL-HC4=MKmYG0CyoG6hKpbnw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/21/23 3:58 AM, xingwei lee wrote:
> Hello I found a bug in io_uring and comfirmed at the latest upstream
> mainine linux.
> TITLE: KMSAN: uninit-value in io_rw_fail
> and I find this bug maybe existed in the
> https://syzkaller.appspot.com/bug?extid=12dde80bf174ac8ae285 but do
> not have a stable reproducer.
> However, I generate a stable reproducer and comfirmed in the latest mainline.

I took a look at that one and can't see anything wrong, is that one
still triggering? In any case, this one is different, as it's the writev
path. Can you try the below?

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4943d683508b..0c856726b15d 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -589,15 +589,19 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 	struct iovec *iov;
 	int ret;
 
+	iorw->bytes_done = 0;
+	iorw->free_iovec = NULL;
+
 	/* submission path, ->uring_lock should already be taken */
 	ret = io_import_iovec(rw, req, &iov, &iorw->s, 0);
 	if (unlikely(ret < 0))
 		return ret;
 
-	iorw->bytes_done = 0;
-	iorw->free_iovec = iov;
-	if (iov)
+	if (iov) {
+		iorw->free_iovec = iov;
 		req->flags |= REQ_F_NEED_CLEANUP;
+	}
+
 	return 0;
 }
 

-- 
Jens Axboe


