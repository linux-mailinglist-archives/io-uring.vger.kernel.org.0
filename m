Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFA7632D2F
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 20:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiKUTqp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 14:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiKUTqn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 14:46:43 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6695C847B
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 11:46:42 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id m15so6140277ilq.2
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 11:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cW7xEil0+Eo1B5pxJ1jN1HcTcVP8+b2NDh/aBES9mHg=;
        b=3IBLlyyRyPeRfnITiaGccxh5jlxDkr7Vs/bJatKMVlQKNsvdMJrcfiq9Rzi+PHDwFX
         S1Uu8RKyDRqWcT0oQ8G1AJbtWLgW6KMDZQSQJzq6e0LDhkfl0qq/qSYS+M7rYTj/l1P7
         wxE59/FXfhIHEQ17dECqInZ80p0mptGhMh+P6fpx/54aIG/QF3Cu+IPU1cMrclfs0v9P
         yD0TELgxh+L5Fm6NvLgI053jePA6oW7ag1+9LzoZdVj0sFHKZUjblWutCVCAc1rWCVUq
         UCl3wDFM7QluarR/iTj7gwVJYaoLq6cTYz62WE+Ioeb/xWsRon0ZIGSuQClXo167cvMV
         DvxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cW7xEil0+Eo1B5pxJ1jN1HcTcVP8+b2NDh/aBES9mHg=;
        b=RcNG0SsQGCPjntfUWGyIBdiYihGR+9T8JFp2t+bxo8DbwErbH3hD5CNaPTFyd/V3JX
         H0RPJVB4hONguW5dROKHqkrwoTGJ8ihqIWsVrc22MTH2APAYyjMmVVF4Htc6Br4+R9aL
         uFK2/h8eEn8Xubru9xFmyo2P40hibOs80gVx6v5Oc0h9AlrJRpGWiKvJPRwAzUITMMHD
         TFLGi7xt+YgDw+4scPwCf9s+c2+06+6hXkJvLZDGo9ZyLSw6lIQhlNpkUyBft9sv338z
         +6xrburGPDDyAHt282jW2+UxSFkaiFtV0yrCp8Gs8y35ofALs6QavNSupx1kG6PMaHU9
         6HsA==
X-Gm-Message-State: ANoB5pk2BJpx2lEe/Zk9ICEWEJu6muEkTeLTcjzBQm0VJCX7orzN7jWH
        KIOlpjV+360/qwg6RypNdim0SrxYihLRKQ==
X-Google-Smtp-Source: AA0mqf5tbbmMXgs493av/aFNqPj4mL46FPNqh3kidOnfhP6HCvYUkgVPV4N0fFl2Qm7xAE1WDN5j8Q==
X-Received: by 2002:a92:cf01:0:b0:300:d30a:8963 with SMTP id c1-20020a92cf01000000b00300d30a8963mr1597483ilo.139.1669060002164;
        Mon, 21 Nov 2022 11:46:42 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b4-20020a05660214c400b006cab79c4214sm4558264iow.46.2022.11.21.11.46.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 11:46:41 -0800 (PST)
Message-ID: <35168b29-a81c-e1b2-7ec9-b5f0b896ee74@kernel.dk>
Date:   Mon, 21 Nov 2022 12:46:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v5 2/3] io_uring: add api to set / get napi configuration.
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>, kernel-team@fb.com
Cc:     olivier@trillion01.com, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org
References: <20221121191437.996297-1-shr@devkernel.io>
 <20221121191437.996297-3-shr@devkernel.io>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221121191437.996297-3-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/21/22 12:14?PM, Stefan Roesch wrote:
> +static int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
> +{
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	const struct io_uring_napi curr = {
> +		.busy_poll_to = ctx->napi_busy_poll_to,
> +	};
> +
> +	if (copy_to_user(arg, &curr, sizeof(curr)))
> +		return -EFAULT;
> +
> +	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
> +	return 0;
> +#else
> +	return -EINVAL;
> +#endif
> +}

Should probably check resv/pad here as well, maybe even the
'busy_poll_to' being zero?

-- 
Jens Axboe
