Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04FAE561E05
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 16:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237094AbiF3Oed (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 10:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237009AbiF3OeV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 10:34:21 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EAD65D70
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:19:51 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id g39-20020a05600c4ca700b003a03ac7d540so1815836wmp.3
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=yD0Xw2sSMYAhL0S3z/tuwMHi/WikSVKA4z/w85i3b9o=;
        b=dZEV+ettjFtVQy0mNho6ARiJ4LZlvMsf2O/2JgjiPBsVEV0b+IBNPzWBOrI+KSwAzy
         JX4g8RFfgHxMpNuYh4E2Y7ZoSITlDlfUM5TbhfFYSanRsqI4SWumXA2ogAScoELLMcgG
         sthp2nW3D4seFsfYYyOjFEmbjVrB6tyzP4YY3bhnUxd8KW6sp6SA03BUOq3K7XoYciV3
         P8/ah64QcWNS4cR7eN3S/sSCn5XCsJPvCOckGtXwlPObGjTpZe4XvEJ7Qz45hg+D4aq3
         bzTQcDlxvifj9ulGt+Q5vfPrN/UT/lQBLQ6/Icv25msOTRbfiarVB6LBQMENWriGojzj
         Rh5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yD0Xw2sSMYAhL0S3z/tuwMHi/WikSVKA4z/w85i3b9o=;
        b=58KbeO1x3BYR97TKzX/IOijoAA1iGFJW5Bbwcpzxkgn/UnvHzZzgz+H74YTP7MbxS0
         4hyUeLlSRZlECFqvm+UBBq/pwP4qswjJK95R6bKT95W9Ypq6Uuafg46TH+9g8rg+BctK
         EAR4LMSK9B1xP36H17dog/MS3S1hdjdKTVYIV9T0tmRJFgNq8ipJbW/Ok0UG2RqOFf6x
         HFclaulUsiEZFag+zaChh8xbl2toEOF6pIX9ePxqJrIclkN27rupONeKBIOjyrnu2Eti
         tuvNU1GK/P9NNlnokQYxUV6fZ2VMjOyYnkkBPbere4fnI7MQnHRUaZdguhKRAE/C2UTu
         Ukyg==
X-Gm-Message-State: AJIora+Gcy5eEXnMzHnVVNnZZWpGkERCajo0PWFdFFLaeiWIJGgcRQcu
        ij7U9Xa0M/lJAzcry0DB8ywhaUlKU/I5AQ==
X-Google-Smtp-Source: AGRyM1ulon0PI/rqeNp2BXjdBMYGSWFzKSlp6Bv2icMW9++H4/AoMkJwSkswUdyE54jiC53cVZJRSA==
X-Received: by 2002:a7b:c314:0:b0:3a0:5750:1b4a with SMTP id k20-20020a7bc314000000b003a057501b4amr12092481wmj.20.1656598789690;
        Thu, 30 Jun 2022 07:19:49 -0700 (PDT)
Received: from [192.168.43.77] (82-132-232-9.dab.02.net. [82.132.232.9])
        by smtp.gmail.com with ESMTPSA id bd5-20020a05600c1f0500b003a02f957245sm2817437wmb.26.2022.06.30.07.19.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 07:19:49 -0700 (PDT)
Message-ID: <af745cb5-908c-1532-e5ea-a875a5166ec7@gmail.com>
Date:   Thu, 30 Jun 2022 15:19:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 3/3] test range file alloc
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
References: <cover.1656580293.git.asml.silence@gmail.com>
 <decaf87bd125ad0e77261985e521926aff66ff34.1656580293.git.asml.silence@gmail.com>
 <30f95627-eb6c-c743-8fb2-11b0b874e00b@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <30f95627-eb6c-c743-8fb2-11b0b874e00b@kernel.dk>
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

On 6/30/22 14:09, Jens Axboe wrote:
> On 6/30/22 3:13 AM, Pavel Begunkov wrote:
>> @@ -949,5 +1114,11 @@ int main(int argc, char *argv[])
>>   		return ret;
>>   	}
>>   
>> +	ret = test_file_alloc_ranges();
>> +	if (ret) {
>> +		printf("test_partial_register_fail failed\n");
>> +		return ret;
>> +	}
> 
> If you're returning this directly, test_file_alloc_ranges() should use
> the proper T_EXIT_foo return codes.

Nobody cared enough to "fix" all tests to use those new codes, most
of the cases just return what they've got, but whatever. Same with
stdout vs stderr.

-- 
Pavel Begunkov
