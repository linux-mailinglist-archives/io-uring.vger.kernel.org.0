Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04056660A7
	for <lists+io-uring@lfdr.de>; Wed, 11 Jan 2023 17:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbjAKQgk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Jan 2023 11:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbjAKQgM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Jan 2023 11:36:12 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73DFE0D1
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 08:36:09 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d9so17323983pll.9
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 08:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RiY0KPU/gcOZD8qg8uMOG8JyPOa/cq5fewT4Bouff2w=;
        b=uRByYXcWKvmsLi52A425tGe1huzOvM8P0nQzrosv+2r4V+FM+josud8dQoCDc9DLIn
         mJlcbutFbckahCDRRNCzgVjLPGgIXn1i5DgmxGSk7O1bs7ah4phEJPFcC+x2nk8bhpO2
         BFfYwTMw4ipp3fTllrP8mlMt3ALZvNgYQT2SwT4Knw53dw+TYa/A2gM8r91SUbU6zi8I
         ok4OABz4ona0ArDt5vv/tddLp0LpoM8+i38rTnxDt0ymWtJJY9yrmk8bo7NmE9sqQBRz
         R8P9Ii9IvT4jTKhMb8FkNQMNXigF81FZ7bbqQ22u+OgXFktw32P6vjVg0aXnXfYrIRcu
         Apkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RiY0KPU/gcOZD8qg8uMOG8JyPOa/cq5fewT4Bouff2w=;
        b=FBFYJn7w2SZXqztX+mos0h+66nsJS9zi+yxcxg/efdAl3ZKZ8l0Y1Wc6ayNiy7Qh4e
         0dKD0ZZBt+DEoOD4RUcUGcZ9/flHRN/Q1DTVlMJ2qJz9i0SN4ieCKAOw50lzhF2uOI8y
         ebBlW6jLaAGyVpEXOmxEeMM4mQ5Nkt7RWy37J9bn/1GbpaxQ0G26biymnV2Oh0pWLWBJ
         qGpKFgHmGso0kI846xAgFBiPiIVHaT6bxQSmMu9C0DFRFkUBTU9vdJE1IFDp+MocPUC1
         oxyMPjb7ROVbqNiJRJm6V3VJkkuO0vw9U50F3GoDX/VNX2Db0USbAkGNRzm8q4jkH17U
         UDVQ==
X-Gm-Message-State: AFqh2kptjiDUEX2NvmJdpkJaZlKOjBzrNVE8F/i69UkQZ7qXvaJXL+oC
        GC8I8GLhAzcvOM/AyqS9StlIVA==
X-Google-Smtp-Source: AMrXdXt1QE10+TH+UFhdFsevXl/DNc5gxYt8lstt1OPItdgnSd6UMypL/PI4B9EiKovMRRs/QV7l/Q==
X-Received: by 2002:a17:90a:be01:b0:226:9d35:c49b with SMTP id a1-20020a17090abe0100b002269d35c49bmr7206577pjs.3.1673454969109;
        Wed, 11 Jan 2023 08:36:09 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jx12-20020a17090b46cc00b00225a8024b8bsm9259042pjb.55.2023.01.11.08.36.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 08:36:08 -0800 (PST)
Message-ID: <2fe23c69-2a51-fba3-47e1-fe9e7b9ab22b@kernel.dk>
Date:   Wed, 11 Jan 2023 09:36:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: IOSQE_IO_LINK vs. short send of SOCK_STREAM
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>,
        Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>
References: <Y77VIB1s6LurAvBd@T590>
 <b8011ec8-8d43-9b9b-4dcc-53b6cb272354@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b8011ec8-8d43-9b9b-4dcc-53b6cb272354@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/11/23 9:32 AM, Stefan Metzmacher wrote:
> Hi Ming,
> 
>> Per my understanding, a short send on SOCK_STREAM should terminate the
>> remainder of the SQE chain built by IOSQE_IO_LINK.
>>
>> But from my observation, this point isn't true when using io_sendmsg or
>> io_sendmsg_zc on TCP socket, and the other remainder of the chain still
>> can be completed after one short send is found. MSG_WAITALL is off.
> 
> This is due to legacy reasons, you need pass MSG_WAITALL explicitly
> in order to a retry or an error on a short write...
> It should work for send, sendmsg, sendmsg_zc, recv and recvmsg.

Dylan and I were just discussing this OOB and was hoping you'd chime
in, as I had some recollection that you were involved with this one.

We should probably ensure this is adequately documented, as it isn't
immediately obvious that you'd need WAITALL for links to work with
receives.

> For recv and recvmsg MSG_WAITALL also fails the link for MSG_TRUNC and MSG_CTRUNC.
> 
> metze
> 

-- 
Jens Axboe


