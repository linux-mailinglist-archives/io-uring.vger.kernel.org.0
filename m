Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE62550D62F
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 02:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237157AbiDYAfc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 Apr 2022 20:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbiDYAfb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 Apr 2022 20:35:31 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696D51707B
        for <io-uring@vger.kernel.org>; Sun, 24 Apr 2022 17:32:29 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n18so23481952plg.5
        for <io-uring@vger.kernel.org>; Sun, 24 Apr 2022 17:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xCp93gHKMBrII7N8V2EyKue28sPjOO56P2j/yoVrVI0=;
        b=8Tp2QtsoCFGGMzj1I1Hw+GGIwHTo6wRFHz6CNLX5th9yE1wEdhVHpQIi4T3mT6di6a
         y3f8gkPmmkhC3csGgNRydHMn2jWhOEhNetXOpijZu32dgwpeN0Fx2EfiYmJi1WFQMJlh
         jhC8hr8bdexd+AdIxxUi9BCofHPp1ZwnjGhdZq/evZ881M4OxOJVSkMn0FzO8P21QW6k
         TxtI7GkXleyJy1PaR797NkhOilFUtweYmX4SXgJ3/2/41SWDvitztiPrK5EsqkwA2u0N
         oSg2NRPKiFkC3YBQoGSUOuIVa4DXzDkpKrDZT2hv6qFasCZPQbTQ48R1rPBeZWaKL6QN
         bi0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xCp93gHKMBrII7N8V2EyKue28sPjOO56P2j/yoVrVI0=;
        b=4vrpWYR41DH06Z5qFROtv7bVoRDIA/S7VXQskNOWpIaeP2tSnEgzqn+uFktebLqBKo
         oz7u6/MS7A1K/SnH059MYZhNkT6JX72hSqrka+cBw4X/jmsulG08BWnUAVhw/zQnMsiA
         xRYSt8qVj57+1QJeYfBoQrP7SoLjsQzWCp8jLUOczIdWIeLSTWCkYoCPNpdnsbJQ2VCu
         lb/ISlf+rPF2ezkVX1cmmaMH1+UutSQdh5DJ3iAeLWmPRzo9sOzff5wEjlE6EFe5DYjI
         a0qr3ykytMdH+QjjzMTQylXypmNsmPi2jfuHKI9IMe0oWbnzPTHdG/J48P7XIhsKVCfd
         vr3g==
X-Gm-Message-State: AOAM531KSSIciMx0M5bKF2px7WupHjm9DzHNWSqbWUmtaj1S232qca5l
        h/V/uCslTO80kd32HsvU8kJfDw==
X-Google-Smtp-Source: ABdhPJxhR4LjYgoa+Ve+tb/LZ7MQbkZ6Q9zmGZ9k5tvcPZsrUvhB59HKUBFeMD0YjMEmaca1eYNbWQ==
X-Received: by 2002:a17:90b:3508:b0:1d2:ef2f:9f8c with SMTP id ls8-20020a17090b350800b001d2ef2f9f8cmr28755561pjb.42.1650846748780;
        Sun, 24 Apr 2022 17:32:28 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p1-20020a056a000a0100b0050ac9c31b7esm9916085pfh.180.2022.04.24.17.32.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 17:32:28 -0700 (PDT)
Message-ID: <aa25d6c1-498a-40a9-a7d1-dfbc94ed7a07@kernel.dk>
Date:   Sun, 24 Apr 2022 18:32:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] io_uring: cleanup error-handling around io_req_complete
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     io-uring@vger.kernel.org, hch@lst.de
References: <CGME20220422101608epcas5p22e9c82eb1b3beef6bf6e1c2e83b4b19b@epcas5p2.samsung.com>
 <20220422101048.419942-1-joshi.k@samsung.com>
 <ca1767ba-0398-e26e-4e80-fe339e769c01@kernel.dk>
 <20220424062241.GA17917@test-zns>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220424062241.GA17917@test-zns>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/24/22 12:22 AM, Kanchan Joshi wrote:
> On Sat, Apr 23, 2022 at 12:06:05PM -0600, Jens Axboe wrote:
>> On 4/22/22 4:10 AM, Kanchan Joshi wrote:
>>> Move common error-handling to io_req_complete, so that various callers
>>> avoid repeating that. Few callers (io_tee, io_splice) require slightly
>>> different handling. These are changed to use __io_req_complete instead.
>>
>> This seems incomplete, missing msgring and openat2 at least? I do like
>> the change though. Care to respin a v2?
> 
> But both (io_msg_ring, and io_openat2) are already using
> __io_req_complete (and not io_req_complete). So nothing is amiss?

Yeah, I guess it's actually fine like that, and would in any case
require more changes to unify the rest. So let's just go with this for
now.

-- 
Jens Axboe

