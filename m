Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD364E5C60
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 01:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346817AbiCXAha (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 20:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346808AbiCXAha (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 20:37:30 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57B588B0A
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 17:35:59 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id j13so3155595plj.8
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 17:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Izgfg/oI5zYeaCDxkub+eMw0ElM6DVSvB82ta5GTPhw=;
        b=Ndse15B+qwG0d2/LFkWCD1OGy7onij507tn5U1ujD0RfO8JLvzF8etQpyeBE1enDLK
         PXr76JJWOh3KNdF9qnku1IvPLNTY5rxoxiC6cCfTyWfQH0AbYDj7qAmbyzu9R4uYyy3T
         bYE61uMe5F46ee4kQToxKtZiAs9MGKxTbj3S5jPfyBokHNLkavoMjFncvInwvVPXZ0tX
         nLff/XFyn6ZHROb667yHynDXGL7aZIjgHkZmvUnfeAjOjEDb3Aa5rMMDeXuJ3DaQWpvE
         lacUzIQ1cKci0jcIgKu8tSc4zL4MDEkpkbDd42dQkjs2Z4fW7SAbwB0O7jwuFasZ+FLG
         rKzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Izgfg/oI5zYeaCDxkub+eMw0ElM6DVSvB82ta5GTPhw=;
        b=V3R4yGRC4nmp82BUEvLw1Le9xyAb/l9m+pCm7G3IgCOSUL1Pj/7HuDTq0B98tiLn3Z
         ME3NwgA/dllKPWYbVtxF7edQ4I8m+ktwFoLUjbOuttz1JRAdhhigaswXR3GU7AmPlQYK
         TUHwQ0bNolDF03BeVUvrKHtSR4JkDDpfLoU8xH+5J2rtTFQMUlpK2NyQh7DkHzvNNCS1
         dRm+6bQt2LiThbBNKHZ29YwGZDXERwvtcvt4sBAgtR4atfsgk6kZa1HwQRPbqu+yG9CX
         ahCSbYw0JCPGx2Qe/Hlp2+v+TL56sUNR2bT1b8b2+SBEK3JmmEZYiHlIQ+gCd5LxwKd3
         hjzw==
X-Gm-Message-State: AOAM5302eTY3wswFiKyBRXSZ+ihsijJADICl6ATBpiEo9k+kcjq+eZTu
        DUWz1Tm+npn9BANdEwuVmNSGhpubwudZGwf4
X-Google-Smtp-Source: ABdhPJz0aefpKM0Tn/gz9aL/6LXXn+Bq0nfE/b2siBP6hlnYsRjAI7+icomtl/B0a7G9H77SZourLA==
X-Received: by 2002:a17:903:11c7:b0:151:7290:ccc with SMTP id q7-20020a17090311c700b0015172900cccmr2917214plh.95.1648082159139;
        Wed, 23 Mar 2022 17:35:59 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u10-20020a63b54a000000b00380ea901cd2sm778338pgo.6.2022.03.23.17.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 17:35:58 -0700 (PDT)
Message-ID: <fe39288b-95a1-5300-f2ea-3c7018dfa18a@kernel.dk>
Date:   Wed, 23 Mar 2022 18:35:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] io_uring: ensure recv and recvmsg handle MSG_WAITALL
 correctly
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     constantine.gavrilov@gmail.com, stable@vger.kernel.org
References: <20220323224131.370674-1-axboe@kernel.dk>
 <20220323224131.370674-2-axboe@kernel.dk>
 <51a79835-9186-695c-0304-bfd6e6a5d17d@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <51a79835-9186-695c-0304-bfd6e6a5d17d@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/23/22 6:32 PM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>> @@ -5524,12 +5542,22 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>               return -EAGAIN;
>>           if (ret == -ERESTARTSYS)
>>               ret = -EINTR;
>> +        if (ret > 0 && io_net_retry(sock, flags)) {
>> +            sr->len -= ret;
>> +            sr->buf += ret;
>> +            sr->done_io += ret;
>> +            return -EAGAIN;
>> +        }
>>           req_set_fail(req);
>>       } else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
>>   out_free:
>>           req_set_fail(req);
> 
> The change only affects retry based socket io in the main thread, correct?

Not sure I follow - it affects retries for streams based sockets, where
previously they could be broken into two pieces when they should not be.

> The truncated mesages still trigger req_set_fail if MSG_WAITALL was set?

If we don't retry, regardless of flags, then we'll set failure on the
request to break links. If it ends up transferring the whole amount,
regardless of whether or not it happens in one go or not, it will not
fail links.

-- 
Jens Axboe

