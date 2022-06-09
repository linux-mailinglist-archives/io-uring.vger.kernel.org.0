Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1B954489F
	for <lists+io-uring@lfdr.de>; Thu,  9 Jun 2022 12:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiFIKTT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jun 2022 06:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241889AbiFIKTP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jun 2022 06:19:15 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5CC8020F
        for <io-uring@vger.kernel.org>; Thu,  9 Jun 2022 03:19:13 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id d19so13134921lji.10
        for <io-uring@vger.kernel.org>; Thu, 09 Jun 2022 03:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IKelqxqncukeOfRBr7AdfQNwKL5qk3SlW4VIBbVXKNI=;
        b=13RIhy7rLAL/d424qAqOTKef4JvPopgE055WvDXyruXW1Ur0cbBl9VbgmuxfZz11fa
         sDjdu6/FjL3VEIHeE4FklmBwvJdB+PMLUaFW4Iwhb//BKGLOMYiBg4W/pmZS1Qz/q+wc
         k7z7bdg42Crfd4we5BbbliXN/nQxVwbUOYCBZVea11/mHD7AEUjk9x4QB8lje5XR0RYl
         heWOm8nM5+HsNPL0aaH8b1i8nVx4dsPtJvS1tn0Ei2yVBTWfTvkf+QTAuqUuc3NW9YF1
         hUCTpkT/GvecN1vB1+ekwkxLJyw8U2dIzrEKZvB/PvQeIbSdS0xLu8p0TkciMOKe2gxF
         +vxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IKelqxqncukeOfRBr7AdfQNwKL5qk3SlW4VIBbVXKNI=;
        b=xt/azILy/+0BPZoLNUJo5xjO/A3cb/jn85KpPhK8U0/tArHASaG70XVNInBnkhbSMU
         L+MpdxIJ8AZWsZ3kQaWlHPQpCIXqMS/sOKDMsJFXgmvjgsZGQIj4vI+TRMXpxyrtq9Eg
         bF3814dRYd3BAkADXuxvLOfM5Itj+UKCpvRcdxbqLvdOrO1cKTDOj1hhmIYqaUup74f+
         sjVNThJaPieavo2oX5nAeqO7uqv0vi7Hpg1HSH5QBGeqBhjkhrTaQvddrxtwnxZPYEAJ
         5gLvi4oU1IIAq5OoSizGPl10+AHscrM07KiNp2JOnS1E/hRVKVVUcRSiPXME8LFKxXUW
         rpdQ==
X-Gm-Message-State: AOAM530BWiZ9lo3t0k1s092jp/H+efezacRGmEmbn5J8MTFNCEDAp3sB
        XoNnopflt3rIrb51WWmMNM2Tkw==
X-Google-Smtp-Source: ABdhPJzvMpNPlZZX7ZskmfYJxzs3vX/TuGZTPAoQ+0hBJ4ibdXO2w8mw3Rz8Te12Q1NfQvzYi/aP6A==
X-Received: by 2002:a2e:b0dc:0:b0:255:a099:37f5 with SMTP id g28-20020a2eb0dc000000b00255a09937f5mr9623173ljl.77.1654769951594;
        Thu, 09 Jun 2022 03:19:11 -0700 (PDT)
Received: from [192.168.172.199] (176-20-186-40-dynamic.dk.customer.tdc.net. [176.20.186.40])
        by smtp.gmail.com with ESMTPSA id k19-20020ac24f13000000b00477c05f9ffbsm4187527lfr.9.2022.06.09.03.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 03:19:10 -0700 (PDT)
Message-ID: <8ec6116d-39cd-ed6c-3477-9165d1a27128@kernel.dk>
Date:   Thu, 9 Jun 2022 04:19:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Possible bug for ring-mapped provided buffer
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <1884ea45-07df-303a-c22c-319a2394b20f@linux.dev>
 <7c563209-7b33-4cc8-86d9-fecfef68c274@kernel.dk>
 <ed5b8a0a-d312-1181-c6b4-95fd126ea9e9@linux.dev>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ed5b8a0a-d312-1181-c6b4-95fd126ea9e9@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/22 4:14 AM, Hao Xu wrote:
> On 6/9/22 18:06, Jens Axboe wrote:
>> On 6/9/22 1:53 AM, Hao Xu wrote:
>>> Hi all,
>>> I haven't done tests to demonstrate it. It is for partial io case, we
>>> don't consume/release the buffer before arm_poll in ring-mapped mode.
>>> But seems we should? Otherwise ring head isn't moved and other requests
>>> may take that buffer. What do I miss?
>>
>> On vacation this week, so can't take a look at the code. But the
>> principle is precisely not to consume the buffer if we arm poll, because
>> then the next one can grab it instead. We don't want to consume a buffer
>> over poll, as that defeats the purpose of a provided buffer. It should
>> be grabbed and consumed only if we can use it right now.
>>
>> Hence the way it should work is that we DON'T consume the buffer in this
>> case, and that someone else can just use it. At the same time, we should
>> ensure that we grab a NEW buffer for this case, whenever the poll
> 
> If we grab a new buffer for it, then we have to copy the data since we
> have done partial io...this also defeats the purpose of this feature.

For partial IO, we never drop the buffer. See the logic in
io_kbuf_recycle(). It should be as follows:

- If PARTIAL_IO is set, then hang on to the buffer. You can't consume a
  partial buffer anyway.

- If no IO has been done and it's a ring provided buffer, just hang on
  to the bgid and clear the fact that we grabbed a buffer. That's all
  you need to do in this case, someone else may grab it and we'll grab a
  new one for this request whenever it's time to do so.

> What the legacy provided buffer mode do in this case is just
> keep/consume that buffer. So I'd think we should keep the consistency.
> But yes, there may be a better way.

The legacy mode has to do that, as it always has to grab the buffer. We
don't need to do that in the ring case, it's an efficiency thing as
well. If we do need to arm poll, we don't have to do anything but ensure
that we grab a new one next time. Consuming it would be the wrong thing
to do in that case, as it defeats the purpose of a provided buffer. You
may as well just pass in a buffer at that point.

-- 
Jens Axboe

