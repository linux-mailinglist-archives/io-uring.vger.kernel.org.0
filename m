Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0ECE6EFF0C
	for <lists+io-uring@lfdr.de>; Thu, 27 Apr 2023 03:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbjD0Buq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Apr 2023 21:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240499AbjD0Buq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Apr 2023 21:50:46 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A380A35AD
        for <io-uring@vger.kernel.org>; Wed, 26 Apr 2023 18:50:41 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63f167e4be1so1757868b3a.1
        for <io-uring@vger.kernel.org>; Wed, 26 Apr 2023 18:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682560241; x=1685152241;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=luxzbqqI8t8rakpBG4JFf01AxugJUCsU9ehdqyS/B8Y=;
        b=1cj7R0oLr+inUYmNbrrJ2i34L1CQ80jP3tNPCEBVhajPPw7DuT7vKAM7co9ysZmHKu
         oS2yCnQUS7B0gu5oaGRmZmN9FD3p+PR7M9R7N6L8/1+lfyNQw+D2PILixeiBifunzb6P
         SkMR/X7oKJrsZFqsCG8kpdAKl5xuu9WHbdq9EZHuDKeWoEsAek3Zx47ylYLMsp/ruce3
         qFDOXorK5vgDRvtkQRlDRMB2YkaJ6W/izgTQCd4xqnpd94jPQPZ/l4EsX1jxGu9ht/l6
         VOaG6oAeYVBTc8pLzXz0aV2bz0muJIDH1tMt+VkbRSDj/aWULYF+4hY8nm7g8Bxdfvna
         CCSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682560241; x=1685152241;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=luxzbqqI8t8rakpBG4JFf01AxugJUCsU9ehdqyS/B8Y=;
        b=VdVqJi8U3iEYMwCCtVqWhmV2PuvirESzDdkSM7O94uHKz/W8bes7ZKuXk7uUKYsGqc
         vBM39hP/COz3cCV5hJIHMMSIw82il0VSkoOCM92Qgm8KsckrJAsXkfdD7kNaBl+bp3mh
         jNmNbaO+TXwx6rwos/KSl4dEUbS+hed0EVrNYYKKDma8oEhlpmhk4dQukgtNnfcyqfGc
         G+/oSNDZ40ZZgPv3IgIXnnmEAs1KLwzn/3DgVI56/ms52iFJuV8Ov+O5hPjDSk0O57DF
         Ox9XntUWnOzgK151a4VBhG1VsO+QkiNVz2HCxBCB5+UBLaZBIr+8F262sUD9YqomDARe
         0PFA==
X-Gm-Message-State: AC+VfDyQ/41rdGIH1ZW88up6j8eP9KpE3kaJVV4wr2nsI+tt/5qp8/kZ
        m0BHTrgZJDLGVUsXqlyzS15i5A==
X-Google-Smtp-Source: ACHHUZ5nMumo0VM/w90vMe7LoLxMxLrFAvJKEkMwPDRfnQDtreNZIiivAQL2QZw/McLEVe63W/T+ag==
X-Received: by 2002:a05:6a20:4421:b0:f6:d60d:dbfc with SMTP id ce33-20020a056a20442100b000f6d60ddbfcmr6323888pzb.5.1682560241107;
        Wed, 26 Apr 2023 18:50:41 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n10-20020a63ee4a000000b0051b0e564963sm10492752pgk.49.2023.04.26.18.50.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Apr 2023 18:50:40 -0700 (PDT)
Message-ID: <dbf750fb-5a7b-8d10-d71b-4def3441e821@kernel.dk>
Date:   Wed, 26 Apr 2023 19:50:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v10 2/5] io-uring: add napi busy poll support
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
        kernel-team@fb.com
Cc:     ammarfaizi2@gnuweeb.org, Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230425181845.2813854-1-shr@devkernel.io>
 <20230425181845.2813854-3-shr@devkernel.io>
 <ddb2704e-f3a2-c430-0e76-2642580ad1b5@kernel.dk>
In-Reply-To: <ddb2704e-f3a2-c430-0e76-2642580ad1b5@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/26/23 7:41?PM, Jens Axboe wrote:
>> +static void io_napi_multi_busy_loop(struct list_head *napi_list,
>> +		struct io_wait_queue *iowq)
>> +{
>> +	unsigned long start_time = busy_loop_current_time();
>> +
>> +	do {
>> +		if (list_is_singular(napi_list))
>> +			break;
>> +		if (!__io_napi_busy_loop(napi_list, iowq->napi_prefer_busy_poll))
>> +			break;
>> +	} while (!io_napi_busy_loop_should_end(iowq, start_time));
>> +}
> 
> Do we need to check for an empty list here?
> 
>> +static void io_napi_blocking_busy_loop(struct list_head *napi_list,
>> +		struct io_wait_queue *iowq)
>> +{
>> +	if (!list_is_singular(napi_list))
>> +		io_napi_multi_busy_loop(napi_list, iowq);
>> +
>> +	if (list_is_singular(napi_list)) {
>> +		struct io_napi_ht_entry *ne;
>> +
>> +		ne = list_first_entry(napi_list, struct io_napi_ht_entry, list);
>> +		napi_busy_loop(ne->napi_id, io_napi_busy_loop_should_end, iowq,
>> +			iowq->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
>> +	}
>> +}
> 
> Presumably io_napi_multi_busy_loop() can change the state of the list,
> which is why we have if (cond) and then if (!cond) here? Would probably
> warrant a comment as it looks a bit confusing.

Doesn't look like that's the case? We just call into
io_napi_multi_busy_loop() -> napi_busy_loop() which doesn't touch it. So
the state should be the same?

We also check if the list isn't singular before we call it, and then
io_napi_multi_busy_loop() breaks out of the loop if it is. And we know
it's not singular when calling, and I don't see what changes it.

Unless I'm missing something, which is quite possible, this looks overly
convoluted and has extra pointless checks?

-- 
Jens Axboe

