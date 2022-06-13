Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654D9549B31
	for <lists+io-uring@lfdr.de>; Mon, 13 Jun 2022 20:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244364AbiFMSMC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 14:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244220AbiFMSLs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 14:11:48 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3313590CFB
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 07:06:37 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h19so4059121wrc.12
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 07:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vaqCaxOemZmI8Ct53MYRng2ruruYwRhnRuU+w5QGJ40=;
        b=jna3lZtKPYHLgk8dzoUkUFFBC/s9VcStCUKgdmjlDg7W0zeOFjaSYG9nnnjpUkRt5r
         Lbco9QurDGOe7/1XexAeOtb41+T5DWfFWiqQJWNYDGluXzFsKtd79Oti+neGN77kMsNL
         VAnwHxr+nGaoYSgk7xr8wbVMRAOJKHHGGGndwPwfmTw7+DHMMul5rk5t0hT5nigK6iPf
         0IoJ3UgMWz3RdiRVfwvKT3JUCjwROhnHBrjQvZArh4aOL/CseqGiTgKxviGx8rjnE3CR
         AvMktUOgsI7y9IXxtvHs0A14Ux6UCmNjT4KR8r2NHg9HylRefyNeAib9Ug94hHOCgQVN
         H/lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vaqCaxOemZmI8Ct53MYRng2ruruYwRhnRuU+w5QGJ40=;
        b=jflwp0jlltmxtsg7VwW3dNWIZws2fdN2gcQCAf5QA0WiTtf+4Xk9hK8CBbOMlvT5Iv
         hL4YPyX/9fQZEt4cBst6OiQY3vSGbaLiZDnnTUGh1k0vHQ27aPUvi6HRjSml0wy/Gcxp
         JeoYVLl6ihNlfvHoOVp/Aw8ZrJFWGGCtcIxrfi40kSssK1NltTI5kJ4YZikosmjYa2PL
         DMPMA2j0nG4LxwmfZLAoW3H5aGSkzB2PrmsmpNgE54/rYTfFlNDBAeFPborc1mKIM9C5
         GYZW3bbdCHqz9xMpbE+7Vy6giI/rMAfnT9UczEOmsEAuwjpsdS5Ms+5iQkZLdgPBrUgl
         Lu7Q==
X-Gm-Message-State: AJIora/RNupWav+MqaKc92o/w+pRh/B1GeY2Y1EXBLs87a+3XfUAX538
        f7/+dpFx2+vFWHPPQBuLFho=
X-Google-Smtp-Source: AGRyM1tvKrzeGnCIeTKt4UksyhwI5/uymr97VeS2DQu1o6SX74Vv1IFwgzyMqko62/b7DgY0VUnbsg==
X-Received: by 2002:a5d:6510:0:b0:216:f04d:3c50 with SMTP id x16-20020a5d6510000000b00216f04d3c50mr52792wru.628.1655129195648;
        Mon, 13 Jun 2022 07:06:35 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id f14-20020a5d58ee000000b0020fc6590a12sm8819429wrd.41.2022.06.13.07.06.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 07:06:35 -0700 (PDT)
Message-ID: <e609bd27-9a2e-f367-1ccb-bd93dc3a71e2@gmail.com>
Date:   Mon, 13 Jun 2022 15:05:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 0/3] io_uring: fixes for provided buffer ring
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "hao.xu@linux.dev" <hao.xu@linux.dev>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     Kernel Team <Kernel-team@fb.com>
References: <20220613101157.3687-1-dylany@fb.com>
 <f2fddce1-bc25-183e-6095-bb5a70a57319@linux.dev>
 <de5e6f02-dcab-07df-7cc4-7f12885083e6@gmail.com>
 <265e0239ff5b6a8a4a6d91446c774549affb5191.camel@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <265e0239ff5b6a8a4a6d91446c774549affb5191.camel@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/13/22 14:16, Dylan Yudaken wrote:
> On Mon, 2022-06-13 at 13:59 +0100, Pavel Begunkov wrote:
>> On 6/13/22 12:08, Hao Xu wrote:
>>> On 6/13/22 18:11, Dylan Yudaken wrote:
>>>> This fixes two problems in the new provided buffer ring feature.
>>>> One
>>>> is a simple arithmetic bug (I think this came out from a
>>>> refactor).
>>>> The other is due to type differences between head & tail, which
>>>> causes
>>>> it to sometimes reuse an old buffer incorrectly.
>>>>
>>>> Patch 1&2 fix bugs
>>>> Patch 3 limits the size of the ring as it's not
>>>> possible to address more entries with 16 bit head/tail
>>>
>>> Reviewed-by: Hao Xu <howeyxu@tencent.com>
>>>
>>>>
>>>> I will send test cases for liburing shortly.
>>>>
>>>> One question might be if we should change the type of
>>>> ring_entries
>>>> to uint16_t in struct io_uring_buf_reg?
>>>
>>> Why not? 5.19 is just rc2 now. So we can assume there is no users
>>> using
>>> it right now I think?
>>
>> It's fine to change, but might be better if we want to extend it
>> in the future. Do other pbuf bits allow more than 2^16 buffers?
>>

might be better to leave it u32 *

> I guess with
> 
> +	if (reg.ring_entries >= 65536)
> +		return -EINVAL;
> 
> it doesn't matter either way. we can always use those bits later if we
> need?

I think so as well.

I was also wondering whether pbufs can potentially allow >16 bits,
but taking a quick look IORING_CQE_BUFFER_SHIFT=16, so we only have
16 bits in cqe::flags for indexes we return.

-- 
Pavel Begunkov
