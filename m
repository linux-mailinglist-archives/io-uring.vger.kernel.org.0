Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376867C8722
	for <lists+io-uring@lfdr.de>; Fri, 13 Oct 2023 15:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbjJMNqB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Oct 2023 09:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbjJMNqA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Oct 2023 09:46:00 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF6DBF
        for <io-uring@vger.kernel.org>; Fri, 13 Oct 2023 06:45:57 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-7a2874d2820so28883539f.1
        for <io-uring@vger.kernel.org>; Fri, 13 Oct 2023 06:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1697204757; x=1697809557; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dy6cR2Hzs2fRj+jqX6DHkTEB1kpzFyCXP4UUU0j0bFE=;
        b=n36tFI7RUEpCypQXtxDuyQFYulIBQv94NME8LYqJZ6k8NdiGShK3vSYFNhNE4KDp0d
         MTBFbe/rihyI+sRO2h3Ke+vOXttE4puJUJgF5znvYKqWlebleZPb9WkZQUbQ88R/qWI8
         pdcN45J+yLWa+I3DjwvvEBvAbJTEVUUA5N41Ho+Y/Ni5/84tt5OtTR89OyPNJ7uBz0dB
         Z6M2ytm1mSw01Hokg+wlKPkeoN1ZTIdsH6k9VYhcBmLB8zsHLsFOYb9dGHq+oHuPg81+
         b8mBzPYSirOx2ro7LTkOrTdDabv4egz4M9WoEajOAk6PduJMFXdzBanSuiN7EmLEeXL2
         gjtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697204757; x=1697809557;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dy6cR2Hzs2fRj+jqX6DHkTEB1kpzFyCXP4UUU0j0bFE=;
        b=SJiZXagp28GLCxmQYUAXvYYaXDKbuS4ALlbPZfaUCqTdOkPPZbADNiqvRZXQK+Ay3P
         oHmrtGFq6DjSd+hADS9H33pa3KyiJfK/E2YnKb5vLhvwiXdRdKf+n7VoaYB+MTDchwQq
         IauRfusVQ8haxXjblQJrezbZaVrQZMawBe0XzqoOGklXQFrxdT6DDsImlYud/LIK/gU2
         G8kn0BkZD1hz55qgnnshTxSyuOdByQGEpmOng7SoZpaU5gbPEZSKCchk5BWjwudp5k1l
         HV5GOSOkKwr1VqvSwjnyGOc1gzRQulgktM8SUOrzkd7ECM69HlIhNGLW4qGQSmXKcY1I
         1KFg==
X-Gm-Message-State: AOJu0YxhJiFqwuwf1ReSfMig2lW1LrK6/tgrkrCrOyRHmdGqQfEgnJSA
        f9RFEB6itXCq+uylIWot/NUoJw==
X-Google-Smtp-Source: AGHT+IGhomw/8wuPVTHe5JDimsPS11whdPVfk1pJcH/40uMu9k60/6M26anDY6AXc9bGj7cgITZbWA==
X-Received: by 2002:a92:dacd:0:b0:351:1ed0:5c6b with SMTP id o13-20020a92dacd000000b003511ed05c6bmr26491258ilq.3.1697204756852;
        Fri, 13 Oct 2023 06:45:56 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id em15-20020a0566384daf00b0042ff466c9bdsm4674760jab.127.2023.10.13.06.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Oct 2023 06:45:56 -0700 (PDT)
Message-ID: <a9dd11d9-b5b8-456d-b8b6-12257e2924ab@kernel.dk>
Date:   Fri, 13 Oct 2023 07:45:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Problem with io_uring splice and KTLS
Content-Language: en-US
To:     Sascha Hauer <sha@pengutronix.de>
Cc:     Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20231010141932.GD3114228@pengutronix.de>
 <d729781a-3d12-423b-973e-c16fdbcbb60b@kernel.dk>
 <20231012133407.GA3359458@pengutronix.de>
 <f39ef992-4789-4c30-92ef-e3114a31d5c7@kernel.dk>
 <20231013054716.GG3359458@pengutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231013054716.GG3359458@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/12/23 11:47 PM, Sascha Hauer wrote:
> On Thu, Oct 12, 2023 at 07:45:07PM -0600, Jens Axboe wrote:
>> On 10/12/23 7:34 AM, Sascha Hauer wrote:
>>> In case you don't have encryption hardware you can create an
>>> asynchronous encryption module using cryptd. Compile a kernel with
>>> CONFIG_CRYPTO_USER_API_AEAD and CONFIG_CRYPTO_CRYPTD and start the
>>> webserver with the '-c' option. /proc/crypto should then contain an
>>> entry with:
>>>
>>>  name         : gcm(aes)
>>>  driver       : cryptd(gcm_base(ctr(aes-generic),ghash-generic))
>>>  module       : kernel
>>>  priority     : 150
>>
>> I did a bit of prep work to ensure I had everything working for when
>> there's time to dive into it, but starting it with -c doesn't register
>> this entry. Turns out the bind() in there returns -1/ENOENT.
> 
> Yes, that happens here as well, that's why I don't check for the error
> in the bind call. Nevertheless it has the desired effect that the new
> algorithm is registered and used from there on. BTW you only need to
> start the webserver once with -c. If you start it repeatedly with -c a
> new gcm(aes) instance is registered each time.

Gotcha - I wasn't able to trigger the condition, which is why I thought
perhaps I was missing something.

Can you try the below patch and see if that makes a difference? I'm not
quite sure why it would since you said it triggers with DEFER_TASKRUN as
well, and for that kind of notification, you should never hit the paths
you have detailed in the debug patch.

diff --git a/net/core/stream.c b/net/core/stream.c
index f5c4e47df165..a9a196587254 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -67,7 +67,7 @@ int sk_stream_wait_connect(struct sock *sk, long *timeo_p)
 			return -EPIPE;
 		if (!*timeo_p)
 			return -EAGAIN;
-		if (signal_pending(tsk))
+		if (task_sigpending(tsk))
 			return sock_intr_errno(*timeo_p);
 
 		add_wait_queue(sk_sleep(sk), &wait);
@@ -103,7 +103,7 @@ void sk_stream_wait_close(struct sock *sk, long timeout)
 		do {
 			if (sk_wait_event(sk, &timeout, !sk_stream_closing(sk), &wait))
 				break;
-		} while (!signal_pending(current) && timeout);
+		} while (!task_sigpending(current) && timeout);
 
 		remove_wait_queue(sk_sleep(sk), &wait);
 	}
@@ -134,7 +134,7 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
 			goto do_error;
 		if (!*timeo_p)
 			goto do_eagain;
-		if (signal_pending(current))
+		if (task_sigpending(current))
 			goto do_interrupted;
 		sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
 		if (sk_stream_memory_free(sk) && !vm_wait)

-- 
Jens Axboe

