Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2076B11EA1D
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2019 19:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbfLMSWt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Dec 2019 13:22:49 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:34368 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfLMSWt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Dec 2019 13:22:49 -0500
Received: by mail-io1-f66.google.com with SMTP id z193so399957iof.1
        for <io-uring@vger.kernel.org>; Fri, 13 Dec 2019 10:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HpocJd7ZVW8aqsXghWaXWyBEujhMqhHxlf0cK+XS6no=;
        b=Rqg/OvmizrBtTm3kiJrpDSeR1+kUYCkrSayQpyg6tZ1FpM4zpcENIWmluYZCNiLQsf
         mcnIyNhSdvU7L13bX7IFVftUuiEqUZ03dqGoWi8vAT+thWksY7jy0hD/05fwtmRGpZpx
         WjDbYiPt23rEi9W6Ews0hOUuaFpAM+EGAK3+6VhoAqbuoSH4MJTJyZk91WRzw90R0SQk
         3bvTUPIwgI/lq9J/QmW8xtf0t/Emw5AIqCvsQ5IOX1fQ6JqIeLyDUTR0cezcIeaCWFo3
         MDPlTX3F8LKzr7Vjs62YyJNnydUO/HK/ZWS6tTYp5A5a0/xnamNwxE8HxxKMBgojXuBQ
         2l4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HpocJd7ZVW8aqsXghWaXWyBEujhMqhHxlf0cK+XS6no=;
        b=WHRq5gN24mRwZa427UzaRJEAfkN4msbM+VVgCxgMlvYa51zwu+XNv9WUUu31270vw7
         t0mp9aMITkvjI2amG+wb7Uzevg+mqZ1IngFICstF0ubu82WjtyMXSfqCeA2zBCGOEnjN
         IQKMqhyhW2Idue1mu8yKzq6IlZCgudHA9qJWqoDcf2vBzHerZS6P2d9qr9orhmN7jGya
         0vnxVUlA0z6If1xvfmqQaYpoVUMI9XeSf8Dz4vzdcux/BQHa4num91nrhLp5ZbQ/paCY
         QTMYDss3YQBfCCvOjkiOcTNIEHY965PgqiZfP3/+wF2KPAK3RvOSxx1Mmasy3m/T/Zz2
         ZTfg==
X-Gm-Message-State: APjAAAWIIAbk04EPpbhCXyHPZ1KRAPN96eFk9TSoNHE7dqsaI764I3C6
        iaqJy63gLnfumyZrCTQXVlWyFQ==
X-Google-Smtp-Source: APXvYqz+nYGKX4SR4hvzE3Dwrf1y/0vzAsMTfcVHoDmJ3j+QwRWGkOVLGygSmd4UPTRiWG+hkQIUtw==
X-Received: by 2002:a6b:7b41:: with SMTP id m1mr8002940iop.191.1576261368225;
        Fri, 13 Dec 2019 10:22:48 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d7sm3018102ilk.11.2019.12.13.10.22.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 10:22:47 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: don't wait when under-submitting
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <5caa38be87f069eb4cc921d58ee1a98ff5d53978.1576223348.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <21ca72b0-c35d-96b7-399f-d4034d976c27@kernel.dk>
Date:   Fri, 13 Dec 2019 11:22:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <5caa38be87f069eb4cc921d58ee1a98ff5d53978.1576223348.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/13/19 12:51 AM, Pavel Begunkov wrote:
> There is no reliable way to submit and wait in a single syscall, as
> io_submit_sqes() may under-consume sqes (in case of an early error).
> Then it will wait for not-yet-submitted requests, deadlocking the user
> in most cases.

Why not just cap the wait_nr? If someone does to_submit = 8, wait_nr = 8,
and we only submit 4, just wait for 4? Ala:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 81219a631a6d..4a76ccbb7856 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5272,6 +5272,10 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		submitted = io_submit_sqes(ctx, to_submit, f.file, fd,
 					   &cur_mm, false);
 		mutex_unlock(&ctx->uring_lock);
+		if (submitted <= 0)
+			goto done;
+		if (submitted != to_submit && min_complete > submitted)
+			min_complete = submitted;
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {
 		unsigned nr_events = 0;
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

