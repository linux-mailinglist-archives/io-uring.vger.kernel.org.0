Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF8B504801
	for <lists+io-uring@lfdr.de>; Sun, 17 Apr 2022 16:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234229AbiDQOcD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Apr 2022 10:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiDQOcC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Apr 2022 10:32:02 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D072275E3
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 07:29:26 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id g20so15015283edw.6
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 07:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=fqJbln8YQ4waTg+isHQsHzETKv6VVtbhKrES65CPdAI=;
        b=lUd4jJ9gowdT8YQ9YKDhPLMX/TKdWNIx76F0fA/fly4e5qw1pwOf2PztqOwdFMs8TX
         IwNdBZ4IQ3ZL/ha0KECEFeF1QcVff3fx+ZnjpsIsVHeIOlp36GbMQYP9K5mEkLqnbgxw
         O0XH5krv0l+L7BnP3eNxHo8ORupdiRCgvbIQfu80/dlL33MZdioziPvhKZOOpYyHR9Cw
         Cwn7aTUzm0uhbNpMYc3QtmVdkxVBwxXvrQKCriMHGTLqtOjWCqvEXudgXmfvCuhPdf7E
         EmqEC2yGZQ9JGI1/zgAN8c5SsIow4BdWZddCoJ+sRZo411B4SvmqguzLM/lGBtC/esNx
         jg0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fqJbln8YQ4waTg+isHQsHzETKv6VVtbhKrES65CPdAI=;
        b=Drk+uaLJ9KsBqwNnFX5XPK/DhkdpENCr7VFyMu/CinOqCemNjlBIl+rsGhr5C+pdxs
         Mxu9+lE242+FiQD1DfblkSD5OJM+EH78+1PJMVkQWEfVA5aSczDVMd+u29Z/NqzOiE4S
         Nk4QERTLVCUb10I0eRDtSuIkQgDUmH/JaqmHD9k9eY7tTnN5AV2QPrDBkn7lLRekjfU9
         uGPcNzao+f5I/y9gW799FOYa9MtKU5OMUXaDK2TP6jWPz9WmWOA5do+1dFBEBSooGBxp
         hrzIGmwg/7YGkJ9n0uZbKgrleEGJDrWCs4dEohT/mWG2FHkiBP9P5ijTZ6UePi5NtvOR
         5ulA==
X-Gm-Message-State: AOAM532ylnSiC+CUxtXRet/uSxiQ0IeJQKhmA2x0IiCXQH9aVoAm4sgX
        /dB+Ax0L+ixSQNUsWYnx4q12vh2qaeA=
X-Google-Smtp-Source: ABdhPJyRnUF56OrdswZxLjZzdxgqyaI04aCRk1e3OjkQsc7jy0XbXILli0BmxuHM+/CiBryz9YUxHg==
X-Received: by 2002:a05:6402:484:b0:415:d931:cb2f with SMTP id k4-20020a056402048400b00415d931cb2fmr8058219edv.287.1650205764560;
        Sun, 17 Apr 2022 07:29:24 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.82])
        by smtp.gmail.com with ESMTPSA id el14-20020a056402360e00b0042121aee887sm5060870edb.77.2022.04.17.07.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Apr 2022 07:29:24 -0700 (PDT)
Message-ID: <9e68f46d-6fa1-e62d-b6d4-2c41d7d8e6ef@gmail.com>
Date:   Sun, 17 Apr 2022 15:28:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH liburing 3/3] tests: add more file registration tests
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1650186365.git.asml.silence@gmail.com>
 <d50933f8313050ee43353a1f0f368df9f9ea00c0.1650186365.git.asml.silence@gmail.com>
 <952f73a9-0a2d-bd4f-0489-b17c80a931ef@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <952f73a9-0a2d-bd4f-0489-b17c80a931ef@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/17/22 14:00, Jens Axboe wrote:
> On 4/17/22 3:09 AM, Pavel Begunkov wrote:
>> diff --git a/test/file-register.c b/test/file-register.c
>> index bd15408..ee2fdcd 100644
>> --- a/test/file-register.c
>> +++ b/test/file-register.c
>> @@ -745,7 +745,90 @@ static int test_fixed_removal_ordering(void)
>>   	return 0;
>>   }
>>   
>> +/* mix files requiring SCM-accounting and not in a single register */
>> +static int test_mixed_af_unix(void)
>> +{
>> +	struct io_uring ring;
>> +	int i, ret, fds[2];
>> +	int reg_fds[32];
>> +	int sp[2];
>> +
>> +	ret = io_uring_queue_init(8, &ring, 0);
>> +	if (ret < 0) {
>> +		fprintf(stderr, "failed to init io_uring: %s\n", strerror(-ret));
>> +		return ret;
>> +	}
>> +	if (pipe(fds)) {
>> +		perror("pipe");
>> +		return -1;
>> +	}
>> +	if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sp) != 0) {
>> +		perror("Failed to create Unix-domain socket pair\n");
>> +		return 1;
>> +	}
>> +
>> +	for (i = 0; i < 16; i++) {
>> +		reg_fds[i * 2] = fds[0];
>> +		reg_fds[i * 2 + 1] = sp[0];
>> +	}
>>   
>> +	ret = io_uring_register_files(&ring, reg_fds, 32);
>> +	if (!ret) {
>> +		fprintf(stderr, "file_register: %d\n", ret);
>> +		return ret;
>> +	}
> 
> This check looks wrong.

Agree, resending it

-- 
Pavel Begunkov
