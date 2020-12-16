Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF8E2DC2A2
	for <lists+io-uring@lfdr.de>; Wed, 16 Dec 2020 16:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgLPPCJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 10:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbgLPPCI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Dec 2020 10:02:08 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7A0C061794
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 07:01:28 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id r7so23492492wrc.5
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 07:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D0eEl+a+D9e95U0oflIdI5U4FU0jtziIxO+olAP1LVw=;
        b=ZzWYL/I7N33WZMZFjaWUBfug94pjm8eurxRHADEmtWOZMccTZRV749vLW2CFT2eKOE
         nGoOa+BiJ5ziWD25p7hzxHIav4YWMbvPEICQJcZIIBzesYt1fV625fPRqtwY1QlSnQlk
         JzSCPoiMqYFA/VQDSKC/gT7JUFc+lOuQI3ilsvDlcO5J5s8Jd3M2Jsj53nAcV+wLiZLX
         kSni5f2J2SPdnf8IWwCK+r3dHfoirk3UpiNPcbGB7dWEbGEGmucZ6JsRNhuHnjWk2pc5
         VYY9XGIduIE8a19AX/6kshEk/GVHnVgxgQ+NrFO/jZBEnMzHOIUD9lMUlY/j1iTi3t9U
         xlPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=D0eEl+a+D9e95U0oflIdI5U4FU0jtziIxO+olAP1LVw=;
        b=VnjEEIDxkmjnA/EGEurla7eDZAZj2x7edCyUZQRvJoilrWG5dbyOgvn8WC1SFFfF2a
         OREqFxDmVIegAsWJFj629pYFm8gxIOEoSo2QTJpKBb/OWeelqyvm6ghQM53RrKviBbmW
         KQ5ji6fWK4rwJJaRaLBgXKrxS1p2+qIEZejaHxIR0/TO/jmAtp7d9wAUEZZ5rTDxGVZG
         avlFFw5LPbS7r3Aquxb5V6yQc2YKZVEg05dJpERx71dbXg3E90DhpeN3RxgkVrKXdMX3
         bixpJdFJEtOFcdJH0JoA64T+3IoPPqk7dXYbZfHn1uNLtZqVCbGat7fxAaGU3tV6otlr
         +k8Q==
X-Gm-Message-State: AOAM531aWisiq/nb35EFwpn6MLp0TQKMDkEqltPyQa6jXDwda1q+Bm/Z
        9TahC/wNjurrJik+B+FW0zQ13ZPLglCwlQ==
X-Google-Smtp-Source: ABdhPJz0uJB1Y65y7+5HRL1GXNu9/7XKzrvntvZm60PlugtD+t26KbKmSKc1ycAASnDoedtT/Avc+w==
X-Received: by 2002:a5d:4cd1:: with SMTP id c17mr38732304wrt.49.1608130886669;
        Wed, 16 Dec 2020 07:01:26 -0800 (PST)
Received: from [192.168.8.128] ([185.69.144.225])
        by smtp.gmail.com with ESMTPSA id p124sm3184530wmp.5.2020.12.16.07.01.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 07:01:26 -0800 (PST)
Subject: Re: [PATCH v2 08/13] io_uring: implement fixed buffers registration
 similar to fixed files
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1607379352-68109-9-git-send-email-bijan.mottahedeh@oracle.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <d9b4abb9-61e2-4751-9350-99fc58b02aae@gmail.com>
Date:   Wed, 16 Dec 2020 14:58:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1607379352-68109-9-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/12/2020 22:15, Bijan Mottahedeh wrote:
> Apply fixed_rsrc functionality for fixed buffers support.
> 
> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> ---
>  fs/io_uring.c | 240 +++++++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 204 insertions(+), 36 deletions(-)
> 
[...]
>  	/* overflow */
> @@ -8296,28 +8313,71 @@ static unsigned long ring_pages(unsigned sq_entries, unsigned cq_entries)
>  	return pages;
>  }
>  
> -static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
> +static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)

I think this and some others from here can go into a separate patch, would
be cleaner.

-- 
Pavel Begunkov
