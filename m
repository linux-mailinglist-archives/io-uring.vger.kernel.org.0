Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2681859E896
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 19:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343745AbiHWRHK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 13:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343926AbiHWRED (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 13:04:03 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAA0150154
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 06:33:40 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 67so5290375pfv.2
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 06:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=aCSXGk9NtNmglUVpbUQ1Rjs+YdBMM2XU3YePZpV6vnQ=;
        b=jLH60+HfG5U8ezVkTAuijLoLylLR3TAnYTCNGkRSYaXVEB1RrgRj4cZ2E0d22eIC3K
         92/vTy/0T5iBMTrT7lsqB+KGysInPkNuKKnjHNVnN6+Fb/H7y0iRIdwHNfeeLz3Xl+rr
         vbJXmwYdB4hKN2MM558O7p4hjglh6k8FUBX/IvfdET1tE2p8/7Gjk6uk8p50aldySkK6
         VKuhRIy4g+j6vcnnlPJekfl3u4zL2Ns0QVwlcmhJ/YILoBFCBwIF26bshgM72tRqOIqE
         hxUvNXESs3HU0UWTjccyx+qgYb6k8iV9J0k3MTBakGTgT2uM7UT35Jqrf6wxOv/WeqLV
         IZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=aCSXGk9NtNmglUVpbUQ1Rjs+YdBMM2XU3YePZpV6vnQ=;
        b=k3C+MRwK1JmHdnVd822yxeBkgH4Rlcf5PUOzzBJWb48jTUienjzFkmer5oFBXl7oCc
         f9kMPM519GyxBk3LU4Ze1cgZKF3W4Q4jML20UwMFymcjCxYz5JU7gAMoHTdljvVACuVH
         8pH6B7klPah56VsRLKo5fmZKdsAbLr9sc1M96KUU48FVJAUD7J4BZzBzvfBEYsCECEOX
         2Q+EtMEcFtTUjI1CWGh2jq9pkxw9E4wcVFUkhbmXzEdOaTkNyU0t6LkFka2N7uDrVCiu
         YKQyvR6/nXAaOmYC/t03lOOGCtoj26OzpkHliBxKc5cm3QMJgokuCQasq33d9sy5iOjN
         1Eww==
X-Gm-Message-State: ACgBeo2GL04KKzKNa1dzYsRQWo/Fcn7QTY4zj7oWuIKgaiuuswRPCFlj
        PK29+hHU7qSL/0am0OKVwhSwtuuxrj33mw==
X-Google-Smtp-Source: AA6agR6S6rfRj/zc3mfjlga4zrGt9A0T25FwyEPhGMSVV9ZoGj3YuGzKeEzbZSewB8Y4MIpq+O8cqA==
X-Received: by 2002:a63:b07:0:b0:429:411a:ff51 with SMTP id 7-20020a630b07000000b00429411aff51mr20162901pgl.207.1661261620081;
        Tue, 23 Aug 2022 06:33:40 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ei23-20020a17090ae55700b001f7a76d6f28sm9963727pjb.18.2022.08.23.06.33.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 06:33:39 -0700 (PDT)
Message-ID: <d2a66100-6660-8f99-a100-0f3c4f80d0ac@kernel.dk>
Date:   Tue, 23 Aug 2022 07:33:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH 3/3] /dev/null: add IORING_OP_URING_CMD support
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Luis Chamberlain <mcgrof@kernel.org>
References: <166120321387.369593.7400426327771894334.stgit@olly>
 <166120327984.369593.8371751426301540450.stgit@olly>
 <YwR41qQs07dYVnqD@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YwR41qQs07dYVnqD@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/23/22 12:51 AM, Greg Kroah-Hartman wrote:
> On Mon, Aug 22, 2022 at 05:21:19PM -0400, Paul Moore wrote:
>> This patch adds support for the io_uring command pass through, aka
>> IORING_OP_URING_CMD, to the /dev/null driver.  As with all of the
>> /dev/null functionality, the implementation is just a simple sink
>> where commands go to die, but it should be useful for developers who
>> need a simple IORING_OP_URING_CMD test device that doesn't require
>> any special hardware.
>>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Paul Moore <paul@paul-moore.com>
>> ---
>>  drivers/char/mem.c |    6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
>> index 84ca98ed1dad..32a932a065a6 100644
>> --- a/drivers/char/mem.c
>> +++ b/drivers/char/mem.c
>> @@ -480,6 +480,11 @@ static ssize_t splice_write_null(struct pipe_inode_info *pipe, struct file *out,
>>  	return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_null);
>>  }
>>  
>> +static int uring_cmd_null(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
>> +{
>> +	return 0;
> 
> If a callback just returns 0, that implies it is not needed at all and
> can be removed and then you are back at the original file before your
> commit :)

In theory you are correct, but the empty hook is needed so that
submitting an io_uring cmd to the file type is attempted. If not it's
just errored upfront.

Paul, is it strictly needed to test the selinux uring cmd policy? If the
operation would've been attempted but null doesn't support it, you'd get
-1/EOPNOTSUPP - and supposedly you'd get EACCES/EPERM or something if
it's filtered?

-- 
Jens Axboe
