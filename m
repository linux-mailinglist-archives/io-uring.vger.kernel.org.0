Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48418561E86
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 16:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbiF3O5s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 10:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbiF3O5q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 10:57:46 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157B71D0FD
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:57:46 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id m13so19450534ioj.0
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=AaW1iBSok+7ZMdnY/5TEfHxpbacDAZPmWERHTCZvLJc=;
        b=My/FtdyKthbmbH4iTzjWqJDjJ/wX0Z6bl9UBAWEzWIE+NQbnyOGGIUFaLIrvNcKMo9
         kETE+HBoL2gs3cbwq9tBkXvys9zwjZunsP6fO9zT18Jb7T/S1mP9olyC2l4VN8Pzn5ro
         MB1wNWPNRVUVdOxsMYBQFyV9QA7CDElTpHzRKi2WfqMKrDi7lysUnwkhMrmKr/N8rWcy
         0oXrNp8AxHZxKrZXpL3iWK5hQ0v/EBaQV3QgQJTU3rBZ2B5ot+Lxe+1FzXmmlJ7HZC+s
         21alSEC2zWmOR2jDjGiqZPheieUR+A8aLgKZs+McIDRkPNDjgSqxf5Ke4TpvZuWmGBBz
         ZYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AaW1iBSok+7ZMdnY/5TEfHxpbacDAZPmWERHTCZvLJc=;
        b=1tCCRcrKn6W36qPH0fTFbmoQP9s/eapAzXmKG3HumjmIPnaYwzl4SVkny2GHJQfaOc
         7ThZKiJM1OIMG2q7k52J8l0xFZCzyvHPSnxDed651SX+IOsrBRrsH4kjC/uBZW4CVeXu
         wNMQvphHdOjhbraga50TgFxZ++vtzSkgGIEtXoL6SCF98IvVIExc2c6AVB1QTImJu0lS
         9RhPNRb7Yl0T/iNH+LcM2f6jCv1x9xyVqvlugJ/sntCCwnholazHKex9O1dhgvTMsNnJ
         YQCHTDCmz5udkyPD+w2VsRkMCqQhwtWh2VsfhRxDPqe5+vwqAVWIQPo1ZHSfWTTNwfLi
         XreQ==
X-Gm-Message-State: AJIora9kDoze2H4on8zwKUja6OIjR5ztrUSN55MHEt7QHepuk3VTCk7/
        D+k23fF3w0/sPvcjw+rDbBBysw==
X-Google-Smtp-Source: AGRyM1vWDaiP7wR60OReqhsp8q18YwUru9UWvy1wRXnkC60oywFlp3NFF9TGqa7KRWaMGXq7PnKN1g==
X-Received: by 2002:a6b:d309:0:b0:664:716c:d758 with SMTP id s9-20020a6bd309000000b00664716cd758mr4648308iob.157.1656601065414;
        Thu, 30 Jun 2022 07:57:45 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z19-20020a05663822b300b00331f1f828adsm8699833jas.16.2022.06.30.07.57.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 07:57:45 -0700 (PDT)
Message-ID: <831c6fb0-8d31-4867-0510-ae25d41acac6@kernel.dk>
Date:   Thu, 30 Jun 2022 08:57:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 3/3] test range file alloc
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
References: <cover.1656580293.git.asml.silence@gmail.com>
 <decaf87bd125ad0e77261985e521926aff66ff34.1656580293.git.asml.silence@gmail.com>
 <30f95627-eb6c-c743-8fb2-11b0b874e00b@kernel.dk>
 <af745cb5-908c-1532-e5ea-a875a5166ec7@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <af745cb5-908c-1532-e5ea-a875a5166ec7@gmail.com>
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

On 6/30/22 8:19 AM, Pavel Begunkov wrote:
> On 6/30/22 14:09, Jens Axboe wrote:
>> On 6/30/22 3:13 AM, Pavel Begunkov wrote:
>>> @@ -949,5 +1114,11 @@ int main(int argc, char *argv[])
>>>           return ret;
>>>       }
>>>   +    ret = test_file_alloc_ranges();
>>> +    if (ret) {
>>> +        printf("test_partial_register_fail failed\n");
>>> +        return ret;
>>> +    }
>>
>> If you're returning this directly, test_file_alloc_ranges() should use
>> the proper T_EXIT_foo return codes.
> 
> Nobody cared enough to "fix" all tests to use those new codes, most
> of the cases just return what they've got, but whatever. Same with
> stdout vs stderr.

We'll get there eventually, it's just a bad idea to add NEW tests that
don't adhere to the new rules.

As for stdout vs stderr, by far most of them do it correct. Again, new
tests certainly should.

-- 
Jens Axboe

