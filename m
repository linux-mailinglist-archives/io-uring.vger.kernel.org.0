Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6A1302869
	for <lists+io-uring@lfdr.de>; Mon, 25 Jan 2021 18:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbhAYRFS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jan 2021 12:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729891AbhAYRBc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 12:01:32 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5211C061786
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 09:00:22 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id q7so13566270wre.13
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 09:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=is52ncoUt00/0LlJ8Kgi3mx4aEE0Sg4AqOE7Mcu6Y2I=;
        b=a0uXgRJiAjIgBe3cDJnpWBAn8foCGWiKRH3eQi1kjwnTdsyCQ49D0vuk2jo2Xzd5j+
         yg06wQ+CSrEP19dypan34+uEmMhR0pABux0cj5twbW0ZjnfI0jZvZOHy2zqxWKHqwrlA
         Xcc05ROZvVC6XggCb3Q5VwNmy0p3xTjVnch7+AkxrI7IKTq1k8QBitoeQpAFpF5T0OB4
         nTY/BtevUlY7HP+h9/8XMjw0oEYz+/1kGT3rWijXDFUANpCqPtU8NSh0+jZI0hrVHFup
         TVph61U8aleqlvZsB5LZFzDxRbLohB3Elq6oj+eeUJP29sWqKnoyNVWKSVzt4PRDE5Wz
         K7vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=is52ncoUt00/0LlJ8Kgi3mx4aEE0Sg4AqOE7Mcu6Y2I=;
        b=kEjutvHFlT4h5GPu2SeiHEDcBQdAYQsofzNubvIM3dRn5pJx1C4cWEck3RaX8X4t4r
         bleZ3NNq0vjHEmEam0AKcKv10/Ps+XDNIhxnA/48PI90JN8VymPighCJMofXEWyKub19
         usuXKLirPLUp2M3ba8/wVRNvFsRodb53WqCLcAXJh7Os994MRPZoOUdUGtqgm9vO5naZ
         gYZVBrKoVSpwMl0dH5zqIbSDs5A1Wq2/wIdJcb82sxcxmihvsS224GGiUY3rs40wYZHr
         tIO5ni1Xi6CrDFBjKnsKjDXcCDP0VmyJMcBWVU79XRwlp1p0EI7LIcI8cUrDZMqJCCUG
         Db2A==
X-Gm-Message-State: AOAM530mANdiuioLm/BiWFab4sxXmP0iSTThQhl/ijaRRVN955fbFTWV
        mZqliR+D1LmEE8dOuHBsgfP99W7IZd77vg==
X-Google-Smtp-Source: ABdhPJzrxtWPPIKfKZTlkR+OUsjq0PiymRt1Q0dsidKMX2Zf6hHSbvPMQdWYFWG6eFDseISwioq+5g==
X-Received: by 2002:a5d:4b50:: with SMTP id w16mr2007669wrs.391.1611594021381;
        Mon, 25 Jan 2021 09:00:21 -0800 (PST)
Received: from [192.168.8.154] ([85.255.234.28])
        by smtp.gmail.com with ESMTPSA id b18sm23803897wrm.57.2021.01.25.09.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 09:00:20 -0800 (PST)
Subject: Re: [PATCH 0/8] second part of 5.12 patches
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1611573970.git.asml.silence@gmail.com>
 <f10dc4a5-9b2c-da65-bb62-00352aff3926@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <5b3cfdda-b16c-5dca-da9a-1c034571f91f@gmail.com>
Date:   Mon, 25 Jan 2021 16:56:41 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <f10dc4a5-9b2c-da65-bb62-00352aff3926@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 25/01/2021 16:08, Jens Axboe wrote:
> On 1/25/21 4:42 AM, Pavel Begunkov wrote:
> 
> Applied 1-2 for now. Maybe the context state is workable for the
> state, if the numbers are looking this good. I'll try and run
> it here too and see what I find.

I believe I've seen it jumping from ~9.5M to 14M with turbo boost
and not so strict environment, but this claim is not very reliable.

-- 
Pavel Begunkov
