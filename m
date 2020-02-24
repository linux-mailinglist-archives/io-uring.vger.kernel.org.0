Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAF1816AAA3
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 17:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgBXQDA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 11:03:00 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:40544 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgBXQC7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 11:02:59 -0500
Received: by mail-io1-f65.google.com with SMTP id x1so10762597iop.7
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 08:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=etpoqy9O+gPLI38SL+ssyAss6alHy9mVTRgQbr4VqYU=;
        b=DSMRcNb/AcSIQqY+EkQUgtUmzolOeReMwL6Tv3U+hLeQ2NwiZi4Yj/w0I1bgZtKjvs
         qpzOQdqOSzRVG5nDAA1YNN0jrgMjJgK8vqrs3NVIY6dkRCZY1qKPBSmDxBfRfKGbe6PP
         qHe2m9rU+cTYfEhThkmBuH+VGfM0AmZAaQtzoF1pFcZL5qnlYrP1Lp5yqS8BUJlt19jX
         kU9l8/W7QsMqb1yaMPReu2DnhH8AY/ctkcY4+az14ycQX3FAaobx+rRb7ieP9RX7Yg1u
         lEFhSdGFDDlD9/uDQZ5XMnqv/DxeUH4osF4/JDuJy0MOh224rxmy6rQX1qRUHGDkzM12
         8MjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=etpoqy9O+gPLI38SL+ssyAss6alHy9mVTRgQbr4VqYU=;
        b=CMQcw5ylVgHMzVKSxW0+ILqfpfsVU4q6WBovBufQ4Zhp5ugak/HRdPx0dq/Dp6vfDI
         9uokId4GzzeFmGoAxtsSVTOf6kvXypl+MArY5UMptTitqehzJRdRwF/UkfNAnsVITw/p
         D70/HsII2+v4ip9d0/SnqmaAUqgz5AV2UM6cfmpkrcpPKH2oGxS4ps4fQUd/fZQd2fi6
         ++qVQyL+SrpLntoADLNSbNVf8IcPhfZgtXEx4UUjSeedrRf+nzOczHBvgP2mxs36m0KO
         X+q8qhdn6S+Mx47ZSBVpRz968Q/WrPzG3LJeGeDW5WYCOvVUqY+Ymnaj2NdMboB6vme+
         K5cA==
X-Gm-Message-State: APjAAAXYvBdTRNs0gdV7LbC/kXzMszSvoOFKWZX+jYSfLjkkY64vPiJW
        dLQmeOmiOYLa8enBo6xvIHCEzf7Dcw4=
X-Google-Smtp-Source: APXvYqxrq6aUrVEPzUkFac8zidyP1duN6UyJWLhYP5NxDRg1Y0LyfnSUvn0m2cTrUqHKkpnlgP/1MA==
X-Received: by 2002:a05:6602:20d9:: with SMTP id 25mr49366983ioz.181.1582560178907;
        Mon, 24 Feb 2020 08:02:58 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n9sm3118959iob.45.2020.02.24.08.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 08:02:58 -0800 (PST)
Subject: Re: Deduplicate io_*_prep calls?
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
 <23a49bca-26a6-ddbd-480b-d7f3caa16c29@gmail.com>
 <065ee992-7eaf-051a-e8c5-9e0e8731b3f1@kernel.dk>
 <746b93f0-d0b5-558a-28c7-a614b2367d91@gmail.com>
 <c17acad2-89f6-b312-f591-c9e887b4fc2b@kernel.dk>
 <ad07fe70-ea45-a1bf-21c3-9af241bdef15@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b9901cca-caab-2261-2482-9bf9f81d589d@kernel.dk>
Date:   Mon, 24 Feb 2020 09:02:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <ad07fe70-ea45-a1bf-21c3-9af241bdef15@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 8:56 AM, Pavel Begunkov wrote:
> On 24/02/2020 18:53, Jens Axboe wrote:
>> On 2/24/20 8:50 AM, Pavel Begunkov wrote:
>>> On 24/02/2020 18:46, Jens Axboe wrote:
>>>> On 2/24/20 8:44 AM, Pavel Begunkov wrote:
>>>>>> Fine like this, though easier if you inline the patches so it's easier
>>>>>> to comment on them.
>>>>>>
>>>>>> Agree that the first patch looks fine, though I don't quite see why
>>>>>> you want to pass in opcode as a separate argument as it's always
>>>>>> req->opcode. Seeing it separate makes me a bit nervous, thinking that
>>>>>> someone is reading it again from the sqe, or maybe not passing in
>>>>>> the right opcode for the given request. So that seems fragile and it
>>>>>> should go away.
>>>>>
>>>>> I suppose it's to hint a compiler, that opcode haven't been changed
>>>>> inside the first switch. And any compiler I used breaks analysis there
>>>>> pretty easy.  Optimising C is such a pain...
>>>>
>>>> But if the choice is between confusion/fragility/performance vs obvious
>>>> and safe, then I'll go with the latter every time. We should definitely
>>>> not pass in req and opcode separately.
>>>
>>> Yep, and even better to go with the latter, and somehow hint, that it won't
>>> change. Though, never found a way to do that. Have any tricks in a sleeve?
>>
>> We could make it const and just make the assignment a bit hackier... Apart
>> from that, don't have any tricks up my sleeve.
> 
> Usually doesn't work because of such possible "hackier assignments".
> Ok, I have to go and experiment a bit. Anyway, it probably generates a lot of
> useless stuff, e.g. for req->ctx

Tried this, and it generates the same code...


diff --git a/fs/io_uring.c b/fs/io_uring.c
index ba8d4e2d9f99..8de5863aa749 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -598,7 +598,7 @@ struct io_kiocb {
 
 	struct io_async_ctx		*io;
 	bool				needs_fixed_file;
-	u8				opcode;
+	const u8			opcode;
 
 	struct io_ring_ctx	*ctx;
 	struct list_head	list;
@@ -5427,6 +5427,8 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	 */
 	head = READ_ONCE(sq_array[ctx->cached_sq_head & ctx->sq_mask]);
 	if (likely(head < ctx->sq_entries)) {
+		u8 *op;
+
 		/*
 		 * All io need record the previous position, if LINK vs DARIN,
 		 * it can be used to mark the position of the first IO in the
@@ -5434,7 +5436,8 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		 */
 		req->sequence = ctx->cached_sq_head;
 		*sqe_ptr = &ctx->sq_sqes[head];
-		req->opcode = READ_ONCE((*sqe_ptr)->opcode);
+		op = (void *) req + offsetof(struct io_kiocb, opcode);
+		*op = READ_ONCE((*sqe_ptr)->opcode);
 		req->user_data = READ_ONCE((*sqe_ptr)->user_data);
 		ctx->cached_sq_head++;
 		return true;

-- 
Jens Axboe

