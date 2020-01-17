Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09AA1140229
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 04:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389125AbgAQC76 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jan 2020 21:59:58 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:41809 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389065AbgAQC76 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jan 2020 21:59:58 -0500
Received: by mail-pf1-f176.google.com with SMTP id w62so11228416pfw.8
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2020 18:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=z+YdJeFqFDZRiS6UDwTkhXHC91WQ1PZ11Rxt5I2e+FU=;
        b=OME1BEPmzQ43q7L6b6RwcTDzN4ky8vN6iW5h0/2emyXIECsky7iZXPnqyzRv093ppZ
         lF0W5SFvL5CCJjGYa22yIVb+8y4vpQrqZiwGICPwjOcoZnkUVVipcELGMXwoXaEtdZIG
         dj3GcBd9bPOvsyLDUbzX98O1FdmUNP7uO1rDk3g4htEdgpkeHtlcWflNGj5DeYdJQPT4
         X3ERHWTE/Y8Ppz3iq6d8lVBDzsbSmqqJeVuvtkHKQmXBi6dAfWO/ltPBZp6b5R0q+e9s
         gSj/VoDBc2HjcicB1V5XWrsIwhmg1pzxniaQDupXt3oVaFiygCDcyLLDUskLIYvOz2wJ
         uA/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z+YdJeFqFDZRiS6UDwTkhXHC91WQ1PZ11Rxt5I2e+FU=;
        b=LnSeEIBdFkTGufYDYFoXh/hXkIzNcAhbN8j07L46z8b8bHTex8gEDbWieJ96pNAenX
         sVMi8NumeXOPAvyGBfrwbam+qDhCdvoJKeJWBIv+KuzgSU2htnC1VLtwRh22FBb25epu
         EC+yxTfoCK96c4MSweQS7kZDgbLw8ajS/bpCvaF7IJWPc1YKz5C8H7Svh8Anm5uB7PcN
         CiB0g5s1jd0IQnSfuKcjnkK3YVn62EaiJal2Bp5Y5tgfVj35Pxn3do9oqQMySxskqPoA
         94D/yMHQVsZPL7LGIn3Z8ANo8pTs06E8W0WjDTrLViZM0c/my3RfD+wQrr4InktsmJ7K
         80ow==
X-Gm-Message-State: APjAAAUnCHMIXXtYs0ei9EG8NZoLkLir60HpQK8GbL5d+Wqs0urL2l22
        0Hl8EF/DGbKTJzJFyRcozE+vrzJf+dWr6Q==
X-Google-Smtp-Source: APXvYqyS/RKeM9zumYWvWIONZnnYQoo2K9mMGL30OI0gAqgkRZQYGDp2/hgWcYtcJbLOY/q14c0jWg==
X-Received: by 2002:a62:446:: with SMTP id 67mr713329pfe.109.1579229997428;
        Thu, 16 Jan 2020 18:59:57 -0800 (PST)
Received: from ?IPv6:2600:380:4b14:d397:f0a3:4fc6:c904:323a? ([2600:380:4b14:d397:f0a3:4fc6:c904:323a])
        by smtp.gmail.com with ESMTPSA id a26sm27407001pfo.27.2020.01.16.18.59.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 18:59:57 -0800 (PST)
Subject: Re: [PATCH] io_uring: remove extra check in __io_commit_cqring
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <0d023acc096d63db454927590a5aca07deeac1cf.1579222330.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e3109a4c-76c9-fc88-6140-5825fd5bf3e1@kernel.dk>
Date:   Thu, 16 Jan 2020 19:59:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <0d023acc096d63db454927590a5aca07deeac1cf.1579222330.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/20 5:52 PM, Pavel Begunkov wrote:
> __io_commit_cqring() is almost always called when there is a change in
> the rings, so the check is rather pessimising.

Applied, thanks.

-- 
Jens Axboe

