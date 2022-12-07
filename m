Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AA8645DFF
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 16:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiLGPw2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Dec 2022 10:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiLGPwK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Dec 2022 10:52:10 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6653654F2
        for <io-uring@vger.kernel.org>; Wed,  7 Dec 2022 07:51:39 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id o189so6343445iof.0
        for <io-uring@vger.kernel.org>; Wed, 07 Dec 2022 07:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XUqdNv3LlspC4ExSz7fNrloNFMiDEMn7qssKBqs9s8I=;
        b=tuLNk5I2wvb/WHtuUKBqHIvs0qMQkmnMU0eiB0W+sb4md7ccroaMYTZJfGvucfnnOa
         4BLW+GQxnKyfBx7YnkX941iAgTcrAWSJ2Pezl2GXUuOMrER3ilmQMEAthzRcGUUkcchN
         7iJVcx4zFDgp+5VfEryfyzbycm1Zi0aXhCMzhfzp30aWEIH37+60YBbf5GwCso6yEORF
         pcxHps+NhQXBsYWcqKScc5OwFC5c/E09KT7qD7HxUOrynAQaGONhth1zJk5BVgNAW1Nn
         jCzrFGt+54yWRA2909VIM4c1mwLCZ4SXI8pP9MOASrv5EduCAtOCy/QyMk80rNkHeAl8
         RvMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XUqdNv3LlspC4ExSz7fNrloNFMiDEMn7qssKBqs9s8I=;
        b=Ka8xodJ4IFAmZXPxkcgiRB9XNKZ/PBz9y+nyQJt+Ro0VLUVqWHQOOWp/uXSlhySV4c
         hSTSKX+nflHjN60dqeCqRJ5Omk1EbEps9qpUUGzvaJjf4F7n7BoMtjGkj51nAGqF9xrQ
         nWiLIzWw2tNI8YXcLxYeSMAoPz7fRmvIMhA/O/Xq24HWPIjSj3aQXlIFk7Ca7DHTGUWP
         Cv/Cx5oiU8BhF931PaJ7wkXhCFF+uYQ5fj1icWJmUVjrVUWTxasy+fMLLraiRVs/4BSK
         fnRuEJQsn3gQ+YW20kadLqXe7w14Z0Swhbu//oRUwEuWoNtecJ9q7C0W1fjG/uVyHjAg
         w4Vw==
X-Gm-Message-State: ANoB5pmMhKtwVgLb8D5zCcS/GKBSU37+IbE7nVZqr1qJ816aBWfnA5Fr
        h6X/NtSTeW9UKGqsEK65RUlSsP3nTVSXU4L7a5g=
X-Google-Smtp-Source: AA0mqf4rHOvaXo68kkU/vixaY+71ouBCh9JGuTn7UATzm3I+DZBILWgkZozAwwO+sFp1wr+uqraczQ==
X-Received: by 2002:a5d:9f0a:0:b0:6df:c6b6:df00 with SMTP id q10-20020a5d9f0a000000b006dfc6b6df00mr13405991iot.173.1670428298979;
        Wed, 07 Dec 2022 07:51:38 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r3-20020a92d443000000b002eb3b43cd63sm7087870ilm.18.2022.12.07.07.51.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 07:51:38 -0800 (PST)
Message-ID: <f36043e9-cda3-3275-d945-26d121255d2f@kernel.dk>
Date:   Wed, 7 Dec 2022 08:51:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH for-next v2 11/12] io_uring: do msg_ring in target task
 via tw
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1670384893.git.asml.silence@gmail.com>
 <4d76c7b28ed5d71b520de4482fbb7f660f21cd80.1670384893.git.asml.silence@gmail.com>
 <3957b426-2391-eeaa-9e02-c8e90169ec2e@kernel.dk>
In-Reply-To: <3957b426-2391-eeaa-9e02-c8e90169ec2e@kernel.dk>
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

On 12/7/22 8:31 AM, Jens Axboe wrote:
> On 12/6/22 8:53?PM, Pavel Begunkov wrote:
>> @@ -43,6 +61,15 @@ static int io_msg_ring_data(struct io_kiocb *req)
>>  	if (msg->src_fd || msg->dst_fd || msg->flags)
>>  		return -EINVAL;
>>  
>> +	if (target_ctx->task_complete && current != target_ctx->submitter_task) {
>> +		init_task_work(&msg->tw, io_msg_tw_complete);
>> +		if (task_work_add(target_ctx->submitter_task, &msg->tw,
>> +				  TWA_SIGNAL))
>> +			return -EOWNERDEAD;
>> +
>> +		return IOU_ISSUE_SKIP_COMPLETE;
>> +	}
>> +
> 
> We should probably be able to get by with TWA_SIGNAL_NO_IPI here, no?

Considering we didn't even wake before, I'd say that's a solid yes.

-- 
Jens Axboe


