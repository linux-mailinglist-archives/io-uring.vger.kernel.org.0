Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D85D66D0A8
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 22:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbjAPVEM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 16:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjAPVEL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 16:04:11 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0021BADD
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 13:04:10 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id v3so20485520pgh.4
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 13:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aGK1V5gIC+NujhvS/gu0KGXV3fRO1vgMFkpNG8cQa0g=;
        b=BREqZarjdjYwOpOuuEg9JHsAe4JiObe+oqMxyqGfMECxoGiPEOGUIGYjAY1REEcotc
         8sNpNzJiGxOx7ewfXJ2rlNSomEgnT/i5ddPDuuK/DxgOd1Xzp6/YZ/SgrYY5mS3v6zyW
         pgublYqtz+TNxazSNHi7N3jTLUKu/5XJJlp/LlJ38yxcEAtkmWS2GNuurg+mKQaeOxJg
         iF9Z0dQh3/GbIg+ndvwqfv9LN8iFu+lyQdITBPyqu0a8n30FETFWpJ4kiCr+31IL4NwR
         kdOxrSbI4urtLKyuhP1wsZPWpq4n6z5nXVMjjTnHJAyRoZhgTnuyI63ND/QDiuWaNMGd
         8wCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aGK1V5gIC+NujhvS/gu0KGXV3fRO1vgMFkpNG8cQa0g=;
        b=jkriH6PUhMBE2bfb+pUfHt7+n+CDFhegsF7HuOaWoN3IrVhUSX/2LSpJu5cGmvs5yn
         wKHe//Gh+nPmg7yIDqOzCWHpiDdtOjLpNTX/ALUlDFTlTvG35qmBEYCWPr2Ldk07LrIV
         NhrpsrXowhmNAb14QDRuBHYpQwYsOuS2v+cS93QyWA8wGBss0+65D9Ke4yHclN0moULb
         EWLmaZ1tU+lUyp/rMpsLMm7KH2UEtSNhnA0SZdHjZBIVzymsuCFU7X8ATbDfGGIPyQuV
         mMaPcth/2IUEyDF06ZG2fkiSI60F6xUHjPonW/4lyE5yDDdihyhOWYy8SR+2Fzwqihmc
         VosQ==
X-Gm-Message-State: AFqh2kpkzhY4d5/7mcbOA3CgbQpgoxkkh2Tzz9GkrAZoUSfKysWnPii6
        6wd3vZGuzsghMBrvYHSyum6379wnDQLHfZHl
X-Google-Smtp-Source: AMrXdXvaFBMth1mL2QeLXp8ekTq5Tj2r7JG0WBmXNBamxJISSkA9PUGyedVHQVoFoqdn3f77uRx79A==
X-Received: by 2002:aa7:96bb:0:b0:58d:a90d:b245 with SMTP id g27-20020aa796bb000000b0058da90db245mr234986pfk.1.1673903049801;
        Mon, 16 Jan 2023 13:04:09 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x10-20020aa79aca000000b0058a0e61136asm12714600pfp.66.2023.01.16.13.04.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 13:04:09 -0800 (PST)
Message-ID: <427936d0-f62b-3840-6a59-70138d278cb8@kernel.dk>
Date:   Mon, 16 Jan 2023 14:04:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH for-next 1/5] io_uring: return back links tw run
 optimisation
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1673887636.git.asml.silence@gmail.com>
 <6328acdbb5e60efc762b18003382de077e6e1367.1673887636.git.asml.silence@gmail.com>
 <3b01c5b6-9b4c-0f7e-0fdf-67eb7c320bf0@kernel.dk>
 <92413c12-5cd1-7b3b-b926-0529c92a927a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <92413c12-5cd1-7b3b-b926-0529c92a927a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/23 12:47 PM, Pavel Begunkov wrote:
> On 1/16/23 18:43, Jens Axboe wrote:
>> On 1/16/23 9:48 AM, Pavel Begunkov wrote:
>>> io_submit_flush_completions() may queue new requests for tw execution,
>>> especially true for linked requests. Recheck the tw list for emptiness
>>> after flushing completions.
>>
>> Did you check when it got lost? Would be nice to add a Fixes link?
> 
> fwiw, not fan of putting a "Fixes" tag on sth that is not a fix.

I'm not either as it isn't fully descriptive, but it is better than
not having that reference imho.

> Looks like the optimisation was there for normal task_work, then
> disappeared in f88262e60bb9c ("io_uring: lockless task list").
> DEFERRED_TASKRUN came later and this patch handles exclusively
> deferred tw. I probably need to send a patch for normal tw as well.

So maybe just use that commit? I can make a note in the message on
how it relates.

-- 
Jens Axboe


