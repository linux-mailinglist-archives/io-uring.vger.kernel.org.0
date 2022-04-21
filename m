Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE98D50A885
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 20:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358393AbiDUS5B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 14:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355560AbiDUS47 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 14:56:59 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0196C4C416
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 11:54:09 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id r12so6299413iod.6
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 11:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=hhQfpMn6wdY/98SpPCBOP2HidocHUdu95O0kT0/zBbc=;
        b=y+pk0ADZTghS55KyrHXMUMNjp/x1YNtDTsDbJnpj4raV0YIouaAWIehJ8uSZb21qSZ
         kh32fGfLuauYqSJAE+OlO+KDbvrEGnBSQeq+VfqqeZMSrezI9SIZtP6CEncO8YF0hJas
         hnt82Hxt0rdS67Pu81gTWoTO391vRTrO0r/Cyyi+0sd0PwXaalmCv5z24MZIxBRSiWIA
         9l/DHZTcSBQChmUVWxdPPHILbxlCSAvNXHZtQBXAkzVpe1CgJjjhBcWy1N8sm03wbEBu
         6NB04DvbjF6qQ7DsWSMlSzPL5GIHb4s9uHq1CD8nBAxgoX579+bgyl/WTTaqvSf6eg9c
         5PEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hhQfpMn6wdY/98SpPCBOP2HidocHUdu95O0kT0/zBbc=;
        b=PwAZb5UxC7+jMUgy3XP8a/H+dIdzuVa/A3ComOmZ/FCZHfPVBctKjIYXtA2J35167A
         Q+rM2JFMvx8jewQbpKbI2R1+rGc0BZzCIjiS+DHYos6CDLyUGGM/Q2A9S8h5vDBStGf+
         ws0JTtCrQbfSYbdEkxsRLyAiQ6lr35EmPT6AMtFTIzBvU8Y59WI3VRMgPWuecRNMQULz
         T6yIELxT+JUTqo3BBYnww6EG784N0zzdTTuluhON/A9DoY3ilLqgOnjO/No3Klph64xu
         9m8M35jQ1Hst/63fFvRFSzuo221vcaZ/50FCTrWQ7QEJVLm3xIuZXdqyn47fsr4d62XS
         Zcgw==
X-Gm-Message-State: AOAM530i+norQEQ5ZnXWkyDi4cOLoYpK25FRnu1QSgiTj4ZKetTWCRvl
        fyRjffcyLOlhDQz7kGGhqPOq8w==
X-Google-Smtp-Source: ABdhPJzTqHwvYO47PAqSiiWTrbzYXXI9c//TQ+m1AGD8v3anqIt/g9WqhYmjEHQdGkGRdpXyNAhTBQ==
X-Received: by 2002:a05:6638:4126:b0:32a:892f:c009 with SMTP id ay38-20020a056638412600b0032a892fc009mr581518jab.26.1650567248363;
        Thu, 21 Apr 2022 11:54:08 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f5-20020a6b5105000000b006572915097asm2834886iob.35.2022.04.21.11.54.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 11:54:07 -0700 (PDT)
Message-ID: <356ea32c-6a12-3d12-1460-ede6b5b20b76@kernel.dk>
Date:   Thu, 21 Apr 2022 12:54:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 00/12] add large CQE support for io-uring
Content-Language: en-US
To:     Stefan Roesch <shr@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>, kernel-team@fb.com,
        io-uring@vger.kernel.org
References: <20220420191451.2904439-1-shr@fb.com>
 <165049508483.559887.15785156729960849643.b4-ty@kernel.dk>
 <5676b135-b159-02c3-21f8-9bf25bd4e2c9@gmail.com>
 <2fa5238c-6617-5053-7661-f2c1a6d70356@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2fa5238c-6617-5053-7661-f2c1a6d70356@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/21/22 12:49 PM, Stefan Roesch wrote:
> 
> 
> On 4/21/22 11:42 AM, Pavel Begunkov wrote:
>> On 4/20/22 23:51, Jens Axboe wrote:
>>> On Wed, 20 Apr 2022 12:14:39 -0700, Stefan Roesch wrote:
>>>> This adds the large CQE support for io-uring. Large CQE's are 16 bytes longer.
>>>> To support the longer CQE's the allocation part is changed and when the CQE is
>>>> accessed.
>>>>
>>>> The allocation of the large CQE's is twice as big, so the allocation size is
>>>> doubled. The ring size calculation needs to take this into account.
>>
>> I'm missing something here, do we have a user for it apart
>> from no-op requests?
>>
> 
> Pavel, what started this work is the patch series "io_uring passthru over nvme" from samsung.
> (https://lore.kernel.org/io-uring/20220308152105.309618-1-joshi.k@samsung.com/)
> 
> They will use the large SQE and CQE support.

Indeed - and as such, this will just be a base for that. Doesn't make
sense standalone, but with the passthrough support it does.

-- 
Jens Axboe

