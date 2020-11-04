Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD1E2A6CB8
	for <lists+io-uring@lfdr.de>; Wed,  4 Nov 2020 19:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732393AbgKDSc4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 13:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgKDSc4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 13:32:56 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A82C0613D3
        for <io-uring@vger.kernel.org>; Wed,  4 Nov 2020 10:32:55 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id u19so23262075ion.3
        for <io-uring@vger.kernel.org>; Wed, 04 Nov 2020 10:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mAULd+nujD2wZPqhh2z18jHo+mYDmNvMP7vzBg9by5I=;
        b=a+hW+lfjlDTkO0z43Q4dou9J8Sw3wWH7u8HliejxEbep0CG0rB6lwWPDv65PSbWMuj
         jb45zsQhbsqQNzIYIQWMsSStUw32QhgX7mv75X6qOUnaGbG514Yk2AEScCeM0egI3S6V
         zGBxm7yi8TDICuZc8HJsYvL06Ba+zdh0+y4av1NE9dnPI47EYInNty0ocea93KK+xCly
         hjdbXy6crZRWXq5qeEq8khaMXs1wYsoTHsHeFFNIrFwT0UiicBZvjHBOJQ0I8a9xxMWF
         lLA6xwHmds+CaWaCYQYaSPp5XPwsnwHK9Uv/KciaL1x5zuImXp0AthDZsM4GmH3i/7+7
         RgtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mAULd+nujD2wZPqhh2z18jHo+mYDmNvMP7vzBg9by5I=;
        b=FJPD1hyywEdjn7sjWeM+nXxLAknKcdgMJYlN+6d7rpRktvkUtv3keYyQC6+N3h6kQ/
         GGM9hbKaWnbouXCHEsw/bsTk61+KXnrlCf2Wl7VepmfcUZTlK3HL4wpNAh0cjWnbVN1m
         aHkgwGZSmY2KD0g9wO3dyOGSQQdXh+dvR5YksM57lr9WggDS+BbehZjNtZ9weH2Kpqia
         X9ofNfauAvKNIUbfPhVX0UN0iGwFmjTLnt+RJVCkjEr6FW+OrhVzpo/4SuOHuuknCbr4
         u61qV107EDtVgWiFWUsI6j8LGme+WtNGxB82cPnk9NJecOs0W/nLELAbBJUaq39L7hWl
         a6KQ==
X-Gm-Message-State: AOAM533zYiowdTOXGtWsAF9C3JDFbR0jWSzOEYH+Tfd4d7XrtHBMJOG8
        jpyb/rdOyWHZiJIhnBVF+cp6MtxXdDgG9g==
X-Google-Smtp-Source: ABdhPJwlpPKNN3yMr5ON+SeBwsi4XtB9EilYcPlhxNV89ZZ2I4YJ55x8LH51HowpQf5G6/R1E+BhvA==
X-Received: by 2002:a05:6638:d52:: with SMTP id d18mr21502210jak.127.1604514774922;
        Wed, 04 Nov 2020 10:32:54 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x20sm1028398ioh.17.2020.11.04.10.32.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 10:32:54 -0800 (PST)
Subject: Re: [PATCH v3 RESEND] io_uring: add timeout support for
 io_uring_enter()
From:   Jens Axboe <axboe@kernel.dk>
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, metze@samba.org,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1604307047-50980-1-git-send-email-haoxu@linux.alibaba.com>
 <1604372077-179941-1-git-send-email-haoxu@linux.alibaba.com>
 <c2ae5254-d558-a48f-fca2-0759781bf3e1@kernel.dk>
Message-ID: <052a2b54-017f-8617-5d1a-074408d164fd@kernel.dk>
Date:   Wed, 4 Nov 2020 11:32:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c2ae5254-d558-a48f-fca2-0759781bf3e1@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/4/20 10:50 AM, Jens Axboe wrote:
> +struct io_uring_getevents_arg {
> +	sigset_t *sigmask;
> +	struct __kernel_timespec *ts;
> +};
> +

I missed that this is still not right, I did bring it up in your last
posting though - you can't have pointers as a user API, since the size
of the pointer will vary depending on whether this is a 32-bit or 64-bit
arch (or 32-bit app running on 64-bit kernel).

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7e6945383907..2f533f6815ea 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9158,8 +9158,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			return -EINVAL;
 		if (copy_from_user(&arg, argp, sizeof(arg)))
 			return -EFAULT;
-		sig = arg.sigmask;
-		ts = arg.ts;
+		sig = u64_to_user_ptr(arg.sigmask);
+		ts = u64_to_user_ptr(arg.ts);
 	} else {
 		sig = (const sigset_t __user *)argp;
 		ts = NULL;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index fefee28c3ed8..0b104891df68 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -338,8 +338,8 @@ enum {
 };
 
 struct io_uring_getevents_arg {
-	sigset_t *sigmask;
-	struct __kernel_timespec *ts;
+	__u64	sigmask;
+	__u64	ts;
 };
 
 #endif

-- 
Jens Axboe

