Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3026B596D03
	for <lists+io-uring@lfdr.de>; Wed, 17 Aug 2022 12:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbiHQKuC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Aug 2022 06:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiHQKuB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Aug 2022 06:50:01 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E996C13A
        for <io-uring@vger.kernel.org>; Wed, 17 Aug 2022 03:50:00 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id v3so15786426wrp.0
        for <io-uring@vger.kernel.org>; Wed, 17 Aug 2022 03:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=kCPSbGOrPvryqv0HeCtJEyWMrNlYuJtBFrxds08Uc4M=;
        b=KT6D+e6z585KrtKixGQXVsGDSiykRDrLx/K1egWoElkC3P45GFxOvW5eaWZbxfIY/f
         ayvkoQGLNnq9S8DbZhjw/GBpc6ppHPTGEqKhvSozkeJeW1aNtO60bmFMEwHwzatoPZNo
         PWThwZwtkmABzB8kLMn9hs+th7/uEZFaAD7Zmz3CwvyXjxxRZiHlMhZ432qYRH84+mzn
         DN6kokREoIHwjNfZVD/Yahx2HqRxllZevPLsZTa2DLdSf/rNNgeE5AVYSdm2kKfV6n1f
         fu3rxc2XgbRk3LJEm1LcZzfzu/hoG7ueeDzvWvpBYV839ZfaekhrhMYQ8IQoiV6JLYc0
         MWQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=kCPSbGOrPvryqv0HeCtJEyWMrNlYuJtBFrxds08Uc4M=;
        b=NWUcSl8jIPtVzVl5DMfuw4wPUkVxfBQ0I75DVcIV+dIbSWYaM+pE82rqN9Pd8x7vZD
         s8toV3Vskr/TX94h9QqlJF4vd5+vzTYQBumuGW1/K+Mt7e2bV7IypRGfncBtitBrxo19
         UTg4l72cjZRMOItlBKbEdZTiXUOsf7AvXyfGRWycUZHNDmo4h7QWPV3VM8Sm1pqsQRFw
         KeNpk0NLO/0YAYmOqlY2ptCabrWxEGJDBffMfsc+PVHIN8uyNBUjJItDPCPnXsuaE9gF
         jrq+CqCRVAlOsqPJ0q6F2exEnCdB0Idfpzdji0374YUN6EKpF/6xvgZcaiiN2r/GCK7o
         DVVw==
X-Gm-Message-State: ACgBeo18olyI5sGME5/VtzYqll/ykudtuQYkMTh3c2T3ZVTf5QDEautI
        UAS7rxWEgB8A5EVMcZjQIp7vRty7/l4=
X-Google-Smtp-Source: AA6agR540mA7emwNzaqcYF/fqCgUfSRkZf2xcXEEvI23SZqnUC7Jafv6UDZyuwlZAbFEf2rZroh2IQ==
X-Received: by 2002:adf:d090:0:b0:220:7188:ac8b with SMTP id y16-20020adfd090000000b002207188ac8bmr14090654wrh.389.1660733399112;
        Wed, 17 Aug 2022 03:49:59 -0700 (PDT)
Received: from [192.168.8.198] (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id s3-20020a7bc383000000b003a550be861bsm1835740wmj.27.2022.08.17.03.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 03:49:58 -0700 (PDT)
Message-ID: <96d18b77-06d8-3795-8569-34de5c8779f1@gmail.com>
Date:   Wed, 17 Aug 2022 11:48:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC 2/2] io_uring/net: allow to override notification tag
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "metze@samba.org" <metze@samba.org>
References: <cover.1660635140.git.asml.silence@gmail.com>
 <6aa0c662a3fec17a1ade512e7bbb519aa49e6e4d.1660635140.git.asml.silence@gmail.com>
 <4d344ba991c604f0ae28511143c26b3c9af75a2a.camel@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4d344ba991c604f0ae28511143c26b3c9af75a2a.camel@fb.com>
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

On 8/16/22 09:37, Dylan Yudaken wrote:
> On Tue, 2022-08-16 at 08:42 +0100, Pavel Begunkov wrote:
>> Considering limited amount of slots some users struggle with
>> registration time notification tag assignment as it's hard to manage
>> notifications using sequence numbers. Add a simple feature that
>> copies
>> sqe->user_data of a send(+flush) request into the notification CQE it
>> flushes (and only when it's flushes).
> 
> I think for this to be useful I think it would also be needed to have
> flags on the generated CQE.
> 
> If there are more CQEs coming for the same request it should have
> IORING_CQE_F_MORE set. Otherwise user space would not be able to know
> if it is able to reuse local data.

If you want to have:

expect_more = cqe->flags & IORING_CQE_F_MORE;

Then in the current form you can perfectly do that with

// MSG_WAITALL
expect_more = (cqe->res == io_len);
// !MSG_WAITALL,
expect_more = (cqe->res >= 0);

But might be more convenient to have IORING_CQE_F_MORE set,
one problem is a slight change of (implicit) semantics, i.e.
we don't execute linked requests when filling a IORING_CQE_F_MORE
CQE + CQE ordering implied from that.

It's maybe worth to not rely on the link failing concept for
deciding whether to flush or not.


> Additionally it would need to provide a way of disambiguating the send
> CQE with the flush CQE.

Do you mean like IORING_CQE_F_NOTIF from 1/2?

-- 
Pavel Begunkov
