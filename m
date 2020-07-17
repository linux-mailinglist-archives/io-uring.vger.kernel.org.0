Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69F422407B
	for <lists+io-uring@lfdr.de>; Fri, 17 Jul 2020 18:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgGQQV4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jul 2020 12:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgGQQV4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jul 2020 12:21:56 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF1BC0619D2
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 09:21:56 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k5so5626304plk.13
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 09:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=yzZKnQV3L7Zy0ryxVjSrPHGQljg1QPHpZw/+76EUI1c=;
        b=wQYg9NV3GQ3CoZ3vjLgUjOssEqeot20t865vnv6vkSpOAr/1HcRc4CFwREJitLIJ/c
         bkFUVNEqVCavbLuFCcDBX0PI2jUjTAU79WbqPhc4+dUnc1flojE6IX9PjEQur2ca/akk
         xkUeBNLBS7DY4FC8GMB4qGiunOAvGIXxnY0zbW1x2uC4ngqIUUrquEHNtaj+JJXwMWJu
         /Xa6mgdq/sGNkriwAvcqbDm4bfKfTCzEIDvfWlzB6I61wJyYEMyfC4IyGcu4y3UytDel
         N8smjSNScPRhKR6C47tbRczqq8LWiQ7GHcHwcyE9vI41iUsItlzgL1xpr8+TZ9WDEJWQ
         INxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yzZKnQV3L7Zy0ryxVjSrPHGQljg1QPHpZw/+76EUI1c=;
        b=hZV4EpCUkEcEafPAqO2Y+EWEx4a/Mv9qf32YPzYOd3xDh/J/maJ4cWVoO3kL5dDi1Q
         FStp+qGZq46UGOYnBC1PrHRxgEIhWCh0etgNzpri7RQnN9hFrLyCIEkQC1VgP64X/LNw
         yZRFwie2DSwDLDAa2S1TVajVcfqaptiayzDj2lAZCbAdcjtOWbo1xoCLWrMdchx0tf1R
         YtLKnH7Ja+NtJQP5d/czP4o0aotpZABqWIcjdYlpP87CGHpmqKA6PMCU5L0VlzDPh5mn
         OTDigywr+rK4A0ZPYQpj1s0bAjhf/cEkoz1/MZnF+Fyy6qU//MMiTujH3153dHaeFB5d
         ko9A==
X-Gm-Message-State: AOAM530fCZSdNYFbDIASlUmuAmO3LCsxqvXQTYdxqHFHmeuVxs2fNQnj
        7GYsB+yxobD/mbGiO8BfxiC76E1yZxhHKQ==
X-Google-Smtp-Source: ABdhPJwyCmNHqAPKVrBx+pi2HxhLYkA3kaX8DaFpKlgDomq3gePvRFoCRDB9BecI6KCgECzbu/p9Hw==
X-Received: by 2002:a17:902:b786:: with SMTP id e6mr8584307pls.88.1595002915071;
        Fri, 17 Jul 2020 09:21:55 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id cl17sm3243104pjb.50.2020.07.17.09.21.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 09:21:54 -0700 (PDT)
Subject: Re: [PATCH] io_files_update_prep shouldn't consider all the flags
 invalid
To:     Daniele Salvatore Albano <d.albano@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <CAKq9yRh2Q2fJuEM1X6GV+G7dAyGv2=wdGbPQ4X0y_CP=wJcKwg@mail.gmail.com>
 <CAKq9yRiSyHJu7voNUiXbwm36cRjU+VdcSXYkGPDGWai0w8BG=w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bf3df7ce-7127-2481-602c-ee18733b02bd@kernel.dk>
Date:   Fri, 17 Jul 2020 10:21:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAKq9yRiSyHJu7voNUiXbwm36cRjU+VdcSXYkGPDGWai0w8BG=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/17/20 10:13 AM, Daniele Salvatore Albano wrote:
> On Tue, 14 Jul 2020 at 18:32, Daniele Salvatore Albano
> <d.albano@gmail.com> wrote:
>>
>> Currently when an IORING_OP_FILES_UPDATE is submitted with the
>> IOSQE_IO_LINK flag it fails with EINVAL even if it's considered a
>> valid because the expectation is that there are no flags set for the
>> sqe.
>>
>> The patch updates the check to allow IOSQE_IO_LINK and ensure that
>> EINVAL is returned only for IOSQE_FIXED_FILE and IOSQE_BUFFER_SELECT.
>>
>> Signed-off-by: Daniele Albano <d.albano@gmail.com>
>> ---
>>  fs/io_uring.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index ba70dc62f15f..7058b1a0bd39 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -5205,7 +5205,14 @@ static int io_async_cancel(struct io_kiocb *req)
>>  static int io_files_update_prep(struct io_kiocb *req,
>>                                 const struct io_uring_sqe *sqe)
>>  {
>> -       if (sqe->flags || sqe->ioprio || sqe->rw_flags)
>> +       unsigned flags = 0;
>> +
>> +       if (sqe->ioprio || sqe->rw_flags)
>> +               return -EINVAL;
>> +
>> +       flags = READ_ONCE(sqe->flags);
>> +
>> +       if (flags & (IOSQE_FIXED_FILE | IOSQE_BUFFER_SELECT))
>>                 return -EINVAL;
>>
>>         req->files_update.offset = READ_ONCE(sqe->off);
>> --
>> 2.25.1
> 
> Hi,
> 
> Did you get the chance to review this patch? Would you prefer to get
> the flags loaded before the first branching?

I think it looks fine, but looking a bit further, I think we should
extend this kind of checking to also include timeout_prep and cancel_prep
as well. They suffer from the same kind of issue where they disallow all
flags, and they should just fail on the same as the above.

And we should just use req->flags for this checking, and get rid of the
sqe->flags reading in those prep functions. Something like this:


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 74bc4a04befa..5c87b9a686dd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4732,7 +4732,9 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->flags || sqe->ioprio || sqe->buf_index || sqe->len)
+	if (req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->buf_index || sqe->len)
 		return -EINVAL;
 
 	req->timeout.addr = READ_ONCE(sqe->addr);
@@ -4910,8 +4912,9 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->flags || sqe->ioprio || sqe->off || sqe->len ||
-	    sqe->cancel_flags)
+	if (req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags)
 		return -EINVAL;
 
 	req->cancel.addr = READ_ONCE(sqe->addr);
@@ -4929,9 +4932,10 @@ static int io_async_cancel(struct io_kiocb *req)
 static int io_files_update_prep(struct io_kiocb *req,
 				const struct io_uring_sqe *sqe)
 {
-	if (sqe->flags || sqe->ioprio || sqe->rw_flags)
+	if (sqe->ioprio || sqe->rw_flags)
+		return -EINVAL;
+	if (req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT))
 		return -EINVAL;
-
 	req->files_update.offset = READ_ONCE(sqe->off);
 	req->files_update.nr_args = READ_ONCE(sqe->len);
 	if (!req->files_update.nr_args)

-- 
Jens Axboe

