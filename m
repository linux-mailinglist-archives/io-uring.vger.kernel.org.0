Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33476565B9B
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 18:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbiGDQUh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 12:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbiGDQUR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 12:20:17 -0400
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1ED13CEE;
        Mon,  4 Jul 2022 09:19:13 -0700 (PDT)
Received: by mail-wm1-f46.google.com with SMTP id u12-20020a05600c210c00b003a02b16d2b8so5951511wml.2;
        Mon, 04 Jul 2022 09:19:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XmnLu4Qef4dfNrY0uAMDFIS143n6y4DAB7rTUJQV5rw=;
        b=0eWlX06udcMpVsd+weyUvlCb1xVu+SC6jWWcKl232eAJuyGyqatU9lLzGSZY0e/T6V
         dru89jdWDGZoM+3IapzgxygGkKvXXayTTGOhm6ail0gA7I+SkmrXKQ7WdfW+tSHP8oIa
         Cd6Ald0wVBoyIGLksRXkGKy3OxnkkUW4zestDHGVObR9XCpwG6/n6SHA9cTTRNXKKsCu
         7tkkGPkpOcj9keHXqLQ0HCKaLxNc7ARjUtitO9fwlMQL8hDS1ZnJNtIipMj9W3YBReXH
         4MTgBqDtMoPGYh6dk7qmL20Gj/t6m+RCsJhr8ajlo5G2SgwkwAz0T5EXUc0elHlyiW5h
         qXtg==
X-Gm-Message-State: AJIora/tgj/Cf/NP5qZnI0ne7377hq4r3YuwX9Id+GuMFbTfPtOcVp/C
        U1fjKO/oJI8fI9AYJ9ALaJU=
X-Google-Smtp-Source: AGRyM1sqSSitMlpKRNVliWk55gdN5vT7HuBFqfVO6Mj2Ek/+kOV/MdD7Opr9fFxQJvfqgpVfobLwpw==
X-Received: by 2002:a05:600c:3588:b0:3a1:74c8:e7e8 with SMTP id p8-20020a05600c358800b003a174c8e7e8mr30500410wmq.64.1656951551877;
        Mon, 04 Jul 2022 09:19:11 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id d7-20020a5d5387000000b0021d5c52f4b4sm6930966wrv.34.2022.07.04.09.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 09:19:11 -0700 (PDT)
Message-ID: <c2053491-abb6-dc75-923d-bfea81431afa@grimberg.me>
Date:   Mon, 4 Jul 2022 19:19:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH V3 1/1] ublk: add io_uring based userspace block driver
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <20220628160807.148853-1-ming.lei@redhat.com>
 <20220628160807.148853-2-ming.lei@redhat.com>
 <da861bbb-1506-7598-fa06-32201456967d@grimberg.me> <YsLeR1QWPmqfNAQY@T590>
 <8cf1aef0-ea5b-a3df-266d-ae67674c96ae@grimberg.me>
 <87a69oamap.fsf@collabora.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <87a69oamap.fsf@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


>>>>> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
>>>>> index fdb81f2794cd..d218089cdbec 100644
>>>>> --- a/drivers/block/Kconfig
>>>>> +++ b/drivers/block/Kconfig
>>>>> @@ -408,6 +408,12 @@ config BLK_DEV_RBD
>>>>>     	  If unsure, say N.
>>>>> +config BLK_DEV_UBLK
>>>>> +	bool "Userspace block driver"
>>>>
>>>> Really? why compile this to the kernel and not tristate as loadable
>>>> module?
>>> So far, this is only one reason: task_work_add() is required, which
>>> isn't exported for modules.
>>
>> So why not exporting it?
>> Doesn't seem like a good justification to build it into the kernel.
> 
> Sagi,
> 
> If I understand correctly, the task_work_add function is quite a core
> API that we probably want to avoid exposing directly to (out-of-tree)
> modules?  I agree, though, it would be great to have this buildable as a
> module for general use cases.  Would it make sense to have it exposed
> through a thin built-in wrapper, specific to UBD, which is exported, and
> therefore able to invoke that function?  Is it a reasonable approach?

All I'm saying is that either we should expose it (or an interface to
it) if it has merit, or use something else (use a workqueue).
Having a block driver driver builtin is probably not the answer.
