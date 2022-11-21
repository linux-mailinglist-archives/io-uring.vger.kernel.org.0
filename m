Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F7C632D2A
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 20:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbiKUTpl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 14:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbiKUTp0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 14:45:26 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0854C9015
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 11:45:19 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id h2so5443444ile.11
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 11:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SKyutkGtq5wCLCRgbbrRI8D5Q9dKHR8db9PKRfBRuGQ=;
        b=0NNRjLWD8RVWs1fY+XYqsnnUp6AGdUymHYbGveKis6XPah+LbL+5rBb1BQ70aBE9/d
         ZoF4Xieol6KxeQluSC+4/GeHKzePSBNPE0B4YJNHJHdk1bUtV+ODaeInl3+HNDIVazRM
         DG6Yu+oWKqaoby9Ur6QsqTMrh7NwNs5yLVBa4/l5/HPxK974SNr7rMipxfaangLkvGwE
         ta09tIO/Pfi7LiGfEVDXaIfxGN5j3YD6TB6elnmx+LQQ/AjB7eojfQEoNhV7SnkK7O7+
         +UTqJNwsyLGrPHZvMym4zSIWfARXxwnfgSvWDcdgbgfESVR4Ep4iS7bp/1eKuwvPPC9i
         48XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SKyutkGtq5wCLCRgbbrRI8D5Q9dKHR8db9PKRfBRuGQ=;
        b=Or+LeujRadzXWHasgLC99yy/VZnpkasjbM8sHjCAlSoM99DW7mHROfq7aOwWhw2N9x
         5pFjWUHkj39zTgS8Se48d+Ryh9Syud9FUqoJ5njMRRzjJhc3+lICvwrZSZfmZENP+07y
         D264PIXkUFJ0KRxtdJNgEIresBv0WXG7tWXYOeMhuw7bsVtGngcUeUCxtUnLkK/zHceb
         Xs2pEehFysTV2BtWcGYutKdJ95bC58KMn+Nh4CWiUEoLza3Oe9BFjrcdA2zX2VIvuF90
         g9HmYVfNi8YbHafNxK+JXFKSybf9qqsF7izXjga5oH/UeXZX7oIb+zCAI22X0VnA1yr+
         CLiQ==
X-Gm-Message-State: ANoB5pnFHvrAbnuQYApop6rU2INE10WT96a35AJbtg9nD1mdhGreLtfP
        tDa5dSK0GKvPFdaWMGBAS3wKbWFIGRGtVA==
X-Google-Smtp-Source: AA0mqf6eUl768llMIq+LgvbaCnEZphFz3ju5Nj8CLYHspP9zYyc1DfiBHEOYb243+uXHRseGubuJMg==
X-Received: by 2002:a92:d088:0:b0:302:c1f7:af2e with SMTP id h8-20020a92d088000000b00302c1f7af2emr2718221ilh.58.1669059919110;
        Mon, 21 Nov 2022 11:45:19 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q3-20020a05663810c300b0034a6d12aa25sm4070989jad.4.2022.11.21.11.45.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 11:45:18 -0800 (PST)
Message-ID: <067a22bc-72ba-9035-05da-93c43ce356f2@kernel.dk>
Date:   Mon, 21 Nov 2022 12:45:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v5 1/3] io_uring: add napi busy polling support
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>, kernel-team@fb.com
Cc:     olivier@trillion01.com, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org
References: <20221121191437.996297-1-shr@devkernel.io>
 <20221121191437.996297-2-shr@devkernel.io>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221121191437.996297-2-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/21/22 12:14?PM, Stefan Roesch wrote:
> +/*
> + * io_napi_add() - Add napi id to the busy poll list
> + * @file: file pointer for socket
> + * @ctx:  io-uring context
> + *
> + * Add the napi id of the socket to the napi busy poll list.
> + */
> +void io_napi_add(struct file *file, struct io_ring_ctx *ctx)
> +{
> +	unsigned int napi_id;
> +	struct socket *sock;
> +	struct sock *sk;
> +	struct io_napi_entry *ne;
> +
> +	if (!io_napi_busy_loop_on(ctx))
> +		return;
> +
> +	sock = sock_from_file(file);
> +	if (!sock)
> +		return;
> +
> +	sk = sock->sk;
> +	if (!sk)
> +		return;
> +
> +	napi_id = READ_ONCE(sk->sk_napi_id);
> +
> +	/* Non-NAPI IDs can be rejected */
> +	if (napi_id < MIN_NAPI_ID)
> +		return;
> +
> +	spin_lock(&ctx->napi_lock);
> +	list_for_each_entry(ne, &ctx->napi_list, list) {
> +		if (ne->napi_id == napi_id) {
> +			ne->timeout = jiffies + NAPI_TIMEOUT;
> +			goto out;
> +		}
> +	}
> +
> +	ne = kmalloc(sizeof(*ne), GFP_NOWAIT);
> +	if (!ne)
> +		goto out;
> +
> +	ne->napi_id = napi_id;
> +	ne->timeout = jiffies + NAPI_TIMEOUT;
> +	list_add_tail(&ne->list, &ctx->napi_list);
> +
> +out:
> +	spin_unlock(&ctx->napi_lock);
> +}

I think this all looks good now, just one minor comment on the above. Is
the expectation here that we'll basically always add to the napi list?
If so, then I think allocating 'ne' outside the spinlock would be a lot
saner, and then just kfree() it for the unlikely case where we find a
duplicate.

-- 
Jens Axboe
