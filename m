Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBE5646331
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 22:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiLGVXU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Dec 2022 16:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiLGVXT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Dec 2022 16:23:19 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21E7B9C
        for <io-uring@vger.kernel.org>; Wed,  7 Dec 2022 13:23:18 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id r72so7546484iod.5
        for <io-uring@vger.kernel.org>; Wed, 07 Dec 2022 13:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MU+MbJOeX1HLkd+bDTXnuoEuGoRAns1qlJwS7SfRhvU=;
        b=5qFEYCobWp88ve6tAhx/d+WF+kowuMxUq3vmGuj2aIvrbhI9PqZUOtL/f9S2czgNBJ
         tfSEt9jJD+NTWScHouA/pJjAR71hQoeLOvMvAzBKHXLCYlF7sDKfnY/h7L6pqA1Mz2sx
         wn7s5PfZjask+MARGg2H7Ime1at+eFC6TtoEMI/F4tmuTpOjYikBOsjU3Q0rPASeFyb0
         /K4IMA3owSIR82X4nZlBe4u9emotuqp92uJrrW3hlL69oaIVNBTJZMognhW9kAAhOk5E
         CcoGqEDgyVgjmCx+tlonZiYtsm2yq5OdtWhufIhp20Xw/uC0QvkURC/dTs6fqPsL5nyo
         xMjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MU+MbJOeX1HLkd+bDTXnuoEuGoRAns1qlJwS7SfRhvU=;
        b=B/rNwlqDwxKh1EUoddrM22Qc+/L+EuvRBnVemq/bKber+nBylEywmFMl6PN8fgUy/Q
         c5I32GiXO64V4yF0Iaa2WOsrDMBd5YmQo/pPnNeJanFb/b3YoGtKMdceZ77L60uPopsx
         y8dYnWxiOmtKbBKPd9e0CA/M+m0rrCarueKUB5wCMWbcEVrUwN0ufYF+j38K74xggVUf
         zZmxPu7ZuIzNIp4x0uFC9CAYE5W7OuudPtEgmt83dc9QvqsqXUNYeeH0KS5XzYP1h1JW
         rpZEQsvBNY2RtuzND78mw9ZUF6PgFx2qRucj3vQR18nNjnIr15Do4pIQVQPgCE80qlYl
         h3zw==
X-Gm-Message-State: ANoB5pkKGgCGMi+OV1CWOlHgtF2CZiX6CvG/Yc3sLvG5iqGq3prWoGZR
        i29ZVgm0DfAyuBuUn7Rq6WNvuOqVLPJOGPH2Vtg=
X-Google-Smtp-Source: AA0mqf7uPf407kKgdbIb0ztKo9pGPQor1H5/1UkWWi5aGlJ2o4BY/cSqQEpfjEnDO9CVSJpaNUkd/w==
X-Received: by 2002:a02:a88e:0:b0:38a:6579:50e6 with SMTP id l14-20020a02a88e000000b0038a657950e6mr3368841jam.185.1670448198331;
        Wed, 07 Dec 2022 13:23:18 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q23-20020a02b057000000b0038a3b8aaf11sm4422212jah.37.2022.12.07.13.23.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 13:23:17 -0800 (PST)
Message-ID: <ecfb9326-5e65-b57e-7641-3317538308ab@kernel.dk>
Date:   Wed, 7 Dec 2022 14:23:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH for-next v2 01/12] io_uring: dont remove file from
 msg_ring reqs
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1670384893.git.asml.silence@gmail.com>
 <e5ac9edadb574fe33f6d727cb8f14ce68262a684.1670384893.git.asml.silence@gmail.com>
 <bc422c44-b723-8b6e-0d21-980539cd4f6d@kernel.dk>
 <b6f19a3c-fdf3-0c97-1f9b-79260fa09c6c@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b6f19a3c-fdf3-0c97-1f9b-79260fa09c6c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/7/22 2:12 PM, Pavel Begunkov wrote:
> On 12/7/22 13:52, Jens Axboe wrote:
>> On 12/6/22 8:53 PM, Pavel Begunkov wrote:
>>> We should not be messing with req->file outside of core paths. Clearing
>>> it makes msg_ring non reentrant, i.e. luckily io_msg_send_fd() fails the
>>> request on failed io_double_lock_ctx() but clearly was originally
>>> intended to do retries instead.
>>
>> That's basically what I had in my patch, except I just went for the
>> negated one instead to cut down on churn. Why not just do that?
> I just already had this patch so left it as is, but if I have to
> find a reason it would be: 1) considering that the req->file check
> is already an exception to the rule, the negative would be an
> exception to the exception, and 2) it removes that extra req->file
> check.

Let's just leave it as-is, was only mostly concerned with potential
backport pain.

-- 
Jens Axboe


