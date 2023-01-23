Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6377E6788ED
	for <lists+io-uring@lfdr.de>; Mon, 23 Jan 2023 21:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbjAWU6w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 15:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbjAWU6n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 15:58:43 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1523FDBEF
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 12:58:17 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id m15so10017620wms.4
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 12:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jP31T9len35tRIV6SSGMhQ3n8VcNE5DPSsO+Y5Dlli8=;
        b=Di8+yQeCLn3bmFLFg2gHqOmZSr+KeyZHhN94gE6YH0ZbI9AOg5LecrdYX5PbC+vLFn
         UZmcHVbcW0eMZx3zHMoH8az+yRiOS1EEjxAX0YadN6MtlkUacc2gKcBC6s3HF3MpR/Ko
         B+/hMs3LTMjuP/IjxVgdyZmM7L+jKHciti9XKBohrfrcfRfE9zH8dUiTLQlwJFCAV1XA
         7RRQUNtUD0tjcR9drQJe9M9GHu2RxB2Ma28RL9w9GzeQdapW1sldQBzgdEv7JQ5mTo3B
         FHLw/h7+HUk9FI3/YBTPN3axwdiyz5uOlky3YiAOs7tXoRNPO1ODA1wlgoGW2t4hWRrA
         z7Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jP31T9len35tRIV6SSGMhQ3n8VcNE5DPSsO+Y5Dlli8=;
        b=jEFWUaWAhHobkmwUYCYRLadxFSJy7I65971fusKO9A2gK406o6J3JqyM3vrdfd/8A5
         hiUJCU3WMUp8o9XtesflTgKBns+g0LGDQwnW94t8sQN8S08QzJHg1wQ1zMKUNh/VoCM1
         UIBXN5rsyHUipWIsV5dTXKA7yuW1gT8bq3u6hKtIdCMrvUY+7/hgYldRhPNia8eMFaoo
         lhyQKN8TsoFD3XUqxWR11ybyhsvUc7rY13iehsMFx/sIzvSne5VFnpEL8fC716h6pWCZ
         c9O8o/dCpqVaFQeFEn9xaKh+k8KidSfGXXR2MScpLYcJ8BXhRihnMKaP7U8YT3chmNnS
         U3bw==
X-Gm-Message-State: AFqh2kpPVV3t4psQ9E5kj1XZBDVmy6qUUaPlWWo6trNwMb1S38ClX3LL
        NS/02LuLwrZMtQfrCY631KtrsYNAZ9w=
X-Google-Smtp-Source: AMrXdXt1bkpvFleWR09z/Qu2mLcMj56ZUeIZape1qGZ8EGL16YrLypUgCYqM1mWrgmFFCZyOApCBtA==
X-Received: by 2002:a05:600c:540c:b0:3cf:7704:50ce with SMTP id he12-20020a05600c540c00b003cf770450cemr24191972wmb.38.1674507495155;
        Mon, 23 Jan 2023 12:58:15 -0800 (PST)
Received: from [192.168.8.100] (92.41.37.76.threembb.co.uk. [92.41.37.76])
        by smtp.gmail.com with ESMTPSA id e18-20020a05600c449200b003da105437besm186220wmo.29.2023.01.23.12.58.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 12:58:14 -0800 (PST)
Message-ID: <1575ad4b-d6c0-33e2-9dab-046094fd7b43@gmail.com>
Date:   Mon, 23 Jan 2023 20:56:54 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH for-next 1/7] io_uring: use user visible tail in
 io_uring_poll()
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1674484266.git.asml.silence@gmail.com>
 <228ffcbf30ba98856f66ffdb9a6a60ead1dd96c0.1674484266.git.asml.silence@gmail.com>
 <bb8f25a0-d3a1-3e65-24f7-e0e3966c2602@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bb8f25a0-d3a1-3e65-24f7-e0e3966c2602@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/23/23 18:25, Jens Axboe wrote:
> On 1/23/23 7:37 AM, Pavel Begunkov wrote:
>> We return POLLIN from io_uring_poll() depending on whether there are
>> CQEs for the userspace, and so we should use the user visible tail
>> pointer instead of a transient cached value.
> 
> Should we mark this one for stable as well?
Yeah, we can. It makes it to overestimate the number of ready CQEs
and causes spurious POLLINs, but should be extremely rare and happen
only on queue (but not wq wake up).

-- 
Pavel Begunkov
