Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281306F1E17
	for <lists+io-uring@lfdr.de>; Fri, 28 Apr 2023 20:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346446AbjD1ScS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Apr 2023 14:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbjD1ScR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Apr 2023 14:32:17 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1F6E5
        for <io-uring@vger.kernel.org>; Fri, 28 Apr 2023 11:32:15 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-76656f3568cso525039f.1
        for <io-uring@vger.kernel.org>; Fri, 28 Apr 2023 11:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682706735; x=1685298735;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UnIyrlX+Tui17CSXyzwD21EblbBQZxZQxBDROZgCXbY=;
        b=chlKHPqX9MGyUfnQUBSJM0/mabW5u5pUtgT2Ma8BV3omqFC6bFSX2qWC4LCKB6JP+2
         CePr7Lgt1c9gBJD98vXpDUNFJnt9BJc9FtXHlboFpnxSLOXaSeqmycKtHPyfPau7zv0p
         q8VCxzOOwIdQtrPF+jXG5uUU9r2hZeoluC1fyeGrO8hWWVMnL9cpKZBKM6DwITUBnsk6
         ms83uDRxsEw+cCqtn40JMCqOPBcKr7Zjz8BMXqeCQcy6eT2ruhIBCmsDhnGYMo74hivc
         ftc9aXjdpdlVp/s5DnmqWmdjJiMZumoBiNlgFndbTjHfrUbnYPfr1m+aiLjiMBkBpJGE
         stkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682706735; x=1685298735;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UnIyrlX+Tui17CSXyzwD21EblbBQZxZQxBDROZgCXbY=;
        b=I+uGtwSkXh6x5eVcYnciC8IdZtwPMN0vdx8HFF6B49HOuU8IFOum+zQFvbIHgGF5eR
         jI/14jRFrw/tVDNGqVFQUtFDpvrG9rmWYHTN9cJ0TzUncrqecyCcEcxhgsWaV5lz0OxG
         AGbmhOCGt1MPwfgVE47PgqtzZ4zjVyrvSgrpE9xDg1iAVuS+de7fb3Bn1OiMkDJY2xw/
         7fV9D7oQbmiNQKsrnrGhtRRwA3e4ZjGbWY6IbXIwfrKXoTyMShG1Zi+XUbjUZ+ambGaO
         33bm4MGmfYMJevKDrnBjtP/ythY9zUHbmJpt17x4SgdmnslwzuGEwcsqTNv5N9alq2mm
         ghkg==
X-Gm-Message-State: AC+VfDwNObE8S24B65pZYGbMFoFHkJxkQKE7AjMZC4GrlGzhFoa1mxq5
        qOZRqDCdnOWgDgMPJ/W+R8ZihTbyUYDq+JnBd1g=
X-Google-Smtp-Source: ACHHUZ56Im9yZViz9ECON1PAbcDeJEZ5HKB+D5koKt9nle/cypVJDdTFDjDvmTfdw6IiXLhzgmj+8g==
X-Received: by 2002:a05:6e02:3499:b0:32b:4518:d122 with SMTP id bp25-20020a056e02349900b0032b4518d122mr3052892ilb.3.1682706735168;
        Fri, 28 Apr 2023 11:32:15 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g36-20020a022724000000b0040fa80f3981sm6124350jaa.6.2023.04.28.11.32.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 11:32:14 -0700 (PDT)
Message-ID: <89ef84bf-48c2-594c-cc9c-f796adcab5e8@kernel.dk>
Date:   Fri, 28 Apr 2023 12:32:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v11 2/5] io-uring: add napi busy poll support
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
        kernel-team@fb.com
Cc:     ammarfaizi2@gnuweeb.org, Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230428181248.610605-1-shr@devkernel.io>
 <20230428181248.610605-3-shr@devkernel.io>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230428181248.610605-3-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This looks much better now! One question and a minor comment:

> @@ -2619,9 +2622,13 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>  
>  		if (get_timespec64(&ts, uts))
>  			return -EFAULT;
> +
>  		iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());

Probably want to kill that extra added line, not worth respinning for
obviously.

> diff --git a/io_uring/napi.c b/io_uring/napi.c
> new file mode 100644
> index 000000000000..a085122cae8b
> --- /dev/null
> +++ b/io_uring/napi.c
> +void __io_napi_add(struct io_ring_ctx *ctx, struct file *file)
> +{
> +	unsigned int napi_id;
> +	struct socket *sock;
> +	struct sock *sk;
> +	struct io_napi_ht_entry *he;
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
> +	/* Non-NAPI IDs can be rejected. */
> +	if (napi_id < MIN_NAPI_ID)
> +		return;
> +
> +	spin_lock(&ctx->napi_lock);
> +	hash_for_each_possible(ctx->napi_ht, he, node, napi_id) {
> +		if (he->napi_id == napi_id) {
> +			he->timeout = jiffies + NAPI_TIMEOUT;
> +			goto out;
> +		}
> +	}
> +
> +	he = kmalloc(sizeof(*he), GFP_NOWAIT);
> +	if (!he)
> +		goto out;
> +
> +	he->napi_id = napi_id;
> +	he->timeout = jiffies + NAPI_TIMEOUT;
> +	hash_add(ctx->napi_ht, &he->node, napi_id);
> +
> +	list_add_tail(&he->list, &ctx->napi_list);
> +
> +out:
> +	spin_unlock(&ctx->napi_lock);
> +}

Didn't look into the details here just yet, but one thing occurred to me
- would it be possible to rcu_read_lock() protect the hash for lookup? I
would imagine that the ratio of successful lookups to "nope nothing
found, need to alloc and insert" is quite high, and we could avoid the
napi_lock for that case when just iterating the hash.

Would obviously need rcu freeing of 'he' as well, and so forth. And some
way to detect if 'he' is going away or not. But seems like it'd be
doable without too much trouble?

-- 
Jens Axboe

