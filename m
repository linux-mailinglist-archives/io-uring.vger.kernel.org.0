Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C90D29826A
	for <lists+io-uring@lfdr.de>; Sun, 25 Oct 2020 16:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415249AbgJYPxa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Oct 2020 11:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1415166AbgJYPxa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Oct 2020 11:53:30 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C97C0613CE
        for <io-uring@vger.kernel.org>; Sun, 25 Oct 2020 08:53:23 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id o1so1791101pjt.2
        for <io-uring@vger.kernel.org>; Sun, 25 Oct 2020 08:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cgA4yNNSK8ruSsmjELq0D3PyuO9/kXmJ5lH/hpxAfgc=;
        b=XWJ8UplsYgi7trmAWIAgUGJ0Sq7HjQD62uWzRnPaOCkz/IQ7bhvRANBh9kf6dVzrNy
         pRNckn9SkyAqWDXR5XD96Cs2QUu0F8nz6cHvfhhelBZOf1rUsQbHt9UQZxt7QZmy9z4x
         fAdzoxPVjMyGVzk3kWasEYtEUPFhYOsKHBgjGYOKwHYxLTTG+fVM1Wav/e4GNm8ZfXg6
         gYIr/sjOhHJCKwOW9NquVND0N4dxiib+6V3tBlrXJcrqJIBrc+qWO+jlsx3z/0Tfq2K4
         xMAcTv370ukPPBxtvh+TatX7Gz4CT+um2ocBUUOEDqUog7QNmY0VSpELDrnqsXUp1FNY
         BxYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cgA4yNNSK8ruSsmjELq0D3PyuO9/kXmJ5lH/hpxAfgc=;
        b=jiG87toOW2JVlmJf40D3JwzqEj+m+xIq+K/BOdFK3dCDEylN3G2OSIMVUpsoK0H1uR
         NSWDPMurcGCnf7GYCXVS+VfDERfpDguU5PP8cuEDn8LznZ7DBGHXyGh9tfkPzcFL1tcI
         A7HRLpCGtM8yEd2kyDVS0ICoZ+OAwXH0xDCHybhY+s3laICWqL7uLQ9uE0lCULuNdHtV
         typJV8uAitNtIiE4dGmZ0IaYfNo458f3C4zm04jhGRad4XD19+DM8NYvYHM503i0JUl9
         iv3xB2TIEbv41G5jKI+f1C093keXsSPiHpZI/wZ2YMipQ8F5dKjwbAuo4+VVZb8d3JRx
         E0Bw==
X-Gm-Message-State: AOAM5323dSkW0u2xbuqhRoXt44tsbnM5ua/lGQZyKSVKIylu5ufdeMqs
        za7R0CNFBZtAWHoQY6o9zvNYaQ==
X-Google-Smtp-Source: ABdhPJx2Jjl81JB8bQUxJ+TAxWJx5fbuOuLozb0DuvZKwUhqXLaZeZar/8LP98zTioJV9QkQ+kFDTQ==
X-Received: by 2002:a17:90a:f40b:: with SMTP id ch11mr12878914pjb.123.1603641203271;
        Sun, 25 Oct 2020 08:53:23 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g16sm8063140pgm.38.2020.10.25.08.53.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2020 08:53:22 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix invalid handler for double apoll
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <1bf1093730a68f8939bfd7e6747add7af37ad321.1603635991.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1ea94ec7-d80a-527b-5366-b91815496f4a@kernel.dk>
Date:   Sun, 25 Oct 2020 09:53:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1bf1093730a68f8939bfd7e6747add7af37ad321.1603635991.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/25/20 8:26 AM, Pavel Begunkov wrote:
> io_poll_double_wake() is called for both: poll requests and as apoll
> (internal poll to make rw and other requests), hence when it calls
> __io_async_wake() it should use a right callback depending on the
> current poll type.

Can we do something like this instead? Untested...


diff --git a/fs/io_uring.c b/fs/io_uring.c
index b42dfa0243bf..a0147c0e5320 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4978,7 +4978,7 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 		wait->private = NULL;
 		spin_unlock(&poll->head->lock);
 		if (!done)
-			__io_async_wake(req, poll, mask, io_poll_task_func);
+			poll->wait.func(wait, mode, sync, key);
 	}
 	refcount_dec(&req->refs);
 	return 1;

-- 
Jens Axboe

