Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A476F04D5
	for <lists+io-uring@lfdr.de>; Thu, 27 Apr 2023 13:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243316AbjD0LQX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Apr 2023 07:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243242AbjD0LQV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Apr 2023 07:16:21 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A99749CF
        for <io-uring@vger.kernel.org>; Thu, 27 Apr 2023 04:16:20 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b8b927f62so1761412b3a.0
        for <io-uring@vger.kernel.org>; Thu, 27 Apr 2023 04:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682594180; x=1685186180;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JiC+s/orvW3dVeyfwQLgv3/7FyfXfIWmoWuOjheJ6Hw=;
        b=BYMDaRnZrvJi7cWxv7DXpL/Rfp7/74r2BuUwc0IClGmDqpdaflHJiNIyuapAAQvfZ+
         9NGVHar8cs3vrCtNEf9iGBfQsL7yWr8gWv2hETAUM2qT7XIHL57M4kjLMaeq9DUc2Kjx
         Nyzs4uFNBtFY+CHhpATJQ+4vazvm+dQqU9IRSXA+nHWMz7eZ+yIFL1jYC/xLB9h5cyM9
         iQpQvlKGWcs/eC5SpcGRBgaMfNSEXA91V66bOshPSX10QHwh/C/81h1NYvmRKkZ2vRSB
         7ZcfSbEylrfsGSmTcL0SqDzi4m+X/TTcwkBpvyA7SFFmlrtOD09gzHVXSD4bxZKkd+U4
         4dAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682594180; x=1685186180;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JiC+s/orvW3dVeyfwQLgv3/7FyfXfIWmoWuOjheJ6Hw=;
        b=GkGlr+47Zu8CMBdNEMAAs/19aU3xTzCNRvaThAvgw9IZDh41knukPuwxjDHGFVRfYN
         r751bakNBlWapFILwmG2ZkIwhK3mfZEEEVtCQt4roctVw3aaJhuu1obrvXPNhO51Ywm3
         k5ZP1dR9a/pNbzFQCXhXsjHuj5dCIORxI9wjZLwBpinCyJwkZJ4xrG1QZ9u2vVNL/Tu9
         iJfWjniel87CYm0iMc1qyx2fiXVyNUZPYlLV9IJCoxEKK5dJ40ilMk//YaoZSnZFt5aO
         1IDM4hqWG897zZW15auYcFyqn6Lia0C+PZEAAJ3hhiYjGl/HOfbkNVWcr+EDwmWoWhdy
         L9UA==
X-Gm-Message-State: AC+VfDwxiW1/Hq/BZ+exu+cly8hHPF6GBFaZy4htL+9WcK8CYFDs9Ksr
        TtRoNIZJQlWzWx50UO6t8ZcKlw==
X-Google-Smtp-Source: ACHHUZ6JSyPG0a67pHmPcxf08RH8YfjMG/gXeEdvVAD7+wh62r2nCd4dNt0x3BlJ9AhFkt2LRi+EwQ==
X-Received: by 2002:a05:6a21:9991:b0:f6:7bb8:c8d5 with SMTP id ve17-20020a056a21999100b000f67bb8c8d5mr1530425pzb.4.1682594179861;
        Thu, 27 Apr 2023 04:16:19 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ei23-20020a056a0080d700b006410f4f3ecdsm1770115pfb.83.2023.04.27.04.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 04:16:19 -0700 (PDT)
Message-ID: <afbc5377-f424-e34a-6987-7569a342daf6@kernel.dk>
Date:   Thu, 27 Apr 2023 05:16:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v10 2/5] io-uring: add napi busy poll support
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Stefan Roesch <shr@devkernel.io>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230425181845.2813854-1-shr@devkernel.io>
 <20230425181845.2813854-3-shr@devkernel.io>
 <ZEnkUMF/p19Ub0MQ@biznet-home.integral.gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZEnkUMF/p19Ub0MQ@biznet-home.integral.gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/26/23 8:56?PM, Ammar Faizi wrote:
> On Tue, Apr 25, 2023 at 11:18:42AM -0700, Stefan Roesch wrote:
>> +void __io_napi_add(struct io_ring_ctx *ctx, struct file *file)
>> +{
>> +	unsigned int napi_id;
>> +	struct socket *sock;
>> +	struct sock *sk;
>> +	struct io_napi_ht_entry *he;
>> +
>> +	sock = sock_from_file(file);
>> +	if (!sock)
>> +		return;
>> +
>> +	sk = sock->sk;
>> +	if (!sk)
>> +		return;
>> +
>> +	napi_id = READ_ONCE(sk->sk_napi_id);
>> +
>> +	/* Non-NAPI IDs can be rejected. */
>> +	if (napi_id < MIN_NAPI_ID)
>> +		return;
>> +
>> +	spin_lock(&ctx->napi_lock);
>> +	hash_for_each_possible(ctx->napi_ht, he, node, napi_id) {
>> +		if (he->napi_id == napi_id) {
>> +			he->timeout = jiffies + NAPI_TIMEOUT;
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	he = kmalloc(sizeof(*he), GFP_NOWAIT);
>> +	if (!he)
>> +		goto out;
>> +
>> +	he->napi_id = napi_id;
>> +	he->timeout = jiffies + NAPI_TIMEOUT;
>> +	hash_add(ctx->napi_ht, &he->node, napi_id);
>> +
>> +	list_add_tail(&he->list, &ctx->napi_list);
>> +
>> +out:
>> +	spin_unlock(&ctx->napi_lock);
>> +}
> 
> What about using GFP_KERNEL to allocate 'he' outside the spin lock, then
> kfree() it in the (he->napi_id == napi_id) path after unlock?

We actually discussed this in previous versions of this, it kind of
optimizes for the wrong thing. Only the first trip through here should
allocate a 'he' unit, the rest will find it on the hash. That means that
now the common case will alloc+free an extra one, pointlessly.

> That would make the critical section shorter. Also, GFP_NOWAIT is likely
> to fail under memory pressure.

If a ~48 byte allocation fails, then I suspect we have more serious
issues at hand rather than ignoring NAPI for this socket!

-- 
Jens Axboe

