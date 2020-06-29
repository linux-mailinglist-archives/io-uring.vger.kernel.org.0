Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9529B20D8EA
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2020 22:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388000AbgF2Tmp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 15:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387985AbgF2Tmo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 15:42:44 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34567C02A575
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 06:43:20 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id c1so784529pja.5
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 06:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pFDlaEalzIHAdq7iJSjFmzlaMvkiuy/ZyvtFdE0t2bc=;
        b=zbOBhIzMxAuVEfKJJ8kNBMf1vs/Bb/Aop71sR4C4klgOfGBE37FaqTxbgvS8Cs2RTk
         KP4raMq37hxpnPvvjqJZHPguC2JFzzgCIYzrv/GOog1/y7hseOGFY75xify9TX1SMK8j
         DvNK15fXXvX2fcL393mz+hYXD0+aN5D2IvGaXOslSFsmUNwSVqRcMVy36UMfkwcliR+1
         rqmCrjl2lIqrMwDfKYTVxwMso8vVf6KR9xk+zgYj3XHNU0n/oQhawzUVid4LnUmJwaSF
         1lh1l0p+DWUt2r0DLlQ415/Cpk5QAYkvHCiAGLLV1hxNOAQs3QRvNdMibu8Py+jVKCZp
         EWvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pFDlaEalzIHAdq7iJSjFmzlaMvkiuy/ZyvtFdE0t2bc=;
        b=fvicbX61Cz5vaePtK8DcWNQSxM7niucygTTDlipxuAcN5iGFQ96KV5oF+8YOAhCCXA
         vusAu5U7Om4SBZY4WMy/BPwQ6x0avdIFhoOR1OZHXxyzdMyUPF0EhOKhuAixfz+Pn637
         4ymAt1S79/94b79IRANlNLJi1zJTM074Bj33GSa7Jc6uzR0acPwz/xH0GJ2u+lkSnyNJ
         PbM+zgkrkKxLcHaM3ZRG9Y2Qfn9yETTDw/aIBeo+MVHsukw5wA4HxmWz1/nR8YCxtdMl
         c9ShPAJn1aNrawHI5zKVbQGep0zi5rcGCHEnRV3QRoUgd8DhR0TVj/WCHXIE7PsCVYBH
         DwoQ==
X-Gm-Message-State: AOAM5301k45RFXHKj8yJNYh6aaVFJpw+BaR9FqvZZDk1zVsHGJ1eABbN
        8QJCnxS6OQ8M87vQ/0A0ZhtDwY4t59pssw==
X-Google-Smtp-Source: ABdhPJwd4V/3XHaEu0v70I+iR3Tua7RhzfqDSCRRjujNerofR2PZZBP1IeBpi5e9CwKf8YyOKml6HA==
X-Received: by 2002:a17:90a:8c96:: with SMTP id b22mr18588927pjo.88.1593438199323;
        Mon, 29 Jun 2020 06:43:19 -0700 (PDT)
Received: from [192.168.86.197] (cpe-75-85-219-51.dc.res.rr.com. [75.85.219.51])
        by smtp.gmail.com with ESMTPSA id 4sm50646pfn.205.2020.06.29.06.43.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 06:43:18 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: fix missing wake_up io_rw_reissue()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <b455c5ffdc7398eb61460669c4a19301320258f6.1593424638.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4834cc78-4780-8f5c-81ea-599ca62147f8@kernel.dk>
Date:   Mon, 29 Jun 2020 07:43:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <b455c5ffdc7398eb61460669c4a19301320258f6.1593424638.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/29/20 3:59 AM, Pavel Begunkov wrote:
> Don't forget to wake up a process to which io_rw_reissue() added
> task_work.

Applied, thanks.

-- 
Jens Axboe

