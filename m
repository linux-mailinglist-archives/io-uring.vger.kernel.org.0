Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C38B6CA318
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 14:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbjC0MKg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 08:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbjC0MKf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 08:10:35 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359C63C0D
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 05:10:31 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id x3so35117922edb.10
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 05:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679919029;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TuNCsmOtBOb4uSRXl9QDy46bo8vPpx70g3zB1RFiK9Y=;
        b=fM1Guh/I3V3Bnq4pzvxA8FScpIIEEud+rmyRHFR9MTL+sZSio5Uz8CLFqbDkZkAvst
         2WadYlerwyuJNjPOE4N7oEmFtigKAYczGGPHBLnujEYL2Or+lN6HCdyEK2GXRcF/5D+y
         6tyk25UIXNLDdiiw6USe1gKmId+2n34BvlFQmyw713NQXLCrA8x1zdI9vlYIOVbHP+iP
         QTKWMW08ho58+XHhSQVXYSo39ohgXg8FQ/3RlKCsvWzoMeCQXURPVLPi742YS/P8NfHK
         XNNTaVOC4SJMs+5HIKhPGe4njXJccfeeajtGSsuhilg0sNhVb+HR3YfAh0IpVb049FUp
         K1lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679919029;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TuNCsmOtBOb4uSRXl9QDy46bo8vPpx70g3zB1RFiK9Y=;
        b=klqgS3UkK+AczV1/BQYCErwgZQFJfTl8SzdQE9xjhXBqcQjk+rVQVTcWbxnqYB7zVn
         Y12wQQ7QsV+oa2mlPgXdnbxrxYk9lEc5N60cfD7mp/TknvFUW9dllmu3mdKN2pUF0mam
         y9qllaUG1psuyKrFu2129f94ijmBQiuiP5WhEzJHTl/Kb1aehB6Xrt32sF0FUmUHjuc+
         2eUbUrgCExZ1RwmKOFl8FQiPYTYaYhJsWCU0vD0LBnqcqBo0PtG9m0sNM5pMwXOBUXZK
         vKVhzDJw0CCWIcjifs+Bdzi6YrcWgA4faq6ERxHQUs3aCzLsNmT6byjjV0pbWPqX0sup
         WQyg==
X-Gm-Message-State: AAQBX9dGvyvtBw3I2ifRtHrIzTdc19trSypjGs3tPEAfE3P8rSHz550l
        AAKII2uPxS6Z4GmsxVp9T32v1FN9Z00=
X-Google-Smtp-Source: AKy350ZMFs5zQ0X/MX0wL7uYTSxkbKqpNl0lqvTTKwUm9R993144mxBxvqQPKC2QOIkT1ywI0ic+sQ==
X-Received: by 2002:aa7:d68f:0:b0:4fb:8b80:e959 with SMTP id d15-20020aa7d68f000000b004fb8b80e959mr11925887edr.32.1679919029519;
        Mon, 27 Mar 2023 05:10:29 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:1063])
        by smtp.gmail.com with ESMTPSA id z37-20020a509e28000000b005023dc49bdasm2366468ede.83.2023.03.27.05.10.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 05:10:29 -0700 (PDT)
Message-ID: <83913ac4-bcb9-0965-ac46-25c7827423df@gmail.com>
Date:   Mon, 27 Mar 2023 13:09:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH] io_uring: add support for multishot timeouts
Content-Language: en-US
To:     David Wei <davidhwei@meta.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <20230323231015.2170096-1-davidhwei@meta.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230323231015.2170096-1-davidhwei@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/23/23 23:10, David Wei wrote:
> A multishot timeout submission will repeatedly generate completions with
> the IORING_CQE_F_MORE cflag set. Depending on the value of the `off' field
> in the submission, these timeouts can either repeat indefinitely until
> cancelled (`off' = 0) or for a fixed number of times (`off' > 0).
> 
> Only noseq timeouts (i.e. not dependent on the number of I/O
> completions) are supported.

It's ok, I'm not sure there is anyone using sequences

> For the second case, the `target_seq' field in `struct io_timeout' is
> re-purposed to track the remaining number of timeouts.

We have space in struct io_timeout, let's just add another
field there.

[...]
>   static bool io_kill_timeout(struct io_kiocb *req, int status)
>   	__must_hold(&req->ctx->timeout_lock)
>   {
> @@ -202,6 +215,13 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
>   	struct io_ring_ctx *ctx = req->ctx;
>   	unsigned long flags;
>   
> +	if (!io_timeout_finish(timeout, data)) {
> +		io_aux_cqe(req->ctx, false, req->cqe.user_data, -ETIME,
> +			   IORING_CQE_F_MORE, true);

We can't post a cqe from here, it should be a task context,
e.g. using tw

> +		hrtimer_forward_now(&data->timer, timespec64_to_ktime(data->ts));
> +		return HRTIMER_RESTART;
> +	}
> +
[...]

-- 
Pavel Begunkov
