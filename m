Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEA964CDAD
	for <lists+io-uring@lfdr.de>; Wed, 14 Dec 2022 17:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238407AbiLNQHF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Dec 2022 11:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238869AbiLNQHE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Dec 2022 11:07:04 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E106F57
        for <io-uring@vger.kernel.org>; Wed, 14 Dec 2022 08:07:02 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id b192so3617015iof.8
        for <io-uring@vger.kernel.org>; Wed, 14 Dec 2022 08:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=48hMfidP2iBO5yZhLdWAk8Tc9MJFwg5V0spZeLApJ5Q=;
        b=hYsJVfcDYfvFIiNHnIgrhDmQHZ1dtEecNzWEOAJBSUQQs71elL9WQ6XvSfBofF4EIE
         lBUcmkHtdsukRx5PeqHljxkf780LZwwSuHavh2XKHZexHJ6aHnd62DjjeO371fwdW9LZ
         tVB6CKCEmmnTipeWaRm8x21/18THShIYdzjGzqs+FtMwc5nftyivZ4UmWvTDSn2ZlP5O
         5TQTL+WemTFq0qcFTf6FO8JbA1ju0Ww6+OcO0qnCo8aBCuv0HQ0TcdinssHLnCo45Ttq
         HF0sUGmPQ07wWDk2iHde8ZAnVqusiRqi/ubYqOVY9GNTZjE4lwPsP4/P49NxusXWyyTM
         47PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=48hMfidP2iBO5yZhLdWAk8Tc9MJFwg5V0spZeLApJ5Q=;
        b=HchY5hL8B5T+Ot0a9segeERlgbBVrLsRKBCLFCubbhSeKqODMQ6zcBpHvKoYJHp6Cj
         xOuqhwD4hTF/fSgHOJSpspZExWeGpUUEKk3OHGnJtBESfhOjg/Sr18qaPLs/D25iy89q
         /IBqoE+nhAcsXuxVcKotGWOSQ6AIG7MSXh4Ed50sb8x0Oa4aXzyuIMFi80dqvAFXLpvU
         Wyiucm/BJnyrCGM4Ek/UoWZEcTBVp+VY87dB5i9eSoM3+u1EPx5eEI07+PGLi3qALPEI
         fvvldwrKqV6/NPzmt3DMzJVBCpuh1itx2grEj4lkcDB7Rn/bwLTes1S45nkp3CiBAUN4
         NU/w==
X-Gm-Message-State: ANoB5plNrajce0ztO+oMhXhD5fxEe6CN049hzwt3Y0uQLzJ9gq5ebrBl
        ZkQshBHDzXDLmGF21NFTzJJnZKLKPFHQwthAF4c=
X-Google-Smtp-Source: AA0mqf5bOx52HuXV7ONqEYDzIqHHQAIhX00h/Tbe/6Yqv2YSnH1M5FEHXc9ErSWogNYTTUWlVTBm0A==
X-Received: by 2002:a5d:8459:0:b0:6d9:7981:2a76 with SMTP id w25-20020a5d8459000000b006d979812a76mr2764352ior.0.1671034020762;
        Wed, 14 Dec 2022 08:07:00 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u10-20020a02aa8a000000b0038a48cfededsm1854457jai.15.2022.12.14.08.07.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Dec 2022 08:07:00 -0800 (PST)
Message-ID: <18e081a3-d522-05bf-d309-daa9886922e8@kernel.dk>
Date:   Wed, 14 Dec 2022 09:06:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH for-next 0/4] some 6.2 cleanups
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
References: <cover.1670002973.git.asml.silence@gmail.com>
 <167001140694.936996.12312748109578334067.b4-ty@kernel.dk>
In-Reply-To: <167001140694.936996.12312748109578334067.b4-ty@kernel.dk>
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

On 12/2/22 1:03?PM, Jens Axboe wrote:
> 
> On Fri, 02 Dec 2022 17:47:21 +0000, Pavel Begunkov wrote:
>> Random cleanups, mostly around locking and timeouts. Even though 1/4 is
>> makred for stable it shouldn't be too important.
>>
>> Pavel Begunkov (4):
>>   io_uring: protect cq_timeouts with timeout_lock
>>   io_uring: revise completion_lock locking
>>   io_uring: ease timeout flush locking requirements
>>   io_uring: rename __io_fill_cqe_req
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/4] io_uring: protect cq_timeouts with timeout_lock
>       commit: f9df7554e30aa244a860a09ba8f68d9d25f5d1fb
> [2/4] io_uring: revise completion_lock locking
>       commit: f12da342ec9c81fd109dfbafa05f3b17ddd88b2a
> [3/4] io_uring: ease timeout flush locking requirements
>       commit: 4124d26a5930e5e259ea5452866749dc385b5144
> [4/4] io_uring: rename __io_fill_cqe_req
>       commit: 03d5549e3cb7b7f26147fd27f9627c1b4851807b

I apparently fat fingered applying these as part of moving things
around, and as a result, there were not in the tree for 6.2. I've
applied them again in io_uring-6.2 - please take a look, as I needed to
hand apply 1 and 4 because of the other locking changes.

-- 
Jens Axboe

