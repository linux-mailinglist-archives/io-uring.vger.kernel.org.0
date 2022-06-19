Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE24A550B27
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 16:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiFSOVZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 10:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiFSOVY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 10:21:24 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C29DEDD
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 07:21:22 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id es26so10146602edb.4
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 07:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Lp7u3TRNim2T4zhs2sDrbOuiOQISPeP+ge2N7EoOV20=;
        b=klAqz8+bhe+AQNDBsYDnHIBf4AAAx7BGgdjs4hjw+7of39NQi0E966qrTrFmYf4r6Z
         DBQ4s2M/DX7bOTVRQ2ZJNS+tyFm5jYZtXsxDGpLAyoRtVg1vslSUDbB7BqW4GYyaqjmk
         iMjOkhv1VfKl1YXzqRsLa3A9sJdwET6chEg+QADiBTqlK2ypLh+L/ovA9o2w3W3T3Z9Y
         rfUUi/purEadrU7s9LyG+NNP4TKrGgw95gDJuN/6+EtqU0wZvVpEH/6qDdkdelwgF1r9
         H1riHNrPqHzhIo//V2vjosnLnxulvMCgI7wDwWzUA1Y01Z/jlItC+qtOPTzUjjlyA/oG
         uVFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Lp7u3TRNim2T4zhs2sDrbOuiOQISPeP+ge2N7EoOV20=;
        b=31q63NaYOzEUKkPs+vMt9KGMlJVkLDujB0xp6mFcBOJf8MI76Flwv5I8YbnqSjc+IB
         qFL/Pm5s1+42WEd+leTgev//aGTDmFp0UlwqUPH8rgPoh4tgMPbedEDwxjKpa1aOmn9F
         oC0/UDY+jMvFClwsbcgx4dVlUwEY+FjT2Dg+Hd2DtNudN3DKZ6FkGqJzlO3Bg4MQuemN
         YEQe3ZaelzcMrctCw6I8nXhlXsE2tP5B/konf2N90ylI3sx5N14QFd9WyKTqQ54zZoY8
         tSkRLUJqZEwzf63CpqY77MNbYRBUHj1ZL5jpGtDrB15q9azbR6ezrrthNfLw2tN1cChQ
         BsuA==
X-Gm-Message-State: AJIora/XMXzd/znQHAvK4PkKeTK5FtFuah/COmzxv+CuAOeCl8MbNHcU
        QMRGAZFfgDWt0tMXvckx3nk=
X-Google-Smtp-Source: AGRyM1sl7gGBZlFWOz9PpB6G0QCK51lhUEzvZt3Pd1Z4EUkd/gwp1pVfMxx6DQCv0dej7THtx4VR5g==
X-Received: by 2002:a05:6402:27c8:b0:42e:2e43:86ae with SMTP id c8-20020a05640227c800b0042e2e4386aemr24172310ede.427.1655648481391;
        Sun, 19 Jun 2022 07:21:21 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020a17090632db00b00721d8e5bf0bsm1795651ejk.6.2022.06.19.07.21.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jun 2022 07:21:20 -0700 (PDT)
Message-ID: <f967dcd4-9078-e5a4-4d0c-7a757e47aee4@gmail.com>
Date:   Sun, 19 Jun 2022 15:20:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 6/7] io_uring: introduce locking helpers for CQE
 posting
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1655637157.git.asml.silence@gmail.com>
 <693e461561af1ce9ccacfee9c28ff0c54e31e84f.1655637157.git.asml.silence@gmail.com>
 <91584f2b-f7bb-ec20-8b27-62451e2b19e0@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <91584f2b-f7bb-ec20-8b27-62451e2b19e0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/19/22 14:30, Jens Axboe wrote:
> On 6/19/22 5:26 AM, Pavel Begunkov wrote:
>> spin_lock(&ctx->completion_lock);
>> /* post CQEs */
>> io_commit_cqring(ctx);
>> spin_unlock(&ctx->completion_lock);
>> io_cqring_ev_posted(ctx);
>>
>> We have many places repeating this sequence, and the three function
>> unlock section is not perfect from the maintainance perspective and also
>> makes harder to add new locking/sync trick.
>>
>> Introduce to helpers. io_cq_lock(), which is simple and only grabs
>> ->completion_lock, and io_cq_unlock_post() encapsulating the three call
>> section.
> 
> I'm a bit split on this one, since I generally hate helpers that are
> just wrapping something trivial:
> 
> static inline void io_cq_lock(struct io_ring_ctx *ctx)
> 	__acquires(ctx->completion_lock)
> {
> 	spin_lock(&ctx->completion_lock);
> }
> 
> The problem imho is that when I see spin_lock(ctx->lock) in the code I
> know exactly what it does, if I see io_cq_lock(ctx) I have a good guess,
> but I don't know for a fact until I become familiar with that new
> helper.
> 
> I can see why you're doing it as it gives us symmetry with the unlock
> helper, which does indeed make more sense. But I do wonder if we
> shouldn't just keep the spin_lock() part the same, and just have the
> unlock helper?

That what I was doing first, but it's too ugly, that's the main
reason. And if we find that removing locking with SINGLE_ISSUER
is worth it, it'd need modification on the locking side:

cq_lock() {
	if (!(ctx->flags & SINGLE_ISSUER))
		lock(compl_lock);
}

cq_unlock() {
	...
	if (!(ctx->flags & SINGLE_ISSUER))
		unlock(compl_lock);
}


-- 
Pavel Begunkov
