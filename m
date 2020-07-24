Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841DF22CBE4
	for <lists+io-uring@lfdr.de>; Fri, 24 Jul 2020 19:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgGXRRx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jul 2020 13:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbgGXRRx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jul 2020 13:17:53 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F098C0619D3
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 10:17:52 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id n22so10723450ejy.3
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 10:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R5svZUXjtYd5vLN5S2ePtUuavQ1TEO2j50wwitPsb6g=;
        b=qPCpvk8plLazZyb2sESdXmxKo+wgPXSX3ZWlRVpa2TRosz11j/4pBtALjhempUMr3C
         K2zyKJUPi2LLPlLxAOxqeFe7LL915liU5QIhSPhN88rlVAfAwLQ8OgkR2nGOL3otVOEY
         9zyLCULiI0UOdp2O2t0zEbpTJTs9m+eKIrVAnj1oCLO2KVb5QFP0crVekI/Du/Y8U+7x
         +YIZK1TcTWQqgpYDMiIsznNZJ2JwbASaDMLRy76pgxFQfvNz97U2AKm9NW5GE9DYeHm1
         +1fCjHwP5iMz61twfRahnEytq8iQGvPun9u0kMkLluQ2a4meRWYBHdmQ9+0ECdkw0Dyj
         g5gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R5svZUXjtYd5vLN5S2ePtUuavQ1TEO2j50wwitPsb6g=;
        b=aUqyRpO9agVfnVE18mmgeC80Py5ED/U/YF8LCqFCU/eKqHVUy3+OLvbA0UuyTR0mwR
         eRIQMfKoJO3XsdzOCan/7ZPBWLAUY1YPDRQN4ICwNScs3LJaAs46/zXn3BnCtVIVpkas
         hw13/ZNcioHrxilzEPzjP0nnc6AbzIgkLWPxMZe40GXQmq/P80Ny+v1BySg6QGufHl0v
         bWkYfCGyf4qy9PW4acfDN2mAUqLS4ZOd4KRIx4/mwEaycwIvJrQfjF1apuCbzruczqyK
         vO1/X8D3vm5fRC3G3fNWfVv3aSoIcVCqZGhI4IbWSrTKsEXTcB/7yAuiG7lWAAlltlac
         CPtQ==
X-Gm-Message-State: AOAM5305+oAICS6MOg4shblhiuwYlSnZhK370uyNfVssw7cT1luZjx3V
        gmooDJYWYgLxivaygGDJTXZGKY36
X-Google-Smtp-Source: ABdhPJzXN8NvtR2VZDocFPJTnZwi+nQDC/zsS7Ao4WlI1POrXbUs5o1CGP8g5gNy4+hyLYFOS5EIxg==
X-Received: by 2002:a17:906:eb41:: with SMTP id mc1mr8540802ejb.245.1595611071157;
        Fri, 24 Jul 2020 10:17:51 -0700 (PDT)
Received: from [192.168.43.57] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id u16sm1062969edb.97.2020.07.24.10.17.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2020 10:17:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1595610422.git.asml.silence@gmail.com>
 <3aad8261c564462b78b96d79ff23b7ac2e253b41.1595610422.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 1/2] io_uring: fix ->work corruption with poll_add
Message-ID: <0fe2c36d-1988-8ce6-df21-531410837073@gmail.com>
Date:   Fri, 24 Jul 2020 20:15:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3aad8261c564462b78b96d79ff23b7ac2e253b41.1595610422.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24/07/2020 20:07, Pavel Begunkov wrote:
> req->work might be already initialised by the time it gets into
> __io_arm_poll_handler(), which will corrupt it be using fields that are
s/be using/by using/

Jens, could you please fold it in, if the patch would do? Or let me know
and I'll resend.

> in an union with req->work. Luckily, the only side effect is missing
> put_creds(). Clean req->work before going there.
> 
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 32b0064f806e..98e8079e67e7 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4658,6 +4658,10 @@ static int io_poll_add(struct io_kiocb *req)
>  	struct io_poll_table ipt;
>  	__poll_t mask;
>  
> +	/* ->work is in union with hash_node and others */
> +	io_req_work_drop_env(req);
> +	req->flags &= ~REQ_F_WORK_INITIALIZED;
> +
>  	INIT_HLIST_NODE(&req->hash_node);
>  	INIT_LIST_HEAD(&req->list);
>  	ipt.pt._qproc = io_poll_queue_proc;
> 

-- 
Pavel Begunkov
