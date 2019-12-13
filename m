Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1A811EA5F
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2019 19:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbfLMScl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Dec 2019 13:32:41 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:37107 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728660AbfLMScl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Dec 2019 13:32:41 -0500
Received: by mail-il1-f193.google.com with SMTP id h15so240742ile.4
        for <io-uring@vger.kernel.org>; Fri, 13 Dec 2019 10:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5Ho3srihBAE8WuqzThl+Cpq/uBCrB5qBgKR3HmQKsxU=;
        b=1rG8VDBf1RzS6fLt6IZMvsGREvW/pB39avCyZC+RA7z8lS+72OOEAbK0AX/E4uEFi9
         1pcAEAISjkBkzz+s+qx+f6cv0K9X7/PKhCumokvg8oGTO30cCYTkOrdcrjxq1X2C5lqy
         40hX1py4b2WRqaGyi5TvYrHNZ19KSfHiXoTvwmneHfOx1mumq1q2mFU5JK/N2pplYOU5
         fo3zlX0iSQ6zrkh9qTgOKKyf94r3l4pSZIeDIlslhIlpGLDzKAWtBaafMApfkfOp01Wx
         /qfgef5eZtzAUW50+Cbtkj1ePMHN/+TELH2qeHCu4um3Me98g9gkx6CNV0hWbFfvvxyh
         droQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Ho3srihBAE8WuqzThl+Cpq/uBCrB5qBgKR3HmQKsxU=;
        b=areDK+qljWGdVlDrCfGl1caceR8mk9Ox/6uHPaLBDSOtS6RnAHGeoU8141jVuuXT9d
         FSSyLDu/G751QRUud8BwW8V6htGtsETR+HTNbsxA+6hEL/I1dklFE8PHP5LLC5g90jHU
         SrBkfcRW6iQl70nHIVR4Kac6h4WSeCD+/xpvvvGzzx7zhf8Tj2f7XynwTCnWZFlYiVui
         u3y3uF/0CbcxqpScCdIzmYluIl+d5ZjJwrAv8zhMQrn/IoVEO6kVQKUS+iErGtYXbZQy
         5X2ypn2FSyhNhqT5126oImK95tdTKTH8j/s1b0qUaVC5piaPxMq2hNvM/FCS+sccZAu5
         sPRQ==
X-Gm-Message-State: APjAAAUnrG7zuuz6LWja1dsiA0eH1TLaHiV4Wh/+MCyionx0Axm7W/Vn
        JGXKZYLa+h7GXx2e0vFoJGwtELdVhUq1Lg==
X-Google-Smtp-Source: APXvYqxFDpLVReulOVdecp1lbQgbQm2TE7vxx9BZvzbBgtzQrBAFdqkoMHu0SeY1Znwi8Kg3Ce8/CA==
X-Received: by 2002:a92:d806:: with SMTP id y6mr687452ilm.234.1576261960431;
        Fri, 13 Dec 2019 10:32:40 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r22sm2942913ilb.25.2019.12.13.10.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 10:32:39 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: don't wait when under-submitting
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <5caa38be87f069eb4cc921d58ee1a98ff5d53978.1576223348.git.asml.silence@gmail.com>
 <21ca72b0-c35d-96b7-399f-d4034d976c27@kernel.dk>
Message-ID: <9fbb03f4-6444-04a6-4cfb-ee4b3aa0bcd1@kernel.dk>
Date:   Fri, 13 Dec 2019 11:32:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <21ca72b0-c35d-96b7-399f-d4034d976c27@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/13/19 11:22 AM, Jens Axboe wrote:
> On 12/13/19 12:51 AM, Pavel Begunkov wrote:
>> There is no reliable way to submit and wait in a single syscall, as
>> io_submit_sqes() may under-consume sqes (in case of an early error).
>> Then it will wait for not-yet-submitted requests, deadlocking the user
>> in most cases.
> 
> Why not just cap the wait_nr? If someone does to_submit = 8, wait_nr = 8,
> and we only submit 4, just wait for 4? Ala:
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 81219a631a6d..4a76ccbb7856 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5272,6 +5272,10 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>  		submitted = io_submit_sqes(ctx, to_submit, f.file, fd,
>  					   &cur_mm, false);
>  		mutex_unlock(&ctx->uring_lock);
> +		if (submitted <= 0)
> +			goto done;
> +		if (submitted != to_submit && min_complete > submitted)
> +			min_complete = submitted;
>  	}
>  	if (flags & IORING_ENTER_GETEVENTS) {
>  		unsigned nr_events = 0;
> @@ -5284,7 +5288,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>  			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
>  		}
>  	}
> -
> +done:
>  	percpu_ref_put(&ctx->refs);
>  out_fput:
>  	fdput(f);
> 

This is probably a bit cleaner, since it only adjusts if we're going to
wait.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 81219a631a6d..e262549a2601 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5272,11 +5272,15 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		submitted = io_submit_sqes(ctx, to_submit, f.file, fd,
 					   &cur_mm, false);
 		mutex_unlock(&ctx->uring_lock);
+		if (submitted <= 0)
+			goto done;
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {
 		unsigned nr_events = 0;
 
 		min_complete = min(min_complete, ctx->cq_entries);
+		if (submitted != to_submit && min_complete > submitted)
+			min_complete = submitted;
 
 		if (ctx->flags & IORING_SETUP_IOPOLL) {
 			ret = io_iopoll_check(ctx, &nr_events, min_complete);
@@ -5284,7 +5288,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
 		}
 	}
-
+done:
 	percpu_ref_put(&ctx->refs);
 out_fput:
 	fdput(f);

-- 
Jens Axboe

