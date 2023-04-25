Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE1D6EDA36
	for <lists+io-uring@lfdr.de>; Tue, 25 Apr 2023 04:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbjDYCSG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Apr 2023 22:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjDYCSF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Apr 2023 22:18:05 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CD39EF7
        for <io-uring@vger.kernel.org>; Mon, 24 Apr 2023 19:18:04 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-520de6d3721so654436a12.0
        for <io-uring@vger.kernel.org>; Mon, 24 Apr 2023 19:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682389084; x=1684981084;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3vpAwrHYtHsy8T6Ru3OOid7jQ5wmtBxCpd0M3TCAXSc=;
        b=N3uB2vzQHvd4wo1sFniNMTRORsmJc7rYUcFpXhvczsOvan7OSVDS0aXrPJyY94UPso
         O0mIrSLWoMGUDbzn+L+8nxpVxqB8j2xH3D5RS0B63alOvZx1WMFDP6wg3uIFL48bNK63
         zcrgmXR57yzEg4NaHvg7IGD+UUYMo1834F+dgFPEcx9qckPTPEGRDe7xSxUMTGEUwe/+
         dQLSsUWUdpgjbqiCMbYlU3ZB9YFM4eGCXHD6Oe/mzKulo0+QW4d5qjRBrNpnPFg36edQ
         wan51r3+RF8GlDN5FE+/NFFEhc4rjhOch8L0S0drOIU4Khx5k4SRxxlDegtVYYSSFncU
         h74Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682389084; x=1684981084;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3vpAwrHYtHsy8T6Ru3OOid7jQ5wmtBxCpd0M3TCAXSc=;
        b=iCu+bocq8HHSj8D11YE/Q2KdjflK9l81EEt9OZQIWKj5IaXzfEpRmmpHgkjRSuURth
         tvFzQev7JJq8u13dVVRMtHfkw2ReCp9vWDVyJFEnzxWwIzJE2kGqr1ICvS+7dFkMMXjO
         n7Ad7aNPN7Rs/NBX/tjdk9/YTa9kmdOgxYRK7ccRzIG3Yse1VJXd4Wq7I80itljlFBeS
         9mIqZ7QDht7YZMAuk0yB/vVnwm5N/COUP1Ew3+885/ZpD4+YshNhZEYH0cmfaA1+4oiD
         v3Clw3gtx6wE0O5Lc7RUtYmIB5yTYr9fOE6tbhchyRPkivoQMdNVW3jFgnOvSOvluFxq
         OMww==
X-Gm-Message-State: AAQBX9fYYdqaMjv9oQ7rrkU7/FRAWY6bd4arezwcuXOR38tKvw/R+9Eo
        ex6ptaGloBEGf8pEqpfslV0T2faP3PMnzH32vsY=
X-Google-Smtp-Source: AKy350ak5Jjp58QYb3X8y88UbtGS1KpICW3BJ589Vcfx/vVrm+faVbSF2jrybOzb2nQO23CHDK4elg==
X-Received: by 2002:a17:903:41c6:b0:19e:94ff:6780 with SMTP id u6-20020a17090341c600b0019e94ff6780mr19077407ple.6.1682389083762;
        Mon, 24 Apr 2023 19:18:03 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ix3-20020a170902f80300b0019a96a6543esm7108063plb.184.2023.04.24.19.18.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 19:18:03 -0700 (PDT)
Message-ID: <a1c8d37f-ca21-3648-9a37-741e7519650b@kernel.dk>
Date:   Mon, 24 Apr 2023 20:18:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 4/4] io_uring: mark opcodes that always need io-wq punt
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20230420183135.119618-1-axboe@kernel.dk>
 <20230420183135.119618-5-axboe@kernel.dk>
 <ZEYwAkk7aXKfQKKr@ovpn-8-16.pek2.redhat.com>
 <b5e48439-0427-98a8-3288-99426ae36b45@kernel.dk>
 <ZEclhYPobt94OndL@ovpn-8-24.pek2.redhat.com>
 <478df0f7-c167-76f3-3fd8-9d5771a44048@kernel.dk>
 <ZEc3WttIofAqFy+b@ovpn-8-24.pek2.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZEc3WttIofAqFy+b@ovpn-8-24.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/24/23 8:13?PM, Ming Lei wrote:
> On Mon, Apr 24, 2023 at 08:08:09PM -0600, Jens Axboe wrote:
>> On 4/24/23 6:57?PM, Ming Lei wrote:
>>> On Mon, Apr 24, 2023 at 09:24:33AM -0600, Jens Axboe wrote:
>>>> On 4/24/23 1:30?AM, Ming Lei wrote:
>>>>> On Thu, Apr 20, 2023 at 12:31:35PM -0600, Jens Axboe wrote:
>>>>>> Add an opdef bit for them, and set it for the opcodes where we always
>>>>>> need io-wq punt. With that done, exclude them from the file_can_poll()
>>>>>> check in terms of whether or not we need to punt them if any of the
>>>>>> NO_OFFLOAD flags are set.
>>>>>>
>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>> ---
>>>>>>  io_uring/io_uring.c |  2 +-
>>>>>>  io_uring/opdef.c    | 22 ++++++++++++++++++++--
>>>>>>  io_uring/opdef.h    |  2 ++
>>>>>>  3 files changed, 23 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>> index fee3e461e149..420cfd35ebc6 100644
>>>>>> --- a/io_uring/io_uring.c
>>>>>> +++ b/io_uring/io_uring.c
>>>>>> @@ -1948,7 +1948,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>>>>>>  		return -EBADF;
>>>>>>  
>>>>>>  	if (issue_flags & IO_URING_F_NO_OFFLOAD &&
>>>>>> -	    (!req->file || !file_can_poll(req->file)))
>>>>>> +	    (!req->file || !file_can_poll(req->file) || def->always_iowq))
>>>>>>  		issue_flags &= ~IO_URING_F_NONBLOCK;
>>>>>
>>>>> I guess the check should be !def->always_iowq?
>>>>
>>>> How so? Nobody that takes pollable files should/is setting
>>>> ->always_iowq. If we can poll the file, we should not force inline
>>>> submission. Basically the ones setting ->always_iowq always do -EAGAIN
>>>> returns if nonblock == true.
>>>
>>> I meant IO_URING_F_NONBLOCK is cleared here for  ->always_iowq, and
>>> these OPs won't return -EAGAIN, then run in the current task context
>>> directly.
>>
>> Right, of IO_URING_F_NO_OFFLOAD is set, which is entirely the point of
>> it :-)
> 
> But ->always_iowq isn't actually _always_ since fallocate/fsync/... are
> not punted to iowq in case of IO_URING_F_NO_OFFLOAD, looks the naming of
> ->always_iowq is a bit confusing?

Yeah naming isn't that great, I can see how that's bit confusing. I'll
be happy to take suggestions on what would make it clearer.

-- 
Jens Axboe

